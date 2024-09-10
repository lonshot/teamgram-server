package main

import (
	"github.com/teamgram/marmota/pkg/commands"

	"pwm-server/app/service/media/internal/server"
)

func main() {
	commands.Run(server.New())
}
