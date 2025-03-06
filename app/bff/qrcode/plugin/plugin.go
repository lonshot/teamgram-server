package plugin

import (
	"context"
)

type QrcodePlugin interface {
	CheckSessionPasswordNeeded(ctx context.Context, userId int64) bool
}
