package core

import (
	"github.com/teamgram/proto/mtproto"
	"pwm-server/app/service/biz/user/user"
)

// UserSetAccountDaysTTL
// user.setAccountDaysTTL user_id:int ttl:int = Bool;
func (c *UserCore) UserSetAccountDaysTTL(in *user.TLUserSetAccountDaysTTL) (*mtproto.Bool, error) {
	c.svcCtx.Dao.UsersDAO.UpdateAccountDaysTTL(c.ctx, in.Ttl, in.UserId)

	return mtproto.BoolTrue, nil
}
