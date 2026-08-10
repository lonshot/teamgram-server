package native

import (
	"bytes"
	"context"
	"image"
	"image/color"
	"image/jpeg"
	"os"
	"path/filepath"
	"sync"
	"testing"
	"time"

	"github.com/stretchr/testify/require"
	"github.com/teamgram/proto/mtproto"
	"pwm-server/app/service/dfs/dfs"
	"pwm-server/app/service/media/media"
)

func TestUploaderStagesPersistsAndVerifiesFullAndPreview(t *testing.T) {
	root := t.TempDir()
	fullPath := filepath.Join(root, "sticker.tgs")
	previewPath := filepath.Join(root, "preview.webp")
	fullBytes := []byte("full-tgs-payload-spans-several-test-parts")
	require.NoError(t, os.WriteFile(fullPath, fullBytes, 0o600))
	require.NoError(t, os.WriteFile(previewPath, []byte("raw-preview"), 0o600))

	dfsClient := newFakeDFS()
	previewJPEG := makeJPEG(t, 64, 32)
	mediaClient := &fakeMedia{dfs: dfsClient, previewJPEG: previewJPEG}
	uploader := NewUploader(dfsClient, mediaClient, Options{
		OwnerID:       77,
		PartSize:      8,
		VerifyBytes:   true,
		VerifyTimeout: time.Second,
		RetryDelay:    time.Millisecond,
	})
	uploader.newID = sequenceIDs(101, 102)
	uploader.wait = func(context.Context, time.Duration) error { return nil }
	dfsClient.emptyDownloads = 1

	result, err := uploader.Upload(context.Background(), DocumentSpec{
		SourcePath:  fullPath,
		PreviewPath: previewPath,
		FileName:    "AnimatedSticker.tgs",
		MimeType:    "application/x-tgsticker",
		Attributes: []*mtproto.DocumentAttribute{
			mtproto.MakeTLDocumentAttributeSticker(&mtproto.DocumentAttribute{Alt: "😀"}).To_DocumentAttribute(),
		},
	})
	require.NoError(t, err)
	verified, err := uploader.Verify(context.Background(), result.Document.GetId(), result.Document.GetAccessHash(), fullPath, result.SourceChecksum, true)
	require.NoError(t, err)
	require.Equal(t, int64(9001), result.Document.GetId())
	require.Equal(t, result.Document.GetId(), verified.GetId())
	require.True(t, result.PreviewPresent)
	require.Equal(t, fullBytes, dfsClient.full)
	require.Equal(t, previewJPEG, dfsClient.preview)
	require.Equal(t, int32(6), dfsClient.partCounts[101])
	require.Equal(t, int32(2), dfsClient.partCounts[102])
	require.Equal(t, int64(77), dfsClient.creators[101])
	require.Equal(t, "AnimatedSticker.tgs", mediaClient.request.GetMedia().GetFile().GetName())
	require.Equal(t, "preview.webp", mediaClient.request.GetMedia().GetThumb().GetName())
}

func TestUploaderStagesStaticSourceOnceWhenItIsAlsoPreview(t *testing.T) {
	root := t.TempDir()
	path := filepath.Join(root, "sticker.webp")
	require.NoError(t, os.WriteFile(path, []byte("static-webp"), 0o600))

	dfsClient := newFakeDFS()
	mediaClient := &fakeMedia{dfs: dfsClient, previewJPEG: makeJPEG(t, 16, 16)}
	uploader := NewUploader(dfsClient, mediaClient, Options{OwnerID: 3, PartSize: 64})
	uploader.newID = sequenceIDs(201)

	result, err := uploader.Upload(context.Background(), DocumentSpec{
		SourcePath:  path,
		PreviewPath: path,
		MimeType:    "image/webp",
		Attributes: []*mtproto.DocumentAttribute{
			mtproto.MakeTLDocumentAttributeCustomEmoji(&mtproto.DocumentAttribute{Alt: "x"}).To_DocumentAttribute(),
		},
	})
	require.NoError(t, err)
	require.True(t, result.PreviewPresent)
	require.Len(t, dfsClient.parts, 1)
	require.Equal(t, mediaClient.request.GetMedia().GetFile().GetId_INT64(), mediaClient.request.GetMedia().GetThumb().GetId_INT64())
}

type fakeDFS struct {
	mu             sync.Mutex
	parts          map[int64]map[int32][]byte
	partCounts     map[int64]int32
	creators       map[int64]int64
	full           []byte
	preview        []byte
	emptyDownloads int
}

func newFakeDFS() *fakeDFS {
	return &fakeDFS{
		parts:      make(map[int64]map[int32][]byte),
		partCounts: make(map[int64]int32),
		creators:   make(map[int64]int64),
	}
}

func (f *fakeDFS) DfsWriteFilePartData(_ context.Context, in *dfs.TLDfsWriteFilePartData) (*mtproto.Bool, error) {
	f.mu.Lock()
	defer f.mu.Unlock()
	if f.parts[in.GetFileId()] == nil {
		f.parts[in.GetFileId()] = make(map[int32][]byte)
	}
	f.parts[in.GetFileId()][in.GetFilePart()] = append([]byte(nil), in.GetBytes()...)
	f.partCounts[in.GetFileId()] = in.GetFileTotalParts().GetValue()
	f.creators[in.GetFileId()] = in.GetCreator()
	return mtproto.BoolTrue, nil
}

func (f *fakeDFS) DfsDownloadFile(_ context.Context, in *dfs.TLDfsDownloadFile) (*mtproto.Upload_File, error) {
	f.mu.Lock()
	defer f.mu.Unlock()
	if f.emptyDownloads > 0 {
		f.emptyDownloads--
		return mtproto.MakeTLUploadFile(&mtproto.Upload_File{Bytes: nil}).To_Upload_File(), nil
	}
	data := f.full
	if in.GetLocation().GetThumbSize() != "" {
		data = f.preview
	}
	offset := int(in.GetOffset())
	if offset >= len(data) {
		return mtproto.MakeTLUploadFile(&mtproto.Upload_File{Bytes: nil}).To_Upload_File(), nil
	}
	end := offset + int(in.GetLimit())
	if end > len(data) {
		end = len(data)
	}
	return mtproto.MakeTLUploadFile(&mtproto.Upload_File{Bytes: append([]byte(nil), data[offset:end]...)}).To_Upload_File(), nil
}

func (f *fakeDFS) staged(fileID int64, parts int32) []byte {
	f.mu.Lock()
	defer f.mu.Unlock()
	var result []byte
	for part := int32(0); part < parts; part++ {
		result = append(result, f.parts[fileID][part]...)
	}
	return result
}

type fakeMedia struct {
	dfs         *fakeDFS
	previewJPEG []byte
	request     *media.TLMediaUploadedDocumentMedia
	document    *mtproto.Document
}

func (f *fakeMedia) MediaUploadedDocumentMedia(_ context.Context, in *media.TLMediaUploadedDocumentMedia) (*mtproto.MessageMedia, error) {
	f.request = in
	file := in.GetMedia().GetFile()
	f.dfs.full = f.dfs.staged(file.GetId_INT64(), file.GetParts())
	var thumbs []*mtproto.PhotoSize
	if in.GetMedia().GetThumb() != nil {
		f.dfs.preview = append([]byte(nil), f.previewJPEG...)
		config, _, _ := image.DecodeConfig(bytes.NewReader(f.previewJPEG))
		thumbs = []*mtproto.PhotoSize{
			mtproto.MakeTLPhotoSize(&mtproto.PhotoSize{
				Type:  mtproto.PhotoSZMediumType,
				W:     int32(config.Width),
				H:     int32(config.Height),
				Size2: int32(len(f.previewJPEG)),
			}).To_PhotoSize(),
		}
	}
	f.document = mtproto.MakeTLDocument(&mtproto.Document{
		Id:            9001,
		AccessHash:    8001,
		FileReference: []byte{},
		Date:          1,
		MimeType:      in.GetMedia().GetMimeType(),
		Size2_INT64:   int64(len(f.dfs.full)),
		Size2_INT32:   int32(len(f.dfs.full)),
		Thumbs:        thumbs,
		DcId:          1,
		Attributes:    in.GetMedia().GetAttributes(),
	}).To_Document()
	return mtproto.MakeTLMessageMediaDocument(&mtproto.MessageMedia{Document: f.document}).To_MessageMedia(), nil
}

func (f *fakeMedia) MediaGetDocument(context.Context, *media.TLMediaGetDocument) (*mtproto.Document, error) {
	return f.document, nil
}

func makeJPEG(t *testing.T, width, height int) []byte {
	t.Helper()
	img := image.NewNRGBA(image.Rect(0, 0, width, height))
	for y := 0; y < height; y++ {
		for x := 0; x < width; x++ {
			img.Set(x, y, color.NRGBA{R: uint8(x), G: uint8(y), B: 100, A: 255})
		}
	}
	var result bytes.Buffer
	require.NoError(t, jpeg.Encode(&result, img, nil))
	return result.Bytes()
}

func sequenceIDs(ids ...int64) func() (int64, error) {
	index := 0
	return func() (int64, error) {
		value := ids[index]
		index++
		return value, nil
	}
}
