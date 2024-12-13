package config

import (
	"github.com/zeromicro/go-zero/core/stores/kv"
	"github.com/zeromicro/go-zero/rest"
	"github.com/zeromicro/go-zero/zrpc"
)

type Config struct {
	Http              rest.RestConf
	Session           zrpc.RpcClientConf
	MsgClient         zrpc.RpcClientConf
	KV                kv.KvConf
	KeyFile           string
	KeyFingerprint    string
	SecureAPIKey      string
	VerifySameNetwork bool
}
