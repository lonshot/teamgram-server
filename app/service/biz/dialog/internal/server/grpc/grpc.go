package grpc

import (
	"pwm-server/app/service/biz/dialog/dialog"
	"pwm-server/app/service/biz/dialog/internal/server/grpc/service"
	"pwm-server/app/service/biz/dialog/internal/svc"

	"github.com/zeromicro/go-zero/core/logx"
	"github.com/zeromicro/go-zero/zrpc"
	"google.golang.org/grpc"
)

// New new a grpc server.
func New(ctx *svc.ServiceContext, c zrpc.RpcServerConf) *zrpc.RpcServer {
	s, err := zrpc.NewServer(c, func(grpcServer *grpc.Server) {
		dialog.RegisterRPCDialogServer(grpcServer, service.New(ctx))
	})
	logx.Must(err)
	return s
}
