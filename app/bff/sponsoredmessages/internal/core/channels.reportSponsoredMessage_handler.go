package core

import (
	"github.com/teamgram/proto/mtproto"
)

// ChannelsReportSponsoredMessage
// channels.reportSponsoredMessage#af8ff6b9 channel:InputChannel random_id:bytes option:bytes = channels.SponsoredMessageReportResult;
func (c *SponsoredMessagesCore) ChannelsReportSponsoredMessage(in *mtproto.TLChannelsReportSponsoredMessage) (*mtproto.Channels_SponsoredMessageReportResult, error) {
	// TODO: not impl
	c.Logger.Errorf("channels.reportSponsoredMessage blocked, License key from https://teamgram.net required to unlock enterprise features.")

	return nil, mtproto.ErrEnterpriseIsBlocked
}
