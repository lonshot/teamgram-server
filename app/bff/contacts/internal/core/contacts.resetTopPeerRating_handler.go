package core

import (
	"github.com/teamgram/proto/mtproto"
)

// ContactsResetTopPeerRating
// contacts.resetTopPeerRating#1ae373ac category:TopPeerCategory peer:InputPeer = Bool;
func (c *ContactsCore) ContactsResetTopPeerRating(in *mtproto.TLContactsResetTopPeerRating) (*mtproto.Bool, error) {
	// TODO: not impl
	c.Logger.Errorf("contacts.resetTopPeerRating blocked, License key from https://teamgram.net required to unlock enterprise features.")

	return mtproto.BoolTrue, nil
}
