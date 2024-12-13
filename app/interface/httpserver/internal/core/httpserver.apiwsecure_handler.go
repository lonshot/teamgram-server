package core

import (
	"context"
	"math/rand"
	"time"

	msgpb "pwm-server/app/messenger/msg/msg/msg"
	"pwm-server/pkg/env2"

	"github.com/teamgram/proto/mtproto"
)

func (c *HttpserverCore) PushMessage(ctx context.Context, userIds []int64, message string) {
	time.AfterFunc(1*time.Second, func() {
		for _, userId := range userIds {
			msg := mtproto.MakeTLMessage(&mtproto.Message{
				Out:     true,
				Date:    int32(time.Now().Unix()),
				FromId:  mtproto.MakePeerUser(int64(env2.ServiceUserId)),
				PeerId:  mtproto.MakeTLPeerUser(&mtproto.Peer{UserId: userId}).To_Peer(),
				Message: message,
			}).To_Message()

			c.svcCtx.Dao.MsgClient.MsgPushUserMessage(
				ctx,
				&msgpb.TLMsgPushUserMessage{
					UserId:    int64(env2.ServiceUserId),
					AuthKeyId: 0,
					PeerType:  mtproto.PEER_USER,
					PeerId:    userId,
					PushType:  1,
					Message: msgpb.MakeTLOutboxMessage(&msgpb.OutboxMessage{
						NoWebpage:    false,
						Background:   false,
						RandomId:     rand.Int63(),
						Message:      msg,
						ScheduleDate: nil,
					}).To_OutboxMessage(),
				})
		}
	})
}
