package core

import (
	"github.com/teamgram/proto/mtproto"
)

// MessagesHideAllChatJoinRequests
// messages.hideAllChatJoinRequests#e085f4ea flags:# approved:flags.0?true peer:InputPeer link:flags.1?string = Updates;
func (c *ChatInvitesCore) MessagesHideAllChatJoinRequests(in *mtproto.TLMessagesHideAllChatJoinRequests) (*mtproto.Updates, error) {
	// TODO: not impl
	c.Logger.Errorf("messages.hideAllChatJoinRequests blocked, License key from https://wb.playwith-me.com required to unlock enterprise features.")

	return nil, mtproto.ErrEnterpriseIsBlocked
}
