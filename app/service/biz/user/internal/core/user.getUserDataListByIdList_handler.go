package core

import (
	"github.com/teamgram/proto/mtproto"
	"pwm-server/app/service/biz/user/user"
)

// UserGetUserDataListByIdList
// user.getUserDataListByIdList user_id_list:Vector<long> = Vector<UserData>;
func (c *UserCore) UserGetUserDataListByIdList(in *user.TLUserGetUserDataListByIdList) (*user.Vector_UserData, error) {
	users := &user.Vector_UserData{
		Datas: []*mtproto.UserData{},
	}

	cDataList := c.svcCtx.Dao.GetCacheUserDataListByIdList(c.ctx, in.UserIdList)
	for _, cData := range cDataList {
		users.Datas = append(users.Datas, cData.GetUserData())
	}

	return users, nil

}
