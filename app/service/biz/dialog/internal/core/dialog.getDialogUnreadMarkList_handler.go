package core

import (
	"github.com/teamgram/proto/mtproto"
	"pwm-server/app/service/biz/dialog/dialog"
)

// DialogGetDialogUnreadMarkList
// dialog.getDialogUnreadMarkList user_id:long = Vector<DialogPeer>;
func (c *DialogCore) DialogGetDialogUnreadMarkList(in *dialog.TLDialogGetDialogUnreadMarkList) (*dialog.Vector_DialogPeer, error) {
	// TODO: not impl
	c.Logger.Errorf("dialog.getDialogUnreadMarkList - error: method DialogGetDialogUnreadMarkList not impl")

	return nil, mtproto.ErrMethodNotImpl
}
