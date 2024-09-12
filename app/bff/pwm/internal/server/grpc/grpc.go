package grpc

import (
	"github.com/teamgram/proto/mtproto"
	"pwm-server/app/bff/pwm/internal/server/grpc/service"
	"pwm-server/app/bff/pwm/internal/svc"

	"github.com/zeromicro/go-zero/core/logx"
	"github.com/zeromicro/go-zero/zrpc"
	"google.golang.org/grpc"
)

// New new a grpc server.
func New(ctx *svc.ServiceContext, c zrpc.RpcServerConf) *zrpc.RpcServer {
	s, err := zrpc.NewServer(
		c, func(grpcServer *grpc.Server) {
			mtproto.RegisterRPCWallpapersServer(grpcServer, service.New(ctx))
			mtproto.RegisterRPCStickersServer(grpcServer, service.New(ctx))
			mtproto.RegisterRPCWebPageServer(grpcServer, service.New(ctx))
			mtproto.RegisterRPCEmojiServer(grpcServer, service.New(ctx))
			mtproto.RegisterRPCLangpackServer(grpcServer, service.New(ctx))

			mtproto.RegisterRPCGifsServer(grpcServer, service.New(ctx))
			mtproto.RegisterRPCReactionsServer(grpcServer, service.New(ctx))
			mtproto.RegisterRPCFoldersServer(grpcServer, service.New(ctx))
			mtproto.RegisterRPCThemesServer(grpcServer, service.New(ctx))
		},
	)
	logx.Must(err)
	return s
}
