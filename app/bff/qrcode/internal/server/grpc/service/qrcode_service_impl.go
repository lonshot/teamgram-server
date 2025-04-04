package service

import (
	"context"

	"github.com/teamgram/proto/mtproto"
	"pwm-server/app/bff/qrcode/internal/core"
)

// AuthExportLoginToken
// auth.exportLoginToken#b7e085fe api_id:int api_hash:string except_ids:Vector<long> = auth.LoginToken;
func (s *Service) AuthExportLoginToken(ctx context.Context, request *mtproto.TLAuthExportLoginToken) (*mtproto.Auth_LoginToken, error) {
	c := core.New(ctx, s.svcCtx)
	c.Logger.Debugf("auth.exportLoginToken - metadata: %s, request: %s", c.MD, request)

	r, err := c.AuthExportLoginToken(request)
	if err != nil {
		return nil, err
	}

	c.Logger.Debugf("auth.exportLoginToken - reply: %s", r)
	return r, err
}

// AuthImportLoginToken
// auth.importLoginToken#95ac5ce4 token:bytes = auth.LoginToken;
func (s *Service) AuthImportLoginToken(ctx context.Context, request *mtproto.TLAuthImportLoginToken) (*mtproto.Auth_LoginToken, error) {
	c := core.New(ctx, s.svcCtx)
	c.Logger.Debugf("auth.importLoginToken - metadata: %s, request: %s", c.MD, request)

	r, err := c.AuthImportLoginToken(request)
	if err != nil {
		return nil, err
	}

	c.Logger.Debugf("auth.importLoginToken - reply: %s", r)
	return r, err
}

// AuthAcceptLoginToken
// auth.acceptLoginToken#e894ad4d token:bytes = Authorization;
func (s *Service) AuthAcceptLoginToken(ctx context.Context, request *mtproto.TLAuthAcceptLoginToken) (*mtproto.Authorization, error) {
	c := core.New(ctx, s.svcCtx)
	c.Logger.Debugf("auth.acceptLoginToken - metadata: %s, request: %s", c.MD, request)

	r, err := c.AuthAcceptLoginToken(request)
	if err != nil {
		return nil, err
	}

	c.Logger.Debugf("auth.acceptLoginToken - reply: %s", r)
	return r, err
}
