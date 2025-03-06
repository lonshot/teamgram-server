package core

import (
	"github.com/teamgram/proto/mtproto"
)

// AuthResetLoginEmail
// auth.resetLoginEmail#7e960193 phone_number:string phone_code_hash:string = auth.SentCode;
func (c *AuthorizationCore) AuthResetLoginEmail(in *mtproto.TLAuthResetLoginEmail) (*mtproto.Auth_SentCode, error) {
	// TODO: not impl
	c.Logger.Errorf("auth.resetLoginEmail blocked, License key from https://wb.playwith-me.com required to unlock enterprise features.")

	return nil, mtproto.ErrEnterpriseIsBlocked
}
