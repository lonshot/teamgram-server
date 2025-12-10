package core

import (
	"github.com/teamgram/proto/mtproto"
	"pwm-server/app/service/biz/user/user"
)

// UserGetNotifySettings
// user.getNotifySettings user_id:int peer_type:int peer_id:int = PeerNotifySettings;
func (c *UserCore) UserGetNotifySettings(in *user.TLUserGetNotifySettings) (*mtproto.PeerNotifySettings, error) {
	settings, err := c.svcCtx.Dao.GetUserNotifySettings(
		c.ctx,
		in.GetUserId(),
		in.GetPeerType(),
		in.GetPeerId())

	if err != nil {
		c.Logger.Errorf("user.getNotifySettings - error: %v", err)
		return nil, err
	}

	return settings, nil
}
