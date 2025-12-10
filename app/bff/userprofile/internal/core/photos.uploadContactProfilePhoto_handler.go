package core

import (
	"github.com/teamgram/proto/mtproto"
)

// PhotosUploadContactProfilePhoto
// photos.uploadContactProfilePhoto#e14c4a71 flags:# suggest:flags.3?true save:flags.4?true user_id:InputUser file:flags.0?InputFile video:flags.1?InputFile video_start_ts:flags.2?double video_emoji_markup:flags.5?VideoSize = photos.Photo;
func (c *UserProfileCore) PhotosUploadContactProfilePhoto(in *mtproto.TLPhotosUploadContactProfilePhoto) (*mtproto.Photos_Photo, error) {
	// TODO: not impl
	c.Logger.Errorf("photos.uploadContactProfilePhoto method not impl")

	return nil, mtproto.ErrMethodNotImpl
}
