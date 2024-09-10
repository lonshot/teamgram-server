package messages_helper

import (
	"pwm-server/app/bff/messages/internal/config"
	"pwm-server/app/bff/messages/internal/server/grpc/service"
	"pwm-server/app/bff/messages/internal/svc"
	"pwm-server/app/bff/messages/plugin"
)

type (
	Config = config.Config
)

func New(c Config, plugin plugin.MessagesPlugin) *service.Service {
	return service.New(svc.NewServiceContext(c, plugin))
}
