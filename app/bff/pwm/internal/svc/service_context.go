package svc

import (
	"pwm-server/app/bff/messages/plugin"
	"pwm-server/app/bff/pwm/internal/config"
	"pwm-server/app/bff/pwm/internal/dao"
)

type ServiceContext struct {
	Config config.Config
	*dao.Dao
	Plugin plugin.MessagesPlugin
}

func NewServiceContext(c config.Config) *ServiceContext {
	plugin := plugin.NewMessagesPlugin(c.MediaClient)
	return &ServiceContext{
		Config: c,
		Dao:    dao.New(c),
		Plugin: plugin,
	}
}
