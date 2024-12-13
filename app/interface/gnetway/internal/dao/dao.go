package dao

import (
	"pwm-server/app/interface/gnetway/internal/config"
)

type Dao struct {
	*ShardingSessionClient
}

func New(c config.Config) *Dao {
	return &Dao{
		ShardingSessionClient: NewShardingSessionClient(c),
	}
}
