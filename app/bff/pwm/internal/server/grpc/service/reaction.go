package service

import (
	"context"
	"github.com/teamgram/proto/mtproto"
)

func (s Service) MessagesSendReaction(ctx context.Context, reaction *mtproto.TLMessagesSendReaction) (
	*mtproto.Updates, error,
) {
	//TODO implement me
	panic("implement me")
}

func (s Service) MessagesGetMessagesReactions(
	ctx context.Context, reactions *mtproto.TLMessagesGetMessagesReactions,
) (*mtproto.Updates, error) {
	//TODO implement me
	panic("implement me")
}

func (s Service) MessagesGetMessageReactionsList(
	ctx context.Context, list *mtproto.TLMessagesGetMessageReactionsList,
) (*mtproto.Messages_MessageReactionsList, error) {
	//TODO implement me
	panic("implement me")
}

func (s Service) MessagesSetChatAvailableReactions(
	ctx context.Context, reactions *mtproto.TLMessagesSetChatAvailableReactions,
) (*mtproto.Updates, error) {
	//TODO implement me
	panic("implement me")
}

func (s Service) MessagesGetAvailableReactions(
	ctx context.Context, reactions *mtproto.TLMessagesGetAvailableReactions,
) (*mtproto.Messages_AvailableReactions, error) {
	//TODO implement me
	panic("implement me")
}

func (s Service) MessagesSetDefaultReaction(
	ctx context.Context, reaction *mtproto.TLMessagesSetDefaultReaction,
) (*mtproto.Bool, error) {
	//TODO implement me
	panic("implement me")
}

func (s Service) MessagesGetUnreadReactions(
	ctx context.Context, reactions *mtproto.TLMessagesGetUnreadReactions,
) (*mtproto.Messages_Messages, error) {
	//TODO implement me
	panic("implement me")
}

func (s Service) MessagesReadReactions(
	ctx context.Context, reactions *mtproto.TLMessagesReadReactions,
) (*mtproto.Messages_AffectedHistory, error) {
	//TODO implement me
	panic("implement me")
}

func (s Service) MessagesReportReaction(ctx context.Context, reaction *mtproto.TLMessagesReportReaction) (
	*mtproto.Bool, error,
) {
	//TODO implement me
	panic("implement me")
}

func (s Service) MessagesGetTopReactions(
	ctx context.Context, reactions *mtproto.TLMessagesGetTopReactions,
) (*mtproto.Messages_Reactions, error) {
	//TODO implement me
	panic("implement me")
}

func (s Service) MessagesGetRecentReactions(
	ctx context.Context, reactions *mtproto.TLMessagesGetRecentReactions,
) (*mtproto.Messages_Reactions, error) {
	//TODO implement me
	panic("implement me")
}

func (s Service) MessagesClearRecentReactions(
	ctx context.Context, reactions *mtproto.TLMessagesClearRecentReactions,
) (*mtproto.Bool, error) {
	//TODO implement me
	panic("implement me")
}
