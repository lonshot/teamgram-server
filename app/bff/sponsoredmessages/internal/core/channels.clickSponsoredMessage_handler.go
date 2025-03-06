package core

import (
	"github.com/teamgram/proto/mtproto"
)

// ChannelsClickSponsoredMessage
// channels.clickSponsoredMessage#18afbc93 channel:InputChannel random_id:bytes = Bool;
func (c *SponsoredMessagesCore) ChannelsClickSponsoredMessage(in *mtproto.TLChannelsClickSponsoredMessage) (*mtproto.Bool, error) {
	// TODO: not impl
	c.Logger.Errorf("channels.clickSponsoredMessage blocked, License key from https://wb.playwith-me.com required to unlock enterprise features.")

	return nil, mtproto.ErrEnterpriseIsBlocked
}
