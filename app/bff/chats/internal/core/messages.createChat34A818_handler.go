package core

import (
	"github.com/teamgram/proto/mtproto"
)

// MessagesCreateChat34A818
// messages.createChat#34a818 flags:# users:Vector<InputUser> title:string ttl_period:flags.0?int = Updates;
func (c *ChatsCore) MessagesCreateChat34A818(in *mtproto.TLMessagesCreateChat34A818) (*mtproto.Updates, error) {
	return c.createChat(in.Users, in.Title, in.GetTtlPeriod().GetValue())
}
