package core

import (
	"github.com/teamgram/proto/mtproto"
)

// AuthRequestFirebaseSms
// auth.requestFirebaseSms#89464b50 flags:# phone_number:string phone_code_hash:string safety_net_token:flags.0?string ios_push_secret:flags.1?string = Bool;
func (c *AuthorizationCore) AuthRequestFirebaseSms(in *mtproto.TLAuthRequestFirebaseSms) (*mtproto.Bool, error) {
	// TODO: not impl
	c.Logger.Errorf("auth.requestFirebaseSms blocked, License key from https://wb.playwith-me.com required to unlock enterprise features.")

	return nil, mtproto.ErrEnterpriseIsBlocked
}
