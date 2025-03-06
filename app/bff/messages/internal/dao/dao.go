package dao

import (
	kafka "github.com/teamgram/marmota/pkg/mq"
	"github.com/teamgram/marmota/pkg/net/rpcx"
	"pwm-server/app/bff/messages/internal/config"
	msg_client "pwm-server/app/messenger/msg/msg/client"
	sync_client "pwm-server/app/messenger/sync/client"
	chat_client "pwm-server/app/service/biz/chat/client"
	dialog_client "pwm-server/app/service/biz/dialog/client"
	message_client "pwm-server/app/service/biz/message/client"
	user_client "pwm-server/app/service/biz/user/client"
	username_client "pwm-server/app/service/biz/username/client"
	idgen_client "pwm-server/app/service/idgen/client"
	media_client "pwm-server/app/service/media/client"
)

type Dao struct {
	msg_client.MsgClient
	user_client.UserClient
	ChatClient *chat_client.ChatClientHelper
	media_client.MediaClient
	username_client.UsernameClient
	message_client.MessageClient
	idgen_client.IDGenClient2
	dialog_client.DialogClient
	sync_client.SyncClient
}

func New(c config.Config) *Dao {
	return &Dao{
		MsgClient:      msg_client.NewMsgClient(rpcx.GetCachedRpcClient(c.MsgClient)),
		UserClient:     user_client.NewUserClient(rpcx.GetCachedRpcClient(c.UserClient)),
		ChatClient:     chat_client.NewChatClientHelper(rpcx.GetCachedRpcClient(c.ChatClient)),
		MediaClient:    media_client.NewMediaClient(rpcx.GetCachedRpcClient(c.MediaClient)),
		DialogClient:   dialog_client.NewDialogClient(rpcx.GetCachedRpcClient(c.DialogClient)),
		IDGenClient2:   idgen_client.NewIDGenClient2(rpcx.GetCachedRpcClient(c.IdgenClient)),
		MessageClient:  message_client.NewMessageClient(rpcx.GetCachedRpcClient(c.MessageClient)),
		UsernameClient: username_client.NewUsernameClient(rpcx.GetCachedRpcClient(c.UsernameClient)),
		SyncClient:     sync_client.NewSyncMqClient(kafka.MustKafkaProducer(c.SyncClient)),
	}
}
