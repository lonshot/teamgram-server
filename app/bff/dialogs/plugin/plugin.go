package plugin

import (
	"context"

	"github.com/teamgram/proto/mtproto"
	"pwm-server/app/service/biz/dialog/dialog"
)

type DialogsPlugin interface {
	GetChannelListByIdList(ctx context.Context, selfId int64, id ...int64) []*mtproto.Chat
	GetChannelDialogById(ctx context.Context, selfId int64, id int64) (*dialog.DialogExt, error)
	GetChannelMessage(ctx context.Context, selfId, channelId int64, id int32) (*mtproto.MessageBox, error)
}
