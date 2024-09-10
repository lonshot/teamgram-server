package core

import (
	"github.com/teamgram/proto/mtproto"
)

// MessagesCreateChat9CB126E
// messages.createChat#9cb126e users:Vector<InputUser> title:string = Updates;
func (c *ChatsCore) MessagesCreateChat9CB126E(in *mtproto.TLMessagesCreateChat9CB126E) (*mtproto.Updates, error) {
	return c.createChat(in.Users, in.Title, 0)
}
