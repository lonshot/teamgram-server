package plugin

import (
	"context"

	"github.com/teamgram/proto/mtproto"
)

type ChatPlugin interface {
	GetChatCallActiveAndNotEmpty(ctx context.Context, userId int64, chatId int64) (bool, bool)
	GetChatGroupCall(ctx context.Context, userId int64, chatId int64) *mtproto.InputGroupCall
	// GetGroupCallDefaultJoinAs(ctx context.Context, userId int64, chatId int64) *mtproto.Peer
}
