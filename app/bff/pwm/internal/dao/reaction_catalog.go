package dao

import (
	"context"
	"database/sql"
	"errors"
	"fmt"
	"strconv"
	"strings"

	"github.com/teamgram/marmota/pkg/stores/sqlx"
	"github.com/teamgram/proto/mtproto"
	"pwm-server/app/bff/pwm/internal/dao/dataobject"
)

func (d *Dao) UpsertAvailableReaction(ctx context.Context, in *dataobject.AvailableReactionDO) (uint64, error) {
	const query = `INSERT INTO available_reactions
		(import_id, emoticon, title, inactive, premium, display_order, reaction_hash)
		VALUES (:import_id, :emoticon, :title, :inactive, :premium, :display_order, :reaction_hash)
		ON DUPLICATE KEY UPDATE id = LAST_INSERT_ID(id), import_id = VALUES(import_id), title = VALUES(title),
		 inactive = VALUES(inactive), premium = VALUES(premium), display_order = VALUES(display_order),
		 reaction_hash = VALUES(reaction_hash)`
	r, err := d.db.NamedExec(ctx, query, in)
	if err != nil {
		return 0, err
	}
	id, err := r.LastInsertId()
	return uint64(id), err
}

func (d *Dao) ReplaceAvailableReactionDocuments(ctx context.Context, reactionId uint64, documents []dataobject.AvailableReactionDocumentDO) error {
	return d.db.Transact(ctx, func(tx *sqlx.Tx) error {
		if _, err := tx.Exec("DELETE FROM available_reaction_documents WHERE available_reaction_id = ?", reactionId); err != nil {
			return err
		}
		const query = `INSERT INTO available_reaction_documents
			(available_reaction_id, role, sticker_document_id) VALUES (:available_reaction_id, :role, :sticker_document_id)`
		for i := range documents {
			if _, err := tx.NamedExec(query, &documents[i]); err != nil {
				return err
			}
		}
		return nil
	})
}

func (d *Dao) SelectAvailableReactionCatalog(ctx context.Context, includeInactive bool) ([]dataobject.AvailableReactionDO, error) {
	query := `SELECT id, import_id, emoticon, title, inactive, premium, display_order, reaction_hash
		FROM available_reactions`
	args := make([]interface{}, 0, 1)
	if !includeInactive {
		query += " WHERE inactive = ?"
		args = append(args, false)
	}
	query += " ORDER BY display_order, id"
	rows := make([]dataobject.AvailableReactionDO, 0)
	err := d.db.QueryRowsPartial(ctx, &rows, query, args...)
	return rows, err
}

func (d *Dao) SelectAvailableReactionDocuments(ctx context.Context, reactionId uint64) ([]dataobject.AvailableReactionDocumentDO, error) {
	const query = `SELECT ard.id, ard.available_reaction_id, ard.role, ard.sticker_document_id,
		sd.native_document_id, sd.native_access_hash FROM available_reaction_documents ard
		JOIN sticker_documents sd ON sd.id = ard.sticker_document_id
		WHERE ard.available_reaction_id = ? ORDER BY ard.role`
	rows := make([]dataobject.AvailableReactionDocumentDO, 0)
	err := d.db.QueryRowsPartial(ctx, &rows, query, reactionId)
	return rows, err
}

func (d *Dao) SetDefaultReaction(ctx context.Context, in *dataobject.UserReactionDO) error {
	const query = `INSERT INTO user_default_reaction (user_id, reaction_type, reaction_value)
		VALUES (:user_id, :reaction_type, :reaction_value)
		ON DUPLICATE KEY UPDATE reaction_type = VALUES(reaction_type), reaction_value = VALUES(reaction_value)`
	_, err := d.db.NamedExec(ctx, query, in)
	return err
}

func (d *Dao) SelectDefaultReaction(ctx context.Context, userId int64) (*dataobject.UserReactionDO, error) {
	const query = `SELECT user_id, reaction_type, reaction_value FROM user_default_reaction WHERE user_id = ?`
	row := new(dataobject.UserReactionDO)
	if err := d.db.QueryRowPartial(ctx, row, query, userId); err != nil {
		if errors.Is(err, sqlx.ErrNotFound) || errors.Is(err, sql.ErrNoRows) {
			return nil, nil
		}
		return nil, err
	}
	return row, nil
}

func (d *Dao) RecordRecentReaction(ctx context.Context, in *dataobject.UserReactionDO) error {
	const query = `INSERT INTO user_recent_reactions
		(user_id, reaction_type, reaction_value, usage_count, last_used_at)
		VALUES (:user_id, :reaction_type, :reaction_value, 1, :last_used_at)
		ON DUPLICATE KEY UPDATE usage_count = usage_count + 1, last_used_at = VALUES(last_used_at)`
	_, err := d.db.NamedExec(ctx, query, in)
	return err
}

func (d *Dao) SelectUserRecentReactions(ctx context.Context, userId int64, limit int32) ([]dataobject.UserReactionDO, error) {
	const query = `SELECT user_id, reaction_type, reaction_value, usage_count, last_used_at
		FROM user_recent_reactions WHERE user_id = ? ORDER BY last_used_at DESC, reaction_type, reaction_value LIMIT ?`
	rows := make([]dataobject.UserReactionDO, 0)
	err := d.db.QueryRowsPartial(ctx, &rows, query, userId, limit)
	return rows, err
}

func (d *Dao) SelectUserTopReactions(ctx context.Context, userId int64, limit int32) ([]dataobject.UserReactionDO, error) {
	const query = `SELECT user_id, reaction_type, reaction_value, usage_count, last_used_at
		FROM user_recent_reactions WHERE user_id = ? ORDER BY usage_count DESC, last_used_at DESC,
		reaction_type, reaction_value LIMIT ?`
	rows := make([]dataobject.UserReactionDO, 0)
	err := d.db.QueryRowsPartial(ctx, &rows, query, userId, limit)
	return rows, err
}

func (d *Dao) ClearUserRecentReactions(ctx context.Context, userId int64) error {
	_, err := d.db.Exec(ctx, "DELETE FROM user_recent_reactions WHERE user_id = ?", userId)
	return err
}

func (d *Dao) ValidateReaction(ctx context.Context, reactionType uint8, value string) (bool, error) {
	var exists int
	var err error
	switch reactionType {
	case 1:
		err = d.db.QueryRow(ctx, &exists, "SELECT EXISTS(SELECT 1 FROM available_reactions WHERE emoticon = ? AND inactive = 0 AND premium = 0)", value)
	case 2:
		err = d.db.QueryRow(ctx, &exists, "SELECT EXISTS(SELECT 1 FROM sticker_documents WHERE native_document_id = ? AND document_kind = 2 AND import_state = 3 AND free = 1)", value)
	default:
		return false, nil
	}
	return exists == 1, err
}

func (d *Dao) ReplaceMessageReactions(ctx context.Context, rows []dataobject.MessageReactionDO, userId int64, peerType int32, peerId, dialogMessageId int64) error {
	return d.db.Transact(ctx, func(tx *sqlx.Tx) error {
		if _, err := tx.Exec("DELETE FROM message_reactions WHERE user_id = ? AND peer_type = ? AND peer_id = ? AND dialog_message_id = ?", userId, peerType, peerId, dialogMessageId); err != nil {
			return err
		}
		const query = `INSERT INTO message_reactions
			(user_id, author_user_id, peer_type, peer_id, message_id, dialog_message_id, reaction_type, reaction_value, big, unread, date2)
			VALUES (:user_id, :author_user_id, :peer_type, :peer_id, :message_id, :dialog_message_id, :reaction_type, :reaction_value, :big, :unread, :date2)`
		for i := range rows {
			if _, err := tx.NamedExec(query, &rows[i]); err != nil {
				return err
			}
		}
		return nil
	})
}

func (d *Dao) ListMessageReactions(ctx context.Context, peerType int32, peerId, dialogMessageId int64, filter *dataobject.UserReactionDO, offset string, limit int) (*dataobject.MessageReactionPageDO, error) {
	var cursorDate int32
	var cursorId int64
	if offset != "" {
		parts := strings.Split(offset, ":")
		if len(parts) != 2 {
			return nil, mtproto.ErrOffsetInvalid
		}
		date, dateErr := strconv.ParseInt(parts[0], 10, 32)
		id, idErr := strconv.ParseInt(parts[1], 10, 64)
		if dateErr != nil || idErr != nil || date < 0 || id <= 0 {
			return nil, mtproto.ErrOffsetInvalid
		}
		cursorDate, cursorId = int32(date), id
	}
	where := "peer_type = ? AND peer_id = ? AND dialog_message_id = ?"
	args := []interface{}{peerType, peerId, dialogMessageId}
	if filter != nil {
		where += " AND reaction_type = ? AND reaction_value = ?"
		args = append(args, filter.ReactionType, filter.ReactionValue)
	}
	var count int32
	if err := d.db.QueryRow(ctx, &count, "SELECT COUNT(*) FROM message_reactions WHERE "+where, args...); err != nil {
		return nil, err
	}
	if cursorId > 0 {
		where += " AND (date2 < ? OR (date2 = ? AND id < ?))"
		args = append(args, cursorDate, cursorDate, cursorId)
	}
	args = append(args, limit+1)
	rows := make([]dataobject.MessageReactionDO, 0, limit+1)
	if err := d.db.QueryRowsPartial(ctx, &rows, `SELECT id, user_id, author_user_id, peer_type, peer_id, message_id,
		dialog_message_id, reaction_type, reaction_value, big, unread, date2 FROM message_reactions WHERE `+where+` ORDER BY date2 DESC, id DESC LIMIT ?`, args...); err != nil {
		return nil, err
	}
	next := ""
	if len(rows) > limit {
		rows = rows[:limit]
		last := rows[len(rows)-1]
		next = fmt.Sprintf("%d:%d", last.Date, last.Id)
	}
	return &dataobject.MessageReactionPageDO{Count: count, Reactions: rows, NextOffset: next}, nil
}

func (d *Dao) ReportMessageReaction(ctx context.Context, reporterId, peerId, dialogMessageId, actorId int64, peerType int32) (bool, error) {
	var exists int
	if err := d.db.QueryRow(ctx, &exists, `SELECT EXISTS(SELECT 1 FROM message_reactions
		WHERE peer_type = ? AND peer_id = ? AND dialog_message_id = ? AND user_id = ?)`, peerType, peerId, dialogMessageId, actorId); err != nil {
		return false, err
	}
	if exists == 0 {
		return false, nil
	}
	_, err := d.db.Exec(ctx, `INSERT INTO reaction_reports
		(reporter_user_id, peer_type, peer_id, dialog_message_id, reaction_actor_user_id)
		VALUES (?, ?, ?, ?, ?) ON DUPLICATE KEY UPDATE updated_at = CURRENT_TIMESTAMP`, reporterId, peerType, peerId, dialogMessageId, actorId)
	return true, err
}

func (d *Dao) SetChatReactionSettings(ctx context.Context, userId int64, settings dataobject.ChatReactionSettingsDO) error {
	return d.db.Transact(ctx, func(tx *sqlx.Tx) error {
		var limit interface{}
		if settings.ReactionsLimit != nil {
			limit = *settings.ReactionsLimit
		}
		if _, err := tx.Exec(`INSERT INTO chat_reaction_settings
			(peer_type, peer_id, policy_type, reactions_limit, updated_by_user_id) VALUES (?, ?, ?, ?, ?)
			ON DUPLICATE KEY UPDATE policy_type = VALUES(policy_type), reactions_limit = VALUES(reactions_limit), updated_by_user_id = VALUES(updated_by_user_id)`,
			settings.PeerType, settings.PeerId, settings.PolicyType, limit, userId); err != nil {
			return err
		}
		if _, err := tx.Exec("DELETE FROM chat_available_reactions WHERE peer_type = ? AND peer_id = ?", settings.PeerType, settings.PeerId); err != nil {
			return err
		}
		for i := range settings.Reactions {
			if _, err := tx.Exec(`INSERT INTO chat_available_reactions
				(peer_type, peer_id, reaction_type, reaction_value, order2) VALUES (?, ?, ?, ?, ?)`,
				settings.PeerType, settings.PeerId, settings.Reactions[i].ReactionType, settings.Reactions[i].ReactionValue, i); err != nil {
				return err
			}
		}
		return nil
	})
}

func (d *Dao) ListUnreadReactionMessages(ctx context.Context, userId int64, peerType int32, peerId int64, offsetId, addOffset, limit, minId, maxId int32) (*dataobject.UnreadReactionMessagePageDO, error) {
	where := "user_id = ? AND peer_type = ? AND peer_id = ?"
	args := []interface{}{userId, peerType, peerId}
	if minId > 0 {
		where += " AND message_id > ?"
		args = append(args, minId)
	}
	if maxId > 0 {
		where += " AND message_id < ?"
		args = append(args, maxId)
	}
	var count int32
	if err := d.db.QueryRow(ctx, &count, "SELECT COUNT(*) FROM user_unread_reaction_messages WHERE "+where, args...); err != nil {
		return nil, err
	}
	if offsetId == 0 {
		offsetId = int32(^uint32(0) >> 1)
	}
	rows := make([]struct {
		MessageId int32 `db:"message_id"`
	}, 0, limit)
	queryArgs := append(append([]interface{}{}, args...), offsetId, addOffset, limit)
	if err := d.db.QueryRowsPartial(ctx, &rows, "SELECT message_id FROM user_unread_reaction_messages WHERE "+where+" AND message_id < ? ORDER BY message_id DESC LIMIT ?, ?", queryArgs...); err != nil {
		return nil, err
	}
	ids := make([]int32, len(rows))
	for i := range rows {
		ids[i] = rows[i].MessageId
	}
	return &dataobject.UnreadReactionMessagePageDO{Count: count, MessageIds: ids}, nil
}

func (d *Dao) ClearUnreadReactionMessages(ctx context.Context, userId int64, peerType int32, peerId int64) (int64, error) {
	result, err := d.db.Exec(ctx, "DELETE FROM user_unread_reaction_messages WHERE user_id = ? AND peer_type = ? AND peer_id = ?", userId, peerType, peerId)
	if err != nil {
		return 0, err
	}
	return result.RowsAffected()
}
