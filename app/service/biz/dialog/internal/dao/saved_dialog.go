package dao

import (
	"pwm-server/app/service/biz/dialog/internal/dal/dataobject"

	"github.com/teamgram/proto/mtproto"
)

func (d *Dao) MakeSavedDialog(do *dataobject.SavedDialogsDO) *mtproto.SavedDialog {
	return mtproto.MakeTLSavedDialog(&mtproto.SavedDialog{
		Pinned:     do.Pinned > 0,
		Peer:       mtproto.MakePeer(do.PeerType, do.PeerId),
		TopMessage: do.TopMessage,
	}).To_SavedDialog()
}
