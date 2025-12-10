package dao

import (
	"github.com/teamgram/marmota/pkg/stores/sqlx"
	"pwm-server/app/service/biz/dialog/internal/dal/dao/mysql_dao"
)

type Mysql struct {
	*sqlx.DB
	*mysql_dao.DialogFiltersDAO
	*mysql_dao.DialogsDAO
	*mysql_dao.SavedDialogsDAO
	*sqlx.CommonDAO
}

func newMysqlDao(db *sqlx.DB) *Mysql {
	return &Mysql{
		DB:               db,
		DialogFiltersDAO: mysql_dao.NewDialogFiltersDAO(db),
		DialogsDAO:       mysql_dao.NewDialogsDAO(db),
		SavedDialogsDAO:  mysql_dao.NewSavedDialogsDAO(db),
		CommonDAO:        sqlx.NewCommonDAO(db),
	}
}
