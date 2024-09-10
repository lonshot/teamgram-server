package plugin

import (
	"context"
	"github.com/teamgram/proto/mtproto"
)

type MessagePlugin interface {
	GetMessageMediaPoll(ctx context.Context, userId int64, pollId int64) (*mtproto.MessageMedia, error)
}
