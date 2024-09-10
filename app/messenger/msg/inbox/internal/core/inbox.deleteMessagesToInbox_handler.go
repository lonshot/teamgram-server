package core

import (
	"context"
	"github.com/teamgram/proto/mtproto"
	"pwm-server/app/messenger/msg/inbox/inbox"
	"pwm-server/app/messenger/sync/sync"
)

// InboxDeleteMessagesToInbox
// inbox.deleteMessagesToInbox from_id:long id:Vector<int> = Void;
func (c *InboxCore) InboxDeleteMessagesToInbox(in *inbox.TLInboxDeleteMessagesToInbox) (*mtproto.Void, error) {
	c.svcCtx.Dao.DeleteInboxMessages(
		c.ctx,
		in.FromId,
		mtproto.MakePeerUtil(in.PeerType, in.PeerId),
		in.Id,
		func(ctx context.Context, userId int64, idList []int32) {
			c.svcCtx.Dao.SyncClient.SyncPushUpdates(ctx, &sync.TLSyncPushUpdates{
				UserId: userId,
				Updates: mtproto.MakeUpdatesByUpdates(mtproto.MakeTLUpdateDeleteMessages(&mtproto.Update{
					Messages:  idList,
					Pts_INT32: c.svcCtx.Dao.IDGenClient2.NextNPtsId(ctx, userId, len(idList)),
					PtsCount:  int32(len(idList)),
					PeerId:    mtproto.MakePeerUser(in.FromId),
				}).To_Update()),
			})
		})
	return mtproto.EmptyVoid, nil
}
