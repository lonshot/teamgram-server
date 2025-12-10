package main

import (
	"github.com/teamgram/marmota/pkg/commands"

	"pwm-server/app/service/biz/chat/internal/server"
)

func main() {
	commands.Run(server.New())
}
