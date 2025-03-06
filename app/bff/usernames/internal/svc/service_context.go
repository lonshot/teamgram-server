package svc

import (
	"pwm-server/app/bff/usernames/internal/config"
	"pwm-server/app/bff/usernames/internal/dao"
	"pwm-server/app/bff/usernames/plugin"
)

type ServiceContext struct {
	Config config.Config
	*dao.Dao
	Plugin plugin.UsernamesPlugin
}

func NewServiceContext(c config.Config, plugin plugin.UsernamesPlugin) *ServiceContext {
	return &ServiceContext{
		Config: c,
		Dao:    dao.New(c),
		Plugin: plugin,
	}
}
