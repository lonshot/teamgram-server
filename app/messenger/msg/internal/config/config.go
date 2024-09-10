package config

import (
	kafka "github.com/teamgram/marmota/pkg/mq"
	"github.com/teamgram/marmota/pkg/stores/sqlx"
	"github.com/zeromicro/go-zero/core/stores/kv"
	"github.com/zeromicro/go-zero/core/stores/redis"
	"github.com/zeromicro/go-zero/zrpc"
)

type Config struct {
	zrpc.RpcServerConf
	InboxConsumer    kafka.KafkaConsumerConf
	Mysql            sqlx.Config
	KV               kv.KvConf
	IdgenClient      zrpc.RpcClientConf
	BizServiceClient zrpc.RpcClientConf
	InboxClient      *kafka.KafkaProducerConf
	SyncClient       *kafka.KafkaProducerConf
	BotSyncClient    *kafka.KafkaProducerConf `json:",optional"`
	MessageSharding  int                      `json:",default=1"`
	Redis2           redis.RedisConf
}
