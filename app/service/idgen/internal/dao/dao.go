package dao

import (
	"log"

	"github.com/bwmarrin/snowflake"
	"pwm-server/app/service/idgen/internal/config"
	"github.com/zeromicro/go-zero/core/stores/kv"
)

type Dao struct {
	*snowflake.Node
	KV kv.Store
}

func New(c config.Config) *Dao {
	var (
		err error
		d   = new(Dao)
	)

	d.Node, err = snowflake.NewNode(c.NodeId)
	if err != nil {
		log.Fatal("new snowflake node error: ", err)
	}
	d.KV = kv.NewStore(c.SeqIDGen)

	return d
}
