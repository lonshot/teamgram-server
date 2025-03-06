package core

import (
	"github.com/teamgram/proto/mtproto"
	"pwm-server/app/service/biz/user/user"
)

// AccountUpdateBirthday
// account.updateBirthday#cc6e0c11 flags:# birthday:flags.0?Birthday = Bool;
func (c *UserProfileCore) AccountUpdateBirthday(in *mtproto.TLAccountUpdateBirthday) (*mtproto.Bool, error) {
	rV, err := c.svcCtx.Dao.UserClient.UserUpdateBirthday(c.ctx, &user.TLUserUpdateBirthday{
		UserId:   c.MD.UserId,
		Birthday: in.GetBirthday(),
	})
	if err != nil {
		c.Logger.Errorf("account.updateBirthday - error: %v", err)
		return nil, err
	}

	return rV, nil
}
