package core

import (
	"github.com/teamgram/proto/mtproto"
	"pwm-server/app/service/authsession/authsession"
)

// AuthsessionGetClient
// authsession.getClient auth_key_id:long = String;
func (c *AuthsessionCore) AuthsessionGetClient(in *authsession.TLAuthsessionGetClient) (*mtproto.String, error) {
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

	client := c.svcCtx.Dao.GetClient(c.ctx, keyData.PermAuthKeyId)

	return mtproto.MakeTLString(&mtproto.String{
		V: client,
	}).To_String(), nil
}
