package core

import (
	"github.com/teamgram/proto/mtproto"
	"pwm-server/app/service/biz/user/user"
)

// UserGetMutableUsersV2
// user.getMutableUsersV2 flags:# id:Vector<long> privacy:flags.0?true has_to:flags.2?true to:flags.2?Vector<long> = MutableUsers;
func (c *UserCore) UserGetMutableUsersV2(in *user.TLUserGetMutableUsersV2) (*mtproto.MutableUsers, error) {
	userList := c.svcCtx.Dao.GetMutableUsersV2(
		c.ctx,
		in.Id,
		in.Privacy,
		in.HasTo,
		in.To)
	if userList == nil {
		userList = []*mtproto.ImmutableUser{}
	}

	return mtproto.MakeTLMutableUsers(&mtproto.MutableUsers{
		Users: userList,
	}).To_MutableUsers(), nil
}
