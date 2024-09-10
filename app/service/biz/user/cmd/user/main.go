package main

import (
	"github.com/teamgram/marmota/pkg/commands"

	"pwm-server/app/service/biz/user/internal/server"
)

func main() {
	commands.Run(server.New())
}
