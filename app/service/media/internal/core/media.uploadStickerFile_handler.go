package core

import (
	"pwm-server/app/service/media/media"

	"github.com/teamgram/proto/mtproto"
)

// MediaUploadStickerFile
// media.uploadStickerFile flags:# owner_id:long file:InputFile thumb:flags.0?InputFile mime_type:string file_name:string document_attribute_sticker:DocumentAttribute = Document;
func (c *MediaCore) MediaUploadStickerFile(in *media.TLMediaUploadStickerFile) (*mtproto.Document, error) {
	// TODO: not impl
	c.Logger.Errorf("media.uploadStickerFile blocked, License key from https://wb.playwith-me.com required to unlock enterprise features.")

	return nil, mtproto.ErrEnterpriseIsBlocked
}
