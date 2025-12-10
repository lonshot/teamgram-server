package main

import (
	"github.com/teamgram/marmota/pkg/commands"
	gateway_helper "pwm-server/app/interface/gateway"
)

func main() {
	commands.Run(new(gateway_helper.Server))
}
