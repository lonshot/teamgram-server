USE pwm;

CREATE TABLE IF NOT EXISTS `user_sticker_catalog_state` (
  `user_id` BIGINT NOT NULL,
  `category` TINYINT UNSIGNED NOT NULL COMMENT '1=stickers,2=masks,3=emoji',
  `initialized_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`user_id`, `category`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT IGNORE INTO `schema_migrations` (`version`)
VALUES ('20260810-user-sticker-catalog-state');
