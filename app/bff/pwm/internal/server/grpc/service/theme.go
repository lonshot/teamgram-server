package service

import (
	"context"
	"github.com/teamgram/proto/mtproto"
	"pwm-server/app/bff/pwm/internal/core"
)

// AccountGetThemes retrieves a list of themes available for the user.
func (s *Service) AccountGetThemes(ctx context.Context, themes *mtproto.TLAccountGetThemes) (
	*mtproto.Account_Themes, error,
) {
	allThemes, err := s.svcCtx.GetThemes(ctx)
	if err != nil {
		return nil, err
	}

	return mtproto.MakeTLAccountThemes(
		&mtproto.Account_Themes{
			Themes: allThemes,
		},
	).To_Account_Themes(), nil
}

// AccountUploadTheme handles theme uploads by users.
func (s *Service) AccountUploadTheme(ctx context.Context, theme *mtproto.TLAccountUploadTheme) (
	*mtproto.Document, error,
) {
	c := core.New(ctx, s.svcCtx)
	var (
		document *mtproto.Document
		msgMedia *mtproto.MessageMedia
		//err      error
	)

	// Check if the theme file is valid
	if theme.GetFile() == nil {
		return nil, mtproto.ErrFilePartInvalid
	}

	// Upload the theme file using MediaClient
	//msgMedia, err = s.svcCtx.Plugin.MediaUploadedDocumentMedia(
	//	ctx, &media.TLMediaUploadedDocumentMedia{
	//		OwnerId: c.MD.PermAuthKeyId, // Assuming ownerId is passed in context
	//		Media: &mtproto.InputMedia{
	//			File:     theme.GetFile(),
	//			MimeType: theme.GetMimeType(),
	//		},
	//	},
	//)
	//if err != nil {
	//	return nil, err
	//}

	document = msgMedia.GetDocument()
	if document == nil {
		c.Logger.Errorf("AccountUploadWallPaper - document not found in message media")
		return nil, mtproto.ErrDocumentInvalid
	}

	// Return the uploaded theme document
	return document, nil
}

// AccountCreateTheme creates a new theme
func (s *Service) AccountCreateTheme(ctx context.Context, theme *mtproto.TLAccountCreateTheme) (*mtproto.Theme, error) {
	//TODO implement me
	panic("implement me")
}

// AccountSaveTheme saves a theme for a specific user.
func (s *Service) AccountSaveTheme(ctx context.Context, theme *mtproto.TLAccountSaveTheme) (*mtproto.Bool, error) {
	//TODO implement me
	panic("implement me")
}

func (s Service) AccountUpdateTheme(ctx context.Context, theme *mtproto.TLAccountUpdateTheme) (*mtproto.Theme, error) {
	//TODO implement me
	panic("implement me")
}

func (s Service) AccountInstallTheme(ctx context.Context, theme *mtproto.TLAccountInstallTheme) (*mtproto.Bool, error) {
	//TODO implement me
	panic("implement me")
}

// AccountGetTheme retrieves a theme by its ID or slug.
func (s *Service) AccountGetTheme(ctx context.Context, theme *mtproto.TLAccountGetTheme) (*mtproto.Theme, error) {
	var (
		themeData *mtproto.Theme
		err       error
	)

	// Check if the theme should be fetched by ID or slug
	if theme.Theme.GetId() != 0 {
		// Fetch theme by ID
		themeData, err = s.svcCtx.Dao.GetThemeByID(ctx, theme.Theme.GetId())
		if err != nil {
			return nil, err
		}
	} else if theme.Theme.GetSlug() != "" {
		// Fetch theme by slug
		themeData, err = s.svcCtx.Dao.GetThemeBySlug(ctx, theme.Theme.GetSlug())
		if err != nil {
			return nil, err
		}
	} else {
		// If neither ID nor slug is provided, return an error
		return nil, mtproto.ErrThemeInvalid
	}

	// Check if theme data was found
	if themeData == nil {
		return nil, mtproto.ErrThemeInvalid
	}

	// Return the retrieved theme
	return themeData, nil
}
func (s *Service) AccountGetChatThemes(
	ctx context.Context, req *mtproto.TLAccountGetChatThemes,
) (*mtproto.Account_Themes, error) {
	// Fetch all chat themes from the database
	chatThemes, err := s.svcCtx.Dao.GetChatThemes(ctx)
	if err != nil {
		return nil, err
	}

	// Construct the response
	accountThemes := mtproto.MakeTLAccountThemes(
		&mtproto.Account_Themes{
			Hash:   0,          // Add hash logic if needed
			Themes: chatThemes, // Chat themes fetched from the database
		},
	).To_Account_Themes()

	return accountThemes, nil
}

func (s *Service) MessagesSetChatTheme(
	ctx context.Context, req *mtproto.TLMessagesSetChatTheme,
) (*mtproto.Updates, error) {
	// Extract the peer from the request
	peer := req.GetPeer()

	// Determine if it's a user, chat, or channel based on the peer type
	var peerId int64
	switch peer.PredicateName {
	case mtproto.Predicate_peerUser:
		peerId = peer.GetUserId()
	case mtproto.Predicate_peerChat:
		peerId = peer.GetChatId()
	case mtproto.Predicate_peerChannel:
		peerId = peer.GetChannelId()
	default:
		return nil, mtproto.ErrPeerIdInvalid
	}

	// Fetch the theme by emoticon (or use slug if required)
	theme, err := s.svcCtx.Dao.GetThemeByEmoticon(ctx, req.GetEmoticon())
	if err != nil {
		return nil, err
	}

	// Update the chat or peer with the selected theme
	err = s.svcCtx.Dao.SetChatTheme(ctx, peerId, peer.PredicateName, theme)
	if err != nil {
		return nil, err
	}

	// Construct the updates response
	updates := mtproto.MakeTLUpdates(
		&mtproto.Updates{
			Updates: []*mtproto.Update{},
			Users:   []*mtproto.User{},
			Chats:   []*mtproto.Chat{},
		},
	).To_Updates()

	return updates, nil
}
