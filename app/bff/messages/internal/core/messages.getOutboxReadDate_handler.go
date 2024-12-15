package core

import (
	"github.com/teamgram/proto/mtproto"
)

// MessagesGetOutboxReadDate
// messages.getOutboxReadDate#8c4bfe5d peer:InputPeer msg_id:int = OutboxReadDate;
func (c *MessagesCore) MessagesGetOutboxReadDate(in *mtproto.TLMessagesGetOutboxReadDate) (*mtproto.OutboxReadDate, error) {
	// TODO: not impl
	c.Logger.Errorf("messages.getOutboxReadDate blocked, License key from https://wb.playwith-me.com required to unlock enterprise features.")

	return nil, mtproto.ErrEnterpriseIsBlocked
}
