package core

import (
	"github.com/teamgram/proto/mtproto"
	"pwm-server/app/messenger/msg/inbox/inbox"
	"pwm-server/app/messenger/sync/sync"
)

// InboxReadMediaUnreadToInboxV2
// inbox.readMediaUnreadToInboxV2 user_id:long peer_type:int peer_id:long dialog_message_id:long = Void;
func (c *InboxCore) InboxReadMediaUnreadToInboxV2(in *inbox.TLInboxReadMediaUnreadToInboxV2) (*mtproto.Void, error) {
	unreadDO, err := c.svcCtx.Dao.MessagesDAO.SelectByMessageDataId(c.ctx, in.UserId, in.DialogMessageId)
	if err != nil {
		c.Logger.Errorf("inbox.readMediaUnreadToInboxV2 - error: %v", err)
		return nil, err
	}

	if !unreadDO.MediaUnread || !unreadDO.MediaUnread {
		return mtproto.EmptyVoid, nil
	}
	_, err = c.svcCtx.Dao.MessagesDAO.UpdateMediaUnread(c.ctx, unreadDO.UserId, unreadDO.UserMessageBoxId)
	if err != nil {
		c.Logger.Errorf("inbox.readMediaUnreadToInboxV2 - error: %v", err)
		return nil, err
	}

	pts := c.svcCtx.Dao.IDGenClient2.NextPtsId(c.ctx, in.UserId)
	if pts == 0 {
		c.Logger.Errorf("inbox.readMediaUnreadToInboxV2 - error: nextPtsId(%d) is 0", in.UserId)
		return nil, mtproto.ErrInternalServerError
	}

	c.svcCtx.Dao.SyncClient.SyncPushUpdates(c.ctx, &sync.TLSyncPushUpdates{
		UserId: in.UserId,
		Updates: mtproto.MakeUpdatesByUpdates(mtproto.MakeTLUpdateReadMessagesContents(&mtproto.Update{
			Messages:  []int32{unreadDO.UserMessageBoxId},
			Pts_INT32: pts,
			PtsCount:  1,
		}).To_Update()),
	})

	return mtproto.EmptyVoid, nil
}
