package core

import (
	"context"
	"fmt"
	"math/rand"
	"time"

	"github.com/teamgram/marmota/pkg/threading2"
	"github.com/teamgram/proto/mtproto"
	"pwm-server/app/service/dfs/dfs"
	"pwm-server/app/service/dfs/internal/ffmpegutil"
	"pwm-server/app/service/dfs/internal/model"

	"google.golang.org/protobuf/types/known/wrapperspb"
)

// DfsUploadRingtoneFile
// dfs.uploadRingtoneFile creator:long file:InputFile mime_type:string file_name:string = Document;
func (c *DfsCore) DfsUploadRingtoneFile(in *dfs.TLDfsUploadRingtoneFile) (*mtproto.Document, error) {
	var (
		err error

		documentId = c.svcCtx.Dao.IDGenClient2.NextId(c.ctx)
		file       = in.GetFile()
		ext        = model.GetFileExtName(file.GetName())
		extType    = model.GetStorageFileTypeConstructor(ext)
		accessHash = int64(extType)<<32 | int64(rand.Uint32())
		creatorId  = in.GetCreator()
	)

	// upload file
	if file == nil {
		c.Logger.Errorf("dfs.uploadRingtoneFile - ErrInputRequestInvalid")
		return nil, mtproto.ErrInputRequestInvalid
	}

	if err = model.CheckFileParts(file.Parts); err != nil {
		c.Logger.Errorf("dfs.uploadRingtoneFile - %v", err)
		return nil, err
	}

	// duration
	tmpFileName := fmt.Sprintf("http://127.0.0.1:11701/dfs/file/%d_%d.mp3", creatorId, file.GetId_INT64())
	md, err := c.svcCtx.FFmpegUtil.GetMetadata(tmpFileName)
	if err != nil {
		c.Logger.Errorf("dfs.uploadRingtoneFile - error: %v", err)
		return nil, err
	}
	duration := ffmpegutil.GetDuration(md)
	if duration > 5 {
		//
	}

	fileInfo, err := c.svcCtx.Dao.GetFileInfo(c.ctx, creatorId, file.Id_INT64)
	if err != nil {
		c.Logger.Errorf("dfs.uploadRingtoneFile - error: %v", err)
		return nil, err
	}
	c.svcCtx.Dao.SetCacheFileInfo(c.ctx, documentId, fileInfo)

	threading2.GoSafeContext(c.ctx, func(ctx context.Context) {
		_, err2 := c.svcCtx.Dao.PutDocumentFile(
			ctx,
			fmt.Sprintf("%d.dat", documentId),
			c.svcCtx.Dao.NewSSDBReader(fileInfo))
		if err2 != nil {
			c.Logger.Errorf("dfs.uploadRingtoneFile - error: %v", err)
		}
	})

	// build document
	document := mtproto.MakeTLDocument(&mtproto.Document{
		Id:            documentId,
		AccessHash:    accessHash,
		FileReference: []byte{}, // TODO(@benqi): gen file_reference
		Date:          int32(time.Now().Unix()),
		MimeType:      in.GetMimeType(),
		Size2:         fileInfo.GetFileSize(),
		Size2_INT32:   int32(fileInfo.GetFileSize()),
		Size2_INT64:   fileInfo.GetFileSize(),
		Thumbs:        nil,
		VideoThumbs:   nil,
		DcId:          1,
		Attributes: []*mtproto.DocumentAttribute{
			mtproto.MakeTLDocumentAttributeAudio(&mtproto.DocumentAttribute{
				Voice:            false,
				Duration:         float64(duration),
				Duration_INT32:   int32(duration),
				Duration_FLOAT64: float64(duration),
				Title:            &wrapperspb.StringValue{Value: in.GetFileName()},
				Performer:        &wrapperspb.StringValue{Value: ""}, // TODO:
				Waveform:         nil,
			}).To_DocumentAttribute(),
			mtproto.MakeTLDocumentAttributeFilename(&mtproto.DocumentAttribute{
				FileName: in.GetFileName(),
			}).To_DocumentAttribute(),
		},
	}).To_Document()

	return document, nil
}
