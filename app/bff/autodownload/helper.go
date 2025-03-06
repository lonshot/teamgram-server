package autodownload_helper

import (
	"pwm-server/app/bff/autodownload/internal/config"
	"pwm-server/app/bff/autodownload/internal/server/grpc/service"
	"pwm-server/app/bff/autodownload/internal/svc"
)

type (
	Config = config.Config
)

func New(c Config) *service.Service {
	return service.New(svc.NewServiceContext(c))
}
