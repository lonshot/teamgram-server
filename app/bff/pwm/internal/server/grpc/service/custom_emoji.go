package service

import (
	"context"
	"strings"

	"github.com/teamgram/proto/mtproto"
)

const customEmojiDocumentLimit = 200

func (s Service) MessagesGetCustomEmojiDocuments(ctx context.Context, in *mtproto.TLMessagesGetCustomEmojiDocuments) (*mtproto.Vector_Document, error) {
	if _, err := stickerUserId(ctx); err != nil {
		return nil, err
	}
	if in == nil || len(in.GetDocumentId()) > customEmojiDocumentLimit {
		return nil, mtproto.ErrStickerDocumentInvalid
	}
	ids, err := s.svcCtx.SelectCustomEmojiDocumentIds(ctx, in.GetDocumentId())
	if err != nil {
		return nil, err
	}
	documents, err := s.loadStickerDocuments(ctx, ids)
	if err != nil {
		return nil, err
	}
	return &mtproto.Vector_Document{Datas: documents}, nil
}

func (s Service) MessagesGetFeaturedEmojiStickers(ctx context.Context, in *mtproto.TLMessagesGetFeaturedEmojiStickers) (*mtproto.Messages_FeaturedStickers, error) {
	userId, err := stickerUserId(ctx)
	if err != nil {
		return nil, err
	}
	sets, err := s.svcCtx.SelectFeaturedStickerSets(ctx, userId, stickerCategoryEmoji)
	if err != nil {
		return nil, err
	}
	hash := featuredStickerSetsHash(sets)
	if in != nil && in.GetHash() != 0 && in.GetHash() == hash {
		return mtproto.MakeTLMessagesFeaturedStickersNotModified(&mtproto.Messages_FeaturedStickers{}).To_Messages_FeaturedStickers(), nil
	}
	covered := make([]*mtproto.StickerSetCovered, 0, len(sets))
	unread := make([]int64, 0)
	for i := range sets {
		covered = append(covered, mtproto.MakeTLStickerSetNoCovered(&mtproto.StickerSetCovered{Set: buildStickerSet(&sets[i].StickerSetDO)}).To_StickerSetCovered())
		if sets[i].Unread {
			unread = append(unread, sets[i].NativeSetId)
		}
	}
	return mtproto.MakeTLMessagesFeaturedStickers(&mtproto.Messages_FeaturedStickers{Count: int32(len(sets)), Hash: hash, Sets: covered, Unread: unread}).To_Messages_FeaturedStickers(), nil
}

func (s Service) MessagesSearchCustomEmoji(ctx context.Context, in *mtproto.TLMessagesSearchCustomEmoji) (*mtproto.EmojiList, error) {
	if _, err := stickerUserId(ctx); err != nil {
		return nil, err
	}
	if in == nil || len(in.GetEmoticon()) > 64 {
		return nil, mtproto.ErrEmoticonInvalid
	}
	ids, err := s.svcCtx.SearchCustomEmojiDocumentIds(ctx, strings.TrimSpace(in.GetEmoticon()), customEmojiDocumentLimit)
	if err != nil {
		return nil, err
	}
	hash := emojiDocumentIdsHash(ids)
	if in.GetHash() != 0 && in.GetHash() == hash {
		return mtproto.MakeTLEmojiListNotModified(&mtproto.EmojiList{}).To_EmojiList(), nil
	}
	return mtproto.MakeTLEmojiList(&mtproto.EmojiList{Hash: hash, DocumentId: ids}).To_EmojiList(), nil
}

func (s Service) AccountGetDefaultProfilePhotoEmojis(ctx context.Context, in *mtproto.TLAccountGetDefaultProfilePhotoEmojis) (*mtproto.EmojiList, error) {
	return s.emptyDefaultEmojiList(ctx, in != nil && in.GetHash() == 0)
}

func (s Service) AccountGetDefaultGroupPhotoEmojis(ctx context.Context, in *mtproto.TLAccountGetDefaultGroupPhotoEmojis) (*mtproto.EmojiList, error) {
	return s.emptyDefaultEmojiList(ctx, in != nil && in.GetHash() == 0)
}

func (s Service) emptyDefaultEmojiList(ctx context.Context, full bool) (*mtproto.EmojiList, error) {
	if _, err := stickerUserId(ctx); err != nil {
		return nil, err
	}
	if !full {
		return mtproto.MakeTLEmojiListNotModified(&mtproto.EmojiList{}).To_EmojiList(), nil
	}
	return mtproto.MakeTLEmojiList(&mtproto.EmojiList{DocumentId: []int64{}}).To_EmojiList(), nil
}

func emojiDocumentIdsHash(ids []int64) int64 {
	var hash int64
	for _, id := range ids {
		hash = opaqueStickerHash(hash, id)
	}
	return hash
}
