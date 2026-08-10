package dataobject

type AvailableReactionDO struct {
	Id           uint64 `db:"id"`
	ImportId     uint64 `db:"import_id"`
	Emoticon     string `db:"emoticon"`
	Title        string `db:"title"`
	Inactive     bool   `db:"inactive"`
	Premium      bool   `db:"premium"`
	DisplayOrder uint32 `db:"display_order"`
	ReactionHash int64  `db:"reaction_hash"`
}

type AvailableReactionDocumentDO struct {
	Id                       uint64 `db:"id"`
	AvailableReactionId      uint64 `db:"available_reaction_id"`
	Role                     uint8  `db:"role"`
	StickerDocumentId        uint64 `db:"sticker_document_id"`
	NativeDocumentId         int64  `db:"native_document_id"`
	NativeDocumentAccessHash int64  `db:"native_access_hash"`
}

type UserReactionDO struct {
	UserId        int64  `db:"user_id"`
	ReactionType  uint8  `db:"reaction_type"`
	ReactionValue string `db:"reaction_value"`
	UsageCount    uint64 `db:"usage_count"`
	LastUsedAt    int32  `db:"last_used_at"`
}
