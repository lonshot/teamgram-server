package core

import (
	"github.com/teamgram/proto/mtproto"
	userpb "pwm-server/app/service/biz/user/user"
)

// ContactsAddContacts
// contacts.addContact#e8f463d0 flags:# add_phone_privacy_exception:flags.0?true id:InputUser first_name:string last_name:string phone:string = Updates;
func (c *ContactsCore) ContactsAddContacts(in []*mtproto.TLContactsAddContact) (*mtproto.Updates, error) {
	var (
		me           *mtproto.User
		updatedUsers []*mtproto.User
		err          error
	)

	// Check if input list is empty
	if len(in) == 0 {
		c.Logger.Errorf("ContactsAddContacts - error: input contact list is empty")
		return nil, mtproto.ErrContactIdInvalid
	}

	// Iterate over all contacts to be added
	for _, contact := range in {
		// 400	CONTACT_NAME_EMPTY	Contact name empty.
		if contact.FirstName == "" && contact.LastName == "" {
			err = mtproto.ErrContactNameEmpty
			c.Logger.Errorf("ContactsAddContacts - error: %v", err)
			return nil, err
		}

		id := mtproto.FromInputUser(c.MD.UserId, contact.Id)

		// Validate the input user and prevent adding self as contact
		if !id.IsUser() || id.IsSelf() || id.PeerId == c.MD.UserId {
			err = mtproto.ErrContactIdInvalid
			c.Logger.Errorf("ContactsAddContacts - error: invalid contact ID for user: %v", id.PeerId)
			return nil, err
		}

		// Fetch the mutable user information for the current user and the contact
		users, err := c.svcCtx.Dao.UserClient.UserGetMutableUsers(c.ctx, &userpb.TLUserGetMutableUsers{
			Id: []int64{c.MD.UserId, id.PeerId},
		})
		if err != nil || !users.CheckExistUser(c.MD.UserId, id.PeerId) {
			c.Logger.Errorf("ContactsAddContacts - error fetching users: %v", err)
			return nil, mtproto.ErrContactIdInvalid
		}

		// Add the contact to the user's contact list
		changeMutual, err := c.svcCtx.Dao.UserClient.UserAddContact(c.ctx, &userpb.TLUserAddContact{
			UserId:                   c.MD.UserId,
			AddPhonePrivacyException: mtproto.ToBool(contact.AddPhonePrivacyException),
			Id:                       id.PeerId,
			FirstName:                contact.FirstName,
			LastName:                 contact.LastName,
			Phone:                    contact.Phone,
		})
		if err != nil {
			c.Logger.Errorf("ContactsAddContacts - error adding contact: %v", err)
			return nil, mtproto.ErrContactIdInvalid
		}

		// Get the added contact and mark it as mutual
		cUser, _ := users.GetUnsafeUser(c.MD.UserId, id.PeerId)
		cUser.Contact = true
		cUser.MutualContact = mtproto.FromBool(changeMutual)
		updatedUsers = append(updatedUsers, cUser)

		// Store the "self" user if not already done (fetch only once)
		if me == nil {
			me, _ = users.GetUnsafeUserSelf(c.MD.UserId)
		}
	}

	// Build the updates for all added users
	rUpdates := mtproto.MakeUpdatesByUpdatesUsers(
		append([]*mtproto.User{me}, updatedUsers...),
		mtproto.MakeTLUpdatePeerSettings(&mtproto.Update{
			Peer_PEER: mtproto.MakePeerUser(updatedUsers[0].GetId()), // Using MakePeerUser for the peer
			Settings: mtproto.MakeTLPeerSettings(&mtproto.PeerSettings{
				ReportSpam:            false,
				AddContact:            false,
				BlockContact:          false,
				ShareContact:          false,
				NeedContactsException: false,
				ReportGeo:             false,
			}).To_PeerSettings(),
		}).To_Update(),
	)

	// Log success
	c.Logger.Infof("ContactsAddContacts - successfully added %d contacts for user: %d", len(updatedUsers), c.MD.UserId)

	return rUpdates, nil
}
