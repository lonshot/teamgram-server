package dao

import (
	"context"

	"pwm-server/app/bff/pwm/internal/dao/dataobject"
)

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
