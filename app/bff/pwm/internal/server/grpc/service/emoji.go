package service

import (
	"context"
	"github.com/teamgram/proto/mtproto"
	"github.com/zeromicro/go-zero/core/jsonx"
	"io/ioutil"
)

type EmojiKeywords struct {
	Language string              `json:"language"`
	Version  int                 `json:"version"`
	Keywords map[string][]string `json:"keywords"`
}

func (s Service) MessagesGetEmojiKeywords(ctx context.Context, keywords *mtproto.TLMessagesGetEmojiKeywords) (*mtproto.EmojiKeywordsDifference, error) {
	// Load emoji keywords from JSON file
	emojiKeywords, err := loadEmojiKeywords("assets/emoji/emojiKeywords.json")
	if err != nil {
		return nil, err
	}

	// Retrieve keywords for the specified language
	langKeywords := emojiKeywords.Keywords

	// Convert keywords to MTProto format
	mtprotoKeywords := convertToMTProtoEmojiKeywords(langKeywords)

	// Create EmojiKeywordsDifference
	diff := mtproto.MakeTLEmojiKeywordsDifference(&mtproto.EmojiKeywordsDifference{
		Keywords: mtprotoKeywords,
	}).To_EmojiKeywordsDifference()

	return diff, nil
}

func (s Service) MessagesGetEmojiKeywordsDifference(ctx context.Context, difference *mtproto.TLMessagesGetEmojiKeywordsDifference) (*mtproto.EmojiKeywordsDifference, error) {

	// For static files, there's no difference
	return mtproto.MakeTLEmojiKeywordsDifference(&mtproto.EmojiKeywordsDifference{
		PredicateName: "emojiKeywordsDifference",
		LangCode:      difference.LangCode,
		FromVersion:   difference.FromVersion,
		Version:       1,
		Keywords:      []*mtproto.EmojiKeyword{},
	}).To_EmojiKeywordsDifference(), nil
}

func (s Service) MessagesGetEmojiKeywordsLanguages(ctx context.Context, languages *mtproto.TLMessagesGetEmojiKeywordsLanguages) (*mtproto.Vector_EmojiLanguage, error) {
	// Create a Vector_EmojiLanguage object
	mtprotoEmojiLanguages := &mtproto.Vector_EmojiLanguage{
		Datas: []*mtproto.EmojiLanguage{
			{
				LangCode: "en",
			},
			{
				LangCode: "he",
			},
			{
				LangCode: "vi",
			},
			// ... (add other languages)
		},
	}

	return mtprotoEmojiLanguages, nil
}

func (s Service) MessagesGetEmojiURL(ctx context.Context, url *mtproto.TLMessagesGetEmojiURL) (*mtproto.EmojiURL, error) {
	//TODO implement me
	// For now, return an empty EmojiURL
	return &mtproto.EmojiURL{}, nil
}

func convertToMTProtoEmojiKeywords(langKeywords map[string][]string) []*mtproto.EmojiKeyword {
	mtprotoKeywords := make([]*mtproto.EmojiKeyword, 0, len(langKeywords))
	for key, emojis := range langKeywords {
		mtprotoKeyword := &mtproto.EmojiKeyword{
			Keyword:   key,
			Emoticons: emojis,
		}
		mtprotoKeywords = append(mtprotoKeywords, mtprotoKeyword)
	}
	return mtprotoKeywords
}
func loadEmojiKeywords(filePath string) (*EmojiKeywords, error) {
	// Read the JSON file
	fileBytes, err := ioutil.ReadFile(filePath)
	if err != nil {
		return nil, err
	}

	// Parse the JSON data
	var emojiKeywords EmojiKeywords
	err = jsonx.Unmarshal(fileBytes, &emojiKeywords)
	if err != nil {
		return nil, err
	}

	return &emojiKeywords, nil
}
