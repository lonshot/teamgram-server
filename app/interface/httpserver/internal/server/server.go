package server

import (
	"flag"

	"pwm-server/app/interface/httpserver/internal/config"
	"pwm-server/app/interface/httpserver/internal/server/http"
	"pwm-server/app/interface/httpserver/internal/svc"

	"github.com/zeromicro/go-zero/core/conf"
	"github.com/zeromicro/go-zero/core/logx"
	"github.com/zeromicro/go-zero/rest"
)

var configFile = flag.String("f", "etc/httpserver.yaml", "the config file")

type Server struct {
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

	s.httpSrv = http.New(ctx, c)

	return nil
}

func (s *Server) RunLoop() {
}

func (s *Server) Destroy() {
}
