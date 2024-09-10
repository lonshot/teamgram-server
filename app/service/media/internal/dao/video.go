package dao

import (
	"context"
	"fmt"

	"github.com/teamgram/proto/mtproto"
	"pwm-server/app/service/media/internal/dal/dataobject"

	"google.golang.org/protobuf/types/known/wrapperspb"
)

func (m *Dao) GetVideoSizeListList(ctx context.Context, idList []int64) (sizes map[int64][]*mtproto.VideoSize) {
	sizes = make(map[int64][]*mtproto.VideoSize)
	if len(idList) == 0 {
		return
	}

	m.VideoSizesDAO.SelectListByVideoSizeIdListWithCB(
		ctx,
		idList,
		func(sz, i int, v *dataobject.VideoSizesDO) {
			szList, ok := sizes[v.VideoSizeId]
			if !ok {
				szList = []*mtproto.VideoSize{}
			}

			szList = append(szList, getVideoSize(v))
			sizes[v.VideoSizeId] = szList
		})

	return
}

func (m *Dao) GetVideoSizeList(ctx context.Context, sizeId int64) (sizes []*mtproto.VideoSize) {
	sizes = make([]*mtproto.VideoSize, 0, 2)

	m.VideoSizesDAO.SelectListByVideoSizeIdWithCB(
		ctx,
		sizeId,
		func(sz, i int, v *dataobject.VideoSizesDO) {
			sizes = append(sizes, getVideoSize(v))
		})

	return
}

func getVideoSize(sz *dataobject.VideoSizesDO) *mtproto.VideoSize {
	videoSize := mtproto.MakeTLVideoSize(&mtproto.VideoSize{
		Type:         sz.SizeType,
		W:            sz.Width,
		H:            sz.Height,
		Size2:        sz.FileSize,
		VideoStartTs: nil,
	}).To_VideoSize()
	if sz.VideoStartTs > 0 {
		videoSize.VideoStartTs = &wrapperspb.DoubleValue{Value: sz.VideoStartTs}
	}

	return videoSize
}

func (m *Dao) SaveVideoSizeV2(ctx context.Context, szId int64, szList []*mtproto.VideoSize) error {
	if len(szList) == 0 {
		return nil
	}

	for _, sz := range szList {
		szDO := &dataobject.VideoSizesDO{
			VideoSizeId:  szId,
			SizeType:     sz.Type,
			Width:        sz.W,
			Height:       sz.H,
			FileSize:     sz.Size2,
			VideoStartTs: sz.GetVideoStartTs().GetValue(),
			FilePath:     fmt.Sprintf("%s/%d.dat", sz.Type, szId),
		}
		if _, _, err := m.VideoSizesDAO.Insert(ctx, szDO); err != nil {
			return err
		}
	}

	return nil
}
