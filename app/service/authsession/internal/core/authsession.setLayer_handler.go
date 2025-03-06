package core

import (
	"github.com/teamgram/proto/mtproto"
	"pwm-server/app/service/authsession/authsession"
)

// AuthsessionSetLayer
// authsession.setLayer auth_key_id:long ip:string layer:int = Bool;
func (c *AuthsessionCore) AuthsessionSetLayer(in *authsession.TLAuthsessionSetLayer) (*mtproto.Bool, error) {
	var (
		setLayer = in
		inKeyId  = in.GetAuthKeyId()
	)

	keyData, err := c.svcCtx.Dao.QueryAuthKeyV2(c.ctx, inKeyId)
	if err != nil {
		c.Logger.Errorf("setLayer - queryAuthKeyV2(%d) is error: %v", inKeyId, err)
		return nil, err
	} else if keyData.PermAuthKeyId == 0 {
		c.Logger.Errorf("queryAuthKeyV2(%d) - PermAuthKeyId is empty", inKeyId)
		return nil, mtproto.ErrAuthKeyPermEmpty
	}

	setLayer.AuthKeyId = keyData.PermAuthKeyId
	err = c.svcCtx.Dao.SetLayer(c.ctx, setLayer)
	if err != nil {
		c.Logger.Errorf("setLayer(%d, %d) is error: %v", inKeyId, in.Layer, err)
		return nil, err
	}

	return mtproto.BoolTrue, nil
}
