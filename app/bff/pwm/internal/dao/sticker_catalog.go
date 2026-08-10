package dao

import (
	"context"
	"database/sql"
	"errors"
	"fmt"
	"strings"

	"github.com/teamgram/marmota/pkg/stores/sqlx"
	"github.com/teamgram/proto/mtproto"
	"pwm-server/app/bff/pwm/internal/dao/dataobject"
)

func (d *Dao) UpsertStickerImport(ctx context.Context, in *dataobject.StickerImportDO) (uint64, error) {
	const query = `INSERT INTO sticker_imports
		(dataset_version, dataset_checksum, source_root, state, total_sets, total_documents,
		 imported_documents, skipped_documents, failed_documents, last_error)
		VALUES (:dataset_version, :dataset_checksum, :source_root, :state, :total_sets, :total_documents,
		 :imported_documents, :skipped_documents, :failed_documents, :last_error)
		ON DUPLICATE KEY UPDATE id = LAST_INSERT_ID(id), source_root = VALUES(source_root),
		 state = VALUES(state), total_sets = VALUES(total_sets), total_documents = VALUES(total_documents),
		 imported_documents = VALUES(imported_documents), skipped_documents = VALUES(skipped_documents),
		 failed_documents = VALUES(failed_documents), last_error = VALUES(last_error)`
	r, err := d.db.NamedExec(ctx, query, in)
	if err != nil {
		return 0, err
	}
	id, err := r.LastInsertId()
	return uint64(id), err
}

func (d *Dao) SelectStickerImport(ctx context.Context, datasetVersion string, checksum []byte) (*dataobject.StickerImportDO, error) {
	const query = `SELECT id, dataset_version, dataset_checksum, source_root, state, total_sets,
		total_documents, imported_documents, skipped_documents, failed_documents, last_error,
		started_at, completed_at FROM sticker_imports WHERE dataset_version = ? AND dataset_checksum = ?`
	row := new(dataobject.StickerImportDO)
	if err := d.db.QueryRowPartial(ctx, row, query, datasetVersion, checksum); err != nil {
		if errors.Is(err, sqlx.ErrNotFound) || errors.Is(err, sql.ErrNoRows) {
			return nil, nil
		}
		return nil, err
	}
	return row, nil
}

func (d *Dao) UpsertStickerSet(ctx context.Context, in *dataobject.StickerSetDO) (uint64, error) {
	const query = `INSERT INTO sticker_sets
		(import_id, source_set_id, source_access_hash, native_set_id, native_access_hash, owner_user_id,
		 short_name, short_name_normalized, title, set_hash, document_count, display_order, archived,
		 official, masks, emojis, animated, videos, text_color, thumb_document_id, thumb_access_hash,
		 thumb_dc_id, thumb_version, import_state, last_error)
		VALUES (:import_id, :source_set_id, :source_access_hash, :native_set_id, :native_access_hash,
		 :owner_user_id, :short_name, :short_name_normalized, :title, :set_hash, :document_count,
		 :display_order, :archived, :official, :masks, :emojis, :animated, :videos, :text_color,
		 :thumb_document_id, :thumb_access_hash, :thumb_dc_id, :thumb_version, :import_state, :last_error)
		ON DUPLICATE KEY UPDATE id = LAST_INSERT_ID(id), import_id = VALUES(import_id),
		 source_access_hash = VALUES(source_access_hash), native_set_id = VALUES(native_set_id),
		 native_access_hash = VALUES(native_access_hash), owner_user_id = VALUES(owner_user_id),
		 short_name = VALUES(short_name), short_name_normalized = VALUES(short_name_normalized),
		 title = VALUES(title), set_hash = VALUES(set_hash), document_count = VALUES(document_count),
		 display_order = VALUES(display_order), archived = VALUES(archived), official = VALUES(official),
		 masks = VALUES(masks), emojis = VALUES(emojis), animated = VALUES(animated), videos = VALUES(videos),
		 text_color = VALUES(text_color), thumb_document_id = VALUES(thumb_document_id),
		 thumb_access_hash = VALUES(thumb_access_hash), thumb_dc_id = VALUES(thumb_dc_id),
		 thumb_version = VALUES(thumb_version), import_state = VALUES(import_state), last_error = VALUES(last_error)`
	r, err := d.db.NamedExec(ctx, query, in)
	if err != nil {
		return 0, err
	}
	id, err := r.LastInsertId()
	return uint64(id), err
}

func (d *Dao) SelectStickerSetByNativeId(ctx context.Context, nativeSetId int64) (*dataobject.StickerSetDO, error) {
	return d.selectStickerSet(ctx, "native_set_id = ?", nativeSetId)
}

func (d *Dao) ResolveStickerSet(ctx context.Context, input *mtproto.InputStickerSet) (*dataobject.StickerSetDO, error) {
	if input == nil {
		return nil, mtproto.ErrStickersetInvalid
	}
	var set *dataobject.StickerSetDO
	var err error
	switch input.GetPredicateName() {
	case mtproto.Predicate_inputStickerSetID:
		if input.GetId() <= 0 || input.GetAccessHash() == 0 {
			return nil, mtproto.ErrStickerIdInvalid
		}
		set, err = d.SelectStickerSetByNativeId(ctx, input.GetId())
		if err == nil && (set == nil || set.NativeAccessHash != input.GetAccessHash()) {
			return nil, mtproto.ErrStickerIdInvalid
		}
	case mtproto.Predicate_inputStickerSetShortName:
		name := strings.ToLower(strings.TrimSpace(input.GetShortName()))
		if name == "" {
			return nil, mtproto.ErrStickersetInvalid
		}
		set, err = d.SelectStickerSetByShortName(ctx, name)
		if err == nil && set == nil {
			return nil, mtproto.ErrStickerIdInvalid
		}
	default:
		return nil, mtproto.ErrStickersetInvalid
	}
	return set, err
}

func (d *Dao) SelectStickerSetByShortName(ctx context.Context, normalized string) (*dataobject.StickerSetDO, error) {
	return d.selectStickerSet(ctx, "short_name_normalized = ?", normalized)
}

func (d *Dao) selectStickerSet(ctx context.Context, predicate string, arg interface{}) (*dataobject.StickerSetDO, error) {
	query := `SELECT id, import_id, source_set_id, source_access_hash, native_set_id, native_access_hash,
		owner_user_id, short_name, short_name_normalized, title, set_hash, document_count, display_order,
		archived, official, masks, emojis, animated, videos, text_color, thumb_document_id,
		thumb_access_hash, thumb_dc_id, thumb_version, import_state, last_error FROM sticker_sets WHERE ` + predicate
	row := new(dataobject.StickerSetDO)
	if err := d.db.QueryRowPartial(ctx, row, query, arg); err != nil {
		if errors.Is(err, sqlx.ErrNotFound) || errors.Is(err, sql.ErrNoRows) {
			return nil, nil
		}
		return nil, err
	}
	return row, nil
}

func (d *Dao) SelectStickerSets(ctx context.Context, emojis, archived bool, offset, limit int32) ([]dataobject.StickerSetDO, error) {
	const query = `SELECT id, import_id, source_set_id, source_access_hash, native_set_id, native_access_hash,
		owner_user_id, short_name, short_name_normalized, title, set_hash, document_count, display_order,
		archived, official, masks, emojis, animated, videos, text_color, thumb_document_id,
		thumb_access_hash, thumb_dc_id, thumb_version, import_state, last_error
		FROM sticker_sets WHERE emojis = ? AND archived = ? ORDER BY display_order, id LIMIT ? OFFSET ?`
	rows := make([]dataobject.StickerSetDO, 0)
	err := d.db.QueryRowsPartial(ctx, &rows, query, emojis, archived, limit, offset)
	return rows, err
}

func (d *Dao) UpsertStickerDocument(ctx context.Context, in *dataobject.StickerDocumentDO) (uint64, error) {
	const query = `INSERT INTO sticker_documents
		(import_id, sticker_set_id, source_document_id, native_document_id, native_access_hash, owner_user_id,
		 document_kind, source_path, source_size, source_checksum, preview_source_path, preview_source_size,
		 preview_source_checksum, mime_type, file_name, width, height, date2, free, text_color,
		 import_state, attempt_count, last_error)
		VALUES (:import_id, :sticker_set_id, :source_document_id, :native_document_id, :native_access_hash,
		 :owner_user_id, :document_kind, :source_path, :source_size, :source_checksum, :preview_source_path,
		 :preview_source_size, :preview_source_checksum, :mime_type, :file_name, :width, :height, :date2,
		 :free, :text_color, :import_state, :attempt_count, :last_error)
		ON DUPLICATE KEY UPDATE id = LAST_INSERT_ID(id), sticker_set_id = VALUES(sticker_set_id),
		 native_document_id = VALUES(native_document_id), native_access_hash = VALUES(native_access_hash),
		 source_path = VALUES(source_path), source_size = VALUES(source_size), source_checksum = VALUES(source_checksum),
		 preview_source_path = VALUES(preview_source_path), preview_source_size = VALUES(preview_source_size),
		 preview_source_checksum = VALUES(preview_source_checksum), mime_type = VALUES(mime_type),
		 file_name = VALUES(file_name), width = VALUES(width), height = VALUES(height), date2 = VALUES(date2),
		 free = VALUES(free), text_color = VALUES(text_color), import_state = VALUES(import_state),
		 attempt_count = VALUES(attempt_count), last_error = VALUES(last_error)`
	r, err := d.db.NamedExec(ctx, query, in)
	if err != nil {
		return 0, err
	}
	id, err := r.LastInsertId()
	return uint64(id), err
}

func (d *Dao) SelectStickerDocumentsBySet(ctx context.Context, stickerSetId uint64) ([]dataobject.StickerDocumentDO, error) {
	const query = `SELECT id, import_id, sticker_set_id, source_document_id, native_document_id,
		native_access_hash, owner_user_id, document_kind, source_path, source_size, source_checksum,
		preview_source_path, preview_source_size, preview_source_checksum, mime_type, file_name, width,
		height, date2, free, text_color, import_state, attempt_count, last_error
		FROM sticker_documents WHERE sticker_set_id = ? ORDER BY id`
	rows := make([]dataobject.StickerDocumentDO, 0)
	err := d.db.QueryRowsPartial(ctx, &rows, query, stickerSetId)
	return rows, err
}

func (d *Dao) SelectStickerDocumentViewsBySet(ctx context.Context, stickerSetId uint64) ([]dataobject.StickerDocumentViewDO, error) {
	const query = `SELECT d.id, d.import_id, d.sticker_set_id, d.source_document_id, d.native_document_id,
		d.native_access_hash, d.owner_user_id, d.document_kind, d.source_path, d.source_size, d.source_checksum,
		d.preview_source_path, d.preview_source_size, d.preview_source_checksum, d.mime_type, d.file_name,
		d.width, d.height, d.date2, d.free, d.text_color, d.import_state, d.attempt_count, d.last_error,
		p.emoticon, p.keywords, p.order2 FROM sticker_packs p JOIN sticker_documents d
		ON d.id = p.sticker_document_id WHERE p.sticker_set_id = ? AND d.import_state = 3
		ORDER BY p.order2, p.id`
	rows := make([]dataobject.StickerDocumentViewDO, 0)
	err := d.db.QueryRowsPartial(ctx, &rows, query, stickerSetId)
	return rows, err
}

func (d *Dao) ResolveStickerDocument(ctx context.Context, input *mtproto.InputDocument) (*dataobject.StickerDocumentDO, error) {
	if input == nil || input.GetPredicateName() != mtproto.Predicate_inputDocument || input.GetId() <= 0 || input.GetAccessHash() == 0 {
		return nil, mtproto.ErrStickerDocumentInvalid
	}
	const query = `SELECT id, import_id, sticker_set_id, source_document_id, native_document_id,
		native_access_hash, owner_user_id, document_kind, source_path, source_size, source_checksum,
		preview_source_path, preview_source_size, preview_source_checksum, mime_type, file_name, width,
		height, date2, free, text_color, import_state, attempt_count, last_error
		FROM sticker_documents WHERE native_document_id = ? AND native_access_hash = ? AND document_kind = 1 AND import_state = 3`
	row := new(dataobject.StickerDocumentDO)
	if err := d.db.QueryRowPartial(ctx, row, query, input.GetId(), input.GetAccessHash()); err != nil {
		if errors.Is(err, sqlx.ErrNotFound) || errors.Is(err, sql.ErrNoRows) {
			return nil, mtproto.ErrStickerDocumentInvalid
		}
		return nil, err
	}
	return row, nil
}

func (d *Dao) ReplaceStickerPacks(ctx context.Context, stickerSetId uint64, packs []dataobject.StickerPackDO) error {
	return d.db.Transact(ctx, func(tx *sqlx.Tx) error {
		if _, err := tx.Exec("DELETE FROM sticker_packs WHERE sticker_set_id = ?", stickerSetId); err != nil {
			return err
		}
		const query = `INSERT INTO sticker_packs
			(sticker_set_id, emoticon, sticker_document_id, order2, mask_n, mask_x, mask_y, mask_zoom, keywords)
			VALUES (:sticker_set_id, :emoticon, :sticker_document_id, :order2, :mask_n, :mask_x, :mask_y, :mask_zoom, :keywords)`
		for i := range packs {
			if _, err := tx.NamedExec(query, &packs[i]); err != nil {
				return err
			}
		}
		return nil
	})
}

func (d *Dao) SelectStickerDocumentsByEmoticon(ctx context.Context, emoticon string, limit int32) ([]dataobject.StickerDocumentDO, error) {
	const query = `SELECT d.id, d.import_id, d.sticker_set_id, d.source_document_id, d.native_document_id,
		d.native_access_hash, d.owner_user_id, d.document_kind, d.source_path, d.source_size,
		d.source_checksum, d.preview_source_path, d.preview_source_size, d.preview_source_checksum,
		d.mime_type, d.file_name, d.width, d.height, d.date2, d.free, d.text_color, d.import_state,
		d.attempt_count, d.last_error FROM sticker_packs p JOIN sticker_documents d
		ON d.id = p.sticker_document_id WHERE p.emoticon = ? ORDER BY p.order2, p.id LIMIT ?`
	rows := make([]dataobject.StickerDocumentDO, 0)
	err := d.db.QueryRowsPartial(ctx, &rows, query, emoticon, limit)
	return rows, err
}

func (d *Dao) UpsertUserStickerSet(ctx context.Context, in *dataobject.UserStickerSetDO) error {
	const query = `INSERT INTO user_sticker_sets
		(user_id, sticker_set_id, category, archived, order2, installed_at)
		VALUES (:user_id, :sticker_set_id, :category, :archived, :order2, :installed_at)
		ON DUPLICATE KEY UPDATE archived = VALUES(archived), order2 = VALUES(order2), installed_at = VALUES(installed_at)`
	_, err := d.db.NamedExec(ctx, query, in)
	return err
}

func (d *Dao) DeleteUserStickerSet(ctx context.Context, userId int64, category uint8, stickerSetId uint64) error {
	_, err := d.db.Exec(ctx, "DELETE FROM user_sticker_sets WHERE user_id = ? AND category = ? AND sticker_set_id = ?", userId, category, stickerSetId)
	return err
}

func (d *Dao) SelectUserStickerSets(ctx context.Context, userId int64, category uint8, archived bool) ([]dataobject.UserStickerSetDO, error) {
	const query = `SELECT id, user_id, sticker_set_id, category, archived, order2, installed_at
		FROM user_sticker_sets WHERE user_id = ? AND category = ? AND archived = ? ORDER BY order2, id`
	rows := make([]dataobject.UserStickerSetDO, 0)
	err := d.db.QueryRowsPartial(ctx, &rows, query, userId, category, archived)
	return rows, err
}

func (d *Dao) SelectInstalledStickerSets(ctx context.Context, userId int64, category uint8) ([]dataobject.StickerSetDO, error) {
	const query = `SELECT s.id, s.import_id, s.source_set_id, s.source_access_hash, s.native_set_id, s.native_access_hash,
		s.owner_user_id, s.short_name, s.short_name_normalized, s.title, s.set_hash, s.document_count, s.display_order,
		s.archived, s.official, s.masks, s.emojis, s.animated, s.videos, s.text_color, s.thumb_document_id,
		s.thumb_access_hash, s.thumb_dc_id, s.thumb_version, s.import_state, s.last_error
		FROM user_sticker_sets u JOIN sticker_sets s ON s.id = u.sticker_set_id
		WHERE u.user_id = ? AND u.category = ? AND u.archived = 0 AND s.import_state = 2 ORDER BY u.order2, u.id`
	rows := make([]dataobject.StickerSetDO, 0)
	err := d.db.QueryRowsPartial(ctx, &rows, query, userId, category)
	return rows, err
}

func (d *Dao) InstallStickerSet(ctx context.Context, userId int64, setId uint64, category uint8, archived bool, installedAt int32) error {
	const query = `INSERT INTO user_sticker_sets (user_id, sticker_set_id, category, archived, order2, installed_at)
		SELECT ?, ?, ?, ?, COALESCE(MAX(order2), 0) + 1, ? FROM user_sticker_sets WHERE user_id = ? AND category = ?
		ON DUPLICATE KEY UPDATE archived = VALUES(archived), installed_at = VALUES(installed_at)`
	_, err := d.db.Exec(ctx, query, userId, setId, category, archived, installedAt, userId, category)
	return err
}

func (d *Dao) ReorderStickerSets(ctx context.Context, userId int64, category uint8, nativeIds []int64) error {
	return d.db.Transact(ctx, func(tx *sqlx.Tx) error {
		const selectQuery = `SELECT s.native_set_id FROM user_sticker_sets u JOIN sticker_sets s ON s.id = u.sticker_set_id
			WHERE u.user_id = ? AND u.category = ? AND u.archived = 0 FOR UPDATE`
		var installed []int64
		if err := tx.QueryRowsPartial(&installed, selectQuery, userId, category); err != nil {
			return err
		}
		if len(installed) != len(nativeIds) {
			return mtproto.ErrStickersetInvalid
		}
		valid := make(map[int64]struct{}, len(installed))
		for _, id := range installed {
			valid[id] = struct{}{}
		}
		seen := make(map[int64]struct{}, len(nativeIds))
		for order, id := range nativeIds {
			if _, ok := valid[id]; !ok {
				return mtproto.ErrStickersetInvalid
			}
			if _, ok := seen[id]; ok {
				return mtproto.ErrStickersetInvalid
			}
			seen[id] = struct{}{}
			if _, err := tx.Exec(`UPDATE user_sticker_sets u JOIN sticker_sets s ON s.id = u.sticker_set_id
				SET u.order2 = ? WHERE u.user_id = ? AND u.category = ? AND u.archived = 0 AND s.native_set_id = ?`, order, userId, category, id); err != nil {
				return err
			}
		}
		return nil
	})
}

func (d *Dao) SaveRecentSticker(ctx context.Context, userId int64, documentId uint64, attached bool, usedAt int32) error {
	const query = `INSERT INTO user_recent_stickers (user_id, sticker_document_id, attached, used_at)
		VALUES (?, ?, ?, ?) ON DUPLICATE KEY UPDATE used_at = VALUES(used_at)`
	_, err := d.db.Exec(ctx, query, userId, documentId, attached, usedAt)
	return err
}

func (d *Dao) SelectRecentStickers(ctx context.Context, userId int64, attached bool, limit int32) ([]dataobject.UserStickerDO, error) {
	const query = `SELECT id, user_id, sticker_document_id, attached, used_at
		FROM user_recent_stickers WHERE user_id = ? AND attached = ? ORDER BY used_at DESC, id DESC LIMIT ?`
	rows := make([]dataobject.UserStickerDO, 0)
	err := d.db.QueryRowsPartial(ctx, &rows, query, userId, attached, limit)
	return rows, err
}

func (d *Dao) SelectRecentStickerDocuments(ctx context.Context, userId int64, attached bool, limit int32) ([]dataobject.SavedStickerDocumentDO, error) {
	if limit <= 0 || limit > 200 {
		limit = 200
	}
	const query = `SELECT d.id, d.import_id, d.sticker_set_id, d.source_document_id, d.native_document_id,
		d.native_access_hash, d.owner_user_id, d.document_kind, d.source_path, d.source_size, d.source_checksum,
		d.preview_source_path, d.preview_source_size, d.preview_source_checksum, d.mime_type, d.file_name, d.width,
		d.height, d.date2, d.free, d.text_color, d.import_state, d.attempt_count, d.last_error,
		COALESCE((SELECT p.emoticon FROM sticker_packs p WHERE p.sticker_document_id = d.id ORDER BY p.order2, p.id LIMIT 1), '') emoticon,
		'' keywords, 0 order2, u.used_at saved_at FROM user_recent_stickers u JOIN sticker_documents d ON d.id = u.sticker_document_id
		WHERE u.user_id = ? AND u.attached = ? AND d.document_kind = 1 AND d.import_state = 3 ORDER BY u.used_at DESC, u.id DESC LIMIT ?`
	rows := make([]dataobject.SavedStickerDocumentDO, 0)
	err := d.db.QueryRowsPartial(ctx, &rows, query, userId, attached, limit)
	return rows, err
}

func (d *Dao) ClearRecentStickers(ctx context.Context, userId int64, attached bool) error {
	_, err := d.db.Exec(ctx, "DELETE FROM user_recent_stickers WHERE user_id = ? AND attached = ?", userId, attached)
	return err
}

func (d *Dao) SetFavedSticker(ctx context.Context, userId int64, documentId uint64, favedAt int32, faved bool) error {
	if !faved {
		_, err := d.db.Exec(ctx, "DELETE FROM user_faved_stickers WHERE user_id = ? AND sticker_document_id = ?", userId, documentId)
		return err
	}
	const query = `INSERT INTO user_faved_stickers (user_id, sticker_document_id, faved_at)
		VALUES (?, ?, ?) ON DUPLICATE KEY UPDATE faved_at = VALUES(faved_at)`
	_, err := d.db.Exec(ctx, query, userId, documentId, favedAt)
	return err
}

func (d *Dao) DeleteRecentSticker(ctx context.Context, userId int64, documentId uint64, attached bool) error {
	_, err := d.db.Exec(ctx, `DELETE FROM user_recent_stickers WHERE user_id = ? AND sticker_document_id = ? AND attached = ?`, userId, documentId, attached)
	return err
}

func (d *Dao) SelectFavedStickerDocuments(ctx context.Context, userId int64, limit int32) ([]dataobject.SavedStickerDocumentDO, error) {
	if limit <= 0 || limit > 100 {
		limit = 5
	}
	const query = `SELECT d.id, d.import_id, d.sticker_set_id, d.source_document_id, d.native_document_id,
		d.native_access_hash, d.owner_user_id, d.document_kind, d.source_path, d.source_size, d.source_checksum,
		d.preview_source_path, d.preview_source_size, d.preview_source_checksum, d.mime_type, d.file_name, d.width,
		d.height, d.date2, d.free, d.text_color, d.import_state, d.attempt_count, d.last_error,
		COALESCE((SELECT p.emoticon FROM sticker_packs p WHERE p.sticker_document_id = d.id ORDER BY p.order2, p.id LIMIT 1), '') emoticon,
		'' keywords, 0 order2, u.faved_at saved_at FROM user_faved_stickers u JOIN sticker_documents d ON d.id = u.sticker_document_id
		WHERE u.user_id = ? AND d.document_kind = 1 AND d.import_state = 3 ORDER BY u.faved_at DESC, u.id DESC LIMIT ?`
	rows := make([]dataobject.SavedStickerDocumentDO, 0)
	err := d.db.QueryRowsPartial(ctx, &rows, query, userId, limit)
	return rows, err
}

func (d *Dao) SelectFeaturedStickerSets(ctx context.Context, userId int64, category uint8) ([]dataobject.FeaturedStickerSetDO, error) {
	const query = `SELECT s.id, s.import_id, s.source_set_id, s.source_access_hash, s.native_set_id, s.native_access_hash,
		s.owner_user_id, s.short_name, s.short_name_normalized, s.title, s.set_hash, s.document_count, s.display_order,
		s.archived, s.official, s.masks, s.emojis, s.animated, s.videos, s.text_color, s.thumb_document_id,
		s.thumb_access_hash, s.thumb_dc_id, s.thumb_version, s.import_state, s.last_error, (r.id IS NULL) unread
		FROM featured_sticker_sets f JOIN sticker_sets s ON s.id = f.sticker_set_id
		LEFT JOIN user_featured_sticker_reads r ON r.sticker_set_id = s.id AND r.user_id = ?
		WHERE f.category = ? AND s.import_state = 2 ORDER BY f.display_order, f.id`
	rows := make([]dataobject.FeaturedStickerSetDO, 0)
	err := d.db.QueryRowsPartial(ctx, &rows, query, userId, category)
	return rows, err
}

func (d *Dao) SelectArchivedStickerSets(ctx context.Context, userId int64, category uint8, offsetId int64, limit int32) ([]dataobject.CoveredStickerSetDO, int32, error) {
	if limit <= 0 || limit > 100 {
		limit = 100
	}
	var count int32
	if err := d.db.QueryRowPartial(ctx, &count, `SELECT COUNT(*) FROM user_sticker_sets WHERE user_id = ? AND category = ? AND archived = 1`, userId, category); err != nil {
		return nil, 0, err
	}
	const query = `SELECT s.id, s.import_id, s.source_set_id, s.source_access_hash, s.native_set_id, s.native_access_hash,
		s.owner_user_id, s.short_name, s.short_name_normalized, s.title, s.set_hash, s.document_count, s.display_order,
		s.archived, s.official, s.masks, s.emojis, s.animated, s.videos, s.text_color, s.thumb_document_id,
		s.thumb_access_hash, s.thumb_dc_id, s.thumb_version, s.import_state, s.last_error,
		COALESCE((SELECT d.native_document_id FROM sticker_packs p JOIN sticker_documents d ON d.id = p.sticker_document_id
		 WHERE p.sticker_set_id = s.id AND d.import_state = 3 ORDER BY p.order2, p.id LIMIT 1), 0) cover_document_id
		FROM user_sticker_sets u JOIN sticker_sets s ON s.id = u.sticker_set_id
		WHERE u.user_id = ? AND u.category = ? AND u.archived = 1 AND s.import_state = 2 AND (? = 0 OR s.native_set_id < ?)
		ORDER BY s.native_set_id DESC, u.id DESC LIMIT ?`
	rows := make([]dataobject.CoveredStickerSetDO, 0)
	err := d.db.QueryRowsPartial(ctx, &rows, query, userId, category, offsetId, offsetId, limit)
	return rows, count, err
}

func (d *Dao) SearchStickerSets(ctx context.Context, query string, excludeFeatured bool, limit int32) ([]dataobject.CoveredStickerSetDO, error) {
	query = strings.TrimSpace(query)
	if query == "" {
		return []dataobject.CoveredStickerSetDO{}, nil
	}
	if limit <= 0 || limit > 100 {
		limit = 100
	}
	like := "%" + query + "%"
	const sqlQuery = `SELECT s.id, s.import_id, s.source_set_id, s.source_access_hash, s.native_set_id, s.native_access_hash,
		s.owner_user_id, s.short_name, s.short_name_normalized, s.title, s.set_hash, s.document_count, s.display_order,
		s.archived, s.official, s.masks, s.emojis, s.animated, s.videos, s.text_color, s.thumb_document_id,
		s.thumb_access_hash, s.thumb_dc_id, s.thumb_version, s.import_state, s.last_error,
		COALESCE((SELECT d.native_document_id FROM sticker_packs p JOIN sticker_documents d ON d.id = p.sticker_document_id
		 WHERE p.sticker_set_id = s.id AND d.import_state = 3 ORDER BY p.order2, p.id LIMIT 1), 0) cover_document_id
		FROM sticker_sets s WHERE s.import_state = 2 AND s.archived = 0 AND s.masks = 0 AND s.emojis = 0
		AND (s.short_name_normalized LIKE LOWER(?) OR s.title LIKE ?)
		AND (? = 0 OR NOT EXISTS (SELECT 1 FROM featured_sticker_sets f WHERE f.sticker_set_id = s.id AND f.category = 1))
		ORDER BY (s.short_name_normalized = LOWER(?)) DESC, s.display_order, s.id LIMIT ?`
	rows := make([]dataobject.CoveredStickerSetDO, 0)
	err := d.db.QueryRowsPartial(ctx, &rows, sqlQuery, like, like, excludeFeatured, query, limit)
	return rows, err
}

func (d *Dao) StickerSetIdsByNativeIds(ctx context.Context, nativeIds []int64) ([]uint64, error) {
	ids := make([]uint64, 0, len(nativeIds))
	for _, nativeId := range nativeIds {
		set, err := d.SelectStickerSetByNativeId(ctx, nativeId)
		if err != nil {
			return nil, err
		}
		if set == nil {
			continue
		}
		ids = append(ids, set.Id)
	}
	return ids, nil
}

func (d *Dao) DeleteStickerSetForUser(ctx context.Context, userId int64, setId uint64) error {
	_, err := d.db.Exec(ctx, `DELETE FROM user_sticker_sets WHERE user_id = ? AND sticker_set_id = ?`, userId, setId)
	return err
}

var _ = fmt.Sprintf

func (d *Dao) SelectFavedStickers(ctx context.Context, userId int64, limit int32) ([]dataobject.UserStickerDO, error) {
	const query = `SELECT id, user_id, sticker_document_id, faved_at
		FROM user_faved_stickers WHERE user_id = ? ORDER BY faved_at DESC, id DESC LIMIT ?`
	rows := make([]dataobject.UserStickerDO, 0)
	err := d.db.QueryRowsPartial(ctx, &rows, query, userId, limit)
	return rows, err
}

func (d *Dao) MarkFeaturedStickerSetsRead(ctx context.Context, userId int64, stickerSetIds []uint64, readAt int32) error {
	return d.db.Transact(ctx, func(tx *sqlx.Tx) error {
		const query = `INSERT INTO user_featured_sticker_reads (user_id, sticker_set_id, read_at)
			VALUES (?, ?, ?) ON DUPLICATE KEY UPDATE read_at = VALUES(read_at)`
		for _, stickerSetId := range stickerSetIds {
			if _, err := tx.Exec(query, userId, stickerSetId, readAt); err != nil {
				return err
			}
		}
		return nil
	})
}
