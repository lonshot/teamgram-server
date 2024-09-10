package grpc

import (
	"pwm-server/app/messenger/msg/msg/internal/server/grpc/service"
	"pwm-server/app/messenger/msg/msg/internal/svc"
	msgpb "pwm-server/app/messenger/msg/msg/msg"
	"github.com/zeromicro/go-zero/core/logx"
	"github.com/zeromicro/go-zero/zrpc"
	"google.golang.org/grpc"
)

// New new a grpc server.
func New(ctx *svc.ServiceContext, c zrpc.RpcServerConf) *zrpc.RpcServer {
	s, err := zrpc.NewServer(c, func(grpcServer *grpc.Server) {
		msgpb.RegisterRPCMsgServer(grpcServer, service.New(ctx))
	})
	logx.Must(err)
	return s
}
