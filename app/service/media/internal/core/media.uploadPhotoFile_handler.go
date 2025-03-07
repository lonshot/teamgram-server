package core

import (
	"github.com/teamgram/proto/mtproto"
	"pwm-server/app/service/dfs/dfs"
	"pwm-server/app/service/media/media"
)

// MediaUploadPhotoFile
// media.uploadPhotoFile flags:# owner_id:long file:InputFile stickers:flags.0?Vector<InputDocument> ttl_seconds:flags.1?int = Photo;
func (c *MediaCore) MediaUploadPhotoFile(in *media.TLMediaUploadPhotoFile) (*mtproto.Photo, error) {
	var (
		inputFile = in.GetFile()
		// fileMDList []*dfspb.PhotoFileMetadata
	)

	if in.GetFile() == nil {
		c.Logger.Errorf("media.uploadPhotoFile - error: file is nil")
		return nil, mtproto.ErrMediaInvalid
	}

	photo, err := c.svcCtx.Dao.DfsClient.DfsUploadPhotoFileV2(c.ctx, &dfs.TLDfsUploadPhotoFileV2{
		Creator: in.OwnerId,
		File:    inputFile,
	})
	if err != nil {
		c.Logger.Errorf("media.uploadPhotoFile - error: %v", err)
		return nil, err
	}

	if err = c.svcCtx.Dao.SavePhotoSizeV2(c.ctx, photo.GetId(), photo.GetSizes()); err != nil {
		c.Logger.Errorf("media.uploadPhotoFile - error: %v", err)
		return nil, err
	}

	c.svcCtx.Dao.SavePhotoV2(c.ctx,
		photo.GetId(),
		photo.GetAccessHash(),
		photo.GetHasStickers(),
		false,
		inputFile.GetName())

	return photo, nil
}
