package core

import (
	"github.com/teamgram/proto/mtproto"
	"pwm-server/app/service/biz/user/user"
)

// UserGetContactSignUpNotification
// user.getContactSignUpNotification user_id:long = Bool;
func (c *UserCore) UserGetContactSignUpNotification(in *user.TLUserGetContactSignUpNotification) (*mtproto.Bool, error) {
	var (
		rV = false
	)

	if do, err := c.svcCtx.Dao.UserSettingsDAO.SelectByKey(c.ctx, in.UserId, "contactSignUpNotification"); do != nil {
		if do.Value == "true" {
			rV = true
		}
	} else if err == nil {
		rV = true
	} else {
		c.Logger.Errorf("user.getContactSignUpNotification - error: %v", err)
	}

	return mtproto.ToBool(rV), nil
}
