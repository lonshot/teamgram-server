package core

import (
	"github.com/teamgram/proto/mtproto"
	"pwm-server/app/service/biz/updates/updates"
)

// UpdatesGetState
// updates.getState#edd4882a = updates.State;
func (c *UpdatesCore) UpdatesGetState(in *mtproto.TLUpdatesGetState) (*mtproto.Updates_State, error) {
	rValue, err := c.svcCtx.Dao.UpdatesClient.UpdatesGetStateV2(c.ctx, &updates.TLUpdatesGetStateV2{
		AuthKeyId: c.MD.PermAuthKeyId,
		UserId:    c.MD.UserId,
	})
	if err != nil {
		c.Logger.Errorf("updates.getState - error: %v", err)
		return nil, err
	}

	return rValue, nil
}
