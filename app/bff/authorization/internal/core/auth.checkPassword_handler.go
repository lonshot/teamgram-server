package core

import (
	userpb "pwm-server/app/service/biz/user/user"

	"github.com/teamgram/proto/mtproto"
)

// AuthCheckPassword
// auth.checkPassword#d18b4d16 password:InputCheckPasswordSRP = auth.Authorization;
func (c *AuthorizationCore) AuthCheckPassword(in *mtproto.TLAuthCheckPassword) (*mtproto.Auth_Authorization, error) {
	// TODO: check password
	c.Logger.Errorf("auth.checkPassword blocked, License key from https://wb.playwith-me.com required to unlock enterprise features.")

	user, err := c.svcCtx.UserClient.UserGetImmutableUser(c.ctx, &userpb.TLUserGetImmutableUser{
		Id: c.MD.UserId,
	})
	if err != nil {
		c.Logger.Errorf("auth.checkPassword - error: %v", err)
		return nil, err
	}

	return mtproto.MakeTLAuthAuthorization(&mtproto.Auth_Authorization{
		SetupPasswordRequired: false,
		OtherwiseReloginDays:  nil,
		TmpSessions:           nil,
		FutureAuthToken:       nil,
		User:                  user.ToSelfUser(),
	}).To_Auth_Authorization(), nil
}
