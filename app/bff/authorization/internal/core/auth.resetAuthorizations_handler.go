package core

import (
	"github.com/teamgram/proto/mtproto"
)

// AuthResetAuthorizations
// auth.resetAuthorizations#9fab0d1a = Bool;
func (c *AuthorizationCore) AuthResetAuthorizations(in *mtproto.TLAuthResetAuthorizations) (*mtproto.Bool, error) {
	// TODO: not impl
	c.Logger.Errorf("auth.resetAuthorizations blocked, License key from https://wb.playwith-me.com required to unlock enterprise features.")

	return nil, mtproto.ErrEnterpriseIsBlocked
}
