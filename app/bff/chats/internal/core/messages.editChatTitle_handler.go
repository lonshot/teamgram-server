package core

import (
	"math/rand"

	"github.com/teamgram/proto/mtproto"
	msgpb "pwm-server/app/messenger/msg/msg/msg"
	chatpb "pwm-server/app/service/biz/chat/chat"
)

// MessagesEditChatTitle
// messages.editChatTitle#73783ffd chat_id:long title:string = Updates;
func (c *ChatsCore) MessagesEditChatTitle(in *mtproto.TLMessagesEditChatTitle) (*mtproto.Updates, error) {
	if in.Title == "" {
		err := mtproto.ErrChatTitleEmpty
		c.Logger.Errorf("messages.editChatTitle - error: ", err)
		return nil, err
	}

	chat, err := c.svcCtx.Dao.ChatClient.Client().ChatEditChatTitle(c.ctx, &chatpb.TLChatEditChatTitle{
		ChatId:     in.ChatId,
		EditUserId: c.MD.UserId,
		Title:      in.Title,
	})
	if err != nil {
		c.Logger.Errorf("messages.editChatTitle - error: ", err)
		return nil, err
	}

	replyUpdates, err := c.svcCtx.Dao.MsgClient.MsgSendMessageV2(
		c.ctx,
		&msgpb.TLMsgSendMessageV2{
			UserId:    c.MD.UserId,
			AuthKeyId: c.MD.PermAuthKeyId,
			PeerType:  mtproto.PEER_CHAT,
			PeerId:    in.ChatId,
			Message: []*msgpb.OutboxMessage{
				msgpb.MakeTLOutboxMessage(&msgpb.OutboxMessage{
					NoWebpage:    true,
					Background:   false,
					RandomId:     rand.Int63(),
					Message:      chat.MakeMessageService(c.MD.UserId, mtproto.MakeMessageActionChatEditTitle(in.Title)),
					ScheduleDate: nil,
				}).To_OutboxMessage(),
			},
		})
	if err != nil {
		c.Logger.Errorf("messages.editChatTitle - error: %v", err)
		return nil, err
	}

	return replyUpdates, nil
}
