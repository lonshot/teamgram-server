package core

import (
	"github.com/teamgram/proto/mtproto"
	"pwm-server/app/service/dfs/dfs"

	"google.golang.org/protobuf/types/known/wrapperspb"
)

// UploadSaveBigFilePart
// upload.saveBigFilePart#de7b673d file_id:long file_part:int file_total_parts:int bytes:bytes = Bool;
func (c *FilesCore) UploadSaveBigFilePart(in *mtproto.TLUploadSaveBigFilePart) (*mtproto.Bool, error) {
	_, err := c.svcCtx.Dao.DfsClient.DfsWriteFilePartData(c.ctx, &dfs.TLDfsWriteFilePartData{
		Creator:        c.MD.PermAuthKeyId,
		FileId:         in.FileId,
		FilePart:       in.FilePart,
		Bytes:          in.Bytes,
		Big:            true,
		FileTotalParts: &wrapperspb.Int32Value{Value: in.FileTotalParts},
	})
	if err != nil {
		c.Logger.Errorf("upload.saveFilePart - error: %v", err)
		return nil, err
	}

	return mtproto.BoolTrue, nil
}
