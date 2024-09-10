package svc

import (
	"pwm-server/app/bff/messages/internal/config"
	"pwm-server/app/bff/messages/internal/dao"
	"pwm-server/app/bff/messages/plugin"
)

type ServiceContext struct {
	Config config.Config
	*dao.Dao
	Plugin plugin.MessagesPlugin
}

func NewServiceContext(c config.Config, plugin plugin.MessagesPlugin) *ServiceContext {
	return &ServiceContext{
		Config: c,
		Dao:    dao.New(c),
		Plugin: plugin,
	}
}
