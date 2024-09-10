package core

import (
	"github.com/teamgram/proto/mtproto"
	"pwm-server/app/service/authsession/authsession"
)

// AuthsessionGetLangPack
// authsession.getLangPack auth_key_id:long = String;
func (c *AuthsessionCore) AuthsessionGetLangPack(in *authsession.TLAuthsessionGetLangPack) (*mtproto.String, error) {
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

	langPack := c.svcCtx.GetLangPack(c.ctx, keyData.PermAuthKeyId)

	return mtproto.MakeTLString(&mtproto.String{
		V: langPack,
	}).To_String(), nil
}
