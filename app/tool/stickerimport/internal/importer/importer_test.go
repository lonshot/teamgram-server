package importer

import (
	"context"
	"crypto/sha256"
	"database/sql"
	"errors"
	"fmt"
	"strings"
	"sync"
	"testing"

	"github.com/stretchr/testify/require"
	"github.com/teamgram/proto/mtproto"
	"pwm-server/app/tool/stickerimport/internal/catalog"
	"pwm-server/app/tool/stickerimport/internal/native"
	"pwm-server/app/tool/stickerimport/internal/pwm"
)

func TestImporterPublishesNativeStickerSetAndSkipsVerifiedRerun(t *testing.T) {
	dataset, fingerprint := importerFixture()
	store := newFakeStore()
	uploader := newFakeUploader()
	service := New(store, uploader, fixedIDGenerator(7001), Options{Workers: 2})
	service.newHash = func() (int64, error) { return 8001, nil }

	first, err := service.ImportSets(context.Background(), dataset, fingerprint, []int{0})
	require.NoError(t, err)
	require.Equal(t, 1, first.CompletedSets)
	require.Equal(t, 2, first.UploadedDocuments)
	require.Equal(t, 2, first.VerifiedDocuments)
	require.Zero(t, first.SkippedDocuments)
	require.Len(t, store.finalizedPacks, 2)
	require.Equal(t, catalog.SetComplete, store.set.State)
	require.Len(t, uploader.specs, 2)
	require.True(t, store.featuredPublished)

	byMIME := make(map[string]native.DocumentSpec)
	for _, spec := range uploader.specs {
		byMIME[spec.MimeType] = spec
	}
	regular := findAttribute(t, byMIME[pwm.MIMETypeTGS].Attributes, mtproto.Predicate_documentAttributeSticker)
	require.Equal(t, "😀", regular.GetAlt())
	require.Equal(t, int64(7001), regular.GetStickerset().GetId())
	require.Equal(t, int64(8001), regular.GetStickerset().GetAccessHash())
	custom := findAttribute(t, byMIME[pwm.MIMETypeWebP].Attributes, mtproto.Predicate_documentAttributeCustomEmoji)
	require.True(t, custom.GetFree())
	require.True(t, custom.GetTextColor())
	require.Equal(t, int64(7001), custom.GetStickerset().GetId())

	second, err := service.ImportSets(context.Background(), dataset, fingerprint, []int{0})
	require.NoError(t, err)
	require.Equal(t, 2, second.SkippedDocuments)
	require.Zero(t, second.UploadedDocuments)
	require.Len(t, uploader.specs, 2, "rerun must not upload duplicate native documents")
}

func TestImporterResumesPersistedDocumentByVerificationOnly(t *testing.T) {
	dataset, fingerprint := importerFixture()
	dataset.Sets[0].Stickers = dataset.Sets[0].Stickers[:1]
	dataset.Sets[0].Set.Count = 1
	store := newFakeStore()
	store.documents[101] = &fakeDocumentState{
		ID:         501,
		NativeID:   9001,
		AccessHash: 9101,
		State:      catalog.DocumentPersisted,
	}
	uploader := newFakeUploader()
	service := New(store, uploader, fixedIDGenerator(7001), Options{Workers: 1})
	service.newHash = func() (int64, error) { return 8001, nil }

	report, err := service.ImportSets(context.Background(), dataset, fingerprint, []int{0})
	require.NoError(t, err)
	require.Equal(t, 1, report.ResumedDocuments)
	require.Zero(t, report.UploadedDocuments)
	require.Empty(t, uploader.specs)
	require.Equal(t, 1, uploader.verifyCalls)
	require.Equal(t, catalog.DocumentVerified, store.documents[101].State)
}

func TestImporterReplacesPersistedDocumentThatFailsIntegrityValidation(t *testing.T) {
	dataset, fingerprint := importerFixture()
	dataset.Sets[0].Stickers = dataset.Sets[0].Stickers[:1]
	dataset.Sets[0].Set.Count = 1
	store := newFakeStore()
	store.documents[101] = &fakeDocumentState{
		ID: 501, NativeID: 9001, AccessHash: 9101, State: catalog.DocumentFailed,
	}
	uploader := newFakeUploader()
	uploader.integrityFailures = 1
	service := New(store, uploader, fixedIDGenerator(7001), Options{Workers: 1})
	service.newHash = func() (int64, error) { return 8001, nil }

	report, err := service.ImportSets(context.Background(), dataset, fingerprint, []int{0})
	require.NoError(t, err)
	require.Equal(t, 1, report.UploadedDocuments)
	require.Len(t, uploader.specs, 1, "the invalid persisted mapping must be replaced once")
	require.Equal(t, 2, uploader.verifyCalls, "old mapping and replacement must both be verified")
	require.Equal(t, catalog.DocumentVerified, store.documents[101].State)
}

func TestImporterUploadsAndPublishesEveryNativeReactionRole(t *testing.T) {
	dataset, fingerprint := importerFixture()
	reaction := pwm.Reaction{Reaction: pwm.ReactionID{Emoticon: "👍"}, Title: "Like"}
	for role, document := range reaction.Documents() {
		id := int64(201 + role)
		path := "/dataset/tgs/reaction" + string(rune('a'+role))
		*document = pwm.ReactionDocument{
			ID: fmt.Sprintf("%d", id), SourceID: id, SourcePath: path, SourceSize: 10,
			MimeType: pwm.MIMETypeTGS, FileName: "AnimatedSticker.tgs",
			MediaSize: pwm.MediaSize{Width: 128, Height: 128},
		}
		fingerprint.Files[path] = sha256.Sum256([]byte("one"))
	}
	dataset.Reactions = []pwm.Reaction{reaction}
	dataset.Report.ReactionDocuments = 7
	dataset.Report.UniqueDocuments = 9
	store := newFakeStore()
	uploader := newFakeUploader()
	service := New(store, uploader, fixedIDGenerator(7001), Options{Workers: 4})
	service.newHash = func() (int64, error) { return 8001, nil }

	report, err := service.ImportSets(context.Background(), dataset, fingerprint, []int{0})
	require.NoError(t, err)
	require.Equal(t, 7, report.ReactionDocuments)
	require.Equal(t, 1, report.PublishedReactions)
	require.True(t, store.reactionsPublished)
	require.True(t, store.completedImport)
	require.Len(t, uploader.specs, 9)
	animatedReactionDocuments := 0
	for _, spec := range uploader.specs {
		if strings.HasPrefix(spec.SourcePath, "/dataset/tgs/reaction") &&
			findOptionalAttribute(spec.Attributes, mtproto.Predicate_documentAttributeAnimated) != nil {
			animatedReactionDocuments++
		}
	}
	require.Equal(t, 7, animatedReactionDocuments)
}

func importerFixture() (*pwm.Dataset, *pwm.Fingerprint) {
	fullOne := "/dataset/tgs/sticker101"
	previewOne := "/dataset/preview/sticker101"
	fullTwo := "/dataset/preview/sticker102"
	dataset := &pwm.Dataset{
		Root:    "/dataset",
		Version: "1.0.0",
		Sets: []pwm.StickerSetFile{{
			Set: pwm.StickerSet{
				ID: "10", SourceID: 10, AccessHash: "20", SourceAccessHash: 20,
				Title: "Pack", ShortName: "Pack", Count: 2,
			},
			Stickers: []pwm.StickerDoc{
				{
					ID: "101", SourceID: 101, Emoji: "😀", IsLottie: true,
					Width: 512, Height: 512, MimeType: pwm.MIMETypeTGS,
					SourcePath: fullOne, SourceSize: 12, PreviewPath: previewOne, PreviewSize: 5,
				},
				{
					ID: "102", SourceID: 102, Emoji: "✨", IsCustomEmoji: true,
					Width: 100, Height: 100, MimeType: pwm.MIMETypeWebP, IsFree: true, ShouldUseTextColor: true,
					SourcePath: fullTwo, SourceSize: 6, PreviewPath: fullTwo, PreviewSize: 6,
				},
			},
		}},
		Report: pwm.Report{StickerSets: 1, UniqueDocuments: 2},
		Featured: pwm.FeaturedStickers{Sets: []pwm.FeaturedStickerSet{{
			SourceID: 10, Covers: []pwm.FeaturedCover{{SourceID: 101}},
		}}},
	}
	fingerprint := &pwm.Fingerprint{Files: map[string][sha256.Size]byte{
		fullOne:    sha256.Sum256([]byte("one")),
		previewOne: sha256.Sum256([]byte("preview")),
		fullTwo:    sha256.Sum256([]byte("two")),
	}}
	fingerprint.Dataset = sha256.Sum256([]byte("dataset"))
	return dataset, fingerprint
}

type fakeStore struct {
	mu                 sync.Mutex
	set                *catalog.Set
	documents          map[int64]*fakeDocumentState
	finalizedPacks     []catalog.Pack
	featuredPublished  bool
	completedImport    bool
	reactionsPublished bool
}

type fakeDocumentState struct {
	ID         int64
	NativeID   int64
	AccessHash int64
	State      int
	Preview    bool
}

func newFakeStore() *fakeStore {
	return &fakeStore{documents: make(map[int64]*fakeDocumentState)}
}

func (f *fakeStore) BeginImport(context.Context, catalog.ImportInput) (*catalog.Import, error) {
	return &catalog.Import{ID: 1, State: catalog.ImportRunning}, nil
}

func (f *fakeStore) ReplaceEmojiKeywords(context.Context, catalog.EmojiKeywordsInput) error {
	return nil
}

func (f *fakeStore) ReplaceFeatured(_ context.Context, featured []catalog.FeaturedSetInput) error {
	f.mu.Lock()
	defer f.mu.Unlock()
	f.featuredPublished = true
	if len(featured) != 1 || featured[0].SourceSetID != 10 || len(featured[0].CoverSourceDocumentIDs) != 1 || featured[0].CoverSourceDocumentIDs[0] != 101 {
		return errors.New("unexpected featured catalog")
	}
	return nil
}

func (f *fakeStore) ReplaceReactions(_ context.Context, input catalog.ReactionCatalogInput) error {
	f.mu.Lock()
	defer f.mu.Unlock()
	f.reactionsPublished = len(input.Reactions) > 0
	return nil
}

func (f *fakeStore) CompleteImport(context.Context, int64) error {
	f.mu.Lock()
	defer f.mu.Unlock()
	f.completedImport = true
	return nil
}

func (f *fakeStore) EnsureSet(_ context.Context, input catalog.SetInput) (*catalog.Set, error) {
	f.mu.Lock()
	defer f.mu.Unlock()
	if f.set == nil {
		f.set = &catalog.Set{ID: 11, NativeID: input.NativeID, NativeAccessHash: input.NativeAccessHash}
	}
	return f.set, nil
}

func (f *fakeStore) MarkSetRunning(context.Context, int64) error {
	f.mu.Lock()
	defer f.mu.Unlock()
	f.set.State = catalog.SetRunning
	return nil
}

func (f *fakeStore) MarkSetFailed(context.Context, int64, error) error {
	f.mu.Lock()
	defer f.mu.Unlock()
	f.set.State = catalog.SetFailed
	return nil
}

func (f *fakeStore) ReserveDocument(_ context.Context, input catalog.DocumentInput) (*catalog.Document, error) {
	f.mu.Lock()
	defer f.mu.Unlock()
	state := f.documents[input.SourceID]
	if state == nil {
		state = &fakeDocumentState{ID: int64(500 + len(f.documents) + 1), State: catalog.DocumentPending, Preview: input.PreviewPath != ""}
		f.documents[input.SourceID] = state
	}
	result := &catalog.Document{ID: state.ID, State: state.State, PreviewState: catalog.PreviewPending}
	if state.NativeID != 0 {
		result.NativeID = sql.NullInt64{Int64: state.NativeID, Valid: true}
		result.NativeAccessHash = sql.NullInt64{Int64: state.AccessHash, Valid: true}
	}
	result.NeedsUpload = !result.NativeID.Valid
	result.NeedsVerify = result.NativeID.Valid && state.State != catalog.DocumentVerified
	return result, nil
}

func (f *fakeStore) MarkDocumentPersisted(_ context.Context, id, nativeID, accessHash int64, preview bool) error {
	f.mu.Lock()
	defer f.mu.Unlock()
	for _, state := range f.documents {
		if state.ID == id {
			state.NativeID, state.AccessHash, state.State, state.Preview = nativeID, accessHash, catalog.DocumentPersisted, preview
		}
	}
	return nil
}

func (f *fakeStore) MarkDocumentVerified(_ context.Context, id int64, _ bool) error {
	f.mu.Lock()
	defer f.mu.Unlock()
	for _, state := range f.documents {
		if state.ID == id {
			state.State = catalog.DocumentVerified
		}
	}
	return nil
}

func (f *fakeStore) MarkDocumentFailed(context.Context, int64, error) error { return nil }

func (f *fakeStore) ResetDocumentForUpload(_ context.Context, id int64, _ error) error {
	f.mu.Lock()
	defer f.mu.Unlock()
	for _, state := range f.documents {
		if state.ID == id {
			state.NativeID, state.AccessHash, state.State = 0, 0, catalog.DocumentPending
		}
	}
	return nil
}

func (f *fakeStore) FinalizeSet(_ context.Context, _ int64, packs []catalog.Pack) error {
	f.mu.Lock()
	defer f.mu.Unlock()
	f.finalizedPacks = append([]catalog.Pack(nil), packs...)
	f.set.State = catalog.SetComplete
	return nil
}

type fakeUploader struct {
	mu                sync.Mutex
	specs             []native.DocumentSpec
	verifyCalls       int
	nextID            int64
	integrityFailures int
}

func newFakeUploader() *fakeUploader { return &fakeUploader{nextID: 9000} }

func (f *fakeUploader) Upload(_ context.Context, spec native.DocumentSpec) (*native.Result, error) {
	f.mu.Lock()
	defer f.mu.Unlock()
	f.specs = append(f.specs, spec)
	f.nextID++
	checksum := sha256.Sum256([]byte("one"))
	if spec.MimeType == pwm.MIMETypeWebP {
		checksum = sha256.Sum256([]byte("two"))
	}
	document := mtproto.MakeTLDocument(&mtproto.Document{
		Id: f.nextID, AccessHash: f.nextID + 100, MimeType: spec.MimeType, DcId: 1,
	}).To_Document()
	return &native.Result{Document: document, SourceChecksum: checksum, PreviewPresent: spec.PreviewPath != ""}, nil
}

func (f *fakeUploader) Verify(_ context.Context, id, hash int64, _ string, _ [sha256.Size]byte, _ bool) (*mtproto.Document, error) {
	f.mu.Lock()
	defer f.mu.Unlock()
	f.verifyCalls++
	if f.integrityFailures > 0 {
		f.integrityFailures--
		return nil, native.ErrNativeIntegrity
	}
	return mtproto.MakeTLDocument(&mtproto.Document{Id: id, AccessHash: hash, DcId: 1}).To_Document(), nil
}

type fixedIDGenerator int64

func (f fixedIDGenerator) NextID(context.Context) (int64, error) { return int64(f), nil }

func findAttribute(t *testing.T, attributes []*mtproto.DocumentAttribute, predicate string) *mtproto.DocumentAttribute {
	t.Helper()
	for _, attribute := range attributes {
		if attribute.GetPredicateName() == predicate {
			return attribute
		}
	}
	t.Fatalf("attribute %s not found", predicate)
	return nil
}

func findOptionalAttribute(attributes []*mtproto.DocumentAttribute, predicate string) *mtproto.DocumentAttribute {
	for _, attribute := range attributes {
		if attribute.GetPredicateName() == predicate {
			return attribute
		}
	}
	return nil
}
