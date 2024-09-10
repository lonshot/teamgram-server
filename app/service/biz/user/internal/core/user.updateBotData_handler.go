package core

import (
	"github.com/teamgram/proto/mtproto"
	"pwm-server/app/service/biz/user/user"
)

// UserUpdateBotData
// user.updateBotData flags:# user_id:long bot_chat_history:flags.15?Bool bot_nochats:flags.16?Bool bot_inline_geo:flags.21?Bool bot_attach_menu:flags.27?Bool bot_inline_placeholder:flags.19?Bool = Bool;
func (c *UserCore) UserUpdateBotData(in *user.TLUserUpdateBotData) (*mtproto.Bool, error) {
	// TODO: not impl
	c.Logger.Errorf("user.updateBotData blocked, License key from https://teamgram.net required to unlock enterprise features.")

	return nil, mtproto.ErrEnterpriseIsBlocked
}
