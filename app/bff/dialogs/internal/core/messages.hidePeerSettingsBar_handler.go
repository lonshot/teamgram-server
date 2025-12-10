package core

import (
	"github.com/teamgram/proto/mtproto"
	"pwm-server/app/messenger/sync/sync"
	userpb "pwm-server/app/service/biz/user/user"
)

// MessagesHidePeerSettingsBar
// messages.hidePeerSettingsBar#4facb138 peer:InputPeer = Bool;
func (c *DialogsCore) MessagesHidePeerSettingsBar(in *mtproto.TLMessagesHidePeerSettingsBar) (*mtproto.Bool, error) {
	// Extract peer information from input
	peer := mtproto.FromInputPeer2(c.MD.UserId, in.Peer)

	// Check if the peer is valid
	if !peer.IsUser() && !peer.IsChat() && !peer.IsChannel() {
		c.Logger.Errorf("MessagesHidePeerSettingsBar - error: invalid peer %v", peer)
		return mtproto.BoolFalse, mtproto.ErrPeerIdInvalid
	}

	// Delete peer settings for the specified user and peer
	_, err := c.svcCtx.UserClient.UserDeletePeerSettings(c.ctx, &userpb.TLUserDeletePeerSettings{
		UserId:   c.MD.UserId,
		PeerType: peer.PeerType,
		PeerId:   peer.PeerId,
	})
	if err != nil {
		c.Logger.Errorf("MessagesHidePeerSettingsBar - error deleting peer settings for peer %v: %v", peer, err)
		return mtproto.BoolFalse, err
	}

	// Sync updates to other clients (syncUpdatesNotMe)
	syncUpdates := mtproto.MakeUpdatesByUpdates(
		mtproto.MakeTLUpdatePeerSettings(&mtproto.Update{
			Peer_PEER: peer.ToPeer(),
			Settings:  mtproto.MakeTLPeerSettings(&mtproto.PeerSettings{}).To_PeerSettings(),
		}).To_Update(),
	)

	// Push the updates to other clients
	c.svcCtx.Dao.SyncClient.SyncUpdatesNotMe(c.ctx, &sync.TLSyncUpdatesNotMe{
		UserId:        c.MD.UserId,
		PermAuthKeyId: c.MD.PermAuthKeyId,
		Updates:       syncUpdates,
	})

	// Log success
	c.Logger.Infof("MessagesHidePeerSettingsBar - successfully hid peer settings bar for peer %v", peer)

	return mtproto.BoolTrue, nil
}
