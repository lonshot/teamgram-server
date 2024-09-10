package gnetway_helper

import (
	"pwm-server/app/interface/gnetway/internal/server"

	"github.com/zeromicro/go-zero/zrpc"
)

func init() {
	zrpc.DontLogContentForMethod("/gateway.RPCGateway/gateway_sendDataToGateway")

	zrpc.DontLogClientContentForMethod("/session.RPCSession/session_sendDataToSession")
}

type (
	Server = server.Server
)
