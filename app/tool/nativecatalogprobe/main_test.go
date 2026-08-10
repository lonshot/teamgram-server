package main

import (
	"testing"

	"github.com/stretchr/testify/require"
	"github.com/teamgram/proto/mtproto"
)

func TestParseOptions(t *testing.T) {
	tests := []struct {
		name string
		args []string
		err  string
	}{
		{name: "valid", args: []string{"-endpoint", "pwm:2010", "-user-id", "42"}},
		{name: "missing endpoint", args: []string{"-user-id", "42"}, err: "-endpoint is required"},
		{name: "invalid user", args: []string{"-endpoint", "pwm:2010", "-user-id", "0"}, err: "-user-id must be greater than zero"},
		{name: "partial sticker set", args: []string{"-endpoint", "pwm:2010", "-user-id", "42", "-sticker-set-id", "7"}, err: "must be provided together"},
		{name: "orphan document access hash", args: []string{"-endpoint", "pwm:2010", "-user-id", "42", "-document-access-hash", "8"}, err: "requires -document-id"},
		{name: "invalid timeout", args: []string{"-endpoint", "pwm:2010", "-user-id", "42", "-timeout", "0s"}, err: "-timeout must be greater than zero"},
	}
	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			_, err := parseOptions(tt.args)
			if tt.err == "" {
				require.NoError(t, err)
				return
			}
			require.ErrorContains(t, err, tt.err)
		})
	}
}

func TestResultValidation(t *testing.T) {
	validDocument := func(id int64) *mtproto.Document {
		return &mtproto.Document{Constructor: mtproto.CRC32_document_1e87342b, Id: id, AccessHash: 2, FileReference: []byte{1}, MimeType: "application/x-tgsticker", Size2_INT64: 3, DcId: 4}
	}

	t.Run("all stickers rejects empty", func(t *testing.T) {
		err := validateAllStickers(&mtproto.Messages_AllStickers{Constructor: mtproto.CRC32_messages_allStickers})
		require.ErrorContains(t, err, "empty")
	})
	t.Run("sticker set accepts hydrated documents", func(t *testing.T) {
		result := &mtproto.Messages_StickerSet{Constructor: mtproto.CRC32_messages_stickerSet_b60a24a6, Set: &mtproto.StickerSet{Id: 7}, Documents: []*mtproto.Document{validDocument(9)}}
		require.NoError(t, validateStickerSet(result, 7))
	})
	t.Run("reactions reject missing media", func(t *testing.T) {
		result := &mtproto.Messages_AvailableReactions{Constructor: mtproto.CRC32_messages_availableReactions, Reactions: []*mtproto.AvailableReaction{{Reaction: "ok"}}}
		require.ErrorContains(t, validateAvailableReactions(result), "hydrated document")
	})
	t.Run("keywords reject empty result", func(t *testing.T) {
		result := &mtproto.EmojiKeywordsDifference{Constructor: mtproto.CRC32_emojiKeywordsDifference, LangCode: "en", Version: 1}
		require.ErrorContains(t, validateEmojiKeywords(result, "en"), "empty")
	})
	t.Run("custom emoji verifies identity and access hash", func(t *testing.T) {
		result := &mtproto.Vector_Document{Datas: []*mtproto.Document{validDocument(9)}}
		require.NoError(t, validateCustomEmojiDocuments(result, 9, 2))
		require.ErrorContains(t, validateCustomEmojiDocuments(result, 10, 2), "identity")
		require.ErrorContains(t, validateCustomEmojiDocuments(result, 9, 3), "access hash")
	})
}
