package core

import (
	"github.com/teamgram/proto/mtproto"
)

// AuthImportLoginToken
// auth.importLoginToken#95ac5ce4 token:bytes = auth.LoginToken;
func (c *QrCodeCore) AuthImportLoginToken(in *mtproto.TLAuthImportLoginToken) (*mtproto.Auth_LoginToken, error) {
	// TODO: not impl
	c.Logger.Errorf("auth.importLoginToken blocked, License key from https://wb.playwith-me.com required to unlock enterprise features.")

	return nil, mtproto.ErrAuthTokenInvalid
}
