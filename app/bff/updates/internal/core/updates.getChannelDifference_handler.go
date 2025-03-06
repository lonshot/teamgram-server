package core

import (
	"github.com/teamgram/proto/mtproto"
)

// UpdatesGetChannelDifference
// updates.getChannelDifference#3173d78 flags:# force:flags.0?true channel:InputChannel filter:ChannelMessagesFilter pts:int limit:int = updates.ChannelDifference;
func (c *UpdatesCore) UpdatesGetChannelDifference(in *mtproto.TLUpdatesGetChannelDifference) (*mtproto.Updates_ChannelDifference, error) {
	// TODO: not impl
	c.Logger.Errorf("updates.getChannelDifference blocked, License key from https://wb.playwith-me.com required to unlock enterprise features.")

	return nil, mtproto.ErrEnterpriseIsBlocked
}
