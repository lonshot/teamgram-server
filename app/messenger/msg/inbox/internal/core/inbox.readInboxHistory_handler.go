package core

import (
	"fmt"
	"github.com/teamgram/proto/mtproto"
	"pwm-server/app/messenger/msg/inbox/inbox"
	"pwm-server/app/messenger/sync/sync"
)

// InboxReadInboxHistory
// inbox.readInboxHistory user_id:long auth_key_id:long peer_type:int peer_id:long unread_count:int read_inbox_max_id:int max_id:int = Void;
func (c *InboxCore) InboxReadInboxHistory(in *inbox.TLInboxReadInboxHistory) (*mtproto.Void, error) {
	var (
		maxId        = in.MaxId
		did          = mtproto.MakeDialogId(in.UserId, in.PeerType, in.PeerId)
		peerDialogId = mtproto.MakePeerDialogId(in.PeerType, in.PeerId)
		unreadCount  int32
	)

	if maxId > in.ReadInboxMaxId {
		readCount := c.svcCtx.Dao.CommonDAO.CalcSizeByWhere(
			c.ctx,
			c.svcCtx.Dao.MessagesDAO.CalcTableName(in.UserId),
			fmt.Sprintf("user_id = %d AND dialog_id1 = %d AND dialog_id2 = %d AND sender_user_id <> %d AND user_message_box_id > %d AND user_message_box_id <= %d AND deleted = 0",
				in.UserId, did.A, did.B, in.UserId, in.ReadInboxMaxId, maxId))
		unreadCount = in.UnreadCount - int32(readCount)
		if unreadCount < 0 {
			unreadCount = 0
		}
	}

	c.svcCtx.Dao.DialogsDAO.UpdateReadInboxMaxId(c.ctx, unreadCount, maxId, in.UserId, peerDialogId)

	c.svcCtx.Dao.SyncClient.SyncUpdatesNotMe(
		c.ctx,
		&sync.TLSyncUpdatesNotMe{
			UserId:        in.UserId,
			PermAuthKeyId: in.AuthKeyId,
			Updates: mtproto.MakeUpdatesByUpdates(mtproto.MakeTLUpdateReadHistoryInbox(&mtproto.Update{
				Peer_PEER: mtproto.MakePeer(in.PeerType, in.PeerId),
				MaxId:     maxId,
				Pts_INT32: in.Pts,
				PtsCount:  in.PtsCount,
			}).To_Update()),
		})

	return mtproto.EmptyVoid, nil
}
