package grpc

import (
	"pwm-server/app/interface/session/internal/server/grpc/service"
	"pwm-server/app/interface/session/internal/svc"
	"pwm-server/app/interface/session/session"

	"github.com/zeromicro/go-zero/core/logx"
	"github.com/zeromicro/go-zero/zrpc"
	"google.golang.org/grpc"
)

// New new a grpc server.
func New(ctx *svc.ServiceContext, c zrpc.RpcServerConf) *zrpc.RpcServer {
	s, err := zrpc.NewServer(c, func(grpcServer *grpc.Server) {
		session.RegisterRPCSessionServer(grpcServer, service.New(ctx))
	})
	logx.Must(err)
	return s
}
