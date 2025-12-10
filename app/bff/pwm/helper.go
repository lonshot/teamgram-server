package pwm_helper

import (
	"pwm-server/app/bff/pwm/internal/config"
	"pwm-server/app/bff/pwm/internal/server/grpc/service"
	"pwm-server/app/bff/pwm/internal/svc"
)

type (
	Config = config.Config
)

func New(c Config) *service.Service {
	return service.New(svc.NewServiceContext(c))
}
