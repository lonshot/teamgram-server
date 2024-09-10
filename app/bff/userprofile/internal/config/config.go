package config

import (
	kafka "github.com/teamgram/marmota/pkg/mq"
	"github.com/zeromicro/go-zero/zrpc"
)

type Config struct {
	zrpc.RpcServerConf
	MediaClient zrpc.RpcClientConf
	UserClient  zrpc.RpcClientConf
	SyncClient  *kafka.KafkaProducerConf
}
