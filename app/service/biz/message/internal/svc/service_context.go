package svc

import (
	"pwm-server/app/service/biz/message/internal/config"
	"pwm-server/app/service/biz/message/internal/dao"
	"pwm-server/app/service/biz/message/internal/plugin"
)

type ServiceContext struct {
	Config config.Config
	*dao.Dao
}

func NewServiceContext(c config.Config, plugin plugin.MessagePlugin) *ServiceContext {
	return &ServiceContext{
		Config: c,
		Dao:    dao.New(c, plugin),
	}
}
