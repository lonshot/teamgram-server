USE pwm;

CREATE TABLE IF NOT EXISTS `game_commands` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `command_key` VARCHAR(160) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  `command_type` VARCHAR(64) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  `actor_user_id` BIGINT NOT NULL,
  `player_pair_id` INT DEFAULT NULL,
  `pair_game_id` INT DEFAULT NULL,
  `game_config_id` INT DEFAULT NULL,
  `task_id` VARCHAR(50) DEFAULT NULL,
  `chain_task_id` VARCHAR(50) DEFAULT NULL,
  `completed_task_id` INT DEFAULT NULL,
  `task_answer_id` INT DEFAULT NULL,
  `payload` JSON NOT NULL,
  `payload_hash` BINARY(32) NOT NULL,
  `status` TINYINT UNSIGNED NOT NULL DEFAULT 0,
  `result_payload` JSON DEFAULT NULL,
  `error_code` VARCHAR(64) CHARACTER SET ascii COLLATE ascii_bin DEFAULT NULL,
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `applied_at` TIMESTAMP NULL DEFAULT NULL,
  `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_game_commands_key` (`command_key`),
  KEY `idx_game_commands_actor_created` (`actor_user_id`, `created_at`),
  KEY `idx_game_commands_pair_game` (`pair_game_id`, `id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `game_events` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `event_id` CHAR(36) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  `command_id` BIGINT UNSIGNED NOT NULL,
  `recipient_user_id` BIGINT NOT NULL,
  `event_type` VARCHAR(128) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  `aggregate_type` VARCHAR(64) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  `aggregate_id` VARCHAR(64) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  `payload` JSON NOT NULL,
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_game_events_event_recipient` (`event_id`, `recipient_user_id`),
  KEY `idx_game_events_recipient_cursor` (`recipient_user_id`, `id`),
  CONSTRAINT `fk_game_events_command` FOREIGN KEY (`command_id`) REFERENCES `game_commands` (`id`)
    ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `game_outbox` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `event_id` CHAR(36) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  `command_id` BIGINT UNSIGNED NOT NULL,
  `event_type` VARCHAR(128) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  `payload` JSON NOT NULL,
  `available_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `published_at` TIMESTAMP NULL DEFAULT NULL,
  `attempt_count` INT UNSIGNED NOT NULL DEFAULT 0,
  `lease_owner` VARCHAR(64) CHARACTER SET ascii COLLATE ascii_bin NOT NULL DEFAULT '',
  `lease_until` TIMESTAMP NULL DEFAULT NULL,
  `last_error` VARCHAR(2048) NOT NULL DEFAULT '',
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_game_outbox_event` (`event_id`),
  KEY `idx_game_outbox_due` (`published_at`, `available_at`, `lease_until`, `id`),
  CONSTRAINT `fk_game_outbox_command` FOREIGN KEY (`command_id`) REFERENCES `game_commands` (`id`)
    ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT IGNORE INTO `schema_migrations` (`version`)
VALUES ('20260811-native-game-events');
