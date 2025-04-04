package core

import (
	"github.com/teamgram/proto/mtproto"
	"pwm-server/app/service/biz/user/user"
)

// UserGetPeerSettings
// user.getPeerSettings user_id:int peer_type:int peer_id:int = PeerSettings;
func (c *UserCore) UserGetPeerSettings(in *user.TLUserGetPeerSettings) (*mtproto.PeerSettings, error) {
	peerSettings, err := c.svcCtx.Dao.GetUserPeerSettings(
		c.ctx,
		in.GetUserId(),
		in.GetPeerType(),
		in.GetPeerId())

	if err != nil {
		c.Logger.Errorf("user.getPeerSettings - error: %v", err)
		return nil, err
	}

	return peerSettings, nil
}
