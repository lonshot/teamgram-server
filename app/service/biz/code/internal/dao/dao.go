package dao

import (
	"pwm-server/app/service/biz/code/internal/config"

	"github.com/zeromicro/go-zero/core/stores/kv"
)

type Dao struct {
	kv kv.Store
}

func New(c config.Config) *Dao {
	return &Dao{
		kv: kv.NewStore(c.KV),
	}
}
