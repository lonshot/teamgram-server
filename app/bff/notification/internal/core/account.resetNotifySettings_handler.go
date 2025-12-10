package core

import (
	"github.com/teamgram/proto/mtproto"
	"pwm-server/app/messenger/sync/sync"
	userpb "pwm-server/app/service/biz/user/user"

	"google.golang.org/protobuf/types/known/wrapperspb"
)

// AccountResetNotifySettings
// account.resetNotifySettings#db7e1747 = Bool;
func (c *NotificationCore) AccountResetNotifySettings(in *mtproto.TLAccountResetNotifySettings) (*mtproto.Bool, error) {
	_, err := c.svcCtx.Dao.UserClient.UserResetNotifySettings(c.ctx, &userpb.TLUserResetNotifySettings{
		UserId: c.MD.UserId,
	})
	if err != nil {
		c.Logger.Errorf("getNotifySettings error - %v", err)
		// We ignore error
		return mtproto.BoolFalse, nil
	}

	pushNotifySettingsFunc := func(peerType int32) {
		peer := &mtproto.PeerUtil{
			PeerType: peerType,
			PeerId:   0,
		}
		syncUpdates := mtproto.MakeUpdatesByUpdates(mtproto.MakeTLUpdateNotifySettings(&mtproto.Update{
			Peer_NOTIFYPEER: peer.ToNotifyPeer(),
			NotifySettings: mtproto.MakeTLPeerNotifySettings(&mtproto.PeerNotifySettings{
				ShowPreviews: mtproto.BoolTrue,
				Silent:       mtproto.BoolFalse,
				MuteUntil:    &wrapperspb.Int32Value{Value: 0},
				Sound:        &wrapperspb.StringValue{Value: "default"},
			}).To_PeerNotifySettings(),
		}).To_Update())
		c.svcCtx.Dao.SyncClient.SyncUpdatesNotMe(c.ctx, &sync.TLSyncUpdatesNotMe{
			Constructor:   0,
			UserId:        c.MD.UserId,
			PermAuthKeyId: c.MD.PermAuthKeyId,
			Updates:       syncUpdates,
		})
	}

	pushNotifySettingsFunc(mtproto.PEER_USERS)
	pushNotifySettingsFunc(mtproto.PEER_CHATS)
	pushNotifySettingsFunc(mtproto.PEER_BROADCASTS)

	return mtproto.BoolTrue, nil
}
