package updates_helper

import (
	"pwm-server/app/bff/updates/internal/config"
	"pwm-server/app/bff/updates/internal/server/grpc/service"
	"pwm-server/app/bff/updates/internal/svc"
)

type (
	Config = config.Config
)

func New(c Config) *service.Service {
	return service.New(svc.NewServiceContext(c))
}
