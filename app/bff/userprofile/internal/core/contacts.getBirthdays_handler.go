package core

import (
	"github.com/teamgram/proto/mtproto"
	"pwm-server/app/service/biz/user/user"
)

// ContactsGetBirthdays
// contacts.getBirthdays#daeda864 = contacts.ContactBirthdays;
func (c *UserProfileCore) ContactsGetBirthdays(in *mtproto.TLContactsGetBirthdays) (*mtproto.Contacts_ContactBirthdays, error) {
	cBirthdays, err := c.svcCtx.Dao.UserClient.UserGetBirthdays(c.ctx, &user.TLUserGetBirthdays{
		UserId: c.MD.UserId,
	})

	if err != nil {
		c.Logger.Errorf("contacts.getBirthdays - error: %v", err)
		return nil, err
	}

	var (
		idList []int64

		rV = mtproto.MakeTLContactsContactBirthdays(&mtproto.Contacts_ContactBirthdays{
			Contacts: []*mtproto.ContactBirthday{},
			Users:    []*mtproto.User{},
		}).To_Contacts_ContactBirthdays()
	)

	for _, c := range cBirthdays.GetDatas() {
		idList = append(idList, c.ContactId)
	}
	if len(idList) == 0 {
		return rV, nil
	}

	cUsers, err := c.svcCtx.Dao.UserClient.UserGetMutableUsersV2(c.ctx, &user.TLUserGetMutableUsersV2{
		Id: idList,
	})
	if err != nil {
		c.Logger.Errorf("contacts.getBirthdays - error: %v", err)
	} else {
		rV.Contacts = cBirthdays.GetDatas()
		rV.Users = cUsers.GetUserListByIdList(c.MD.UserId, idList...)
	}

	return rV, nil
}
