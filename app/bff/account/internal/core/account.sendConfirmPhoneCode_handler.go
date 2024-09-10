package core

import (
	"github.com/teamgram/proto/mtproto"
)

// AccountSendConfirmPhoneCode
// account.sendConfirmPhoneCode#1b3faa88 hash:string settings:CodeSettings = auth.SentCode;
func (c *AccountCore) AccountSendConfirmPhoneCode(in *mtproto.TLAccountSendConfirmPhoneCode) (*mtproto.Auth_SentCode, error) {
	// TODO: not impl
	c.Logger.Errorf("account.sendConfirmPhoneCode blocked, License key from https://teamgram.net required to unlock enterprise features.")

	return nil, mtproto.ErrEnterpriseIsBlocked
}
