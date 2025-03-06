package dao

import (
	kafka "github.com/teamgram/marmota/pkg/mq"
	"github.com/teamgram/marmota/pkg/net/rpcx"
	"pwm-server/app/bff/qrcode/internal/config"
	sync_client "pwm-server/app/messenger/sync/client"
	authsession_client "pwm-server/app/service/authsession/client"
	user_client "pwm-server/app/service/biz/user/client"
	"github.com/zeromicro/go-zero/core/stores/kv"
)

type Dao struct {
	kv kv.Store
	user_client.UserClient
	authsession_client.AuthsessionClient
	sync_client.SyncClient
}

func New(c config.Config) *Dao {
	return &Dao{
		kv:                kv.NewStore(c.KV),
		UserClient:        user_client.NewUserClient(rpcx.GetCachedRpcClient(c.UserClient)),
		AuthsessionClient: authsession_client.NewAuthsessionClient(rpcx.GetCachedRpcClient(c.AuthSessionClient)),
		SyncClient:        sync_client.NewSyncMqClient(kafka.MustKafkaProducer(c.SyncClient)),
	}
}
