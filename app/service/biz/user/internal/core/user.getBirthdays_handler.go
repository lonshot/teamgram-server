package core

import (
	"pwm-server/app/service/biz/user/user"

	"github.com/teamgram/proto/mtproto"
)

// UserGetBirthdays
// user.getBirthdays user_id:long = Vector<ContactBirthday>;
func (c *UserCore) UserGetBirthdays(in *user.TLUserGetBirthdays) (*user.Vector_ContactBirthday, error) {
	// TODO: not impl
	c.Logger.Errorf("user.getBirthdays blocked, License key from https://wb.playwith-me.com required to unlock enterprise features.")

	rV := &user.Vector_ContactBirthday{
		Datas: make([]*mtproto.ContactBirthday, 0),
	}

	return rV, nil
}
