package core

import (
	"github.com/teamgram/proto/mtproto"
	"pwm-server/app/service/media/media"
)

// MediaGetDocument
// media.getDocument id:long = Document;
func (c *MediaCore) MediaGetDocument(in *media.TLMediaGetDocument) (*mtproto.Document, error) {
	document := c.svcCtx.Dao.GetDocumentById(c.ctx, in.GetId())

	return document, nil
}
