package dao

import (
	kafka "github.com/teamgram/marmota/pkg/mq"
	"github.com/teamgram/marmota/pkg/net/rpcx"
	"github.com/teamgram/marmota/pkg/stores/sqlx"
	"pwm-server/app/bff/notification/internal/config"
	sync_client "pwm-server/app/messenger/sync/client"
	chat_client "pwm-server/app/service/biz/chat/client"
	user_client "pwm-server/app/service/biz/user/client"
)

type Dao struct {
	user_client.UserClient
	chat_client.ChatClient
	sync_client.SyncClient
	*DevicesDAO
}

func New(c config.Config) *Dao {
	db := sqlx.NewMySQL(&c.Mysql)
	return &Dao{
		UserClient: user_client.NewUserClient(rpcx.GetCachedRpcClient(c.UserClient)),
		ChatClient: chat_client.NewChatClient(rpcx.GetCachedRpcClient(c.ChatClient)),
		SyncClient: sync_client.NewSyncMqClient(kafka.MustKafkaProducer(c.SyncClient)),
		DevicesDAO: NewDevicesDAO(db),
	}
}
