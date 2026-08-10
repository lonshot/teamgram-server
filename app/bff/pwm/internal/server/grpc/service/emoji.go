package service

import (
	"context"
	"strings"

	"github.com/teamgram/proto/mtproto"
	"pwm-server/app/bff/pwm/internal/dao/dataobject"
)

func (s Service) MessagesGetEmojiKeywords(ctx context.Context, keywords *mtproto.TLMessagesGetEmojiKeywords) (*mtproto.EmojiKeywordsDifference, error) {
	if keywords == nil {
		return nil, mtproto.ErrLangCodeInvalid
	}
	return s.emojiKeywordsDifference(ctx, strings.TrimSpace(keywords.GetLangCode()), 0)
}

func (s Service) MessagesGetEmojiKeywordsDifference(ctx context.Context, difference *mtproto.TLMessagesGetEmojiKeywordsDifference) (*mtproto.EmojiKeywordsDifference, error) {
	if difference == nil || difference.GetFromVersion() < 0 {
		return nil, mtproto.ErrLangCodeInvalid
	}
	return s.emojiKeywordsDifference(ctx, strings.TrimSpace(difference.GetLangCode()), difference.GetFromVersion())
}

func (s Service) MessagesGetEmojiKeywordsLanguages(ctx context.Context, languages *mtproto.TLMessagesGetEmojiKeywordsLanguages) (*mtproto.Vector_EmojiLanguage, error) {
	available, err := s.svcCtx.SelectEmojiKeywordLanguages(ctx)
	if err != nil {
		return nil, err
	}
	requested := []string(nil)
	if languages != nil {
		requested = languages.GetLangCodes()
	}
	selected := selectEmojiLanguages(available, requested)
	result := &mtproto.Vector_EmojiLanguage{Datas: make([]*mtproto.EmojiLanguage, 0, len(selected))}
	for _, language := range selected {
		result.Datas = append(result.Datas, mtproto.MakeTLEmojiLanguage(&mtproto.EmojiLanguage{LangCode: language}).To_EmojiLanguage())
	}
	return result, nil
}

func (s Service) MessagesGetEmojiURL(ctx context.Context, url *mtproto.TLMessagesGetEmojiURL) (*mtproto.EmojiURL, error) {
	//TODO implement me
	// For now, return an empty EmojiURL
	return &mtproto.EmojiURL{}, nil
}

func (s Service) emojiKeywordsDifference(ctx context.Context, languageCode string, fromVersion int32) (*mtproto.EmojiKeywordsDifference, error) {
	if languageCode == "" || len(languageCode) > 16 {
		return nil, mtproto.ErrLangCodeInvalid
	}
	version, err := s.svcCtx.SelectEmojiKeywordVersion(ctx, languageCode)
	if err != nil {
		return nil, err
	}
	rows, err := s.svcCtx.SelectEmojiKeywords(ctx, languageCode, fromVersion, version)
	if err != nil {
		return nil, err
	}
	return mtproto.MakeTLEmojiKeywordsDifference(&mtproto.EmojiKeywordsDifference{
		LangCode: languageCode, FromVersion: fromVersion, Version: version, Keywords: buildEmojiKeywords(rows),
	}).To_EmojiKeywordsDifference(), nil
}

func buildEmojiKeywords(rows []dataobject.EmojiKeywordDO) []*mtproto.EmojiKeyword {
	result := make([]*mtproto.EmojiKeyword, 0)
	for _, row := range rows {
		if len(result) == 0 || result[len(result)-1].GetKeyword() != row.Keyword {
			result = append(result, mtproto.MakeTLEmojiKeyword(&mtproto.EmojiKeyword{Keyword: row.Keyword, Emoticons: []string{row.Emoticon}}).To_EmojiKeyword())
			continue
		}
		result[len(result)-1].Emoticons = append(result[len(result)-1].Emoticons, row.Emoticon)
	}
	return result
}

func selectEmojiLanguages(available, requested []string) []string {
	if len(requested) == 0 {
		return available
	}
	known := make(map[string]struct{}, len(available))
	for _, language := range available {
		known[language] = struct{}{}
	}
	selected := make([]string, 0, len(requested))
	seen := make(map[string]struct{}, len(requested))
	for _, language := range requested {
		language = strings.TrimSpace(language)
		if _, ok := known[language]; !ok {
			continue
		}
		if _, ok := seen[language]; ok {
			continue
		}
		seen[language] = struct{}{}
		selected = append(selected, language)
	}
	return selected
}
