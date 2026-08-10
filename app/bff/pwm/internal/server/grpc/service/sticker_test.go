package service

import (
	"context"
	"errors"
	"testing"

	"github.com/stretchr/testify/require"
	"github.com/teamgram/proto/mtproto"
	"google.golang.org/grpc/codes"
	"google.golang.org/grpc/status"

	"pwm-server/app/bff/pwm/internal/dao/dataobject"
)

type stickerCatalogStoreStub struct {
	calls []uint8
	sets  []dataobject.StickerSetDO
	err   error
}

func (s *stickerCatalogStoreStub) InitializeUserStickerCatalog(_ context.Context, _ int64, category uint8) error {
	s.calls = append(s.calls, category)
	return s.err
}

func (s *stickerCatalogStoreStub) SelectInstalledStickerSets(_ context.Context, _ int64, category uint8) ([]dataobject.StickerSetDO, error) {
	s.calls = append(s.calls, category+10)
	return s.sets, nil
}

func TestBuildStickerSetLayer186(t *testing.T) {
	set := buildStickerSet(&dataobject.StickerSetDO{
		NativeSetId: 42, NativeAccessHash: 84, Title: "Animals", ShortName: "animals",
		SetHash: 7, DocumentCount: 3, Official: true, Animated: true,
		ThumbDocumentId: 9, ThumbDcId: 2, ThumbVersion: 4,
	})

	require.Equal(t, mtproto.Predicate_stickerSet, set.GetPredicateName())
	require.Equal(t, int64(42), set.GetId())
	require.Equal(t, int64(84), set.GetAccessHash())
	require.Equal(t, int32(3), set.GetCount())
	require.Equal(t, int32(7), set.GetHash())
	require.Equal(t, int64(9), set.GetThumbDocumentId().GetValue())
}

func TestStickerPacksPreserveFirstEmojiOrder(t *testing.T) {
	rows := []dataobject.StickerDocumentViewDO{
		{StickerDocumentDO: dataobject.StickerDocumentDO{NativeDocumentId: 10}, Emoticon: "a"},
		{StickerDocumentDO: dataobject.StickerDocumentDO{NativeDocumentId: 20}, Emoticon: "b"},
		{StickerDocumentDO: dataobject.StickerDocumentDO{NativeDocumentId: 30}, Emoticon: "a"},
	}

	packs := stickerPacks(rows)
	require.Len(t, packs, 2)
	require.Equal(t, "a", packs[0].GetEmoticon())
	require.Equal(t, []int64{10, 30}, packs[0].GetDocuments())
	require.Equal(t, "b", packs[1].GetEmoticon())
}

func TestInitializeAndSelectInstalledStickerSets(t *testing.T) {
	for _, category := range []uint8{stickerCategoryRegular, stickerCategoryEmoji} {
		t.Run(string(rune('0'+category)), func(t *testing.T) {
			store := &stickerCatalogStoreStub{sets: []dataobject.StickerSetDO{{Id: 1}}}
			sets, err := initializeAndSelectInstalledStickerSets(context.Background(), store, 42, category)
			require.NoError(t, err)
			require.Equal(t, []uint8{category, category + 10}, store.calls)
			require.Len(t, sets, 1)
		})
	}
}

func TestInitializeAndSelectInstalledStickerSetsStopsOnInitializationError(t *testing.T) {
	wantErr := errors.New("initialize")
	store := &stickerCatalogStoreStub{err: wantErr}
	sets, err := initializeAndSelectInstalledStickerSets(context.Background(), store, 42, stickerCategoryRegular)
	require.ErrorIs(t, err, wantErr)
	require.Nil(t, sets)
	require.Equal(t, []uint8{stickerCategoryRegular}, store.calls)
}

func TestUnsupportedStickerRPCsReturnUnimplementedWithoutPanic(t *testing.T) {
	service := Service{}
	tests := []struct {
		name string
		call func() error
	}{
		{"create", func() error { _, err := service.StickersCreateStickerSet(context.Background(), nil); return err }},
		{"remove", func() error { _, err := service.StickersRemoveStickerFromSet(context.Background(), nil); return err }},
		{"add", func() error { _, err := service.StickersAddStickerToSet(context.Background(), nil); return err }},
		{"rename", func() error { _, err := service.StickersRenameStickerSet(context.Background(), nil); return err }},
		{"delete", func() error { _, err := service.StickersDeleteStickerSet(context.Background(), nil); return err }},
	}
	for _, test := range tests {
		t.Run(test.name, func(t *testing.T) {
			require.NotPanics(t, func() {
				require.Equal(t, codes.Unimplemented, status.Code(test.call()))
			})
		})
	}
}
