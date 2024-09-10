package core

import (
	"github.com/teamgram/proto/mtproto"
)

// ContactsAcceptContact
// contacts.acceptContact#f831a20f id:InputUser = Updates;
func (c *ContactsCore) ContactsAcceptContact(in *mtproto.TLContactsAcceptContact) (*mtproto.Updates, error) {
	// TODO: not impl
	c.Logger.Errorf("contacts.acceptContact blocked, License key from https://teamgram.net required to unlock enterprise features.")

	return mtproto.MakeEmptyUpdates(), nil
}
