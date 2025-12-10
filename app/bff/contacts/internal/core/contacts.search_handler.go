package core

import (
	userpb "pwm-server/app/service/biz/user/user"
	"pwm-server/app/service/biz/username/username"

	"github.com/teamgram/proto/mtproto"
)

// ContactsSearch
// contacts.search#11f812d8 q:string limit:int = contacts.Found;
func (c *ContactsCore) ContactsSearch(in *mtproto.TLContactsSearch) (*mtproto.Contacts_Found, error) {
	var (
		limit = in.GetLimit()
	)

	if limit > 50 {
		limit = 50
	}
	if limit == 0 {
		limit = 50
	}

	q := in.Q

	if q == "" {
		err := mtproto.ErrSearchQueryEmpty
		c.Logger.Errorf("contacts.search - error: %v", err)
		return nil, err
	}

	if q[0] == '@' {
		q = q[1:]
	}

	if len(q) < 3 {
		err := mtproto.ErrQueryTooShort
		c.Logger.Errorf("contacts.search - error: %v", err)
		return nil, err
	}

	var (
		idHelper = mtproto.NewIDListHelper(c.MD.UserId)
	)

	found := mtproto.MakeTLContactsFound(&mtproto.Contacts_Found{
		MyResults: []*mtproto.Peer{},
		Results:   []*mtproto.Peer{},
		Users:     []*mtproto.User{},
		Chats:     []*mtproto.Chat{},
	}).To_Contacts_Found()

	// TODO(@benqi):
	// This method will exclude the current user's contacts from the search results. It is assumed that searches among the user's contacts can be handled locally by the client.
	//

	// Check query string and limit
	if len(q) >= 3 && limit > 0 {
		contacts, _ := c.svcCtx.Dao.UserClient.UserGetContactIdList(c.ctx, &userpb.TLUserGetContactIdList{
			UserId: c.MD.UserId,
		})

		// c.Logger.Debugf("q: %s", q)
		rVList, err := c.svcCtx.Dao.UsernameClient.UsernameSearch(c.ctx, &username.TLUsernameSearch{
			Q:                q,
			ExcludedContacts: append(contacts.GetDatas(), c.MD.UserId),
			Limit:            limit,
		})
		if err != nil {
			c.Logger.Errorf("contacts.search - error: %v", err)
			return found, nil
		}

		for _, v := range rVList.GetDatas() {
			// c.Logger.Debugf("v: %v", v)
			idHelper.PickByPeer(v.Peer)
		}

		rVList2, err := c.svcCtx.Dao.UserClient.UserSearch(c.ctx, &userpb.TLUserSearch{
			Q:                in.Q,
			ExcludedContacts: append(contacts.GetDatas(), c.MD.UserId),
			Offset:           0,
			Limit:            limit,
		})

		for _, v := range rVList2.GetIdList() {
			idHelper.PickByPeerUtil(mtproto.PEER_USER, v)
		}
	}

	idHelper.Visit(
		func(userIdList []int64) {
			users, _ := c.svcCtx.Dao.UserClient.UserGetMutableUsers(c.ctx,
				&userpb.TLUserGetMutableUsers{
					Id: userIdList,
				})

			users.Visit(func(it *mtproto.ImmutableUser) {
				peer := mtproto.MakeTLPeerUser(&mtproto.Peer{
					UserId: it.Id(),
				})
				if ok, _ := it.CheckContact(c.MD.UserId); ok {
					found.MyResults = append(found.MyResults, peer.To_Peer())
				} else {
					found.Results = append(found.Results, peer.To_Peer())
				}
			})

			found.Users = users.GetUserListByIdList(c.MD.UserId, userIdList...)
		},
		func(chatIdList []int64) {
		},
		func(channelIdList []int64) {
			if c.svcCtx.Plugin != nil {
				chats := c.svcCtx.Plugin.GetChannelListByIdList(c.ctx, c.MD.UserId, channelIdList...)
				for _, ch := range chats {
					if ch.PredicateName == mtproto.Predicate_chatEmpty {
						continue
					}
					found.Chats = append(found.Chats, ch)
					found.Results = append(found.Results, mtproto.MakePeerChannel(ch.GetId()))
				}
			} else {
				c.Logger.Errorf("contacts.search blocked, License key from https://wb.playwith-me.com required to unlock enterprise features.")
			}
		})

	return found, nil
}
