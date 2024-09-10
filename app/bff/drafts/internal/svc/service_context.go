package svc

import (
	"pwm-server/app/bff/drafts/internal/config"
	"pwm-server/app/bff/drafts/internal/dao"
	"pwm-server/app/bff/drafts/plugin"
)

type ServiceContext struct {
	Config config.Config
	*dao.Dao
	Plugin plugin.DraftsPlugin
}

func NewServiceContext(c config.Config, plugin plugin.DraftsPlugin) *ServiceContext {
	return &ServiceContext{
		Config: c,
		Dao:    dao.New(c),
		Plugin: plugin,
	}
}
