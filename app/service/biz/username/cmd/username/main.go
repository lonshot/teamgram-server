/*
 * WARNING! All changes made in this file will be lost!
 * Created from 'scheme.tl' by 'mtprotoc'
 *
 * Copyright (c) 2021-present,  Teamgram Studio (https://teamgram.io).
 *  All rights reserved.
 *
 * Author: teamgramio (teamgram.io@gmail.com)
 */

package main

import (
	"github.com/teamgram/marmota/pkg/commands"

	"pwm-server/app/service/biz/username/internal/server"
)

func main() {
	commands.Run(server.New())
}
