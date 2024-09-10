package dao

import (
	kafka "github.com/teamgram/marmota/pkg/mq"
	"github.com/teamgram/marmota/pkg/net/rpcx"
	"pwm-server/app/bff/privacysettings/internal/config"
	sync_client "pwm-server/app/messenger/sync/client"
	authsession_client "pwm-server/app/service/authsession/client"
	chat_client "pwm-server/app/service/biz/chat/client"
	user_client "pwm-server/app/service/biz/user/client"
)

type Dao struct {
	authsession_client.AuthsessionClient
	user_client.UserClient
	sync_client.SyncClient
	chat_client.ChatClient
}

func New(c config.Config) *Dao {
	return &Dao{
		UserClient:        user_client.NewUserClient(rpcx.GetCachedRpcClient(c.UserClient)),
		AuthsessionClient: authsession_client.NewAuthsessionClient(rpcx.GetCachedRpcClient(c.AuthsessionClient)),
		ChatClient:        chat_client.NewChatClient(rpcx.GetCachedRpcClient(c.ChatClient)),
		SyncClient:        sync_client.NewSyncMqClient(kafka.MustKafkaProducer(c.SyncClient)),
	}
}
