package dao

import (
	"github.com/teamgram/marmota/pkg/net/rpcx"
	"pwm-server/app/bff/nsfw/internal/config"
	user_client "pwm-server/app/service/biz/user/client"
)

type Dao struct {
	user_client.UserClient
}

func New(c config.Config) *Dao {
	return &Dao{
		UserClient: user_client.NewUserClient(rpcx.GetCachedRpcClient(c.UserClient)),
	}
}
