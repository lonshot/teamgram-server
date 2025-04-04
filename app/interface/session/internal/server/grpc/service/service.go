package service

import (
	"context"
	"strconv"

	"github.com/teamgram/proto/mtproto"
	"pwm-server/app/interface/session/internal/svc"

	"github.com/zeromicro/go-zero/core/logx"
)

type Service struct {
	svcCtx *svc.ServiceContext
}

func (s *Service) GetServiceContext() *svc.ServiceContext {
	return s.svcCtx
}

func New(ctx *svc.ServiceContext) *Service {
	return &Service{
		svcCtx: ctx,
	}
}

func (s *Service) checkShardingV(ctx context.Context, authId int64) (err error) {
	server, ok := s.svcCtx.RpcShardingManager.GetShardingV(strconv.FormatInt(authId, 10))

	if !ok {
		logx.WithContext(ctx).Errorf("not found shardingV by authId: %d", authId)
		err = mtproto.ErrInternalServerError
	} else {
		if server != s.svcCtx.Dao.MyServerId {
			logx.WithContext(ctx).Errorf("authId(%d), redirect to server: %d", authId, server)
			err = mtproto.NewErrRedirectToX(server)
		}
	}

	return
}
