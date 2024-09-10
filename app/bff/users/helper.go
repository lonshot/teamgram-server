package users_helper

import (
	"pwm-server/app/bff/users/internal/config"
	"pwm-server/app/bff/users/internal/plugin"
	"pwm-server/app/bff/users/internal/server/grpc/service"
	"pwm-server/app/bff/users/internal/svc"
)

type (
	Config = config.Config
)

func New(c Config, plugin plugin.StoryPlugin) *service.Service {
	return service.New(svc.NewServiceContext(c, plugin))
}
