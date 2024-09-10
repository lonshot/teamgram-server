package authorization_helper

import (
	"pwm-server/app/bff/authorization/internal/config"
	"pwm-server/app/bff/authorization/internal/server/grpc/service"
	"pwm-server/app/bff/authorization/internal/svc"
	"pwm-server/app/bff/authorization/plugin"
	"pwm-server/pkg/code"
)

type (
	Config               = config.Config
	AuthorizationService = service.Service
)

func New(c Config, code2 code.VerifyCodeInterface, plugin plugin.AuthorizationPlugin) *service.Service {
	return service.New(svc.NewServiceContext(c, code2, plugin))
}
