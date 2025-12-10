package core

import (
	"github.com/teamgram/proto/mtproto"
	userpb "pwm-server/app/service/biz/user/user"
)

// AccountSetGlobalPrivacySettings
// account.setGlobalPrivacySettings#1edaaac2 settings:GlobalPrivacySettings = GlobalPrivacySettings;
func (c *PrivacySettingsCore) AccountSetGlobalPrivacySettings(in *mtproto.TLAccountSetGlobalPrivacySettings) (*mtproto.GlobalPrivacySettings, error) {
	rSettings := in.GetSettings()

	_, err := c.svcCtx.Dao.UserClient.UserSetGlobalPrivacySettings(c.ctx, &userpb.TLUserSetGlobalPrivacySettings{
		UserId:   c.MD.UserId,
		Settings: rSettings,
	})
	if err != nil {
		c.Logger.Errorf("account.setGlobalPrivacySettings - error: %v", err)
		return nil, err
	}

	return rSettings, nil
}
