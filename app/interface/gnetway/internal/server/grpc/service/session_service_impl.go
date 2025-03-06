package service

import (
	"context"

	"github.com/teamgram/proto/mtproto"
	"pwm-server/app/interface/gateway/gateway"

	"github.com/zeromicro/go-zero/core/logx"
)

// GatewaySendDataToGateway
// gateway.sendDataToGateway auth_key_id:long session_id:long payload:bytes = Bool;
func (s *Service) GatewaySendDataToGateway(ctx context.Context, request *gateway.TLGatewaySendDataToGateway) (reply *mtproto.Bool, err error) {
	logx.WithContext(ctx).Debugf("gateway.sendDataToGateway - request: {auth_key_id:%d, session_id:long:%d, payload: %d}",
		request.AuthKeyId,
		request.SessionId,
		len(request.Payload))

	r, err := s.RPCGatewayServer.GatewaySendDataToGateway(ctx, request)
	if err != nil {
		return nil, err
	}

	logx.WithContext(ctx).Debugf("gateway.sendDataToGateway - reply: %s", r)
	return r, err
}
