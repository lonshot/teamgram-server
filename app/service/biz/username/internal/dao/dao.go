package dao

import (
	"github.com/teamgram/marmota/pkg/stores/sqlc"
	"github.com/teamgram/marmota/pkg/stores/sqlx"
)

// Dao dao.
type Dao struct {
	*Mysql
	sqlc.CachedConn
}

// New new a dao and return.
func New(db *sqlx.DB, c sqlc.CachedConn) (dao *Dao) {
	dao = &Dao{
		Mysql:      newMysqlDao(db),
		CachedConn: c,
	}
	return
}
