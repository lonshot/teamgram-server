/*
 * WARNING! All changes made in this file will be lost!
 * Created from 'scheme.tl' by 'mtprotoc'
 *
 * Copyright (c) 2021-present,  Teamgram Studio (https://teamgram.io).
 *  All rights reserved.
 *
 * Author: teamgramio (teamgram.io@gmail.com)
 */

package msg_helper

import (
	"pwm-server/app/messenger/msg/msg/internal/config"
	"pwm-server/app/messenger/msg/msg/internal/server/grpc/service"
	"pwm-server/app/messenger/msg/msg/internal/svc"
	"pwm-server/app/messenger/msg/msg/plugin"
)

type (
	Config = config.Config
)

func New(c Config, plugin plugin.MsgPlugin) *service.Service {
	return service.New(svc.NewServiceContext(c, plugin))
}
