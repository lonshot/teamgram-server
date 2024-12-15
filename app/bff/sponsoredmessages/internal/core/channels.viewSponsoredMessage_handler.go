package core

import (
	"github.com/teamgram/proto/mtproto"
)

// ChannelsViewSponsoredMessage
// channels.viewSponsoredMessage#beaedb94 channel:InputChannel random_id:bytes = Bool;
func (c *SponsoredMessagesCore) ChannelsViewSponsoredMessage(in *mtproto.TLChannelsViewSponsoredMessage) (*mtproto.Bool, error) {
	// TODO: not impl
	c.Logger.Errorf("channels.viewSponsoredMessage blocked, License key from https://wb.playwith-me.com required to unlock enterprise features.")

	return nil, mtproto.ErrEnterpriseIsBlocked
}
