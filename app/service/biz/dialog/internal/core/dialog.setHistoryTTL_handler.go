package core

import (
	"github.com/teamgram/marmota/pkg/stores/sqlx"
	"github.com/teamgram/proto/mtproto"
	"pwm-server/app/service/biz/dialog/dialog"
)

// DialogSetHistoryTTL
// dialog.setHistoryTTL user_id:long peer_type:int peer_id:long ttl_period:int = Bool;
func (c *DialogCore) DialogSetHistoryTTL(in *dialog.TLDialogSetHistoryTTL) (*mtproto.Bool, error) {
	sqlx.TxWrapper(c.ctx, c.svcCtx.Dao.DB, func(tx *sqlx.Tx, result *sqlx.StoreResult) {
		c.svcCtx.Dao.DialogsDAO.UpdateCustomMapTx(
			tx,
			map[string]interface{}{
				"ttl_period": in.TtlPeriod,
			},
			in.UserId,
			in.PeerType,
			in.PeerId)
		c.svcCtx.Dao.DialogsDAO.UpdateCustomMapTx(
			tx,
			map[string]interface{}{
				"ttl_period": in.TtlPeriod,
			},
			in.PeerId,
			in.PeerType,
			in.UserId)
	})

	return mtproto.BoolTrue, nil
}
