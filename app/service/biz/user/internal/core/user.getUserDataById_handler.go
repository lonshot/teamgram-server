package core

import (
	"github.com/teamgram/proto/mtproto"
	"pwm-server/app/service/biz/user/user"
)

// UserGetUserDataById
// user.getUserDataById user_id:long = UserData;
func (c *UserCore) UserGetUserDataById(in *user.TLUserGetUserDataById) (*mtproto.UserData, error) {
	cacheData := c.svcCtx.Dao.GetCacheUserData(c.ctx, in.UserId)
	if cacheData == nil {
		c.Logger.Errorf("user.getUserDataById - error: not found userId(%d)", in.UserId)
		return nil, mtproto.ErrUserIdInvalid
	}

	return cacheData.UserData, nil
}
