package notification_helper

import (
	"pwm-server/app/bff/notification/internal/config"
	"pwm-server/app/bff/notification/internal/server/grpc/service"
	"pwm-server/app/bff/notification/internal/svc"
	"pwm-server/app/bff/notification/plugin"
)

type (
	Config = config.Config
)

func New(c Config, plugin plugin.NotificationPlugin) *service.Service {
	return service.New(svc.NewServiceContext(c, plugin))
}
