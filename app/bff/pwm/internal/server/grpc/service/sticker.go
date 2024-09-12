package service

import (
	"context"
	"github.com/teamgram/proto/mtproto"
)

func (s Service) MessagesGetStickers(
	ctx context.Context, stickers *mtproto.TLMessagesGetStickers,
) (*mtproto.Messages_Stickers, error) {
	//TODO implement me
	panic("implement me")
}

func (s Service) MessagesGetAllStickers(
	ctx context.Context, stickers *mtproto.TLMessagesGetAllStickers,
) (*mtproto.Messages_AllStickers, error) {
	//TODO implement me
	panic("implement me")
}

func (s Service) MessagesGetStickerSet(
	ctx context.Context, set *mtproto.TLMessagesGetStickerSet,
) (*mtproto.Messages_StickerSet, error) {
	//TODO implement me
	panic("implement me")
}

func (s Service) MessagesInstallStickerSet(
	ctx context.Context, set *mtproto.TLMessagesInstallStickerSet,
) (*mtproto.Messages_StickerSetInstallResult, error) {
	//TODO implement me
	panic("implement me")
}

func (s Service) MessagesUninstallStickerSet(
	ctx context.Context, set *mtproto.TLMessagesUninstallStickerSet,
) (*mtproto.Bool, error) {
	//TODO implement me
	panic("implement me")
}

func (s Service) MessagesReorderStickerSets(
	ctx context.Context, sets *mtproto.TLMessagesReorderStickerSets,
) (*mtproto.Bool, error) {
	//TODO implement me
	panic("implement me")
}

func (s Service) MessagesGetFeaturedStickers(
	ctx context.Context, stickers *mtproto.TLMessagesGetFeaturedStickers,
) (*mtproto.Messages_FeaturedStickers, error) {
	//TODO implement me
	panic("implement me")
}

func (s Service) MessagesReadFeaturedStickers(
	ctx context.Context, stickers *mtproto.TLMessagesReadFeaturedStickers,
) (*mtproto.Bool, error) {
	//TODO implement me
	panic("implement me")
}

func (s Service) MessagesGetRecentStickers(
	ctx context.Context, stickers *mtproto.TLMessagesGetRecentStickers,
) (*mtproto.Messages_RecentStickers, error) {
	//TODO implement me
	panic("implement me")
}

func (s Service) MessagesSaveRecentSticker(
	ctx context.Context, sticker *mtproto.TLMessagesSaveRecentSticker,
) (*mtproto.Bool, error) {
	//TODO implement me
	panic("implement me")
}

func (s Service) MessagesClearRecentStickers(
	ctx context.Context, stickers *mtproto.TLMessagesClearRecentStickers,
) (*mtproto.Bool, error) {
	//TODO implement me
	panic("implement me")
}

func (s Service) MessagesGetArchivedStickers(
	ctx context.Context, stickers *mtproto.TLMessagesGetArchivedStickers,
) (*mtproto.Messages_ArchivedStickers, error) {
	//TODO implement me
	panic("implement me")
}

func (s Service) MessagesGetMaskStickers(
	ctx context.Context, stickers *mtproto.TLMessagesGetMaskStickers,
) (*mtproto.Messages_AllStickers, error) {
	//TODO implement me
	panic("implement me")
}

func (s Service) MessagesGetAttachedStickers(
	ctx context.Context, stickers *mtproto.TLMessagesGetAttachedStickers,
) (*mtproto.Vector_StickerSetCovered, error) {
	//TODO implement me
	panic("implement me")
}

func (s Service) MessagesGetFavedStickers(
	ctx context.Context, stickers *mtproto.TLMessagesGetFavedStickers,
) (*mtproto.Messages_FavedStickers, error) {
	//TODO implement me
	panic("implement me")
}

func (s Service) MessagesFaveSticker(ctx context.Context, sticker *mtproto.TLMessagesFaveSticker) (
	*mtproto.Bool, error,
) {
	//TODO implement me
	panic("implement me")
}

func (s Service) MessagesSearchStickerSets(
	ctx context.Context, sets *mtproto.TLMessagesSearchStickerSets,
) (*mtproto.Messages_FoundStickerSets, error) {
	//TODO implement me
	panic("implement me")
}

func (s Service) MessagesToggleStickerSets(
	ctx context.Context, sets *mtproto.TLMessagesToggleStickerSets,
) (*mtproto.Bool, error) {
	//TODO implement me
	panic("implement me")
}

func (s Service) MessagesGetOldFeaturedStickers(
	ctx context.Context, stickers *mtproto.TLMessagesGetOldFeaturedStickers,
) (*mtproto.Messages_FeaturedStickers, error) {
	//TODO implement me
	panic("implement me")
}

func (s Service) MessagesSearchEmojiStickerSets(
	ctx context.Context, sets *mtproto.TLMessagesSearchEmojiStickerSets,
) (*mtproto.Messages_FoundStickerSets, error) {
	//TODO implement me
	panic("implement me")
}

func (s Service) MessagesGetMyStickers(
	ctx context.Context, stickers *mtproto.TLMessagesGetMyStickers,
) (*mtproto.Messages_MyStickers, error) {
	//TODO implement me
	panic("implement me")
}

func (s Service) StickersCreateStickerSet(
	ctx context.Context, set *mtproto.TLStickersCreateStickerSet,
) (*mtproto.Messages_StickerSet, error) {
	//TODO implement me
	panic("implement me")
}

func (s Service) StickersRemoveStickerFromSet(
	ctx context.Context, set *mtproto.TLStickersRemoveStickerFromSet,
) (*mtproto.Messages_StickerSet, error) {
	//TODO implement me
	panic("implement me")
}

func (s Service) StickersChangeStickerPosition(
	ctx context.Context, position *mtproto.TLStickersChangeStickerPosition,
) (*mtproto.Messages_StickerSet, error) {
	//TODO implement me
	panic("implement me")
}

func (s Service) StickersAddStickerToSet(
	ctx context.Context, set *mtproto.TLStickersAddStickerToSet,
) (*mtproto.Messages_StickerSet, error) {
	//TODO implement me
	panic("implement me")
}

func (s Service) StickersSetStickerSetThumb(
	ctx context.Context, thumb *mtproto.TLStickersSetStickerSetThumb,
) (*mtproto.Messages_StickerSet, error) {
	//TODO implement me
	panic("implement me")
}

func (s Service) StickersCheckShortName(ctx context.Context, name *mtproto.TLStickersCheckShortName) (
	*mtproto.Bool, error,
) {
	//TODO implement me
	panic("implement me")
}

func (s Service) StickersSuggestShortName(
	ctx context.Context, name *mtproto.TLStickersSuggestShortName,
) (*mtproto.Stickers_SuggestedShortName, error) {
	//TODO implement me
	panic("implement me")
}

func (s Service) StickersChangeSticker(
	ctx context.Context, sticker *mtproto.TLStickersChangeSticker,
) (*mtproto.Messages_StickerSet, error) {
	//TODO implement me
	panic("implement me")
}

func (s Service) StickersRenameStickerSet(
	ctx context.Context, set *mtproto.TLStickersRenameStickerSet,
) (*mtproto.Messages_StickerSet, error) {
	//TODO implement me
	panic("implement me")
}

func (s Service) StickersDeleteStickerSet(ctx context.Context, set *mtproto.TLStickersDeleteStickerSet) (
	*mtproto.Bool, error,
) {
	//TODO implement me
	panic("implement me")
}

func (s Service) StickersReplaceSticker(
	ctx context.Context, sticker *mtproto.TLStickersReplaceSticker,
) (*mtproto.Messages_StickerSet, error) {
	//TODO implement me
	panic("implement me")
}
