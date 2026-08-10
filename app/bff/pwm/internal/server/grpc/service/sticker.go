package service

import (
	"context"
	"fmt"
	"strings"
	"time"

	"github.com/teamgram/proto/mtproto"
	rpcmetadata "github.com/teamgram/proto/mtproto/rpc/metadata"
	"google.golang.org/grpc/codes"
	"google.golang.org/grpc/status"
	"google.golang.org/protobuf/types/known/wrapperspb"

	"pwm-server/app/bff/pwm/internal/dao/dataobject"
	"pwm-server/app/service/media/media"
)

const (
	stickerCategoryRegular uint8 = 1
	stickerCategoryMask    uint8 = 2
	stickerCategoryEmoji   uint8 = 3
	recentStickerLimit           = 200
	favedStickerLimit            = 5
)

func (s Service) MessagesGetStickers(ctx context.Context, in *mtproto.TLMessagesGetStickers) (*mtproto.Messages_Stickers, error) {
	if in == nil {
		return nil, mtproto.ErrStickersetInvalid
	}
	rows, err := s.svcCtx.SelectStickerDocumentsByEmoticon(ctx, strings.TrimSpace(in.GetEmoticon()), 200)
	if err != nil {
		return nil, err
	}
	hash := documentRowsHash(rows)
	if in.GetHash() != 0 && in.GetHash() == hash {
		return mtproto.MakeTLMessagesStickersNotModified(&mtproto.Messages_Stickers{}).To_Messages_Stickers(), nil
	}
	documents, err := s.loadStickerDocuments(ctx, documentIds(rows))
	if err != nil {
		return nil, err
	}
	return mtproto.MakeTLMessagesStickers(&mtproto.Messages_Stickers{Hash: hash, Stickers: documents}).To_Messages_Stickers(), nil
}

func (s Service) MessagesGetAllStickers(ctx context.Context, in *mtproto.TLMessagesGetAllStickers) (*mtproto.Messages_AllStickers, error) {
	return s.installedStickerSets(ctx, in.GetHash(), stickerCategoryRegular)
}

func (s Service) MessagesGetEmojiStickers(ctx context.Context, in *mtproto.TLMessagesGetEmojiStickers) (*mtproto.Messages_AllStickers, error) {
	return s.installedStickerSets(ctx, in.GetHash(), stickerCategoryEmoji)
}

func (s Service) MessagesGetMaskStickers(ctx context.Context, in *mtproto.TLMessagesGetMaskStickers) (*mtproto.Messages_AllStickers, error) {
	return s.installedStickerSets(ctx, in.GetHash(), stickerCategoryMask)
}

func (s Service) installedStickerSets(ctx context.Context, requestHash int64, category uint8) (*mtproto.Messages_AllStickers, error) {
	userId, err := stickerUserId(ctx)
	if err != nil {
		return nil, err
	}
	sets, err := s.svcCtx.SelectInstalledStickerSets(ctx, userId, category)
	if err != nil {
		return nil, err
	}
	hash := stickerSetsHash(sets)
	if requestHash != 0 && requestHash == hash {
		return mtproto.MakeTLMessagesAllStickersNotModified(&mtproto.Messages_AllStickers{}).To_Messages_AllStickers(), nil
	}
	return mtproto.MakeTLMessagesAllStickers(&mtproto.Messages_AllStickers{Hash: hash, Sets: buildStickerSets(sets)}).To_Messages_AllStickers(), nil
}

func (s Service) MessagesGetStickerSet(ctx context.Context, in *mtproto.TLMessagesGetStickerSet) (*mtproto.Messages_StickerSet, error) {
	if in == nil {
		return nil, mtproto.ErrStickersetInvalid
	}
	set, err := s.svcCtx.ResolveStickerSet(ctx, in.GetStickerset())
	if err != nil {
		return nil, err
	}
	if in.GetHash() != 0 && in.GetHash() == int32(set.SetHash) {
		return mtproto.MakeTLMessagesStickerSetNotModified(&mtproto.Messages_StickerSet{}).To_Messages_StickerSet(), nil
	}
	return s.buildStickerSetResponse(ctx, set)
}

func (s Service) MessagesInstallStickerSet(ctx context.Context, in *mtproto.TLMessagesInstallStickerSet) (*mtproto.Messages_StickerSetInstallResult, error) {
	userId, err := stickerUserId(ctx)
	if err != nil {
		return nil, err
	}
	if in == nil {
		return nil, mtproto.ErrStickersetInvalid
	}
	set, err := s.svcCtx.ResolveStickerSet(ctx, in.GetStickerset())
	if err != nil {
		return nil, err
	}
	if err = s.svcCtx.InstallStickerSet(ctx, userId, set.Id, stickerSetCategory(set), mtproto.FromBool(in.GetArchived()), int32(time.Now().Unix())); err != nil {
		return nil, err
	}
	return mtproto.MakeTLMessagesStickerSetInstallResultSuccess(&mtproto.Messages_StickerSetInstallResult{}).To_Messages_StickerSetInstallResult(), nil
}

func (s Service) MessagesUninstallStickerSet(ctx context.Context, in *mtproto.TLMessagesUninstallStickerSet) (*mtproto.Bool, error) {
	userId, err := stickerUserId(ctx)
	if err != nil {
		return nil, err
	}
	if in == nil {
		return nil, mtproto.ErrStickersetInvalid
	}
	set, err := s.svcCtx.ResolveStickerSet(ctx, in.GetStickerset())
	if err != nil {
		return nil, err
	}
	if err = s.svcCtx.DeleteStickerSetForUser(ctx, userId, set.Id); err != nil {
		return nil, err
	}
	return mtproto.BoolTrue, nil
}

func (s Service) MessagesReorderStickerSets(ctx context.Context, in *mtproto.TLMessagesReorderStickerSets) (*mtproto.Bool, error) {
	userId, err := stickerUserId(ctx)
	if err != nil {
		return nil, err
	}
	if in == nil || in.GetMasks() && in.GetEmojis() {
		return nil, mtproto.ErrStickersetInvalid
	}
	category := stickerCategoryRegular
	if in.GetMasks() {
		category = stickerCategoryMask
	}
	if in.GetEmojis() {
		category = stickerCategoryEmoji
	}
	if err = s.svcCtx.ReorderStickerSets(ctx, userId, category, in.GetOrder()); err != nil {
		return nil, err
	}
	return mtproto.BoolTrue, nil
}

func (s Service) MessagesGetFeaturedStickers(ctx context.Context, in *mtproto.TLMessagesGetFeaturedStickers) (*mtproto.Messages_FeaturedStickers, error) {
	userId, err := stickerUserId(ctx)
	if err != nil {
		return nil, err
	}
	sets, err := s.svcCtx.SelectFeaturedStickerSets(ctx, userId, stickerCategoryRegular)
	if err != nil {
		return nil, err
	}
	hash := featuredStickerSetsHash(sets)
	if in.GetHash() != 0 && in.GetHash() == hash {
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

func (s Service) MessagesReadFeaturedStickers(ctx context.Context, in *mtproto.TLMessagesReadFeaturedStickers) (*mtproto.Bool, error) {
	userId, err := stickerUserId(ctx)
	if err != nil {
		return nil, err
	}
	if in == nil {
		return nil, mtproto.ErrStickersetInvalid
	}
	ids, err := s.svcCtx.StickerSetIdsByNativeIds(ctx, in.GetId())
	if err != nil {
		return nil, err
	}
	if err = s.svcCtx.MarkFeaturedStickerSetsRead(ctx, userId, ids, int32(time.Now().Unix())); err != nil {
		return nil, err
	}
	return mtproto.BoolTrue, nil
}

func (s Service) MessagesGetRecentStickers(ctx context.Context, in *mtproto.TLMessagesGetRecentStickers) (*mtproto.Messages_RecentStickers, error) {
	userId, err := stickerUserId(ctx)
	if err != nil {
		return nil, err
	}
	rows, err := s.svcCtx.SelectRecentStickerDocuments(ctx, userId, in.GetAttached(), recentStickerLimit)
	if err != nil {
		return nil, err
	}
	hash := savedStickerRowsHash(rows)
	if in.GetHash() != 0 && in.GetHash() == hash {
		return mtproto.MakeTLMessagesRecentStickersNotModified(&mtproto.Messages_RecentStickers{}).To_Messages_RecentStickers(), nil
	}
	documents, err := s.loadStickerDocuments(ctx, savedDocumentIds(rows))
	if err != nil {
		return nil, err
	}
	return mtproto.MakeTLMessagesRecentStickers(&mtproto.Messages_RecentStickers{Hash: hash, Packs: savedStickerPacks(rows), Stickers: documents, Dates: savedStickerDates(rows)}).To_Messages_RecentStickers(), nil
}

func (s Service) MessagesSaveRecentSticker(ctx context.Context, in *mtproto.TLMessagesSaveRecentSticker) (*mtproto.Bool, error) {
	userId, err := stickerUserId(ctx)
	if err != nil {
		return nil, err
	}
	if in == nil {
		return nil, mtproto.ErrStickerDocumentInvalid
	}
	document, err := s.svcCtx.ResolveStickerDocument(ctx, in.GetId())
	if err != nil {
		return nil, err
	}
	if mtproto.FromBool(in.GetUnsave()) {
		err = s.svcCtx.DeleteRecentSticker(ctx, userId, document.Id, in.GetAttached())
	} else {
		err = s.svcCtx.SaveRecentSticker(ctx, userId, document.Id, in.GetAttached(), int32(time.Now().Unix()))
	}
	if err != nil {
		return nil, err
	}
	return mtproto.BoolTrue, nil
}

func (s Service) MessagesClearRecentStickers(ctx context.Context, in *mtproto.TLMessagesClearRecentStickers) (*mtproto.Bool, error) {
	userId, err := stickerUserId(ctx)
	if err != nil {
		return nil, err
	}
	if in == nil {
		return nil, mtproto.ErrStickerDocumentInvalid
	}
	if err = s.svcCtx.ClearRecentStickers(ctx, userId, in.GetAttached()); err != nil {
		return nil, err
	}
	return mtproto.BoolTrue, nil
}

func (s Service) MessagesGetArchivedStickers(ctx context.Context, in *mtproto.TLMessagesGetArchivedStickers) (*mtproto.Messages_ArchivedStickers, error) {
	userId, err := stickerUserId(ctx)
	if err != nil {
		return nil, err
	}
	if in == nil || in.GetMasks() && in.GetEmojis() {
		return nil, mtproto.ErrStickersetInvalid
	}
	category := stickerCategoryRegular
	if in.GetMasks() {
		category = stickerCategoryMask
	}
	if in.GetEmojis() {
		category = stickerCategoryEmoji
	}
	rows, count, err := s.svcCtx.SelectArchivedStickerSets(ctx, userId, category, in.GetOffsetId(), in.GetLimit())
	if err != nil {
		return nil, err
	}
	sets, err := s.buildCoveredStickerSets(ctx, rows)
	if err != nil {
		return nil, err
	}
	return mtproto.MakeTLMessagesArchivedStickers(&mtproto.Messages_ArchivedStickers{Count: count, Sets: sets}).To_Messages_ArchivedStickers(), nil
}

func (s Service) MessagesGetFavedStickers(ctx context.Context, in *mtproto.TLMessagesGetFavedStickers) (*mtproto.Messages_FavedStickers, error) {
	userId, err := stickerUserId(ctx)
	if err != nil {
		return nil, err
	}
	rows, err := s.svcCtx.SelectFavedStickerDocuments(ctx, userId, favedStickerLimit)
	if err != nil {
		return nil, err
	}
	hash := savedStickerRowsHash(rows)
	if in.GetHash() != 0 && in.GetHash() == hash {
		return mtproto.MakeTLMessagesFavedStickersNotModified(&mtproto.Messages_FavedStickers{}).To_Messages_FavedStickers(), nil
	}
	documents, err := s.loadStickerDocuments(ctx, savedDocumentIds(rows))
	if err != nil {
		return nil, err
	}
	return mtproto.MakeTLMessagesFavedStickers(&mtproto.Messages_FavedStickers{Hash: hash, Packs: savedStickerPacks(rows), Stickers: documents}).To_Messages_FavedStickers(), nil
}

func (s Service) MessagesFaveSticker(ctx context.Context, in *mtproto.TLMessagesFaveSticker) (*mtproto.Bool, error) {
	userId, err := stickerUserId(ctx)
	if err != nil {
		return nil, err
	}
	if in == nil {
		return nil, mtproto.ErrStickerDocumentInvalid
	}
	document, err := s.svcCtx.ResolveStickerDocument(ctx, in.GetId())
	if err != nil {
		return nil, err
	}
	if err = s.svcCtx.SetFavedSticker(ctx, userId, document.Id, int32(time.Now().Unix()), !mtproto.FromBool(in.GetUnfave())); err != nil {
		return nil, err
	}
	return mtproto.BoolTrue, nil
}

func (s Service) MessagesSearchStickerSets(ctx context.Context, in *mtproto.TLMessagesSearchStickerSets) (*mtproto.Messages_FoundStickerSets, error) {
	if _, err := stickerUserId(ctx); err != nil {
		return nil, err
	}
	if in == nil {
		return nil, mtproto.ErrStickersetInvalid
	}
	rows, err := s.svcCtx.SearchStickerSets(ctx, in.GetQ(), in.GetExcludeFeatured(), 100)
	if err != nil {
		return nil, err
	}
	hash := coveredStickerSetsHash(rows)
	if in.GetHash() != 0 && in.GetHash() == hash {
		return mtproto.MakeTLMessagesFoundStickerSetsNotModified(&mtproto.Messages_FoundStickerSets{}).To_Messages_FoundStickerSets(), nil
	}
	sets, err := s.buildCoveredStickerSets(ctx, rows)
	if err != nil {
		return nil, err
	}
	return mtproto.MakeTLMessagesFoundStickerSets(&mtproto.Messages_FoundStickerSets{Hash: hash, Sets: sets}).To_Messages_FoundStickerSets(), nil
}

func (s Service) buildStickerSetResponse(ctx context.Context, set *dataobject.StickerSetDO) (*mtproto.Messages_StickerSet, error) {
	rows, err := s.svcCtx.SelectStickerDocumentViewsBySet(ctx, set.Id)
	if err != nil {
		return nil, err
	}
	documents, err := s.loadStickerDocuments(ctx, viewDocumentIds(rows))
	if err != nil {
		return nil, err
	}
	return mtproto.MakeTLMessagesStickerSet(&mtproto.Messages_StickerSet{Set: buildStickerSet(set), Packs: stickerPacks(rows), Documents: documents}).To_Messages_StickerSet(), nil
}

func (s Service) loadStickerDocuments(ctx context.Context, ids []int64) ([]*mtproto.Document, error) {
	if len(ids) == 0 {
		return []*mtproto.Document{}, nil
	}
	result, err := s.svcCtx.MediaGetDocumentList(ctx, &media.TLMediaGetDocumentList{IdList: ids})
	if err != nil {
		return nil, err
	}
	byId := make(map[int64]*mtproto.Document, len(result.GetDatas()))
	for _, document := range result.GetDatas() {
		if document != nil {
			byId[document.GetId()] = document
		}
	}
	documents := make([]*mtproto.Document, 0, len(ids))
	for _, id := range ids {
		document := byId[id]
		if document == nil {
			return nil, fmt.Errorf("native sticker document %d is missing", id)
		}
		documents = append(documents, document)
	}
	return documents, nil
}

func (s Service) buildCoveredStickerSets(ctx context.Context, rows []dataobject.CoveredStickerSetDO) ([]*mtproto.StickerSetCovered, error) {
	ids := make([]int64, 0, len(rows))
	for i := range rows {
		if rows[i].CoverDocumentId > 0 {
			ids = append(ids, rows[i].CoverDocumentId)
		}
	}
	documents, err := s.loadStickerDocuments(ctx, ids)
	if err != nil {
		return nil, err
	}
	byId := make(map[int64]*mtproto.Document, len(documents))
	for _, document := range documents {
		byId[document.GetId()] = document
	}
	sets := make([]*mtproto.StickerSetCovered, 0, len(rows))
	for i := range rows {
		covered := &mtproto.StickerSetCovered{Set: buildStickerSet(&rows[i].StickerSetDO), Cover: byId[rows[i].CoverDocumentId]}
		if covered.Cover == nil {
			sets = append(sets, mtproto.MakeTLStickerSetNoCovered(covered).To_StickerSetCovered())
		} else {
			sets = append(sets, mtproto.MakeTLStickerSetCovered(covered).To_StickerSetCovered())
		}
	}
	return sets, nil
}

func buildStickerSet(set *dataobject.StickerSetDO) *mtproto.StickerSet {
	value := &mtproto.StickerSet{Archived: set.Archived, Official: set.Official, Masks: set.Masks, Emojis: set.Emojis, TextColor: set.TextColor,
		Animated: set.Animated, Videos: set.Videos, Id: set.NativeSetId, AccessHash: set.NativeAccessHash, Title: set.Title,
		ShortName: set.ShortName, Count: int32(set.DocumentCount), Hash: int32(set.SetHash)}
	if set.ThumbDocumentId > 0 {
		value.ThumbDocumentId = wrapperspb.Int64(set.ThumbDocumentId)
		value.ThumbDcId = wrapperspb.Int32(set.ThumbDcId)
		value.ThumbVersion = wrapperspb.Int32(set.ThumbVersion)
	}
	return mtproto.MakeTLStickerSet(value).To_StickerSet()
}

func buildStickerSets(sets []dataobject.StickerSetDO) []*mtproto.StickerSet {
	result := make([]*mtproto.StickerSet, len(sets))
	for i := range sets {
		result[i] = buildStickerSet(&sets[i])
	}
	return result
}
func stickerSetCategory(set *dataobject.StickerSetDO) uint8 {
	if set.Emojis {
		return stickerCategoryEmoji
	}
	if set.Masks {
		return stickerCategoryMask
	}
	return stickerCategoryRegular
}
func stickerUserId(ctx context.Context) (int64, error) {
	md := rpcmetadata.RpcMetadataFromIncoming(ctx)
	if md == nil || md.GetUserId() <= 0 {
		return 0, mtproto.ErrAuthKeyUnregistered
	}
	return md.GetUserId(), nil
}
func opaqueStickerHash(hash, value int64) int64 { return (hash*20261 + value) & 0x7fffffffffffffff }
func stickerSetsHash(sets []dataobject.StickerSetDO) int64 {
	var hash int64
	for i := range sets {
		hash = opaqueStickerHash(hash, sets[i].NativeSetId)
		hash = opaqueStickerHash(hash, int64(uint32(sets[i].SetHash)))
	}
	return hash
}
func documentRowsHash(rows []dataobject.StickerDocumentDO) int64 {
	var hash int64
	for i := range rows {
		hash = opaqueStickerHash(hash, rows[i].NativeDocumentId)
	}
	return hash
}
func savedStickerRowsHash(rows []dataobject.SavedStickerDocumentDO) int64 {
	var hash int64
	for i := range rows {
		hash = opaqueStickerHash(hash, rows[i].NativeDocumentId)
		hash = opaqueStickerHash(hash, int64(rows[i].SavedAt))
	}
	return hash
}
func featuredStickerSetsHash(rows []dataobject.FeaturedStickerSetDO) int64 {
	var hash int64
	for i := range rows {
		hash = opaqueStickerHash(hash, rows[i].NativeSetId)
		hash = opaqueStickerHash(hash, int64(uint32(rows[i].SetHash)))
	}
	return hash
}
func coveredStickerSetsHash(rows []dataobject.CoveredStickerSetDO) int64 {
	var hash int64
	for i := range rows {
		hash = opaqueStickerHash(hash, rows[i].NativeSetId)
		hash = opaqueStickerHash(hash, int64(uint32(rows[i].SetHash)))
		hash = opaqueStickerHash(hash, rows[i].CoverDocumentId)
	}
	return hash
}
func documentIds(rows []dataobject.StickerDocumentDO) []int64 {
	ids := make([]int64, len(rows))
	for i := range rows {
		ids[i] = rows[i].NativeDocumentId
	}
	return ids
}
func viewDocumentIds(rows []dataobject.StickerDocumentViewDO) []int64 {
	ids := make([]int64, len(rows))
	for i := range rows {
		ids[i] = rows[i].NativeDocumentId
	}
	return ids
}
func savedDocumentIds(rows []dataobject.SavedStickerDocumentDO) []int64 {
	ids := make([]int64, len(rows))
	for i := range rows {
		ids[i] = rows[i].NativeDocumentId
	}
	return ids
}
func savedStickerDates(rows []dataobject.SavedStickerDocumentDO) []int32 {
	dates := make([]int32, len(rows))
	for i := range rows {
		dates[i] = rows[i].SavedAt
	}
	return dates
}
func savedStickerPacks(rows []dataobject.SavedStickerDocumentDO) []*mtproto.StickerPack {
	views := make([]dataobject.StickerDocumentViewDO, len(rows))
	for i := range rows {
		views[i] = rows[i].StickerDocumentViewDO
	}
	return stickerPacks(views)
}
func stickerPacks(rows []dataobject.StickerDocumentViewDO) []*mtproto.StickerPack {
	order := make([]string, 0)
	ids := make(map[string][]int64)
	for i := range rows {
		emoji := rows[i].Emoticon
		if _, ok := ids[emoji]; !ok {
			order = append(order, emoji)
		}
		ids[emoji] = append(ids[emoji], rows[i].NativeDocumentId)
	}
	packs := make([]*mtproto.StickerPack, 0, len(order))
	for _, emoji := range order {
		packs = append(packs, mtproto.MakeTLStickerPack(&mtproto.StickerPack{Emoticon: emoji, Documents: ids[emoji]}).To_StickerPack())
	}
	return packs
}

func unimplementedSticker(method string) error {
	return status.Errorf(codes.Unimplemented, "%s is not implemented", method)
}
func (s Service) MessagesGetAttachedStickers(context.Context, *mtproto.TLMessagesGetAttachedStickers) (*mtproto.Vector_StickerSetCovered, error) {
	return nil, unimplementedSticker("MessagesGetAttachedStickers")
}
func (s Service) MessagesToggleStickerSets(context.Context, *mtproto.TLMessagesToggleStickerSets) (*mtproto.Bool, error) {
	return nil, unimplementedSticker("MessagesToggleStickerSets")
}
func (s Service) MessagesGetOldFeaturedStickers(context.Context, *mtproto.TLMessagesGetOldFeaturedStickers) (*mtproto.Messages_FeaturedStickers, error) {
	return nil, unimplementedSticker("MessagesGetOldFeaturedStickers")
}
func (s Service) MessagesSearchEmojiStickerSets(context.Context, *mtproto.TLMessagesSearchEmojiStickerSets) (*mtproto.Messages_FoundStickerSets, error) {
	return nil, unimplementedSticker("MessagesSearchEmojiStickerSets")
}
func (s Service) MessagesGetMyStickers(context.Context, *mtproto.TLMessagesGetMyStickers) (*mtproto.Messages_MyStickers, error) {
	return nil, unimplementedSticker("MessagesGetMyStickers")
}
func (s Service) StickersCreateStickerSet(context.Context, *mtproto.TLStickersCreateStickerSet) (*mtproto.Messages_StickerSet, error) {
	return nil, unimplementedSticker("StickersCreateStickerSet")
}
func (s Service) StickersRemoveStickerFromSet(context.Context, *mtproto.TLStickersRemoveStickerFromSet) (*mtproto.Messages_StickerSet, error) {
	return nil, unimplementedSticker("StickersRemoveStickerFromSet")
}
func (s Service) StickersChangeStickerPosition(context.Context, *mtproto.TLStickersChangeStickerPosition) (*mtproto.Messages_StickerSet, error) {
	return nil, unimplementedSticker("StickersChangeStickerPosition")
}
func (s Service) StickersAddStickerToSet(context.Context, *mtproto.TLStickersAddStickerToSet) (*mtproto.Messages_StickerSet, error) {
	return nil, unimplementedSticker("StickersAddStickerToSet")
}
func (s Service) StickersSetStickerSetThumb(context.Context, *mtproto.TLStickersSetStickerSetThumb) (*mtproto.Messages_StickerSet, error) {
	return nil, unimplementedSticker("StickersSetStickerSetThumb")
}
func (s Service) StickersCheckShortName(context.Context, *mtproto.TLStickersCheckShortName) (*mtproto.Bool, error) {
	return nil, unimplementedSticker("StickersCheckShortName")
}
func (s Service) StickersSuggestShortName(context.Context, *mtproto.TLStickersSuggestShortName) (*mtproto.Stickers_SuggestedShortName, error) {
	return nil, unimplementedSticker("StickersSuggestShortName")
}
func (s Service) StickersChangeSticker(context.Context, *mtproto.TLStickersChangeSticker) (*mtproto.Messages_StickerSet, error) {
	return nil, unimplementedSticker("StickersChangeSticker")
}
func (s Service) StickersRenameStickerSet(context.Context, *mtproto.TLStickersRenameStickerSet) (*mtproto.Messages_StickerSet, error) {
	return nil, unimplementedSticker("StickersRenameStickerSet")
}
func (s Service) StickersDeleteStickerSet(context.Context, *mtproto.TLStickersDeleteStickerSet) (*mtproto.Bool, error) {
	return nil, unimplementedSticker("StickersDeleteStickerSet")
}
func (s Service) StickersReplaceSticker(context.Context, *mtproto.TLStickersReplaceSticker) (*mtproto.Messages_StickerSet, error) {
	return nil, unimplementedSticker("StickersReplaceSticker")
}
