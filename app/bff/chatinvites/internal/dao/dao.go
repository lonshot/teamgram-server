package dao

import (
	kafka "github.com/teamgram/marmota/pkg/mq"
	"github.com/teamgram/marmota/pkg/net/rpcx"
	"pwm-server/app/bff/chatinvites/internal/config"
	msg_client "pwm-server/app/messenger/msg/msg/client"
	sync_client "pwm-server/app/messenger/sync/client"
	chat_client "pwm-server/app/service/biz/chat/client"
	user_client "pwm-server/app/service/biz/user/client"
)

type Dao struct {
	user_client.UserClient
	chat_client.ChatClient
	msg_client.MsgClient
	sync_client.SyncClient
}

func New(c config.Config) *Dao {
	return &Dao{
		UserClient: user_client.NewUserClient(rpcx.GetCachedRpcClient(c.UserClient)),
		ChatClient: chat_client.NewChatClient(rpcx.GetCachedRpcClient(c.ChatClient)),
		MsgClient:  msg_client.NewMsgClient(rpcx.GetCachedRpcClient(c.MsgClient)),
		SyncClient: sync_client.NewSyncMqClient(kafka.MustKafkaProducer(c.SyncClient)),
	}
}
