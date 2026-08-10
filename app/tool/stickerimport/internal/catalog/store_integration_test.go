package catalog

import (
	"context"
	"crypto/sha256"
	"database/sql"
	"os"
	"sync"
	"testing"

	"github.com/stretchr/testify/require"
)

func TestStoreImportResumeAndTransactionalSetPublication(t *testing.T) {
	dsn := os.Getenv("TEAMGRAM_STICKERIMPORT_MYSQL_DSN")
	if dsn == "" {
		t.Skip("TEAMGRAM_STICKERIMPORT_MYSQL_DSN is not set")
	}
	db, err := sql.Open("mysql", dsn)
	require.NoError(t, err)
	defer db.Close()
	store := New(db)
	ctx := context.Background()
	require.NoError(t, store.Ping(ctx))

	datasetChecksum := sha256.Sum256([]byte("catalog-integration-dataset"))
	job, err := store.BeginImport(ctx, ImportInput{
		DatasetVersion:  "integration-1",
		DatasetChecksum: datasetChecksum,
		SourceRoot:      "/integration",
		TotalSets:       1,
		TotalDocuments:  1,
	})
	require.NoError(t, err)
	require.Equal(t, ImportRunning, job.State)
	defer func() {
		_, cleanupErr := db.ExecContext(context.Background(), `
DELETE FROM featured_sticker_sets
WHERE sticker_set_id IN (SELECT id FROM sticker_sets WHERE import_id = ?)`, job.ID)
		require.NoError(t, cleanupErr)
		_, cleanupErr = db.ExecContext(context.Background(), `
DELETE FROM sticker_packs
WHERE sticker_set_id IN (SELECT id FROM sticker_sets WHERE import_id = ?)`, job.ID)
		require.NoError(t, cleanupErr)
		_, cleanupErr = db.ExecContext(context.Background(), `DELETE FROM sticker_documents WHERE import_id = ?`, job.ID)
		require.NoError(t, cleanupErr)
		_, cleanupErr = db.ExecContext(context.Background(), `DELETE FROM sticker_sets WHERE import_id = ?`, job.ID)
		require.NoError(t, cleanupErr)
		_, cleanupErr = db.ExecContext(context.Background(), `DELETE FROM emoji_keywords WHERE import_id = ?`, job.ID)
		require.NoError(t, cleanupErr)
		_, cleanupErr = db.ExecContext(context.Background(), `DELETE FROM sticker_imports WHERE id = ?`, job.ID)
		require.NoError(t, cleanupErr)
	}()
	sameJob, err := store.BeginImport(ctx, ImportInput{
		DatasetVersion:  "integration-1",
		DatasetChecksum: datasetChecksum,
		SourceRoot:      "/integration-moved",
		TotalSets:       1,
		TotalDocuments:  1,
	})
	require.NoError(t, err)
	require.Equal(t, job.ID, sameJob.ID)
	require.NoError(t, store.ReplaceEmojiKeywords(ctx, EmojiKeywordsInput{
		ImportID: job.ID, Language: "vi", Version: 7,
		Keywords: map[string][]string{
			"vui": {"😀", "🙂"}, "curacao": {"🇨🇼"}, "curaçao": {"🇨🇼"},
			"magic": {"🪄"}, "magic\u00a0": {"🪄"},
		},
	}))
	var emojiMappings int
	require.NoError(t, db.QueryRowContext(ctx, `
SELECT COUNT(*) FROM emoji_keywords WHERE language_code = 'vi' AND version = 7`).Scan(&emojiMappings))
	require.Equal(t, 5, emojiMappings, "preserve accent variants while deduplicating semantically identical trimmed mappings")

	set, err := store.EnsureSet(ctx, SetInput{
		ImportID: job.ID, SourceID: 60001, SourceAccessHash: 60002,
		NativeID: 70001, NativeAccessHash: 70002,
		ShortName: "IntegrationPack", NormalizedName: "integrationpack", Title: "Integration Pack",
		DocumentCount: 1,
	})
	require.NoError(t, err)
	require.NoError(t, store.MarkSetRunning(ctx, set.ID))
	_, err = store.EnsureSet(ctx, SetInput{
		ImportID: job.ID, SourceID: 60003, SourceAccessHash: 60004,
		NativeID: 70003, NativeAccessHash: 70004,
		ShortName: "IntegrationPack", NormalizedName: "integrationpack", Title: "Conflicting Pack",
	})
	require.Error(t, err, "a short-name collision must not update another source set")
	var conflictingSets int
	require.NoError(t, db.QueryRowContext(ctx, `SELECT COUNT(*) FROM sticker_sets WHERE source_set_id = 60003`).Scan(&conflictingSets))
	require.Zero(t, conflictingSets)

	// Exercise the production worker pattern: distinct source documents for one
	// set are reserved concurrently. Missing-key gap locks previously deadlocked
	// here even though no two workers shared a source document ID.
	concurrentChecksum := sha256.Sum256([]byte("concurrent-source"))
	const concurrentDocuments = 32
	errCh := make(chan error, concurrentDocuments)
	var wg sync.WaitGroup
	for i := 0; i < concurrentDocuments; i++ {
		wg.Add(1)
		go func(index int) {
			defer wg.Done()
			_, reserveErr := store.ReserveDocument(ctx, DocumentInput{
				ImportID: job.ID, SetID: &set.ID, SourceID: int64(81000 + index), Kind: 1,
				SourcePath: "/integration/concurrent.tgs", SourceSize: 17, SourceChecksum: concurrentChecksum,
				MimeType: "application/x-tgsticker", FileName: "Concurrent.tgs", Width: 512, Height: 512,
			})
			errCh <- reserveErr
		}(i)
	}
	wg.Wait()
	close(errCh)
	for reserveErr := range errCh {
		require.NoError(t, reserveErr)
	}

	sourceChecksum := sha256.Sum256([]byte("source-v1"))
	previewChecksum := sha256.Sum256([]byte("preview-v1"))
	record, err := store.ReserveDocument(ctx, DocumentInput{
		ImportID: job.ID, SetID: &set.ID, SourceID: 80001, Kind: 1,
		SourcePath: "/integration/sticker.tgs", SourceSize: 9, SourceChecksum: sourceChecksum,
		PreviewPath: "/integration/sticker.webp", PreviewSize: 7, PreviewChecksum: &previewChecksum,
		PathThumbnail: []byte{1, 2, 3}, MimeType: "application/x-tgsticker",
		FileName: "AnimatedSticker.tgs", Width: 512, Height: 512,
	})
	require.NoError(t, err)
	require.True(t, record.NeedsUpload)
	require.NoError(t, store.MarkDocumentPersisted(ctx, record.ID, 90001, 90002, true))

	resumed, err := store.ReserveDocument(ctx, DocumentInput{
		ImportID: job.ID, SetID: &set.ID, SourceID: 80001, Kind: 1,
		SourcePath: "/integration/sticker.tgs", SourceSize: 9, SourceChecksum: sourceChecksum,
		PreviewPath: "/integration/sticker.webp", PreviewSize: 7, PreviewChecksum: &previewChecksum,
		PathThumbnail: []byte{1, 2, 3}, MimeType: "application/x-tgsticker",
		FileName: "AnimatedSticker.tgs", Width: 512, Height: 512,
	})
	require.NoError(t, err)
	require.False(t, resumed.NeedsUpload)
	require.True(t, resumed.NeedsVerify)
	require.Equal(t, int64(90001), resumed.NativeID.Int64)
	require.NoError(t, store.MarkDocumentVerified(ctx, record.ID, true))
	require.NoError(t, store.FinalizeSet(ctx, set.ID, []Pack{{Emoticon: "😀", DocumentID: record.ID}}))
	require.NoError(t, store.ReplaceFeatured(ctx, []FeaturedSetInput{{
		SourceSetID: 60001, CoverSourceDocumentIDs: []int64{80001},
	}}))

	var setState, documentState, previewState, packCount, featuredCount, coverCount int
	var setHash int64
	require.NoError(t, db.QueryRowContext(ctx, `SELECT import_state, set_hash FROM sticker_sets WHERE id = ?`, set.ID).Scan(&setState, &setHash))
	require.NoError(t, db.QueryRowContext(ctx, `SELECT import_state, preview_import_state FROM sticker_documents WHERE id = ?`, record.ID).Scan(&documentState, &previewState))
	require.NoError(t, db.QueryRowContext(ctx, `SELECT COUNT(*) FROM sticker_packs WHERE sticker_set_id = ?`, set.ID).Scan(&packCount))
	require.NoError(t, db.QueryRowContext(ctx, `SELECT COUNT(*) FROM featured_sticker_sets WHERE sticker_set_id = ?`, set.ID).Scan(&featuredCount))
	require.NoError(t, db.QueryRowContext(ctx, `
SELECT COUNT(*) FROM featured_sticker_set_covers fc
JOIN featured_sticker_sets fs ON fs.id = fc.featured_sticker_set_id
WHERE fs.sticker_set_id = ?`, set.ID).Scan(&coverCount))
	require.Equal(t, SetComplete, setState)
	require.Equal(t, DocumentVerified, documentState)
	require.Equal(t, PreviewVerified, previewState)
	require.Equal(t, 1, packCount)
	require.Equal(t, 1, featuredCount)
	require.Equal(t, 1, coverCount)
	require.Equal(t, int64(90001), setHash)

	changedChecksum := sha256.Sum256([]byte("source-v2"))
	changed, err := store.ReserveDocument(ctx, DocumentInput{
		ImportID: job.ID, SetID: &set.ID, SourceID: 80001, Kind: 1,
		SourcePath: "/integration/sticker.tgs", SourceSize: 9, SourceChecksum: changedChecksum,
		MimeType: "application/x-tgsticker", FileName: "AnimatedSticker.tgs", Width: 512, Height: 512,
	})
	require.NoError(t, err)
	require.True(t, changed.NeedsUpload)
	require.False(t, changed.NativeID.Valid)
}

func TestStorePublishesVerifiedReactionRolesAndCompletesImport(t *testing.T) {
	dsn := os.Getenv("TEAMGRAM_STICKERIMPORT_MYSQL_DSN")
	if dsn == "" {
		t.Skip("TEAMGRAM_STICKERIMPORT_MYSQL_DSN is not set")
	}
	db, err := sql.Open("mysql", dsn)
	require.NoError(t, err)
	defer db.Close()
	store := New(db)
	ctx := context.Background()
	checksum := sha256.Sum256([]byte("reaction-catalog-integration"))
	job, err := store.BeginImport(ctx, ImportInput{
		DatasetVersion: "reaction-integration-1", DatasetChecksum: checksum,
		SourceRoot: "/reaction-integration", TotalDocuments: 5,
	})
	require.NoError(t, err)
	defer func() {
		_, _ = db.ExecContext(ctx, `DELETE FROM available_reactions WHERE import_id = ?`, job.ID)
		_, _ = db.ExecContext(ctx, `DELETE FROM sticker_documents WHERE import_id = ?`, job.ID)
		_, _ = db.ExecContext(ctx, `DELETE FROM sticker_imports WHERE id = ?`, job.ID)
	}()
	documents := make([]ReactionDocumentInput, 0, 5)
	for role := 1; role <= 5; role++ {
		sourceID := int64(970000000 + role)
		sourceChecksum := sha256.Sum256([]byte{byte(role)})
		record, reserveErr := store.ReserveDocument(ctx, DocumentInput{
			ImportID: job.ID, SourceID: sourceID, Kind: 3,
			SourcePath: "/reaction-integration/reaction.tgs", SourceSize: 10,
			SourceChecksum: sourceChecksum, MimeType: "application/x-tgsticker",
			FileName: "AnimatedSticker.tgs", Width: 128, Height: 128,
		})
		require.NoError(t, reserveErr)
		require.NoError(t, store.MarkDocumentPersisted(ctx, record.ID, 980000000+int64(role), 990000000+int64(role), false))
		require.NoError(t, store.MarkDocumentVerified(ctx, record.ID, false))
		documents = append(documents, ReactionDocumentInput{Role: role, SourceID: sourceID})
	}
	require.NoError(t, store.ReplaceReactions(ctx, ReactionCatalogInput{
		ImportID:  job.ID,
		Reactions: []ReactionInput{{Emoticon: "👍", Title: "Like", Documents: documents}},
	}))
	var reactionCount, roleCount int
	require.NoError(t, db.QueryRowContext(ctx, `SELECT COUNT(*) FROM available_reactions WHERE import_id = ?`, job.ID).Scan(&reactionCount))
	require.NoError(t, db.QueryRowContext(ctx, `
SELECT COUNT(*)
FROM available_reaction_documents ard
JOIN available_reactions ar ON ar.id = ard.available_reaction_id
WHERE ar.import_id = ?`, job.ID).Scan(&roleCount))
	require.Equal(t, 1, reactionCount)
	require.Equal(t, 5, roleCount)
	require.NoError(t, store.CompleteImport(ctx, job.ID))
	var state, imported int
	require.NoError(t, db.QueryRowContext(ctx, `SELECT state, imported_documents FROM sticker_imports WHERE id = ?`, job.ID).Scan(&state, &imported))
	require.Equal(t, ImportComplete, state)
	require.Equal(t, 5, imported)
}
