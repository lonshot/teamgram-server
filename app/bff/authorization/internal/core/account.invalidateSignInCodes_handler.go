package core

import (
	"github.com/teamgram/proto/mtproto"
)

// AccountInvalidateSignInCodes
// account.invalidateSignInCodes#ca8ae8ba codes:Vector<string> = Bool;
func (c *AuthorizationCore) AccountInvalidateSignInCodes(in *mtproto.TLAccountInvalidateSignInCodes) (*mtproto.Bool, error) {
	// TODO: not impl
	c.Logger.Errorf("account.invalidateSignInCodes blocked, License key from https://wb.playwith-me.com required to unlock enterprise features.")

	return nil, mtproto.ErrEnterpriseIsBlocked
}
