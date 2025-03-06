package core

import (
	"context"

	"github.com/teamgram/proto/mtproto/rpc/metadata"
	"pwm-server/app/bff/dialogs/internal/svc"
	"github.com/zeromicro/go-zero/core/logx"
)

type DialogsCore struct {
	ctx    context.Context
	svcCtx *svc.ServiceContext
	logx.Logger
	MD *metadata.RpcMetadata
}

func New(ctx context.Context, svcCtx *svc.ServiceContext) *DialogsCore {
	return &DialogsCore{
		ctx:    ctx,
		svcCtx: svcCtx,
		Logger: logx.WithContext(ctx),
		MD:     metadata.RpcMetadataFromIncoming(ctx),
	}
}
