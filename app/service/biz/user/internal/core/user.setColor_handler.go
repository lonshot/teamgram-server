package core

import (
	"github.com/teamgram/proto/mtproto"
	"pwm-server/app/service/biz/user/user"
)

// UserSetColor
// user.setColor flags:# user_id:long for_profile:flags.1?true color:int background_emoji_id:long = Bool;
func (c *UserCore) UserSetColor(in *user.TLUserSetColor) (*mtproto.Bool, error) {
	var (
		rB bool
	)

	if in.ForProfile {
		rB = c.svcCtx.Dao.UpdateColor(
			c.ctx,
			in.UserId,
			true,
			in.Color,
			in.BackgroundEmojiId)
	} else {
		rB = c.svcCtx.Dao.UpdateColor(
			c.ctx,
			in.UserId,
			false,
			in.Color,
			in.BackgroundEmojiId)
	}

	return mtproto.ToBool(rB), nil
}
