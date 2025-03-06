package core

import (
	"github.com/teamgram/proto/mtproto"
	"pwm-server/app/service/biz/user/internal/dal/dataobject"
	"pwm-server/app/service/biz/user/user"
)

// UserSetContentSettings
// user.setContentSettings flags:# user_id:long sensitive_enabled:flags.0?true = Bool;
func (c *UserCore) UserSetContentSettings(in *user.TLUserSetContentSettings) (*mtproto.Bool, error) {
	var (
		k, v string
	)

	k = "sensitive_enabled"

	if in.SensitiveEnabled {
		v = "true"
	} else {
		v = "false"
	}

	// TODO: check
	// 403	SENSITIVE_CHANGE_FORBIDDEN	You can't change your sensitive content settings.

	_, _, err := c.svcCtx.Dao.UserSettingsDAO.InsertOrUpdate(c.ctx, &dataobject.UserSettingsDO{
		UserId: in.UserId,
		Key2:   k,
		Value:  v,
	})
	if err != nil {
		c.Logger.Errorf("user.setContentSettings - error: %v", err)
		return mtproto.BoolFalse, nil
	}

	return mtproto.BoolTrue, nil
}
