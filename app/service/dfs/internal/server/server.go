package server

import (
	"flag"
	"pwm-server/app/service/dfs/internal/server/http"
	"github.com/zeromicro/go-zero/rest"

	"pwm-server/app/service/dfs/internal/config"
	"pwm-server/app/service/dfs/internal/server/grpc"
	"pwm-server/app/service/dfs/internal/svc"

	"github.com/zeromicro/go-zero/core/conf"
	"github.com/zeromicro/go-zero/core/logx"
	"github.com/zeromicro/go-zero/zrpc"
)

var configFile = flag.String("f", "etc/dfs.yaml", "the config file")

type Server struct {
	grpcSrv *zrpc.RpcServer
	httpSrv *rest.Server
}

func New() *Server {
	return new(Server)
}

func (s *Server) Initialize() error {
	var c config.Config
	conf.MustLoad(*configFile, &c)

	logx.Infov(c)
	ctx := svc.NewServiceContext(c)

	s.grpcSrv = grpc.New(ctx, c.RpcServerConf)
	go func() {
		s.grpcSrv.Start()
	}()

	s.httpSrv = http.New(ctx, c.MiniHttp)

	return nil
}

func (s *Server) RunLoop() {
}

func (s *Server) Destroy() {
	s.grpcSrv.Stop()
}
