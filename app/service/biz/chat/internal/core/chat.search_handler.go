package core

import (
	"github.com/teamgram/proto/mtproto"
	"pwm-server/app/service/biz/chat/chat"
)

// ChatSearch
// chat.search self_id:long q:string offset:long limit:int = Vector<UserChatIdList>;
func (c *ChatCore) ChatSearch(in *chat.TLChatSearch) (*chat.Vector_MutableChat, error) {
	var (
		chatList = &chat.Vector_MutableChat{
			Datas: []*mtproto.MutableChat{},
		}
	)

	// Check query string and limit
	if len(in.Q) < 3 || in.Limit <= 0 {
		return chatList, nil
	}

	if in.Limit > 50 {
		in.Limit = 50
	}

	// 构造模糊查询字符串
	q := "%" + in.Q + "%"

	c.svcCtx.Dao.ChatsDAO.SearchByQueryStringWithCB(
		c.ctx,
		q,
		in.Limit,
		func(sz, i int, v int64) {
			chat, err := c.svcCtx.Dao.GetExcludeParticipantsMutableChat(c.ctx, v)
			if err != nil {
				c.Logger.Errorf("chat.search - error: %v", err)
			} else if chat != nil {
				chatList.Datas = append(chatList.Datas, chat)
			}
		})

	return chatList, nil
}
