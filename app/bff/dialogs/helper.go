package dialogs_helper

import (
	"pwm-server/app/bff/dialogs/internal/config"
	"pwm-server/app/bff/dialogs/internal/server/grpc/service"
	"pwm-server/app/bff/dialogs/internal/svc"
	"pwm-server/app/bff/dialogs/plugin"
)

type (
	Config = config.Config
)

func New(c Config, plugin plugin.DialogsPlugin) *service.Service {
	return service.New(svc.NewServiceContext(c, plugin))
}
