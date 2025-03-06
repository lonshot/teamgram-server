package core

import (
	"github.com/teamgram/proto/mtproto"
	userpb "pwm-server/app/service/biz/user/user"
)

// AccountSetContactSignUpNotification
// account.setContactSignUpNotification#cff43f61 silent:Bool = Bool;
func (c *ContactsCore) AccountSetContactSignUpNotification(in *mtproto.TLAccountSetContactSignUpNotification) (*mtproto.Bool, error) {
	rValue, err := c.svcCtx.Dao.UserClient.UserSetContactSignUpNotification(c.ctx, &userpb.TLUserSetContactSignUpNotification{
		UserId: c.MD.UserId,
		Silent: in.Silent,
	})
	if err != nil {
		c.Logger.Errorf("account.setContactSignUpNotification - error: %v", err)
		return mtproto.BoolFalse, nil
	}

	return rValue, nil
}
