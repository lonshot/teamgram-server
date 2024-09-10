package core

import (
	"github.com/teamgram/proto/mtproto"
)

// MessagesAddChatUserF24753E3
// messages.addChatUser#f24753e3 chat_id:long user_id:InputUser fwd_limit:int = Updates;
func (c *ChatsCore) MessagesAddChatUserF24753E3(in *mtproto.TLMessagesAddChatUserF24753E3) (*mtproto.Updates, error) {
	return c.addChatUser(in.ChatId, in.UserId, in.FwdLimit)
}
