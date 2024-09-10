package svc

import (
	"pwm-server/app/bff/savedmessagedialogs/internal/config"
	"pwm-server/app/bff/savedmessagedialogs/internal/dao"
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
