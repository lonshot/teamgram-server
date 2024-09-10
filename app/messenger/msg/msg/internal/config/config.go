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
	Mysql           sqlx.Config
	KV              kv.KvConf
	IdgenClient     zrpc.RpcClientConf
	UserClient      zrpc.RpcClientConf
	InboxClient     *kafka.KafkaProducerConf
	ChatClient      zrpc.RpcClientConf
	SyncClient      *kafka.KafkaProducerConf
	ChannelClient   zrpc.RpcClientConf
	DialogClient    zrpc.RpcClientConf
	MessageSharding int `json:",default=1"`
	Redis2          redis.RedisConf
	UsernameClient  zrpc.RpcClientConf
}
