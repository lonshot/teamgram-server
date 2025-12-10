package configuration_helper

import (
	"pwm-server/app/bff/configuration/internal/config"
	"pwm-server/app/bff/configuration/internal/server/grpc/service"
	"pwm-server/app/bff/configuration/internal/svc"
)

type (
	Config = config.Config
)

func New(c Config) *service.Service {
	return service.New(svc.NewServiceContext(c))
}
