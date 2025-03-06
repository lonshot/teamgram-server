package chats_helper

import (
	"pwm-server/app/bff/chats/internal/config"
	"pwm-server/app/bff/chats/internal/server/grpc/service"
	"pwm-server/app/bff/chats/internal/svc"
)

type (
	Config = config.Config
)

func New(c Config) *service.Service {
	return service.New(svc.NewServiceContext(c))
}
