package server

import (
	"flag"

	"pwm-server/app/bff/pwm/internal/config"
	"pwm-server/app/bff/pwm/internal/server/grpc"
	grpcservice "pwm-server/app/bff/pwm/internal/server/grpc/service"
	"pwm-server/app/bff/pwm/internal/svc"

	"github.com/zeromicro/go-zero/core/conf"
	"github.com/zeromicro/go-zero/core/logx"
	"github.com/zeromicro/go-zero/zrpc"
)

var configFile = flag.String("f", "etc/pwm.yaml", "the config file")

type Server struct {
	grpcSrv    *zrpc.RpcServer
	worker     *grpcservice.ReactionCommandWorker
	gameWorker *grpcservice.GameOutboxWorker
}

func New() *Server {
	return new(Server)
}

func (s *Server) Initialize() error {
	var c config.Config
	conf.MustLoad(*configFile, &c)

	logx.Infov(c)
	ctx := svc.NewServiceContext(c)
	reactions := grpcservice.New(ctx)
	s.worker = grpcservice.NewReactionCommandWorker(reactions)
	s.worker.Start()
	s.gameWorker = grpcservice.NewGameOutboxWorker(reactions)
	s.gameWorker.Start()
	s.grpcSrv = grpc.New(ctx, c.RpcServerConf, reactions)

	go func() {
		go s.grpcSrv.Start()
	}()
	return nil
}

func (s *Server) RunLoop() {
}

func (s *Server) Destroy() {
	s.grpcSrv.Stop()
	s.gameWorker.Stop()
	s.worker.Stop()
}
