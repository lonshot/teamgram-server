package pwm

import "encoding/json"

const (
	MIMETypeTGS  = "application/x-tgsticker"
	MIMETypeWebP = "image/webp"
	MIMETypeWebM = "video/webm"
)

type Dataset struct {
	Root          string
	Version       string
	Sets          []StickerSetFile
	Reactions     []Reaction
	EmojiKeywords EmojiKeywords
	Featured      FeaturedStickers
	Auxiliary     map[string]json.RawMessage
	Report        Report
}

type Report struct {
	SetFiles               int   `json:"set_files"`
	StickerSets            int   `json:"sticker_sets"`
	StickerDocuments       int   `json:"sticker_documents"`
	ReactionDocuments      int   `json:"reaction_documents"`
	UniqueDocuments        int   `json:"unique_documents"`
	AvailableReactions     int   `json:"available_reactions"`
	EmojiKeywords          int   `json:"emoji_keywords"`
	FeaturedSets           int   `json:"featured_sets"`
	UnsupportedVideos      int   `json:"unsupported_videos"`
	StickerPreviews        int   `json:"sticker_previews"`
	ReactionPreviews       int   `json:"reaction_previews"`
	PathThumbnails         int   `json:"path_thumbnails"`
	MissingPreviews        int   `json:"missing_previews"`
	ReferencedAssetBytes   int64 `json:"referenced_asset_bytes"`
	ReferencedPreviewBytes int64 `json:"referenced_preview_bytes"`
}

type StickerSetFile struct {
	SourcePath string       `json:"-"`
	Set        StickerSet   `json:"set"`
	Stickers   []StickerDoc `json:"stickers"`
}

type StickerSet struct {
	IsArchived   bool   `json:"isArchived"`
	IsEmoji      bool   `json:"isEmoji"`
	ID           string `json:"id"`
	AccessHash   string `json:"accessHash"`
	Title        string `json:"title"`
	HasThumbnail bool   `json:"hasThumbnail"`
	Count        int32  `json:"count"`
	ShortName    string `json:"shortName"`

	SourceID         int64 `json:"-"`
	SourceAccessHash int64 `json:"-"`
}

type StickerSetInfo struct {
	ID         string `json:"id"`
	AccessHash string `json:"accessHash"`
}

type MediaSize struct {
	Width  int32 `json:"width"`
	Height int32 `json:"height"`
}

// Thumbnail is the low-cost PhotoPathSize representation emitted by the
// Telegram client which produced the PWM JSON. PathBytes is reconstructed
// losslessly from DataURI during preflight so the native importer can persist
// a real photoPathSize instead of inventing a preview/document protocol.
type Thumbnail struct {
	DataURI string `json:"dataUri"`
	Width   int32  `json:"width"`
	Height  int32  `json:"height"`

	PathBytes []byte `json:"-"`
}

type StickerDoc struct {
	MediaType          string         `json:"mediaType"`
	ID                 string         `json:"id"`
	StickerSetInfo     StickerSetInfo `json:"stickerSetInfo"`
	Emoji              string         `json:"emoji"`
	IsCustomEmoji      bool           `json:"isCustomEmoji"`
	IsLottie           bool           `json:"isLottie"`
	IsVideo            bool           `json:"isVideo"`
	Width              int32          `json:"width"`
	Height             int32          `json:"height"`
	Size               int64          `json:"size"`
	MimeType           string         `json:"mimeType"`
	Timestamp          int32          `json:"timestamp"`
	FileName           string         `json:"fileName"`
	IsFree             bool           `json:"isFree"`
	ShouldUseTextColor bool           `json:"shouldUseTextColor"`
	Thumbnail          *Thumbnail     `json:"thumbnail"`

	SourceID    int64  `json:"-"`
	SourcePath  string `json:"-"`
	SourceSize  int64  `json:"-"`
	PreviewPath string `json:"-"`
	PreviewSize int64  `json:"-"`
}

type ReactionDocument struct {
	MediaType string     `json:"mediaType"`
	ID        string     `json:"id"`
	Size      int64      `json:"size"`
	MimeType  string     `json:"mimeType"`
	Timestamp int32      `json:"timestamp"`
	FileName  string     `json:"fileName"`
	MediaSize MediaSize  `json:"mediaSize"`
	Thumbnail *Thumbnail `json:"thumbnail"`

	SourceID    int64  `json:"-"`
	SourcePath  string `json:"-"`
	SourceSize  int64  `json:"-"`
	PreviewPath string `json:"-"`
	PreviewSize int64  `json:"-"`
}

type ReactionID struct {
	Emoticon string `json:"emoticon"`
}

type Reaction struct {
	Inactive          bool             `json:"isInactive"`
	Premium           bool             `json:"isPremium"`
	Reaction          ReactionID       `json:"reaction"`
	Title             string           `json:"title"`
	StaticIcon        ReactionDocument `json:"staticIcon"`
	AppearAnimation   ReactionDocument `json:"appearAnimation"`
	SelectAnimation   ReactionDocument `json:"selectAnimation"`
	ActivateAnimation ReactionDocument `json:"activateAnimation"`
	EffectAnimation   ReactionDocument `json:"effectAnimation"`
	AroundAnimation   ReactionDocument `json:"aroundAnimation"`
	CenterIcon        ReactionDocument `json:"centerIcon"`
}

func (r *Reaction) Documents() []*ReactionDocument {
	return []*ReactionDocument{
		&r.StaticIcon,
		&r.AppearAnimation,
		&r.SelectAnimation,
		&r.ActivateAnimation,
		&r.EffectAnimation,
		&r.AroundAnimation,
		&r.CenterIcon,
	}
}

type EmojiKeywords struct {
	Language string              `json:"language"`
	Version  int32               `json:"version"`
	Keywords map[string][]string `json:"keywords"`
}

type FeaturedStickers struct {
	Hash      string               `json:"hash"`
	IsPremium bool                 `json:"isPremium"`
	Sets      []FeaturedStickerSet `json:"sets"`
}

type FeaturedStickerSet struct {
	ID       string          `json:"id"`
	Covers   []FeaturedCover `json:"covers"`
	SourceID int64           `json:"-"`
}

type FeaturedCover struct {
	ID       string `json:"id"`
	SourceID int64  `json:"-"`
}
