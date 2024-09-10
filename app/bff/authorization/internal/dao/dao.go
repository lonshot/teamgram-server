package dao

import (
	"flag"
	"github.com/oschwald/geoip2-golang"
	kafka "github.com/teamgram/marmota/pkg/mq"
	"github.com/teamgram/marmota/pkg/net/rpcx"
	"pwm-server/app/bff/authorization/internal/config"
	msg_client "pwm-server/app/messenger/msg/msg/client"
	sync_client "pwm-server/app/messenger/sync/client"
	authsession_client "pwm-server/app/service/authsession/client"
	chat_client "pwm-server/app/service/biz/chat/client"
	user_client "pwm-server/app/service/biz/user/client"
	username_client "pwm-server/app/service/biz/username/client"
	status_client "pwm-server/app/service/status/client"
	"github.com/zeromicro/go-zero/core/stores/kv"
)

var (
	mmdb string
)

func init() {
	flag.StringVar(&mmdb, "mmdb", "./GeoLite2-City.mmdb", "mmdb")
}

type Dao struct {
	kv   kv.Store
	MMDB *geoip2.Reader
	authsession_client.AuthsessionClient
	user_client.UserClient
	sync_client.SyncClient
	chat_client.ChatClient
	status_client.StatusClient
	msg_client.MsgClient
	username_client.UsernameClient
}

func New(c config.Config) *Dao {
	MMDB, err := geoip2.Open(mmdb)
	if err != nil {
		// panic(err)
	}
	return &Dao{
		kv:                kv.NewStore(c.KV),
		MMDB:              MMDB,
		UserClient:        user_client.NewUserClient(rpcx.GetCachedRpcClient(c.UserClient)),
		AuthsessionClient: authsession_client.NewAuthsessionClient(rpcx.GetCachedRpcClient(c.AuthsessionClient)),
		ChatClient:        chat_client.NewChatClient(rpcx.GetCachedRpcClient(c.ChatClient)),
		SyncClient:        sync_client.NewSyncMqClient(kafka.MustKafkaProducer(c.SyncClient)),
		StatusClient:      status_client.NewStatusClient(rpcx.GetCachedRpcClient(c.StatusClient)),
		MsgClient:         msg_client.NewMsgClient(rpcx.GetCachedRpcClient(c.MsgClient)),
		UsernameClient:    username_client.NewUsernameClient(rpcx.GetCachedRpcClient(c.UsernameClient)),
	}
}
