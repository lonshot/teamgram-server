package core

import (
	chatpb "pwm-server/app/service/biz/chat/chat"
	"pwm-server/app/service/biz/dialog/dialog"
	"pwm-server/app/service/biz/message/message"

	"github.com/teamgram/proto/mtproto"
)

// MessagesGetMessageReadParticipants31C1C44F
// messages.getMessageReadParticipants#31c1c44f peer:InputPeer msg_id:int = Vector<ReadParticipantDate>;
func (c *ChatsCore) MessagesGetMessageReadParticipants31C1C44F(in *mtproto.TLMessagesGetMessageReadParticipants31C1C44F) (*mtproto.Vector_ReadParticipantDate, error) {
	var (
		peer                 = mtproto.FromInputPeer2(c.MD.UserId, in.Peer)
		readParticipantDates = make([]*mtproto.ReadParticipantDate, 0)
	)

	switch peer.PeerType {
	case mtproto.PEER_CHAT:
		msgBox, err := c.svcCtx.Dao.MessageClient.MessageGetUserMessage(c.ctx, &message.TLMessageGetUserMessage{
			UserId: c.MD.UserId,
			Id:     in.MsgId,
		})
		if err != nil {
			c.Logger.Errorf("messages.getMessageReadParticipants - error: %v", err)
			return nil, err
		}

		pIdList, err := c.svcCtx.Dao.ChatClient.Client().ChatGetChatParticipantIdList(c.ctx, &chatpb.TLChatGetChatParticipantIdList{
			ChatId: peer.PeerId,
		})
		if err != nil {
			c.Logger.Errorf("messages.getMessageReadParticipants - error: %v", err)
			return nil, err
		}

		boxList, err := c.svcCtx.Dao.MessageClient.MessageGetUserMessageListByDataIdUserIdList(c.ctx, &message.TLMessageGetUserMessageListByDataIdUserIdList{
			Id:         msgBox.DialogMessageId,
			UserIdList: pIdList.GetDatas(),
		})
		if err != nil {
			c.Logger.Errorf("messages.getMessageReadParticipants - error: %v", err)
			return nil, err
		}

		// TODO: 性能优化
		boxList.Walk(func(idx int, v *mtproto.MessageBox) {
			if v.UserId == c.MD.UserId {
				return
			}

			dialogList, _ := c.svcCtx.Dao.DialogClient.DialogGetDialogsByIdList(c.ctx, &dialog.TLDialogGetDialogsByIdList{
				UserId: v.UserId,
				IdList: []int64{mtproto.MakePeerDialogId(peer.PeerType, peer.PeerId)},
			})
			for _, d := range dialogList.GetDatas() {
				// c.Logger.Infof("messages.getMessageReadParticipants - dialog: %s", d)
				if d.GetDialog().GetReadInboxMaxId() >= v.MessageId {
					readParticipantDates = append(readParticipantDates, mtproto.MakeTLReadParticipantDate(&mtproto.ReadParticipantDate{
						UserId: v.UserId,
						Date:   0,
					}).To_ReadParticipantDate())
				}
			}
		})
	case mtproto.PEER_CHANNEL:
		c.Logger.Errorf("messages.getMessageReadParticipants blocked, License key from https://wb.playwith-me.com required to unlock enterprise features.")

		return nil, mtproto.ErrEnterpriseIsBlocked
	default:
		err := mtproto.ErrPeerIdInvalid
		c.Logger.Errorf("messages.getMessageReadParticipants - error: %v", err)
		return nil, err
	}

	// TODO: add readParticipantDates
	return &mtproto.Vector_ReadParticipantDate{
		Datas: readParticipantDates,
	}, nil
}
