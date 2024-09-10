/*
 * WARNING! All changes made in this file will be lost!
 * Created from 'scheme.tl' by 'mtprotoc'
 *
 * Copyright (c) 2021-present,  Teamgram Studio (https://teamgram.io).
 *  All rights reserved.
 *
 * Author: teamgramio (teamgram.io@gmail.com)
 */

package user_helper

import (
	"pwm-server/app/service/biz/user/internal/config"
	"pwm-server/app/service/biz/user/internal/dao"
	"pwm-server/app/service/biz/user/internal/server/grpc/service"
	"pwm-server/app/service/biz/user/internal/svc"
)

type (
	Dao           = dao.Dao
	CacheUserData = dao.CacheUserData
)

var (
	GenCacheUserDataCacheKey = dao.GenCacheUserDataCacheKey
)

type (
	Config  = config.Config
	Service = service.Service
)

var (
	NewServiceContext = svc.NewServiceContext
)

func New(c Config) *service.Service {
	return service.New(svc.NewServiceContext(c))
}
