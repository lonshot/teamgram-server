package core

import (
	// "github.com/teamgram/marmota/pkg/container2"
	"github.com/teamgram/proto/mtproto"
	"pwm-server/app/messenger/sync/sync"
	// channelpb "pwm-server/app/service/biz/channel/channel"
	chatpb "pwm-server/app/service/biz/chat/chat"
)

// SyncBroadcastUpdates
// sync.broadcastUpdates broadcast_type:int chat_id:long exclude_id_list:Vector<long> updates:Updates = Void;
func (c *SyncCore) SyncBroadcastUpdates(in *sync.TLSyncBroadcastUpdates) (*mtproto.Void, error) {
	pushUpdates := &sync.TLSyncPushUpdates{
		UserId:  0,
		Updates: in.Updates,
	}

	if in.BroadcastType != sync.BroadcastTypeChat {
		c.Logger.Errorf("invalid broadcast_type: %s", in)
		return mtproto.EmptyVoid, nil
	}

	idList, _ := c.svcCtx.Dao.ChatClient.ChatGetChatParticipantIdList(c.ctx, &chatpb.TLChatGetChatParticipantIdList{
		ChatId: in.ChatId,
	})

	for _, id := range idList.GetDatas() {
		pushUpdates.UserId = id
		c.SyncPushUpdates(pushUpdates)
	}

	return mtproto.EmptyVoid, nil
}
