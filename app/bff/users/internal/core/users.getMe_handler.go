package core

import (
	"github.com/teamgram/proto/mtproto"
	"google.golang.org/protobuf/types/known/wrapperspb"
	userpb "pwm-server/app/service/biz/user/user"
)

// UsersGetMe
// users.getMe id:long token:string = User;
func (c *UsersCore) UsersGetMe(in *mtproto.TLUsersGetMe) (*mtproto.User, error) {
	// Validate input parameters
	if in.Id == 0 || in.Token == "" {
		return nil, mtproto.ErrUserIdInvalid
	}

	// Step 1: Fetch user data by token
	userData, err := c.svcCtx.Dao.UserClient.UserGetUserDataByToken(
		c.ctx, &userpb.TLUserGetUserDataByToken{
			Token: in.Token,
		},
	)
	if err != nil {
		c.Logger.Errorf("users.getMe - error fetching user data by token: %v", err)
		return nil, err
	}

	// Check if user data is retrieved successfully
	if userData == nil {
		c.Logger.Errorf("users.getMe - error: user not found")
		return nil, mtproto.ErrUserInvalid
	}

	// Step 2: Handle profile photo
	var profilePhoto *mtproto.UserProfilePhoto
	if userData.GetProfilePhoto() != nil {
		profilePhoto = handleUserProfilePhoto(userData.GetProfilePhoto())
	} else {
		profilePhoto = mtproto.MakeTLUserProfilePhotoEmpty(nil).To_UserProfilePhoto()
	}
	// Wrap the single username in a list of Username objects
	usernames := []*mtproto.Username{
		mtproto.MakeTLUsername(
			&mtproto.Username{
				Username: userData.GetUsername(), // Wrap the single username string
			},
		).To_Username(),
	}
	// Step 3: Create the mtproto.User object based on the retrieved user data
	me := mtproto.MakeTLUser(
		&mtproto.User{
			Id:                 userData.GetId(),
			AccessHash:         wrapperspb.Int64(userData.GetAccessHash()),   // Wrap Int64
			FirstName:          wrapperspb.String(userData.GetFirstName()),   // Wrap String
			LastName:           wrapperspb.String(userData.GetLastName()),    // Wrap String
			Username:           wrapperspb.String(userData.GetUsername()),    // Wrap String
			Phone:              wrapperspb.String(userData.GetPhone()),       // Wrap String
			Photo:              profilePhoto,                                 // Already processed earlier
			Bot:                userData.GetBot() != nil,                     // Convert to boolean if not nil
			Verified:           userData.GetVerified(),                       // Direct boolean
			Deleted:            userData.GetDeleted(),                        // Direct boolean
			Restricted:         userData.GetRestricted(),                     // Direct boolean
			Support:            userData.GetSupport(),                        // Direct boolean
			Scam:               userData.GetScam(),                           // Direct boolean
			Fake:               userData.GetFake(),                           // Direct boolean
			Premium:            userData.GetPremium(),                        // Direct boolean
			StoriesUnavailable: userData.GetStoriesUnavailable(),             // Direct boolean
			RestrictionReason:  userData.GetRestrictionReason(),              // List of RestrictionReason
			EmojiStatus:        userData.GetEmojiStatus(),                    // Direct EmojiStatus object
			Usernames:          usernames,                                    // List of Username objects
			StoriesMaxId:       wrapperspb.Int32(userData.GetStoriesMaxId()), // Wrap Int32
			ProfileColor:       userData.GetProfileColor(),                   // Direct PeerColor object
			Color:              userData.GetColor().GetColor(),               // Wrap Int32
		},
	).To_User()

	// Step 4: Return the current user's information
	return me, nil
}

// handleUserProfilePhoto processes the user's profile photo and returns the appropriate structure
func handleUserProfilePhoto(photo *mtproto.Photo) *mtproto.UserProfilePhoto {
	if photo == nil {
		return mtproto.MakeTLUserProfilePhotoEmpty(nil).To_UserProfilePhoto()
	}

	// Extract the stripped thumbnail and other relevant fields from the photo sizes
	var strippedThumb []byte
	for _, size := range photo.GetSizes() {
		if size.GetType() == "s" { // Assuming "s" is the type for stripped thumbnails
			strippedThumb = size.GetBytes()
			break
		}
	}

	// Convert the mtproto.Photo to mtproto.UserProfilePhoto
	return mtproto.MakeTLUserProfilePhoto(
		&mtproto.UserProfilePhoto{
			PhotoId:       photo.GetId(),
			HasVideo:      photo.HasStickers, // Assuming has stickers is related to video/photo media
			Personal:      false,             // Set based on your business logic (you can update this if necessary)
			StrippedThumb: strippedThumb,
			DcId:          photo.GetDcId(), // Assuming the DC ID is directly available
		},
	).To_UserProfilePhoto()
}
