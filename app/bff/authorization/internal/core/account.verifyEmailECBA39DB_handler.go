package core

import (
	"github.com/teamgram/proto/mtproto"
)

// AccountVerifyEmailECBA39DB
// account.verifyEmail#ecba39db email:string code:string = Bool;
func (c *AuthorizationCore) AccountVerifyEmailECBA39DB(in *mtproto.TLAccountVerifyEmailECBA39DB) (*mtproto.Bool, error) {
	// TODO: not impl
	c.Logger.Errorf("account.verifyEmailECBA39DB blocked, License key from https://teamgram.net required to unlock enterprise features.")

	return nil, mtproto.ErrEnterpriseIsBlocked
}
