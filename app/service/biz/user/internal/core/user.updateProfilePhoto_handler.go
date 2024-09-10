package core

import (
	"github.com/teamgram/proto/mtproto"
	"pwm-server/app/service/biz/user/user"
)

// UserUpdateProfilePhoto
// user.updateProfilePhoto user_id:long id:long = Int64;
func (c *UserCore) UserUpdateProfilePhoto(in *user.TLUserUpdateProfilePhoto) (*mtproto.Int64, error) {
	rV := c.svcCtx.Dao.UpdateProfilePhoto(
		c.ctx,
		in.GetUserId(),
		in.GetId())

	return &mtproto.Int64{
		V: rV,
	}, nil
}
