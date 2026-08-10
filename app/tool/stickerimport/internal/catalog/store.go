package catalog

import (
	"bytes"
	"context"
	"database/sql"
	"errors"
	"fmt"
	"sort"
	"strings"
	"time"

	mysql "github.com/go-sql-driver/mysql"
)

const (
	ImportValidated = 0
	ImportRunning   = 1
	ImportComplete  = 2
	ImportFailed    = 3

	SetPending  = 0
	SetRunning  = 1
	SetComplete = 2
	SetFailed   = 3

	DocumentPending     = 0
	DocumentStaged      = 1
	DocumentPersisted   = 2
	DocumentVerified    = 3
	DocumentFailed      = 4
	DocumentUnsupported = 5

	PreviewAbsent    = 0
	PreviewPending   = 1
	PreviewPersisted = 2
	PreviewVerified  = 3
	PreviewFailed    = 4
)

type Store struct {
	db *sql.DB
}

type DBOptions struct {
	MaxOpenConns    int
	MaxIdleConns    int
	ConnMaxLifetime time.Duration
}

func Open(dsn string, options DBOptions) (*Store, error) {
	if dsn == "" {
		return nil, errors.New("MySQL DSN is required")
	}
	db, err := sql.Open("mysql", dsn)
	if err != nil {
		return nil, err
	}
	if options.MaxOpenConns > 0 {
		db.SetMaxOpenConns(options.MaxOpenConns)
	}
	if options.MaxIdleConns > 0 {
		db.SetMaxIdleConns(options.MaxIdleConns)
	}
	if options.ConnMaxLifetime > 0 {
		db.SetConnMaxLifetime(options.ConnMaxLifetime)
	}
	return &Store{db: db}, nil
}

func New(db *sql.DB) *Store {
	return &Store{db: db}
}

func (s *Store) Close() error {
	if s == nil || s.db == nil {
		return nil
	}
	return s.db.Close()
}

func (s *Store) Ping(ctx context.Context) error {
	if s == nil || s.db == nil {
		return errors.New("catalog store is not configured")
	}
	return s.db.PingContext(ctx)
}

type ImportInput struct {
	DatasetVersion  string
	DatasetChecksum [32]byte
	SourceRoot      string
	TotalSets       int
	TotalDocuments  int
}

type Import struct {
	ID    int64
	State int
}

func (s *Store) BeginImport(ctx context.Context, input ImportInput) (*Import, error) {
	result, err := s.db.ExecContext(ctx, `
INSERT INTO sticker_imports
  (dataset_version, dataset_checksum, source_root, state, total_sets, total_documents, started_at)
VALUES (?, ?, ?, ?, ?, ?, CURRENT_TIMESTAMP)
ON DUPLICATE KEY UPDATE
  id = LAST_INSERT_ID(id), source_root = VALUES(source_root),
  total_sets = VALUES(total_sets), total_documents = VALUES(total_documents)`,
		input.DatasetVersion, input.DatasetChecksum[:], input.SourceRoot, ImportRunning,
		input.TotalSets, input.TotalDocuments)
	if err != nil {
		return nil, fmt.Errorf("begin sticker import: %w", err)
	}
	id, err := result.LastInsertId()
	if err != nil {
		return nil, fmt.Errorf("resolve sticker import ID: %w", err)
	}
	var state int
	if err = s.db.QueryRowContext(ctx, `SELECT state FROM sticker_imports WHERE id = ?`, id).Scan(&state); err != nil {
		return nil, fmt.Errorf("read sticker import state: %w", err)
	}
	if state == ImportValidated || state == ImportFailed {
		if _, err = s.db.ExecContext(ctx, `
UPDATE sticker_imports
SET state = ?, last_error = '', started_at = COALESCE(started_at, CURRENT_TIMESTAMP), completed_at = NULL
WHERE id = ?`, ImportRunning, id); err != nil {
			return nil, fmt.Errorf("resume sticker import: %w", err)
		}
		state = ImportRunning
	}
	return &Import{ID: id, State: state}, nil
}

type SetInput struct {
	ImportID         int64
	SourceID         int64
	SourceAccessHash int64
	NativeID         int64
	NativeAccessHash int64
	ShortName        string
	NormalizedName   string
	Title            string
	DocumentCount    int
	DisplayOrder     int
	Archived         bool
	Emoji            bool
	Animated         bool
	Videos           bool
	TextColor        bool
}

type Set struct {
	ID               int64
	NativeID         int64
	NativeAccessHash int64
	State            int
}

func (s *Store) EnsureSet(ctx context.Context, input SetInput) (*Set, error) {
	tx, err := s.db.BeginTx(ctx, nil)
	if err != nil {
		return nil, err
	}
	defer func() { _ = tx.Rollback() }()
	set := &Set{}
	err = tx.QueryRowContext(ctx, `
SELECT id, native_set_id, native_access_hash, import_state
FROM sticker_sets WHERE source_set_id = ? FOR UPDATE`, input.SourceID).Scan(
		&set.ID, &set.NativeID, &set.NativeAccessHash, &set.State)
	if errors.Is(err, sql.ErrNoRows) {
		result, insertErr := tx.ExecContext(ctx, `
INSERT INTO sticker_sets
  (import_id, source_set_id, source_access_hash, native_set_id, native_access_hash,
   short_name, short_name_normalized, title, document_count, display_order,
   archived, emojis, animated, videos, text_color, import_state)
VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)`,
			input.ImportID, input.SourceID, input.SourceAccessHash, input.NativeID, input.NativeAccessHash,
			input.ShortName, input.NormalizedName, input.Title, input.DocumentCount, input.DisplayOrder,
			input.Archived, input.Emoji, input.Animated, input.Videos, input.TextColor, SetPending)
		if insertErr != nil {
			return nil, fmt.Errorf("insert source sticker set %d: %w", input.SourceID, insertErr)
		}
		set.ID, insertErr = result.LastInsertId()
		if insertErr != nil {
			return nil, insertErr
		}
		set.NativeID = input.NativeID
		set.NativeAccessHash = input.NativeAccessHash
		set.State = SetPending
	} else if err != nil {
		return nil, fmt.Errorf("lock source sticker set %d: %w", input.SourceID, err)
	} else {
		if _, err = tx.ExecContext(ctx, `
UPDATE sticker_sets
SET import_id = ?, source_access_hash = ?, short_name = ?, short_name_normalized = ?,
    title = ?, document_count = ?, display_order = ?, archived = ?, emojis = ?,
    animated = ?, videos = ?, text_color = ?, last_error = ''
WHERE id = ?`,
			input.ImportID, input.SourceAccessHash, input.ShortName, input.NormalizedName,
			input.Title, input.DocumentCount, input.DisplayOrder, input.Archived, input.Emoji,
			input.Animated, input.Videos, input.TextColor, set.ID); err != nil {
			return nil, fmt.Errorf("update source sticker set %d: %w", input.SourceID, err)
		}
	}
	if err = tx.Commit(); err != nil {
		return nil, err
	}
	return set, nil
}

type DocumentInput struct {
	ImportID        int64
	SetID           *int64
	SourceID        int64
	Kind            int
	SourcePath      string
	SourceSize      int64
	SourceChecksum  [32]byte
	PreviewPath     string
	PreviewSize     int64
	PreviewChecksum *[32]byte
	PathThumbnail   []byte
	MimeType        string
	FileName        string
	Width           int32
	Height          int32
	Date            int32
	Free            bool
	TextColor       bool
}

type Document struct {
	ID               int64
	NativeID         sql.NullInt64
	NativeAccessHash sql.NullInt64
	State            int
	PreviewState     int
	NeedsUpload      bool
	NeedsVerify      bool
}

func (s *Store) ReserveDocument(ctx context.Context, input DocumentInput) (*Document, error) {
	const maxAttempts = 5
	var lastErr error
	for attempt := 0; attempt < maxAttempts; attempt++ {
		document, err := s.reserveDocument(ctx, input)
		if err == nil {
			return document, nil
		}
		lastErr = err
		if !isRetryableMySQLError(err) || attempt == maxAttempts-1 {
			return nil, err
		}
		delay := time.Duration(attempt+1) * 10 * time.Millisecond
		timer := time.NewTimer(delay)
		select {
		case <-ctx.Done():
			timer.Stop()
			return nil, ctx.Err()
		case <-timer.C:
		}
	}
	return nil, lastErr
}

func (s *Store) reserveDocument(ctx context.Context, input DocumentInput) (*Document, error) {
	previewChecksum := checksumBytes(input.PreviewChecksum)
	previewState := PreviewAbsent
	if input.PreviewPath != "" {
		previewState = PreviewPending
	}

	// Materialize the row before taking a record lock. SELECT ... FOR UPDATE on a
	// missing unique key takes an InnoDB gap lock; many importer workers doing
	// that concurrently can deadlock even when their source IDs are different.
	// LAST_INSERT_ID(id) resolves both the inserted and already-existing row.
	result, err := s.db.ExecContext(ctx, `
INSERT INTO sticker_documents
  (import_id, sticker_set_id, source_document_id, document_kind,
   source_path, source_size, source_checksum,
   preview_source_path, preview_source_size, preview_source_checksum,
   path_thumbnail_bytes, mime_type, file_name, width, height, date2,
   free, text_color, import_state, preview_import_state)
VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
ON DUPLICATE KEY UPDATE id = LAST_INSERT_ID(id)`,
		input.ImportID, input.SetID, input.SourceID, input.Kind,
		input.SourcePath, input.SourceSize, input.SourceChecksum[:],
		input.PreviewPath, input.PreviewSize, previewChecksum,
		input.PathThumbnail, input.MimeType, input.FileName, input.Width, input.Height, input.Date,
		input.Free, input.TextColor, DocumentPending, previewState)
	if err != nil {
		return nil, fmt.Errorf("materialize source document %d: %w", input.SourceID, err)
	}
	documentID, err := result.LastInsertId()
	if err != nil {
		return nil, fmt.Errorf("resolve source document %d: %w", input.SourceID, err)
	}

	tx, err := s.db.BeginTx(ctx, nil)
	if err != nil {
		return nil, err
	}
	defer func() { _ = tx.Rollback() }()

	existing, err := selectDocumentByIDForUpdate(ctx, tx, documentID)
	if err != nil {
		return nil, fmt.Errorf("lock source document %d: %w", input.SourceID, err)
	}
	unchanged := bytes.Equal(existing.SourceChecksum, input.SourceChecksum[:]) &&
		bytes.Equal(existing.PreviewChecksum, previewChecksum)
	state := existing.State
	newPreviewState := existing.PreviewState
	if !unchanged {
		state = DocumentPending
		newPreviewState = previewState
		existing.NativeID = sql.NullInt64{}
		existing.NativeAccessHash = sql.NullInt64{}
	}
	_, updateErr := tx.ExecContext(ctx, `
UPDATE sticker_documents
SET import_id = ?, sticker_set_id = ?, document_kind = ?,
    source_path = ?, source_size = ?, source_checksum = ?,
    preview_source_path = ?, preview_source_size = ?, preview_source_checksum = ?,
    path_thumbnail_bytes = ?, mime_type = ?, file_name = ?, width = ?, height = ?,
    date2 = ?, free = ?, text_color = ?,
    native_document_id = ?, native_access_hash = ?, import_state = ?, preview_import_state = ?,
    last_error = ''
WHERE id = ?`,
		input.ImportID, input.SetID, input.Kind,
		input.SourcePath, input.SourceSize, input.SourceChecksum[:],
		input.PreviewPath, input.PreviewSize, previewChecksum,
		input.PathThumbnail, input.MimeType, input.FileName, input.Width, input.Height,
		input.Date, input.Free, input.TextColor,
		nullValue(existing.NativeID), nullValue(existing.NativeAccessHash), state, newPreviewState,
		existing.ID)
	if updateErr != nil {
		return nil, fmt.Errorf("refresh source document %d: %w", input.SourceID, updateErr)
	}
	existing.State = state
	existing.PreviewState = newPreviewState
	if err = tx.Commit(); err != nil {
		return nil, err
	}
	return &Document{
		ID:               existing.ID,
		NativeID:         existing.NativeID,
		NativeAccessHash: existing.NativeAccessHash,
		State:            existing.State,
		PreviewState:     existing.PreviewState,
		NeedsUpload:      !existing.NativeID.Valid,
		NeedsVerify:      existing.NativeID.Valid && existing.State != DocumentVerified,
	}, nil
}

type documentRow struct {
	ID               int64
	NativeID         sql.NullInt64
	NativeAccessHash sql.NullInt64
	State            int
	PreviewState     int
	SourceChecksum   []byte
	PreviewChecksum  []byte
}

func selectDocumentByIDForUpdate(ctx context.Context, tx *sql.Tx, id int64) (*documentRow, error) {
	row := &documentRow{}
	err := tx.QueryRowContext(ctx, `
SELECT id, native_document_id, native_access_hash, import_state, preview_import_state,
       source_checksum, preview_source_checksum
FROM sticker_documents WHERE id = ? FOR UPDATE`, id).Scan(
		&row.ID, &row.NativeID, &row.NativeAccessHash, &row.State, &row.PreviewState,
		&row.SourceChecksum, &row.PreviewChecksum)
	return row, err
}

func isRetryableMySQLError(err error) bool {
	var mysqlErr *mysql.MySQLError
	if !errors.As(err, &mysqlErr) {
		return false
	}
	return mysqlErr.Number == 1205 || mysqlErr.Number == 1213
}

func (s *Store) MarkDocumentPersisted(ctx context.Context, id, nativeID, accessHash int64, hasPreview bool) error {
	previewState := PreviewAbsent
	thumbType := ""
	if hasPreview {
		previewState = PreviewPersisted
		thumbType = "m"
	}
	result, err := s.db.ExecContext(ctx, `
UPDATE sticker_documents
SET native_document_id = ?, native_access_hash = ?, import_state = ?,
    native_thumb_size_type = ?, preview_import_state = ?, attempt_count = attempt_count + 1,
    last_error = ''
WHERE id = ?`, nativeID, accessHash, DocumentPersisted, thumbType, previewState, id)
	if err != nil {
		return fmt.Errorf("mark document %d persisted: %w", id, err)
	}
	return requireOneRow(result, "mark document persisted")
}

func (s *Store) MarkDocumentVerified(ctx context.Context, id int64, hasPreview bool) error {
	previewState := PreviewAbsent
	if hasPreview {
		previewState = PreviewVerified
	}
	result, err := s.db.ExecContext(ctx, `
UPDATE sticker_documents
SET import_state = ?, preview_import_state = ?, last_error = ''
WHERE id = ? AND native_document_id IS NOT NULL`, DocumentVerified, previewState, id)
	if err != nil {
		return fmt.Errorf("mark document %d verified: %w", id, err)
	}
	return requireOneRow(result, "mark document verified")
}

func (s *Store) MarkDocumentFailed(ctx context.Context, id int64, cause error) error {
	message := truncateError(cause)
	_, err := s.db.ExecContext(ctx, `
UPDATE sticker_documents
SET import_state = ?, preview_import_state = IF(preview_import_state = 0, 0, ?),
    attempt_count = attempt_count + 1, last_error = ?
WHERE id = ?`, DocumentFailed, PreviewFailed, message, id)
	return err
}

func (s *Store) ResetDocumentForUpload(ctx context.Context, id int64, cause error) error {
	result, err := s.db.ExecContext(ctx, `
UPDATE sticker_documents
SET native_document_id = NULL, native_access_hash = NULL, native_thumb_size_type = '',
    import_state = ?, preview_import_state = IF(preview_source_path = '', ?, ?),
    attempt_count = attempt_count + 1, last_error = ?
WHERE id = ?`, DocumentPending, PreviewAbsent, PreviewPending, truncateError(cause), id)
	if err != nil {
		return fmt.Errorf("reset document %d for native repair: %w", id, err)
	}
	return requireOneRow(result, "reset document for native repair")
}

type Pack struct {
	Emoticon   string
	DocumentID int64
	Order      int
}

type EmojiKeywordsInput struct {
	ImportID int64
	Language string
	Version  int32
	Keywords map[string][]string
}

type FeaturedSetInput struct {
	SourceSetID            int64
	CoverSourceDocumentIDs []int64
}

type ReactionInput struct {
	Emoticon  string
	Title     string
	Inactive  bool
	Premium   bool
	Documents []ReactionDocumentInput
}

type ReactionDocumentInput struct {
	Role     int
	SourceID int64
}

type ReactionCatalogInput struct {
	ImportID  int64
	Reactions []ReactionInput
}

func (s *Store) ReplaceReactions(ctx context.Context, input ReactionCatalogInput) error {
	if input.ImportID <= 0 || len(input.Reactions) == 0 {
		return errors.New("reaction import ID and catalog are required")
	}
	tx, err := s.db.BeginTx(ctx, nil)
	if err != nil {
		return err
	}
	defer func() { _ = tx.Rollback() }()
	type nativeReaction struct {
		source    ReactionInput
		documents []struct {
			role int
			id   int64
		}
		hash int64
	}
	native := make([]nativeReaction, 0, len(input.Reactions))
	seen := make(map[string]struct{}, len(input.Reactions))
	for _, source := range input.Reactions {
		emoticon := strings.TrimSpace(source.Emoticon)
		if emoticon == "" || strings.TrimSpace(source.Title) == "" || len(source.Documents) < 5 || len(source.Documents) > 7 {
			return errors.New("every available reaction requires emoticon, title and five mandatory document roles")
		}
		if _, duplicate := seen[emoticon]; duplicate {
			return fmt.Errorf("duplicate available reaction %q", emoticon)
		}
		seen[emoticon] = struct{}{}
		entry := nativeReaction{source: source}
		roles := make(map[int]struct{}, len(source.Documents))
		for _, sourceDocument := range source.Documents {
			if sourceDocument.Role < 1 || sourceDocument.Role > 7 {
				return fmt.Errorf("available reaction %q has invalid role %d", emoticon, sourceDocument.Role)
			}
			if _, duplicate := roles[sourceDocument.Role]; duplicate {
				return fmt.Errorf("available reaction %q repeats role %d", emoticon, sourceDocument.Role)
			}
			roles[sourceDocument.Role] = struct{}{}
			var documentID, nativeID int64
			if err = tx.QueryRowContext(ctx, `
SELECT id, native_document_id
FROM sticker_documents
WHERE import_id = ? AND source_document_id = ? AND document_kind = 3
  AND import_state = ? AND native_document_id IS NOT NULL`,
				input.ImportID, sourceDocument.SourceID, DocumentVerified).Scan(&documentID, &nativeID); err != nil {
				return fmt.Errorf("resolve reaction %q source document %d: %w", emoticon, sourceDocument.SourceID, err)
			}
			entry.documents = append(entry.documents, struct {
				role int
				id   int64
			}{role: sourceDocument.Role, id: documentID})
			entry.hash = entry.hash*20261 + nativeID
		}
		for mandatory := 1; mandatory <= 5; mandatory++ {
			if _, exists := roles[mandatory]; !exists {
				return fmt.Errorf("available reaction %q is missing mandatory role %d", emoticon, mandatory)
			}
		}
		native = append(native, entry)
	}
	if _, err = tx.ExecContext(ctx, `DELETE FROM available_reactions`); err != nil {
		return fmt.Errorf("replace available reactions: %w", err)
	}
	for order, entry := range native {
		result, insertErr := tx.ExecContext(ctx, `
INSERT INTO available_reactions
  (import_id, emoticon, title, inactive, premium, display_order, reaction_hash)
VALUES (?, ?, ?, ?, ?, ?, ?)`, input.ImportID, strings.TrimSpace(entry.source.Emoticon),
			strings.TrimSpace(entry.source.Title), entry.source.Inactive, entry.source.Premium, order, entry.hash)
		if insertErr != nil {
			return fmt.Errorf("publish available reaction %q: %w", entry.source.Emoticon, insertErr)
		}
		reactionID, idErr := result.LastInsertId()
		if idErr != nil {
			return idErr
		}
		for _, document := range entry.documents {
			if _, insertErr = tx.ExecContext(ctx, `
INSERT INTO available_reaction_documents
  (available_reaction_id, role, sticker_document_id)
VALUES (?, ?, ?)`, reactionID, document.role, document.id); insertErr != nil {
				return fmt.Errorf("publish available reaction %q role %d: %w", entry.source.Emoticon, document.role, insertErr)
			}
		}
	}
	return tx.Commit()
}

func (s *Store) CompleteImport(ctx context.Context, importID int64) error {
	if importID <= 0 {
		return errors.New("import ID is required")
	}
	var expected, verified, failed int
	if err := s.db.QueryRowContext(ctx, `
SELECT si.total_documents,
       SUM(sd.import_state = ?),
       SUM(sd.import_state = ?)
FROM sticker_imports si
LEFT JOIN sticker_documents sd ON sd.import_id = si.id
WHERE si.id = ?
GROUP BY si.id, si.total_documents`, DocumentVerified, DocumentFailed, importID).Scan(&expected, &verified, &failed); err != nil {
		return fmt.Errorf("audit completed import %d: %w", importID, err)
	}
	if verified != expected || failed != 0 {
		return fmt.Errorf("import %d is incomplete: verified=%d expected=%d failed=%d", importID, verified, expected, failed)
	}
	result, err := s.db.ExecContext(ctx, `
UPDATE sticker_imports
SET state = ?, imported_documents = ?, failed_documents = 0,
    last_error = '', completed_at = CURRENT_TIMESTAMP
WHERE id = ?`, ImportComplete, verified, importID)
	if err != nil {
		return fmt.Errorf("complete import %d: %w", importID, err)
	}
	return requireOneRow(result, "complete import")
}

func (s *Store) ReplaceFeatured(ctx context.Context, featured []FeaturedSetInput) error {
	tx, err := s.db.BeginTx(ctx, nil)
	if err != nil {
		return err
	}
	defer func() { _ = tx.Rollback() }()
	type nativeFeatured struct {
		setID    int64
		coverIDs []int64
	}
	native := make([]nativeFeatured, 0, len(featured))
	for _, source := range featured {
		var setID int64
		if err = tx.QueryRowContext(ctx, `
SELECT id FROM sticker_sets WHERE source_set_id = ? AND import_state = ?`, source.SourceSetID, SetComplete).Scan(&setID); err != nil {
			return fmt.Errorf("resolve featured source set %d: %w", source.SourceSetID, err)
		}
		entry := nativeFeatured{setID: setID, coverIDs: make([]int64, 0, len(source.CoverSourceDocumentIDs))}
		for _, sourceDocumentID := range source.CoverSourceDocumentIDs {
			var documentID int64
			if err = tx.QueryRowContext(ctx, `
SELECT id FROM sticker_documents
WHERE source_document_id = ? AND sticker_set_id = ? AND import_state = ?`, sourceDocumentID, setID, DocumentVerified).Scan(&documentID); err != nil {
				return fmt.Errorf("resolve featured source set %d cover %d: %w", source.SourceSetID, sourceDocumentID, err)
			}
			entry.coverIDs = append(entry.coverIDs, documentID)
		}
		native = append(native, entry)
	}
	if _, err = tx.ExecContext(ctx, `DELETE FROM featured_sticker_sets WHERE category = 1`); err != nil {
		return err
	}
	for order, entry := range native {
		result, insertErr := tx.ExecContext(ctx, `
INSERT INTO featured_sticker_sets (sticker_set_id, category, display_order)
VALUES (?, 1, ?)`, entry.setID, order)
		if insertErr != nil {
			return fmt.Errorf("publish featured sticker set %d: %w", entry.setID, insertErr)
		}
		featuredID, idErr := result.LastInsertId()
		if idErr != nil {
			return idErr
		}
		for coverOrder, documentID := range entry.coverIDs {
			if _, insertErr = tx.ExecContext(ctx, `
INSERT INTO featured_sticker_set_covers
  (featured_sticker_set_id, sticker_document_id, order2)
VALUES (?, ?, ?)`, featuredID, documentID, coverOrder); insertErr != nil {
				return fmt.Errorf("publish featured sticker set %d cover %d: %w", entry.setID, documentID, insertErr)
			}
		}
	}
	return tx.Commit()
}

func (s *Store) ReplaceEmojiKeywords(ctx context.Context, input EmojiKeywordsInput) error {
	if input.ImportID <= 0 || strings.TrimSpace(input.Language) == "" || input.Version <= 0 {
		return errors.New("emoji keyword import ID, language and version are required")
	}
	tx, err := s.db.BeginTx(ctx, nil)
	if err != nil {
		return err
	}
	defer func() { _ = tx.Rollback() }()
	if _, err = tx.ExecContext(ctx, `DELETE FROM emoji_keywords WHERE language_code = ? AND version = ?`, input.Language, input.Version); err != nil {
		return fmt.Errorf("replace emoji keywords for %q: %w", input.Language, err)
	}
	statement, err := tx.PrepareContext(ctx, `
INSERT INTO emoji_keywords
  (import_id, language_code, version, keyword, keyword_normalized, emoticon, order2)
VALUES (?, ?, ?, ?, ?, ?, ?)`)
	if err != nil {
		return err
	}
	keywords := make([]string, 0, len(input.Keywords))
	for keyword := range input.Keywords {
		keywords = append(keywords, keyword)
	}
	sort.Strings(keywords)
	seenMappings := make(map[string]struct{})
	normalizedOrder := make(map[string]int)
	for _, keyword := range keywords {
		normalized := strings.ToLower(strings.TrimSpace(keyword))
		if normalized == "" {
			_ = statement.Close()
			return errors.New("emoji keyword must not normalize to an empty value")
		}
		emoticons := append([]string(nil), input.Keywords[keyword]...)
		sort.Strings(emoticons)
		for _, emoticon := range emoticons {
			if emoticon = strings.TrimSpace(emoticon); emoticon == "" {
				_ = statement.Close()
				return fmt.Errorf("emoji keyword %q contains an empty emoticon", keyword)
			}
			mappingKey := normalized + "\x00" + emoticon
			if _, duplicate := seenMappings[mappingKey]; duplicate {
				continue
			}
			seenMappings[mappingKey] = struct{}{}
			order := normalizedOrder[normalized]
			normalizedOrder[normalized] = order + 1
			if _, err = statement.ExecContext(ctx,
				input.ImportID, input.Language, input.Version, keyword,
				normalized, emoticon, order); err != nil {
				_ = statement.Close()
				return fmt.Errorf("insert emoji keyword %q/%q: %w", keyword, emoticon, err)
			}
		}
	}
	if err = statement.Close(); err != nil {
		return err
	}
	return tx.Commit()
}

func (s *Store) FinalizeSet(ctx context.Context, setID int64, packs []Pack) error {
	if len(packs) == 0 {
		return fmt.Errorf("sticker set %d has no documents to publish", setID)
	}
	tx, err := s.db.BeginTx(ctx, nil)
	if err != nil {
		return err
	}
	defer func() { _ = tx.Rollback() }()
	placeholders := strings.TrimRight(strings.Repeat("?,", len(packs)), ",")
	documentArgs := make([]any, 0, len(packs)+2)
	documentArgs = append(documentArgs, setID, DocumentVerified)
	for _, pack := range packs {
		documentArgs = append(documentArgs, pack.DocumentID)
	}
	var verified int
	if err = tx.QueryRowContext(ctx, fmt.Sprintf(`
SELECT COUNT(*) FROM sticker_documents
WHERE sticker_set_id = ? AND import_state = ? AND id IN (%s)`, placeholders), documentArgs...).Scan(&verified); err != nil {
		return err
	}
	if verified != len(packs) {
		return fmt.Errorf("sticker set %d has %d/%d verified current documents", setID, verified, len(packs))
	}
	rows, err := tx.QueryContext(ctx, fmt.Sprintf(`
SELECT id, native_document_id FROM sticker_documents
WHERE id IN (%s)`, placeholders), documentArgs[2:]...)
	if err != nil {
		return err
	}
	nativeIDs := make(map[int64]int64, len(packs))
	for rows.Next() {
		var documentID, nativeID int64
		if err = rows.Scan(&documentID, &nativeID); err != nil {
			_ = rows.Close()
			return err
		}
		nativeIDs[documentID] = nativeID
	}
	if err = rows.Close(); err != nil {
		return err
	}
	var setHash int64
	for _, pack := range packs {
		nativeID, ok := nativeIDs[pack.DocumentID]
		if !ok {
			return fmt.Errorf("sticker set %d document %d has no native mapping", setID, pack.DocumentID)
		}
		setHash = (setHash*20261 + nativeID) & 0x7fffffff
	}
	if _, err = tx.ExecContext(ctx, `DELETE FROM sticker_packs WHERE sticker_set_id = ?`, setID); err != nil {
		return err
	}
	detachArgs := make([]any, 0, len(packs)+1)
	detachArgs = append(detachArgs, setID)
	for _, pack := range packs {
		detachArgs = append(detachArgs, pack.DocumentID)
	}
	if _, err = tx.ExecContext(ctx, fmt.Sprintf(`
UPDATE sticker_documents SET sticker_set_id = NULL
WHERE sticker_set_id = ? AND id NOT IN (%s)`, placeholders), detachArgs...); err != nil {
		return err
	}
	statement, err := tx.PrepareContext(ctx, `
INSERT INTO sticker_packs (sticker_set_id, emoticon, sticker_document_id, order2)
VALUES (?, ?, ?, ?)`)
	if err != nil {
		return err
	}
	for _, pack := range packs {
		if _, err = statement.ExecContext(ctx, setID, pack.Emoticon, pack.DocumentID, pack.Order); err != nil {
			_ = statement.Close()
			return err
		}
	}
	if err = statement.Close(); err != nil {
		return err
	}
	if _, err = tx.ExecContext(ctx, `
UPDATE sticker_sets
SET import_state = ?, set_hash = ?, last_error = '',
    document_count = (SELECT COUNT(*) FROM sticker_documents WHERE sticker_set_id = ?)
WHERE id = ?`, SetComplete, setHash, setID, setID); err != nil {
		return err
	}
	return tx.Commit()
}

func (s *Store) MarkSetRunning(ctx context.Context, setID int64) error {
	_, err := s.db.ExecContext(ctx, `UPDATE sticker_sets SET import_state = ?, last_error = '' WHERE id = ?`, SetRunning, setID)
	return err
}

func (s *Store) MarkSetFailed(ctx context.Context, setID int64, cause error) error {
	_, err := s.db.ExecContext(ctx, `UPDATE sticker_sets SET import_state = ?, last_error = ? WHERE id = ?`, SetFailed, truncateError(cause), setID)
	return err
}

func checksumBytes(checksum *[32]byte) []byte {
	if checksum == nil {
		return nil
	}
	return checksum[:]
}

func nullValue(value sql.NullInt64) any {
	if !value.Valid {
		return nil
	}
	return value.Int64
}

func requireOneRow(result sql.Result, operation string) error {
	rows, err := result.RowsAffected()
	if err != nil {
		return err
	}
	if rows != 1 {
		return fmt.Errorf("%s affected %d rows", operation, rows)
	}
	return nil
}

func truncateError(err error) string {
	if err == nil {
		return ""
	}
	message := err.Error()
	if len(message) > 2048 {
		message = message[:2048]
	}
	return message
}
