package core

import (
	"github.com/teamgram/proto/mtproto"
	"pwm-server/app/messenger/sync/sync"
)

// SyncUpdatesNotMe
// sync.updatesNotMe user_id:long auth_key_id:long updates:Updates = Void;
func (c *SyncCore) SyncUpdatesNotMe(in *sync.TLSyncUpdatesNotMe) (*mtproto.Void, error) {
	var (
		userId    = in.GetUserId()
		authKeyId = in.GetPermAuthKeyId()
		updates   = in.GetUpdates()
	)

	notification, err := c.processUpdates(syncTypeUserNotMe, userId, false, updates)
	if err != nil {
		c.Logger.Errorf("sync.updatesNotMe - error: %v", err)
		return nil, err
	}

	c.pushUpdatesToSession(syncTypeUserNotMe, userId, authKeyId, nil, nil, nil, updates, notification)

	return mtproto.EmptyVoid, nil
}
