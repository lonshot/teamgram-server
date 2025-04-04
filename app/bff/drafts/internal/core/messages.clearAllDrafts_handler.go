package core

import (
	"pwm-server/app/messenger/sync/sync"
	chatpb "pwm-server/app/service/biz/chat/chat"
	"pwm-server/app/service/biz/dialog/dialog"
	userpb "pwm-server/app/service/biz/user/user"

	"github.com/teamgram/proto/mtproto"
)

// MessagesClearAllDrafts
// messages.clearAllDrafts#7e58ee9c = Bool;
func (c *DraftsCore) MessagesClearAllDrafts(in *mtproto.TLMessagesClearAllDrafts) (*mtproto.Bool, error) {
	rValues, err := c.svcCtx.Dao.DialogClient.DialogClearAllDrafts(c.ctx, &dialog.TLDialogClearAllDrafts{
		UserId: c.MD.UserId,
	})
	if err != nil {
		c.Logger.Errorf("messages.clearAllDrafts: %v", err)
		return nil, err
	}

	if len(rValues.Datas) == 0 {
		return mtproto.BoolTrue, nil
	}

	// sync
	for _, v := range rValues.Datas {
		syncUpdates := mtproto.MakeUpdatesByUpdates(mtproto.MakeTLUpdateDraftMessage(&mtproto.Update{
			Peer_PEER: v.Peer,
			Draft:     v.Draft,
		}).To_Update())

		peer := mtproto.FromPeer(v.Peer)
		switch peer.PeerType {
		case mtproto.PEER_USER:
			users, _ := c.svcCtx.Dao.UserClient.UserGetMutableUsers(c.ctx, &userpb.TLUserGetMutableUsers{
				Id: []int64{c.MD.UserId, peer.PeerId},
			})
			user, _ := users.GetUnsafeUser(c.MD.UserId, peer.PeerId)

			syncUpdates.AddSafeUser(user)
		case mtproto.PEER_CHAT:
			chat, _ := c.svcCtx.Dao.ChatClient.ChatGetMutableChat(c.ctx, &chatpb.TLChatGetMutableChat{
				ChatId: peer.PeerId,
			})

			syncUpdates.AddSafeChat(chat.ToUnsafeChat(c.MD.UserId))
		case mtproto.PEER_CHANNEL:
			if c.svcCtx.Plugin != nil {
				chats := c.svcCtx.Plugin.GetChannelListByIdList(c.ctx, c.MD.UserId, peer.PeerId)
				syncUpdates.PushChat(chats...)
			} else {
				c.Logger.Errorf("messages.clearAllDrafts blocked, License key from https://wb.playwith-me.com required to unlock enterprise features.")
				return nil, mtproto.ErrEnterpriseIsBlocked
			}
		}

		c.svcCtx.Dao.SyncClient.SyncUpdatesNotMe(c.ctx, &sync.TLSyncUpdatesNotMe{
			UserId:        c.MD.UserId,
			PermAuthKeyId: c.MD.PermAuthKeyId,
			Updates:       syncUpdates,
		})
	}

	return mtproto.BoolTrue, nil
}
