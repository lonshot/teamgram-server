package core

import (
	"github.com/teamgram/proto/mtproto"
	userpb "pwm-server/app/service/biz/user/user"
)

// AccountGetAccountTTL
// account.getAccountTTL#8fc711d = AccountDaysTTL;
func (c *AccountCore) AccountGetAccountTTL(in *mtproto.TLAccountGetAccountTTL) (*mtproto.AccountDaysTTL, error) {
	days, err := c.svcCtx.Dao.UserClient.UserGetAccountDaysTTL(c.ctx, &userpb.TLUserGetAccountDaysTTL{
		UserId: c.MD.UserId,
	})
	if err != nil {
		c.Logger.Errorf("account.getAccountTTL - error: %v", err)
		return nil, err
	}

	return mtproto.MakeTLAccountDaysTTL(&mtproto.AccountDaysTTL{
		Days: days.Days,
	}).To_AccountDaysTTL(), nil
}
