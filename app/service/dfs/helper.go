package dfs_helper

import (
	"pwm-server/app/service/dfs/internal/config"
	"pwm-server/app/service/dfs/internal/dao"
	"pwm-server/app/service/dfs/internal/imaging"
	"pwm-server/app/service/dfs/internal/minio_util"
	"pwm-server/app/service/dfs/internal/server/grpc/service"
	"pwm-server/app/service/dfs/internal/server/http"
	"pwm-server/app/service/dfs/internal/svc"

	"github.com/zeromicro/go-zero/core/stores/kv"
	"github.com/zeromicro/go-zero/zrpc"
)

type (
	Config         = config.Config
	ServiceContext = svc.ServiceContext
)

var (
	New               = service.New
	NewServiceContext = svc.NewServiceContext
	NewMinioHelper    = dao.NewMinioHelper
)

//func New(c Config) *service.Service {
//	return service.New(svc.NewServiceContext(c))
//}

type (
	MinioConfig = minio_util.MinioConfig
	DFSHelper   = dao.Dao
	MinioHelper = minio_util.MinioHelper
)

// imaging - imaging
var (
	OpenWebp   = imaging.OpenWebp
	DecodeWebp = imaging.DecodeWebp
	EncodeWebp = imaging.EncodeWebp

	Open       = imaging.Open
	Decode     = imaging.Decode
	Resize     = imaging.Resize
	EncodeJpeg = imaging.EncodeJpeg

	EncodeStripped = imaging.EncodeStripped
)

func init() {
	zrpc.DontLogContentForMethod("/dfs.RPCDfs/dfs_writeFilePartData")
}

func NewDFSHelper(minio *MinioConfig, idgen zrpc.RpcClientConf, ssdb kv.KvConf) *DFSHelper {
	return dao.NewDFSHelper(minio, idgen, ssdb)
}

// GetDfsFile - GetDfsFile
var (
	GetDfsFile = http.GetDfsFile
)
