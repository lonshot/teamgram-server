-- Creating the wallpapers table to store predefined wallpapers
CREATE TABLE `wallpapers` (
                              `id` BIGINT NOT NULL AUTO_INCREMENT PRIMARY KEY,
                              `slug` VARCHAR(255) NOT NULL,
                              `title` VARCHAR(255) NOT NULL,
                              `pattern` BOOLEAN NOT NULL DEFAULT FALSE,
                              `dark` BOOLEAN NOT NULL DEFAULT FALSE,
                              `document_id` BIGINT DEFAULT NULL,  -- Foreign key to `documents` table for pattern images
                              `access_hash` BIGINT NOT NULL,
                              `background_color` INT DEFAULT NULL,
                              `second_background_color` INT DEFAULT NULL,
                              `third_background_color` INT DEFAULT NULL,
                              `fourth_background_color` INT DEFAULT NULL,
                              `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                              `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
                              CONSTRAINT `fk_wallpapers_document_id` FOREIGN KEY (`document_id`) REFERENCES `documents` (`document_id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Creating the user_wallpapers table to store user-specific wallpaper selections
CREATE TABLE `user_wallpapers` (
                                   `id` BIGINT NOT NULL AUTO_INCREMENT,
                                   `user_id` BIGINT NOT NULL,
                                   `wallpaper_id` BIGINT NOT NULL,
                                   `for_both` BOOLEAN NOT NULL DEFAULT FALSE,
                                   `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
                                   `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
                                   PRIMARY KEY (`id`),
                                   KEY `user_wallpapers_user_id_idx` (`user_id`),
                                   KEY `user_wallpapers_wallpaper_id_idx` (`wallpaper_id`),
                                   CONSTRAINT `fk_user_wallpapers_wallpaper_id` FOREIGN KEY (`wallpaper_id`) REFERENCES `wallpapers` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Creating the wallpaper_settings table
CREATE TABLE `wallpaper_settings` (
                                      `id` BIGINT NOT NULL AUTO_INCREMENT,
                                      `wallpaper_id` BIGINT NOT NULL,
                                      `blur` TINYINT(1) DEFAULT 0,
                                      `motion` TINYINT(1) DEFAULT 0,
                                      `background_color` INT DEFAULT NULL,
                                      `second_background_color` INT DEFAULT NULL,
                                      `third_background_color` INT DEFAULT NULL,
                                      `fourth_background_color` INT DEFAULT NULL,
                                      `intensity` INT DEFAULT NULL,
                                      `rotation` INT DEFAULT NULL,
                                      `emoticon` VARCHAR(255) DEFAULT NULL,
                                      `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
                                      `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
                                      PRIMARY KEY (`id`),
                                      CONSTRAINT `fk_wallpaper_settings_wallpaper_id` FOREIGN KEY (`wallpaper_id`) REFERENCES `wallpapers`(`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Creating the themes table
CREATE TABLE `themes` (
                          `id` BIGINT NOT NULL AUTO_INCREMENT,
                          `slug` VARCHAR(255) NOT NULL,
                          `title` VARCHAR(255) NOT NULL,
                          `creator` TINYINT(1) DEFAULT 0,
                          `default` TINYINT(1) DEFAULT 0,
                          `for_chat` TINYINT(1) DEFAULT 0,
                          `access_hash` BIGINT NOT NULL,
                          `document_id` BIGINT DEFAULT NULL,
                          `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
                          `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
                          PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Creating the theme_settings table
CREATE TABLE `theme_settings` (
                                  `id` BIGINT NOT NULL AUTO_INCREMENT,
                                  `theme_id` BIGINT NOT NULL,
                                  `message_colors_animated` TINYINT(1) DEFAULT 0,
                                  `base_theme` VARCHAR(255) DEFAULT NULL,
                                  `accent_color` INT DEFAULT NULL,
                                  `outbox_accent_color` INT DEFAULT NULL,
                                  `message_colors` JSON DEFAULT NULL,
                                  `wallpaper_id` BIGINT DEFAULT NULL,
                                  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
                                  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
                                  PRIMARY KEY (`id`),
                                  CONSTRAINT `fk_theme_settings_theme_id` FOREIGN KEY (`theme_id`) REFERENCES `themes`(`id`) ON DELETE CASCADE ON UPDATE CASCADE,
                                  CONSTRAINT `fk_theme_settings_wallpaper_id` FOREIGN KEY (`wallpaper_id`) REFERENCES `wallpapers`(`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Creating the user_themes table (User's Custom Themes)
CREATE TABLE `user_themes` (
                               `id` BIGINT NOT NULL AUTO_INCREMENT,
                               `user_id` BIGINT NOT NULL,
                               `theme_id` BIGINT NOT NULL,
                               `selected_accent_color` INT,
                               `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
                               `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
                               PRIMARY KEY (`id`),
                               KEY `user_themes_user_id_idx` (`user_id`),
                               KEY `user_themes_theme_id_idx` (`theme_id`),
                               CONSTRAINT `fk_user_themes_theme_id` FOREIGN KEY (`theme_id`) REFERENCES `themes` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
