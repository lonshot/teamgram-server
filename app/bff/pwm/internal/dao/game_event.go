package dao

import (
	"context"
	"strings"

	"pwm-server/app/bff/pwm/internal/dao/dataobject"
)

func (d *Dao) SelectGamePushDevices(ctx context.Context, userIds []int64) ([]dataobject.GamePushDeviceDO, error) {
	if len(userIds) == 0 {
		return nil, nil
	}
	placeholders := strings.TrimRight(strings.Repeat("?,", len(userIds)), ",")
	args := make([]any, 0, len(userIds)+1)
	args = append(args, int32(2)) // Telegram token type 2 is FCM (Android and APNS through Firebase).
	for _, userId := range userIds {
		args = append(args, userId)
	}
	rows := make([]dataobject.GamePushDeviceDO, 0)
	err := d.db.QueryRowsPartial(ctx, &rows, `SELECT MIN(id) AS id, user_id, token FROM devices
		WHERE token_type = ? AND state = 0 AND token <> '' AND user_id IN (`+placeholders+`)
		GROUP BY user_id, token ORDER BY user_id, id`, args...)
	if err != nil {
		return nil, err
	}
	legacyArgs := make([]any, 0, len(userIds)*2)
	for _, userId := range userIds {
		legacyArgs = append(legacyArgs, userId)
	}
	for _, userId := range userIds {
		legacyArgs = append(legacyArgs, userId)
	}
	legacy := make([]dataobject.GamePushDeviceDO, 0)
	err = d.db.QueryRowsPartial(ctx, &legacy, `SELECT id, id AS user_id, AndroidPushToken AS token FROM users
		WHERE deleted = 0 AND AndroidPushToken IS NOT NULL AND AndroidPushToken <> '' AND id IN (`+placeholders+`)
		UNION ALL SELECT id, id AS user_id, IOSPushToken AS token FROM users
		WHERE deleted = 0 AND IOSPushToken IS NOT NULL AND IOSPushToken <> '' AND id IN (`+placeholders+`)`, legacyArgs...)
	if err != nil {
		return nil, err
	}
	seen := make(map[string]struct{}, len(rows)+len(legacy))
	for _, row := range rows {
		seen[row.Token] = struct{}{}
	}
	for _, row := range legacy {
		if _, ok := seen[row.Token]; ok {
			continue
		}
		seen[row.Token] = struct{}{}
		rows = append(rows, row)
	}
	return rows, nil
}

func (d *Dao) DisableGamePushDevice(ctx context.Context, userId int64, token string) error {
	if _, err := d.db.Exec(ctx, `UPDATE devices SET state = 1
		WHERE user_id = ? AND token = ? AND token_type = 2 AND state = 0`, userId, token); err != nil {
		return err
	}
	_, err := d.db.Exec(ctx, `UPDATE users SET
		AndroidPushToken = IF(AndroidPushToken = ?, NULL, AndroidPushToken),
		IOSPushToken = IF(IOSPushToken = ?, NULL, IOSPushToken)
		WHERE id = ?`, token, token, userId)
	return err
}

func (d *Dao) SelectGameEvents(ctx context.Context, userId int64, afterId uint64, limit int) ([]dataobject.GameEventDO, error) {
	if limit <= 0 || limit > 500 {
		limit = 100
	}
	rows := make([]dataobject.GameEventDO, 0, limit)
	const query = `SELECT id, event_id, command_id, recipient_user_id, event_type, aggregate_type,
		aggregate_id, payload, created_at FROM game_events
		WHERE recipient_user_id = ? AND id > ? ORDER BY id LIMIT ?`
	err := d.db.QueryRowsPartial(ctx, &rows, query, userId, afterId, limit)
	return rows, err
}

func (d *Dao) ClaimGameOutbox(ctx context.Context, owner string, limit, leaseSeconds int) ([]dataobject.GameOutboxDO, error) {
	if limit <= 0 || limit > 100 {
		limit = 16
	}
	if leaseSeconds <= 0 {
		leaseSeconds = 30
	}
	_, err := d.db.Exec(ctx, `UPDATE game_outbox SET lease_owner = ?,
		lease_until = DATE_ADD(CURRENT_TIMESTAMP, INTERVAL ? SECOND)
		WHERE published_at IS NULL AND available_at <= CURRENT_TIMESTAMP
		AND (lease_until IS NULL OR lease_until < CURRENT_TIMESTAMP)
		ORDER BY available_at, id LIMIT ?`, owner, leaseSeconds, limit)
	if err != nil {
		return nil, err
	}
	rows := make([]dataobject.GameOutboxDO, 0, limit)
	err = d.db.QueryRowsPartial(ctx, &rows, `SELECT id, event_id, command_id, event_type, payload, attempt_count
		FROM game_outbox WHERE lease_owner = ? AND lease_until >= CURRENT_TIMESTAMP
		AND published_at IS NULL ORDER BY id`, owner)
	return rows, err
}

func (d *Dao) MarkGameOutboxPublished(ctx context.Context, id uint64, owner string) (bool, error) {
	result, err := d.db.Exec(ctx, `UPDATE game_outbox SET published_at = CURRENT_TIMESTAMP,
		lease_owner = '', lease_until = NULL, last_error = ''
		WHERE id = ? AND lease_owner = ? AND published_at IS NULL`, id, owner)
	if err != nil {
		return false, err
	}
	updated, err := result.RowsAffected()
	return updated == 1, err
}

func (d *Dao) MarkGameOutboxFailed(ctx context.Context, id uint64, owner, failure string) error {
	if len(failure) > 2048 {
		failure = failure[:2048]
	}
	_, err := d.db.Exec(ctx, `UPDATE game_outbox SET attempt_count = attempt_count + 1,
		available_at = DATE_ADD(CURRENT_TIMESTAMP, INTERVAL LEAST(300, POW(2, LEAST(attempt_count, 8))) SECOND),
		lease_owner = '', lease_until = NULL, last_error = ?
		WHERE id = ? AND lease_owner = ? AND published_at IS NULL`, failure, id, owner)
	return err
}
