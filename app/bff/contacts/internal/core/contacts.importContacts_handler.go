package core

import (
	"github.com/teamgram/proto/mtproto"
	userpb "pwm-server/app/service/biz/user/user"
	"strings" // Import the strings package
)

// ContactsImportContacts imports a list of contacts for the user.
func (c *ContactsCore) ContactsImportContacts(in *mtproto.TLContactsImportContacts) (
	*mtproto.Contacts_ImportedContacts, error,
) {
	var (
		me           *mtproto.User
		updatedUsers []*mtproto.User
		imported     []*mtproto.ImportedContact
		popular      []*mtproto.PopularContact
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

		// Remove all spaces from the phone number
		cleanedPhone := strings.ReplaceAll(contact.Phone, " ", "")

		// Check if the cleaned contact phone is valid (non-empty after removing spaces)
		if cleanedPhone == "" {
			err = mtproto.ErrContactIdInvalid
			c.Logger.Errorf("ContactsImportContacts - error: contact phone is invalid")
			return nil, err
		}

		// Fetch the user by phone number using UserGetImmutableUserByPhone
		contactUser, err := c.svcCtx.Dao.UserClient.UserGetImmutableUserByPhone(
			c.ctx, &userpb.TLUserGetImmutableUserByPhone{
				Phone: cleanedPhone,
			},
		)
		if err != nil || contactUser == nil {
			c.Logger.Errorf("ContactsImportContacts - error: user not found for phone: %v", cleanedPhone)
			continue // Skip this contact but do not fail the entire process
		}

		// Prevent adding self as a contact
		if contactUser.Id() == c.MD.UserId {
			c.Logger.Errorf("ContactsImportContacts - error: cannot add self as contact")
			continue // Skip this contact but do not fail the entire process
		}

		// Fetch mutable user information
		users, err := c.svcCtx.Dao.UserClient.UserGetMutableUsers(
			c.ctx, &userpb.TLUserGetMutableUsers{
				Id: []int64{c.MD.UserId, contactUser.Id()},
			},
		)
		if err != nil || !users.CheckExistUser(c.MD.UserId, contactUser.Id()) {
			c.Logger.Errorf("ContactsImportContacts - error fetching users: %v", err)
			continue // Skip this contact but do not fail the entire process
		}

		// Add the contact to the user's contact list
		changeMutual, err := c.svcCtx.Dao.UserClient.UserAddContact(
			c.ctx, &userpb.TLUserAddContact{
				UserId:    c.MD.UserId,
				Id:        contactUser.Id(),
				FirstName: contact.FirstName,
				LastName:  contact.LastName,
				Phone:     cleanedPhone, // Use the cleaned phone number
			},
		)
		if err != nil {
			c.Logger.Errorf("ContactsImportContacts - error adding contact: %v", err)
			continue // Skip this contact but do not fail the entire process
		}

		// Create an imported contact record
		imported = append(
			imported, &mtproto.ImportedContact{
				UserId:   contactUser.Id(),
				ClientId: contact.ClientId, // Use client-provided ID if available
			},
		)

		// Create a popular contact record
		popular = append(
			popular, &mtproto.PopularContact{
				ClientId:  contact.ClientId,
				Importers: 100, // Placeholder value, adjust based on your logic
			},
		)

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

	// Build and return the Contacts_ImportedContacts structure
	if len(imported) > 0 {
		contactsImported := &mtproto.Contacts_ImportedContacts{
			Imported:       imported,
			PopularInvites: popular,
			Users:          append([]*mtproto.User{me}, updatedUsers...),
		}

		// Log success
		c.Logger.Infof(
			"ContactsImportContacts - successfully added %d contacts for user: %d", len(updatedUsers), c.MD.UserId,
		)

		return contactsImported, nil
	}

	return nil, mtproto.ErrInternalServerError
}
