package core

import (
	"context"

	"github.com/teamgram/marmota/pkg/stores/sqlx"
	"github.com/teamgram/proto/mtproto"
	"pwm-server/app/service/biz/dialog/dialog"
)

// DialogDeleteDialogFilter
// dialog.deleteDialogFilter user_id:long id:int = Bool;
func (c *DialogCore) DialogDeleteDialogFilter(in *dialog.TLDialogDeleteDialogFilter) (*mtproto.Bool, error) {
	c.svcCtx.Dao.CachedConn.Exec(
		c.ctx,
		func(ctx context.Context, conn *sqlx.DB) (int64, int64, error) {
			_, err := c.svcCtx.Dao.DialogFiltersDAO.Clear(ctx, in.UserId, in.Id)
			return 0, 0, err
		},
		dialog.GenDialogFilterCacheKey(in.UserId))

	return mtproto.BoolTrue, nil
}
