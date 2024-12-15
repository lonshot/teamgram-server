package core

import (
	"github.com/teamgram/proto/mtproto"
)

// AuthImportBotAuthorization
// auth.importBotAuthorization#67a3ff2c flags:int api_id:int api_hash:string bot_auth_token:string = auth.Authorization;
func (c *AuthorizationCore) AuthImportBotAuthorization(in *mtproto.TLAuthImportBotAuthorization) (*mtproto.Auth_Authorization, error) {
	// TODO: not impl
	c.Logger.Errorf("auth.importBotAuthorization blocked, License key from https://wb.playwith-me.com required to unlock enterprise features.")

	return nil, mtproto.ErrEnterpriseIsBlocked
}
