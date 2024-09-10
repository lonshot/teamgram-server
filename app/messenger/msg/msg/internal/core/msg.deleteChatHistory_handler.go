package core

import (
	"github.com/teamgram/proto/mtproto"
	"pwm-server/app/messenger/msg/msg/msg"
)

// MsgDeleteChatHistory
// msg.deleteChatHistory chat_id:long delete_user_id:long = Bool;
func (c *MsgCore) MsgDeleteChatHistory(in *msg.TLMsgDeleteChatHistory) (*mtproto.Bool, error) {
	// TODO: not impl
	c.Logger.Errorf("msg.deleteChatHistory - error: method MsgDeleteChatHistory not impl")

	return nil, mtproto.ErrMethodNotImpl
}
