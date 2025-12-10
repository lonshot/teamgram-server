package service

import (
	"context"
	"github.com/teamgram/proto/mtproto"
)

func (s Service) MessagesGetSavedGifs(
	ctx context.Context, gifs *mtproto.TLMessagesGetSavedGifs,
) (*mtproto.Messages_SavedGifs, error) {
	//TODO implement me
	panic("implement me")
}

func (s Service) MessagesSaveGif(ctx context.Context, gif *mtproto.TLMessagesSaveGif) (*mtproto.Bool, error) {
	//TODO implement me
	panic("implement me")
}
