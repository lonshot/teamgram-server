package config

import (
	"github.com/teamgram/marmota/pkg/stores/sqlx"
	"github.com/zeromicro/go-zero/zrpc"
)

type Config struct {
	zrpc.RpcServerConf
	Mysql sqlx.Config
	//Cache       cache.CacheConf
	//Dfs         zrpc.RpcClientConf
	MediaClient zrpc.RpcClientConf
}