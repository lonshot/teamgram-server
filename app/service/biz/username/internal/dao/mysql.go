package dao

import (
	"github.com/teamgram/marmota/pkg/stores/sqlx"
	"pwm-server/app/service/biz/username/internal/dal/dao/mysql_dao"
)

type Mysql struct {
	*sqlx.DB
	*mysql_dao.UsernameDAO
	*sqlx.CommonDAO
}

func newMysqlDao(db *sqlx.DB) *Mysql {
	return &Mysql{
		DB:          db,
		UsernameDAO: mysql_dao.NewUsernameDAO(db),
		CommonDAO:   sqlx.NewCommonDAO(db),
	}
}
