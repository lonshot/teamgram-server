package config

import (
	kafka "github.com/teamgram/marmota/pkg/mq"
	"github.com/teamgram/marmota/pkg/stores/sqlx"
	"github.com/zeromicro/go-zero/core/stores/cache"
	"github.com/zeromicro/go-zero/zrpc"
)

type Config struct {
	zrpc.RpcServerConf
	Mysql             sqlx.Config
	Cache             cache.CacheConf
	MediaClient       zrpc.RpcClientConf
	UserClient        zrpc.RpcClientConf
	ChatClient        zrpc.RpcClientConf
	MsgClient         zrpc.RpcClientConf
	DialogClient      zrpc.RpcClientConf
	SyncClient        *kafka.KafkaProducerConf
	AuthsessionClient zrpc.RpcClientConf
	IdgenClient       zrpc.RpcClientConf
	MessageClient     zrpc.RpcClientConf
}
