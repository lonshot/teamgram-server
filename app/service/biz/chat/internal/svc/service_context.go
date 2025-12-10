package svc

import (
	"pwm-server/app/service/biz/chat/internal/config"
	"pwm-server/app/service/biz/chat/internal/dao"
	"pwm-server/app/service/biz/chat/plugin"
)

type ServiceContext struct {
	Config config.Config
	*dao.Dao
}

func NewServiceContext(c config.Config, plugin plugin.ChatPlugin) *ServiceContext {
	return &ServiceContext{
		Config: c,
		Dao:    dao.New(c, plugin),
	}
}
