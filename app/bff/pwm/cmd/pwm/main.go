package main

import (
	"github.com/teamgram/marmota/pkg/commands"

	"pwm-server/app/bff/pwm/internal/server"
)

func main() {
	commands.Run(server.New())
}