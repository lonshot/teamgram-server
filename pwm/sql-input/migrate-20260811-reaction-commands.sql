USE pwm;

CREATE TABLE IF NOT EXISTS `message_reaction_commands` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `command_key` VARCHAR(160) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  `user_id` BIGINT NOT NULL,
  `auth_key_id` BIGINT NOT NULL DEFAULT 0,
  `peer_type` INT NOT NULL,
  `request_peer_id` BIGINT NOT NULL,
  `peer_id` BIGINT NOT NULL,
  `message_id` INT NOT NULL,
  `dialog_message_id` BIGINT NOT NULL,
  `generation` BIGINT UNSIGNED NOT NULL DEFAULT 1,
  `delivered_generation` BIGINT UNSIGNED NOT NULL DEFAULT 0,
  `attempt_count` INT UNSIGNED NOT NULL DEFAULT 0,
  `next_attempt_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `lease_owner` VARCHAR(64) CHARACTER SET ascii COLLATE ascii_bin NOT NULL DEFAULT '',
  `lease_until` TIMESTAMP NULL DEFAULT NULL,
  `last_error` VARCHAR(2048) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_message_reaction_command_key` (`command_key`),
  UNIQUE KEY `uk_message_reaction_command_actor` (`peer_type`, `peer_id`, `dialog_message_id`, `user_id`),
  KEY `idx_message_reaction_commands_due` (`next_attempt_at`, `lease_until`, `id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT IGNORE INTO `schema_migrations` (`version`)
VALUES ('20260811-reaction-commands');
