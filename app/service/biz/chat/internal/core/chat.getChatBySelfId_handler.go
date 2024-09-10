package core

import (
	"github.com/teamgram/proto/mtproto"
	"pwm-server/app/service/biz/chat/chat"
)

// ChatGetChatBySelfId
// chat.getChatBySelfId self_id:long chat_id:long = MutableChat;
func (c *ChatCore) ChatGetChatBySelfId(in *chat.TLChatGetChatBySelfId) (*mtproto.MutableChat, error) {
	chat2, err := c.svcCtx.Dao.GetMutableChat(c.ctx, in.ChatId, in.SelfId)
	if err != nil {
		c.Logger.Errorf("chat.getMutableChat - error: %v", err)
		return nil, err
	}

	return chat2, nil
}
