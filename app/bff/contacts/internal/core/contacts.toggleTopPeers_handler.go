package core

import (
	"github.com/teamgram/proto/mtproto"
)

// ContactsToggleTopPeers
// contacts.toggleTopPeers#8514bdda enabled:Bool = Bool;
func (c *ContactsCore) ContactsToggleTopPeers(in *mtproto.TLContactsToggleTopPeers) (*mtproto.Bool, error) {
	// TODO: not impl
	c.Logger.Errorf("contacts.toggleTopPeers blocked, License key from https://wb.playwith-me.com required to unlock enterprise features.")

	return mtproto.BoolTrue, nil
}
