package core

import (
	"github.com/teamgram/proto/mtproto"
	"pwm-server/app/service/biz/user/user"
)

// UserGetImmutableUserByToken
// user.getImmutableUserByToken token:string = ImmutableUser;
func (c *UserCore) UserGetImmutableUserByToken(in *user.TLUserGetImmutableUserByToken) (*mtproto.ImmutableUser, error) {
	// TODO: performance optimization
	botId, err := c.svcCtx.Dao.BotsDAO.SelectByToken(c.ctx, in.Token)
	if err != nil || botId == 0 {
		err = mtproto.ErrTokenInvalid
		return nil, err
	}

	return c.UserGetImmutableUser(&user.TLUserGetImmutableUser{
		Id: botId,
	})
}
