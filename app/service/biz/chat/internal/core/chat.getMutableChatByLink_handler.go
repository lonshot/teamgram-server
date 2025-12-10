package core

import (
	"github.com/teamgram/proto/mtproto"
	"pwm-server/app/service/biz/chat/chat"
)

// ChatGetMutableChatByLink
// chat.getMutableChatByLink link:string = MutableChat;
func (c *ChatCore) ChatGetMutableChatByLink(in *chat.TLChatGetMutableChatByLink) (*mtproto.MutableChat, error) {
	// TODO: not impl
	c.Logger.Errorf("chat.getMutableChatByLink - error: method ChatGetMutableChatByLink not impl")

	return nil, mtproto.ErrMethodNotImpl
}
