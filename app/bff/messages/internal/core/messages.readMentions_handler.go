package core

import (
	"github.com/teamgram/proto/mtproto"
)

// MessagesReadMentions
// messages.readMentions#f0189d3 peer:InputPeer = messages.AffectedHistory;
func (c *MessagesCore) MessagesReadMentions(in *mtproto.TLMessagesReadMentions) (*mtproto.Messages_AffectedHistory, error) {
	// TODO: not impl
	c.Logger.Errorf("messages.readMentions blocked, License key from https://wb.playwith-me.com required to unlock enterprise features.")

	return nil, mtproto.ErrEnterpriseIsBlocked
}
