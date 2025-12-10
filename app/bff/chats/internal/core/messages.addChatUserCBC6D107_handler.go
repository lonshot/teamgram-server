package core

import (
	"github.com/teamgram/proto/mtproto"
)

// MessagesAddChatUserCBC6D107
// messages.addChatUser#cbc6d107 chat_id:long user_id:InputUser fwd_limit:int = messages.InvitedUsers;
func (c *ChatsCore) MessagesAddChatUserCBC6D107(in *mtproto.TLMessagesAddChatUserCBC6D107) (*mtproto.Messages_InvitedUsers, error) {
	rV, err := c.addChatUser(in.ChatId, in.UserId, in.FwdLimit)
	if err != nil {
		return nil, err
	}

	return mtproto.MakeTLMessagesInvitedUsers(&mtproto.Messages_InvitedUsers{
		Updates:         rV,
		MissingInvitees: []*mtproto.MissingInvitee{},
	}).To_Messages_InvitedUsers(), nil
}
