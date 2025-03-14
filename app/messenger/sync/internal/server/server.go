package server

import (
	"flag"

	kafka "github.com/teamgram/marmota/pkg/mq"
	"pwm-server/app/messenger/sync/internal/config"
	"pwm-server/app/messenger/sync/internal/server/mq"
	"pwm-server/app/messenger/sync/internal/svc"

	"github.com/zeromicro/go-zero/core/conf"
	"github.com/zeromicro/go-zero/core/logx"
)

var configFile = flag.String("f", "etc/sync.yaml", "the config file")

type Server struct {
	// grpcSrv *zrpc.RpcServer
	mq *kafka.ConsumerGroup
}

func New() *Server {
	return new(Server)
}

func (s *Server) Initialize() error {
	var c config.Config
	conf.MustLoad(*configFile, &c)
	logx.Infov(c)

	if err := logx.SetUp(c.Log); err != nil {
		return err
	}

	ctx := svc.NewServiceContext(c)
	// s.grpcSrv = grpc.New(ctx, c.RpcServerConf)
	s.mq = mq.New(ctx, c.SyncConsumer)

	// go s.grpcSrv.Start()
	go s.mq.Start()

	return nil
}

func (s *Server) RunLoop() {
}

func (s *Server) Destroy() {
	// s.grpcSrv.Stop()
	s.mq.Stop()
}
