package core

import (
	"github.com/teamgram/proto/mtproto"
)

// AccountChangeAuthorizationSettings
// account.changeAuthorizationSettings#40f48462 flags:# hash:long encrypted_requests_disabled:flags.0?Bool call_requests_disabled:flags.1?Bool = Bool;
func (c *AuthorizationCore) AccountChangeAuthorizationSettings(in *mtproto.TLAccountChangeAuthorizationSettings) (*mtproto.Bool, error) {
	// TODO: not impl
	c.Logger.Errorf("account.changeAuthorizationSettings blocked, License key from https://wb.playwith-me.com required to unlock enterprise features.")

	return nil, mtproto.ErrEnterpriseIsBlocked
}
