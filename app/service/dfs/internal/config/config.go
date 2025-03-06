package config

import (
	"pwm-server/app/service/dfs/internal/minio_util"
	"github.com/zeromicro/go-zero/core/stores/kv"
	"github.com/zeromicro/go-zero/rest"

	"github.com/zeromicro/go-zero/zrpc"
)

type Config struct {
	zrpc.RpcServerConf
	MiniHttp rest.RestConf
	Minio    minio_util.MinioConfig
	IdGen    zrpc.RpcClientConf
	SSDB     kv.KvConf
}
