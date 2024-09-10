package plugin

import (
	"context"

	"github.com/teamgram/proto/mtproto"
)

type NotificationPlugin interface {
	GetChannelListByIdList(ctx context.Context, selfId int64, id ...int64) []*mtproto.Chat
	GetChannelById(ctx context.Context, selfId int64, id int64) (*mtproto.Chat, error)
}
