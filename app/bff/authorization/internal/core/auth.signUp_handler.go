package core

import (
	"context"
	"math/rand"

	"pwm-server/app/bff/authorization/internal/logic"
	"pwm-server/app/bff/authorization/internal/model"
	msgpb "pwm-server/app/messenger/msg/msg/msg"
	"pwm-server/app/service/authsession/authsession"
	userpb "pwm-server/app/service/biz/user/user"
	"pwm-server/pkg/phonenumber"

	"github.com/teamgram/marmota/pkg/threading2"
	"github.com/teamgram/proto/mtproto"
	"github.com/teamgram/proto/mtproto/crypto"
)

/*
  Android client auth.signUp#1b067634, handler error
	if (error.text.contains("PHONE_NUMBER_INVALID")) {
		needShowAlert(LocaleController.getString("AppName", R.string.AppName), LocaleController.getString("InvalidPhoneNumber", R.string.InvalidPhoneNumber));
	} else if (error.text.contains("PHONE_CODE_EMPTY") || error.text.contains("PHONE_CODE_INVALID")) {
		needShowAlert(LocaleController.getString("AppName", R.string.AppName), LocaleController.getString("InvalidCode", R.string.InvalidCode));
	} else if (error.text.contains("PHONE_CODE_EXPIRED")) {
		needShowAlert(LocaleController.getString("AppName", R.string.AppName), LocaleController.getString("CodeExpired", R.string.CodeExpired));
	} else if (error.text.contains("FIRSTNAME_INVALID")) {
		needShowAlert(LocaleController.getString("AppName", R.string.AppName), LocaleController.getString("InvalidFirstName", R.string.InvalidFirstName));
	} else if (error.text.contains("LASTNAME_INVALID")) {
		needShowAlert(LocaleController.getString("AppName", R.string.AppName), LocaleController.getString("InvalidLastName", R.string.InvalidLastName));
	} else {
		needShowAlert(LocaleController.getString("AppName", R.string.AppName), error.text);
	}

*/

// AuthSignUp
// auth.signUp#80eee427 phone_number:string phone_code_hash:string first_name:string last_name:string = auth.Authorization;
func (c *AuthorizationCore) AuthSignUp(in *mtproto.TLAuthSignUp) (*mtproto.Auth_Authorization, error) {
	if c.svcCtx.Plugin != nil {
		c.svcCtx.Plugin.OnAuthAction(c.ctx,
			c.MD.PermAuthKeyId,
			c.MD.ClientMsgId,
			c.MD.ClientAddr,
			in.PhoneNumber,
			logic.GetActionType(in),
			"auth.signUp")
	}

	// 1. check phone_code empty
	var (
		phoneCode *string = nil
	)

	// 3. check number
	// 3.1. empty
	if in.PhoneNumber == "" {
		c.Logger.Errorf("check phone_number error - empty")
		err := mtproto.ErrPhoneNumberInvalid
		return nil, err
	}

	// 3.2. check phone_number
	// 客户端发送的手机号格式为: "+86 111 1111 1111"，归一化
	// We need getRegionCode from phone_number
	pNumber, err := phonenumber.MakePhoneNumberHelper(in.PhoneNumber, "")
	if err != nil {
		c.Logger.Errorf("check phone_number error - %v", err)
		err = mtproto.ErrPhoneNumberInvalid
		return nil, err
	}
	phoneNumber := pNumber.GetNormalizeDigits()

	if in.PhoneCodeHash == "" {
		c.Logger.Errorf("check phone_code_hash error - empty")
		err = mtproto.ErrPhoneCodeHashEmpty
		return nil, err
	}

	// TODO(@benqi): register name ruler
	// check first name invalid
	if in.FirstName == "" {
		c.Logger.Errorf("check first_name error - empty")
		err = mtproto.ErrFirstnameInvalid
		return nil, err
	}

	// TODO(@benqi): PHONE_NUMBER_FLOOD
	// <string name="PhoneNumberFlood">Sorry, you have deleted and re-created your account too many times recently.
	//    Please wait for a few days before signing up again.</string>
	//

	////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	var (
		codeData *model.PhoneCodeTransaction
	)
	// phoneRegistered := auth.CheckPhoneNumberExist(phoneNumber)
	codeData, err = c.svcCtx.AuthLogic.DoAuthSignUp(c.ctx, c.MD.PermAuthKeyId, phoneNumber, phoneCode, in.PhoneCodeHash)
	if err != nil {
		c.Logger.Errorf(err.Error())
		return nil, err
	} else {
		_ = codeData
	}

	var (
		user *mtproto.ImmutableUser
	)

	key := crypto.CreateAuthKey()
	_, err = c.svcCtx.Dao.AuthsessionClient.AuthsessionSetAuthKey(c.ctx, &authsession.TLAuthsessionSetAuthKey{
		AuthKey: &mtproto.AuthKeyInfo{
			AuthKeyId:          key.AuthKeyId(),
			AuthKey:            key.AuthKey(),
			AuthKeyType:        mtproto.AuthKeyTypePerm,
			PermAuthKeyId:      key.AuthKeyId(),
			TempAuthKeyId:      0,
			MediaTempAuthKeyId: 0,
		},
		FutureSalt: nil,
	})

	if err != nil {
		c.Logger.Errorf("create user secret key error")
		err = mtproto.ErrInternalServerError
		return nil, err
	}

	var (
		firstName = in.FirstName
		lastName  = in.LastName
	)

	// Create new user
	if user, err = c.svcCtx.UserClient.UserCreateNewUser(c.ctx, &userpb.TLUserCreateNewUser{
		SecretKeyId: key.AuthKeyId(),
		Phone:       phoneNumber,
		CountryCode: pNumber.GetRegionCode(),
		FirstName:   firstName,
		LastName:    lastName,
	}); err != nil {
		c.Logger.Errorf("createNewUser error: %v", err)
		err = mtproto.ErrInternalServerError
		return nil, err
	}

	// TODO(@benqi): remove to createNewUser
	// user.Self = true

	// bind auth_key and user_id
	_, err = c.svcCtx.Dao.AuthsessionClient.AuthsessionBindAuthKeyUser(c.ctx, &authsession.TLAuthsessionBindAuthKeyUser{
		AuthKeyId: c.MD.PermAuthKeyId,
		UserId:    user.User.Id,
	})
	if err != nil {
		c.Logger.Errorf("bindAuthKeyUser error: %v", err)
		err = mtproto.ErrInternalServerError
		return nil, err
	}

	return threading2.WrapperGoFunc(
		c.ctx,
		mtproto.MakeTLAuthAuthorization(&mtproto.Auth_Authorization{
			SetupPasswordRequired: false,
			OtherwiseReloginDays:  nil,
			TmpSessions:           nil,
			FutureAuthToken:       nil,
			User:                  user.ToSelfUser(),
		}).To_Auth_Authorization(),
		func(ctx context.Context) {
			// on event
			c.svcCtx.AuthLogic.DeletePhoneCode(ctx, c.MD.PermAuthKeyId, phoneNumber, in.PhoneCodeHash)
			// c.pushSignInMessage(ctx, user.Id(), codeData.PhoneCode)
			c.onContactSignUp(ctx, c.MD.PermAuthKeyId, user.Id(), phoneNumber)
		},
	).(*mtproto.Auth_Authorization), nil
}

func (c *AuthorizationCore) onContactSignUp(ctx context.Context, authKeyId, userId int64, phone string) {
	importers, _ := c.svcCtx.Dao.UserClient.UserGetImportersByPhone(ctx, &userpb.TLUserGetImportersByPhone{
		Phone: phone,
	})

	for _, c2 := range importers.GetDatas() {
		c.Logger.Infof("importer: %v", c2)
		v, _ := c.svcCtx.Dao.UserClient.UserGetContactSignUpNotification(ctx, &userpb.TLUserGetContactSignUpNotification{
			UserId: c2.ClientId,
		})

		_ = authKeyId
		if mtproto.FromBool(v) {
			c.svcCtx.Dao.MsgClient.MsgPushUserMessage(
				context.Background(),
				&msgpb.TLMsgPushUserMessage{
					UserId:    userId,
					AuthKeyId: 0,
					PeerType:  mtproto.PEER_USER,
					PeerId:    c2.ClientId,
					PushType:  1,
					Message: msgpb.MakeTLOutboxMessage(&msgpb.OutboxMessage{
						NoWebpage:    false,
						Background:   false,
						RandomId:     rand.Int63(),
						Message:      mtproto.MakeContactSignUpMessage(userId, c2.ClientId),
						ScheduleDate: nil,
					}).To_OutboxMessage(),
				})
		} else {
			c.Logger.Infof("not setting contactSignUpNotification")
		}
	}
	c.svcCtx.Dao.UserClient.UserDeleteImportersByPhone(ctx, &userpb.TLUserDeleteImportersByPhone{
		Phone: phone,
	})
}
