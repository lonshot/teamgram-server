package svc

import (
	"pwm-server/app/bff/users/internal/config"
	"pwm-server/app/bff/users/internal/dao"
	"pwm-server/app/bff/users/internal/plugin"
)

type ServiceContext struct {
	Config config.Config
	*dao.Dao
}

func NewServiceContext(c config.Config, plugin plugin.StoryPlugin) *ServiceContext {
	return &ServiceContext{
		Config: c,
		Dao:    dao.New(c, plugin),
	}
}
