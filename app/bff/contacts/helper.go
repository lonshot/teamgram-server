/*
 * WARNING! All changes made in this file will be lost!
 * Created from 'scheme.tl' by 'mtprotoc'
 *
 * Copyright 2022 Teamgram Authors.
 *  All rights reserved.
 *
 * Author: teamgramio (teamgram.io@gmail.com)
 */

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
