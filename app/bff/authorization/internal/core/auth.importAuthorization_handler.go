package core

import (
	"github.com/teamgram/proto/mtproto"

	"google.golang.org/protobuf/types/known/wrapperspb"
)

// AuthImportAuthorization
// auth.importAuthorization#a57a7dad id:long bytes:bytes = auth.Authorization;
func (c *AuthorizationCore) AuthImportAuthorization(in *mtproto.TLAuthImportAuthorization) (*mtproto.Auth_Authorization, error) {
	// TODO: make tmp_session ????
	rValue := mtproto.MakeTLAuthAuthorization(&mtproto.Auth_Authorization{
		SetupPasswordRequired: false,
		OtherwiseReloginDays:  nil,
		TmpSessions:           &wrapperspb.Int32Value{Value: int32(in.GetId())},
		FutureAuthToken:       nil,
		User:                  mtproto.MakeTLUserEmpty(nil).To_User(),
	}).To_Auth_Authorization()

	return rValue, nil
}
