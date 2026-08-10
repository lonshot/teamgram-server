package importer

import (
	"context"
	"crypto/rand"
	"crypto/sha256"
	"encoding/binary"
	"errors"
	"fmt"
	"strings"
	"sync"

	"github.com/teamgram/proto/mtproto"
	"pwm-server/app/tool/stickerimport/internal/catalog"
	"pwm-server/app/tool/stickerimport/internal/native"
	"pwm-server/app/tool/stickerimport/internal/pwm"
)

type Store interface {
	BeginImport(context.Context, catalog.ImportInput) (*catalog.Import, error)
	ReplaceEmojiKeywords(context.Context, catalog.EmojiKeywordsInput) error
	ReplaceFeatured(context.Context, []catalog.FeaturedSetInput) error
	ReplaceReactions(context.Context, catalog.ReactionCatalogInput) error
	CompleteImport(context.Context, int64) error
	EnsureSet(context.Context, catalog.SetInput) (*catalog.Set, error)
	MarkSetRunning(context.Context, int64) error
	MarkSetFailed(context.Context, int64, error) error
	ReserveDocument(context.Context, catalog.DocumentInput) (*catalog.Document, error)
	MarkDocumentPersisted(context.Context, int64, int64, int64, bool) error
	MarkDocumentVerified(context.Context, int64, bool) error
	MarkDocumentFailed(context.Context, int64, error) error
	ResetDocumentForUpload(context.Context, int64, error) error
	FinalizeSet(context.Context, int64, []catalog.Pack) error
}

type Uploader interface {
	Upload(context.Context, native.DocumentSpec) (*native.Result, error)
	Verify(context.Context, int64, int64, string, [sha256.Size]byte, bool) (*mtproto.Document, error)
}

type IDGenerator interface {
	NextID(context.Context) (int64, error)
}

type Options struct {
	Workers     int
	Reverify    bool
	CatalogOnly bool
}

type Importer struct {
	store    Store
	uploader Uploader
	idgen    IDGenerator
	opts     Options
	newHash  func() (int64, error)
}

type Report struct {
	ImportID           int64 `json:"import_id"`
	SelectedSets       int   `json:"selected_sets"`
	CompletedSets      int   `json:"completed_sets"`
	UploadedDocuments  int   `json:"uploaded_documents"`
	ResumedDocuments   int   `json:"resumed_documents"`
	SkippedDocuments   int   `json:"skipped_documents"`
	VerifiedDocuments  int   `json:"verified_documents"`
	ReactionDocuments  int   `json:"reaction_documents"`
	PublishedReactions int   `json:"published_reactions"`
}

func New(store Store, uploader Uploader, idgen IDGenerator, options Options) *Importer {
	if options.Workers <= 0 {
		options.Workers = 1
	}
	return &Importer{store: store, uploader: uploader, idgen: idgen, opts: options, newHash: randomNonZeroInt64}
}

func (i *Importer) ImportSets(ctx context.Context, dataset *pwm.Dataset, fingerprint *pwm.Fingerprint, selected []int) (*Report, error) {
	if i.store == nil || i.uploader == nil || i.idgen == nil {
		return nil, errors.New("importer store, uploader and ID generator are required")
	}
	if dataset == nil || fingerprint == nil {
		return nil, errors.New("dataset and fingerprint are required")
	}
	job, err := i.store.BeginImport(ctx, catalog.ImportInput{
		DatasetVersion:  dataset.Version,
		DatasetChecksum: fingerprint.Dataset,
		SourceRoot:      dataset.Root,
		TotalSets:       dataset.Report.StickerSets,
		TotalDocuments:  dataset.Report.UniqueDocuments,
	})
	if err != nil {
		return nil, err
	}
	if err = i.store.ReplaceEmojiKeywords(ctx, catalog.EmojiKeywordsInput{
		ImportID: job.ID,
		Language: dataset.EmojiKeywords.Language,
		Version:  dataset.EmojiKeywords.Version,
		Keywords: dataset.EmojiKeywords.Keywords,
	}); err != nil {
		return nil, fmt.Errorf("publish emoji keywords: %w", err)
	}
	report := &Report{ImportID: job.ID, SelectedSets: len(selected)}
	if !i.opts.CatalogOnly {
		for _, setIndex := range selected {
			if setIndex < 0 || setIndex >= len(dataset.Sets) {
				return nil, fmt.Errorf("selected set index %d is out of range", setIndex)
			}
			if err = i.importSet(ctx, job.ID, setIndex, &dataset.Sets[setIndex], fingerprint, report); err != nil {
				return report, err
			}
			report.CompletedSets++
		}
	}
	if i.opts.CatalogOnly || selectsCompleteDataset(selected, len(dataset.Sets)) {
		if len(dataset.Reactions) > 0 {
			if err = i.importReactions(ctx, job.ID, dataset, fingerprint, report); err != nil {
				return report, err
			}
		}
		featured := make([]catalog.FeaturedSetInput, 0, len(dataset.Featured.Sets))
		for _, source := range dataset.Featured.Sets {
			entry := catalog.FeaturedSetInput{SourceSetID: source.SourceID, CoverSourceDocumentIDs: make([]int64, 0, len(source.Covers))}
			for _, cover := range source.Covers {
				entry.CoverSourceDocumentIDs = append(entry.CoverSourceDocumentIDs, cover.SourceID)
			}
			featured = append(featured, entry)
		}
		if err = i.store.ReplaceFeatured(ctx, featured); err != nil {
			return report, fmt.Errorf("publish featured sticker sets: %w", err)
		}
		if err = i.store.CompleteImport(ctx, job.ID); err != nil {
			return report, fmt.Errorf("complete sticker import: %w", err)
		}
	}
	return report, nil
}

func selectsCompleteDataset(selected []int, total int) bool {
	if len(selected) != total {
		return false
	}
	seen := make([]bool, total)
	for _, index := range selected {
		if index < 0 || index >= total || seen[index] {
			return false
		}
		seen[index] = true
	}
	return true
}

func (i *Importer) importSet(ctx context.Context, importID int64, setIndex int, source *pwm.StickerSetFile, fingerprint *pwm.Fingerprint, report *Report) error {
	candidateID, err := i.idgen.NextID(ctx)
	if err != nil {
		return fmt.Errorf("allocate native ID for source set %s: %w", source.Set.ID, err)
	}
	if candidateID <= 0 {
		return fmt.Errorf("allocate native ID for source set %s: ID must be positive", source.Set.ID)
	}
	candidateHash, err := i.newHash()
	if err != nil {
		return fmt.Errorf("allocate native access hash for source set %s: %w", source.Set.ID, err)
	}
	animated, videos, textColor := setFlags(source)
	set, err := i.store.EnsureSet(ctx, catalog.SetInput{
		ImportID:         importID,
		SourceID:         source.Set.SourceID,
		SourceAccessHash: source.Set.SourceAccessHash,
		NativeID:         candidateID,
		NativeAccessHash: candidateHash,
		ShortName:        source.Set.ShortName,
		NormalizedName:   strings.ToLower(strings.TrimSpace(source.Set.ShortName)),
		Title:            source.Set.Title,
		DocumentCount:    len(source.Stickers),
		DisplayOrder:     setIndex,
		Archived:         source.Set.IsArchived,
		Emoji:            source.Set.IsEmoji,
		Animated:         animated,
		Videos:           videos,
		TextColor:        textColor,
	})
	if err != nil {
		return err
	}
	if err = i.store.MarkSetRunning(ctx, set.ID); err != nil {
		return err
	}

	type task struct {
		index    int
		document *pwm.StickerDoc
	}
	tasks := make(chan task)
	results := make(chan documentResult, len(source.Stickers))
	workerCtx, cancel := context.WithCancel(ctx)
	defer cancel()
	workers := i.opts.Workers
	if workers > len(source.Stickers) {
		workers = len(source.Stickers)
	}
	var waitGroup sync.WaitGroup
	for worker := 0; worker < workers; worker++ {
		waitGroup.Add(1)
		go func() {
			defer waitGroup.Done()
			for item := range tasks {
				result := i.importSticker(workerCtx, importID, set, item.index, item.document, fingerprint)
				results <- result
				if result.err != nil {
					cancel()
				}
			}
		}()
	}
	go func() {
		defer close(tasks)
		for index := range source.Stickers {
			select {
			case <-workerCtx.Done():
				return
			case tasks <- task{index: index, document: &source.Stickers[index]}:
			}
		}
	}()
	waitGroup.Wait()
	close(results)

	packs := make([]catalog.Pack, 0, len(source.Stickers))
	var firstErr error
	for result := range results {
		if result.err != nil {
			if firstErr == nil {
				firstErr = result.err
			}
			continue
		}
		packs = append(packs, result.pack)
		report.UploadedDocuments += result.uploaded
		report.ResumedDocuments += result.resumed
		report.SkippedDocuments += result.skipped
		report.VerifiedDocuments++
	}
	if firstErr != nil {
		_ = i.store.MarkSetFailed(ctx, set.ID, firstErr)
		return fmt.Errorf("import source sticker set %s: %w", source.Set.ID, firstErr)
	}
	if len(packs) != len(source.Stickers) {
		err = fmt.Errorf("import source sticker set %s produced %d/%d documents", source.Set.ID, len(packs), len(source.Stickers))
		_ = i.store.MarkSetFailed(ctx, set.ID, err)
		return err
	}
	if err = i.store.FinalizeSet(ctx, set.ID, packs); err != nil {
		_ = i.store.MarkSetFailed(ctx, set.ID, err)
		return fmt.Errorf("publish source sticker set %s: %w", source.Set.ID, err)
	}
	return nil
}

func (i *Importer) importReactions(ctx context.Context, importID int64, dataset *pwm.Dataset, fingerprint *pwm.Fingerprint, report *Report) error {
	type task struct {
		index    int
		document *pwm.ReactionDocument
	}
	tasks := make(chan task)
	totalDocuments := dataset.Report.ReactionDocuments
	results := make(chan documentResult, totalDocuments)
	workerCtx, cancel := context.WithCancel(ctx)
	defer cancel()
	workers := min(i.opts.Workers, max(1, totalDocuments))
	var waitGroup sync.WaitGroup
	for worker := 0; worker < workers; worker++ {
		waitGroup.Add(1)
		go func() {
			defer waitGroup.Done()
			for item := range tasks {
				result := i.importReactionDocument(workerCtx, importID, item.document, fingerprint)
				result.pack.Order = item.index
				results <- result
				if result.err != nil {
					cancel()
				}
			}
		}()
	}
	go func() {
		defer close(tasks)
		index := 0
		for reactionIndex := range dataset.Reactions {
			for _, document := range dataset.Reactions[reactionIndex].Documents() {
				if document.ID == "" {
					continue
				}
				select {
				case <-workerCtx.Done():
					return
				case tasks <- task{index: index, document: document}:
				}
				index++
			}
		}
	}()
	waitGroup.Wait()
	close(results)

	completed := make([]bool, totalDocuments)
	var firstErr error
	for result := range results {
		if result.err != nil {
			if firstErr == nil {
				firstErr = result.err
			}
			continue
		}
		if result.pack.Order >= 0 && result.pack.Order < len(completed) {
			completed[result.pack.Order] = true
		}
		report.UploadedDocuments += result.uploaded
		report.ResumedDocuments += result.resumed
		report.SkippedDocuments += result.skipped
		report.VerifiedDocuments++
		report.ReactionDocuments++
	}
	if firstErr != nil {
		return fmt.Errorf("import PWM reaction assets: %w", firstErr)
	}
	for index, done := range completed {
		if !done {
			return fmt.Errorf("import PWM reaction assets produced %d/%d documents", index, len(completed))
		}
	}

	input := catalog.ReactionCatalogInput{ImportID: importID, Reactions: make([]catalog.ReactionInput, 0, len(dataset.Reactions))}
	for _, source := range dataset.Reactions {
		reaction := catalog.ReactionInput{
			Emoticon: source.Reaction.Emoticon, Title: source.Title,
			Inactive: source.Inactive, Premium: source.Premium,
			Documents: make([]catalog.ReactionDocumentInput, 0, len(source.Documents())),
		}
		for role, document := range source.Documents() {
			if document.ID == "" {
				continue
			}
			reaction.Documents = append(reaction.Documents, catalog.ReactionDocumentInput{Role: role + 1, SourceID: document.SourceID})
		}
		input.Reactions = append(input.Reactions, reaction)
	}
	if err := i.store.ReplaceReactions(ctx, input); err != nil {
		return fmt.Errorf("publish available reactions: %w", err)
	}
	report.PublishedReactions = len(input.Reactions)
	return nil
}

func (i *Importer) importReactionDocument(ctx context.Context, importID int64, source *pwm.ReactionDocument, fingerprint *pwm.Fingerprint) documentResult {
	checksum, ok := fingerprint.Files[source.SourcePath]
	if !ok {
		return documentResult{err: fmt.Errorf("source reaction document %s has no fingerprint", source.ID)}
	}
	var previewChecksum *[sha256.Size]byte
	if source.PreviewPath != "" {
		value, exists := fingerprint.Files[source.PreviewPath]
		if !exists {
			return documentResult{err: fmt.Errorf("preview reaction document %s has no fingerprint", source.ID)}
		}
		previewChecksum = &value
	}
	pathThumbnail := []byte(nil)
	if source.Thumbnail != nil {
		pathThumbnail = source.Thumbnail.PathBytes
	}
	record, err := i.store.ReserveDocument(ctx, catalog.DocumentInput{
		ImportID: importID, SourceID: source.SourceID, Kind: 3,
		SourcePath: source.SourcePath, SourceSize: source.SourceSize, SourceChecksum: checksum,
		PreviewPath: source.PreviewPath, PreviewSize: source.PreviewSize, PreviewChecksum: previewChecksum,
		PathThumbnail: pathThumbnail, MimeType: source.MimeType, FileName: reactionFileName(source),
		Width: source.MediaSize.Width, Height: source.MediaSize.Height, Date: source.Timestamp,
	})
	if err != nil {
		return documentResult{err: err}
	}
	result := documentResult{pack: catalog.Pack{DocumentID: record.ID}}
	expectPreview := source.PreviewPath != ""
	if record.State == catalog.DocumentVerified && record.NativeID.Valid {
		if !i.opts.Reverify {
			result.skipped = 1
			return result
		}
		if _, err = i.uploader.Verify(ctx, record.NativeID.Int64, record.NativeAccessHash.Int64, source.SourcePath, checksum, expectPreview); err != nil {
			if !errors.Is(err, native.ErrNativeIntegrity) {
				_ = i.store.MarkDocumentFailed(context.WithoutCancel(ctx), record.ID, err)
				return documentResult{err: err}
			}
			if resetErr := i.store.ResetDocumentForUpload(context.WithoutCancel(ctx), record.ID, err); resetErr != nil {
				return documentResult{err: resetErr}
			}
			record.NeedsUpload, record.NeedsVerify = true, false
		} else {
			result.resumed = 1
			return result
		}
	}
	nativeID, accessHash := record.NativeID.Int64, record.NativeAccessHash.Int64
	if record.NeedsVerify && !record.NeedsUpload {
		if _, err = i.uploader.Verify(ctx, nativeID, accessHash, source.SourcePath, checksum, expectPreview); err == nil {
			if err = i.store.MarkDocumentVerified(ctx, record.ID, expectPreview); err != nil {
				return documentResult{err: err}
			}
			result.resumed = 1
			return result
		} else if !errors.Is(err, native.ErrNativeIntegrity) {
			_ = i.store.MarkDocumentFailed(context.WithoutCancel(ctx), record.ID, err)
			return documentResult{err: err}
		}
		if resetErr := i.store.ResetDocumentForUpload(context.WithoutCancel(ctx), record.ID, err); resetErr != nil {
			return documentResult{err: resetErr}
		}
		record.NeedsUpload = true
	}
	if record.NeedsUpload {
		uploaded, uploadErr := i.uploader.Upload(ctx, native.DocumentSpec{
			SourcePath: source.SourcePath, PreviewPath: source.PreviewPath,
			FileName: reactionFileName(source), MimeType: source.MimeType,
			Attributes: reactionAttributes(source),
		})
		if uploadErr != nil {
			_ = i.store.MarkDocumentFailed(context.WithoutCancel(ctx), record.ID, uploadErr)
			return documentResult{err: uploadErr}
		}
		if uploaded.SourceChecksum != checksum {
			uploadErr = fmt.Errorf("source reaction document %s changed between fingerprint and upload", source.ID)
			_ = i.store.MarkDocumentFailed(context.WithoutCancel(ctx), record.ID, uploadErr)
			return documentResult{err: uploadErr}
		}
		nativeID, accessHash = uploaded.Document.GetId(), uploaded.Document.GetAccessHash()
		if err = i.store.MarkDocumentPersisted(ctx, record.ID, nativeID, accessHash, uploaded.PreviewPresent); err != nil {
			return documentResult{err: err}
		}
		result.uploaded = 1
	}
	if _, err = i.uploader.Verify(ctx, nativeID, accessHash, source.SourcePath, checksum, expectPreview); err != nil {
		_ = i.store.MarkDocumentFailed(context.WithoutCancel(ctx), record.ID, err)
		return documentResult{err: err}
	}
	if err = i.store.MarkDocumentVerified(ctx, record.ID, expectPreview); err != nil {
		return documentResult{err: err}
	}
	return result
}

func reactionFileName(source *pwm.ReactionDocument) string {
	if strings.TrimSpace(source.FileName) != "" {
		return source.FileName
	}
	return "reaction" + source.ID + ".tgs"
}

func reactionAttributes(source *pwm.ReactionDocument) []*mtproto.DocumentAttribute {
	attributes := []*mtproto.DocumentAttribute{
		mtproto.MakeTLDocumentAttributeImageSize(&mtproto.DocumentAttribute{
			W: source.MediaSize.Width, H: source.MediaSize.Height,
		}).To_DocumentAttribute(),
	}
	if source.MimeType == "application/x-tgsticker" {
		attributes = append(attributes, mtproto.MakeTLDocumentAttributeAnimated(&mtproto.DocumentAttribute{}).To_DocumentAttribute())
	}
	return append(attributes, mtproto.MakeTLDocumentAttributeFilename(&mtproto.DocumentAttribute{
		FileName: reactionFileName(source),
	}).To_DocumentAttribute())
}

type documentResult struct {
	pack     catalog.Pack
	uploaded int
	resumed  int
	skipped  int
	err      error
}

func (i *Importer) importSticker(ctx context.Context, importID int64, set *catalog.Set, order int, source *pwm.StickerDoc, fingerprint *pwm.Fingerprint) documentResult {
	checksum, ok := fingerprint.Files[source.SourcePath]
	if !ok {
		return documentResult{err: fmt.Errorf("source document %s has no fingerprint", source.ID)}
	}
	var previewChecksum *[sha256.Size]byte
	if source.PreviewPath != "" {
		value, exists := fingerprint.Files[source.PreviewPath]
		if !exists {
			return documentResult{err: fmt.Errorf("preview document %s has no fingerprint", source.ID)}
		}
		previewChecksum = &value
	}
	setID := set.ID
	pathThumbnail := []byte(nil)
	if source.Thumbnail != nil {
		pathThumbnail = source.Thumbnail.PathBytes
	}
	record, err := i.store.ReserveDocument(ctx, catalog.DocumentInput{
		ImportID:        importID,
		SetID:           &setID,
		SourceID:        source.SourceID,
		Kind:            documentKind(source),
		SourcePath:      source.SourcePath,
		SourceSize:      source.SourceSize,
		SourceChecksum:  checksum,
		PreviewPath:     source.PreviewPath,
		PreviewSize:     source.PreviewSize,
		PreviewChecksum: previewChecksum,
		PathThumbnail:   pathThumbnail,
		MimeType:        source.MimeType,
		FileName:        stickerFileName(source),
		Width:           source.Width,
		Height:          source.Height,
		Date:            source.Timestamp,
		Free:            source.IsFree,
		TextColor:       source.ShouldUseTextColor,
	})
	if err != nil {
		return documentResult{err: err}
	}
	result := documentResult{pack: catalog.Pack{Emoticon: source.Emoji, DocumentID: record.ID, Order: order}}
	expectPreview := source.PreviewPath != ""
	if record.State == catalog.DocumentVerified && record.NativeID.Valid {
		if !i.opts.Reverify {
			result.skipped = 1
			return result
		}
		if _, err = i.uploader.Verify(ctx, record.NativeID.Int64, record.NativeAccessHash.Int64, source.SourcePath, checksum, expectPreview); err != nil {
			if !errors.Is(err, native.ErrNativeIntegrity) {
				_ = i.store.MarkDocumentFailed(context.WithoutCancel(ctx), record.ID, err)
				return documentResult{err: err}
			}
			if resetErr := i.store.ResetDocumentForUpload(context.WithoutCancel(ctx), record.ID, err); resetErr != nil {
				return documentResult{err: resetErr}
			}
			record.NeedsUpload = true
			record.NeedsVerify = false
		} else {
			result.resumed = 1
			return result
		}
	}

	nativeID := record.NativeID.Int64
	accessHash := record.NativeAccessHash.Int64
	if record.NeedsVerify && !record.NeedsUpload {
		if _, err = i.uploader.Verify(ctx, nativeID, accessHash, source.SourcePath, checksum, expectPreview); err == nil {
			if err = i.store.MarkDocumentVerified(ctx, record.ID, expectPreview); err != nil {
				return documentResult{err: err}
			}
			result.resumed = 1
			return result
		} else if !errors.Is(err, native.ErrNativeIntegrity) {
			_ = i.store.MarkDocumentFailed(context.WithoutCancel(ctx), record.ID, err)
			return documentResult{err: err}
		}
		if resetErr := i.store.ResetDocumentForUpload(context.WithoutCancel(ctx), record.ID, err); resetErr != nil {
			return documentResult{err: resetErr}
		}
		record.NeedsUpload = true
	}
	if record.NeedsUpload {
		uploaded, uploadErr := i.uploader.Upload(ctx, native.DocumentSpec{
			SourcePath:  source.SourcePath,
			PreviewPath: source.PreviewPath,
			FileName:    stickerFileName(source),
			MimeType:    source.MimeType,
			Attributes:  stickerAttributes(source, set),
		})
		if uploadErr != nil {
			_ = i.store.MarkDocumentFailed(context.WithoutCancel(ctx), record.ID, uploadErr)
			return documentResult{err: uploadErr}
		}
		if uploaded.SourceChecksum != checksum {
			uploadErr = fmt.Errorf("source document %s changed between fingerprint and upload", source.ID)
			_ = i.store.MarkDocumentFailed(context.WithoutCancel(ctx), record.ID, uploadErr)
			return documentResult{err: uploadErr}
		}
		nativeID = uploaded.Document.GetId()
		accessHash = uploaded.Document.GetAccessHash()
		if err = i.store.MarkDocumentPersisted(ctx, record.ID, nativeID, accessHash, uploaded.PreviewPresent); err != nil {
			return documentResult{err: err}
		}
		result.uploaded = 1
	}

	if _, err = i.uploader.Verify(ctx, nativeID, accessHash, source.SourcePath, checksum, expectPreview); err != nil {
		_ = i.store.MarkDocumentFailed(context.WithoutCancel(ctx), record.ID, err)
		return documentResult{err: err}
	}
	if err = i.store.MarkDocumentVerified(ctx, record.ID, expectPreview); err != nil {
		return documentResult{err: err}
	}
	return result
}

func stickerAttributes(source *pwm.StickerDoc, set *catalog.Set) []*mtproto.DocumentAttribute {
	setRef := mtproto.MakeTLInputStickerSetID(&mtproto.InputStickerSet{
		Id:         set.NativeID,
		AccessHash: set.NativeAccessHash,
	}).To_InputStickerSet()
	attributes := []*mtproto.DocumentAttribute{
		mtproto.MakeTLDocumentAttributeImageSize(&mtproto.DocumentAttribute{
			W: source.Width,
			H: source.Height,
		}).To_DocumentAttribute(),
	}
	if source.IsCustomEmoji {
		attributes = append(attributes,
			mtproto.MakeTLDocumentAttributeCustomEmoji(&mtproto.DocumentAttribute{
				Free:       source.IsFree,
				TextColor:  source.ShouldUseTextColor,
				Alt:        source.Emoji,
				Stickerset: setRef,
			}).To_DocumentAttribute())
	} else {
		attributes = append(attributes,
			mtproto.MakeTLDocumentAttributeSticker(&mtproto.DocumentAttribute{
				Alt:        source.Emoji,
				Stickerset: setRef,
			}).To_DocumentAttribute())
	}
	attributes = append(attributes,
		mtproto.MakeTLDocumentAttributeFilename(&mtproto.DocumentAttribute{
			FileName: stickerFileName(source),
		}).To_DocumentAttribute())
	if source.IsLottie {
		attributes = append(attributes,
			mtproto.MakeTLDocumentAttributeAnimated(&mtproto.DocumentAttribute{}).To_DocumentAttribute())
	}
	return attributes
}

func stickerFileName(source *pwm.StickerDoc) string {
	if source.FileName != "" {
		return source.FileName
	}
	switch source.MimeType {
	case pwm.MIMETypeTGS:
		return "AnimatedSticker.tgs"
	case pwm.MIMETypeWebP:
		return "Sticker.webp"
	case pwm.MIMETypeWebM:
		return "Sticker.webm"
	default:
		return "Sticker.bin"
	}
}

func documentKind(source *pwm.StickerDoc) int {
	if source.IsCustomEmoji {
		return 2
	}
	return 1
}

func setFlags(source *pwm.StickerSetFile) (animated, videos, textColor bool) {
	for index := range source.Stickers {
		animated = animated || source.Stickers[index].IsLottie
		videos = videos || source.Stickers[index].IsVideo
		textColor = textColor || source.Stickers[index].ShouldUseTextColor
	}
	return
}

func randomNonZeroInt64() (int64, error) {
	var data [8]byte
	if _, err := rand.Read(data[:]); err != nil {
		return 0, err
	}
	value := int64(binary.LittleEndian.Uint64(data[:]))
	if value == 0 {
		value = 1
	}
	return value, nil
}
