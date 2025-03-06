package core

import (
	"github.com/teamgram/proto/mtproto"
	"pwm-server/app/interface/session/session"
	"pwm-server/app/service/authsession/authsession"
)

// SessionSetAuthKey
// session.setAuthKey auth_key:AuthKeyInfo future_salt:FutureSalt expires_in:int = Bool;
func (c *SessionCore) SessionSetAuthKey(in *session.TLSessionSetAuthKey) (*mtproto.Bool, error) {
	if in.AuthKey == nil {
		c.Logger.Errorf("session.setAuthKey error: auth_key is nil")
		return nil, mtproto.ErrInputRequestInvalid
	}

	rV, err := c.svcCtx.Dao.AuthsessionClient.AuthsessionSetAuthKey(
		c.ctx,
		&authsession.TLAuthsessionSetAuthKey{
			AuthKey:    in.AuthKey,
			FutureSalt: in.GetFutureSalt(),
			ExpiresIn:  in.GetExpiresIn(),
		})
	if err != nil {
		c.Logger.Errorf("session.setAuthKey - error: %v", err)
		return nil, err
	}

	return rV, nil
}
