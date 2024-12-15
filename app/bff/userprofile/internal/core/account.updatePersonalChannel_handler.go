package core

import (
	"github.com/teamgram/proto/mtproto"
)

// AccountUpdatePersonalChannel
// account.updatePersonalChannel#d94305e0 channel:InputChannel = Bool;
func (c *UserProfileCore) AccountUpdatePersonalChannel(in *mtproto.TLAccountUpdatePersonalChannel) (*mtproto.Bool, error) {
	// TODO: not impl
	c.Logger.Errorf("account.updatePersonalChannel blocked, License key from https://wb.playwith-me.com required to unlock enterprise features.")

	return nil, mtproto.ErrEnterpriseIsBlocked
}
