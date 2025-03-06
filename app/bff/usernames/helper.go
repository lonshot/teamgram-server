package usernames_helper

import (
	"pwm-server/app/bff/usernames/internal/config"
	"pwm-server/app/bff/usernames/internal/server/grpc/service"
	"pwm-server/app/bff/usernames/internal/svc"
	"pwm-server/app/bff/usernames/plugin"
)

type (
	Config = config.Config
)

func New(c Config, plugin plugin.UsernamesPlugin) *service.Service {
	return service.New(svc.NewServiceContext(c, plugin))
}
