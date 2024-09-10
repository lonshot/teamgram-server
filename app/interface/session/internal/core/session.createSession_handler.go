package core

import (
	"github.com/teamgram/proto/mtproto"
	"pwm-server/app/interface/session/session"
)

// SessionCreateSession
// session.createSession client:SessionClientEvent = Bool;
func (c *SessionCore) SessionCreateSession(in *session.TLSessionCreateSession) (*mtproto.Bool, error) {
	var (
		cli = in.GetClient()
	)

	if cli == nil {
		err := mtproto.ErrInputRequestInvalid
		c.Logger.Errorf("session.createSession - error: %v", err)
		return nil, err
	}

	mainAuth, err := c.getOrFetchMainAuthWrapper(cli.PermAuthKeyId)
	if err != nil {
		c.Logger.Errorf("session.createSession - error: %v", err)
		return nil, err
	}

	mainAuth.SessionClientNew(c.ctx, int(cli.KeyType), cli.AuthKeyId, cli.ServerId, cli.SessionId)

	return mtproto.BoolTrue, nil
}
