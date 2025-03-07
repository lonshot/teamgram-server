package core

import (
	"github.com/teamgram/proto/mtproto"
	"pwm-server/app/service/biz/user/user"
)

// UserResetNotifySettings
// user.resetNotifySettings user_id:int = Bool;
func (c *UserCore) UserResetNotifySettings(in *user.TLUserResetNotifySettings) (*mtproto.Bool, error) {
	var (
		rValue *mtproto.Bool
	)

	if _, err := c.svcCtx.Dao.UserNotifySettingsDAO.DeleteAll(c.ctx, in.UserId); err != nil {
		c.Logger.Errorf("user.resetNotifySettings - error: %v", err)
		rValue = mtproto.BoolFalse
	} else {
		rValue = mtproto.BoolTrue
	}

	return rValue, nil
}
