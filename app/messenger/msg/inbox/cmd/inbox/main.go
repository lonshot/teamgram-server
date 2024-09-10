package main

import (
	"github.com/teamgram/marmota/pkg/commands"

	"pwm-server/app/messenger/msg/inbox/internal/server"
)

func main() {
	commands.Run(server.New())
}
