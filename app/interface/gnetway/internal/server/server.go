package server

import (
	"flag"

	"pwm-server/app/interface/gnetway/internal/config"
	"pwm-server/app/interface/gnetway/internal/server/gnet"
	"pwm-server/app/interface/gnetway/internal/server/grpc"
	"pwm-server/app/interface/gnetway/internal/svc"

	"github.com/zeromicro/go-zero/core/conf"
	"github.com/zeromicro/go-zero/core/logx"
	"github.com/zeromicro/go-zero/zrpc"
)

var (
	configFile = flag.String("f", "etc/gateway.yaml", "the config file")
)

type Server struct {
	grpcSrv *zrpc.RpcServer
	server  *gnet.Server
}

func (s *Server) Initialize() error {
	var c config.Config
	conf.MustLoad(*configFile, &c)

	logx.Infov(c)

	ctx := svc.NewServiceContext(c)
	s.server = gnet.New(ctx, c)
	s.grpcSrv = grpc.New(ctx, c.RpcServerConf, s.server)

	go func() {
		s.grpcSrv.Start()
	}()

	return nil
}

func (s *Server) RunLoop() {
	// s.server.Serve()
	//if err := s.server.Serve(); err != nil {
	//	logx.Errorf("run server error: %v, quit...", err)
	//	commands.GSignal <- syscall.SIGQUIT
	//}
}

func (s *Server) Destroy() {
	s.grpcSrv.Stop()
	s.server.Close()
}
