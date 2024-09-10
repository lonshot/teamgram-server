package core

import (
	"context"
	"github.com/teamgram/proto/mtproto/rpc/metadata"
	"pwm-server/app/service/biz/message/internal/svc"
	"github.com/zeromicro/go-zero/core/logx"
)

type MessageCore struct {
	ctx context.Context
	logx.Logger
	svcCtx *svc.ServiceContext
	MD     *metadata.RpcMetadata
}

func New(ctx context.Context, svcCtx *svc.ServiceContext) *MessageCore {
	return &MessageCore{
		ctx:    ctx,
		svcCtx: svcCtx,
		Logger: logx.WithContext(ctx),
		MD:     metadata.RpcMetadataFromIncoming(ctx),
	}
}
