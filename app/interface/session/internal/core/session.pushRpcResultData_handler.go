package core

import (
	"fmt"

	"github.com/teamgram/proto/mtproto"
	"pwm-server/app/interface/session/session"
)

// SessionPushRpcResultData
// session.pushRpcResultData auth_key_id:long session_id:long client_req_msg_id:long rpc_result_data:bytes = Bool;
func (c *SessionCore) SessionPushRpcResultData(in *session.TLSessionPushRpcResultData) (*mtproto.Bool, error) {
	mainAuth := c.svcCtx.MainAuthMgr.GetMainAuthWrapper(in.PermAuthKeyId)
	if mainAuth == nil {
		err := fmt.Errorf("not found authKeyId(%d)", in.PermAuthKeyId)
		c.Logger.Errorf("session.pushRpcResultData - %v", err)
		return nil, err
	}
	mainAuth.SyncRpcResultDataArrived(c.ctx, in.AuthKeyId, in.SessionId, in.ClientReqMsgId, in.RpcResultData)

	return mtproto.BoolTrue, nil
}
