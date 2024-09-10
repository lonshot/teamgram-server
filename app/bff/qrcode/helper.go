package qrcode_helper

import (
	"pwm-server/app/bff/qrcode/internal/config"
	"pwm-server/app/bff/qrcode/internal/server/grpc/service"
	"pwm-server/app/bff/qrcode/internal/svc"
	"pwm-server/app/bff/qrcode/plugin"
)

type (
	Config = config.Config
)

func New(c Config, plugin plugin.QrcodePlugin) *service.Service {
	return service.New(svc.NewServiceContext(c, plugin))
}
