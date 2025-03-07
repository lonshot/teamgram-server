package core

import (
	"context"

	"github.com/teamgram/proto/mtproto/rpc/metadata"
	"pwm-server/app/service/status/internal/svc"

	"github.com/zeromicro/go-zero/core/logx"
)

type StatusCore struct {
	ctx    context.Context
	svcCtx *svc.ServiceContext
	logx.Logger
	MD *metadata.RpcMetadata
}

func New(ctx context.Context, svcCtx *svc.ServiceContext) *StatusCore {
	return &StatusCore{
		ctx:    ctx,
		svcCtx: svcCtx,
		Logger: logx.WithContext(ctx),
		MD:     metadata.RpcMetadataFromIncoming(ctx),
	}
}
