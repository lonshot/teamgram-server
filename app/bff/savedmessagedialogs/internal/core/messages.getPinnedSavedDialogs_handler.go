package core

import (
	"github.com/teamgram/marmota/pkg/container2/linkedmap"
	"github.com/teamgram/proto/mtproto"
	chatpb "pwm-server/app/service/biz/chat/chat"
	"pwm-server/app/service/biz/dialog/dialog"
	"pwm-server/app/service/biz/message/message"
	userpb "pwm-server/app/service/biz/user/user"
)

// MessagesGetPinnedSavedDialogs
// messages.getPinnedSavedDialogs#d63d94e0 = messages.SavedDialogs;
func (c *SavedMessageDialogsCore) MessagesGetPinnedSavedDialogs(in *mtproto.TLMessagesGetPinnedSavedDialogs) (*mtproto.Messages_SavedDialogs, error) {
	var (
		msgIdList []int32
		rMessages = linkedmap.New()
		rValues   = mtproto.MakeTLMessagesSavedDialogs(&mtproto.Messages_SavedDialogs{
			Dialogs:  []*mtproto.SavedDialog{},
			Messages: []*mtproto.Message{},
			Chats:    []*mtproto.Chat{},
			Users:    []*mtproto.User{},
		}).To_Messages_SavedDialogs()
	)

	dialogs, err := c.svcCtx.Dao.DialogClient.DialogGetPinnedSavedDialogs(c.ctx, &dialog.TLDialogGetPinnedSavedDialogs{
		UserId: c.MD.UserId,
	})
	if err != nil {
		c.Logger.Errorf("messages.getPinnedSavedDialogs - error: %v", err)
		return nil, err
	} else if len(dialogs.Dialogs) == 0 {
		return rValues, nil
	}

	rValues.Dialogs = dialogs.Dialogs

	for _, dialog := range rValues.Dialogs {
		msgIdList = append(msgIdList, dialog.TopMessage)
	}

	boxList, _ := c.svcCtx.Dao.MessageClient.MessageGetUserMessageList(
		c.ctx,
		&message.TLMessageGetUserMessageList{
			UserId: c.MD.UserId,
			IdList: msgIdList,
		})

	boxList.Visit(c.MD.UserId,
		func(messageList []*mtproto.Message) {
			for _, msg := range messageList {
				rMessages.Add(msg.Id, msg)
			}
			for i := rMessages.First(); i != nil; i = i.Next() {
				rValues.Messages = append(rValues.Messages, i.Value().(*mtproto.Message))
			}
		},
		func(userIdList []int64) {
			mUsers, _ := c.svcCtx.Dao.UserClient.UserGetMutableUsers(
				c.ctx,
				&userpb.TLUserGetMutableUsers{
					Id: userIdList,
				})
			rValues.Users = append(rValues.Users, mUsers.GetUserListByIdList(c.MD.UserId, userIdList...)...)
		},
		func(chatIdList []int64) {
			mChats, _ := c.svcCtx.Dao.ChatClient.ChatGetChatListByIdList(
				c.ctx,
				&chatpb.TLChatGetChatListByIdList{
					IdList: chatIdList,
				})
			rValues.Chats = append(rValues.Chats, mChats.GetChatListByIdList(c.MD.UserId, chatIdList...)...)
		},
		func(channelIdList []int64) {
			// TODO: not impl
		})

	return rValues, nil
}
