package core

import (
	"github.com/teamgram/proto/mtproto"
	"pwm-server/app/service/biz/code/code"
)

// CodeUpdatePhoneCodeData
// code.updatePhoneCodeData auth_key_id:long phone:string phone_code_hash:string code_data:PhoneCodeTransaction = Bool;
func (c *CodeCore) CodeUpdatePhoneCodeData(in *code.TLCodeUpdatePhoneCodeData) (*mtproto.Bool, error) {
	if err := c.svcCtx.Dao.PutCachePhoneCode(c.ctx, in.AuthKeyId, in.PhoneCodeHash, in.CodeData); err != nil {
		c.Logger.Errorf("code.updatePhoneCodeData - error: %v", err)
		return nil, mtproto.ErrInternalServerError
	}

	return mtproto.BoolTrue, nil
}
