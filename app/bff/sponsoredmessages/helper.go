package sponsoredmessages_helper

import (
	"pwm-server/app/bff/sponsoredmessages/internal/config"
	"pwm-server/app/bff/sponsoredmessages/internal/server/grpc/service"
	"pwm-server/app/bff/sponsoredmessages/internal/svc"
)

type (
	Config = config.Config
)

func New(c Config) *service.Service {
	return service.New(svc.NewServiceContext(c))
}
