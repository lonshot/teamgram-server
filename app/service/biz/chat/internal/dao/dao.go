package dao

import (
	"github.com/teamgram/marmota/pkg/net/rpcx"
	"pwm-server/app/service/biz/chat/plugin"

	"github.com/teamgram/marmota/pkg/stores/sqlc"
	"github.com/teamgram/marmota/pkg/stores/sqlx"
	"pwm-server/app/service/biz/chat/internal/config"
	media_client "pwm-server/app/service/media/client"
)

// Dao dao.
type Dao struct {
	*Mysql
	sqlc.CachedConn
	media_client.MediaClient
	Plugin plugin.ChatPlugin
}

// New new a dao and return.
func New(c config.Config, plugin plugin.ChatPlugin) (dao *Dao) {
	db := sqlx.NewMySQL(&c.Mysql)
	return &Dao{
		Mysql:       newMysqlDao(db),
		CachedConn:  sqlc.NewConn(db, c.Cache),
		MediaClient: media_client.NewMediaClient(rpcx.GetCachedRpcClient(c.MediaClient)),
		Plugin:      plugin,
	}
}
