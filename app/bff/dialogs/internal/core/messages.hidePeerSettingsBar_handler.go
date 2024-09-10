package core

import (
	"github.com/teamgram/proto/mtproto"
	userpb "pwm-server/app/service/biz/user/user"
)

// MessagesHidePeerSettingsBar
// messages.hidePeerSettingsBar#4facb138 peer:InputPeer = Bool;
func (c *DialogsCore) MessagesHidePeerSettingsBar(in *mtproto.TLMessagesHidePeerSettingsBar) (*mtproto.Bool, error) {
	peer := mtproto.FromInputPeer2(c.MD.UserId, in.Peer)
	c.svcCtx.UserClient.UserDeletePeerSettings(c.ctx, &userpb.TLUserDeletePeerSettings{
		UserId:   c.MD.UserId,
		PeerType: peer.PeerType,
		PeerId:   peer.PeerId,
	})

	// TODO: syncUpdatesNotMe
	return mtproto.BoolTrue, nil
}
