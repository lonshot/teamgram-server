package config

import (
	kafka "github.com/teamgram/marmota/pkg/mq"
	"github.com/zeromicro/go-zero/zrpc"
)

type Config struct {
	zrpc.RpcServerConf
	UserClient    zrpc.RpcClientConf
	ChatClient    zrpc.RpcClientConf
	DialogClient  zrpc.RpcClientConf
	UpdatesClient zrpc.RpcClientConf
	SyncClient    *kafka.KafkaProducerConf
	MessageClient zrpc.RpcClientConf
	// ChannelClient zrpc.RpcClientConf
}
