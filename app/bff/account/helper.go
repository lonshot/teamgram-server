package account_helper

import (
	"pwm-server/app/bff/account/internal/config"
	"pwm-server/app/bff/account/internal/server/grpc/service"
	"pwm-server/app/bff/account/internal/svc"
)

type (
	Config = config.Config
)

func New(c Config) *service.Service {
	return service.New(svc.NewServiceContext(c))
}
