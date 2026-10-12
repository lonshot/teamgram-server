package dataobject

type SavedGifDO struct {
	UserID     int64 `db:"user_id"`
	DocumentID int64 `db:"document_id"`
	AccessHash int64 `db:"access_hash"`
	SavedAt    int32 `db:"saved_at"`
}
