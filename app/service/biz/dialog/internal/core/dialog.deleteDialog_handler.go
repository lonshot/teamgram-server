package core

import (
	"context"

	"github.com/teamgram/marmota/pkg/stores/sqlx"
	"github.com/teamgram/proto/mtproto"
	"pwm-server/app/service/biz/dialog/dialog"
)

// DialogDeleteDialog
// dialog.deleteDialog user_id:long peer_type:int peer_id:long = Bool;
func (c *DialogCore) DialogDeleteDialog(in *dialog.TLDialogDeleteDialog) (*mtproto.Bool, error) {
	c.svcCtx.Dao.CachedConn.Exec(
		c.ctx,
		func(ctx context.Context, conn *sqlx.DB) (int64, int64, error) {
			r, err := c.svcCtx.Dao.DialogsDAO.Delete(ctx, in.UserId, in.PeerType, in.PeerId)
			return 0, r, err
		},
		dialog.GenCacheKeyByPeerType(in.UserId, in.PeerType))

	return mtproto.BoolTrue, nil
}
