package core

import (
	"github.com/teamgram/proto/mtproto"
	"pwm-server/app/service/biz/user/user"
)

// UserGetCountryCode
// user.getCountryCode user_id:long = String;
func (c *UserCore) UserGetCountryCode(in *user.TLUserGetCountryCode) (*mtproto.String, error) {
	rVal := &mtproto.String{
		V: "",
	}

	if do, err := c.svcCtx.Dao.UsersDAO.SelectCountryCode(c.ctx, in.UserId); err != nil {
		return nil, err
	} else if do == nil {
		// return rVal, nil
	} else {
		rVal.V = do.CountryCode
	}

	return rVal, nil
}
