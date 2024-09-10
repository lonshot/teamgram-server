package core

import (
	"github.com/teamgram/proto/mtproto"
	"pwm-server/app/interface/session/session"
	"pwm-server/app/service/authsession/authsession"
)

// SessionQueryAuthKey
// session.queryAuthKey auth_key_id:long = AuthKeyInfo;
func (c *SessionCore) SessionQueryAuthKey(in *session.TLSessionQueryAuthKey) (*mtproto.AuthKeyInfo, error) {
	key, err := c.svcCtx.Dao.AuthsessionClient.AuthsessionQueryAuthKey(c.ctx, &authsession.TLAuthsessionQueryAuthKey{
		AuthKeyId: in.GetAuthKeyId(),
	})
	if err != nil {
		c.Logger.Errorf("session.queryAuthKey - error: %v", err)
		return nil, err
	}

	return key, nil
}
