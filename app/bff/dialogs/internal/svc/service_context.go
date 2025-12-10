package svc

import (
	"pwm-server/app/bff/dialogs/internal/config"
	"pwm-server/app/bff/dialogs/internal/dao"
	"pwm-server/app/bff/dialogs/plugin"
)

type ServiceContext struct {
	Config config.Config
	*dao.Dao
	Plugin plugin.DialogsPlugin
}

func NewServiceContext(c config.Config, plugin plugin.DialogsPlugin) *ServiceContext {
	return &ServiceContext{
		Config: c,
		Dao:    dao.New(c),
		Plugin: plugin,
	}
}
