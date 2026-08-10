package service

import (
	"testing"

	"github.com/stretchr/testify/require"
	"pwm-server/app/bff/pwm/internal/dao/dataobject"
)

func TestBuildEmojiKeywordsDeterministicGrouping(t *testing.T) {
	rows := []dataobject.EmojiKeywordDO{
		{Keyword: "cat", Emoticon: "cat1"},
		{Keyword: "cat", Emoticon: "cat2"},
		{Keyword: "dog", Emoticon: "dog1"},
	}

	keywords := buildEmojiKeywords(rows)
	require.Len(t, keywords, 2)
	require.Equal(t, "cat", keywords[0].GetKeyword())
	require.Equal(t, []string{"cat1", "cat2"}, keywords[0].GetEmoticons())
	require.Equal(t, "dog", keywords[1].GetKeyword())
}

func TestSelectEmojiLanguagesPreservesRequestedOrder(t *testing.T) {
	require.Equal(t, []string{"vi", "en"}, selectEmojiLanguages([]string{"en", "he", "vi"}, []string{"vi", "missing", "en", "vi"}))
}

func TestEmojiDocumentIdsHashIsOrderSensitive(t *testing.T) {
	require.NotEqual(t, emojiDocumentIdsHash([]int64{1, 2}), emojiDocumentIdsHash([]int64{2, 1}))
}
