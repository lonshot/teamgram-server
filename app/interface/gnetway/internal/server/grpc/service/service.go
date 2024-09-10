package service

import (
	"pwm-server/app/interface/gateway/gateway"
	"pwm-server/app/interface/gnetway/internal/svc"
)

type Service struct {
	svcCtx *svc.ServiceContext
	gateway.RPCGatewayServer
}

func New(ctx *svc.ServiceContext, srv gateway.RPCGatewayServer) *Service {
	return &Service{
		svcCtx:           ctx,
		RPCGatewayServer: srv,
	}
}
