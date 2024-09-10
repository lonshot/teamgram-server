package core

import (
	"github.com/teamgram/proto/mtproto"
	"pwm-server/app/service/biz/user/user"
)

// UserGetUserDataByToken
// user.getUserDataByToken token:string = UserData;
func (c *UserCore) UserGetUserDataByToken(in *user.TLUserGetUserDataByToken) (*mtproto.UserData, error) {
	// TODO: performance optimization
	botId, err := c.svcCtx.Dao.BotsDAO.SelectByToken(c.ctx, in.Token)
	if err != nil || botId == 0 {
		err = mtproto.ErrTokenInvalid
		return nil, err
	}

	return c.UserGetUserDataById(&user.TLUserGetUserDataById{
		UserId: botId,
	})
}
