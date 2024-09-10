package config

import (
	kafka "github.com/teamgram/marmota/pkg/mq"
	"pwm-server/pkg/code/conf"
	"github.com/zeromicro/go-zero/core/stores/kv"
	"github.com/zeromicro/go-zero/zrpc"
)

type Config struct {
	zrpc.RpcServerConf
	KV                        kv.KvConf
	Code                      *conf.SmsVerifyCodeConfig
	BizServiceClient          zrpc.RpcClientConf
	AuthSessionClient         zrpc.RpcClientConf
	MediaClient               zrpc.RpcClientConf
	IdgenClient               zrpc.RpcClientConf
	MsgClient                 zrpc.RpcClientConf
	SyncClient                *kafka.KafkaProducerConf
	DfsClient                 zrpc.RpcClientConf
	StatusClient              zrpc.RpcClientConf
	SignInServiceNotification []conf.MessageEntityConfig `json:",optional"`
	SignInMessage             []conf.MessageEntityConfig `json:",optional"`
}
