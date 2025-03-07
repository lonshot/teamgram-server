package core

import (
	"github.com/teamgram/marmota/pkg/container2/linkedmap"
	"github.com/teamgram/proto/mtproto"
	chatpb "pwm-server/app/service/biz/chat/chat"
	"pwm-server/app/service/biz/dialog/dialog"
	"pwm-server/app/service/biz/message/message"
	userpb "pwm-server/app/service/biz/user/user"
)

// MessagesGetSavedDialogs
// messages.getSavedDialogs#5381d21a flags:# exclude_pinned:flags.0?true offset_date:int offset_id:int offset_peer:InputPeer limit:int hash:long = messages.SavedDialogs;
func (c *DialogsCore) MessagesGetSavedDialogs(in *mtproto.TLMessagesGetSavedDialogs) (*mtproto.Messages_SavedDialogs, error) {
	var (
		offsetPeer = mtproto.FromInputPeer2(c.MD.UserId, in.OffsetPeer)
		limit      = in.Limit
		msgIdList  []int32
		rMessages  = linkedmap.New()
		rValues    = mtproto.MakeTLMessagesSavedDialogsSlice(&mtproto.Messages_SavedDialogs{
			Dialogs:  []*mtproto.SavedDialog{},
			Messages: []*mtproto.Message{},
			Chats:    []*mtproto.Chat{},
			Users:    []*mtproto.User{},
			Count:    0,
		}).To_Messages_SavedDialogs()
	)

	if limit > 500 {
		limit = 500
	}

	dialogs, err := c.svcCtx.Dao.DialogClient.DialogGetSavedDialogs(c.ctx, &dialog.TLDialogGetSavedDialogs{
		UserId:        c.MD.UserId,
		ExcludePinned: mtproto.ToBool(in.ExcludePinned),
		OffsetDate:    in.GetOffsetDate(),
		OffsetId:      in.OffsetId,
		OffsetPeer:    offsetPeer,
		Limit:         limit,
	})
	if err != nil {
		c.Logger.Errorf("messages.getDialogs - error: %v", err)
		return nil, err
	} else if len(dialogs.Dialogs) == 0 {
		return rValues, nil
	}

	rValues.Dialogs = dialogs.Dialogs
	rValues.Count = dialogs.Count

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
