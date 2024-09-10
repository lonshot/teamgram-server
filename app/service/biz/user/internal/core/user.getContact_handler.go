package core

import (
	"github.com/teamgram/proto/mtproto"
	"pwm-server/app/service/biz/user/user"
)

// UserGetContact
// user.getContact user_id:long id:long = ContactData;
func (c *UserCore) UserGetContact(in *user.TLUserGetContact) (*mtproto.ContactData, error) {
	contact := c.svcCtx.Dao.GetUserContact(c.ctx, in.GetUserId(), in.GetId())
	if contact == nil {
		err := mtproto.ErrContactIdInvalid
		c.Logger.Errorf("user.getContact - error: %v", err)
		return nil, err
	}

	return contact, nil
}
