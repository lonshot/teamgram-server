package service

import (
	"context"
	"errors"
	"fmt"
	"github.com/teamgram/proto/mtproto"
	"pwm-server/app/bff/pwm/internal/core"
	"pwm-server/app/bff/pwm/internal/dao/dataobject"
	"pwm-server/app/service/biz/message/message"
	"time"
)

// MessagesSendReaction allows users to send reactions to messages.
func (s *Service) MessagesSendReaction(ctx context.Context, reaction *mtproto.TLMessagesSendReaction) (
	*mtproto.Updates, error,
) {
	fmt.Printf(
		"MessagesSendReaction called with: Peer: %+v, MsgId: %d, Reactions: %+v\n", reaction.Peer, reaction.MsgId,
		reaction.Reaction_FLAGVECTORREACTION,
	)

	// Validate input
	if reaction.Peer == nil || len(reaction.Reaction_FLAGVECTORREACTION) == 0 || reaction.MsgId == 0 {
		fmt.Printf(
			"Invalid input: Peer: %+v, MsgId: %d, Reactions: %+v\n", reaction.Peer, reaction.MsgId,
			reaction.Reaction_FLAGVECTORREACTION,
		)
		return nil, errors.New("invalid input")
	}

	// Initialize PeerId and PeerType
	var peerId int64
	var peerType int32

	// Handle different peer types from InputPeer
	p := mtproto.FromInputPeer(reaction.Peer)
	peerId = p.PeerId
	peerType = p.PeerType
	fmt.Printf("Resolved PeerId: %d, PeerType: %d\n", peerId, peerType)

	// Extract current user from the context (core)
	c := core.New(ctx, s.svcCtx)
	fmt.Printf("Current UserId: %d\n", c.MD.UserId)

	// Get the message details using the MessageClient
	fmt.Printf("Fetching message with MsgId: %d for UserId: %d\n", reaction.MsgId, c.MD.UserId)
	box, err := s.svcCtx.MessageClient.MessageGetUserMessage(
		ctx, &message.TLMessageGetUserMessage{
			UserId: c.MD.UserId,
			Id:     reaction.MsgId, // The ID of the message to which a reaction will be added
		},
	)
	if err != nil {
		fmt.Printf("Error: Message not found for MsgId: %d, UserId: %d\n", reaction.MsgId, c.MD.UserId)
		return nil, errors.New("message not found")
	}
	fmt.Printf("Message fetched: %+v\n", box)

	// Loop through all reactions in Reaction_FLAGVECTORREACTION
	for _, reactionItem := range reaction.Reaction_FLAGVECTORREACTION {
		// Extract the actual reaction value from the Reaction structure
		reactionValue := reactionItem.Emoticon
		fmt.Printf("Processing reaction: %s for MsgId: %d\n", reactionValue, reaction.MsgId)

		// Insert the reaction into the database
		_, err = s.svcCtx.Dao.InsertReaction(
			ctx, &dataobject.ReactionsDO{
				UserId:    c.MD.UserId,
				MessageId: int64(reaction.MsgId), // Convert int32 to int64
				Reaction:  reactionValue,
				PeerId:    peerId,
				PeerType:  peerType,
				CreatedAt: time.Now().Unix(),
				UpdatedAt: time.Now().Unix(),
			},
		)
		if err != nil {
			fmt.Printf("Error: Failed to save reaction: %s for MsgId: %d\n", reactionValue, reaction.MsgId)
			return nil, errors.New("failed to save reaction")
		}
		fmt.Printf("Reaction %s saved successfully for MsgId: %d\n", reactionValue, reaction.MsgId)
	}

	// Retrieve the updated list of reactions for the message
	fmt.Printf("Retrieving updated reactions for MsgId: %d\n", reaction.MsgId)
	reactionsList, err := s.svcCtx.Dao.SelectReactionsByMessageId(ctx, int64(reaction.MsgId))
	if err != nil {
		fmt.Printf("Error: Failed to retrieve updated reactions for MsgId: %d\n", reaction.MsgId)
		return nil, errors.New("failed to retrieve updated reactions")
	}
	fmt.Printf("Updated reactions list: %+v\n", reactionsList)

	// Convert the reactions to proto format
	reactionProto := convertReactionsToMessageReactionsProto(reactionsList)
	box.Message.Reactions = reactionProto
	updates := mtproto.MakeUpdatesByUpdates(
		mtproto.MakeTLUpdateEditMessage(
			&mtproto.Update{
				Pts_INT32:       box.Pts,
				PtsCount:        box.PtsCount,
				Message_MESSAGE: box.Message,
			},
		).To_Update(),
	)
	if err != nil {
		c.Logger.Errorf("inbox.editMessageToInboxV2 - error: %v", err)
		return nil, err
	}
	fmt.Printf("Updates created: %+v\n", updates)

	// _, err = s.svcCtx.Dao.SyncClient.SyncUpdatesNotMe(
	//	ctx, &sync.TLSyncUpdatesNotMe{
	//		UserId:        peerId,
	//		PermAuthKeyId: c.MD.PermAuthKeyId,
	//		Updates:       updates,
	//	},
	// )
	// if err != nil {
	// 	fmt.Printf("Error: Failed to push update to peer\n")
	// 	return nil, errors.New("failed to push update to peer")
	// }

	fmt.Printf("Updates successfully generated for MsgId: %d\n", reaction.MsgId)
	return updates, nil
}

// MessagesGetMessagesReactions retrieves reactions for a list of message IDs.
func (s Service) MessagesGetMessagesReactions(
	ctx context.Context, reactions *mtproto.TLMessagesGetMessagesReactions,
) (*mtproto.Updates, error) {
	// Validate input
	if reactions.Peer == nil || len(reactions.Id) == 0 {
		return nil, errors.New("invalid input")
	}

	// Convert the list of int32 message IDs to int64
	msgIds := make([]int32, len(reactions.Id))
	for i, id := range reactions.Id {
		msgIds[i] = int32(id)
	}

	// Extract current user from the context (core)
	c := core.New(ctx, s.svcCtx)
	// Get the message list details using the MessageClient
	messageBoxes, err := s.svcCtx.MessageClient.MessageGetUserMessageList(
		ctx, &message.TLMessageGetUserMessageList{
			UserId: c.MD.UserId,
			IdList: msgIds, // The ID of the message to which a reaction will be added
		},
	)
	if err != nil {
		return nil, errors.New("message not found")
	}

	var messageUpdates []*mtproto.Update
	for _, box := range messageBoxes.GetDatas() {
		// Retrieve the updated list of reactions for the message
		reactionsList, err2 := s.svcCtx.Dao.SelectReactionsByMessageId(ctx, int64(box.MessageId))
		if err2 != nil {
			return nil, errors.New("failed to retrieve message reactions")
		}

		// Convert the reactions to proto format
		reactionProto := convertReactionsToMessageReactionsProto(reactionsList)

		messageUpdates = append(
			messageUpdates, mtproto.MakeTLUpdateMessageReactions(
				&mtproto.Update{
					UserId:                     c.MD.UserId,
					Pts_INT32:                  box.Pts,
					PtsCount:                   box.PtsCount,
					RandomId:                   box.RandomId,
					Message_MESSAGE:            box.Message,
					Reactions_MESSAGEREACTIONS: reactionProto,
				},
			).To_Update(),
		)
	}

	return mtproto.MakeTLUpdates(
		&mtproto.Updates{
			Updates: messageUpdates,
			Users:   []*mtproto.User{},
			Chats:   []*mtproto.Chat{},
			Date:    int32(time.Now().Unix()),
			Seq:     0,
		},
	).To_Updates(), nil
}

// convertReactionsToMessageReactionsProto converts the list of ReactionsDO into proto format (MessageReactions).
func convertReactionsToMessageReactionsProto(reactions []*dataobject.ReactionsDO) *mtproto.MessageReactions {
	var protoReactions []*mtproto.MessagePeerReaction
	reactionCountMap := make(map[string]int32) // Map to store the count of each reaction type
	uniqueReactionSet := make(map[string]bool) // Set to track if a reaction type has been added to protoReactions

	for _, reaction := range reactions {
		// Count the reactions for each type
		reactionCountMap[reaction.Reaction]++

		// Skip adding to protoReactions if the reaction has already been added
		if uniqueReactionSet[reaction.Reaction] {
			continue
		}

		// Create each proto reaction object
		protoReaction := mtproto.MakeTLMessagePeerReaction(
			&mtproto.MessagePeerReaction{
				Reaction: reaction.Reaction,                     // The reaction (e.g., emoji)
				PeerId:   mtproto.MakePeerUser(reaction.UserId), // User who made the reaction
				Date:     int32(reaction.CreatedAt),             // The date of the reaction (convert timestamp to int32)
				Unread:   !reaction.Read,                        // Whether the reaction is unread
			},
		).To_MessagePeerReaction()

		// Append to the list of proto reactions
		protoReactions = append(protoReactions, protoReaction)

		// Mark the reaction type as already added
		uniqueReactionSet[reaction.Reaction] = true
	}

	// Create the Results list of ReactionCount from the reactionCountMap
	var reactionCounts []*mtproto.ReactionCount
	for reaction, count := range reactionCountMap {
		reactionCounts = append(
			reactionCounts, mtproto.MakeTLReactionCount(
				&mtproto.ReactionCount{
					Reaction: reaction,
					Count:    count,
				},
			).To_ReactionCount(),
		)
	}

	// Return the MessageReactions object with both the proto reactions list and the reaction counts
	return mtproto.MakeTLMessageReactions(
		&mtproto.MessageReactions{
			Results:         reactionCounts, // Populated with aggregated reaction counts
			RecentReactions: protoReactions, // The individual reactions we just converted
			CanSeeList:      true,           // Can customize this depending on the use case
		},
	).To_MessageReactions()
}

// MessagesGetMessageReactionsList retrieves the list of reactions for a specific message.
func (s *Service) MessagesGetMessageReactionsList(
	ctx context.Context, list *mtproto.TLMessagesGetMessageReactionsList,
) (*mtproto.Messages_MessageReactionsList, error) {
	// Validate input
	if list.Peer == nil || list.Id == 0 {
		return nil, errors.New("invalid input")
	}

	// Retrieve reactions for the specified message ID
	reactions, err := s.svcCtx.Dao.SelectReactionsByMessageId(ctx, int64(list.Id))
	if err != nil {
		return nil, err
	}

	// Convert reactions to proto format and aggregate reaction counts
	var protoReactions []*mtproto.MessagePeerReaction
	uniqueReactionSet := make(map[string]bool) // Set to track if a reaction type has been added to protoReactions

	for _, reaction := range reactions {
		// Skip adding to protoReactions if the reaction has already been added
		if uniqueReactionSet[reaction.Reaction] {
			continue
		}

		// Create each proto reaction object
		protoReaction := mtproto.MakeTLMessagePeerReaction(
			&mtproto.MessagePeerReaction{
				Reaction: reaction.Reaction,                     // The reaction (e.g., emoji)
				PeerId:   mtproto.MakePeerUser(reaction.UserId), // User who made the reaction
				Date:     int32(reaction.CreatedAt),             // The date of the reaction (convert timestamp to int32)
				Unread:   !reaction.Read,                        // Whether the reaction is unread
			},
		).To_MessagePeerReaction()

		// Append to the list of proto reactions
		protoReactions = append(protoReactions, protoReaction)

		// Mark the reaction type as already added
		uniqueReactionSet[reaction.Reaction] = true
	}

	// Limit the number of reactions returned
	if list.Limit > 0 && len(protoReactions) > int(list.Limit) {
		protoReactions = protoReactions[:list.Limit]
	}

	// Build the response with both individual reactions and reaction counts
	reactionsList := mtproto.MakeTLMessagesMessageReactionsList(
		&mtproto.Messages_MessageReactionsList{
			Reactions: protoReactions,             // Individual reactions in proto format
			Count:     int32(len(protoReactions)), // Number of individual reactions returned
		},
	).To_Messages_MessageReactionsList()

	return reactionsList, nil
}

// MessagesSetChatAvailableReactions sets available reactions for a chat.
func (s Service) MessagesSetChatAvailableReactions(
	ctx context.Context, reactions *mtproto.TLMessagesSetChatAvailableReactions,
) (*mtproto.Updates, error) {
	// Prepare Updates object
	updates := &mtproto.Updates{
		// Return updated reactions
	}
	return updates, nil
}

// MessagesGetAvailableReactions fetches available reactions for a chat.
func (s Service) MessagesGetAvailableReactions(
	ctx context.Context, reactions *mtproto.TLMessagesGetAvailableReactions,
) (*mtproto.Messages_AvailableReactions, error) {
	return &mtproto.Messages_AvailableReactions{}, nil
}

// MessagesSetDefaultReaction sets a default reaction for a user.
func (s Service) MessagesSetDefaultReaction(
	ctx context.Context, reaction *mtproto.TLMessagesSetDefaultReaction,
) (*mtproto.Bool, error) {
	// Update the user's default reaction
	//err := s.svcCtx.Dao.UpdateDefaultReaction(ctx, reaction.UserId, reaction.Reaction)
	//if err != nil {
	//	return nil, err
	//}

	return mtproto.BoolTrue, nil
}

// MessagesGetUnreadReactions gets unread reactions for the user.
func (s Service) MessagesGetUnreadReactions(
	ctx context.Context, reactions *mtproto.TLMessagesGetUnreadReactions,
) (*mtproto.Messages_Messages, error) {
	// Extract peerId and construct Peer object
	var peerId int64

	// Handle different peer types from InputPeer
	peer := mtproto.FromInputPeer(reactions.Peer)
	peerId = peer.PeerId

	// Fetch unread reactions for the user using pagination parameters
	unreadReactions, err := s.svcCtx.Dao.SelectUnreadReactionsByUserId(
		ctx, peerId, reactions.OffsetId, reactions.Limit,
	)
	if err != nil {
		return nil, err
	}

	// Convert unread reactions into proto format
	protoMessages := make([]*mtproto.Message, len(unreadReactions))
	for i, reaction := range unreadReactions {
		protoMessages[i] = &mtproto.Message{
			Id:        int32(reaction.MessageId),
			PeerId:    peer.ToPeer(),
			Reactions: convertReactionsToMessageReactionsProto([]*dataobject.ReactionsDO{reaction}),
		}
	}

	// Return unread messages
	return mtproto.MakeTLMessagesMessages(
		&mtproto.Messages_Messages{
			Messages: protoMessages,
		},
	).To_Messages_Messages(), nil
}

// MessagesReadReactions marks reactions as read.
func (s Service) MessagesReadReactions(
	ctx context.Context, reactions *mtproto.TLMessagesReadReactions,
) (*mtproto.Messages_AffectedHistory, error) {
	// Extract peerId based on Peer type
	var peerId int64

	peer := mtproto.FromInputPeer(reactions.Peer)
	peerId = peer.PeerId

	// Convert TopMsgId to int32 if it exists
	var topMsgId int32
	if reactions.TopMsgId != nil {
		topMsgId = reactions.TopMsgId.GetValue()
	}

	// Get the current Unix timestamp for updating the 'read' status
	updatedAt := time.Now().Unix()

	// Mark reactions as read for the given peer and top message ID
	err := s.svcCtx.Dao.MarkReactionsAsRead(ctx, peerId, int64(topMsgId), updatedAt)
	if err != nil {
		return nil, err
	}

	// Prepare the affected history response
	affectedHistory := &mtproto.Messages_AffectedHistory{
		Pts:      0, // These values can be populated based on your app's logic
		PtsCount: 1, // Count of updates made, like the number of read reactions
		Offset:   0, // Offset if needed for pagination
	}

	return mtproto.MakeTLMessagesAffectedHistory(
		affectedHistory,
	).To_Messages_AffectedHistory(), nil
}

// MessagesReportReaction reports a reaction.
func (s Service) MessagesReportReaction(
	ctx context.Context, reaction *mtproto.TLMessagesReportReaction,
) (*mtproto.Bool, error) {

	// Validate input
	if reaction == nil || reaction.Id == 0 || reaction.ReactionPeer == nil {
		return nil, errors.New("invalid input")
	}

	// Report the reaction in the database
	err := s.svcCtx.Dao.ReportReaction(ctx, int64(reaction.Id), reaction.ReactionPeer.String())
	if err != nil {
		return nil, err
	}

	// Return success response
	return mtproto.BoolTrue, nil
}

// MessagesGetTopReactions retrieves the top reactions.
func (s Service) MessagesGetTopReactions(
	ctx context.Context, reactions *mtproto.TLMessagesGetTopReactions,
) (*mtproto.Messages_Reactions, error) {
	// Fetch top reactions from the database
	topReactions, err := s.svcCtx.Dao.SelectTopReactions(ctx)
	if err != nil {
		return nil, err
	}

	// Convert the top reactions into the proto format using Reaction instead of ReactionCount
	var protoReactions []*mtproto.Reaction
	for _, reaction := range topReactions {
		protoReactions = append(
			protoReactions, mtproto.MakeTLReactionEmoji(
				&mtproto.Reaction{
					Emoticon: reaction.Reaction, // Emoji or reaction identifier
					//DocumentId: reaction.Reaction
					//Count:    int32(reaction.Count), // The number of times this reaction was used
				},
			).To_Reaction(),
		)
	}

	// Create the Messages_Reactions object to return
	reactionList := mtproto.MakeTLMessagesReactions(
		&mtproto.Messages_Reactions{
			Reactions: protoReactions, // Use the list of Reaction
		},
	).To_Messages_Reactions()

	return reactionList, nil
}

// MessagesGetRecentReactions retrieves recent reactions.
func (s Service) MessagesGetRecentReactions(
	ctx context.Context, reactions *mtproto.TLMessagesGetRecentReactions,
) (*mtproto.Messages_Reactions, error) {
	// Fetch recent reactions for the user
	c := core.New(ctx, s.svcCtx)
	recentReactions, err := s.svcCtx.Dao.SelectRecentReactions(ctx, c.MD.UserId, reactions.Limit)
	if err != nil {
		return nil, err
	}

	// Convert the recent reactions into the proto format
	var protoReactions []*mtproto.Reaction
	for _, reaction := range recentReactions {
		protoReactions = append(
			protoReactions, mtproto.MakeTLReactionEmoji(
				&mtproto.Reaction{
					Emoticon: reaction.Reaction, // The emoji or reaction identifier
				},
			).To_Reaction(),
		)
	}

	// Create and return the Messages_Reactions object
	reactionList := mtproto.MakeTLMessagesReactions(
		&mtproto.Messages_Reactions{
			Reactions: protoReactions, // Populate recent reactions
		},
	).To_Messages_Reactions()

	return reactionList, nil
}

// MessagesClearRecentReactions clears recent reactions for the user.
func (s Service) MessagesClearRecentReactions(
	ctx context.Context, reactions *mtproto.TLMessagesClearRecentReactions,
) (*mtproto.Bool, error) {
	c := core.New(ctx, s.svcCtx)
	// Clear recent reactions for the user in the database
	err := s.svcCtx.Dao.ClearRecentReactions(ctx, c.MD.UserId)
	if err != nil {
		return nil, err
	}

	return mtproto.BoolTrue, nil
}
