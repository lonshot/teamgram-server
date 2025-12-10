package core

import (
	"context"
	"sort"

	"github.com/teamgram/proto/mtproto"
	chatpb "pwm-server/app/service/biz/chat/chat"
	"pwm-server/app/service/biz/dialog/dialog"
	"pwm-server/app/service/biz/message/message"
	userpb "pwm-server/app/service/biz/user/user"

	"github.com/zeromicro/go-zero/core/mr"
)

// MessagesGetDialogs
// messages.getDialogs#a0f4cb4f flags:# exclude_pinned:flags.0?true folder_id:flags.1?int offset_date:int offset_id:int offset_peer:InputPeer limit:int hash:long = messages.Dialogs;
func (c *DialogsCore) MessagesGetDialogs(in *mtproto.TLMessagesGetDialogs) (*mtproto.Messages_Dialogs, error) {
	var (
		offsetPeer         = mtproto.FromInputPeer2(c.MD.UserId, in.OffsetPeer)
		folderId           = in.GetFolderId().GetValue()
		limit              = in.Limit
		dialogExtList      dialog.DialogExtList
		notifySettingsList []*userpb.PeerPeerNotifySettings
	)

	// Cap the limit to 500 if it's larger
	if limit > 500 {
		limit = 500
	}

	// Fetch dialogs and notification settings in parallel
	mr.FinishVoid(
		func() {
			dialogs, err := c.svcCtx.Dao.DialogClient.DialogGetDialogs(c.ctx, &dialog.TLDialogGetDialogs{
				UserId:        c.MD.UserId,
				ExcludePinned: mtproto.ToBool(in.ExcludePinned),
				FolderId:      folderId,
			})
			if err != nil {
				c.Logger.Errorf("messages.getDialogs - error fetching dialogs: %v", err)
			} else {
				dialogExtList = dialogs.GetDatas()
			}
		},
		func() {
			settingsList, err := c.svcCtx.Dao.UserClient.UserGetAllNotifySettings(c.ctx, &userpb.TLUserGetAllNotifySettings{
				UserId: c.MD.UserId,
			})
			if err != nil {
				c.Logger.Errorf("messages.getDialogs - error fetching notification settings: %v", err)
			} else {
				notifySettingsList = settingsList.GetDatas()
			}
		})

	// Return an empty result if no dialogs were found
	if len(dialogExtList) == 0 {
		return mtproto.MakeTLMessagesDialogsSlice(&mtproto.Messages_Dialogs{
			Dialogs:  []*mtproto.Dialog{},
			Messages: []*mtproto.Message{},
			Chats:    []*mtproto.Chat{},
			Users:    []*mtproto.User{},
			Count:    0,
		}).To_Messages_Dialogs(), nil
	}

	// Apply notification settings to dialogs
	for _, dialogEx := range dialogExtList {
		peer2 := mtproto.FromPeer(dialogEx.GetDialog().GetPeer())

		// Handle both channels and regular chats
		if peer2.IsChannel() || peer2.IsChat() {
			_, err := c.fetchChannelDetails(c.ctx, peer2.PeerId)
			if err != nil {
				c.Logger.Errorf("messages.getDialogs - error fetching channel details: %v", err)
				continue
			}
			// Attach the channel or chat info to the dialog's peer
			dialogEx.Dialog.Peer = mtproto.MakeTLPeerChannel(&mtproto.Peer{
				UserId: peer2.PeerId,
			}).To_Peer()
		}

		// Attach notify settings to the dialog
		dialogEx.Dialog.NotifySettings = userpb.FindPeerPeerNotifySettings(notifySettingsList, peer2)
	}

	// Sort dialogs by reverse order and apply limit and offset
	sort.Sort(sort.Reverse(dialogExtList))

	dialogExtList = dialogExtList.GetDialogsByOffsetLimit(
		in.OffsetDate,
		in.OffsetId,
		offsetPeer,
		limit)

	// Fetch messages, users, and chats for the dialogs
	messageDialogs := dialogExtList.DoGetMessagesDialogs(
		c.ctx,
		c.MD.UserId,
		fetchMessages(c),
		fetchUsers(c),
		fetchChats(c),
		fetchChannels(c))

	// Return the final dialog data
	return messageDialogs.ToMessagesDialogs(int32(dialogExtList.Len())), nil
}

// fetchChannelDetails handles fetching the channel details (e.g., participants, settings)
func (c *DialogsCore) fetchChannelDetails(ctx context.Context, channelId int64) (*mtproto.Chat, error) {
	channel, err := c.svcCtx.Dao.ChatClient.ChatGetChatListByIdList(ctx, &chatpb.TLChatGetChatListByIdList{
		IdList: []int64{channelId},
	})
	if err != nil || len(channel.GetChatListByIdList(c.MD.UserId, channelId)) == 0 {
		return nil, err
	}
	return channel.GetChatListByIdList(c.MD.UserId, channelId)[0], nil
}

// fetchMessages handles fetching messages for the given top message IDs
func fetchMessages(c *DialogsCore) func(ctx context.Context, selfUserId int64, id ...dialog.TopMessageId) []*mtproto.Message {
	return func(ctx context.Context, selfUserId int64, id ...dialog.TopMessageId) []*mtproto.Message {
		var (
			msgList   []*mtproto.Message
			msgIdList []int32
		)

		for _, id2 := range id {
			msgIdList = append(msgIdList, id2.TopMessage)
		}

		if len(msgIdList) > 0 {
			boxList, _ := c.svcCtx.Dao.MessageClient.MessageGetUserMessageList(c.ctx, &message.TLMessageGetUserMessageList{
				UserId: selfUserId,
				IdList: msgIdList,
			})
			boxList.Walk(func(idx int, v *mtproto.MessageBox) {
				msgList = append(msgList, v.ToMessage(c.MD.UserId))
			})
		}

		return msgList
	}
}

// fetchUsers handles fetching users by their IDs
func fetchUsers(c *DialogsCore) func(ctx context.Context, selfUserId int64, id ...int64) []*mtproto.User {
	return func(ctx context.Context, selfUserId int64, id ...int64) []*mtproto.User {
		users, _ := c.svcCtx.Dao.UserClient.UserGetMutableUsers(c.ctx, &userpb.TLUserGetMutableUsers{
			Id: id,
		})
		return users.GetUserListByIdList(c.MD.UserId, id...)
	}
}

// fetchChats handles fetching chats by their IDs
func fetchChats(c *DialogsCore) func(ctx context.Context, selfUserId int64, id ...int64) []*mtproto.Chat {
	return func(ctx context.Context, selfUserId int64, id ...int64) []*mtproto.Chat {
		chats, _ := c.svcCtx.Dao.ChatClient.ChatGetChatListByIdList(c.ctx, &chatpb.TLChatGetChatListByIdList{
			IdList: id,
		})
		return chats.GetChatListByIdList(c.MD.UserId, id...)
	}
}

// fetchChannels handles fetching channel information (if necessary)
func fetchChannels(c *DialogsCore) func(ctx context.Context, selfUserId int64, id ...int64) []*mtproto.Chat {
	return func(ctx context.Context, selfUserId int64, id ...int64) []*mtproto.Chat {
		chats, _ := c.svcCtx.Dao.ChatClient.ChatGetChatListByIdList(ctx, &chatpb.TLChatGetChatListByIdList{
			IdList: id,
		})
		return chats.GetChatListByIdList(c.MD.UserId, id...)
	}
}
