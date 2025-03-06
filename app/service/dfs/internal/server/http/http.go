package http

import (
	"net/http"

	"pwm-server/app/service/dfs/internal/svc"

	"github.com/zeromicro/go-zero/rest"
)

// New new a grpc server.
func New(ctx *svc.ServiceContext, c rest.RestConf) *rest.Server {
	srv := rest.MustNewServer(c)

	go func() {
		defer srv.Stop()

		srv.AddRoutes([]rest.Route{
			{
				Method:  http.MethodGet,
				Path:    "/dfs/file/:file",
				Handler: GetDfsFile(ctx),
			},
		})

		srv.Start()
	}()
	return srv
}
