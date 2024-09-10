package core

import (
	"github.com/teamgram/proto/mtproto"
)

// AuthCheckRecoveryPassword
// auth.checkRecoveryPassword#d36bf79 code:string = Bool;
func (c *AuthorizationCore) AuthCheckRecoveryPassword(in *mtproto.TLAuthCheckRecoveryPassword) (*mtproto.Bool, error) {
	// TODO: not impl
	c.Logger.Errorf("auth.checkRecoveryPassword blocked, License key from https://teamgram.net required to unlock enterprise features.")

	return nil, mtproto.ErrEnterpriseIsBlocked
}
