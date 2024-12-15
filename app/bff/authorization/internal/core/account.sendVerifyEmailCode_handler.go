package core

import (
	"github.com/teamgram/proto/mtproto"
)

// AccountSendVerifyEmailCode
// account.sendVerifyEmailCode#98e037bb purpose:EmailVerifyPurpose email:string = account.SentEmailCode;
func (c *AuthorizationCore) AccountSendVerifyEmailCode(in *mtproto.TLAccountSendVerifyEmailCode) (*mtproto.Account_SentEmailCode, error) {
	// TODO: not impl
	c.Logger.Errorf("account.sendVerifyEmailCode blocked, License key from https://wb.playwith-me.com required to unlock enterprise features.")

	return nil, mtproto.ErrEnterpriseIsBlocked
}
