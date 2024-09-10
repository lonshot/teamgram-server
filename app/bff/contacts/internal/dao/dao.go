package dao

import (
	kafka "github.com/teamgram/marmota/pkg/mq"
	"github.com/teamgram/marmota/pkg/net/rpcx"
	"pwm-server/app/bff/contacts/internal/config"
	sync_client "pwm-server/app/messenger/sync/client"
	chat_client "pwm-server/app/service/biz/chat/client"
	user_client "pwm-server/app/service/biz/user/client"
	username_client "pwm-server/app/service/biz/username/client"
)

type Dao struct {
	user_client.UserClient
	chat_client.ChatClient
	sync_client.SyncClient
	username_client.UsernameClient
}

func New(c config.Config) *Dao {
	return &Dao{
		UserClient:     user_client.NewUserClient(rpcx.GetCachedRpcClient(c.UserClient)),
		ChatClient:     chat_client.NewChatClient(rpcx.GetCachedRpcClient(c.ChatClient)),
		UsernameClient: username_client.NewUsernameClient(rpcx.GetCachedRpcClient(c.UsernameClient)),
		SyncClient:     sync_client.NewSyncMqClient(kafka.MustKafkaProducer(c.SyncClient)),
	}
}
