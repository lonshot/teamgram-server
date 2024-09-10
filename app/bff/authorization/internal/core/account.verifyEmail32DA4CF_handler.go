package core

import (
	"github.com/teamgram/proto/mtproto"
)

// AccountVerifyEmail32DA4CF
// account.verifyEmail#32da4cf purpose:EmailVerifyPurpose verification:EmailVerification = account.EmailVerified;
func (c *AuthorizationCore) AccountVerifyEmail32DA4CF(in *mtproto.TLAccountVerifyEmail32DA4CF) (*mtproto.Account_EmailVerified, error) {
	// TODO: not impl
	c.Logger.Errorf("account.verifyEmail32DA4CF blocked, License key from https://teamgram.net required to unlock enterprise features.")

	return nil, mtproto.ErrEnterpriseIsBlocked
}
