package core

import (
	"github.com/teamgram/proto/mtproto"
	userpb "pwm-server/app/service/biz/user/user"
)

// MessagesGetPeerSettings
// messages.getPeerSettings#efd9a6a2 peer:InputPeer = messages.PeerSettings;
func (c *DialogsCore) MessagesGetPeerSettings(in *mtproto.TLMessagesGetPeerSettings) (*mtproto.Messages_PeerSettings, error) {
	peer := mtproto.FromInputPeer2(c.MD.UserId, in.Peer)

	peerSettings, err := c.svcCtx.UserClient.UserGetPeerSettings(c.ctx, &userpb.TLUserGetPeerSettings{
		UserId:   c.MD.UserId,
		PeerType: peer.PeerType,
		PeerId:   peer.PeerId,
	})

	if err != nil {
		c.Logger.Errorf("messages.getPeerSettings - error: %v", err)

		// TODO(@benqi): handle error
		peerSettings = mtproto.MakeTLPeerSettings(nil).To_PeerSettings()
	}

	return mtproto.MakeTLMessagesPeerSettings(&mtproto.Messages_PeerSettings{
		Settings: peerSettings,
		Chats:    []*mtproto.Chat{},
		Users:    []*mtproto.User{},
	}).To_Messages_PeerSettings(), nil
}
