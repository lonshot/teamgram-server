package dao

import (
	"github.com/teamgram/marmota/pkg/stores/sqlx"
	"pwm-server/app/service/biz/chat/internal/dal/dao/mysql_dao"
)

type Mysql struct {
	*sqlx.DB
	*mysql_dao.ChatInviteParticipantsDAO
	*mysql_dao.ChatInvitesDAO
	*mysql_dao.ChatParticipantsDAO
	*mysql_dao.ChatsDAO
	*sqlx.CommonDAO
}

func newMysqlDao(db *sqlx.DB) *Mysql {
	return &Mysql{
		DB:                        db,
		ChatInviteParticipantsDAO: mysql_dao.NewChatInviteParticipantsDAO(db),
		ChatInvitesDAO:            mysql_dao.NewChatInvitesDAO(db),
		ChatParticipantsDAO:       mysql_dao.NewChatParticipantsDAO(db),
		ChatsDAO:                  mysql_dao.NewChatsDAO(db),
		CommonDAO:                 sqlx.NewCommonDAO(db),
	}
}
