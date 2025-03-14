package dao

import (
	"github.com/teamgram/marmota/pkg/stores/sqlx"
	"pwm-server/app/service/biz/updates/internal/dal/dao/mysql_dao"
)

type Mysql struct {
	*sqlx.DB
	*mysql_dao.AuthSeqUpdatesDAO
	*mysql_dao.UserPtsUpdatesDAO
	*sqlx.CommonDAO
}

func newMysqlDao(db *sqlx.DB) *Mysql {
	return &Mysql{
		DB:                db,
		AuthSeqUpdatesDAO: mysql_dao.NewAuthSeqUpdatesDAO(db),
		UserPtsUpdatesDAO: mysql_dao.NewUserPtsUpdatesDAO(db),
		CommonDAO:         sqlx.NewCommonDAO(db),
	}
}
