package core

import (
	"time"

	"github.com/teamgram/marmota/pkg/stores/sqlx"
	"github.com/teamgram/proto/mtproto"
	"pwm-server/app/service/biz/dialog/dialog"
)

// DialogReorderPinnedSavedDialogs
// dialog.reorderPinnedSavedDialogs user_id:long force:Bool order:Vector<PeerUtil> = Bool;
func (c *DialogCore) DialogReorderPinnedSavedDialogs(in *dialog.TLDialogReorderPinnedSavedDialogs) (*mtproto.Bool, error) {
	var (
		userId      = in.GetUserId()
		force       = mtproto.FromBool(in.GetForce())
		orderPinned = time.Now().Unix()
	)

	sqlx.TxWrapper(
		c.ctx,
		c.svcCtx.Dao.DB,
		func(tx *sqlx.Tx, result *sqlx.StoreResult) {
			if force {
				_, result.Err = c.svcCtx.Dao.SavedDialogsDAO.UpdateUserUnPinnedTx(
					tx,
					userId)
				if result.Err != nil {
					return
				}
			}

			for _, id := range in.Order {
				_, result.Err = c.svcCtx.Dao.SavedDialogsDAO.UpdateUserPeerPinnedTx(
					tx,
					orderPinned<<32,
					in.UserId,
					id.PeerType,
					id.PeerId)
				if result.Err != nil {
					return
				}
				orderPinned -= 1
			}
		})

	return mtproto.BoolTrue, nil
}
