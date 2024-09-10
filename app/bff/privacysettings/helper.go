package privacysettingshelper

import (
	"pwm-server/app/bff/privacysettings/internal/config"
	"pwm-server/app/bff/privacysettings/internal/server/grpc/service"
	"pwm-server/app/bff/privacysettings/internal/svc"
)

type (
	Config = config.Config
)

func New(c Config) *service.Service {
	return service.New(svc.NewServiceContext(c))
}
