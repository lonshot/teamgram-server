package core

import (
	"github.com/teamgram/marmota/pkg/container2"
	"github.com/teamgram/proto/mtproto"
	"pwm-server/app/service/biz/user/user"
)

// UserCheckContact
// user.checkContact user_id:long id:long = Bool;
func (c *UserCore) UserCheckContact(in *user.TLUserCheckContact) (*mtproto.Bool, error) {
	cacheUserData := c.svcCtx.Dao.GetCacheUserData(c.ctx, in.GetUserId())
	//_, idList := c.svcCtx.Dao.GetUserContactIdList(c.ctx, in.GetUserId())
	isContact := container2.ContainsInt64(cacheUserData.GetContactIdList(), in.GetId())

	return mtproto.ToBool(isContact), nil
}
