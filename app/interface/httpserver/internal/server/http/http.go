// Copyright (c) 2024-present, Teamgram Studio (https://teamgram.io).
//  All rights reserved.
//
// Author: teamgramio (teamgram.io@gmail.com)
//

package http

import (
	"pwm-server/app/interface/httpserver/internal/svc"

	"pwm-server/app/interface/httpserver/internal/config"

	"github.com/zeromicro/go-zero/rest"
)

// New new a grpc server.
func New(ctx *svc.ServiceContext, cg config.Config) *rest.Server {
	srv := rest.MustNewServer(cg.Http)

	go func(s *rest.Server, c *svc.ServiceContext) {
		defer s.Stop()

		RegisterHandlers(s, c)
		Initialize(cg)

		s.Start()
	}(srv, ctx)

	return srv
}
