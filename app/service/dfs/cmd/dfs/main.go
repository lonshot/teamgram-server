package main

import (
	"github.com/teamgram/marmota/pkg/commands"
	"pwm-server/app/service/dfs/internal/server"
)

func main() {
	commands.Run(server.New())
}
