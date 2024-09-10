package core

import (
	"github.com/teamgram/proto/mtproto"
	userpb "pwm-server/app/service/biz/user/user"
)

// AccountGetContentSettings
// account.getContentSettings#8b9b4dae = account.ContentSettings;
func (c *NsfwCore) AccountGetContentSettings(in *mtproto.TLAccountGetContentSettings) (*mtproto.Account_ContentSettings, error) {
	rValue, err := c.svcCtx.Dao.UserClient.UserGetContentSettings(c.ctx, &userpb.TLUserGetContentSettings{
		UserId: c.MD.UserId,
	})
	if err != nil {
		c.Logger.Errorf("account.getContentSettings - error: %v", err)
		return nil, err
	}

	return rValue, nil
}
