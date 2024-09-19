package service

import (
	"context"
	"fmt"
	"github.com/teamgram/proto/mtproto"
	"pwm-server/app/bff/pwm/internal/core"
	"pwm-server/app/service/biz/dialog/dialog"
)

func (s Service) MessagesGetDialogFiltersEFD48C89(
	ctx context.Context, c89 *mtproto.TLMessagesGetDialogFiltersEFD48C89,
) (*mtproto.Messages_DialogFilters, error) {
	c := core.New(ctx, s.svcCtx)
	userId := c.MD.UserId

	// Fetch dialog filters for the user from the database
	filters, err := s.svcCtx.DialogClient.DialogGetDialogFilters(
		ctx, &dialog.TLDialogGetDialogFilters{
			UserId: userId,
		},
	)
	if err != nil {
		return nil, fmt.Errorf("failed to get dialog filters for user %d: %w", userId, err)
	}

	if filters == nil || filters.Datas == nil {
		return nil, fmt.Errorf("dialog filters or its data are nil for user %d", userId)
	}

	// Convert filters.Datas (of type []*DialogFilterExt) to Filters (of type []*DialogFilter)
	dialogFilters := mtproto.MakeTLMessagesDialogFilters(
		&mtproto.Messages_DialogFilters{
			Filters: make(
				[]*mtproto.DialogFilter, len(filters.Datas),
			), // Initialize the slice with the appropriate length
		},
	).To_Messages_DialogFilters()

	for i, filterExt := range filters.Datas {
		dialogFilters.Filters[i] = mtproto.MakeTLDialogFilter(
			filterExt.DialogFilter,
		).To_DialogFilter()
	}

	return dialogFilters, nil
}
func (s Service) MessagesGetSuggestedDialogFilters(
	ctx context.Context, filters *mtproto.TLMessagesGetSuggestedDialogFilters,
) (*mtproto.Vector_DialogFilterSuggested, error) {
	c := core.New(ctx, s.svcCtx)
	userId := c.MD.UserId

	// Call the DialogClient to get dialog filters
	dialogFilters, err := s.svcCtx.DialogClient.DialogGetDialogFilters(
		ctx, &dialog.TLDialogGetDialogFilters{
			UserId: userId,
		},
	)
	if err != nil {
		return nil, fmt.Errorf("failed to get dialog filters for user %d: %w", userId, err)
	}

	// Build suggested filters from the fetched dialog filters
	var suggestedFilters []*mtproto.DialogFilterSuggested
	for _, filterExt := range dialogFilters.Datas {
		if filterExt != nil {
			// Create a suggested filter from the fetched data
			suggestedFilters = append(
				suggestedFilters, mtproto.MakeTLDialogFilterSuggested(
					&mtproto.DialogFilterSuggested{
						Filter: mtproto.MakeTLDialogFilter(
							filterExt.DialogFilter,
						).To_DialogFilter(), // Use the actual dialog filter
					},
				).To_DialogFilterSuggested(),
			)
		}
	}

	// Return in mtproto format
	return &mtproto.Vector_DialogFilterSuggested{
		Datas: suggestedFilters,
	}, nil
}

func (s Service) MessagesUpdateDialogFilter(
	ctx context.Context, filter *mtproto.TLMessagesUpdateDialogFilter,
) (*mtproto.Bool, error) {
	c := core.New(ctx, s.svcCtx)
	userId := c.MD.UserId
	dialogFilter := filter.Filter

	// Update the dialog filter in the database (you will need to write a DAO method for this)
	_, err := s.svcCtx.DialogClient.DialogInsertOrUpdateDialogFilter(
		ctx, &dialog.TLDialogInsertOrUpdateDialogFilter{
			UserId:       userId,
			Id:           dialogFilter.GetId(),
			DialogFilter: dialogFilter,
		},
	)
	if err != nil {
		return nil, err
	}

	return mtproto.MakeTLBoolTrue(nil).To_Bool(), nil
}
func (s Service) MessagesUpdateDialogFiltersOrder(
	ctx context.Context, order *mtproto.TLMessagesUpdateDialogFiltersOrder,
) (*mtproto.Bool, error) {
	c := core.New(ctx, s.svcCtx)
	userId := c.MD.UserId
	newOrder := order.Order

	// Update dialog filter order in the database
	_, err := s.svcCtx.DialogClient.DialogUpdateDialogFiltersOrder(
		ctx, &dialog.TLDialogUpdateDialogFiltersOrder{
			UserId: userId,
			Order:  newOrder,
		},
	)
	if err != nil {
		return nil, err
	}

	return mtproto.MakeTLBoolTrue(nil).To_Bool(), nil
}
func (s Service) FoldersEditPeerFolders(
	ctx context.Context, folders *mtproto.TLFoldersEditPeerFolders,
) (*mtproto.Updates, error) {
	c := core.New(ctx, s.svcCtx)
	userId := c.MD.UserId
	peerFolders := folders.FolderPeers // Use FolderPeers as defined in the struct

	// Check if peerFolders is nil or empty
	if peerFolders == nil || len(peerFolders) == 0 {
		return nil, fmt.Errorf("folder peers cannot be empty")
	}

	var peerDialogList []int64
	for _, folder := range peerFolders {
		if folder != nil && folder.Peer != nil { // Assuming Peer is not nil
			peerDialogList = append(peerDialogList, folder.Peer.UserId) // Assuming PeerId is the ID you need
		}
	}

	// Call the dialog client to edit peer folders
	pinnedDialogs, err := s.svcCtx.DialogClient.DialogEditPeerFolders(
		ctx, &dialog.TLDialogEditPeerFolders{
			UserId:         userId,
			PeerDialogList: peerDialogList, // Pass the converted peer dialog list here
			FolderId:       0,              // Assuming FolderId is not used, or you can replace this with the correct value if necessary
		},
	)
	if err != nil {
		return nil, fmt.Errorf("failed to edit peer folders: %w", err)
	}

	// Check if pinnedDialogs or its Datas field is nil
	if pinnedDialogs == nil || pinnedDialogs.Datas == nil || len(pinnedDialogs.Datas) == 0 {
		return nil, fmt.Errorf("no pinned dialogs data returned")
	}

	// Build updates response (you can add more logic here to customize the response)
	updates := &mtproto.Updates{
		Updates: []*mtproto.Update{}, // Initialize with empty updates
		Chats:   []*mtproto.Chat{},   // Initialize with empty chats
	}

	// Convert pinnedDialogs.Datas (type []*DialogPinnedExt) to the appropriate mtproto structure
	for _, pinned := range pinnedDialogs.Datas {
		// Assuming DialogPinnedExt has a field that needs to be converted into mtproto.Chat or a related structure
		chat := convertDialogPinnedExtToChat(pinned) // You need to implement this conversion function
		updates.Chats = append(updates.Chats, chat)
	}

	return mtproto.MakeTLUpdates(updates).To_Updates(), nil
}

func convertDialogPinnedExtToChat(pinned *dialog.DialogPinnedExt) *mtproto.Chat {
	if pinned == nil {
		return nil
	}

	// Map fields from DialogPinnedExt to mtproto.Chat
	return mtproto.MakeTLChat(
		&mtproto.Chat{
			Id: pinned.PeerId, // Assuming DialogPinnedExt has a PeerId field
			// Add other field mappings here
		},
	).To_Chat()
}

func (s Service) ChatlistsExportChatlistInvite(
	ctx context.Context, invite *mtproto.TLChatlistsExportChatlistInvite,
) (*mtproto.Chatlists_ExportedChatlistInvite, error) {
	//TODO implement me
	panic("implement me")
}

func (s Service) ChatlistsDeleteExportedInvite(
	ctx context.Context, invite *mtproto.TLChatlistsDeleteExportedInvite,
) (*mtproto.Bool, error) {
	//TODO implement me
	panic("implement me")
}

func (s Service) ChatlistsEditExportedInvite(
	ctx context.Context, invite *mtproto.TLChatlistsEditExportedInvite,
) (*mtproto.ExportedChatlistInvite, error) {
	//TODO implement me
	panic("implement me")
}

func (s Service) ChatlistsGetExportedInvites(
	ctx context.Context, invites *mtproto.TLChatlistsGetExportedInvites,
) (*mtproto.Chatlists_ExportedInvites, error) {
	//TODO implement me
	panic("implement me")
}

func (s Service) ChatlistsCheckChatlistInvite(
	ctx context.Context, invite *mtproto.TLChatlistsCheckChatlistInvite,
) (*mtproto.Chatlists_ChatlistInvite, error) {
	//TODO implement me
	panic("implement me")
}

func (s Service) ChatlistsJoinChatlistInvite(
	ctx context.Context, invite *mtproto.TLChatlistsJoinChatlistInvite,
) (*mtproto.Updates, error) {
	//TODO implement me
	panic("implement me")
}

func (s Service) ChatlistsGetChatlistUpdates(
	ctx context.Context, updates *mtproto.TLChatlistsGetChatlistUpdates,
) (*mtproto.Chatlists_ChatlistUpdates, error) {
	//TODO implement me
	panic("implement me")
}

func (s Service) ChatlistsJoinChatlistUpdates(
	ctx context.Context, updates *mtproto.TLChatlistsJoinChatlistUpdates,
) (*mtproto.Updates, error) {
	//TODO implement me
	panic("implement me")
}

func (s Service) ChatlistsHideChatlistUpdates(
	ctx context.Context, updates *mtproto.TLChatlistsHideChatlistUpdates,
) (*mtproto.Bool, error) {
	//TODO implement me
	panic("implement me")
}

func (s Service) ChatlistsGetLeaveChatlistSuggestions(
	ctx context.Context, suggestions *mtproto.TLChatlistsGetLeaveChatlistSuggestions,
) (*mtproto.Vector_Peer, error) {
	//TODO implement me
	panic("implement me")
}

func (s Service) ChatlistsLeaveChatlist(
	ctx context.Context, chatlist *mtproto.TLChatlistsLeaveChatlist,
) (*mtproto.Updates, error) {
	//TODO implement me
	panic("implement me")
}

func (s Service) MessagesGetDialogFiltersF19ED96D(
	ctx context.Context, d *mtproto.TLMessagesGetDialogFiltersF19ED96D,
) (*mtproto.Vector_DialogFilter, error) {
	//TODO implement me
	panic("implement me")
}

func (s Service) FoldersDeleteFolder(ctx context.Context, folder *mtproto.TLFoldersDeleteFolder) (
	*mtproto.Updates, error,
) {
	//TODO implement me
	panic("implement me")
}
