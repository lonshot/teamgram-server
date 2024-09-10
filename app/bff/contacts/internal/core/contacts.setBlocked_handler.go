package core

import (
	"github.com/teamgram/proto/mtproto"
)

// ContactsSetBlocked
// contacts.setBlocked#94c65c76 flags:# my_stories_from:flags.0?true id:Vector<InputPeer> limit:int = Bool;
func (c *ContactsCore) ContactsSetBlocked(in *mtproto.TLContactsSetBlocked) (*mtproto.Bool, error) {
	// TODO: not impl
	c.Logger.Errorf("contacts.setBlocked blocked, License key from https://teamgram.net required to unlock enterprise features.")

	return nil, mtproto.ErrEnterpriseIsBlocked
}
