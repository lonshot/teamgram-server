package core

import (
	"github.com/teamgram/proto/mtproto"
	userpb "pwm-server/app/service/biz/user/user"
)

// ContactsGetBlocked
// contacts.getBlocked#9a868f80 flags:# my_stories_from:flags.0?true offset:int limit:int = contacts.Blocked;
func (c *ContactsCore) ContactsGetBlocked(in *mtproto.TLContactsGetBlocked) (*mtproto.Contacts_Blocked, error) {
	var (
		limit           = in.Limit
		contactsBlocked *mtproto.Contacts_Blocked
	)

	if limit > 50 {
		limit = 50
	}

	blockedList, _ := c.svcCtx.Dao.UserClient.UserGetBlockedList(c.ctx, &userpb.TLUserGetBlockedList{
		UserId: c.MD.UserId,
		Offset: in.Offset,
		Limit:  in.Limit,
	})

	if len(blockedList.GetDatas()) > 0 {
		// TODO(@benqi): impl blockedSlice
		// TODO(@benqi): layer119
		contactsBlocked = mtproto.MakeTLContactsBlocked(&mtproto.Contacts_Blocked{
			Blocked: make([]*mtproto.PeerBlocked, 0, len(blockedList.GetDatas())),
			Chats:   nil,
			Users:   nil,
		}).To_Contacts_Blocked()

		var (
			idHelper = mtproto.NewIDListHelper(c.MD.UserId)
		)

		for _, blocked := range blockedList.GetDatas() {
			peer := blocked.GetPeerId()
			idHelper.PickByPeer(peer)
			// idHelper.AppendUsers(blocked.GetPeerId().GetUserId())
			contactsBlocked.Blocked = append(contactsBlocked.Blocked, mtproto.MakeTLPeerBlocked(&mtproto.PeerBlocked{
				PeerId: blocked.GetPeerId(),
				Date:   blocked.Date,
			}).To_PeerBlocked())
		}

		idHelper.Visit(
			func(userIdList []int64) {
				users, _ := c.svcCtx.Dao.UserClient.UserGetMutableUsers(c.ctx,
					&userpb.TLUserGetMutableUsers{
						Id: userIdList,
					})
				contactsBlocked.Users = users.GetUserListByIdList(c.MD.UserId, userIdList...)
			},
			func(chatIdList []int64) {
			},
			func(channelIdList []int64) {
			})
	} else {
		contactsBlocked = mtproto.MakeTLContactsBlocked(&mtproto.Contacts_Blocked{
			Blocked: []*mtproto.PeerBlocked{},
			Chats:   []*mtproto.Chat{},
			Users:   []*mtproto.User{},
		}).To_Contacts_Blocked()
	}

	return contactsBlocked, nil
}
