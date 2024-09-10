package dao

import (
	"github.com/teamgram/marmota/pkg/stores/sqlc"
	"github.com/teamgram/marmota/pkg/stores/sqlx"
	"pwm-server/app/service/biz/message/internal/config"
	"pwm-server/app/service/biz/message/internal/plugin"
)

// Dao dao.
type Dao struct {
	*Mysql
	sqlc.CachedConn
	Plugin plugin.MessagePlugin
}

// New new a dao and return.
func New(c config.Config, plugin plugin.MessagePlugin) *Dao {
	db := sqlx.NewMySQL(&c.Mysql)
	return &Dao{
		Mysql:      newMysqlDao(db, c.MessageSharding),
		CachedConn: sqlc.NewConn(db, c.Cache),
		Plugin:     plugin,
	}
}
