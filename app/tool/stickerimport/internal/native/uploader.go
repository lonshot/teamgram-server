package native

import (
	"bytes"
	"context"
	"crypto/md5"
	"crypto/rand"
	"crypto/sha256"
	"encoding/binary"
	"errors"
	"fmt"
	"image/jpeg"
	"io"
	"os"
	"path/filepath"
	"time"

	"github.com/teamgram/proto/mtproto"
	"google.golang.org/protobuf/types/known/wrapperspb"
	"pwm-server/app/service/dfs/dfs"
	"pwm-server/app/service/media/media"
)

const defaultPartSize = 512 * 1024

var ErrNativeIntegrity = errors.New("persisted native document failed integrity validation")

type DFSClient interface {
	DfsWriteFilePartData(context.Context, *dfs.TLDfsWriteFilePartData) (*mtproto.Bool, error)
	DfsDownloadFile(context.Context, *dfs.TLDfsDownloadFile) (*mtproto.Upload_File, error)
}

type MediaClient interface {
	MediaUploadedDocumentMedia(context.Context, *media.TLMediaUploadedDocumentMedia) (*mtproto.MessageMedia, error)
	MediaGetDocument(context.Context, *media.TLMediaGetDocument) (*mtproto.Document, error)
}

type Options struct {
	OwnerID       int64
	PartSize      int
	VerifyBytes   bool
	VerifyTimeout time.Duration
	RetryDelay    time.Duration
}

type DocumentSpec struct {
	SourcePath  string
	PreviewPath string
	FileName    string
	MimeType    string
	Attributes  []*mtproto.DocumentAttribute
}

type Result struct {
	Document       *mtproto.Document
	SourceChecksum [sha256.Size]byte
	PreviewPresent bool
}

type Uploader struct {
	dfs   DFSClient
	media MediaClient
	opts  Options
	now   func() time.Time
	wait  func(context.Context, time.Duration) error
	newID func() (int64, error)
}

func NewUploader(dfsClient DFSClient, mediaClient MediaClient, opts Options) *Uploader {
	if opts.PartSize <= 0 {
		opts.PartSize = defaultPartSize
	}
	if opts.VerifyTimeout <= 0 {
		opts.VerifyTimeout = 15 * time.Second
	}
	if opts.RetryDelay <= 0 {
		opts.RetryDelay = 100 * time.Millisecond
	}
	return &Uploader{
		dfs:   dfsClient,
		media: mediaClient,
		opts:  opts,
		now:   time.Now,
		wait: func(ctx context.Context, delay time.Duration) error {
			timer := time.NewTimer(delay)
			defer timer.Stop()
			select {
			case <-ctx.Done():
				return ctx.Err()
			case <-timer.C:
				return nil
			}
		},
		newID: randomPositiveInt64,
	}
}

func (u *Uploader) Upload(ctx context.Context, spec DocumentSpec) (*Result, error) {
	if u.dfs == nil || u.media == nil {
		return nil, errors.New("native uploader clients are required")
	}
	if spec.SourcePath == "" || spec.MimeType == "" || len(spec.Attributes) == 0 {
		return nil, errors.New("source path, MIME type and document attributes are required")
	}
	if spec.FileName == "" {
		spec.FileName = defaultFileName(spec.MimeType)
	}

	full, err := u.stageFile(ctx, spec.SourcePath, spec.FileName)
	if err != nil {
		return nil, fmt.Errorf("stage full asset: %w", err)
	}
	var thumb *mtproto.InputFile
	if spec.PreviewPath != "" {
		if sameFile(spec.SourcePath, spec.PreviewPath) {
			thumb = full.input
		} else {
			preview, previewErr := u.stageFile(ctx, spec.PreviewPath, "preview.webp")
			if previewErr != nil {
				return nil, fmt.Errorf("stage preview asset: %w", previewErr)
			}
			thumb = preview.input
		}
	}

	messageMedia, err := u.media.MediaUploadedDocumentMedia(ctx, &media.TLMediaUploadedDocumentMedia{
		OwnerId: u.opts.OwnerID,
		Media: mtproto.MakeTLInputMediaUploadedDocument(&mtproto.InputMedia{
			File:       full.input,
			Thumb:      thumb,
			MimeType:   spec.MimeType,
			Attributes: spec.Attributes,
		}).To_InputMedia(),
	})
	if err != nil {
		return nil, fmt.Errorf("persist native document: %w", err)
	}
	document := messageMedia.GetDocument()
	if document == nil || document.GetPredicateName() != mtproto.Predicate_document {
		return nil, errors.New("media service returned no native document")
	}
	if err = validateDocument(document, spec, full.size, thumb != nil); err != nil {
		return nil, err
	}

	return &Result{
		Document:       document,
		SourceChecksum: full.checksum,
		PreviewPresent: thumb != nil,
	}, nil
}

// Verify re-reads a persisted document by native ID before touching its DFS
// objects. Importers persist the source-to-native mapping before calling this
// method, so an interrupted verification resumes without uploading a duplicate
// document.
func (u *Uploader) Verify(ctx context.Context, nativeID, accessHash int64, sourcePath string, expected [sha256.Size]byte, expectPreview bool) (*mtproto.Document, error) {
	persisted, err := u.media.MediaGetDocument(ctx, &media.TLMediaGetDocument{Id: nativeID})
	if err != nil {
		return nil, fmt.Errorf("read persisted native document: %w", err)
	}
	if persisted == nil || persisted.GetPredicateName() != mtproto.Predicate_document {
		return nil, fmt.Errorf("%w: persisted document is missing", ErrNativeIntegrity)
	}
	if persisted.GetId() != nativeID || persisted.GetAccessHash() != accessHash {
		return nil, fmt.Errorf("%w: persisted document identity does not match import mapping", ErrNativeIntegrity)
	}
	if expectPreview && mediumThumb(persisted) == nil {
		return nil, fmt.Errorf("%w: persisted document omitted native medium preview", ErrNativeIntegrity)
	}
	if u.opts.VerifyBytes {
		if err = u.verifyFullDownload(ctx, persisted, sourcePath, expected); err != nil {
			return nil, err
		}
		if expectPreview {
			if err = u.verifyPreviewDownload(ctx, persisted); err != nil {
				return nil, err
			}
		}
	}
	return persisted, nil
}

type stagedFile struct {
	input    *mtproto.InputFile
	size     int64
	checksum [sha256.Size]byte
}

func (u *Uploader) stageFile(ctx context.Context, path, name string) (*stagedFile, error) {
	file, err := os.Open(path)
	if err != nil {
		return nil, err
	}
	defer file.Close()
	stat, err := file.Stat()
	if err != nil {
		return nil, err
	}
	if !stat.Mode().IsRegular() || stat.Size() <= 0 {
		return nil, fmt.Errorf("asset %q is not a non-empty regular file", path)
	}
	parts64 := (stat.Size() + int64(u.opts.PartSize) - 1) / int64(u.opts.PartSize)
	if parts64 <= 0 || parts64 > int64(^uint32(0)>>1) {
		return nil, fmt.Errorf("asset %q has invalid part count %d", path, parts64)
	}
	parts := int32(parts64)
	fileID, err := u.newID()
	if err != nil {
		return nil, fmt.Errorf("allocate staging file ID: %w", err)
	}
	sha := sha256.New()
	md5Hash := md5.New()
	buffer := make([]byte, u.opts.PartSize)
	for part := int32(0); part < parts; part++ {
		count, readErr := io.ReadFull(file, buffer)
		if readErr != nil && !errors.Is(readErr, io.ErrUnexpectedEOF) {
			return nil, fmt.Errorf("read part %d: %w", part, readErr)
		}
		chunk := buffer[:count]
		_, _ = sha.Write(chunk)
		_, _ = md5Hash.Write(chunk)
		if _, err = u.dfs.DfsWriteFilePartData(ctx, &dfs.TLDfsWriteFilePartData{
			Creator:        u.opts.OwnerID,
			FileId:         fileID,
			FilePart:       part,
			Bytes:          append([]byte(nil), chunk...),
			Big:            false,
			FileTotalParts: &wrapperspb.Int32Value{Value: parts},
		}); err != nil {
			return nil, fmt.Errorf("write part %d/%d: %w", part+1, parts, err)
		}
	}
	var checksum [sha256.Size]byte
	copy(checksum[:], sha.Sum(nil))
	return &stagedFile{
		input: mtproto.MakeTLInputFile(&mtproto.InputFile{
			Id_INT64:    fileID,
			Parts:       parts,
			Name:        name,
			Md5Checksum: fmt.Sprintf("%x", md5Hash.Sum(nil)),
		}).To_InputFile(),
		size:     stat.Size(),
		checksum: checksum,
	}, nil
}

func validateDocument(document *mtproto.Document, spec DocumentSpec, expectedSize int64, expectThumb bool) error {
	if document.GetId() <= 0 || document.GetAccessHash() == 0 {
		return errors.New("media service returned invalid document identity")
	}
	if document.GetMimeType() != spec.MimeType {
		return fmt.Errorf("native MIME mismatch: got %q want %q", document.GetMimeType(), spec.MimeType)
	}
	if document.GetFixedSize() != expectedSize {
		return fmt.Errorf("native size mismatch: got %d want %d", document.GetFixedSize(), expectedSize)
	}
	if document.GetDcId() <= 0 {
		return errors.New("media service returned invalid document DC")
	}
	if expectThumb && mediumThumb(document) == nil {
		return errors.New("media service omitted native medium preview")
	}
	return nil
}

func (u *Uploader) verifyFullDownload(ctx context.Context, document *mtproto.Document, sourcePath string, expected [sha256.Size]byte) error {
	data, err := u.downloadEventually(ctx, document, "", document.GetFixedSize())
	if err != nil {
		return fmt.Errorf("verify full download: %w", err)
	}
	if actual := sha256.Sum256(data); actual != expected {
		return fmt.Errorf("%w: full download checksum differs from %q", ErrNativeIntegrity, sourcePath)
	}
	return nil
}

func (u *Uploader) verifyPreviewDownload(ctx context.Context, document *mtproto.Document) error {
	thumb := mediumThumb(document)
	if thumb == nil {
		return fmt.Errorf("%w: preview medium thumb metadata is missing", ErrNativeIntegrity)
	}
	data, err := u.downloadEventually(ctx, document, mtproto.PhotoSZMediumType, int64(thumb.GetSize2()))
	if err != nil {
		return fmt.Errorf("verify preview download: %w", err)
	}
	image, err := jpeg.Decode(bytes.NewReader(data))
	if err != nil {
		return fmt.Errorf("%w: preview is not a valid native JPEG: %v", ErrNativeIntegrity, err)
	}
	if int32(image.Bounds().Dx()) != thumb.GetW() || int32(image.Bounds().Dy()) != thumb.GetH() {
		return fmt.Errorf("%w: preview dimensions are %dx%d, metadata is %dx%d", ErrNativeIntegrity, image.Bounds().Dx(), image.Bounds().Dy(), thumb.GetW(), thumb.GetH())
	}
	return nil
}

func (u *Uploader) downloadEventually(ctx context.Context, document *mtproto.Document, thumbSize string, expectedSize int64) ([]byte, error) {
	deadline := u.now().Add(u.opts.VerifyTimeout)
	var lastErr error
	for {
		data, err := u.download(ctx, document, thumbSize, expectedSize)
		if err == nil {
			return data, nil
		}
		lastErr = err
		if !u.now().Before(deadline) {
			return nil, fmt.Errorf("object was not durable within %s: %w", u.opts.VerifyTimeout, lastErr)
		}
		if err = u.wait(ctx, u.opts.RetryDelay); err != nil {
			return nil, err
		}
	}
}

func (u *Uploader) download(ctx context.Context, document *mtproto.Document, thumbSize string, expectedSize int64) ([]byte, error) {
	if expectedSize <= 0 {
		return nil, errors.New("invalid expected download size")
	}
	result := make([]byte, 0, expectedSize)
	for offset := int64(0); offset < expectedSize; {
		limit := u.opts.PartSize
		remaining := expectedSize - offset
		if remaining < int64(limit) {
			limit = int(remaining)
		}
		file, err := u.dfs.DfsDownloadFile(ctx, &dfs.TLDfsDownloadFile{
			Location: mtproto.MakeTLInputDocumentFileLocation(&mtproto.InputFileLocation{
				Id:            document.GetId(),
				AccessHash:    document.GetAccessHash(),
				FileReference: document.GetFileReference(),
				ThumbSize:     thumbSize,
			}).To_InputFileLocation(),
			Offset: offset,
			Limit:  int32(limit),
		})
		if err != nil {
			return nil, err
		}
		chunk := file.GetBytes()
		if len(chunk) == 0 {
			return nil, fmt.Errorf("empty range at offset %d", offset)
		}
		if len(chunk) > limit || int64(len(result)+len(chunk)) > expectedSize {
			return nil, fmt.Errorf("oversized range at offset %d", offset)
		}
		result = append(result, chunk...)
		offset += int64(len(chunk))
	}
	if int64(len(result)) != expectedSize {
		return nil, fmt.Errorf("downloaded %d bytes, expected %d", len(result), expectedSize)
	}
	return result, nil
}

func mediumThumb(document *mtproto.Document) *mtproto.PhotoSize {
	for _, thumb := range document.GetThumbs() {
		if thumb.GetPredicateName() == mtproto.Predicate_photoSize && thumb.GetType() == mtproto.PhotoSZMediumType {
			return thumb
		}
	}
	return nil
}

func sameFile(left, right string) bool {
	leftAbs, leftErr := filepath.Abs(left)
	rightAbs, rightErr := filepath.Abs(right)
	return leftErr == nil && rightErr == nil && leftAbs == rightAbs
}

func defaultFileName(mimeType string) string {
	switch mimeType {
	case "application/x-tgsticker":
		return "AnimatedSticker.tgs"
	case "image/webp":
		return "Sticker.webp"
	case "video/webm":
		return "Sticker.webm"
	default:
		return "Sticker.bin"
	}
}

func randomPositiveInt64() (int64, error) {
	var data [8]byte
	if _, err := rand.Read(data[:]); err != nil {
		return 0, err
	}
	value := int64(binary.LittleEndian.Uint64(data[:]) & ^(uint64(1) << 63))
	if value == 0 {
		value = 1
	}
	return value, nil
}
