package core

import (
	"github.com/teamgram/proto/mtproto"
)

// AccountConfirmPhone
// account.confirmPhone#5f2178c3 phone_code_hash:string phone_code:string = Bool;
func (c *AccountCore) AccountConfirmPhone(in *mtproto.TLAccountConfirmPhone) (*mtproto.Bool, error) {
	// TODO: not impl
	c.Logger.Errorf("account.confirmPhone blocked, License key from https://teamgram.net required to unlock enterprise features.")

	return nil, mtproto.ErrEnterpriseIsBlocked
}
