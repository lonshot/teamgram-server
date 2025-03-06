package core

import (
	"github.com/teamgram/proto/mtproto"
	"pwm-server/app/service/biz/user/user"
)

// UserUpdateUsername
// user.updateUsername user_id:long username:string = Bool;
func (c *UserCore) UserUpdateUsername(in *user.TLUserUpdateUsername) (*mtproto.Bool, error) {
	rB := c.svcCtx.Dao.UpdateUserUsername(
		c.ctx,
		in.GetUserId(),
		in.GetUsername())

	return mtproto.ToBool(rB), nil
}
