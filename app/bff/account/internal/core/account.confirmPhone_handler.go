package core

import (
	"github.com/teamgram/proto/mtproto"
)

// AccountConfirmPhone
// account.confirmPhone#5f2178c3 phone_code_hash:string phone_code:string = Bool;
func (c *AccountCore) AccountConfirmPhone(in *mtproto.TLAccountConfirmPhone) (*mtproto.Bool, error) {
	c.Logger.Errorf("account.changePhone blocked, License key from https://wb.playwith-me.com required to unlock enterprise features.")

	return nil, mtproto.ErrEnterpriseIsBlocked
	//
	//// Check if the phone code or phone code hash is empty
	//if phoneCode == "" {
	//	c.Logger.Errorf("Phone code is empty")
	//	return nil, error_types.ErrPhoneCodeEmpty
	//}
	//
	//if phoneCodeHash == "" {
	//	c.Logger.Errorf("Phone code hash is empty")
	//	return nil, error_types.ErrPhoneCodeInvalid
	//}
	//
	//// Step 1: Retrieve the stored phone_code and expiration time using the phone_code_hash
	//storedCode, expirationTime, err := c.svcCtx.Dao.GetPhoneCodeByHash(c.ctx, phoneCodeHash)
	//if err != nil {
	//	c.Logger.Errorf("Failed to retrieve phone code: %v", err)
	//	return nil, error_types.ErrInternalServerError
	//}
	//
	//// Step 2: Check if the phone code hash has expired
	//if time.Now().After(expirationTime) {
	//	c.Logger.Errorf("Phone code has expired: %s", phoneCodeHash)
	//	return nil, error_types.ErrPhoneCodeInvalid
	//}
	//
	//// Step 3: Compare the provided phone code with the stored code
	//if phoneCode != storedCode {
	//	c.Logger.Errorf("Invalid phone code: provided=%s, expected=%s", phoneCode, storedCode)
	//	return nil, error_types.ErrPhoneCodeInvalid
	//}
	//
	//// Step 4: Confirm the phone number by updating the user's account status
	//userID := c.MD.GetUserId() // Assuming you can retrieve userID from metadata
	//err = c.svcCtx.Dao.ConfirmPhoneNumber(c.ctx, userID, phoneCodeHash)
	//if err != nil {
	//	c.Logger.Errorf("Failed to confirm phone number: %v", err)
	//	return nil, error_types.ErrInternalServerError
	//}
	//
	//// Step 5: Return success
	//c.Logger.Infof("Phone number confirmed successfully for phone_code_hash: %s", phoneCodeHash)
	//return mtproto.ToBool(true), nil
}
