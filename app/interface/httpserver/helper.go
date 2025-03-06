package httpserverhelper

import (
	"pwm-server/app/interface/httpserver/internal/server"
	"github.com/zeromicro/go-zero/zrpc"
)

func init() {
	zrpc.DontLogClientContentForMethod("/session.RPCSession/session_sendHttpDataToSession")
}

type (
	Server = server.Server
)
