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
	UserClient                zrpc.RpcClientConf
	AuthsessionClient         zrpc.RpcClientConf
	ChatClient                zrpc.RpcClientConf
	StatusClient              zrpc.RpcClientConf
	UsernameClient            zrpc.RpcClientConf
	MsgClient                 zrpc.RpcClientConf
	SyncClient                *kafka.KafkaProducerConf
	SignInServiceNotification []conf.MessageEntityConfig `json:",optional"`
	SignInMessage             []conf.MessageEntityConfig `json:",optional"`
}
