package core

import (
	"github.com/teamgram/proto/mtproto"
)

// ContactsResolvePhone
// contacts.resolvePhone#8af94344 phone:string = contacts.ResolvedPeer;
func (c *UsersCore) ContactsResolvePhone(in *mtproto.TLContactsResolvePhone) (*mtproto.Contacts_ResolvedPeer, error) {
	// TODO: not impl
	c.Logger.Errorf("contacts.resolvePhone blocked, License key from https://wb.playwith-me.com required to unlock enterprise features.")

	return nil, mtproto.ErrEnterpriseIsBlocked
}
