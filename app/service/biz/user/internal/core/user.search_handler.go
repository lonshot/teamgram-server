package core

import (
	"github.com/teamgram/proto/mtproto"
	"pwm-server/app/service/biz/user/user"
)

// UserSearch
// user.search q:string offset_id:int limit:int hash:long = UsersFound;
func (c *UserCore) UserSearch(in *user.TLUserSearch) (*user.UsersFound, error) {
	var (
		founds *user.UsersFound
		isData = len(in.ExcludedContacts) == 0
	)

	if isData {
		founds = user.MakeTLUsersDataFound(&user.UsersFound{
			Count:      0,
			Users:      []*mtproto.UserData{},
			NextOffset: "",
		}).To_UsersFound()
	} else {
		founds = user.MakeTLUsersIdFound(&user.UsersFound{
			IdList: []int64{},
		}).To_UsersFound()
	}

	// Check query string and limit
	if len(in.Q) < 3 || in.Limit <= 0 {
		return founds, nil
	}

	if in.Limit > 50 {
		in.Limit = 50
	}

	// 构造模糊查询字符串
	q := in.Q + "%"
	q2 := "%" + in.Q + "%"

	rList, _ := c.svcCtx.Dao.UsersDAO.SearchByQueryString(
		c.ctx,
		q,
		q2,
		[]int64{0},
		in.Limit)

	if isData {
		userDataList, _ := c.UserGetUserDataListByIdList(&user.TLUserGetUserDataListByIdList{
			UserIdList: rList,
		})

		if len(userDataList.GetDatas()) > 0 {
			founds.Users = userDataList.Datas
			founds.Count = int32(len(rList))
		}
	} else {
		founds.IdList = rList
	}

	return founds, nil
}
