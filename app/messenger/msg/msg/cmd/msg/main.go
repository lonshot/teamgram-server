package main

import (
	"github.com/teamgram/marmota/pkg/commands"

	"pwm-server/app/messenger/msg/msg/internal/server"
)

func main() {
	commands.Run(server.New())
}
