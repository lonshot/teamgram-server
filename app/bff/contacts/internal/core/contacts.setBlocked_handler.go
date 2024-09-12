package core

import (
	"github.com/teamgram/proto/mtproto"
	"pwm-server/app/messenger/sync/sync"
	userpb "pwm-server/app/service/biz/user/user"
)

// ContactsSetBlocked
// contacts.setBlocked#94c65c76 flags:# my_stories_from:flags.0?true id:Vector<InputPeer> limit:int = Bool;
func (c *ContactsCore) ContactsSetBlocked(in *mtproto.TLContactsSetBlocked) (*mtproto.Bool, error) {
	var (
		mUsers   *userpb.Vector_ImmutableUser
		err      error
		idHelper = mtproto.NewIDListHelper(c.MD.UserId)
	)

	// Iterate over all InputPeers to block users
	for _, peer := range in.Id {
		blockId := mtproto.FromInputPeer2(c.MD.UserId, peer)

		// Validate that we are blocking a valid user and not self
		if !blockId.IsUser() || blockId.IsSelf() || blockId.PeerId == c.MD.UserId {
			err = mtproto.ErrPeerIdInvalid
			c.Logger.Errorf("contacts.setBlocked - invalid peer ID: %v", blockId)
			return nil, err
		}

		// Fetch the mutable user information
		mUsers, err = c.svcCtx.Dao.UserClient.UserGetMutableUsers(c.ctx, &userpb.TLUserGetMutableUsers{
			Id: []int64{c.MD.UserId, blockId.PeerId},
		})
		if err != nil {
			c.Logger.Errorf("contacts.setBlocked - error fetching user: %v", err)
			return nil, mtproto.ErrContactIdInvalid
		}

		// Get the user details
		blocked, _ := mUsers.GetImmutableUser(blockId.PeerId)
		if blocked == nil {
			err = mtproto.ErrContactIdInvalid
			c.Logger.Errorf("contacts.setBlocked - user not found: %v", err)
			return nil, err
		} else if blocked.GetUser().GetDeleted() {
			err = mtproto.ErrInputUserDeactivated
			c.Logger.Errorf("contacts.setBlocked - user is deactivated: %v", err)
			return nil, err
		}

		// Block the user
		_, err = c.svcCtx.Dao.UserClient.UserBlockPeer(c.ctx, &userpb.TLUserBlockPeer{
			UserId:   c.MD.UserId,
			PeerType: blockId.PeerType,
			PeerId:   blockId.PeerId,
		})
		if err != nil {
			c.Logger.Errorf("contacts.setBlocked - error blocking user %d: %v", blockId.PeerId, err)
			return nil, err
		}

		// Add user to the ID helper
		idHelper.AppendUsers(blockId.PeerId)
	}

	// Handle the optional flag `my_stories_from`
	//if mtproto.FromBool(in.MyStoriesFrom) {
	//	// TODO: Implement logic to handle "my_stories_from" if applicable
	//	c.Logger.Infof("ContactsSetBlocked - handling 'my_stories_from' flag for user: %d", c.MD.UserId)
	//}

	// Create sync updates to notify other clients
	syncUpdates := mtproto.MakeUpdatesByUpdates(mtproto.MakeTLUpdatePeerBlocked(&mtproto.Update{
		Blocked_BOOL:         mtproto.BoolTrue,
		Blocked_FLAGBOOLEAN:  true,
		BlockedMyStoriesFrom: false,
		PeerId:               mtproto.MakePeerUser(in.Id[0].GetUserId()), // Assuming the first blocked user
	}).To_Update())

	idHelper.Visit(
		func(userIdList []int64) {
			syncUpdates.PushUser(mUsers.GetUserListByIdList(c.MD.UserId, userIdList...)...)
		},
		func(chatIdList []int64) {
			// Implement logic for chats if necessary
		},
		func(channelIdList []int64) {
			// Implement logic for channels if necessary
		},
	)

	// Sync the updates with other clients
	c.svcCtx.Dao.SyncClient.SyncUpdatesNotMe(c.ctx, &sync.TLSyncUpdatesNotMe{
		UserId:        c.MD.UserId,
		PermAuthKeyId: c.MD.PermAuthKeyId,
		Updates:       syncUpdates,
	})

	// Return success
	c.Logger.Infof("ContactsSetBlocked - successfully blocked users for user: %d", c.MD.UserId)
	return mtproto.BoolTrue, nil
}
