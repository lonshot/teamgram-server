package core

import (
	"github.com/teamgram/proto/mtproto"
)

// MessagesCreateChat92CEDDD4
// messages.createChat#92ceddd4 flags:# users:Vector<InputUser> title:string ttl_period:flags.0?int = messages.InvitedUsers;
func (c *ChatsCore) MessagesCreateChat92CEDDD4(in *mtproto.TLMessagesCreateChat92CEDDD4) (*mtproto.Messages_InvitedUsers, error) {
	rV, err := c.createChat(in.Users, in.Title, in.GetTtlPeriod().GetValue())
	if err != nil {
		return nil, err
	}

	return mtproto.MakeTLMessagesInvitedUsers(&mtproto.Messages_InvitedUsers{
		Updates:         rV,
		MissingInvitees: []*mtproto.MissingInvitee{},
	}).To_Messages_InvitedUsers(), nil
}
