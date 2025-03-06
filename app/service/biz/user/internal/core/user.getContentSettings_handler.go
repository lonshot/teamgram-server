package core

import (
	"github.com/teamgram/proto/mtproto"
	"pwm-server/app/service/biz/user/user"
)

// UserGetContentSettings
// user.getContentSettings user_id:long = account.ContentSettings;
func (c *UserCore) UserGetContentSettings(in *user.TLUserGetContentSettings) (*mtproto.Account_ContentSettings, error) {
	var (
		rV = false
	)

	if do, _ := c.svcCtx.Dao.UserSettingsDAO.SelectByKey(c.ctx, in.UserId, "sensitive_enabled"); do != nil {
		if do.Value == "true" {
			rV = true
		}
	}

	return mtproto.MakeTLAccountContentSettings(&mtproto.Account_ContentSettings{
		SensitiveEnabled:   rV,
		SensitiveCanChange: true,
	}).To_Account_ContentSettings(), nil
}
