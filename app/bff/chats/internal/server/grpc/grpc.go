package grpc

import (
	"github.com/teamgram/proto/mtproto"
	"pwm-server/app/bff/chats/internal/server/grpc/service"
	"pwm-server/app/bff/chats/internal/svc"

	"github.com/zeromicro/go-zero/core/logx"
	"github.com/zeromicro/go-zero/zrpc"
	"google.golang.org/grpc"
)

// New new a grpc server.
func New(ctx *svc.ServiceContext, c zrpc.RpcServerConf) *zrpc.RpcServer {
	s, err := zrpc.NewServer(c, func(grpcServer *grpc.Server) {
		mtproto.RegisterRPCChatsServer(grpcServer, service.New(ctx))
	})
	logx.Must(err)
	return s
}
