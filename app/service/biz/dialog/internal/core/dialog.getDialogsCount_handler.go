package core

import (
	"github.com/teamgram/proto/mtproto"
	"pwm-server/app/service/biz/dialog/dialog"
)

// DialogGetDialogsCount
// dialog.getDialogsCount user_id:long exclude_pinned:Bool folder_id:int = Int32;
func (c *DialogCore) DialogGetDialogsCount(in *dialog.TLDialogGetDialogsCount) (*mtproto.Int32, error) {
	// TODO: not impl
	c.Logger.Errorf("dialog.getDialogsCount - error: method DialogGetDialogsCount not impl")

	return nil, mtproto.ErrMethodNotImpl
}
