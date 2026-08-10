package dataobject

type StickerImportDO struct {
	Id                uint64  `db:"id"`
	DatasetVersion    string  `db:"dataset_version"`
	DatasetChecksum   []byte  `db:"dataset_checksum"`
	SourceRoot        string  `db:"source_root"`
	State             uint8   `db:"state"`
	TotalSets         uint32  `db:"total_sets"`
	TotalDocuments    uint32  `db:"total_documents"`
	ImportedDocuments uint32  `db:"imported_documents"`
	SkippedDocuments  uint32  `db:"skipped_documents"`
	FailedDocuments   uint32  `db:"failed_documents"`
	LastError         string  `db:"last_error"`
	StartedAt         *string `db:"started_at"`
	CompletedAt       *string `db:"completed_at"`
}

type StickerSetDO struct {
	Id                  uint64 `db:"id"`
	ImportId            uint64 `db:"import_id"`
	SourceSetId         int64  `db:"source_set_id"`
	SourceAccessHash    int64  `db:"source_access_hash"`
	NativeSetId         int64  `db:"native_set_id"`
	NativeAccessHash    int64  `db:"native_access_hash"`
	OwnerUserId         int64  `db:"owner_user_id"`
	ShortName           string `db:"short_name"`
	ShortNameNormalized string `db:"short_name_normalized"`
	Title               string `db:"title"`
	SetHash             int64  `db:"set_hash"`
	DocumentCount       uint32 `db:"document_count"`
	DisplayOrder        uint32 `db:"display_order"`
	Archived            bool   `db:"archived"`
	Official            bool   `db:"official"`
	Masks               bool   `db:"masks"`
	Emojis              bool   `db:"emojis"`
	Animated            bool   `db:"animated"`
	Videos              bool   `db:"videos"`
	TextColor           bool   `db:"text_color"`
	ThumbDocumentId     int64  `db:"thumb_document_id"`
	ThumbAccessHash     int64  `db:"thumb_access_hash"`
	ThumbDcId           int32  `db:"thumb_dc_id"`
	ThumbVersion        int32  `db:"thumb_version"`
	ImportState         uint8  `db:"import_state"`
	LastError           string `db:"last_error"`
}

type StickerDocumentDO struct {
	Id                    uint64 `db:"id"`
	ImportId              uint64 `db:"import_id"`
	StickerSetId          uint64 `db:"sticker_set_id"`
	SourceDocumentId      int64  `db:"source_document_id"`
	NativeDocumentId      int64  `db:"native_document_id"`
	NativeAccessHash      int64  `db:"native_access_hash"`
	OwnerUserId           int64  `db:"owner_user_id"`
	DocumentKind          uint8  `db:"document_kind"`
	SourcePath            string `db:"source_path"`
	SourceSize            uint64 `db:"source_size"`
	SourceChecksum        []byte `db:"source_checksum"`
	PreviewSourcePath     string `db:"preview_source_path"`
	PreviewSourceSize     uint64 `db:"preview_source_size"`
	PreviewSourceChecksum []byte `db:"preview_source_checksum"`
	MimeType              string `db:"mime_type"`
	FileName              string `db:"file_name"`
	Width                 uint32 `db:"width"`
	Height                uint32 `db:"height"`
	Date2                 int32  `db:"date2"`
	Free                  bool   `db:"free"`
	TextColor             bool   `db:"text_color"`
	ImportState           uint8  `db:"import_state"`
	AttemptCount          uint32 `db:"attempt_count"`
	LastError             string `db:"last_error"`
}

type StickerPackDO struct {
	Id                uint64   `db:"id"`
	StickerSetId      uint64   `db:"sticker_set_id"`
	Emoticon          string   `db:"emoticon"`
	StickerDocumentId uint64   `db:"sticker_document_id"`
	Order2            uint32   `db:"order2"`
	MaskN             *int32   `db:"mask_n"`
	MaskX             *float64 `db:"mask_x"`
	MaskY             *float64 `db:"mask_y"`
	MaskZoom          *float64 `db:"mask_zoom"`
	Keywords          string   `db:"keywords"`
}

type UserStickerSetDO struct {
	Id           uint64 `db:"id"`
	UserId       int64  `db:"user_id"`
	StickerSetId uint64 `db:"sticker_set_id"`
	Category     uint8  `db:"category"`
	Archived     bool   `db:"archived"`
	Order2       uint32 `db:"order2"`
	InstalledAt  int32  `db:"installed_at"`
}

type UserStickerDO struct {
	Id                uint64 `db:"id"`
	UserId            int64  `db:"user_id"`
	StickerDocumentId uint64 `db:"sticker_document_id"`
	Attached          bool   `db:"attached"`
	UsedAt            int32  `db:"used_at"`
	FavedAt           int32  `db:"faved_at"`
}

type StickerDocumentViewDO struct {
	StickerDocumentDO
	Emoticon string `db:"emoticon"`
	Keywords string `db:"keywords"`
	Order2   uint32 `db:"order2"`
}

type SavedStickerDocumentDO struct {
	StickerDocumentViewDO
	SavedAt int32 `db:"saved_at"`
}

type FeaturedStickerSetDO struct {
	StickerSetDO
	Unread bool `db:"unread"`
}

type CoveredStickerSetDO struct {
	StickerSetDO
	CoverDocumentId int64 `db:"cover_document_id"`
}

type EmojiKeywordDO struct {
	LanguageCode string `db:"language_code"`
	Version      uint32 `db:"version"`
	Keyword      string `db:"keyword"`
	Emoticon     string `db:"emoticon"`
	Order2       uint32 `db:"order2"`
}
