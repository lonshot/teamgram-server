package grpc

import (
	"pwm-server/app/interface/gateway/gateway"
	"pwm-server/app/interface/gateway/internal/server"

	"github.com/zeromicro/go-zero/core/logx"
	"github.com/zeromicro/go-zero/zrpc"
	"google.golang.org/grpc"
)

// New new a grpc server.
func New(c zrpc.RpcServerConf, server *server.Server) *zrpc.RpcServer {
	s, err := zrpc.NewServer(c, func(grpcServer *grpc.Server) {
		gateway.RegisterRPCGatewayServer(grpcServer, server)
	})
	logx.Must(err)
	return s
}
