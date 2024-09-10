package core

import (
	"github.com/teamgram/proto/mtproto"
	"pwm-server/app/service/biz/user/user"
)

// UserUpdateVerified
// user.updateVerified user_id:long verified:Bool = Bool;
func (c *UserCore) UserUpdateVerified(in *user.TLUserUpdateVerified) (*mtproto.Bool, error) {
	rowsAffected, err := c.svcCtx.Dao.UsersDAO.UpdateUser(c.ctx, map[string]interface{}{
		"verified": mtproto.FromBool(in.Verified),
	}, in.UserId)

	if err != nil {
		c.Logger.Errorf("user.updateVerified - error: %v", err)
		return mtproto.BoolFalse, nil
	}

	return mtproto.ToBool(rowsAffected != 0), nil
}
