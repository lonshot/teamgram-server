package plugin

import (
	"context"

	"pwm-server/app/service/biz/username/username"

	"github.com/teamgram/proto/mtproto"
)

type MsgPlugin interface {
	ReadReactionUnreadMessage(ctx context.Context, userId int64, msgId int32) error
	UsernameResolveUsername(ctx context.Context, in *username.TLUsernameResolveUsername) (*mtproto.Peer, error)
	GetWebpagePreview(ctx context.Context, url string) (*mtproto.WebPage, error)
}
