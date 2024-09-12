package core

import (
	"github.com/teamgram/proto/mtproto"
	userpb "pwm-server/app/service/biz/user/user"
)

// ContactsAcceptContact
// contacts.acceptContact#f831a20f id:InputUser = Updates;
func (c *ContactsCore) ContactsAcceptContact(in *mtproto.TLContactsAcceptContact) (*mtproto.Updates, error) {
	// Extract peer ID from input
	id := mtproto.FromInputUser(c.MD.UserId, in.Id)

	// Validate if the input is a valid user and not the current user itself
	if !id.IsUser() || id.IsSelf() || id.PeerId == c.MD.UserId {
		err := mtproto.ErrContactIdInvalid
		c.Logger.Errorf("ContactsAcceptContact - error: %v", err)
		return nil, err
	}

	// Fetch the contact details of the user
	users, err := c.svcCtx.Dao.UserClient.UserGetMutableUsers(c.ctx, &userpb.TLUserGetMutableUsers{
		Id: []int64{c.MD.UserId, id.PeerId},
	})
	if err != nil || !users.CheckExistUser(c.MD.UserId, id.PeerId) {
		c.Logger.Errorf("ContactsAcceptContact - error fetching user: %v", err)
		return nil, mtproto.ErrContactIdInvalid
	}

	// Add the contact to the user's contact list
	_, err = c.svcCtx.Dao.UserClient.UserAddContact(c.ctx, &userpb.TLUserAddContact{
		UserId:                   c.MD.UserId,
		AddPhonePrivacyException: mtproto.ToBool(false),
		Id:                       id.PeerId,
		FirstName:                "", // Optional, can be empty
		LastName:                 "", // Optional, can be empty
		Phone:                    "", // Optional, can be empty
	})
	if err != nil {
		c.Logger.Errorf("ContactsAcceptContact - error adding contact: %v", err)
		return nil, mtproto.ErrContactIdInvalid
	}

	// Get the added contact and mark it as mutual
	cUser, _ := users.GetUnsafeUser(c.MD.UserId, id.PeerId)
	cUser.Contact = true
	cUser.MutualContact = mtproto.FromBool(mtproto.BoolTrue)
	me, _ := users.GetUnsafeUserSelf(c.MD.UserId)

	// Create updates for the accepted contact
	rUpdates := mtproto.MakeUpdatesByUpdatesUsers(
		[]*mtproto.User{me, cUser},
		mtproto.MakeTLUpdatePeerSettings(&mtproto.Update{
			Peer_PEER: mtproto.MakePeerUser(id.PeerId),
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
	c.Logger.Infof("ContactsAcceptContact - successfully accepted contact for user: %d", c.MD.UserId)

	return rUpdates, nil
}
