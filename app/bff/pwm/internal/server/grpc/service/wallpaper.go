package service

import (
	"context"
	"github.com/teamgram/proto/mtproto"
	"github.com/zeromicro/go-zero/core/logx"
	"pwm-server/app/bff/pwm/internal/core"
	"pwm-server/app/service/media/media"
)

// AccountGetWallPapers retrieves a list of wallpapers available for the user.
func (s *Service) AccountGetWallPapers(
	ctx context.Context, papers *mtproto.TLAccountGetWallPapers,
) (*mtproto.Account_WallPapers, error) {
	// Get wallpapers from the Dao
	wallpapers, err := s.svcCtx.Dao.GetWallPapers(ctx)
	if err != nil {
		return nil, err
	}

	// Convert to mtproto.Account_WallPapers structure
	accountWallpapers := mtproto.MakeTLAccountWallPapers(
		&mtproto.Account_WallPapers{
			Hash:       0, // Customize as per your needs
			Wallpapers: wallpapers,
		},
	).To_Account_WallPapers()

	return accountWallpapers, nil
}

// AccountGetWallPaper retrieves a specific wallpaper by ID or slug.
func (s *Service) AccountGetWallPaper(
	ctx context.Context, paper *mtproto.TLAccountGetWallPaper,
) (*mtproto.WallPaper, error) {
	var wallpaper *mtproto.WallPaper
	var err error

	var wp = paper.Wallpaper
	if wp.GetId() != 0 {
		// Retrieve wallpaper by ID
		wallpaper, err = s.svcCtx.Dao.GetWallPaperByID(ctx, wp.GetId())
	} else if wp.GetSlug() != "" {
		// Retrieve wallpaper by slug
		wallpaper, err = s.svcCtx.Dao.GetWallPaperBySlug(ctx, wp.GetSlug())
	}

	if err != nil {
		return nil, err
	}
	return wallpaper, nil
}

func (s *Service) AccountUploadWallPaper(
	ctx context.Context, paper *mtproto.TLAccountUploadWallPaper,
) (*mtproto.WallPaper, error) {
	c := core.New(ctx, s.svcCtx)
	var (
		inputFile = paper.GetFile()
		mimeType  = paper.GetMimeType()
		settings  = paper.GetSettings()
		ownerId   = c.MD.PermAuthKeyId
		msgMedia  *mtproto.MessageMedia
		document  *mtproto.Document
		err       error
	)

	// Check if the file is valid
	if inputFile == nil {
		return nil, mtproto.ErrFilePartInvalid
	}

	// Use MediaUploadedDocumentMedia to upload the wallpaper document
	msgMedia, err = s.svcCtx.Dao.MediaClient.MediaUploadedDocumentMedia(
		ctx, &media.TLMediaUploadedDocumentMedia{
			OwnerId: ownerId,
			Media: &mtproto.InputMedia{
				File:     inputFile,
				MimeType: mimeType,
				// Add other fields as needed from InputMedia
			},
		},
	)
	if err != nil {
		c.Logger.Errorf("AccountUploadWallPaper - error uploading document: %v", err)
		return nil, err
	}

	// Check if msgMedia contains a valid document
	document = msgMedia.GetDocument()
	if document == nil {
		c.Logger.Errorf("AccountUploadWallPaper - document not found in message media")
		return nil, mtproto.ErrDocumentInvalid
	}

	// Create the wallpaper object
	wallpaper := mtproto.MakeTLWallPaper(
		&mtproto.WallPaper{
			Id:         document.GetId(),
			Slug:       inputFile.GetName(),
			Settings:   settings,
			Document:   document,
			AccessHash: document.GetAccessHash(),
		},
	).To_WallPaper()

	// Return the uploaded wallpaper object
	return wallpaper, nil
}

// AccountSaveWallPaper saves a wallpaper for a user.
func (s *Service) AccountSaveWallPaper(ctx context.Context, paper *mtproto.TLAccountSaveWallPaper) (
	*mtproto.Bool, error,
) {
	// Create a core context to get the authenticated user's ID
	//c := core.New(ctx, s.svcCtx)

	// Use PermAuthKeyId to represent the owner (user) saving the wallpaper
	//ownerId := c.MD.UserId

	// Check if wallpaper should be unsaved (i.e., removed from the user's saved wallpapers)
	//if paper.GetUnsave() != nil && paper.GetUnsave() {
	//	err := s.svcCtx.Dao.DeleteWallPaperForUser(ctx, ownerId, paper.GetWallPaper())
	//	if err != nil {
	//		logx.Errorf("AccountSaveWallPaper - error unsaving wallpaper for user: %v", err)
	//		return nil, err
	//	}
	//	return mtproto.MakeTLBoolTrue(nil).To_Bool(), nil
	//}
	//
	//// If the wallpaper is not unsaved, save the wallpaper for the user
	//err := s.svcCtx.Dao.InsertWallPaperForUser(ctx, ownerId, paper.GetWallPaper(), paper.GetSettings())
	//if err != nil {
	//	logx.Errorf("AccountSaveWallPaper - error saving wallpaper for user: %v", err)
	//	return nil, err
	//}

	return mtproto.MakeTLBoolTrue(nil).To_Bool(), nil
}

// AccountInstallWallPaper installs a wallpaper for a user.
func (s *Service) AccountInstallWallPaper(ctx context.Context, paper *mtproto.TLAccountInstallWallPaper) (
	*mtproto.Bool, error,
) {
	// Typically, this would involve marking the wallpaper as installed for a specific user in the database
	//err := s.svcCtx.Dao.InsertWallPaper(ctx, paper.GetWallPaper())
	//if err != nil {
	//	return nil, err
	//}

	return mtproto.MakeTLBoolTrue(nil).To_Bool(), nil
}

// AccountResetWallPapers resets wallpapers for the user.
func (s *Service) AccountResetWallPapers(ctx context.Context, papers *mtproto.TLAccountResetWallPapers) (
	*mtproto.Bool, error,
) {
	// Example of resetting wallpapers could mean deleting or setting to default
	//err := s.svcCtx.Dao.DeleteWallPaper(ctx, papers.GetId()) // Modify this logic as needed for your reset mechanism
	//if err != nil {
	//	return nil, err
	//}
	return mtproto.MakeTLBoolTrue(nil).To_Bool(), nil
}

// AccountGetMultiWallPapers retrieves multiple wallpapers by their IDs.
func (s *Service) AccountGetMultiWallPapers(
	ctx context.Context, papers *mtproto.TLAccountGetMultiWallPapers,
) (*mtproto.Vector_WallPaper, error) {
	var wallpapers []*mtproto.WallPaper

	for _, w := range papers.Wallpapers {
		wallpaper, err := s.svcCtx.Dao.GetWallPaperByID(ctx, w.GetId())
		if err != nil {
			// Log the error but continue to the next wallpaper instead of returning the error.
			logx.Errorf("AccountGetMultiWallPapers - error retrieving wallpaper with ID %d: %v", w.GetId(), err)
			continue // Skip this wallpaper and continue with others.
		}

		if wallpaper != nil {
			wallpapers = append(wallpapers, wallpaper)
		}
	}

	// Return an empty vector if no wallpapers are found.
	return &mtproto.Vector_WallPaper{
		Datas: wallpapers, // Could be empty if no wallpapers are found.
	}, nil
}

// MessagesSetChatWallPaper sets a custom wallpaper for the chat or peer.
func (s *Service) MessagesSetChatWallPaper(
	ctx context.Context, paper *mtproto.TLMessagesSetChatWallPaper,
) (*mtproto.Updates, error) {
	// Apply the wallpaper to a specific chat
	err := s.svcCtx.Dao.InsertWallPaper(ctx, paper.GetWallpaper())
	if err != nil {
		return nil, err
	}

	// Create an update response (this is just an example; actual logic depends on your updates mechanism)
	updates := mtproto.MakeTLUpdates(
		&mtproto.Updates{
			Updates: []*mtproto.Update{},
			Users:   []*mtproto.User{},
			Chats:   []*mtproto.Chat{},
		},
	).To_Updates()

	return updates, nil
}
