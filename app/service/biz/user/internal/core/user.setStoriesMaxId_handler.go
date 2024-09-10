package core

import (
	"github.com/teamgram/proto/mtproto"
	"pwm-server/app/service/biz/user/user"
)

// UserSetStoriesMaxId
// user.setStoriesMaxId user_id:long id:int = Bool;
func (c *UserCore) UserSetStoriesMaxId(in *user.TLUserSetStoriesMaxId) (*mtproto.Bool, error) {
	rB := c.svcCtx.Dao.UpdateStoriesMaxId(
		c.ctx,
		in.GetUserId(),
		in.GetId())

	return mtproto.ToBool(rB), nil
}
