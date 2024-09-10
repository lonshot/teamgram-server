package core

import (
	"github.com/teamgram/proto/mtproto"
	"pwm-server/app/service/dfs/dfs"
)

// UploadSaveFilePart
// upload.saveFilePart#b304a621 file_id:long file_part:int bytes:bytes = Bool;
func (c *FilesCore) UploadSaveFilePart(in *mtproto.TLUploadSaveFilePart) (*mtproto.Bool, error) {
	_, err := c.svcCtx.Dao.DfsClient.DfsWriteFilePartData(c.ctx, &dfs.TLDfsWriteFilePartData{
		Creator:        c.MD.PermAuthKeyId,
		FileId:         in.FileId,
		FilePart:       in.FilePart,
		Bytes:          in.Bytes,
		Big:            false,
		FileTotalParts: nil,
	})
	if err != nil {
		c.Logger.Errorf("upload.saveFilePart - error: %v", err)
		return nil, err
	}

	return mtproto.BoolTrue, nil
}
