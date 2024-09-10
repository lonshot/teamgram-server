package main

import (
	"github.com/teamgram/marmota/pkg/commands"
	"pwm-server/app/interface/session/internal/server"
)

func main() {
	commands.Run(server.New())
}
