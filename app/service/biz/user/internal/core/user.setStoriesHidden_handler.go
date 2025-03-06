package core

import (
	"context"

	"github.com/teamgram/marmota/pkg/stores/sqlx"
	"github.com/teamgram/proto/mtproto"
	"pwm-server/app/service/biz/user/internal/dao"
	"pwm-server/app/service/biz/user/user"
)

// UserSetStoriesHidden
// user.setStoriesHidden user_id:long id:long hidden:Bool = Bool;
func (c *UserCore) UserSetStoriesHidden(in *user.TLUserSetStoriesHidden) (*mtproto.Bool, error) {
	c.svcCtx.Dao.CachedConn.Exec(
		c.ctx,
		func(ctx context.Context, conn *sqlx.DB) (int64, int64, error) {
			var (
				err error
			)

			_, err = c.svcCtx.Dao.UserContactsDAO.UpdateStoriesHidden(c.ctx, mtproto.FromBool(in.Hidden), in.UserId, in.Id)
			if err != nil {
				c.Logger.Errorf("user.setStoriesHidden - error: %v", err)
			}

			return 0, 0, err
		},
		dao.GenContactCacheKey(in.UserId, in.Id))

	return mtproto.BoolTrue, nil
}
