package core

import (
	"github.com/teamgram/proto/mtproto"
)

// AccountSetAuthorizationTTL
// account.setAuthorizationTTL#bf899aa0 authorization_ttl_days:int = Bool;
func (c *AuthorizationCore) AccountSetAuthorizationTTL(in *mtproto.TLAccountSetAuthorizationTTL) (*mtproto.Bool, error) {
	// TODO: not impl
	c.Logger.Errorf("account.setAuthorizationTTL blocked, License key from https://teamgram.net required to unlock enterprise features.")

	return nil, mtproto.ErrEnterpriseIsBlocked
}
