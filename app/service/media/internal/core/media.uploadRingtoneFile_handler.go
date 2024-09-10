package core

import (
	"github.com/teamgram/proto/mtproto"
	"pwm-server/app/service/media/media"
)

// MediaUploadRingtoneFile
// media.uploadRingtoneFile flags:# owner_id:long file:InputFile mime_type:string file_name:string = Document;
func (c *MediaCore) MediaUploadRingtoneFile(in *media.TLMediaUploadRingtoneFile) (*mtproto.Document, error) {
	// TODO: not impl
	c.Logger.Errorf("media.uploadRingtoneFile blocked, License key from https://teamgram.net required to unlock enterprise features.")

	return nil, mtproto.ErrEnterpriseIsBlocked
}
