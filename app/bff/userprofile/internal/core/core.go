package core

import (
	"context"

	"github.com/teamgram/proto/mtproto/rpc/metadata"
	"pwm-server/app/bff/userprofile/internal/svc"

	"github.com/zeromicro/go-zero/core/logx"
)

type UserProfileCore struct {
	ctx    context.Context
	svcCtx *svc.ServiceContext
	logx.Logger
	MD *metadata.RpcMetadata
}

func New(ctx context.Context, svcCtx *svc.ServiceContext) *UserProfileCore {
	return &UserProfileCore{
		ctx:    ctx,
		svcCtx: svcCtx,
		Logger: logx.WithContext(ctx),
		MD:     metadata.RpcMetadataFromIncoming(ctx),
	}
}
