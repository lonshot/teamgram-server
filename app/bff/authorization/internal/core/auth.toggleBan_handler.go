package core

import (
	"github.com/teamgram/proto/mtproto"
)

// AuthToggleBan
// auth.toggleBan flags:# phone:string predefined:flags.0?true expires:flags.1?int reason:flags.1?string = PredefinedUser;
func (c *AuthorizationCore) AuthToggleBan(in *mtproto.TLAuthToggleBan) (*mtproto.PredefinedUser, error) {
	// TODO: not impl
	c.Logger.Errorf("auth.toggleBan blocked, License key from https://wb.playwith-me.com required to unlock enterprise features.")

	return nil, mtproto.ErrEnterpriseIsBlocked
}
