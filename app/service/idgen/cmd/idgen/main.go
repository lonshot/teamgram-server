package main

import (
	"github.com/teamgram/marmota/pkg/commands"

	"pwm-server/app/service/idgen/internal/server"
)

func main() {
	commands.Run(server.New())
}
