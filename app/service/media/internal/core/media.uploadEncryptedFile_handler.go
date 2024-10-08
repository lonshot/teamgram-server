package core

import (
	"github.com/teamgram/proto/mtproto"
	"pwm-server/app/service/media/media"
)

// MediaUploadEncryptedFile
// media.uploadEncryptedFile owner_id:long file:InputEncryptedFile = EncryptedFile;
func (c *MediaCore) MediaUploadEncryptedFile(in *media.TLMediaUploadEncryptedFile) (*mtproto.EncryptedFile, error) {
	// TODO: not impl
	c.Logger.Errorf("media.uploadEncryptedFile blocked, License key from https://teamgram.net required to unlock enterprise features.")

	return nil, mtproto.ErrEnterpriseIsBlocked
}
