package core

import (
	"github.com/teamgram/proto/mtproto"
	"pwm-server/app/service/authsession/authsession"
)

// AuthsessionGetLayer
// authsession.getLayer auth_key_id:long = Int32;
func (c *AuthsessionCore) AuthsessionGetLayer(in *authsession.TLAuthsessionGetLayer) (*mtproto.Int32, error) {
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

	layer := c.svcCtx.GetApiLayer(c.ctx, keyData.PermAuthKeyId)

	return mtproto.MakeTLInt32(&mtproto.Int32{
		V: layer,
	}).To_Int32(), nil
}
