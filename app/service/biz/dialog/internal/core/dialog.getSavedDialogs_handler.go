package core

import (
	"math"

	"github.com/teamgram/proto/mtproto"
	"pwm-server/app/service/biz/dialog/dialog"
	"pwm-server/app/service/biz/dialog/internal/dal/dataobject"
)

// DialogGetSavedDialogs
// dialog.getSavedDialogs user_id:long exclude_pinned:Bool offset_date:int offset_id:int offset_peer:PeerUtil limit:int = SavedDialogList;
func (c *DialogCore) DialogGetSavedDialogs(in *dialog.TLDialogGetSavedDialogs) (*dialog.SavedDialogList, error) {
	var (
		excludePinned = mtproto.FromBool(in.GetExcludePinned())
		meId          = in.GetUserId()
		limit         = in.GetLimit()
		offsetId      = in.GetOffsetId()
		dList         = dialog.MakeTLSavedDialogList(&dialog.SavedDialogList{
			Count:   0,
			Dialogs: []*mtproto.SavedDialog{},
		}).To_SavedDialogList()
	)

	if offsetId <= 0 {
		offsetId = math.MaxInt32
	}

	if limit == 0 {
		limit = 100
	}

	if excludePinned {
		c.svcCtx.Dao.SavedDialogsDAO.SelectExcludePinnedDialogsWithCB(
			c.ctx,
			meId,
			offsetId,
			limit,
			func(sz, i int, v *dataobject.SavedDialogsDO) {
				dList.Dialogs = append(dList.Dialogs, c.svcCtx.Dao.MakeSavedDialog(v))
			})
		dList.Count = int32(c.svcCtx.Dao.CommonDAO.CalcSize(
			c.ctx,
			"saved_dialogs",
			map[string]interface{}{
				"user_id": meId,
				"pinned":  0,
				"deleted": 0,
			}))
	} else {
		c.svcCtx.Dao.SavedDialogsDAO.SelectDialogsWithCB(
			c.ctx,
			meId,
			offsetId,
			limit,
			func(sz, i int, v *dataobject.SavedDialogsDO) {
				dList.Dialogs = append(dList.Dialogs, c.svcCtx.Dao.MakeSavedDialog(v))
			})
		dList.Count = int32(c.svcCtx.Dao.CommonDAO.CalcSize(
			c.ctx,
			"saved_dialogs",
			map[string]interface{}{
				"user_id": meId,
				"deleted": 0,
			}))
	}

	return dList, nil
}
