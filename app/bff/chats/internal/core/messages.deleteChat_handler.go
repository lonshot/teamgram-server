package core

import (
	"github.com/teamgram/proto/mtproto"
	msgpb "pwm-server/app/messenger/msg/msg/msg"
	"pwm-server/app/messenger/sync/sync"
	chatpb "pwm-server/app/service/biz/chat/chat"
	"pwm-server/app/service/biz/dialog/dialog"
)

// MessagesDeleteChat
// messages.deleteChat#5bd0ee50 chat_id:long = Bool;
func (c *ChatsCore) MessagesDeleteChat(in *mtproto.TLMessagesDeleteChat) (*mtproto.Bool, error) {
	operatorId := c.MD.UserId
	if c.MD.IsAdmin {
		operatorId = 0
	}

	// 2. delete chat
	chat, err := c.svcCtx.Dao.ChatClient.Client().ChatDeleteChat(c.ctx, &chatpb.TLChatDeleteChat{
		ChatId:     in.ChatId,
		OperatorId: operatorId,
	})
	if err != nil {
		c.Logger.Errorf("messages.deleteChat - error: %v", err)
		return nil, err
	}

	pushUpdates := mtproto.MakeUpdatesByUpdatesChats(
		[]*mtproto.Chat{chat.ToChatForbidden()},
		mtproto.MakeUpdateChat(chat.Id()))

	// 1. kicked all
	chat.Walk(func(userId int64, participant *mtproto.ImmutableChatParticipant) error {
		c.svcCtx.Dao.DialogClient.DialogDeleteDialog(c.ctx, &dialog.TLDialogDeleteDialog{
			UserId:   userId,
			PeerType: mtproto.PEER_CHAT,
			PeerId:   chat.Id(),
		})

		if userId == c.MD.UserId || participant.IsChatMemberStateNormal() {
			c.svcCtx.Dao.SyncClient.SyncPushUpdates(c.ctx, &sync.TLSyncPushUpdates{
				UserId:  userId,
				Updates: pushUpdates,
			})
		}

		c.svcCtx.Dao.MsgClient.MsgDeleteHistory(c.ctx, &msgpb.TLMsgDeleteHistory{
			UserId:    userId,
			AuthKeyId: 0,
			PeerType:  mtproto.PEER_CHAT,
			PeerId:    chat.Id(),
			JustClear: false,
			Revoke:    false,
		})
		return nil
	})

	return mtproto.BoolTrue, nil
}
