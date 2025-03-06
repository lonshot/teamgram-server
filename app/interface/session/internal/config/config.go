package config

import (
	"pwm-server/pkg/conf"

	"github.com/zeromicro/go-zero/zrpc"
)

type Config struct {
	zrpc.RpcServerConf
	AuthSession     zrpc.RpcClientConf
	StatusClient    zrpc.RpcClientConf
	GatewayClient   zrpc.RpcClientConf
	BFFProxyClients conf.BFFProxyClients
}

// Routine routine.
type Routine struct {
	Size uint64
	Chan uint64
}
