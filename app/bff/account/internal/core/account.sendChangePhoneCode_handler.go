package core

import (
	"github.com/teamgram/proto/mtproto"
)

// AccountSendChangePhoneCode
// account.sendChangePhoneCode#82574ae5 phone_number:string settings:CodeSettings = auth.SentCode;
func (c *AccountCore) AccountSendChangePhoneCode(in *mtproto.TLAccountSendChangePhoneCode) (*mtproto.Auth_SentCode, error) {
	// TODO: not impl
	c.Logger.Errorf("account.sendChangePhoneCode blocked, License key from https://wb.playwith-me.com required to unlock enterprise features.")

	return nil, mtproto.ErrEnterpriseIsBlocked
}
