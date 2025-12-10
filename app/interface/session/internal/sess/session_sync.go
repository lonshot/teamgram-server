package sess

import (
	"context"

	"github.com/teamgram/proto/mtproto"

	"github.com/zeromicro/go-zero/core/logx"
)

func (c *session) onSyncData(ctx context.Context, obj mtproto.TLObject) {
	// for android, obj maybe is nil
	if obj != nil {
		logx.WithContext(ctx).Infof("session]]>> - session: %s, syncData: %s", c, obj)
	} else {
		logx.WithContext(ctx).Infof("session]]>> - session: %s, syncData: nil", c)
	}

	gatewayId := c.getGatewayId()

	if c.isAndroidPush {
		pusMsgId := c.sessList.cb.getNextNotifyId()
		c.sendPushToQueue(ctx, gatewayId, pusMsgId, androidPushTooLong)
	} else {
		pusMsgId := c.sessList.cb.getNextPushId()
		c.sendPushToQueue(ctx, gatewayId, pusMsgId, obj)
	}

	if c.sessionOnline() {
		if gatewayId == "" {
			logx.WithContext(ctx).Errorf("gatewayId is empty, send delay...")
		} else {
			c.sendQueueToGateway(ctx, gatewayId)
		}
	}
}

func (c *session) onSyncRpcResultData(ctx context.Context, reqMsgId int64, data []byte) {
	// TODO(@benqi):
	// log.Debugf("genericSession]]>> - %v", cntl)
	c.pendingQueue.Remove(reqMsgId)
	gatewayId := c.getGatewayId()
	c.sendPushRpcResultToQueue(gatewayId, reqMsgId, data)
}

func (c *session) onSyncSessionData(ctx context.Context, obj mtproto.TLObject) {
	// TODO(@benqi):
	gatewayId := c.getGatewayId()
	pusMsgId := c.sessList.cb.getNextPushId()

	c.sendPushToQueue(ctx, gatewayId, pusMsgId, obj)
	c.sendQueueToGateway(ctx, gatewayId)
}
