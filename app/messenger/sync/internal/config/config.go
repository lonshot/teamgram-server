package config

import (
	kafka "github.com/teamgram/marmota/pkg/mq"
	"github.com/zeromicro/go-zero/core/stores/cache"
	"github.com/zeromicro/go-zero/core/stores/kv"
	"github.com/zeromicro/go-zero/zrpc"

	"github.com/teamgram/marmota/pkg/stores/sqlx"
)

// Routine routine.
type Routine struct {
	Size uint64
	Chan uint64
}

type Config struct {
	zrpc.RpcServerConf
	Mysql         sqlx.Config
	Cache         cache.CacheConf
	KV            kv.KvConf
	Routine       Routine
	SyncConsumer  kafka.KafkaConsumerConf
	SessionClient zrpc.RpcClientConf
	IdgenClient   zrpc.RpcClientConf
	StatusClient  zrpc.RpcClientConf
	ChatClient    zrpc.RpcClientConf
	PushClient    *kafka.KafkaProducerConf `json:",optional"`
}
