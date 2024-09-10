package plugin

import (
	"context"

	"github.com/teamgram/proto/mtproto"
)

type MessagesPlugin interface {
	GetWebpagePreview(ctx context.Context, url string) (*mtproto.WebPage, error)
	GetMessageMedia(ctx context.Context, userId, ownerId int64, media *mtproto.InputMedia) (*mtproto.MessageMedia, error)
	// RebuildMessageEntities(ctx context.Context, fromId int64, peer *mtproto.PeerUtil, noWebpage bool, message *mtproto.Message, hasBot bool) (*mtproto.Message, error)
}
