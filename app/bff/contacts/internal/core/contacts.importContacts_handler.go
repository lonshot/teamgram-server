package core

import (
	"strings"

	"github.com/teamgram/proto/mtproto"
	chatpb "pwm-server/app/service/biz/chat/chat"
	userpb "pwm-server/app/service/biz/user/user"
)

// ContactsImportContacts imports a list of contacts for the user and syncs the contacts.
func (c *ContactsCore) ContactsImportContacts(in *mtproto.TLContactsImportContacts) (
	*mtproto.Contacts_ImportedContacts, error,
) {
	// Fetch current contacts using UserGetContactList
	currentContacts, err := c.svcCtx.Dao.UserClient.UserGetContactList(
		c.ctx, &userpb.TLUserGetContactList{UserId: c.MD.UserId},
	)
	if err != nil {
		c.Logger.Errorf("ContactsImportContacts - error fetching current contacts: %v", err)
		return nil, mtproto.ErrInternalServerError
	}

	// Build a map of imported contact phone numbers for quick lookup
	importedContactsMap := c.buildContactsMap(in.Contacts)

	// Sync: Delete contacts that are not in the imported list
	if err := c.syncDeletedContacts(currentContacts.Datas, importedContactsMap); err != nil {
		return nil, err
	}

	// If the input contacts are empty, syncing only means deleting existing contacts
	if len(in.Contacts) == 0 {
		c.Logger.Infof("ContactsImportContacts - no new contacts to import, synced deletions only")
		return mtproto.MakeTLContactsImportedContacts(
			&mtproto.Contacts_ImportedContacts{
				Imported:       []*mtproto.ImportedContact{},
				PopularInvites: []*mtproto.PopularContact{},
				Users:          []*mtproto.User{},
			},
		).To_Contacts_ImportedContacts(), nil
	}

	// Process the imported contacts (Add/Update)
	importedContacts, popularContacts, updatedUsers, me, err := c.processImportedContacts(in)
	if err != nil {
		return nil, err
	}

	// Return the result, even if empty (syncing can result in an empty list)
	return mtproto.MakeTLContactsImportedContacts(
		&mtproto.Contacts_ImportedContacts{
			Imported:       importedContacts,
			PopularInvites: popularContacts,
			Users:          append([]*mtproto.User{me}, updatedUsers...),
		},
	).To_Contacts_ImportedContacts(), nil
}

// buildContactsMap creates a map of imported contacts by their cleaned phone numbers.
func (c *ContactsCore) buildContactsMap(contacts []*mtproto.InputContact) map[string]struct{} {
	contactsMap := make(map[string]struct{})
	for _, contact := range contacts {
		cleanedPhone := strings.ReplaceAll(contact.Phone, " ", "")
		contactsMap[cleanedPhone] = struct{}{}
	}
	return contactsMap
}

// syncDeletedContacts removes the contacts and associated chats that are not in the imported list.
func (c *ContactsCore) syncDeletedContacts(
	currentContacts []*mtproto.ContactData, importedContactsMap map[string]struct{},
) error {
	for _, contact := range currentContacts {
		cleanedPhone := strings.ReplaceAll(contact.Phone.GetValue(), " ", "")
		if _, found := importedContactsMap[cleanedPhone]; !found {
			// Contact not found in the imported list, delete the contact and associated chats
			_, err := c.svcCtx.Dao.UserClient.UserDeleteContact(
				c.ctx, &userpb.TLUserDeleteContact{
					UserId: c.MD.UserId,
					Id:     contact.ContactUserId,
				},
			)
			if err != nil {
				c.Logger.Errorf("ContactsImportContacts - error deleting contact: %v", err)
				continue
			}

			// Delete the associated chat with the contact (choose based on context)
			err = c.deleteAssociatedChat(contact.ContactUserId)
			if err != nil {
				c.Logger.Errorf("ContactsImportContacts - error deleting chat for contact: %v", err)
				continue
			}
		}
	}
	return nil
}

// deleteAssociatedChat handles deleting or removing the chat with the contact.
func (c *ContactsCore) deleteAssociatedChat(contactUserId int64) error {
	// Step 1: Retrieve chat ID list between the current user and the contact
	chats, err := c.svcCtx.Dao.ChatClient.ChatGetUsersChatIdList(
		c.ctx, &chatpb.TLChatGetUsersChatIdList{
			Id: []int64{c.MD.UserId, contactUserId}, // The current user and the contact
		},
	)
	if err != nil {
		c.Logger.Errorf("ContactsImportContacts - error fetching chat ID list for users: %v", err)
		return err
	}

	// Step 2: Iterate through the retrieved chat IDs in the Datas field
	for _, userChat := range chats.Datas {
		// Iterate through the list of chat IDs for the user
		for _, chatId := range userChat.ChatIdList {

			// Step 3: Remove the contact from the chat (ChatDeleteChatUser)
			_, err = c.svcCtx.Dao.ChatClient.ChatDeleteChatUser(
				c.ctx, &chatpb.TLChatDeleteChatUser{
					ChatId:       chatId,
					OperatorId:   c.MD.UserId,   // The current user (operator)
					DeleteUserId: contactUserId, // The contact to be deleted
				},
			)
			if err != nil {
				c.Logger.Errorf("ContactsImportContacts - error removing contact from chat: %v", err)
				continue
			}

			// Step 4: Optionally delete the entire chat (ChatDeleteChat)
			_, err = c.svcCtx.Dao.ChatClient.ChatDeleteChat(
				c.ctx, &chatpb.TLChatDeleteChat{
					ChatId:     chatId,      // The chat to be deleted
					OperatorId: c.MD.UserId, // The current user (operator)
				},
			)
			if err != nil {
				c.Logger.Errorf("ContactsImportContacts - error deleting chat: %v", err)
				continue
			}
		}
	}

	return nil
}

// processImportedContacts handles adding and updating the imported contacts.
func (c *ContactsCore) processImportedContacts(
	in *mtproto.TLContactsImportContacts,
) ([]*mtproto.ImportedContact, []*mtproto.PopularContact, []*mtproto.User, *mtproto.User, error) {

	var (
		importedContacts []*mtproto.ImportedContact
		popularContacts  []*mtproto.PopularContact
		updatedUsers     []*mtproto.User
		me               *mtproto.User
	)

	for _, contact := range in.Contacts {
		cleanedPhone := strings.ReplaceAll(contact.Phone, " ", "")

		// Validate contact name and phone
		if err := c.validateContact(contact, cleanedPhone); err != nil {
			return nil, nil, nil, nil, err
		}

		// Fetch user by phone number
		contactUser, err := c.svcCtx.Dao.UserClient.UserGetImmutableUserByPhone(
			c.ctx, &userpb.TLUserGetImmutableUserByPhone{Phone: cleanedPhone},
		)
		if err != nil || contactUser == nil {
			c.Logger.Errorf("ContactsImportContacts - user not found for phone: %v", cleanedPhone)
			continue
		}

		// Prevent adding self as a contact
		if contactUser.Id() == c.MD.UserId {
			c.Logger.Errorf("ContactsImportContacts - cannot add self as contact")
			continue
		}

		// Add or update contact
		users, err := c.addOrUpdateContact(contactUser, contact, cleanedPhone)
		if err != nil {
			continue
		}

		// Prepare imported and popular contacts
		importedContacts = append(
			importedContacts, &mtproto.ImportedContact{
				UserId:   contactUser.Id(),
				ClientId: contact.ClientId,
			},
		)
		popularContacts = append(
			popularContacts, mtproto.MakeTLPopularContact(
				&mtproto.PopularContact{
					ClientId:  contact.ClientId,
					Importers: 100, // Placeholder value
				},
			).To_PopularContact(),
		)

		// Update users list
		cUser, _ := users.GetUnsafeUser(c.MD.UserId, contactUser.Id())
		cUser.Contact = true
		cUser.MutualContact = true
		updatedUsers = append(updatedUsers, cUser)

		if me == nil {
			me, _ = users.GetUnsafeUserSelf(c.MD.UserId)
		}
	}

	return importedContacts, popularContacts, updatedUsers, me, nil
}

// validateContact checks if the contact's name and phone are valid.
func (c *ContactsCore) validateContact(contact *mtproto.InputContact, cleanedPhone string) error {
	if contact.FirstName == "" && contact.LastName == "" {
		c.Logger.Errorf("ContactsImportContacts - contact name is empty")
		return mtproto.ErrContactNameEmpty
	}
	if cleanedPhone == "" {
		c.Logger.Errorf("ContactsImportContacts - contact phone is invalid")
		return mtproto.ErrContactIdInvalid
	}
	return nil
}

// addOrUpdateContact adds or updates the contact in the user's contact list.
func (c *ContactsCore) addOrUpdateContact(
	contactUser *mtproto.ImmutableUser, contact *mtproto.InputContact, cleanedPhone string,
) (*userpb.Vector_ImmutableUser, error) {
	// Fetch mutable user information
	users, err := c.svcCtx.Dao.UserClient.UserGetMutableUsers(
		c.ctx, &userpb.TLUserGetMutableUsers{
			Id: []int64{c.MD.UserId, contactUser.Id()},
		},
	)
	if err != nil || !users.CheckExistUser(c.MD.UserId, contactUser.Id()) {
		c.Logger.Errorf("ContactsImportContacts - error fetching users: %v", err)
		return nil, err
	}

	// Add the contact to the user's contact list
	_, err = c.svcCtx.Dao.UserClient.UserAddContact(
		c.ctx, &userpb.TLUserAddContact{
			UserId:    c.MD.UserId,
			Id:        contactUser.Id(),
			FirstName: contact.FirstName,
			LastName:  contact.LastName,
			Phone:     cleanedPhone,
		},
	)
	if err != nil {
		c.Logger.Errorf("ContactsImportContacts - error adding contact: %v", err)
		return nil, err
	}

	return users, nil
}
