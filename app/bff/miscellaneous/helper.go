package miscellaneous_helper

import (
	"pwm-server/app/bff/miscellaneous/internal/config"
	"pwm-server/app/bff/miscellaneous/internal/server/grpc/service"
	"pwm-server/app/bff/miscellaneous/internal/svc"
)

type (
	Config = config.Config
)

func New(c Config) *service.Service {
	return service.New(svc.NewServiceContext(c))
}
