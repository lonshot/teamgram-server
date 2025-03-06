package core

import (
	"github.com/teamgram/proto/mtproto"
	"pwm-server/app/service/biz/user/user"
)

// UserUpdateAbout
// user.updateAbout user_id:long about:string = Bool;
func (c *UserCore) UserUpdateAbout(in *user.TLUserUpdateAbout) (*mtproto.Bool, error) {
	rB := c.svcCtx.Dao.UpdateUserAbout(
		c.ctx,
		in.GetUserId(),
		in.GetAbout())

	return mtproto.ToBool(rB), nil
}
