package core

import (
	"strconv"

	"github.com/teamgram/proto/mtproto"
	"pwm-server/app/service/status/status"
)

// StatusSetSessionOffline
// status.setSessionOffline online:SessionEntry = Bool;
func (c *StatusCore) StatusSetSessionOffline(in *status.TLStatusSetSessionOffline) (*mtproto.Bool, error) {
	_, err := c.svcCtx.Dao.KV.HdelCtx(
		c.ctx,
		getUserKey(in.GetUserId()),
		strconv.FormatInt(in.GetAuthKeyId(), 10))
	if err != nil {
		c.Logger.Errorf("status.setSessionOffline(%s) error(%v)", in, err)
		return nil, err
	}

	return mtproto.BoolTrue, nil
}
