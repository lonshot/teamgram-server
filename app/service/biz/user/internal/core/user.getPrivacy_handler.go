package core

import (
	"github.com/teamgram/proto/mtproto"
	"pwm-server/app/service/biz/user/user"
)

// UserGetPrivacy
// user.getPrivacy user_id:int key_type:int = Vector<PrivacyRule>;
func (c *UserCore) UserGetPrivacy(in *user.TLUserGetPrivacy) (*user.Vector_PrivacyRule, error) {
	rulesList := c.svcCtx.Dao.GetUserPrivacyRulesListByKeys(c.ctx, in.GetUserId(), in.GetKeyType())
	if len(rulesList) == 0 {
		err := mtproto.ErrPrivacyKeyInvalid
		c.Logger.Errorf("user.getPrivacy - error: %v", err)
		return nil, err
	}

	return &user.Vector_PrivacyRule{
		Datas: rulesList[0].GetRules(),
	}, nil
}
