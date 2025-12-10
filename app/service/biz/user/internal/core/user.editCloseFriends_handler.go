package core

import (
	"context"
	"github.com/teamgram/marmota/pkg/stores/sqlx"
	"github.com/teamgram/proto/mtproto"
	"pwm-server/app/service/biz/user/internal/dao"
	"pwm-server/app/service/biz/user/user"
)

// UserEditCloseFriends
// user.editCloseFriends user_id:long id:Vector<long> = Bool;
func (c *UserCore) UserEditCloseFriends(in *user.TLUserEditCloseFriends) (*mtproto.Bool, error) {
	var (
		cList   = c.svcCtx.Dao.GetCloseFriendList(c.ctx, in.UserId)
		kList   []string
		cIdList []int64
	)

	if len(cList) == 0 && len(in.Id) == 0 {
		return mtproto.BoolTrue, nil
	}

	for _, id := range in.Id {
		kList = append(kList, dao.GenContactCacheKey(in.UserId, id))
	}

	for _, c := range cList {
		kList = append(kList, dao.GenContactCacheKey(in.UserId, c.ContactUserId))
		cIdList = append(cIdList, c.ContactUserId)
	}

	c.svcCtx.Dao.CachedConn.Exec(
		c.ctx,
		func(ctx context.Context, conn *sqlx.DB) (int64, int64, error) {
			var (
				err error
			)

			if len(cIdList) > 0 {
				_, err = c.svcCtx.Dao.UserContactsDAO.UpdateCloseFriend(c.ctx, false, in.UserId, cIdList)
				if err != nil {
					c.Logger.Errorf("user.editCloseFriends - error: %v", err)
					return 0, 0, err
				}
			}

			if len(in.Id) > 0 {
				_, err = c.svcCtx.Dao.UserContactsDAO.UpdateCloseFriend(c.ctx, true, in.UserId, in.Id)
				if err != nil {
					c.Logger.Errorf("user.editCloseFriends - error: %v", err)
				}
			}

			return 0, 0, err
		},
		kList...)

	return mtproto.BoolTrue, nil
}
