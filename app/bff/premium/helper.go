package premium_helper

import (
	"pwm-server/app/bff/premium/internal/config"
	"pwm-server/app/bff/premium/internal/server/grpc/service"
	"pwm-server/app/bff/premium/internal/svc"
)

type (
	Config = config.Config
)

func New(c Config) *service.Service {
	return service.New(svc.NewServiceContext(c))
}
