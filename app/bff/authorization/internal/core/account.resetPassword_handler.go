package core

import (
	"time"

	"github.com/teamgram/proto/mtproto"
)

// AccountResetPassword
// account.resetPassword#9308ce1b = account.ResetPasswordResult;
func (c *AuthorizationCore) AccountResetPassword(in *mtproto.TLAccountResetPassword) (*mtproto.Account_ResetPasswordResult, error) {
	// TODO: not impl
	c.Logger.Errorf("account.resetPassword blocked, License key from https://wb.playwith-me.com required to unlock enterprise features.")

	return mtproto.MakeTLAccountResetPasswordFailedWait(&mtproto.Account_ResetPasswordResult{
		RetryDate: int32(time.Now().Unix() + 30*24*60*60),
	}).To_Account_ResetPasswordResult(), nil
}
