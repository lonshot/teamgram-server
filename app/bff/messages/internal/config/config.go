package config

import (
	kafka "github.com/teamgram/marmota/pkg/mq"
	"github.com/zeromicro/go-zero/zrpc"
)

type Config struct {
	zrpc.RpcServerConf

	UserClient     zrpc.RpcClientConf
	ChatClient     zrpc.RpcClientConf
	MsgClient      zrpc.RpcClientConf
	DialogClient   zrpc.RpcClientConf
	IdgenClient    zrpc.RpcClientConf
	MessageClient  zrpc.RpcClientConf
	MediaClient    zrpc.RpcClientConf
	UsernameClient zrpc.RpcClientConf
	SyncClient     *kafka.KafkaProducerConf
}
