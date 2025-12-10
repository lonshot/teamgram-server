package svc

import (
	"pwm-server/app/bff/nsfw/internal/config"
	"pwm-server/app/bff/nsfw/internal/dao"
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
