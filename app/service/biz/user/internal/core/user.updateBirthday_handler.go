package core

import (
	"github.com/teamgram/proto/mtproto"
	"pwm-server/app/service/biz/user/user"
)

// UserUpdateBirthday
// user.updateBirthday flags:# user_id:long birthday:flags.1?Birthday = Bool;
func (c *UserCore) UserUpdateBirthday(in *user.TLUserUpdateBirthday) (*mtproto.Bool, error) {
	rB := c.svcCtx.Dao.UpdateBirthday(
		c.ctx,
		in.GetUserId(),
		in.GetBirthday())

	return mtproto.ToBool(rB), nil
}
