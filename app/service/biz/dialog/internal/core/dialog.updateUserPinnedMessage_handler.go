package core

import (
	"github.com/teamgram/proto/mtproto"
	"pwm-server/app/service/biz/dialog/dialog"
)

// DialogUpdateUserPinnedMessage
// dialog.updateUserPinnedMessage user_id:long peer_type:int peer_id:long pinned_msg_id:int = Bool;
func (c *DialogCore) DialogUpdateUserPinnedMessage(in *dialog.TLDialogUpdateUserPinnedMessage) (*mtproto.Bool, error) {
	// TODO: not impl
	c.Logger.Errorf("dialog.updateUserPinnedMessage - error: method DialogUpdateUserPinnedMessage not impl")

	return mtproto.BoolTrue, nil
}
