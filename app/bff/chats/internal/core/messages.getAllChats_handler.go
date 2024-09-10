package core

import (
	"github.com/teamgram/marmota/pkg/container2"
	"github.com/teamgram/proto/mtproto"
	"pwm-server/app/service/biz/dialog/dialog"
)

// MessagesGetAllChats
// messages.getAllChats#875f74be except_ids:Vector<long> = messages.Chats;
func (c *ChatsCore) MessagesGetAllChats(in *mtproto.TLMessagesGetAllChats) (*mtproto.Messages_Chats, error) {
	dList, err := c.svcCtx.Dao.DialogClient.DialogGetMyDialogsData(
		c.ctx,
		&dialog.TLDialogGetMyDialogsData{
			UserId:  c.MD.UserId,
			User:    false,
			Chat:    true,
			Channel: true,
		})
	if err != nil {
		c.Logger.Errorf("messages.getAllChats - error: %v", err)
		return nil, err
	}

	var (
		idList        []int64
		messagesChats = mtproto.MakeTLMessagesChats(&mtproto.Messages_Chats{
			Chats: []*mtproto.Chat{},
		}).To_Messages_Chats()
	)

	for _, id := range dList.GetChats() {
		if ok := container2.ContainsInt64(in.ExceptIds, id); !ok {
			idList = append(idList, id)
		}
	}

	if len(idList) == 0 {
		return messagesChats, nil
	}

	messagesChats.Chats = c.svcCtx.ChatClient.GetChatListByIdList(c.ctx, c.MD.UserId, idList...)
	return messagesChats, nil
}
