package core

import (
	"github.com/teamgram/proto/mtproto"
	"pwm-server/app/service/biz/user/user"
)

// UserDeleteImportersByPhone
// user.deleteImportersByPhone phone:string = Bool;
func (c *UserCore) UserDeleteImportersByPhone(in *user.TLUserDeleteImportersByPhone) (*mtproto.Bool, error) {
	c.svcCtx.Dao.UnregisteredContactsDAO.DeleteImportersByPhone(c.ctx, in.Phone)

	return mtproto.BoolTrue, nil
}
