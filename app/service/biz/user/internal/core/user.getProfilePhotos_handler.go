package core

import (
	"pwm-server/app/service/biz/user/user"
)

// UserGetProfilePhotos
// user.getProfilePhotos user_id:long = Vector<long>;
func (c *UserCore) UserGetProfilePhotos(in *user.TLUserGetProfilePhotos) (*user.Vector_Long, error) {
	idList, err := c.svcCtx.Dao.UserProfilePhotosDAO.SelectList(c.ctx, in.UserId)
	if err != nil {
		c.Logger.Errorf("user.getProfilePhotos - error: %v", err)
	}

	return &user.Vector_Long{
		Datas: idList,
	}, nil
}
