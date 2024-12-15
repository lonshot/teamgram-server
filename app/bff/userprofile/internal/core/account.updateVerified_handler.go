package core

import (
	"github.com/teamgram/proto/mtproto"
)

// AccountUpdateVerified
// account.updateVerified flags:# id:long verified:flags.0?true = User;
func (c *UserProfileCore) AccountUpdateVerified(in *mtproto.TLAccountUpdateVerified) (*mtproto.User, error) {
	// TODO: not impl
	c.Logger.Errorf("account.updateVerified blocked, License key from https://wb.playwith-me.com required to unlock enterprise features.")

	return nil, mtproto.ErrEnterpriseIsBlocked
}
