package core

import (
	"time"

	"github.com/teamgram/proto/mtproto"
	"pwm-server/app/service/biz/dialog/dialog"
)

// DialogToggleSavedDialogPin
// dialog.toggleSavedDialogPin user_id:long peer:PeerUtil pinned:Bool = Bool;
func (c *DialogCore) DialogToggleSavedDialogPin(in *dialog.TLDialogToggleSavedDialogPin) (*mtproto.Bool, error) {
	var (
		peer   = in.Peer
		pinned int64
	)

	if mtproto.FromBool(in.Pinned) {
		pinned = time.Now().Unix() << 32
	} else {
		pinned = 0
	}

	_, err := c.svcCtx.Dao.SavedDialogsDAO.UpdateUserPeerPinned(
		c.ctx,
		pinned,
		in.GetUserId(),
		peer.PeerType,
		peer.PeerId)
	if err != nil {
		c.Logger.Error("toggleSavedDialogPin - query saved_dialogs error:", err)
		return nil, err
	}

	return mtproto.BoolTrue, nil
}
