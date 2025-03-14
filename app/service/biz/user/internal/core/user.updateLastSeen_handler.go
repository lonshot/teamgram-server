package core

import (
	"github.com/teamgram/proto/mtproto"
	"pwm-server/app/service/biz/user/user"
)

// UserUpdateLastSeen
// user.updateLastSeen id:long last_seen_at:long expires:int = Bool;
func (c *UserCore) UserUpdateLastSeen(in *user.TLUserUpdateLastSeen) (*mtproto.Bool, error) {
	if in.GetId() > 0 {
		c.svcCtx.Dao.PutLastSeenAt(
			c.ctx,
			in.GetId(),
			in.GetLastSeenAt(),
			in.GetExpires())
	}

	return mtproto.BoolTrue, nil
}
