package dao

import (
	"context"
	"database/sql"
	"github.com/teamgram/marmota/pkg/stores/sqlx"
	"github.com/teamgram/proto/mtproto"
	"pwm-server/app/bff/pwm/internal/config"
)

type Dao struct {
	db *sqlx.DB
}

// New initializes a new instance of the Dao struct
func New(c config.Config) *Dao {
	db := sqlx.NewMySQL(&c.Mysql)
	return &Dao{
		db: db,
	}
}

// GetWallPapers retrieves a list of wallpapers
func (d *Dao) GetWallPapers(ctx context.Context) ([]*mtproto.WallPaper, error) {
	var wallpapers []*mtproto.WallPaper
	query := `SELECT id, slug, title, pattern, dark, document_id, access_hash 
			  FROM wallpapers`
	err := d.db.QueryRows(ctx, &wallpapers, query)
	if err != nil {
		return nil, err
	}
	return wallpapers, nil
}

// GetWallPaperByID retrieves a specific wallpaper by ID
func (d *Dao) GetWallPaperByID(ctx context.Context, id int64) (*mtproto.WallPaper, error) {
	var wallpaper mtproto.WallPaper
	query := `SELECT id, slug, title, pattern, dark, document_id, access_hash 
			  FROM wallpapers WHERE id = ?`
	err := d.db.QueryRow(ctx, &wallpaper, query, id)
	if err != nil {
		return nil, err
	}
	return &wallpaper, nil
}

// GetWallPaperBySlug retrieves a specific wallpaper by slug
func (d *Dao) GetWallPaperBySlug(ctx context.Context, slug string) (*mtproto.WallPaper, error) {
	var wallpaper mtproto.WallPaper
	query := `SELECT id, slug, title, pattern, dark, document_id, access_hash 
			  FROM wallpapers WHERE slug = ?`
	err := d.db.QueryRow(ctx, &wallpaper, query, slug)
	if err != nil {
		return nil, err
	}
	return &wallpaper, nil
}

// UpdateWallPaperSettings updates the settings of an existing wallpaper
func (d *Dao) UpdateWallPaperSettings(
	ctx context.Context, wallpaperID int64, settings *mtproto.WallPaperSettings,
) error {
	query := `UPDATE wallpapers 
			  SET background_color = ?, second_background_color = ?, third_background_color = ?, 
			      fourth_background_color = ?, intensity = ?, rotation = ?
			  WHERE id = ?`
	_, err := d.db.Exec(
		ctx, query, settings.BackgroundColor, settings.SecondBackgroundColor,
		settings.ThirdBackgroundColor, settings.FourthBackgroundColor, settings.Intensity, settings.Rotation,
		wallpaperID,
	)
	return err
}

// DeleteWallPaper deletes a wallpaper from the database
func (d *Dao) DeleteWallPaper(ctx context.Context, wallpaperID int64) error {
	query := `DELETE FROM wallpapers WHERE id = ?`
	_, err := d.db.Exec(ctx, query, wallpaperID)
	return err
}
func (d *Dao) InsertWallPaperForUser(
	ctx context.Context, ownerId int64, wallpaper *mtproto.InputWallPaper, settings *mtproto.WallPaperSettings,
) error {
	query := `
		INSERT INTO user_wallpapers (user_id, wallpaper_id, for_both, created_at, updated_at)
		VALUES (?, ?, ?, NOW(), NOW())
		ON DUPLICATE KEY UPDATE updated_at = NOW()`

	// First, insert or update the user's saved wallpaper in the `user_wallpapers` table.
	_, err := d.db.Exec(
		ctx, query, ownerId, wallpaper.GetId(), false,
	) // Assuming `for_both` is set to `false` for now
	if err != nil {
		return err
	}

	// Insert the wallpaper settings if provided
	if settings != nil {
		querySettings := `
			INSERT INTO wallpaper_settings (wallpaper_id, blur, motion, background_color, second_background_color, third_background_color, fourth_background_color, intensity, rotation, emoticon, created_at, updated_at)
			VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, NOW(), NOW())
			ON DUPLICATE KEY UPDATE blur = ?, motion = ?, background_color = ?, second_background_color = ?, third_background_color = ?, fourth_background_color = ?, intensity = ?, rotation = ?, emoticon = ?, updated_at = NOW()`

		_, err = d.db.Exec(
			ctx, querySettings, wallpaper.GetId(),
			settings.GetBlur(),
			settings.GetMotion(),
			settings.GetBackgroundColor().GetValue(),
			settings.GetSecondBackgroundColor().GetValue(),
			settings.GetThirdBackgroundColor().GetValue(),
			settings.GetFourthBackgroundColor().GetValue(),
			settings.GetIntensity().GetValue(),
			settings.GetRotation().GetValue(),
			settings.GetEmoticon().GetValue(),
			// Update values in case the record already exists
			settings.GetBlur(),
			settings.GetMotion(),
			settings.GetBackgroundColor().GetValue(),
			settings.GetSecondBackgroundColor().GetValue(),
			settings.GetThirdBackgroundColor().GetValue(),
			settings.GetFourthBackgroundColor().GetValue(),
			settings.GetIntensity().GetValue(),
			settings.GetRotation().GetValue(),
			settings.GetEmoticon().GetValue(),
		)
		if err != nil {
			return err
		}
	}

	return nil
}
func (d *Dao) DeleteWallPaperForUser(ctx context.Context, ownerId int64, wallpaper *mtproto.InputWallPaper) error {
	query := `
		DELETE FROM user_wallpapers
		WHERE user_id = ? AND wallpaper_id = ?`

	_, err := d.db.Exec(ctx, query, ownerId, wallpaper.GetId())
	if err != nil {
		return err
	}

	return nil
}

// InsertTheme adds a new theme to the database
func (d *Dao) InsertTheme(ctx context.Context, theme *mtproto.Theme) error {
	query := `INSERT INTO themes (slug, title, creator, default, for_chat, access_hash, document_id) 
	          VALUES (?, ?, ?, ?, ?, ?, ?)`
	_, err := d.db.Exec(
		ctx, query, theme.Slug, theme.Title, theme.Creator, theme.Default, theme.ForChat, theme.AccessHash,
		theme.Document.GetId(),
	)
	return err
}

// InsertThemeSettings adds theme settings to the database
func (d *Dao) InsertThemeSettings(ctx context.Context, themeId int64, settings *mtproto.ThemeSettings) error {
	query := `INSERT INTO theme_settings (theme_id, message_colors_animated, base_theme, accent_color, outbox_accent_color, message_colors, wallpaper_id) 
	          VALUES (?, ?, ?, ?, ?, ?, ?)`
	_, err := d.db.Exec(
		ctx, query, themeId, settings.MessageColorsAnimated, settings.BaseTheme, settings.AccentColor,
		settings.OutboxAccentColor, settings.MessageColors, settings.Wallpaper.GetId(),
	)
	return err
}

// GetThemes fetches all themes from the database
func (d *Dao) GetThemes(ctx context.Context) ([]*mtproto.Theme, error) {
	query := `SELECT id, slug, title, creator, default, for_chat, access_hash, document_id FROM themes`
	var themes []*mtproto.Theme

	err := d.db.QueryRows(ctx, &themes, query) // Populate the themes slice directly
	if err != nil {
		return nil, err
	}

	// Post-processing to handle null document IDs if needed
	for _, theme := range themes {
		if theme.Document != nil && theme.Document.Id == 0 {
			theme.Document = nil // Set document to nil if ID is 0 or invalid
		}
	}

	return themes, nil
}

// GetThemeByID fetches a theme by its ID from the database
func (d *Dao) GetThemeByID(ctx context.Context, id int64) (*mtproto.Theme, error) {
	query := `SELECT id, slug, title, creator, default, for_chat, access_hash, document_id FROM themes WHERE id = ?`
	var theme mtproto.Theme

	err := d.db.QueryRow(ctx, &theme, query, id) // Pass the reference to the theme struct
	if err != nil {
		if err == sql.ErrNoRows {
			return nil, mtproto.ErrThemeInvalid
		}
		return nil, err
	}

	// Handle null document_id if needed
	if theme.Document != nil && theme.Document.Id == 0 {
		theme.Document = nil
	}

	return &theme, nil
}

// GetThemeBySlug fetches a theme by its slug from the database
func (d *Dao) GetThemeBySlug(ctx context.Context, slug string) (*mtproto.Theme, error) {
	query := `SELECT id, slug, title, creator, default, for_chat, access_hash, document_id FROM themes WHERE slug = ?`
	var theme mtproto.Theme

	err := d.db.QueryRow(ctx, &theme, query, slug) // Pass the reference to the theme struct
	if err != nil {
		if err == sql.ErrNoRows {
			return nil, mtproto.ErrThemeSlugInvalid
		}
		return nil, err
	}

	// Handle null document_id if needed
	if theme.Document != nil && theme.Document.Id == 0 {
		theme.Document = nil
	}

	return &theme, nil
}

// GetChatThemes fetches all chat-specific themes from the database
func (d *Dao) GetChatThemes(ctx context.Context) ([]*mtproto.Theme, error) {
	query := `SELECT id, slug, title, creator, default, for_chat, access_hash, document_id FROM themes WHERE for_chat = 1`
	var chatThemes []*mtproto.Theme

	err := d.db.QueryRows(ctx, &chatThemes, query) // Populate the themes slice directly
	if err != nil {
		return nil, err
	}

	return chatThemes, nil
}

// SetChatTheme updates the theme for a specific chat or peer
func (d *Dao) SetChatTheme(ctx context.Context, peerId int64, peerType string, theme *mtproto.Theme) error {
	// Update the theme for a user, chat, or channel based on peerType
	query := `UPDATE chats SET theme_id = ? WHERE id = ? AND peer_type = ?`
	_, err := d.db.Exec(ctx, query, theme.Id, peerId, peerType)
	return err
}

// GetThemeByEmoticon fetches the theme associated with an emoticon
func (d *Dao) GetThemeByEmoticon(ctx context.Context, emoticon string) (*mtproto.Theme, error) {
	query := `SELECT id, slug, title, creator, default, for_chat, access_hash, document_id FROM themes WHERE emoticon = ?`
	var theme mtproto.Theme
	err := d.db.QueryRow(ctx, &theme, query, emoticon)
	if err != nil {
		return nil, err
	}
	return &theme, nil
}
