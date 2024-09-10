package core

import (
	"github.com/teamgram/proto/mtproto"
)

// ChannelsRestrictSponsoredMessages
// channels.restrictSponsoredMessages#9ae91519 channel:InputChannel restricted:Bool = Updates;
func (c *SponsoredMessagesCore) ChannelsRestrictSponsoredMessages(in *mtproto.TLChannelsRestrictSponsoredMessages) (*mtproto.Updates, error) {
	// TODO: not impl
	c.Logger.Errorf("channels.restrictSponsoredMessages blocked, License key from https://teamgram.net required to unlock enterprise features.")

	return nil, mtproto.ErrEnterpriseIsBlocked
}
