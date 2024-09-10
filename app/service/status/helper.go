package status_helper

import (
	"pwm-server/app/service/status/internal/config"
	"pwm-server/app/service/status/internal/server/grpc/service"
	"pwm-server/app/service/status/internal/svc"
)

type (
	Config         = config.Config
	ServiceContext = svc.ServiceContext
)

var (
	New               = service.New
	NewServiceContext = svc.NewServiceContext
)
