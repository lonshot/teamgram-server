package core

import (
	"pwm-server/app/service/media/media"
)

// MediaGetVideoSizeList
// media.getVideoSizeList size_id = VideoSizeList;
func (c *MediaCore) MediaGetVideoSizeList(in *media.TLMediaGetVideoSizeList) (*media.VideoSizeList, error) {
	cData, err := c.svcCtx.Dao.GetCachePhotoData(c.ctx, in.GetSizeId())
	if err != nil {
		c.Logger.Errorf("media.getVideoSizeList - error: %v", err)
		return nil, err
	}

	return cData.ToVideoSizeList(), nil
}
