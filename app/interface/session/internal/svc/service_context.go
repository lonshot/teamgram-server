package svc

import (
	"pwm-server/app/interface/session/internal/config"
	"pwm-server/app/interface/session/internal/dao"
	"pwm-server/app/interface/session/internal/sess"
)

type ServiceContext struct {
	Config      config.Config
	MainAuthMgr *sess.MainAuthWrapperManager
	*dao.Dao
}

func NewServiceContext(c config.Config) *ServiceContext {
	d := dao.New(c)
	mainAuthMgr := sess.NewMainAuthWrapperManager(d)
	d.RpcShardingManager.RegisterCB(mainAuthMgr.OnShardingCB)
	d.RpcShardingManager.Start()

	return &ServiceContext{
		Config:      c,
		MainAuthMgr: mainAuthMgr,
		Dao:         d,
	}
}
