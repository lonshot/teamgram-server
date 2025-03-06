package core

import (
	"github.com/teamgram/proto/mtproto"
	"pwm-server/app/interface/session/session"
)

// SessionSendDataToSession
// session.sendDataToSession data:SessionClientData = Bool;
func (c *SessionCore) SessionSendDataToSession(in *session.TLSessionSendDataToSession) (*mtproto.Bool, error) {
	var (
		data = in.GetData()
	)

	if data == nil {
		err := mtproto.ErrInputRequestInvalid
		c.Logger.Errorf("session.sendDataToSession - error: %v", err)
		return nil, err
	}

	mainAuth, err := c.getOrFetchMainAuthWrapper(data.PermAuthKeyId)
	if err != nil {
		c.Logger.Errorf("session.sendDataToSession - error: %v", err)
		return nil, err
	}

	mainAuth.SessionDataArrived(
		c.ctx,
		int(data.KeyType),
		data.AuthKeyId,
		data.ServerId,
		data.ClientIp,
		data.SessionId,
		data.Salt,
		data.Payload)

	return mtproto.BoolTrue, nil
}
