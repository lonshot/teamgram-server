package core

import (
	"github.com/teamgram/proto/mtproto"
)

// AuthDropTempAuthKeys
// auth.dropTempAuthKeys#8e48a188 except_auth_keys:Vector<long> = Bool;
func (c *AuthorizationCore) AuthDropTempAuthKeys(in *mtproto.TLAuthDropTempAuthKeys) (*mtproto.Bool, error) {
	// TODO: not impl
	// c.Logger.Errorf("auth.dropTempAuthKeys blocked, License key from https://teamgram.net required to unlock enterprise features.")

	return mtproto.BoolTrue, nil
}
