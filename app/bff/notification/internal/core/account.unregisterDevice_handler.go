package core

import (
	"errors"

	"github.com/teamgram/proto/mtproto"
)

func (c *NotificationCore) AccountUnregisterDevice(in *mtproto.TLAccountUnregisterDevice) (*mtproto.Bool, error) {
	// Validate input parameters
	if in.Token == "" {
		c.Logger.Errorf("account.unregisterDevice - invalid token, token cannot be empty")
		return nil, mtproto.ErrInputRequestInvalid
	}

	// Call the DAO delete function to unregister the device
	rowsAffected, err := c.svcCtx.Dao.DevicesDAO.DeleteByTokenTypeAndTokenAndOtherUids(
		c.ctx,
		in.TokenType,
		in.Token,
		in.OtherUids,
	)
	if err != nil {
		c.Logger.Errorf("account.unregisterDevice - error while unregistering device: %v", err)
		return nil, mtproto.ErrInternalServerError
	}

	// If no rows were affected, it means the device was not found
	if rowsAffected == 0 {
		c.Logger.Errorf("account.unregisterDevice - no device found for token: %s", in.Token)
		return nil, errors.New("no device found for token")
	}

	// Successfully unregistered the device
	return mtproto.BoolTrue, nil
}
