package config

import (
	"github.com/teamgram/marmota/pkg/net2"
	"github.com/zeromicro/go-zero/zrpc"
)

type Config struct {
	zrpc.RpcServerConf
	MaxProc        int
	KeyFile        string
	KeyFingerprint string
	Server         *net2.TcpServerConfig
	Session        zrpc.RpcClientConf
}
