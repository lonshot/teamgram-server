package core

import (
	"fmt"

	"github.com/teamgram/proto/mtproto"
	"pwm-server/app/interface/session/session"
)

// SessionPushUpdatesData
// session.pushUpdatesData flags:# auth_key_id:long notification:flags.0?true updates:Updates = Bool;
func (c *SessionCore) SessionPushUpdatesData(in *session.TLSessionPushUpdatesData) (*mtproto.Bool, error) {
	mainAuth := c.svcCtx.MainAuthMgr.GetMainAuthWrapper(in.PermAuthKeyId)
	if mainAuth == nil {
		err := fmt.Errorf("not found authKeyId(%d)", in.PermAuthKeyId)
		c.Logger.Errorf("session.pushUpdatesData - %v", err)
		return nil, err
	}
	mainAuth.SyncDataArrived(c.ctx, in.Notification, in.Updates)

	return mtproto.BoolTrue, nil
}
