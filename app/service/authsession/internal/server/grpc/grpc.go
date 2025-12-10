package grpc

import (
	"pwm-server/app/service/authsession/authsession"
	"pwm-server/app/service/authsession/internal/server/grpc/service"
	"pwm-server/app/service/authsession/internal/svc"

	"github.com/zeromicro/go-zero/core/logx"
	"github.com/zeromicro/go-zero/zrpc"
	"google.golang.org/grpc"
)

// New new a grpc server.
func New(ctx *svc.ServiceContext, c zrpc.RpcServerConf) *zrpc.RpcServer {
	s, err := zrpc.NewServer(c, func(grpcServer *grpc.Server) {
		authsession.RegisterRPCAuthsessionServer(grpcServer, service.New(ctx))
	})
	logx.Must(err)
	return s
}
