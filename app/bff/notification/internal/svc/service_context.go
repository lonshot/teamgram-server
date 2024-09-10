package svc

import (
	"pwm-server/app/bff/notification/internal/config"
	"pwm-server/app/bff/notification/internal/dao"
	"pwm-server/app/bff/notification/plugin"
)

type ServiceContext struct {
	Config config.Config
	*dao.Dao
	Plugin plugin.NotificationPlugin
}

func NewServiceContext(c config.Config, plugin plugin.NotificationPlugin) *ServiceContext {
	return &ServiceContext{
		Config: c,
		Dao:    dao.New(c),
		Plugin: plugin,
	}
}
