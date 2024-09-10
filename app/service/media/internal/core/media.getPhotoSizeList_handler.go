package core

import (
	"pwm-server/app/service/media/media"
)

// MediaGetPhotoSizeList
// media.getPhotoSizeList size_id:long = PhotoSizeList;
func (c *MediaCore) MediaGetPhotoSizeList(in *media.TLMediaGetPhotoSizeList) (*media.PhotoSizeList, error) {
	cData, err := c.svcCtx.Dao.GetCachePhotoData(c.ctx, in.GetSizeId())
	if err != nil {
		c.Logger.Errorf("media.getPhotoSizeList - error: %v", err)
		return nil, err
	}

	return cData.ToPhotoSizeList(), nil
}
