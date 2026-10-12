package dao

import (
	"context"

	"pwm-server/app/bff/pwm/internal/dao/dataobject"
)

func (d *Dao) SetSavedGif(
	ctx context.Context,
	userID int64,
	documentID int64,
	accessHash int64,
	savedAt int32,
	saved bool,
) error {
	if !saved {
		_, err := d.db.Exec(ctx, "DELETE FROM user_saved_gifs WHERE user_id = ? AND document_id = ?", userID, documentID)
		return err
	}
	const query = `INSERT INTO user_saved_gifs (user_id, document_id, access_hash, saved_at)
		VALUES (?, ?, ?, ?) ON DUPLICATE KEY UPDATE access_hash = VALUES(access_hash), saved_at = VALUES(saved_at)`
	_, err := d.db.Exec(ctx, query, userID, documentID, accessHash, savedAt)
	return err
}

func (d *Dao) SelectSavedGifs(ctx context.Context, userID int64, limit int32) ([]dataobject.SavedGifDO, error) {
	if limit <= 0 || limit > 200 {
		limit = 200
	}
	const query = `SELECT user_id, document_id, access_hash, saved_at
		FROM user_saved_gifs WHERE user_id = ? ORDER BY saved_at DESC, id DESC LIMIT ?`
	rows := make([]dataobject.SavedGifDO, 0)
	err := d.db.QueryRowsPartial(ctx, &rows, query, userID, limit)
	return rows, err
}
