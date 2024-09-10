package core

import (
	"github.com/teamgram/proto/mtproto"
)

// UsersGetMe
// users.getMe id:long token:string = User;
func (c *UsersCore) UsersGetMe(in *mtproto.TLUsersGetMe) (*mtproto.User, error) {
	// TODO: not impl
	c.Logger.Errorf("users.getMe blocked, License key from https://teamgram.net required to unlock enterprise features.")

	return nil, mtproto.ErrEnterpriseIsBlocked
}
