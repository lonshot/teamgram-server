package session_helper

import (
	"pwm-server/app/interface/session/internal/server"

	"github.com/zeromicro/go-zero/zrpc"
)

func init() {
	zrpc.DontLogContentForMethod("/session.RPCSession/session_sendDataToSession")

	zrpc.DontLogClientContentForMethod("/gateway.RPCGateway/gateway_sendDataToGateway")
	zrpc.DontLogClientContentForMethod("/mtproto.RPCFiles/upload_saveFilePart")
	zrpc.DontLogClientContentForMethod("/mtproto.RPCFiles/upload_saveBigFilePart")
	zrpc.DontLogClientContentForMethod("/mtproto.RPCFiles/upload_getFile")
}

var (
	New = server.New
)
