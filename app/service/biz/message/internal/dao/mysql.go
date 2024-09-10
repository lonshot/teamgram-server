package dao

import (
	"github.com/teamgram/marmota/pkg/stores/sqlx"
	"pwm-server/app/service/biz/message/internal/dal/dao/mysql_dao"
)

type Mysql struct {
	*sqlx.DB
	*mysql_dao.MessagesDAO
	*mysql_dao.HashTagsDAO
	*sqlx.CommonDAO
}

func newMysqlDao(db *sqlx.DB, shardingSize int) *Mysql {
	return &Mysql{
		DB:          db,
		MessagesDAO: mysql_dao.NewMessagesDAO(db, shardingSize),
		HashTagsDAO: mysql_dao.NewHashTagsDAO(db),
		CommonDAO:   sqlx.NewCommonDAO(db),
	}
}
