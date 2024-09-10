package core

import (
	"github.com/teamgram/proto/mtproto"
	"pwm-server/app/service/biz/user/user"
)

// UserGetBirthdays
// user.getBirthdays user_id:long = Vector<ContactBirthday>;
func (c *UserCore) UserGetBirthdays(in *user.TLUserGetBirthdays) (*user.Vector_ContactBirthday, error) {
	// TODO: not impl
	c.Logger.Errorf("user.getBirthdays blocked, License key from https://teamgram.net required to unlock enterprise features.")

	rV := &user.Vector_ContactBirthday{
		Datas: make([]*mtproto.ContactBirthday, 0),
	}

	return rV, nil
}
