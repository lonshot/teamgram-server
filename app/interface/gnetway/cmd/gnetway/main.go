package main

import (
	"github.com/teamgram/marmota/pkg/commands"
	"pwm-server/app/interface/gnetway"
)

func main() {
	commands.Run(new(gnetway_helper.Server))
}
