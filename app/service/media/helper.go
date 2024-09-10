package media_helper

import (
	"pwm-server/app/service/media/internal/config"
	"pwm-server/app/service/media/internal/dal/dataobject"
	"pwm-server/app/service/media/internal/dao"
	"pwm-server/app/service/media/internal/server/grpc/service"
	"pwm-server/app/service/media/internal/svc"
)

type (
	Dao = dao.Dao
)

type (
	DocumentsDO = dataobject.DocumentsDO
)

var (
	GenCacheDocumentKey   = dao.GenCacheDocumentKey
	ParseCacheDocumentKey = dao.ParseCacheDocumentKey
	GetPhotoSize          = dao.GetPhotoSize
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
