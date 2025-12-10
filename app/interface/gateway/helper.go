package gateway_helper

import (
	"pwm-server/app/interface/gateway/internal/server/server"
	"github.com/zeromicro/go-zero/zrpc"
)

func init() {
	zrpc.DontLogContentForMethod("/gateway.RPCGateway/gateway_sendDataToGateway")

	zrpc.DontLogClientContentForMethod("/session.RPCSession/session_sendDataToSession")
}

type (
	Server = server.Server
)
