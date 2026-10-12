USE pwm;

CREATE TABLE IF NOT EXISTS `user_saved_gifs` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `user_id` BIGINT NOT NULL,
  `document_id` BIGINT NOT NULL,
  `access_hash` BIGINT NOT NULL,
  `saved_at` INT NOT NULL,
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_user_saved_gif` (`user_id`, `document_id`),
  KEY `idx_user_saved_gifs` (`user_id`, `saved_at`, `id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT IGNORE INTO `schema_migrations` (`version`)
VALUES ('20260813-saved-gifs');
