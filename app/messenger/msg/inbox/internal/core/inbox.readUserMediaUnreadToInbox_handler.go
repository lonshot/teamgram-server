package core

import (
	"github.com/teamgram/proto/mtproto"
	"pwm-server/app/messenger/msg/inbox/inbox"
	"pwm-server/app/messenger/msg/internal/dal/dataobject"
	"pwm-server/app/messenger/sync/sync"
)

// InboxReadUserMediaUnreadToInbox
// inbox.readUserMediaUnreadToInbox from_id:long peer_user_id:long id:Vector<InboxMessageId> = Voi
func (c *InboxCore) InboxReadUserMediaUnreadToInbox(in *inbox.TLInboxReadUserMediaUnreadToInbox) (*mtproto.Void, error) {
	idList := make([]int64, 0, len(in.GetId()))
	for _, id := range in.GetId() {
		idList = append(idList, id.DialogMessageId)
	}

	c.svcCtx.Dao.MessagesDAO.SelectByMessageDataIdListWithCB(
		c.ctx,
		c.svcCtx.Dao.MessagesDAO.CalcTableName(in.PeerUserId),
		idList,
		func(sz, i int, v *dataobject.MessagesDO) {
			c.svcCtx.Dao.MessagesDAO.UpdateMediaUnread(c.ctx, v.UserId, v.UserMessageBoxId)

			// TODO: batch handle
			pts := c.svcCtx.Dao.IDGenClient2.NextPtsId(c.ctx, v.UserId)
			c.svcCtx.Dao.SyncClient.SyncPushUpdates(c.ctx, &sync.TLSyncPushUpdates{
				UserId: v.UserId,
				Updates: mtproto.MakeUpdatesByUpdates(mtproto.MakeTLUpdateReadMessagesContents(&mtproto.Update{
					Messages:  []int32{v.UserMessageBoxId},
					Pts_INT32: pts,
					PtsCount:  1,
				}).To_Update()),
			})
		},
	)

	return mtproto.EmptyVoid, nil
}
