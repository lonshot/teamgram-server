package svc

import (
	"pwm-server/app/bff/files/internal/config"
	"pwm-server/app/bff/files/internal/dao"
	"pwm-server/app/bff/files/plugin"
)

type ServiceContext struct {
	Config config.Config
	*dao.Dao
	Plugin1 plugin.ThumbFilesPlugin
	Plugin2 plugin.StreamFilesPlugin
}

func NewServiceContext(c config.Config, plugin1 plugin.ThumbFilesPlugin, plugin2 plugin.StreamFilesPlugin) *ServiceContext {
	return &ServiceContext{
		Config:  c,
		Dao:     dao.New(c),
		Plugin1: plugin1,
		Plugin2: plugin2,
	}
}
