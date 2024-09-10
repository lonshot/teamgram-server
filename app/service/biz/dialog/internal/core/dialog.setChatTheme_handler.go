package core

import (
	"github.com/teamgram/marmota/pkg/stores/sqlx"
	"github.com/teamgram/proto/mtproto"
	"pwm-server/app/service/biz/dialog/dialog"
)

// DialogSetChatTheme
// dialog.setChatTheme user_id:long peer_type:int peer_id:long theme_emoticon:string = Bool;
func (c *DialogCore) DialogSetChatTheme(in *dialog.TLDialogSetChatTheme) (*mtproto.Bool, error) {
	sqlx.TxWrapper(c.ctx, c.svcCtx.Dao.DB, func(tx *sqlx.Tx, result *sqlx.StoreResult) {
		c.svcCtx.Dao.DialogsDAO.UpdateCustomMapTx(
			tx,
			map[string]interface{}{
				"theme_emoticon": in.ThemeEmoticon,
			},
			in.UserId,
			in.PeerType,
			in.PeerId)
		c.svcCtx.Dao.DialogsDAO.UpdateCustomMapTx(
			tx,
			map[string]interface{}{
				"theme_emoticon": in.ThemeEmoticon,
			},
			in.PeerId,
			in.PeerType,
			in.UserId)
	})

	return mtproto.BoolTrue, nil
}
