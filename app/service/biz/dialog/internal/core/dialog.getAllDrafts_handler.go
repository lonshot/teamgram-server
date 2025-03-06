package core

import (
	"github.com/teamgram/proto/mtproto"
	"pwm-server/app/service/biz/dialog/dialog"
	"pwm-server/app/service/biz/dialog/internal/dal/dataobject"
)

// DialogGetAllDrafts
// dialog.getAllDrafts user_id:long = Vector<PeerWithDraftMessage>;
func (c *DialogCore) DialogGetAllDrafts(in *dialog.TLDialogGetAllDrafts) (*dialog.Vector_PeerWithDraftMessage, error) {
	// var doList []dataobject.DialogsDO
	rValues := &dialog.Vector_PeerWithDraftMessage{
		Datas: []*dialog.PeerWithDraftMessage{},
	}

	if _, err := c.svcCtx.Dao.DialogsDAO.SelectAllDraftsWithCB(
		c.ctx,
		in.UserId,
		func(sz, i int, v *dataobject.DialogsDO) {
			if v.DraftMessageData == "" {
				return
			}

			var (
				draft *mtproto.DraftMessage
			)

			if draft != nil {
				rValues.Datas = append(rValues.Datas,
					dialog.MakeTLUpdateDraftMessage(&dialog.PeerWithDraftMessage{
						Peer:  mtproto.MakePeer(v.PeerType, v.PeerId),
						Draft: draft,
					}).To_PeerWithDraftMessage())
			}
		}); err != nil {
		c.Logger.Errorf("dialog.getAllDrafts - error: %v", err)
		return nil, err
	}

	return rValues, nil
}
