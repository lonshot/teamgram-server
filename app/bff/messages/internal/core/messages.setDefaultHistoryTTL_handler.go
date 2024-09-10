package core

import (
	"github.com/teamgram/proto/mtproto"
)

// MessagesSetDefaultHistoryTTL
// messages.setDefaultHistoryTTL#9eb51445 period:int = Bool;
func (c *MessagesCore) MessagesSetDefaultHistoryTTL(in *mtproto.TLMessagesSetDefaultHistoryTTL) (*mtproto.Bool, error) {
	// TODO: not impl
	c.Logger.Errorf("messages.setDefaultHistoryTTL blocked, License key from https://teamgram.net required to unlock enterprise features.")

	return nil, mtproto.ErrEnterpriseIsBlocked
}
