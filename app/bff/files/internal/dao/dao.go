package dao

import (
	"github.com/teamgram/marmota/pkg/net/rpcx"
	"pwm-server/app/bff/files/internal/config"
	user_client "pwm-server/app/service/biz/user/client"
	dfs_client "pwm-server/app/service/dfs/client"
	media_client "pwm-server/app/service/media/client"
)

type Dao struct {
	dfs_client.DfsClient
	media_client.MediaClient
	user_client.UserClient
}

func New(c config.Config) *Dao {
	return &Dao{
		DfsClient:   dfs_client.NewDfsClient(rpcx.GetCachedRpcClient(c.DfsClient)),
		MediaClient: media_client.NewMediaClient(rpcx.GetCachedRpcClient(c.MediaClient)),
		UserClient:  user_client.NewUserClient(rpcx.GetCachedRpcClient(c.UserClient)),
	}
}
