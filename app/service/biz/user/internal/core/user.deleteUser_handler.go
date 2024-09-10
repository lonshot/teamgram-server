package core

import (
	"github.com/teamgram/proto/mtproto"
	"pwm-server/app/service/biz/user/user"
)

// UserDeleteUser
// user.deleteUser user_id:long reason:string = Bool;
func (c *UserCore) UserDeleteUser(in *user.TLUserDeleteUser) (*mtproto.Bool, error) {
	rB := c.svcCtx.Dao.DeleteUser(
		c.ctx,
		in.GetUserId(),
		in.GetReason())

	return mtproto.ToBool(rB), nil
}
