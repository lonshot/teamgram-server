package dao

import (
	"github.com/teamgram/marmota/pkg/net/rpcx"
	"pwm-server/app/bff/updates/internal/config"
	authsession_client "pwm-server/app/service/authsession/client"
	chat_client "pwm-server/app/service/biz/chat/client"
	updates_client "pwm-server/app/service/biz/updates/client"
	user_client "pwm-server/app/service/biz/user/client"
)

type Dao struct {
	updates_client.UpdatesClient
	user_client.UserClient
	chat_client.ChatClient
	authsession_client.AuthsessionClient
}

func New(c config.Config) *Dao {
	return &Dao{
		UpdatesClient:     updates_client.NewUpdatesClient(rpcx.GetCachedRpcClient(c.UpdatesClient)),
		UserClient:        user_client.NewUserClient(rpcx.GetCachedRpcClient(c.UserClient)),
		ChatClient:        chat_client.NewChatClient(rpcx.GetCachedRpcClient(c.ChatClient)),
		AuthsessionClient: authsession_client.NewAuthsessionClient(rpcx.GetCachedRpcClient(c.AuthsessionClient)),
	}
}
