package core

import (
	"pwm-server/app/service/media/media"
)

// MediaGetDocumentList
// media.getDocumentList id_list:Vector<long> = Vector<Document>;
func (c *MediaCore) MediaGetDocumentList(in *media.TLMediaGetDocumentList) (*media.Vector_Document, error) {
	documents := c.svcCtx.Dao.GetDocumentListByIdList(c.ctx, in.IdList)

	return &media.Vector_Document{
		Datas: documents,
	}, nil
}
