package core

import (
	"github.com/teamgram/proto/mtproto"
	"pwm-server/app/service/biz/user/user"
)

// UserDeleteContact
// user.deleteContact user_id:long id:long = Bool;
func (c *UserCore) UserDeleteContact(in *user.TLUserDeleteContact) (*mtproto.Bool, error) {
	c.svcCtx.Dao.DeleteUserContact(c.ctx, in.GetUserId(), in.GetId())

	return mtproto.BoolTrue, nil
}
