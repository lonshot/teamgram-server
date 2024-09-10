package core

import (
	"github.com/teamgram/proto/mtproto"
	"pwm-server/app/service/biz/user/user"
)

// ContactsEditCloseFriends
// contacts.editCloseFriends#ba6705f0 id:Vector<long> = Bool;
func (c *ContactsCore) ContactsEditCloseFriends(in *mtproto.TLContactsEditCloseFriends) (*mtproto.Bool, error) {
	rV, err := c.svcCtx.Dao.UserEditCloseFriends(c.ctx, &user.TLUserEditCloseFriends{
		UserId: c.MD.UserId,
		Id:     in.Id,
	})
	if err != nil {
		c.Logger.Errorf("contacts.editCloseFriends - error: %v", err)
		return nil, err
	}

	return rV, nil
}
