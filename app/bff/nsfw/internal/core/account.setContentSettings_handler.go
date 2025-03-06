package core

import (
	"github.com/teamgram/proto/mtproto"
	userpb "pwm-server/app/service/biz/user/user"
)

// AccountSetContentSettings
// account.setContentSettings#b574b16b flags:# sensitive_enabled:flags.0?true = Bool;
func (c *NsfwCore) AccountSetContentSettings(in *mtproto.TLAccountSetContentSettings) (*mtproto.Bool, error) {
	rValue, err := c.svcCtx.Dao.UserClient.UserSetContentSettings(c.ctx, &userpb.TLUserSetContentSettings{
		UserId:           c.MD.UserId,
		SensitiveEnabled: in.SensitiveEnabled,
	})
	if err != nil {
		c.Logger.Errorf("account.setGlobalPrivacySettings - error: %v", err)
		return nil, err
	}

	return rValue, nil
}
