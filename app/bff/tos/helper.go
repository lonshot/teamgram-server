package tos_helper

import (
	"pwm-server/app/bff/tos/internal/config"
	"pwm-server/app/bff/tos/internal/server/grpc/service"
	"pwm-server/app/bff/tos/internal/svc"
)

type (
	Config = config.Config
)

func New(c Config) *service.Service {
	return service.New(svc.NewServiceContext(c))
}
