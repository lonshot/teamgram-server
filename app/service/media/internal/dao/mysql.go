package dao

import (
	"github.com/teamgram/marmota/pkg/stores/sqlx"
	"pwm-server/app/service/media/internal/dal/dao/mysql_dao"
)

type Mysql struct {
	*sqlx.DB
	*mysql_dao.DocumentsDAO
	*mysql_dao.PhotosDAO
	*mysql_dao.PhotoSizesDAO
	*mysql_dao.VideoSizesDAO
	*sqlx.CommonDAO
}

func newMysqlDao(db *sqlx.DB) *Mysql {
	return &Mysql{
		DB:            db,
		DocumentsDAO:  mysql_dao.NewDocumentsDAO(db),
		PhotosDAO:     mysql_dao.NewPhotosDAO(db),
		PhotoSizesDAO: mysql_dao.NewPhotoSizesDAO(db),
		VideoSizesDAO: mysql_dao.NewVideoSizesDAO(db),
		CommonDAO:     sqlx.NewCommonDAO(db),
	}
}
