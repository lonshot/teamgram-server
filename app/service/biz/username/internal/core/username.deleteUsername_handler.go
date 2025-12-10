package core

import (
	"github.com/teamgram/proto/mtproto"
	"pwm-server/app/service/biz/username/username"
)

// UsernameDeleteUsername
// username.deleteUsername username:string = Bool;
func (c *UsernameCore) UsernameDeleteUsername(in *username.TLUsernameDeleteUsername) (*mtproto.Bool, error) {
	_, err := c.svcCtx.Dao.UsernameDAO.Delete(c.ctx, in.Username)
	if err != nil {
		return mtproto.BoolFalse, nil
	}

	return mtproto.BoolTrue, nil
}
