INSERT INTO users (id, user_type, access_hash, secret_key_id, first_name, last_name, username, phone, country_code, verified, support, scam, fake, premium, about, state, is_bot, account_days_ttl, photo_id, restricted, restriction_reason, archive_and_mute_new_noncontact_peers, emoji_status_document_id, emoji_status_until, deleted, delete_reason, created_at, updated_at) VALUES
(777000, 4, 6599886787491911851, 6895602324158323006, 'Pwm', 'Service', 'pwm', '42777', '', 1, 0, 0, 0, 0, '', 0, 0, 180, 0, 0, '', 0, 0, 0, 0, '', '2018-09-25 13:43:11', '2021-12-17 12:40:51');


START TRANSACTION;

-- Inserting predefined wallpapers into the `wallpapers` table
INSERT INTO `wallpapers` (`id`, `slug`, `title`, `access_hash`, `creator`, `default`, `pattern`, `dark`, `document_id`, `created_at`, `updated_at`)
VALUES
    (1001, 'classic-wallpaper', 'Classic Wallpaper', 987654321, FALSE, TRUE, FALSE, FALSE, NULL, NOW(), NOW()),
    (1002, 'day-wallpaper', 'Day Wallpaper', 987654322, FALSE, FALSE, FALSE, FALSE, NULL, NOW(), NOW()),
    (1003, 'tinted-wallpaper', 'Tinted Wallpaper', 987654323, FALSE, FALSE, FALSE, FALSE, NULL, NOW(), NOW()),
    (1004, 'night-wallpaper', 'Night Wallpaper', 987654324, FALSE, FALSE, FALSE, TRUE, NULL, NOW(), NOW()),
    (1005, 'gradient-wallpaper', 'Gradient Wallpaper', 987654325, FALSE, FALSE, TRUE, FALSE, NULL, NOW(), NOW());

-- Insert sample custom/animated wallpapers
INSERT INTO `wallpapers` (`id`, `slug`, `title`, `access_hash`, `creator`, `default`, `pattern`, `dark`, `document_id`, `created_at`, `updated_at`)
VALUES
    (1006, 'custom-animated-wallpaper', 'Custom Animated Wallpaper', 987654326, TRUE, FALSE, TRUE, FALSE, NULL, NOW(), NOW()),
    (1007, 'abstract-dark-wallpaper', 'Abstract Dark Wallpaper', 987654327, TRUE, FALSE, FALSE, TRUE, NULL, NOW(), NOW());

-- Inserting wallpaper settings for each wallpaper
INSERT INTO `wallpaper_settings` (`wallpaper_id`, `blur`, `motion`, `background_color`, `second_background_color`, `third_background_color`, `fourth_background_color`, `intensity`, `rotation`, `emoticon`, `created_at`, `updated_at`)
VALUES
    (1001, 0, 0, 0xA5D6A7, NULL, NULL, NULL, NULL, NULL, NULL, NOW(), NOW()), -- Classic wallpaper
    (1002, 0, 0, 0x81D4FA, NULL, NULL, NULL, NULL, NULL, NULL, NOW(), NOW()), -- Day wallpaper
    (1003, 0, 0, 0x607D8B, NULL, NULL, NULL, NULL, NULL, NULL, NOW(), NOW()), -- Tinted wallpaper
    (1004, 0, 0, 0x263238, NULL, NULL, NULL, NULL, NULL, NULL, NOW(), NOW()), -- Night wallpaper
    (1005, 1, 1, 0xFFCDD2, 0xFFEBEE, NULL, NULL, 70, 180, ':)', NOW(), NOW()), -- Gradient wallpaper with motion and blur
    (1006, 1, 1, 0xFFC107, NULL, NULL, NULL, 80, 90, ':D', NOW(), NOW()),     -- Custom animated wallpaper with motion and blur
    (1007, 0, 0, 0x212121, NULL, NULL, NULL, NULL, NULL, NULL, NOW(), NOW()); -- Abstract dark wallpaper

COMMIT;


START TRANSACTION;

-- Inserting predefined themes into the `themes` table
INSERT INTO `themes` (`id`, `slug`, `title`, `creator`, `default`, `for_chat`, `access_hash`, `document_id`, `created_at`, `updated_at`)
VALUES
    (1, 'classic-theme', 'Classic', FALSE, TRUE, FALSE, 123456789, NULL, NOW(), NOW()),
    (2, 'day-theme', 'Day', FALSE, FALSE, FALSE, 123456790, NULL, NOW(), NOW()),
    (3, 'tinted-theme', 'Tinted', FALSE, FALSE, FALSE, 123456791, NULL, NOW(), NOW()),
    (4, 'night-theme', 'Night', FALSE, FALSE, FALSE, 123456792, NULL, NOW(), NOW());

-- Insert theme settings into the `theme_settings` table
INSERT INTO `theme_settings` (`theme_id`, `message_colors_animated`, `base_theme`, `accent_color`, `outbox_accent_color`, `message_colors`, `wallpaper_id`, `created_at`, `updated_at`)
VALUES
    (1, FALSE, 'classic', 0xA5D6A7, NULL, JSON_ARRAY(0xFFFFFF, 0xE0F7FA), 1001, NOW(), NOW()), -- Classic theme with classic wallpaper
    (2, FALSE, 'day', 0x81D4FA, NULL, JSON_ARRAY(0xFFFFFF, 0xE1F5FE), 1002, NOW(), NOW()),    -- Day theme with day wallpaper
    (3, FALSE, 'tinted', 0x607D8B, NULL, JSON_ARRAY(0xECEFF1, 0xCFD8DC), 1003, NOW(), NOW()), -- Tinted theme with tinted wallpaper
    (4, FALSE, 'night', 0x263238, NULL, JSON_ARRAY(0x37474F, 0x455A64), 1004, NOW(), NOW());  -- Night theme with night wallpaper

COMMIT;