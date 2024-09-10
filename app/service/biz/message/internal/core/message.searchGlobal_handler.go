package core

import (
	"math"

	"github.com/teamgram/proto/mtproto"
	"pwm-server/app/service/biz/message/internal/dal/dataobject"
	"pwm-server/app/service/biz/message/message"
)

// MessageSearchGlobal
// message.searchGlobal user_id:long q:string offset:int limit:int = Vector<MessageBox>;
func (c *MessageCore) MessageSearchGlobal(in *message.TLMessageSearchGlobal) (*mtproto.MessageBoxList, error) {
	var (
		offset  = in.Offset
		rValues []*mtproto.MessageBox
	)

	if offset == 0 {
		offset = math.MaxInt32
	}

	rList, _ := c.svcCtx.Dao.MessagesDAO.SearchGlobalWithCB(
		c.ctx,
		in.UserId,
		offset, "%"+in.Q+"%",
		in.Limit,
		func(sz, i int, v *dataobject.MessagesDO) {
			rValues = append(rValues, c.svcCtx.Dao.MakeMessageBox(c.ctx, in.UserId, v))
		})
	_ = rList

	if rValues == nil {
		rValues = []*mtproto.MessageBox{}
	}

	return mtproto.MakeTLMessageBoxList(&mtproto.MessageBoxList{
		BoxList: rValues,
	}).To_MessageBoxList(), nil
}
