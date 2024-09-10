package core

import (
	"github.com/teamgram/proto/mtproto"
)

// MessagesSaveDefaultSendAs
// messages.saveDefaultSendAs#ccfddf96 peer:InputPeer send_as:InputPeer = Bool;
func (c *MessagesCore) MessagesSaveDefaultSendAs(in *mtproto.TLMessagesSaveDefaultSendAs) (*mtproto.Bool, error) {
	// TODO: not impl
	c.Logger.Errorf("messages.saveDefaultSendAs blocked, License key from https://teamgram.net required to unlock enterprise features.")

	return nil, mtproto.ErrEnterpriseIsBlocked
}
