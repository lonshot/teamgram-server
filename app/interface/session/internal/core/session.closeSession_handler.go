package core

import (
	"github.com/teamgram/proto/mtproto"
	"pwm-server/app/interface/session/session"
)

// SessionCloseSession
// session.closeSession client:SessionClientEvent = Bool;
func (c *SessionCore) SessionCloseSession(in *session.TLSessionCloseSession) (*mtproto.Bool, error) {
	var (
		cli = in.GetClient()
	)

	if cli == nil {
		err := mtproto.ErrInputRequestInvalid
		c.Logger.Errorf("session.closeSession - error: %v", err)
		return nil, err
	}

	mainAuth := c.svcCtx.MainAuthMgr.GetMainAuthWrapper(cli.PermAuthKeyId)
	if mainAuth == nil {
		c.Logger.Errorf("session.closeSession - not found sessList by keyId: %d", cli)
	} else {
		mainAuth.SessionClientClosed(c.ctx, int(cli.KeyType), cli.AuthKeyId, cli.ServerId, cli.SessionId)
	}

	return mtproto.BoolTrue, nil
}
