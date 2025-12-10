package core

import (
	"fmt"

	"github.com/teamgram/proto/mtproto"
	"pwm-server/app/interface/session/session"
)

// SessionPushSessionUpdatesData
// session.pushSessionUpdatesData auth_key_id:long session_id:long updates:Updates = Bool;
func (c *SessionCore) SessionPushSessionUpdatesData(in *session.TLSessionPushSessionUpdatesData) (*mtproto.Bool, error) {
	mainAuth := c.svcCtx.MainAuthMgr.GetMainAuthWrapper(in.PermAuthKeyId)
	if mainAuth == nil {
		err := fmt.Errorf("not found authKeyId(%d)", in.PermAuthKeyId)
		c.Logger.Errorf("session.pushSessionUpdatesData - %v", err)
		return nil, err
	}
	mainAuth.SyncSessionDataArrived(c.ctx, in.AuthKeyId, in.SessionId, in.Updates)

	return mtproto.BoolTrue, nil
}
