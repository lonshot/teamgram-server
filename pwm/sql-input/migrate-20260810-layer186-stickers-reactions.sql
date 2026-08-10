USE pwm;

CREATE TABLE IF NOT EXISTS `schema_migrations` (
  `version` VARCHAR(128) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  `applied_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`version`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `sticker_imports` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `dataset_version` VARCHAR(64) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  `dataset_checksum` BINARY(32) NOT NULL,
  `source_root` VARCHAR(512) COLLATE utf8mb4_unicode_ci NOT NULL,
  `state` TINYINT UNSIGNED NOT NULL DEFAULT 0 COMMENT '0=validated,1=running,2=complete,3=failed',
  `total_sets` INT UNSIGNED NOT NULL DEFAULT 0,
  `total_documents` INT UNSIGNED NOT NULL DEFAULT 0,
  `imported_documents` INT UNSIGNED NOT NULL DEFAULT 0,
  `skipped_documents` INT UNSIGNED NOT NULL DEFAULT 0,
  `failed_documents` INT UNSIGNED NOT NULL DEFAULT 0,
  `last_error` VARCHAR(2048) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `started_at` TIMESTAMP NULL DEFAULT NULL,
  `completed_at` TIMESTAMP NULL DEFAULT NULL,
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_sticker_import_dataset` (`dataset_version`, `dataset_checksum`),
  KEY `idx_sticker_import_state` (`state`, `updated_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `sticker_sets` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `import_id` BIGINT UNSIGNED NULL,
  `source_set_id` BIGINT NULL,
  `source_access_hash` BIGINT NULL,
  `native_set_id` BIGINT NOT NULL,
  `native_access_hash` BIGINT NOT NULL,
  `owner_user_id` BIGINT NOT NULL DEFAULT 0,
  `short_name` VARCHAR(255) COLLATE utf8mb4_bin NOT NULL,
  `short_name_normalized` VARCHAR(255) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  `title` VARCHAR(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `set_hash` BIGINT NOT NULL DEFAULT 0,
  `document_count` INT UNSIGNED NOT NULL DEFAULT 0,
  `display_order` INT UNSIGNED NOT NULL DEFAULT 0,
  `archived` TINYINT(1) NOT NULL DEFAULT 0,
  `official` TINYINT(1) NOT NULL DEFAULT 0,
  `masks` TINYINT(1) NOT NULL DEFAULT 0,
  `emojis` TINYINT(1) NOT NULL DEFAULT 0,
  `animated` TINYINT(1) NOT NULL DEFAULT 0,
  `videos` TINYINT(1) NOT NULL DEFAULT 0,
  `text_color` TINYINT(1) NOT NULL DEFAULT 0,
  `thumb_document_id` BIGINT NULL,
  `thumb_access_hash` BIGINT NULL,
  `thumb_dc_id` INT NOT NULL DEFAULT 1,
  `thumb_version` INT NOT NULL DEFAULT 0,
  `import_state` TINYINT UNSIGNED NOT NULL DEFAULT 0,
  `last_error` VARCHAR(2048) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_sticker_sets_source` (`source_set_id`),
  UNIQUE KEY `uk_sticker_sets_native` (`native_set_id`),
  UNIQUE KEY `uk_sticker_sets_short_name` (`short_name_normalized`),
  KEY `idx_sticker_sets_owner` (`owner_user_id`, `native_set_id`, `id`),
  KEY `idx_sticker_sets_catalog` (`archived`, `emojis`, `display_order`, `id`),
  KEY `idx_sticker_sets_import` (`import_id`, `import_state`, `id`),
  FULLTEXT KEY `ft_sticker_sets_search` (`title`),
  CONSTRAINT `fk_sticker_sets_import` FOREIGN KEY (`import_id`) REFERENCES `sticker_imports` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `sticker_documents` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `import_id` BIGINT UNSIGNED NULL,
  `sticker_set_id` BIGINT UNSIGNED NULL,
  `source_document_id` BIGINT NULL,
  `native_document_id` BIGINT NULL,
  `native_access_hash` BIGINT NULL,
  `owner_user_id` BIGINT NOT NULL DEFAULT 0,
  `document_kind` TINYINT UNSIGNED NOT NULL COMMENT '1=sticker,2=custom_emoji,3=reaction_asset',
  `source_path` VARCHAR(768) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `source_size` BIGINT UNSIGNED NOT NULL DEFAULT 0,
  `source_checksum` BINARY(32) NULL,
  `preview_source_path` VARCHAR(768) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `preview_source_size` BIGINT UNSIGNED NOT NULL DEFAULT 0,
  `preview_source_checksum` BINARY(32) NULL,
  `path_thumbnail_bytes` BLOB NULL,
  `native_thumb_size_type` CHAR(1) CHARACTER SET ascii COLLATE ascii_bin NOT NULL DEFAULT '',
  `preview_import_state` TINYINT UNSIGNED NOT NULL DEFAULT 0,
  `mime_type` VARCHAR(128) CHARACTER SET ascii COLLATE ascii_bin NOT NULL DEFAULT '',
  `file_name` VARCHAR(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `width` INT UNSIGNED NOT NULL DEFAULT 0,
  `height` INT UNSIGNED NOT NULL DEFAULT 0,
  `date2` INT NOT NULL DEFAULT 0,
  `free` TINYINT(1) NOT NULL DEFAULT 0,
  `text_color` TINYINT(1) NOT NULL DEFAULT 0,
  `import_state` TINYINT UNSIGNED NOT NULL DEFAULT 0,
  `attempt_count` INT UNSIGNED NOT NULL DEFAULT 0,
  `last_error` VARCHAR(2048) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_sticker_documents_source` (`source_document_id`),
  UNIQUE KEY `uk_sticker_documents_native` (`native_document_id`),
  KEY `idx_sticker_documents_set` (`sticker_set_id`, `id`),
  KEY `idx_sticker_documents_resume` (`import_id`, `import_state`, `id`),
  KEY `idx_sticker_documents_kind` (`document_kind`, `native_document_id`),
  CONSTRAINT `fk_sticker_documents_import` FOREIGN KEY (`import_id`) REFERENCES `sticker_imports` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `fk_sticker_documents_set` FOREIGN KEY (`sticker_set_id`) REFERENCES `sticker_sets` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `sticker_packs` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `sticker_set_id` BIGINT UNSIGNED NOT NULL,
  `emoticon` VARCHAR(64) COLLATE utf8mb4_bin NOT NULL,
  `sticker_document_id` BIGINT UNSIGNED NOT NULL,
  `order2` INT UNSIGNED NOT NULL DEFAULT 0,
  `mask_n` INT NULL,
  `mask_x` DOUBLE NULL,
  `mask_y` DOUBLE NULL,
  `mask_zoom` DOUBLE NULL,
  `keywords` VARCHAR(1024) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_sticker_packs_document` (`sticker_set_id`, `emoticon`, `sticker_document_id`),
  KEY `idx_sticker_packs_lookup` (`emoticon`, `sticker_set_id`, `order2`),
  KEY `idx_sticker_packs_set_order` (`sticker_set_id`, `order2`),
  CONSTRAINT `fk_sticker_packs_set` FOREIGN KEY (`sticker_set_id`) REFERENCES `sticker_sets` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `fk_sticker_packs_document` FOREIGN KEY (`sticker_document_id`) REFERENCES `sticker_documents` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `featured_sticker_sets` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `sticker_set_id` BIGINT UNSIGNED NOT NULL,
  `category` TINYINT UNSIGNED NOT NULL DEFAULT 1 COMMENT '1=stickers,2=emoji',
  `display_order` INT UNSIGNED NOT NULL DEFAULT 0,
  `featured_at` INT NOT NULL DEFAULT 0,
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_featured_sticker_set` (`category`, `sticker_set_id`),
  KEY `idx_featured_sticker_order` (`category`, `display_order`, `sticker_set_id`),
  CONSTRAINT `fk_featured_sticker_set` FOREIGN KEY (`sticker_set_id`) REFERENCES `sticker_sets` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `featured_sticker_set_covers` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `featured_sticker_set_id` BIGINT UNSIGNED NOT NULL,
  `sticker_document_id` BIGINT UNSIGNED NOT NULL,
  `order2` INT UNSIGNED NOT NULL DEFAULT 0,
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_featured_sticker_cover` (`featured_sticker_set_id`, `sticker_document_id`),
  KEY `idx_featured_sticker_cover_order` (`featured_sticker_set_id`, `order2`, `id`),
  CONSTRAINT `fk_featured_sticker_cover_featured` FOREIGN KEY (`featured_sticker_set_id`) REFERENCES `featured_sticker_sets` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `fk_featured_sticker_cover_document` FOREIGN KEY (`sticker_document_id`) REFERENCES `sticker_documents` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `available_reactions` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `import_id` BIGINT UNSIGNED NOT NULL,
  `emoticon` VARCHAR(64) COLLATE utf8mb4_bin NOT NULL,
  `title` VARCHAR(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `inactive` TINYINT(1) NOT NULL DEFAULT 0,
  `premium` TINYINT(1) NOT NULL DEFAULT 0,
  `display_order` INT UNSIGNED NOT NULL DEFAULT 0,
  `reaction_hash` BIGINT NOT NULL DEFAULT 0,
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_available_reaction_emoticon` (`emoticon`),
  KEY `idx_available_reactions_catalog` (`inactive`, `display_order`, `id`),
  CONSTRAINT `fk_available_reactions_import` FOREIGN KEY (`import_id`) REFERENCES `sticker_imports` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `available_reaction_documents` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `available_reaction_id` BIGINT UNSIGNED NOT NULL,
  `role` TINYINT UNSIGNED NOT NULL COMMENT '1=static,2=appear,3=select,4=activate,5=effect,6=around,7=center',
  `sticker_document_id` BIGINT UNSIGNED NOT NULL,
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_available_reaction_role` (`available_reaction_id`, `role`),
  KEY `idx_available_reaction_document` (`sticker_document_id`),
  CONSTRAINT `fk_available_reaction_document_reaction` FOREIGN KEY (`available_reaction_id`) REFERENCES `available_reactions` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `fk_available_reaction_document_asset` FOREIGN KEY (`sticker_document_id`) REFERENCES `sticker_documents` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `emoji_keywords` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `import_id` BIGINT UNSIGNED NOT NULL,
  `language_code` VARCHAR(16) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  `version` INT UNSIGNED NOT NULL,
  `keyword` VARCHAR(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `keyword_normalized` VARCHAR(255) COLLATE utf8mb4_bin NOT NULL,
  `emoticon` VARCHAR(64) COLLATE utf8mb4_bin NOT NULL,
  `order2` INT UNSIGNED NOT NULL DEFAULT 0,
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_emoji_keyword_mapping` (`language_code`, `version`, `keyword_normalized`, `emoticon`),
  KEY `idx_emoji_keyword_lookup` (`language_code`, `keyword_normalized`, `order2`),
  KEY `idx_emoji_keyword_version` (`language_code`, `version`, `id`),
  CONSTRAINT `fk_emoji_keywords_import` FOREIGN KEY (`import_id`) REFERENCES `sticker_imports` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `user_sticker_sets` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `user_id` BIGINT NOT NULL,
  `sticker_set_id` BIGINT UNSIGNED NOT NULL,
  `category` TINYINT UNSIGNED NOT NULL DEFAULT 1 COMMENT '1=stickers,2=masks,3=emoji',
  `archived` TINYINT(1) NOT NULL DEFAULT 0,
  `order2` INT UNSIGNED NOT NULL DEFAULT 0,
  `installed_at` INT NOT NULL DEFAULT 0,
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_user_sticker_set` (`user_id`, `category`, `sticker_set_id`),
  KEY `idx_user_sticker_sets_order` (`user_id`, `category`, `archived`, `order2`, `id`),
  CONSTRAINT `fk_user_sticker_sets_set` FOREIGN KEY (`sticker_set_id`) REFERENCES `sticker_sets` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `user_recent_stickers` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `user_id` BIGINT NOT NULL,
  `sticker_document_id` BIGINT UNSIGNED NOT NULL,
  `attached` TINYINT(1) NOT NULL DEFAULT 0,
  `used_at` INT NOT NULL,
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_user_recent_sticker` (`user_id`, `attached`, `sticker_document_id`),
  KEY `idx_user_recent_stickers` (`user_id`, `attached`, `used_at`, `id`),
  CONSTRAINT `fk_user_recent_sticker_document` FOREIGN KEY (`sticker_document_id`) REFERENCES `sticker_documents` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `user_faved_stickers` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `user_id` BIGINT NOT NULL,
  `sticker_document_id` BIGINT UNSIGNED NOT NULL,
  `faved_at` INT NOT NULL,
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_user_faved_sticker` (`user_id`, `sticker_document_id`),
  KEY `idx_user_faved_stickers` (`user_id`, `faved_at`, `id`),
  CONSTRAINT `fk_user_faved_sticker_document` FOREIGN KEY (`sticker_document_id`) REFERENCES `sticker_documents` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `user_featured_sticker_reads` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `user_id` BIGINT NOT NULL,
  `sticker_set_id` BIGINT UNSIGNED NOT NULL,
  `read_at` INT NOT NULL,
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_user_featured_sticker_read` (`user_id`, `sticker_set_id`),
  KEY `idx_user_featured_sticker_reads` (`user_id`, `read_at`, `id`),
  CONSTRAINT `fk_user_featured_sticker_read_set` FOREIGN KEY (`sticker_set_id`) REFERENCES `sticker_sets` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `user_default_reaction` (
  `user_id` BIGINT NOT NULL,
  `reaction_type` TINYINT UNSIGNED NOT NULL COMMENT '1=emoji,2=custom_emoji',
  `reaction_value` VARCHAR(64) COLLATE utf8mb4_bin NOT NULL,
  `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `user_recent_reactions` (
  `user_id` BIGINT NOT NULL,
  `reaction_type` TINYINT UNSIGNED NOT NULL COMMENT '1=emoji,2=custom_emoji',
  `reaction_value` VARCHAR(64) COLLATE utf8mb4_bin NOT NULL,
  `usage_count` BIGINT UNSIGNED NOT NULL DEFAULT 1,
  `last_used_at` INT NOT NULL,
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`user_id`, `reaction_type`, `reaction_value`),
  KEY `idx_user_recent_reactions_recent` (`user_id`, `last_used_at`, `reaction_type`, `reaction_value`),
  KEY `idx_user_recent_reactions_top` (`user_id`, `usage_count`, `last_used_at`, `reaction_type`, `reaction_value`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `message_reactions` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `user_id` BIGINT NOT NULL,
  `author_user_id` BIGINT NOT NULL,
  `peer_type` INT NOT NULL,
  `peer_id` BIGINT NOT NULL,
  `message_id` INT NOT NULL,
  `dialog_message_id` BIGINT NOT NULL,
  `reaction_type` TINYINT UNSIGNED NOT NULL COMMENT '1=emoji,2=custom_emoji',
  `reaction_value` VARCHAR(64) COLLATE utf8mb4_bin NOT NULL,
  `big` TINYINT(1) NOT NULL DEFAULT 0,
  `unread` TINYINT(1) NOT NULL DEFAULT 0,
  `date2` INT NOT NULL,
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_message_reaction_actor` (`peer_type`, `peer_id`, `dialog_message_id`, `user_id`, `reaction_type`, `reaction_value`),
  KEY `idx_message_reactions_list` (`peer_type`, `peer_id`, `dialog_message_id`, `date2`, `id`),
  KEY `idx_message_reactions_actor` (`user_id`, `peer_type`, `peer_id`, `dialog_message_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `message_reaction_states` (
  `peer_type` INT NOT NULL,
  `peer_id` BIGINT NOT NULL,
  `dialog_message_id` BIGINT NOT NULL,
  `refresh_pending` TINYINT(1) NOT NULL DEFAULT 0,
  `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`peer_type`, `peer_id`, `dialog_message_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `user_unread_reaction_messages` (
  `user_id` BIGINT NOT NULL,
  `peer_type` INT NOT NULL,
  `peer_id` BIGINT NOT NULL,
  `message_id` INT NOT NULL,
  `dialog_message_id` BIGINT NOT NULL,
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`user_id`, `peer_type`, `peer_id`, `message_id`),
  KEY `idx_unread_reaction_dialog` (`user_id`, `peer_type`, `peer_id`, `message_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `reaction_reports` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `reporter_user_id` BIGINT NOT NULL,
  `peer_type` INT NOT NULL,
  `peer_id` BIGINT NOT NULL,
  `dialog_message_id` BIGINT NOT NULL,
  `reaction_actor_user_id` BIGINT NOT NULL,
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_reaction_report` (`reporter_user_id`, `peer_type`, `peer_id`, `dialog_message_id`, `reaction_actor_user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `chat_reaction_settings` (
  `peer_type` INT NOT NULL,
  `peer_id` BIGINT NOT NULL,
  `policy_type` INT NOT NULL,
  `reactions_limit` INT NULL,
  `updated_by_user_id` BIGINT NOT NULL,
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`peer_type`, `peer_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `chat_available_reactions` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `peer_type` INT NOT NULL,
  `peer_id` BIGINT NOT NULL,
  `reaction_type` TINYINT UNSIGNED NOT NULL,
  `reaction_value` VARCHAR(64) COLLATE utf8mb4_bin NOT NULL,
  `order2` INT UNSIGNED NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_chat_available_reaction` (`peer_type`, `peer_id`, `reaction_type`, `reaction_value`),
  KEY `idx_chat_available_reactions_order` (`peer_type`, `peer_id`, `order2`, `id`),
  CONSTRAINT `fk_chat_available_reactions_settings` FOREIGN KEY (`peer_type`, `peer_id`) REFERENCES `chat_reaction_settings` (`peer_type`, `peer_id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT IGNORE INTO `schema_migrations` (`version`)
VALUES ('20260810-layer186-stickers-reactions');
