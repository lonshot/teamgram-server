package dao

import (
	"github.com/teamgram/marmota/pkg/stores/sqlx"
	"pwm-server/app/messenger/msg/internal/dal/dao/mysql_dao"
)

type Mysql struct {
	*sqlx.DB
	*mysql_dao.MessagesDAO
	*mysql_dao.ChatParticipantsDAO
	*mysql_dao.HashTagsDAO
	*mysql_dao.DialogsDAO
	*mysql_dao.SavedDialogsDAO
	*sqlx.CommonDAO
}

func NewMysqlDao(db *sqlx.DB, shardingSize int) *Mysql {
	return &Mysql{
		DB:                  db,
		MessagesDAO:         mysql_dao.NewMessagesDAO(db, shardingSize),
		ChatParticipantsDAO: mysql_dao.NewChatParticipantsDAO(db),
		HashTagsDAO:         mysql_dao.NewHashTagsDAO(db),
		DialogsDAO:          mysql_dao.NewDialogsDAO(db),
		SavedDialogsDAO:     mysql_dao.NewSavedDialogsDAO(db),
		CommonDAO:           sqlx.NewCommonDAO(db),
	}
}
