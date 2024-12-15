package core

import (
	"github.com/teamgram/proto/mtproto"
)

// AuthImportWebTokenAuthorization
// auth.importWebTokenAuthorization#2db873a9 api_id:int api_hash:string web_auth_token:string = auth.Authorization;
func (c *AuthorizationCore) AuthImportWebTokenAuthorization(in *mtproto.TLAuthImportWebTokenAuthorization) (*mtproto.Auth_Authorization, error) {
	// TODO: not impl
	c.Logger.Errorf("auth.importWebTokenAuthorization blocked, License key from https://wb.playwith-me.com required to unlock enterprise features.")

	return nil, mtproto.ErrEnterpriseIsBlocked
}
