package drafts_helper

import (
	"pwm-server/app/bff/drafts/internal/config"
	"pwm-server/app/bff/drafts/internal/server/grpc/service"
	"pwm-server/app/bff/drafts/internal/svc"
	"pwm-server/app/bff/drafts/plugin"
)

type (
	Config = config.Config
)

func New(c Config, plugin plugin.DraftsPlugin) *service.Service {
	return service.New(svc.NewServiceContext(c, plugin))
}
