package dao

import (
	kafka "github.com/teamgram/marmota/pkg/mq"
	"github.com/teamgram/marmota/pkg/net/rpcx"
	"pwm-server/app/bff/dialogs/internal/config"
	sync_client "pwm-server/app/messenger/sync/client"
	chat_client "pwm-server/app/service/biz/chat/client"
	dialog_client "pwm-server/app/service/biz/dialog/client"
	message_client "pwm-server/app/service/biz/message/client"
	updates_client "pwm-server/app/service/biz/updates/client"
	user_client "pwm-server/app/service/biz/user/client"
)

type Dao struct {
	dialog_client.DialogClient
	user_client.UserClient
	chat_client.ChatClient
	sync_client.SyncClient
	updates_client.UpdatesClient
	message_client.MessageClient
}

func New(c config.Config) *Dao {
	return &Dao{
		DialogClient:  dialog_client.NewDialogClient(rpcx.GetCachedRpcClient(c.DialogClient)),
		UpdatesClient: updates_client.NewUpdatesClient(rpcx.GetCachedRpcClient(c.UpdatesClient)),
		UserClient:    user_client.NewUserClient(rpcx.GetCachedRpcClient(c.UserClient)),
		SyncClient:    sync_client.NewSyncMqClient(kafka.MustKafkaProducer(c.SyncClient)),
		MessageClient: message_client.NewMessageClient(rpcx.GetCachedRpcClient(c.MessageClient)),
		ChatClient:    chat_client.NewChatClient(rpcx.GetCachedRpcClient(c.ChatClient)),
	}
}
