package core

import (
	"github.com/teamgram/proto/mtproto"
)

// ContactsResetSaved
// contacts.resetSaved#879537f1 = Bool;
func (c *ContactsCore) ContactsResetSaved(in *mtproto.TLContactsResetSaved) (*mtproto.Bool, error) {
	// TODO: not impl
	// c.Logger.Errorf("contacts.resetSaved blocked, License key from https://wb.playwith-me.com required to unlock enterprise features.")

	return mtproto.BoolTrue, nil
}
