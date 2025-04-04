package dao

import (
	kafka "github.com/teamgram/marmota/pkg/mq"
	"github.com/teamgram/marmota/pkg/net/rpcx"
	"pwm-server/app/bff/chats/internal/config"
	msg_client "pwm-server/app/messenger/msg/msg/client"
	sync_client "pwm-server/app/messenger/sync/client"
	authsession_client "pwm-server/app/service/authsession/client"
	chat_client "pwm-server/app/service/biz/chat/client"
	dialog_client "pwm-server/app/service/biz/dialog/client"
	message_client "pwm-server/app/service/biz/message/client"
	user_client "pwm-server/app/service/biz/user/client"
	idgen_client "pwm-server/app/service/idgen/client"
	media_client "pwm-server/app/service/media/client"
)

type Dao struct {
	user_client.UserClient
	ChatClient *chat_client.ChatClientHelper
	msg_client.MsgClient
	sync_client.SyncClient
	media_client.MediaClient
	dialog_client.DialogClient
	authsession_client.AuthsessionClient
	idgen_client.IDGenClient2
	message_client.MessageClient
}

func New(c config.Config) *Dao {
	return &Dao{
		UserClient:        user_client.NewUserClient(rpcx.GetCachedRpcClient(c.UserClient)),
		ChatClient:        chat_client.NewChatClientHelper(rpcx.GetCachedRpcClient(c.ChatClient)),
		MsgClient:         msg_client.NewMsgClient(rpcx.GetCachedRpcClient(c.MsgClient)),
		DialogClient:      dialog_client.NewDialogClient(rpcx.GetCachedRpcClient(c.DialogClient)),
		SyncClient:        sync_client.NewSyncMqClient(kafka.MustKafkaProducer(c.SyncClient)),
		MediaClient:       media_client.NewMediaClient(rpcx.GetCachedRpcClient(c.MediaClient)),
		AuthsessionClient: authsession_client.NewAuthsessionClient(rpcx.GetCachedRpcClient(c.AuthsessionClient)),
		IDGenClient2:      idgen_client.NewIDGenClient2(rpcx.GetCachedRpcClient(c.IdgenClient)),
		MessageClient:     message_client.NewMessageClient(rpcx.GetCachedRpcClient(c.MessageClient)),
	}
}
