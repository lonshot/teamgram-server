package core

import (
	"context"
	"github.com/teamgram/marmota/pkg/stores/sqlx"
	"github.com/teamgram/proto/mtproto"
	"pwm-server/app/service/biz/dialog/dialog"
	"pwm-server/app/service/biz/dialog/internal/dal/dataobject"
	"github.com/zeromicro/go-zero/core/jsonx"
)

// DialogGetDialogFilter
// dialog.getDialogFilter user_id:long id:int = DialogFilterExt;
func (c *DialogCore) DialogGetDialogFilter(in *dialog.TLDialogGetDialogFilter) (*dialog.DialogFilterExt, error) {
	var (
		dialogFilterExtList []*dialog.DialogFilterExt
	)

	err := c.svcCtx.Dao.CachedConn.QueryRow(
		c.ctx,
		&dialogFilterExtList,
		dialog.GenDialogFilterCacheKey(in.UserId),
		func(ctx context.Context, conn *sqlx.DB, v interface{}) error {
			// vList :=
			var (
				vList []*dialog.DialogFilterExt
			)
			_, err := c.svcCtx.Dao.DialogFiltersDAO.SelectListWithCB(
				c.ctx,
				in.UserId,
				func(sz, i int, v *dataobject.DialogFiltersDO) {
					dialogFilter := &dialog.DialogFilterExt{
						Id:           v.DialogFilterId,
						DialogFilter: nil,
						Order:        v.OrderValue,
					}

					if err := jsonx.UnmarshalFromString(v.DialogFilter, &dialogFilter.DialogFilter); err != nil {
						c.Logger.Errorf("jsonx.UnmarshalFromString(%v) - error: %v", v, err)
						// continue
						return
					}

					if dialogFilter.DialogFilter == nil {
						dialogFilter.DialogFilter = mtproto.MakeTLDialogFilter(nil).To_DialogFilter()
					}

					vList = append(vList, dialogFilter)
				})
			if err != nil {
				return err
			}

			*v.(*[]*dialog.DialogFilterExt) = vList
			return err
		},
	)
	if err != nil {
		c.Logger.Errorf("dialog.getDialogFilter#2e24d924 - error: %v", err)
		return nil, err
	}

	for _, d := range dialogFilterExtList {
		if d.Id == in.Id {
			return d, nil
		}
	}

	return nil, mtproto.ErrFilterIdInvalid
}
