package svc

import (
	"pwm-server/app/bff/qrcode/internal/config"
	"pwm-server/app/bff/qrcode/internal/dao"
	"pwm-server/app/bff/qrcode/plugin"
)

type ServiceContext struct {
	Config config.Config
	*dao.Dao
	Plugin plugin.QrcodePlugin
}

func NewServiceContext(c config.Config, plugin plugin.QrcodePlugin) *ServiceContext {
	return &ServiceContext{
		Config: c,
		Dao:    dao.New(c),
		Plugin: plugin,
	}
}
