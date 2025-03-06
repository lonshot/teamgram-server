package svc

import (
	"pwm-server/app/service/dfs/internal/config"
	"pwm-server/app/service/dfs/internal/dao"
	"pwm-server/app/service/dfs/internal/ffmpegutil"
)

type ServiceContext struct {
	Config config.Config
	*dao.Dao
	*ffmpegutil.FFmpegUtil
}

func NewServiceContext(c config.Config) *ServiceContext {
	return &ServiceContext{
		Config:     c,
		Dao:        dao.New(c),
		FFmpegUtil: ffmpegutil.NewFFmpegUtil(),
	}
}
