package core

import (
	"github.com/teamgram/proto/mtproto"
)

// AccountToggleSponsoredMessages
// account.toggleSponsoredMessages#b9d9a38d enabled:Bool = Bool;
func (c *SponsoredMessagesCore) AccountToggleSponsoredMessages(in *mtproto.TLAccountToggleSponsoredMessages) (*mtproto.Bool, error) {
	// TODO: not impl
	c.Logger.Errorf("account.toggleSponsoredMessages blocked, License key from https://wb.playwith-me.com required to unlock enterprise features.")

	return nil, mtproto.ErrEnterpriseIsBlocked
}
