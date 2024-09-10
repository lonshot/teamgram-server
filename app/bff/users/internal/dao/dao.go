package dao

import (
	"github.com/teamgram/marmota/pkg/net/rpcx"
	"pwm-server/app/bff/users/internal/config"
	"pwm-server/app/bff/users/internal/plugin"
	chat_client "pwm-server/app/service/biz/chat/client"
	dialog_client "pwm-server/app/service/biz/dialog/client"
	user_client "pwm-server/app/service/biz/user/client"
)

type Dao struct {
	user_client.UserClient
	chat_client.ChatClient
	dialog_client.DialogClient
	Plugin plugin.StoryPlugin
}

func New(c config.Config, plugin plugin.StoryPlugin) *Dao {
	return &Dao{
		UserClient:   user_client.NewUserClient(rpcx.GetCachedRpcClient(c.UserClient)),
		ChatClient:   chat_client.NewChatClient(rpcx.GetCachedRpcClient(c.ChatClient)),
		DialogClient: dialog_client.NewDialogClient(rpcx.GetCachedRpcClient(c.DialogClient)),
		Plugin:       plugin,
	}
}
