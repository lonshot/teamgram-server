package core

import (
	"context"

	"github.com/teamgram/proto/mtproto/rpc/metadata"
	"pwm-server/app/service/biz/code/internal/svc"

	"github.com/zeromicro/go-zero/core/logx"
)

type CodeCore struct {
	ctx    context.Context
	svcCtx *svc.ServiceContext
	logx.Logger
	MD *metadata.RpcMetadata
}

func New(ctx context.Context, svcCtx *svc.ServiceContext) *CodeCore {
	return &CodeCore{
		ctx:    ctx,
		svcCtx: svcCtx,
		Logger: logx.WithContext(ctx),
		MD:     metadata.RpcMetadataFromIncoming(ctx),
	}
}
