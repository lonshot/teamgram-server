package svc

import (
	"pwm-server/app/bff/authorization/internal/config"
	"pwm-server/app/bff/authorization/internal/dao"
	"pwm-server/app/bff/authorization/internal/logic"
	"pwm-server/app/bff/authorization/plugin"
	"pwm-server/pkg/code"
)

type ServiceContext struct {
	Config config.Config
	*dao.Dao
	*logic.AuthLogic
	Plugin plugin.AuthorizationPlugin
}

func NewServiceContext(c config.Config, code2 code.VerifyCodeInterface, plugin plugin.AuthorizationPlugin) *ServiceContext {
	d := dao.New(c)
	if code2 == nil {
		code2 = code.NewVerifyCode(c.Code)
	}
	return &ServiceContext{
		Config:    c,
		Dao:       d,
		AuthLogic: logic.NewAuthSignLogic(d, code2),
		Plugin:    plugin,
	}
}
