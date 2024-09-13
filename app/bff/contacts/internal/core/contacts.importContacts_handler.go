package core

import (
	"github.com/teamgram/proto/mtproto"
	userpb "pwm-server/app/service/biz/user/user"
)

// ContactsImportContacts imports a list of contacts for the user.
func (c *ContactsCore) ContactsImportContacts(in *mtproto.TLContactsImportContacts) (*mtproto.Updates, error) {
	var (
		me           *mtproto.User
		updatedUsers []*mtproto.User
		err          error
	)

	// Check if input list is empty
	if len(in.Contacts) == 0 {
		c.Logger.Errorf("ContactsImportContacts - error: input contact list is empty")
		return nil, mtproto.ErrContactIdInvalid
	}

	// Iterate over all contacts to be added
	for _, contact := range in.Contacts {
		// Ensure first and last names are not both empty
		if contact.FirstName == "" && contact.LastName == "" {
			err = mtproto.ErrContactNameEmpty
			c.Logger.Errorf("ContactsImportContacts - error: %v", err)
			return nil, err
		}

		// Check if the contact phone is valid (non-empty)
		if contact.Phone == "" {
			err = mtproto.ErrContactIdInvalid
			c.Logger.Errorf("ContactsImportContacts - error: contact phone is invalid")
			return nil, err
		}

		// Fetch the user by phone number using UserGetImmutableUserByPhone
		contactUser, err := c.svcCtx.Dao.UserClient.UserGetImmutableUserByPhone(
			c.ctx, &userpb.TLUserGetImmutableUserByPhone{
				Phone: contact.Phone,
			},
		)
		if err != nil || contactUser == nil {
			c.Logger.Errorf("ContactsImportContacts - error: user not found for phone: %v", contact.Phone)
			return nil, mtproto.ErrContactIdInvalid
		}

		// Prevent adding self as a contact
		if contactUser.Id() == c.MD.UserId {
			err = mtproto.ErrContactIdInvalid
			c.Logger.Errorf("ContactsImportContacts - error: cannot add self as contact")
			return nil, err
		}

		// Fetch mutable user information
		users, err := c.svcCtx.Dao.UserClient.UserGetMutableUsers(
			c.ctx, &userpb.TLUserGetMutableUsers{
				Id: []int64{c.MD.UserId, contactUser.Id()},
			},
		)
		if err != nil || !users.CheckExistUser(c.MD.UserId, contactUser.Id()) {
			c.Logger.Errorf("ContactsImportContacts - error fetching users: %v", err)
			return nil, mtproto.ErrContactIdInvalid
		}

		// Add the contact to the user's contact list
		changeMutual, err := c.svcCtx.Dao.UserClient.UserAddContact(
			c.ctx, &userpb.TLUserAddContact{
				UserId: c.MD.UserId,
				//AddPhonePrivacyException: mtproto.ToBool(contact.AddPhonePrivacyException),
				Id:        contactUser.Id(),
				FirstName: contact.FirstName,
				LastName:  contact.LastName,
				Phone:     contact.Phone,
			},
		)
		if err != nil {
			c.Logger.Errorf("ContactsImportContacts - error adding contact: %v", err)
			return nil, mtproto.ErrContactIdInvalid
		}

		// Get the added contact and update it as mutual
		cUser, _ := users.GetUnsafeUser(c.MD.UserId, contactUser.Id())
		cUser.Contact = true
		cUser.MutualContact = mtproto.FromBool(changeMutual)
		updatedUsers = append(updatedUsers, cUser)

		// Get the current user's info if not already retrieved
		if me == nil {
			me, _ = users.GetUnsafeUserSelf(c.MD.UserId)
		}
	}

	// Build updates for all added users
	if len(updatedUsers) > 0 {
		rUpdates := mtproto.MakeUpdatesByUpdatesUsers(
			append([]*mtproto.User{me}, updatedUsers...),
			mtproto.MakeTLUpdatePeerSettings(
				&mtproto.Update{
					Peer_PEER: mtproto.MakePeerUser(updatedUsers[0].GetId()),
					Settings: mtproto.MakeTLPeerSettings(
						&mtproto.PeerSettings{
							ReportSpam:            false,
							AddContact:            false,
							BlockContact:          false,
							ShareContact:          false,
							NeedContactsException: false,
							ReportGeo:             false,
						},
					).To_PeerSettings(),
				},
			).To_Update(),
		)

		// Log success
		c.Logger.Infof(
			"ContactsImportContacts - successfully added %d contacts for user: %d", len(updatedUsers), c.MD.UserId,
		)

		return rUpdates, nil
	}

	return nil, mtproto.ErrInternalServerError
}
