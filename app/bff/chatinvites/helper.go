package chatinvites_helper

import (
	"pwm-server/app/bff/chatinvites/internal/config"
	"pwm-server/app/bff/chatinvites/internal/server/grpc/service"
	"pwm-server/app/bff/chatinvites/internal/svc"
)

type (
	Config = config.Config
)

func New(c Config) *service.Service {
	return service.New(svc.NewServiceContext(c))
}
