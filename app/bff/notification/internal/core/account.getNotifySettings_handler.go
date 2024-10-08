package core

import (
	"github.com/teamgram/proto/mtproto"
	userpb "pwm-server/app/service/biz/user/user"
)

// AccountGetNotifySettings
// account.getNotifySettings#12b3ad31 peer:InputNotifyPeer = PeerNotifySettings;
func (c *NotificationCore) AccountGetNotifySettings(in *mtproto.TLAccountGetNotifySettings) (
	*mtproto.PeerNotifySettings, error,
) {
	var (
		err      error
		settings *mtproto.PeerNotifySettings
	)

	peer := mtproto.FromInputNotifyPeer(c.MD.UserId, in.Peer)
	switch peer.PeerType {
	case mtproto.PEER_USER:
		// Validate if the user exists by calling UserGetImmutableUser
		_, err = c.svcCtx.Dao.UserClient.UserGetImmutableUser(
			c.ctx, &userpb.TLUserGetImmutableUser{
				Id: peer.PeerId,
			},
		)
		if err != nil {
			c.Logger.Errorf("account.getNotifySettings - user not found: %v", err)
			return nil, mtproto.ErrMemberNotFound
		}
	case mtproto.PEER_CHAT:
		// TODO(@benqi): check peerChat exists
	case mtproto.PEER_CHANNEL:
		// TODO(@benqi): check peerChannel exists
	case mtproto.PEER_USERS:
	case mtproto.PEER_CHATS:
	case mtproto.PEER_BROADCASTS:
	default:
		err = mtproto.ErrPeerIdInvalid
		c.Logger.Errorf("account.updateNotifySettings - error: %v", err)
		return nil, err
	}

	settings, err = c.svcCtx.Dao.UserClient.UserGetNotifySettings(
		c.ctx, &userpb.TLUserGetNotifySettings{
			UserId:   c.MD.UserId,
			PeerType: peer.PeerType,
			PeerId:   peer.PeerId,
		},
	)
	if err != nil {
		c.Logger.Errorf("getNotifySettings error - %v", err)
		return nil, err
	}

	return settings, err
}
