package dao

import (
	"github.com/teamgram/marmota/pkg/stores/sqlc"
	"github.com/teamgram/marmota/pkg/stores/sqlx"
	dfs_client "pwm-server/app/service/dfs/client"
	"pwm-server/app/service/media/internal/config"

	"github.com/zeromicro/go-zero/zrpc"
)

type Dao struct {
	*Mysql
	sqlc.CachedConn
	dfs_client.DfsClient
}

func New(c config.Config) *Dao {
	db := sqlx.NewMySQL(&c.Mysql)
	return &Dao{
		Mysql:      newMysqlDao(db),
		CachedConn: sqlc.NewConn(db, c.Cache),
		DfsClient:  dfs_client.NewDfsClient(zrpc.MustNewClient(c.Dfs)),
	}
}
