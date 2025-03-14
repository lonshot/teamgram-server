package core

import (
	"github.com/teamgram/marmota/pkg/container2/sets"
	"github.com/teamgram/proto/mtproto"
	"pwm-server/app/messenger/msg/inbox/inbox"
	"pwm-server/app/messenger/msg/internal/dal/dataobject"
	"pwm-server/app/messenger/sync/sync"
	chatpb "pwm-server/app/service/biz/chat/chat"
)

// InboxReadChatMediaUnreadToInbox
// inbox.readChatMediaUnreadToInbox from_id:long peer_chat_id:long id:Vector<int> = Void;
func (c *InboxCore) InboxReadChatMediaUnreadToInbox(in *inbox.TLInboxReadChatMediaUnreadToInbox) (*mtproto.Void, error) {
	var (
		idList = make([]int64, 0, len(in.GetId()))
		tables = sets.NewWithLength(1)
	)

	for _, id := range in.GetId() {
		idList = append(idList, id.DialogMessageId)
	}

	pUserIdList, _ := c.svcCtx.ChatClient.ChatGetChatParticipantIdList(c.ctx, &chatpb.TLChatGetChatParticipantIdList{
		ChatId: in.PeerChatId,
	})

	for _, uId := range pUserIdList.GetDatas() {
		tables.Insert(c.svcCtx.Dao.MessagesDAO.CalcTableName(uId))
	}

	for tableName, _ := range tables {
		c.svcCtx.Dao.MessagesDAO.SelectByMessageDataIdListWithCB(
			c.ctx,
			tableName,
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
	}

	return mtproto.EmptyVoid, nil
}
