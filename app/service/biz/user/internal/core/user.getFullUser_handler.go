package core

import (
	"github.com/teamgram/proto/mtproto"
	"pwm-server/app/service/biz/user/user"
)

// UserGetFullUser
// user.getFullUser self_user_id:long id:long = users.UserFull;
func (c *UserCore) UserGetFullUser(in *user.TLUserGetFullUser) (*mtproto.Users_UserFull, error) {
	// TODO: not impl
	c.Logger.Errorf("user.getFullUser - error: method UserGetFullUser not impl")

	return nil, mtproto.ErrMethodNotImpl
}
