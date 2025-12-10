package svc

import (
	"github.com/teamgram/marmota/pkg/stores/sqlc"
	"github.com/teamgram/marmota/pkg/stores/sqlx"
	"pwm-server/app/service/biz/username/internal/config"
	"pwm-server/app/service/biz/username/internal/dao"
)

type ServiceContext struct {
	Config config.Config
	*dao.Dao
}

func NewServiceContext(c config.Config) *ServiceContext {
	db := sqlx.NewMySQL(&c.Mysql)
	return &ServiceContext{
		Config: c,
		Dao:    dao.New(db, sqlc.NewConn(db, c.Cache)),
	}
}
