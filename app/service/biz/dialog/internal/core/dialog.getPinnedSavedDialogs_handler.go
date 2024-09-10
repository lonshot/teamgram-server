package core

import (
	"github.com/teamgram/proto/mtproto"
	"pwm-server/app/service/biz/dialog/dialog"
	"pwm-server/app/service/biz/dialog/internal/dal/dataobject"
)

// DialogGetPinnedSavedDialogs
// dialog.getPinnedSavedDialogs user_id:long = SavedDialogList;
func (c *DialogCore) DialogGetPinnedSavedDialogs(in *dialog.TLDialogGetPinnedSavedDialogs) (*dialog.SavedDialogList, error) {
	var (
		meId  = in.GetUserId()
		dList = dialog.MakeTLSavedDialogList(&dialog.SavedDialogList{
			Count:   0,
			Dialogs: []*mtproto.SavedDialog{},
		}).To_SavedDialogList()
	)

	c.svcCtx.Dao.SavedDialogsDAO.SelectPinnedDialogsWithCB(
		c.ctx,
		meId,
		func(sz, i int, v *dataobject.SavedDialogsDO) {
			dList.Dialogs = append(dList.Dialogs, c.svcCtx.Dao.MakeSavedDialog(v))
		})
	dList.Count = int32(len(dList.Dialogs))

	return dList, nil
}
