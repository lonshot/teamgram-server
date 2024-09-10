package main

import (
	"github.com/teamgram/marmota/pkg/commands"

	"pwm-server/app/service/status/internal/server"
)

func main() {
	commands.Run(server.New())
}
