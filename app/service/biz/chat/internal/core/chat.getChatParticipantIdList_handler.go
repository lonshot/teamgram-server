package core

import (
	"github.com/teamgram/proto/mtproto"
	"pwm-server/app/service/biz/chat/chat"
	"pwm-server/app/service/biz/chat/internal/dal/dataobject"
)

// ChatGetChatParticipantIdList
// chat.getChatParticipantIdList chat_id:long = Vector<long>;
func (c *ChatCore) ChatGetChatParticipantIdList(in *chat.TLChatGetChatParticipantIdList) (*chat.Vector_Long, error) {
	var (
		idList = make([]int64, 0)
	)

	c.svcCtx.Dao.ChatParticipantsDAO.SelectListWithCB(
		c.ctx,
		in.ChatId,
		func(sz, i int, v *dataobject.ChatParticipantsDO) {
			if v.State != mtproto.ChatMemberStateNormal {
				return
			}
			idList = append(idList, v.UserId)
		})

	return &chat.Vector_Long{
		Datas: idList,
	}, nil
}
