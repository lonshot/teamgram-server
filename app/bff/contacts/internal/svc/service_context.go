package svc

import (
	"pwm-server/app/bff/contacts/internal/config"
	"pwm-server/app/bff/contacts/internal/dao"
	"pwm-server/app/bff/contacts/plugin"
)

type ServiceContext struct {
	Config config.Config
	*dao.Dao
	Plugin plugin.ContactsPlugin
}

func NewServiceContext(c config.Config, plugin plugin.ContactsPlugin) *ServiceContext {
	return &ServiceContext{
		Config: c,
		Dao:    dao.New(c),
		Plugin: plugin,
	}
}
