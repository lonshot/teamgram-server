package core

import (
	"github.com/teamgram/proto/mtproto"
	"pwm-server/app/service/biz/user/internal/dal/dataobject"
	"pwm-server/app/service/biz/user/user"
)

// UserGetImportersByPhone
// user.getImportersByPhone phone:string = Vector<InputContact>;
func (c *UserCore) UserGetImportersByPhone(in *user.TLUserGetImportersByPhone) (*user.Vector_InputContact, error) {
	contacts := &user.Vector_InputContact{
		Datas: make([]*mtproto.InputContact, 0),
	}

	c.svcCtx.Dao.UnregisteredContactsDAO.SelectImportersByPhoneWithCB(
		c.ctx,
		in.Phone,
		func(sz, i int, v *dataobject.UnregisteredContactsDO) {
			contacts.Datas = append(contacts.Datas, mtproto.MakeTLInputPhoneContact(&mtproto.InputContact{
				ClientId:  v.ImporterUserId,
				Phone:     "",
				FirstName: v.ImportFirstName,
				LastName:  v.ImportLastName,
			}).To_InputContact())
		})

	return contacts, nil
}
