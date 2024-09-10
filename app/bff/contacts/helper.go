package contacts_helper

import (
	"pwm-server/app/bff/contacts/internal/config"
	"pwm-server/app/bff/contacts/internal/server/grpc/service"
	"pwm-server/app/bff/contacts/internal/svc"
	"pwm-server/app/bff/contacts/plugin"
)

type (
	Config = config.Config
)

func New(c Config, plugin plugin.ContactsPlugin) *service.Service {
	return service.New(svc.NewServiceContext(c, plugin))
}
