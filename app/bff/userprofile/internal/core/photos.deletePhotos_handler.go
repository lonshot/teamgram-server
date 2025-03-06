package core

import (
	"github.com/teamgram/proto/mtproto"
	"pwm-server/app/messenger/sync/sync"
	userpb "pwm-server/app/service/biz/user/user"
	mediapb "pwm-server/app/service/media/media"
)

// PhotosDeletePhotos
// photos.deletePhotos#87cf7f2f id:Vector<InputPhoto> = Vector<long>;
func (c *UserProfileCore) PhotosDeletePhotos(in *mtproto.TLPhotosDeletePhotos) (*mtproto.Vector_Long, error) {
	var (
		photo        *mtproto.Photo
		deleteIdList = make([]int64, 0, len(in.GetId()))
	)

	for _, id := range in.GetId() {
		deleteIdList = append(deleteIdList, id.GetId())
	}

	// TODO: ALBUM_PHOTOS_TOO_MANY
	mainId, err := c.svcCtx.Dao.UserClient.UserDeleteProfilePhotos(c.ctx, &userpb.TLUserDeleteProfilePhotos{
		UserId: c.MD.UserId,
		Id:     deleteIdList,
	})
	if err != nil {
		c.Logger.Errorf("photos.deletePhotos - error: %v", err)
		return nil, err
	}

	if mainId.V != 0 {
		photo, err = c.svcCtx.Dao.MediaClient.MediaGetPhoto(c.ctx, &mediapb.TLMediaGetPhoto{
			PhotoId: mainId.V,
		})
		if err != nil {
			c.Logger.Errorf("photos.deletePhotos - error: %v", err)
			return nil, err
		}
	}

	if photo == nil {
		photo = mtproto.MakeTLPhotoEmpty(nil).To_Photo()
	}

	me, err := c.svcCtx.Dao.UserClient.UserGetImmutableUser(
		c.ctx,
		&userpb.TLUserGetImmutableUser{
			Id:       c.MD.UserId,
			Privacy:  false,
			Contacts: nil,
		})
	if err != nil {
		c.Logger.Errorf("photos.updateProfilePhoto - error: %v", err)
		return nil, err
	}

	c.svcCtx.Dao.SyncClient.SyncPushUpdates(c.ctx, &sync.TLSyncPushUpdates{
		UserId: c.MD.UserId,
		Updates: mtproto.MakeUpdatesByUpdatesUsers(
			[]*mtproto.User{me.ToSelfUser()},
			mtproto.MakeTLUpdateUser(&mtproto.Update{
				UserId: c.MD.UserId,
			}).To_Update()),
	})

	return &mtproto.Vector_Long{
		Datas: deleteIdList,
	}, nil
}
