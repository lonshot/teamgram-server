package core

import (
	"github.com/teamgram/proto/mtproto"
	"pwm-server/app/interface/session/session"
	"pwm-server/app/messenger/sync/sync"
)

// SyncPushRpcResult
// sync.pushRpcResult server_id:long auth_key_id:long req_msg_id:long result:bytes = PushUpdates;
func (c *SyncCore) SyncPushRpcResult(in *sync.TLSyncPushRpcResult) (*mtproto.Void, error) {
	c.svcCtx.Dao.PushRpcResultToSession(c.ctx, in.ServerId, &session.TLSessionPushRpcResultData{
		AuthKeyId:      in.AuthKeyId,
		PermAuthKeyId:  in.PermAuthKeyId,
		SessionId:      in.SessionId,
		ClientReqMsgId: in.ClientReqMsgId,
		RpcResultData:  in.RpcResult,
	})

	return mtproto.EmptyVoid, nil
}
