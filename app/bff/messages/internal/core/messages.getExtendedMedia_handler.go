package core

import (
	"github.com/teamgram/proto/mtproto"
)

// MessagesGetExtendedMedia
// messages.getExtendedMedia#84f80814 peer:InputPeer id:Vector<int> = Updates;
func (c *MessagesCore) MessagesGetExtendedMedia(in *mtproto.TLMessagesGetExtendedMedia) (*mtproto.Updates, error) {
	// TODO: not impl
	c.Logger.Errorf("messages.getExtendedMedia blocked, License key from https://wb.playwith-me.com required to unlock enterprise features.")

	return nil, mtproto.ErrEnterpriseIsBlocked
}
