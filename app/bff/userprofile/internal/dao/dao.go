package dao

import (
	kafka "github.com/teamgram/marmota/pkg/mq"
	"github.com/teamgram/marmota/pkg/net/rpcx"
	"pwm-server/app/bff/userprofile/internal/config"
	sync_client "pwm-server/app/messenger/sync/client"
	user_client "pwm-server/app/service/biz/user/client"
	media_client "pwm-server/app/service/media/client"
)

type Dao struct {
	media_client.MediaClient
	user_client.UserClient
	sync_client.SyncClient
}

func New(c config.Config) *Dao {
	return &Dao{
		MediaClient: media_client.NewMediaClient(rpcx.GetCachedRpcClient(c.MediaClient)),
		UserClient:  user_client.NewUserClient(rpcx.GetCachedRpcClient(c.UserClient)),
		SyncClient:  sync_client.NewSyncMqClient(kafka.MustKafkaProducer(c.SyncClient)),
	}
}
