package core

import (
	"github.com/teamgram/proto/mtproto"
	"pwm-server/app/service/biz/user/user"
)

// UserUpdateFirstAndLastName
// user.updateFirstAndLastName user_id:long first_name:string last_name:string = Bool;
func (c *UserCore) UserUpdateFirstAndLastName(in *user.TLUserUpdateFirstAndLastName) (*mtproto.Bool, error) {
	rB := c.svcCtx.Dao.UpdateUserFirstAndLastName(
		c.ctx,
		in.GetUserId(),
		in.GetFirstName(),
		in.GetLastName())

	return mtproto.ToBool(rB), nil
}
