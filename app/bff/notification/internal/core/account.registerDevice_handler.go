package core

import (
	"github.com/teamgram/proto/mtproto"
	"pwm-server/app/bff/notification/internal/dataobject"
)
import (
	"strconv"
	"strings"
)

func (c *NotificationCore) AccountRegisterDevice(in *mtproto.TLAccountRegisterDevice) (*mtproto.Bool, error) {
	// Validate required input parameters
	if in.Token == "" {
		c.Logger.Errorf("account.registerDevice - invalid token, token cannot be empty")
		return nil, mtproto.ErrInputRequestInvalid
	}

	// Prepare default values for optional fields
	var appSandbox bool
	if in.AppSandbox != nil {
		appSandbox = mtproto.FromBool(in.AppSandbox) // GetValue extracts the boolean value if it's a proto Bool object
	} else {
		appSandbox = false // Default value for AppSandbox if not provided
	}

	var otherUidsStr string
	if len(in.OtherUids) > 0 {
		// Convert the slice of int64 (OtherUids) to a comma-separated string
		otherUidsStr = int64SliceToString(in.OtherUids)
	} else {
		otherUidsStr = "" // Default to an empty string if OtherUids is not provided
	}

	// Create the data object to be inserted or updated in the database
	deviceDO := &dataobject.DevicesDO{
		AuthKeyId:  c.MD.PermAuthKeyId, // Assuming PermAuthKeyId is the correct field from MD for AuthKeyId
		UserId:     c.MD.UserId,
		TokenType:  in.TokenType,
		Token:      in.Token,
		AppSandbox: appSandbox,
		Secret:     string(in.Secret), // Convert the []byte secret to a string
		OtherUids:  otherUidsStr,
		NoMuted:    in.NoMuted,
		State:      0, // Default state
	}

	// Insert or update the device in the database using the DAO
	_, _, err := c.svcCtx.Dao.DevicesDAO.InsertOrUpdate(c.ctx, deviceDO)
	if err != nil {
		c.Logger.Errorf("account.registerDevice - error while inserting or updating device: %v", err)
		return nil, mtproto.ErrInternalServerError
	}

	// Successfully registered the device
	return mtproto.BoolTrue, nil
}

// Helper function to convert a slice of int64 to a comma-separated string
func int64SliceToString(uids []int64) string {
	var strUids []string
	for _, uid := range uids {
		strUids = append(strUids, strconv.FormatInt(uid, 10))
	}
	return strings.Join(strUids, ",")
}
