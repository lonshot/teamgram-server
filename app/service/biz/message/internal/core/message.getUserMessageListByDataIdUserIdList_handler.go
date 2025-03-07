package core

import (
	"github.com/teamgram/proto/mtproto"
	"pwm-server/app/service/biz/message/internal/dal/dataobject"
	"pwm-server/app/service/biz/message/message"
)

// MessageGetUserMessageListByDataIdUserIdList
// message.getUserMessageListByDataIdUserIdList id:long user_id_list:Vector<long> = Vector<MessageBox>;
func (c *MessageCore) MessageGetUserMessageListByDataIdUserIdList(in *message.TLMessageGetUserMessageListByDataIdUserIdList) (*message.Vector_MessageBox, error) {
	var (
		tables     = make(map[string][]int64)
		rValueList = &message.Vector_MessageBox{
			Datas: make([]*mtproto.MessageBox, 0),
		}
	)

	for _, uid := range in.GetUserIdList() {
		table := c.svcCtx.Dao.MessagesDAO.CalcTableName(uid)
		if idList, ok := tables[table]; ok {
			tables[table] = append(idList, uid)
		} else {
			tables[table] = []int64{uid}
		}
	}

	for k, v := range tables {
		c.svcCtx.Dao.MessagesDAO.SelectByMessageDataIdUserIdListWithCB(
			c.ctx,
			k,
			in.GetId(),
			v,
			func(sz, i int, v *dataobject.MessagesDO) {
				rValueList.Datas = append(rValueList.Datas, c.svcCtx.Dao.MakeMessageBox(c.ctx, 0, v))
			})
	}

	return rValueList, nil
}
