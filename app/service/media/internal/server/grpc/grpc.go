package grpc

import (
	"pwm-server/app/service/media/internal/server/grpc/service"
	"pwm-server/app/service/media/internal/svc"
	"pwm-server/app/service/media/media"

	"github.com/zeromicro/go-zero/core/logx"
	"github.com/zeromicro/go-zero/zrpc"
	"google.golang.org/grpc"
)

// New new a grpc server.
func New(ctx *svc.ServiceContext, c zrpc.RpcServerConf) *zrpc.RpcServer {
	s, err := zrpc.NewServer(c, func(grpcServer *grpc.Server) {
		media.RegisterRPCMediaServer(grpcServer, service.New(ctx))
	})
	logx.Must(err)
	return s
}
