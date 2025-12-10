package core

import (
	"github.com/teamgram/proto/mtproto"
	"pwm-server/app/service/biz/dialog/dialog"

	"github.com/zeromicro/go-zero/core/jsonx"
)

// DialogGetDialogFilterBySlug
// dialog.getDialogFilterBySlug user_id:long slug:string = DialogFilterExt;
func (c *DialogCore) DialogGetDialogFilterBySlug(in *dialog.TLDialogGetDialogFilterBySlug) (*dialog.DialogFilterExt, error) {
	var (
		dialogFilter *dialog.DialogFilterExt
	)

	v, err := c.svcCtx.Dao.DialogFiltersDAO.SelectBySlug(c.ctx, in.UserId, in.Slug)
	if err != nil {
		c.Logger.Errorf("dialog.getDialogFilterBySlug - error: %v", err)
		return nil, err
	}

	if v == nil {
		c.Logger.Errorf("dialog.getDialogFilterBySlug - error: %v", err)
		return nil, mtproto.ErrInviteSlugEmpty
	} else {
		dialogFilter = &dialog.DialogFilterExt{
			Id:           v.DialogFilterId,
			JoinedBySlug: true,
			Slug:         in.Slug,
			DialogFilter: nil,
			Order:        v.OrderValue,
		}

		if err = jsonx.UnmarshalFromString(v.DialogFilter, &dialogFilter.DialogFilter); err != nil {
			c.Logger.Errorf("jsonx.UnmarshalFromString(%v) - error: %v", v, err)
			return nil, err
		}

		if dialogFilter.DialogFilter == nil {
			dialogFilter.DialogFilter = mtproto.MakeTLDialogFilter(nil).To_DialogFilter()
		}
	}

	return dialogFilter, nil
}
