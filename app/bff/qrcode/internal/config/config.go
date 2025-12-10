package config

import (
	kafka "github.com/teamgram/marmota/pkg/mq"
	"github.com/zeromicro/go-zero/core/stores/kv"
	"github.com/zeromicro/go-zero/zrpc"
)

type Config struct {
	zrpc.RpcServerConf
	KV                kv.KvConf
	UserClient        zrpc.RpcClientConf
	AuthSessionClient zrpc.RpcClientConf
	SyncClient        *kafka.KafkaProducerConf
}
