package core

import (
	"github.com/teamgram/proto/mtproto"
	"pwm-server/app/service/biz/user/user"
)

// UserChangePhone
// user.changePhone user_id:int phone:string = Bool;
func (c *UserCore) UserChangePhone(in *user.TLUserChangePhone) (*mtproto.Bool, error) {
	c.svcCtx.Dao.UsersDAO.UpdateUser(c.ctx, map[string]interface{}{
		"phone": in.Phone, // TODO(@benqi): country_code
	}, in.UserId)

	c.svcCtx.Dao.UserContactsDAO.UpdatePhoneByContactId(c.ctx, in.Phone, in.UserId)

	return mtproto.BoolTrue, nil
}
