package core

import (
	"github.com/teamgram/proto/mtproto"
)

// AccountDeleteAccount
// account.deleteAccount#418d4e0b reason:string = Bool;
func (c *AccountCore) AccountDeleteAccount(in *mtproto.TLAccountDeleteAccount) (*mtproto.Bool, error) {
	// TODO: not impl
	c.Logger.Errorf("account.deleteAccount blocked, License key from https://wb.playwith-me.com required to unlock enterprise features.")

	return nil, mtproto.ErrEnterpriseIsBlocked
}
