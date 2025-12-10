package core

import (
	"github.com/teamgram/proto/mtproto"
	"pwm-server/app/service/biz/user/user"
)

// UserSetPrivacy
// user.setPrivacy user_id:int key_type:int rules:Vector<PrivacyRule> = Bool;
func (c *UserCore) UserSetPrivacy(in *user.TLUserSetPrivacy) (*mtproto.Bool, error) {
	c.svcCtx.Dao.SetUserPrivacyRules(
		c.ctx,
		in.GetUserId(),
		in.GetKeyType(),
		in.GetRules())

	return mtproto.BoolTrue, nil
}
