package core

import (
	"github.com/teamgram/proto/mtproto"
	userpb "pwm-server/app/service/biz/user/user"
)

// UsersGetUsers
// users.getUsers#d91a548 id:Vector<InputUser> = Vector<User>;
func (c *UsersCore) UsersGetUsers(in *mtproto.TLUsersGetUsers) (*mtproto.Vector_User, error) {
	var (
		idList []int64
	)

	for _, inputUser := range in.Id {
		peer := mtproto.FromInputUser(c.MD.UserId, inputUser)
		switch peer.PeerType {
		case mtproto.PEER_SELF, mtproto.PEER_USER:
			idList = append(idList, peer.PeerId)
		default:
			c.Logger.Errorf("invalid userId")
		}
	}

	mUsers, _ := c.svcCtx.Dao.UserClient.UserGetMutableUsers(c.ctx, &userpb.TLUserGetMutableUsers{
		Id: idList,
		To: []int64{c.MD.UserId},
	})

	return &mtproto.Vector_User{
		Datas: mUsers.GetUserListByIdList(c.MD.UserId, idList...),
	}, nil
}
