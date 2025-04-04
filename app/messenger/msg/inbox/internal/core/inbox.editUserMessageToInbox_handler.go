package core

import (
	"github.com/teamgram/proto/mtproto"
	"pwm-server/app/messenger/msg/inbox/inbox"
	"pwm-server/app/messenger/sync/sync"
	chatpb "pwm-server/app/service/biz/chat/chat"
	userpb "pwm-server/app/service/biz/user/user"
)

// InboxEditUserMessageToInbox
// inbox.editUserMessageToInbox from_id:long peer_user_id:long message:Message = Void;
func (c *InboxCore) InboxEditUserMessageToInbox(in *inbox.TLInboxEditUserMessageToInbox) (*mtproto.Void, error) {
	inBox, err := c.svcCtx.Dao.EditUserInboxMessage(c.ctx, in.FromId, in.PeerUserId, in.Message)
	if err != nil {
		c.Logger.Errorf("editUserInboxMessage - error: %v", err)
		return nil, err
	} else if inBox == nil {
		err = mtproto.ErrMsgIdInvalid
		c.Logger.Errorf("editUserInboxMessage - error: %v", err)
		return nil, err
	}

	pushUpdates := mtproto.MakePushUpdates(
		func(idList []int64) []*mtproto.User {
			users, _ := c.svcCtx.Dao.UserClient.UserGetMutableUsers(c.ctx,
				&userpb.TLUserGetMutableUsers{
					Id: idList,
				})
			return users.GetUserListByIdList(in.PeerUserId, idList...)
		},
		func(idList []int64) []*mtproto.Chat {
			chats, _ := c.svcCtx.Dao.ChatClient.ChatGetChatListByIdList(c.ctx,
				&chatpb.TLChatGetChatListByIdList{
					IdList: idList,
				})
			return chats.GetChatListByIdList(in.PeerUserId, idList...)
		},
		func(idList []int64) []*mtproto.Chat {
			// TODO
			return nil
		},
		mtproto.MakeTLUpdateEditMessage(&mtproto.Update{
			Pts_INT32:       inBox.Pts,
			PtsCount:        inBox.PtsCount,
			Message_MESSAGE: inBox.Message,
		}).To_Update())

	c.svcCtx.Dao.SyncClient.SyncPushUpdates(c.ctx, &sync.TLSyncPushUpdates{
		UserId:  in.PeerUserId,
		Updates: pushUpdates,
	})

	return mtproto.EmptyVoid, nil
}
