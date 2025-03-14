package core

import (
	"github.com/teamgram/proto/mtproto"
	"pwm-server/app/service/biz/user/user"
)

// UserGetAccountDaysTTL
// user.getAccountDaysTTL user_id:int = AccountDaysTTL;
func (c *UserCore) UserGetAccountDaysTTL(in *user.TLUserGetAccountDaysTTL) (*mtproto.AccountDaysTTL, error) {
	userDO, _ := c.svcCtx.Dao.UsersDAO.SelectAccountDaysTTL(c.ctx, in.UserId)
	if userDO == nil {
		err := mtproto.ErrUserIdInvalid
		c.Logger.Errorf("user.getAccountDaysTTL - error: %v", err)
		return nil, err
	}

	return mtproto.MakeTLAccountDaysTTL(&mtproto.AccountDaysTTL{
		Days: userDO.AccountDaysTtl,
	}).To_AccountDaysTTL(), nil
}
