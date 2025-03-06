package svc

import (
	"pwm-server/app/messenger/sync/internal/config"
	"pwm-server/app/messenger/sync/internal/dao"
)

type ServiceContext struct {
	Config config.Config
	*dao.Dao
}

func NewServiceContext(c config.Config) *ServiceContext {
	return &ServiceContext{
		Config: c,
		Dao:    dao.New(c),
	}
}
