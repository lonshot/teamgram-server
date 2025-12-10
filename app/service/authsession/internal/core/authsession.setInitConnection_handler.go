package core

import (
	"github.com/teamgram/proto/mtproto"
	"pwm-server/app/service/authsession/authsession"
)

// AuthsessionSetInitConnection
// authsession.setInitConnection auth_key_id:long ip:string api_id:int device_model:string system_version:string app_version:string system_lang_code:string lang_pack:string lang_code:string proxy:string params:string = Bool;
func (c *AuthsessionCore) AuthsessionSetInitConnection(in *authsession.TLAuthsessionSetInitConnection) (*mtproto.Bool, error) {
	var (
		initConnection = in
		inKeyId        = in.GetAuthKeyId()
	)

	keyData, err := c.svcCtx.Dao.QueryAuthKeyV2(c.ctx, inKeyId)
	if err != nil {
		c.Logger.Errorf("setLayer - queryAuthKeyV2(%d) is error: %v", inKeyId, err)
		return nil, err
	} else if keyData.PermAuthKeyId == 0 {
		c.Logger.Errorf("queryAuthKeyV2(%d) - PermAuthKeyId is empty", inKeyId)
		return nil, mtproto.ErrAuthKeyPermEmpty
	}

	initConnection.AuthKeyId = keyData.PermAuthKeyId
	err = c.svcCtx.Dao.SetInitConnection(c.ctx, in)
	if err != nil {
		c.Logger.Errorf("setInitConnection(%d) is error: %v", inKeyId, err)
		return nil, err
	}

	return mtproto.BoolTrue, nil
}
