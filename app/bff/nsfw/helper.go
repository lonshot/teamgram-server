package nsfw_helper

import (
	"pwm-server/app/bff/nsfw/internal/config"
	"pwm-server/app/bff/nsfw/internal/server/grpc/service"
	"pwm-server/app/bff/nsfw/internal/svc"
)

type (
	Config = config.Config
)

func New(c Config) *service.Service {
	return service.New(svc.NewServiceContext(c))
}
