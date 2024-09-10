package dao

import (
	"flag"

	"github.com/teamgram/marmota/pkg/stores/sqlc"
	"github.com/teamgram/marmota/pkg/stores/sqlx"
	"pwm-server/app/service/authsession/internal/config"

	"github.com/oschwald/geoip2-golang"
	"github.com/zeromicro/go-zero/core/stores/kv"
)

var (
	mmdb string
)

func init() {
	flag.StringVar(&mmdb, "mmdb", "assets/GeoLite2-City.mmdb", "mmdb")
}

type Dao struct {
	*Mysql
	sqlc.CachedConn
	kv   kv.Store
	MMDB *geoip2.Reader
}

func New(c config.Config) *Dao {
	MMDB, err := geoip2.Open(mmdb)
	if err != nil {
		// panic(err)
		// logx.Errorf("")
	}
	db := sqlx.NewMySQL(&c.Mysql)

	return &Dao{
		Mysql:      newMysqlDao(db),
		CachedConn: sqlc.NewConn(db, c.Cache),
		kv:         kv.NewStore(c.KV),
		MMDB:       MMDB,
	}
}
