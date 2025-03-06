package core

import (
	"github.com/teamgram/proto/mtproto"
	"pwm-server/app/service/authsession/authsession"
)

// AuthsessionGetPermAuthKeyId
// authsession.getPermAuthKeyId auth_key_id:long= Int64;
func (c *AuthsessionCore) AuthsessionGetPermAuthKeyId(in *authsession.TLAuthsessionGetPermAuthKeyId) (*mtproto.Int64, error) {
	var (
		inKeyId = in.GetAuthKeyId()
	)

	keyData, err := c.svcCtx.Dao.QueryAuthKeyV2(c.ctx, inKeyId)
	if err != nil {
		c.Logger.Errorf("queryAuthKeyV2(%d) is error: %v", inKeyId, err)
		return nil, err
	} else if keyData.PermAuthKeyId == 0 {
		c.Logger.Errorf("queryAuthKeyV2(%d) - PermAuthKeyId is empty", inKeyId)
		return nil, mtproto.ErrAuthKeyPermEmpty
	}

	return mtproto.MakeTLInt64(&mtproto.Int64{
		V: keyData.PermAuthKeyId,
	}).To_Int64(), nil
}
