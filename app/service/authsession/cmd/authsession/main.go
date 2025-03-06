package main

import (
	"github.com/teamgram/marmota/pkg/commands"

	"pwm-server/app/service/authsession/internal/server"
)

func main() {
	commands.Run(server.New())
}
