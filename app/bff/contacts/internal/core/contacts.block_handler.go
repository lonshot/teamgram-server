package core

import (
	"github.com/teamgram/proto/mtproto"
	"pwm-server/app/messenger/sync/sync"
	userpb "pwm-server/app/service/biz/user/user"
)

// ContactsBlock
// contacts.block#2e2e8734 flags:# my_stories_from:flags.0?true id:InputPeer = Bool;
func (c *ContactsCore) ContactsBlock(in *mtproto.TLContactsBlock) (*mtproto.Bool, error) {
	var (
		err    error
		mUsers *userpb.Vector_ImmutableUser

		blockId  = mtproto.FromInputPeer2(c.MD.UserId, in.GetId())
		idHelper = mtproto.NewIDListHelper(c.MD.UserId)
	)

	if !blockId.IsUser() || blockId.IsSelf() {
		err = mtproto.ErrPeerIdInvalid
		c.Logger.Errorf("contacts.block - error: %v", err)
		return nil, err
	}

	if blockId.PeerId == c.MD.UserId {
		err = mtproto.ErrContactIdInvalid
		c.Logger.Errorf("contacts.block - error: %v", err)
		return nil, err
	}

	// TODO
	/*
		auto BlockPeerBoxController::createRow(not_null<History*> history)
		-> std::unique_ptr<BlockPeerBoxController::Row> {
			if (!history->peer->isUser()
				|| history->peer->isServiceUser()
				|| history->peer->isSelf()
				|| history->peer->isRepliesChat()) {
				return nullptr;
			}
			auto row = std::make_unique<Row>(history);
			updateIsBlocked(row.get(), history->peer);
			return row;
		}
	*/

	mUsers, err = c.svcCtx.Dao.UserClient.UserGetMutableUsers(c.ctx, &userpb.TLUserGetMutableUsers{
		Id: []int64{c.MD.UserId, blockId.PeerId},
	})

	// me, _ := users.GetImmutableUser(c.MD.UserId)
	blocked, _ := mUsers.GetImmutableUser(blockId.PeerId)

	if blocked == nil {
		err = mtproto.ErrContactIdInvalid
		c.Logger.Errorf("contacts.block - error: %v", err)
		return nil, err
	} else if blocked.GetUser().GetDeleted() {
		err = mtproto.ErrInputUserDeactivated
		c.Logger.Errorf("contacts.block - error: %v", err)
		return nil, err
	}
	c.svcCtx.Dao.UserClient.UserBlockPeer(c.ctx, &userpb.TLUserBlockPeer{
		UserId:   c.MD.UserId,
		PeerType: blockId.PeerType,
		PeerId:   blockId.PeerId,
	})
	idHelper.AppendUsers(blockId.PeerId)

	syncUpdates := mtproto.MakeUpdatesByUpdates(mtproto.MakeTLUpdatePeerBlocked(&mtproto.Update{
		Blocked_BOOL:         mtproto.BoolTrue,
		Blocked_FLAGBOOLEAN:  true,
		BlockedMyStoriesFrom: false,
		PeerId:               blockId.ToPeer(),
	}).To_Update())

	idHelper.Visit(
		func(userIdList []int64) {
			syncUpdates.PushUser(mUsers.GetUserListByIdList(c.MD.UserId, userIdList...)...)
		},
		func(chatIdList []int64) {
			//
		},
		func(channelIdList []int64) {
			//
		})

	c.svcCtx.Dao.SyncClient.SyncUpdatesNotMe(c.ctx, &sync.TLSyncUpdatesNotMe{
		UserId:        c.MD.UserId,
		PermAuthKeyId: c.MD.PermAuthKeyId,
		Updates:       syncUpdates,
	})

	return mtproto.BoolTrue, nil
}
