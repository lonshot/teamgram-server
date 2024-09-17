package dao

import (
	"context"
	"database/sql"
	kafka "github.com/teamgram/marmota/pkg/mq"
	"github.com/teamgram/marmota/pkg/net/rpcx"
	"github.com/teamgram/marmota/pkg/stores/sqlc"
	"github.com/teamgram/marmota/pkg/stores/sqlx"
	"github.com/teamgram/proto/mtproto"
	"github.com/zeromicro/go-zero/core/logx"
	"pwm-server/app/bff/pwm/internal/config"
	"pwm-server/app/bff/pwm/internal/dao/dataobject"
	msg_client "pwm-server/app/messenger/msg/msg/client"
	sync_client "pwm-server/app/messenger/sync/client"
	authsession_client "pwm-server/app/service/authsession/client"
	chat_client "pwm-server/app/service/biz/chat/client"
	dialog_client "pwm-server/app/service/biz/dialog/client"
	message_client "pwm-server/app/service/biz/message/client"
	user_client "pwm-server/app/service/biz/user/client"
	idgen_client "pwm-server/app/service/idgen/client"
	media_client "pwm-server/app/service/media/client"
	"time"
)

type Dao struct {
	db *sqlx.DB
	sqlc.CachedConn
	user_client.UserClient
	ChatClient *chat_client.ChatClientHelper
	msg_client.MsgClient
	sync_client.SyncClient
	media_client.MediaClient
	dialog_client.DialogClient
	authsession_client.AuthsessionClient
	idgen_client.IDGenClient2
	message_client.MessageClient
}

// New initializes a new instance of the Dao struct
func New(c config.Config) *Dao {
	db := sqlx.NewMySQL(&c.Mysql)
	return &Dao{
		db:                db,
		CachedConn:        sqlc.NewConn(db, c.Cache),
		UserClient:        user_client.NewUserClient(rpcx.GetCachedRpcClient(c.UserClient)),
		ChatClient:        chat_client.NewChatClientHelper(rpcx.GetCachedRpcClient(c.ChatClient)),
		MsgClient:         msg_client.NewMsgClient(rpcx.GetCachedRpcClient(c.MsgClient)),
		DialogClient:      dialog_client.NewDialogClient(rpcx.GetCachedRpcClient(c.DialogClient)),
		SyncClient:        sync_client.NewSyncMqClient(kafka.MustKafkaProducer(c.SyncClient)),
		MediaClient:       media_client.NewMediaClient(rpcx.GetCachedRpcClient(c.MediaClient)),
		AuthsessionClient: authsession_client.NewAuthsessionClient(rpcx.GetCachedRpcClient(c.AuthsessionClient)),
		IDGenClient2:      idgen_client.NewIDGenClient2(rpcx.GetCachedRpcClient(c.IdgenClient)),
		MessageClient:     message_client.NewMessageClient(rpcx.GetCachedRpcClient(c.MessageClient)),
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

// InsertReaction adds a new reaction to a message.
func (d *Dao) InsertReaction(ctx context.Context, reaction *dataobject.ReactionsDO) (int64, error) {
	query := `
		INSERT INTO reactions (user_id, message_id, reaction, peer_id, peer_type, created_at, updated_at)
		VALUES (?, ?, ?, ?, ?, ?, ?)
	`
	// Use Unix timestamps for created_at and updated_at
	result, err := d.db.Exec(
		ctx, query, reaction.UserId, reaction.MessageId, reaction.Reaction, reaction.PeerId, reaction.PeerType,
		reaction.CreatedAt, reaction.UpdatedAt,
	)
	if err != nil {
		return 0, err
	}
	return result.LastInsertId()
}

// SelectReactionsByMessageIds retrieves reactions for a list of message IDs.
func (d *Dao) SelectReactionsByMessageIds(ctx context.Context, msgIds []int64) ([]*dataobject.ReactionsDO, error) {
	query, args, err := sqlx.In("SELECT * FROM reactions WHERE message_id IN (?)", msgIds)
	if err != nil {
		return nil, err
	}

	var reactions []*dataobject.ReactionsDO
	err = d.db.QueryRows(ctx, &reactions, query, args...)
	if err != nil {
		return nil, err
	}
	return reactions, nil
}

// SelectReactionsByMessageId retrieves reactions for a specific message ID.
func (d *Dao) SelectReactionsByMessageId(ctx context.Context, msgId int64) ([]*dataobject.ReactionsDO, error) {
	query := `
		SELECT * FROM reactions WHERE message_id = ?
	`
	var reactions []*dataobject.ReactionsDO
	err := d.db.QueryRows(ctx, &reactions, query, msgId)
	if err != nil {
		return nil, err
	}
	return reactions, nil
}

// MarkReactionsAsRead marks all reactions for a specific message as read.
func (d *Dao) MarkReactionsAsRead(ctx context.Context, userId, msgId int64, updatedAt int64) error {
	query := `
		UPDATE reactions SET read = 1, updated_at = ? WHERE user_id = ? AND message_id = ?
	`
	_, err := d.db.Exec(ctx, query, updatedAt, userId, msgId)
	return err
}

// ReportReaction flags a reaction for moderation or reporting.
func (d *Dao) ReportReaction(ctx context.Context, msgId int64, reaction string) error {
	// Prepare the SQL query to update the 'reported' status and update the 'updated_at' field.
	query := `
		UPDATE reactions 
		SET reported = 1, updated_at = ? 
		WHERE message_id = ? AND reaction = ?
	`

	// Use Unix timestamp for the updated_at field.
	updatedAt := time.Now().Unix()

	// Execute the query with context, passing the updated timestamp, message ID, and reaction.
	_, err := d.db.Exec(ctx, query, updatedAt, msgId, reaction)
	if err != nil {
		// Log the error and return it if the query fails.
		logx.WithContext(ctx).Errorf(
			"Failed to report reaction for message_id: %d, reaction: %s, error: %v", msgId, reaction, err,
		)
		return err
	}

	return nil
}

// ClearRecentReactions clears recent reactions for a user.
func (d *Dao) ClearRecentReactions(ctx context.Context, userId int64) error {
	query := `
		DELETE FROM reactions WHERE user_id = ?
	`
	_, err := d.db.Exec(ctx, query, userId)
	return err
}

// UpdateAvailableReactions
// update chats set available_reactions_type = :available_reactions_type, available_reactions = :available_reactions where id = :id
func (dao *Dao) UpdateAvailableReactions(
	ctx context.Context, availableReactionsType int32, availableReactions string, id int64,
) (rowsAffected int64, err error) {
	var (
		query   = "update chats set available_reactions_type = ?, available_reactions = ? where id = ?"
		rResult sql.Result
	)

	rResult, err = dao.db.Exec(ctx, query, availableReactionsType, availableReactions, id)

	if err != nil {
		logx.WithContext(ctx).Errorf("exec in UpdateAvailableReactions(_), error: %v", err)
		return
	}

	rowsAffected, err = rResult.RowsAffected()
	if err != nil {
		logx.WithContext(ctx).Errorf("rowsAffected in UpdateAvailableReactions(_), error: %v", err)
	}

	return
}

// SelectAvailableReactions retrieves the available reactions for a chat.
func (dao *Dao) SelectAvailableReactions(ctx context.Context, peerId int64) (*dataobject.ChatReactionsDO, error) {
	var (
		query   = "SELECT available_reactions_type, available_reactions FROM chats WHERE id = ?"
		chatsDO dataobject.ChatReactionsDO
	)

	// Use QueryRow to execute the query and bind the result to the ChatsDO struct
	err := dao.db.QueryRow(ctx, &chatsDO, query, peerId)
	if err != nil {
		if err == sql.ErrNoRows {
			logx.WithContext(ctx).Infof("No available reactions found for peer_id: %d", peerId)
			return nil, nil // Return nil without error for no results
		}
		logx.WithContext(ctx).Errorf("Error in SelectAvailableReactions: %v", err)
		return nil, err
	}

	return &chatsDO, nil
}

// SelectUnreadReactionsByUserId retrieves unread reactions for a specific user/peer with pagination support.
func (d *Dao) SelectUnreadReactionsByUserId(
	ctx context.Context, peerId int64, offsetId, limit int32,
) ([]*dataobject.ReactionsDO, error) {
	query := `
		SELECT * FROM reactions 
		WHERE peer_id = ? AND read = 0
		ORDER BY created_at DESC
		LIMIT ? OFFSET ?
	`
	var unreadReactions []*dataobject.ReactionsDO
	err := d.db.QueryRows(ctx, &unreadReactions, query, peerId, limit, offsetId)
	if err != nil {
		if err == sql.ErrNoRows {
			return nil, nil
		}
		return nil, err
	}
	return unreadReactions, nil
}

// SelectTopReactions fetches the top reactions from the database.
func (d *Dao) SelectTopReactions(ctx context.Context) ([]*dataobject.ReactionCountDO, error) {
	query := `
		SELECT reaction, COUNT(reaction) AS count 
		FROM reactions 
		GROUP BY reaction 
		ORDER BY count DESC 
		LIMIT 10
	`
	var topReactions []*dataobject.ReactionCountDO
	err := d.db.QueryRows(ctx, &topReactions, query)
	if err != nil {
		return nil, err
	}
	return topReactions, nil
}

// SelectRecentReactions retrieves the most recent reactions for a specific user, limited by the provided count.
func (d *Dao) SelectRecentReactions(ctx context.Context, userId int64, limit int32) ([]*dataobject.ReactionsDO, error) {
	query := `
		SELECT * FROM reactions 
		WHERE user_id = ? 
		ORDER BY created_at DESC 
		LIMIT ?
	`
	var recentReactions []*dataobject.ReactionsDO
	err := d.db.QueryRows(ctx, &recentReactions, query, userId, limit)
	if err != nil {
		if err == sql.ErrNoRows {
			return nil, nil // No recent reactions found
		}
		return nil, err
	}
	return recentReactions, nil
}
