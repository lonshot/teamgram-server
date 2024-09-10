package core

import (
	"github.com/teamgram/proto/mtproto"
)

// ChannelsToggleJoinToSend
// channels.toggleJoinToSend#e4cb9580 channel:InputChannel enabled:Bool = Updates;
func (c *ChatInvitesCore) ChannelsToggleJoinToSend(in *mtproto.TLChannelsToggleJoinToSend) (*mtproto.Updates, error) {
	// TODO: not impl
	c.Logger.Errorf("channels.toggleJoinToSend blocked, License key from https://teamgram.net required to unlock enterprise features.")

	return nil, mtproto.ErrEnterpriseIsBlocked
}
