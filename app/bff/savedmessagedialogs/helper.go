package savedmessagedialogshelper

import (
	"pwm-server/app/bff/savedmessagedialogs/internal/config"
	"pwm-server/app/bff/savedmessagedialogs/internal/server/grpc/service"
	"pwm-server/app/bff/savedmessagedialogs/internal/svc"
)

type (
	Config = config.Config
)

func New(c Config) *service.Service {
	return service.New(svc.NewServiceContext(c))
}
