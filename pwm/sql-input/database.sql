use pwm;

SET
  SQL_MODE = "NO_AUTO_VALUE_ON_ZERO"; 

SET
  time_zone = "+00:00";

--
-- 数据库： `pwm2`
--
-- --------------------------------------------------------
--
-- 表的结构 `auths`
--
CREATE TABLE
  `auths` (
    `id` bigint (20) NOT NULL,
    `auth_key_id` bigint (20) NOT NULL,
    `layer` int (11) NOT NULL DEFAULT '0',
    `api_id` int (11) NOT NULL,
    `device_model` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
    `system_version` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
    `app_version` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
    `system_lang_code` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
    `lang_pack` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
    `lang_code` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
    `system_code` varchar(256) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
    `proxy` varchar(512) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
    `params` json NOT NULL,
    `client_ip` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
    `date_active` bigint (20) NOT NULL DEFAULT '0',
    `deleted` tinyint (1) NOT NULL DEFAULT '0',
    `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
  ) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

-- --------------------------------------------------------
--
-- 表的结构 `auth_keys`
--
CREATE TABLE
  `auth_keys` (
    `id` bigint (20) NOT NULL,
    `auth_key_id` bigint (20) NOT NULL COMMENT 'auth_id',
    `body` varchar(512) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'auth_key，原始数据为256的二进制数据，存储时转换成base64格式',
    `deleted` tinyint (1) NOT NULL DEFAULT '0',
    `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
  ) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

-- --------------------------------------------------------
--
-- 表的结构 `auth_key_infos`
--
CREATE TABLE
  `auth_key_infos` (
    `id` bigint (20) NOT NULL,
    `auth_key_id` bigint (20) NOT NULL,
    `auth_key_type` int (11) NOT NULL,
    `perm_auth_key_id` bigint (20) NOT NULL DEFAULT '0',
    `temp_auth_key_id` bigint (20) NOT NULL DEFAULT '0',
    `media_temp_auth_key_id` bigint (20) NOT NULL DEFAULT '0',
    `deleted` tinyint (1) NOT NULL DEFAULT '0',
    `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
  ) ENGINE = InnoDB DEFAULT CHARSET = utf8;

-- --------------------------------------------------------
--
-- 表的结构 `auth_seq_updates`
--
CREATE TABLE
  `auth_seq_updates` (
    `id` bigint (20) NOT NULL,
    `auth_id` bigint (20) NOT NULL,
    `user_id` bigint (20) NOT NULL,
    `seq` int (11) NOT NULL DEFAULT '0',
    `update_type` int (11) NOT NULL DEFAULT '0',
    `update_data` json NOT NULL,
    `date2` bigint (20) NOT NULL DEFAULT '0',
    `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
  ) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

-- --------------------------------------------------------
--
-- 表的结构 `auth_users`
--
CREATE TABLE
  `auth_users` (
    `id` bigint (20) NOT NULL,
    `auth_key_id` bigint (20) NOT NULL,
    `user_id` bigint (20) NOT NULL DEFAULT '0',
    `hash` bigint (20) NOT NULL DEFAULT '0',
    `layer` int (11) NOT NULL DEFAULT '0',
    `device_model` varchar(128) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
    `platform` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
    `system_version` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
    `api_id` int (11) NOT NULL DEFAULT '0',
    `app_name` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
    `app_version` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
    `date_created` bigint (20) NOT NULL DEFAULT '0',
    `date_actived` bigint (20) NOT NULL DEFAULT '0',
    `ip` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
    `country` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
    `region` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
    `deleted` tinyint (1) NOT NULL DEFAULT '0',
    `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
  ) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

-- --------------------------------------------------------
--
-- 表的结构 `bots`
--
CREATE TABLE
  `bots` (
    `id` bigint (20) NOT NULL,
    `bot_id` bigint (20) NOT NULL,
    `bot_type` int (11) NOT NULL DEFAULT '0',
    `creator_user_id` bigint (20) NOT NULL DEFAULT '0',
    `token` varchar(128) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
    `description` varchar(10240) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
    `bot_chat_history` tinyint (1) NOT NULL DEFAULT '0',
    `bot_nochats` tinyint (1) NOT NULL DEFAULT '1',
    `verified` tinyint (1) NOT NULL DEFAULT '0',
    `bot_inline_geo` tinyint (1) NOT NULL DEFAULT '0',
    `bot_info_version` int (11) NOT NULL DEFAULT '1',
    `bot_inline_placeholder` varchar(128) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
    `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
  ) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

-- --------------------------------------------------------
--
-- 表的结构 `bot_commands`
--
CREATE TABLE
  `bot_commands` (
    `id` bigint (20) NOT NULL,
    `bot_id` bigint (20) NOT NULL,
    `command` varchar(128) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
    `description` varchar(10240) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
    `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
  ) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

-- --------------------------------------------------------
--
-- 表的结构 `chats`
--
CREATE TABLE
  `chats` (
    `id` bigint (20) NOT NULL,
    `creator_user_id` bigint (20) NOT NULL,
    `access_hash` bigint (20) NOT NULL,
    `random_id` bigint (20) NOT NULL,
    `participant_count` int (11) NOT NULL,
    `title` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
    `about` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
    `photo_id` bigint (20) NOT NULL DEFAULT '0',
    `default_banned_rights` bigint (20) NOT NULL DEFAULT '0',
    `migrated_to_id` bigint (20) NOT NULL DEFAULT '0',
    `migrated_to_access_hash` bigint (20) NOT NULL DEFAULT '0',
    `deactivated` tinyint (1) NOT NULL DEFAULT '0',
    `version` int (11) NOT NULL DEFAULT '1',
    `date` bigint (20) NOT NULL DEFAULT '0',
    `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
  ) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

-- --------------------------------------------------------
--
-- 表的结构 `chat_invites`
--
CREATE TABLE
  `chat_invites` (
    `id` bigint (20) NOT NULL,
    `chat_id` bigint (20) NOT NULL,
    `admin_id` bigint (20) NOT NULL,
    `migrated_to_id` bigint (20) NOT NULL DEFAULT '0',
    `link` varchar(64) COLLATE utf8mb4_bin NOT NULL,
    `permanent` tinyint (1) NOT NULL DEFAULT '0',
    `revoked` tinyint (1) NOT NULL DEFAULT '0',
    `request_needed` tinyint (1) NOT NULL DEFAULT '0',
    `start_date` bigint (20) NOT NULL DEFAULT '0',
    `expire_date` bigint (20) NOT NULL DEFAULT '0',
    `usage_limit` int (11) NOT NULL DEFAULT '0',
    `usage2` int (11) NOT NULL DEFAULT '0',
    `requested` int (11) NOT NULL DEFAULT '0',
    `title` varchar(64) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
    `date2` bigint (20) NOT NULL,
    `state` int (11) NOT NULL DEFAULT '0',
    `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
  ) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_bin;

-- --------------------------------------------------------
--
-- 表的结构 `chat_invite_participants`
--
CREATE TABLE
  `chat_invite_participants` (
    `id` bigint (20) NOT NULL,
    `link` varchar(32) COLLATE utf8mb4_bin NOT NULL,
    `user_id` bigint (20) NOT NULL,
    `date2` bigint (20) NOT NULL,
    `deleted` tinyint (1) NOT NULL DEFAULT '0',
    `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
  ) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_bin;

-- --------------------------------------------------------
--
-- 表的结构 `chat_participants`
--
CREATE TABLE
  `chat_participants` (
    `id` bigint (20) NOT NULL,
    `chat_id` bigint (20) NOT NULL,
    `user_id` bigint (20) NOT NULL,
    `participant_type` int (11) DEFAULT '0',
    `link` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
    `usage2` int (11) NOT NULL DEFAULT '0',
    `admin_rights` int (11) NOT NULL DEFAULT '0',
    `inviter_user_id` bigint (20) NOT NULL DEFAULT '0',
    `invited_at` bigint (20) NOT NULL DEFAULT '0',
    `kicked_at` bigint (20) NOT NULL DEFAULT '0',
    `left_at` bigint (20) NOT NULL DEFAULT '0',
    `state` int (11) NOT NULL DEFAULT '0',
    `date2` bigint (20) NOT NULL DEFAULT '0',
    `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
  ) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

-- --------------------------------------------------------
--
-- 表的结构 `devices`
--
CREATE TABLE
  `devices` (
    `id` bigint (20) NOT NULL,
    `auth_key_id` bigint (20) NOT NULL,
    `user_id` bigint (20) NOT NULL,
    `token_type` int (11) NOT NULL,
    `token` varchar(512) COLLATE utf8mb4_unicode_ci NOT NULL,
    `no_muted` tinyint (1) NOT NULL DEFAULT '0',
    `locked_period` int (11) NOT NULL DEFAULT '0',
    `app_sandbox` tinyint (1) NOT NULL DEFAULT '0',
    `secret` varchar(1024) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
    `other_uids` varchar(1024) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
    `state` tinyint (1) NOT NULL DEFAULT '0',
    `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
  ) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

-- --------------------------------------------------------
--
-- 表的结构 `dialogs`
--
CREATE TABLE
  `dialogs` (
    `id` bigint (20) NOT NULL,
    `user_id` bigint (20) NOT NULL,
    `peer_type` int (11) NOT NULL DEFAULT '2',
    `peer_id` bigint (20) NOT NULL,
    `peer_dialog_id` bigint (20) NOT NULL,
    `pinned` bigint (20) NOT NULL DEFAULT '0',
    `top_message` int (11) NOT NULL DEFAULT '0',
    `pinned_msg_id` int (11) NOT NULL DEFAULT '0',
    `read_inbox_max_id` int (11) NOT NULL DEFAULT '0',
    `read_outbox_max_id` int (11) NOT NULL DEFAULT '0',
    `unread_count` int (11) NOT NULL DEFAULT '0',
    `unread_mentions_count` int (11) NOT NULL DEFAULT '0',
    `unread_mark` tinyint (1) NOT NULL DEFAULT '0',
    `draft_type` int (11) NOT NULL DEFAULT '0',
    `draft_message_data` json NOT NULL,
    `folder_id` int (11) NOT NULL DEFAULT '0',
    `folder_pinned` bigint (20) NOT NULL DEFAULT '0',
    `has_scheduled` tinyint (1) NOT NULL DEFAULT '0',
    `date2` bigint (20) NOT NULL,
    `deleted` tinyint (1) NOT NULL DEFAULT '0',
    `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
  ) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

-- --------------------------------------------------------
--
-- 表的结构 `dialog_filters`
--
CREATE TABLE
  `dialog_filters` (
    `id` bigint (20) NOT NULL,
    `user_id` bigint (20) NOT NULL,
    `dialog_filter_id` int (11) NOT NULL,
    `dialog_filter` json NOT NULL,
    `order_value` bigint (20) NOT NULL DEFAULT '0',
    `deleted` tinyint (1) NOT NULL DEFAULT '0',
    `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
  ) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

-- --------------------------------------------------------
--
-- 表的结构 `documents`
--
CREATE TABLE
  `documents` (
    `id` bigint (20) NOT NULL,
    `document_id` bigint (20) NOT NULL,
    `access_hash` bigint (20) NOT NULL,
    `dc_id` int (11) NOT NULL,
    `file_path` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
    `file_size` int (11) NOT NULL,
    `uploaded_file_name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
    `ext` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
    `mime_type` varchar(128) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
    `thumb_id` bigint (20) NOT NULL DEFAULT '0',
    `video_thumb_id` bigint (20) NOT NULL DEFAULT '0',
    `version` int (11) NOT NULL DEFAULT '0',
    `attributes` json NOT NULL,
    `date2` bigint (20) NOT NULL DEFAULT '0',
    `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
  ) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

-- --------------------------------------------------------
--
-- 表的结构 `encrypted_files`
--
CREATE TABLE
  `encrypted_files` (
    `id` bigint (20) NOT NULL,
    `encrypted_file_id` bigint (20) NOT NULL,
    `access_hash` bigint (20) NOT NULL,
    `dc_id` int (11) NOT NULL,
    `file_size` int (11) NOT NULL,
    `key_fingerprint` int (11) NOT NULL,
    `md5_checksum` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
    `file_path` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
    `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
  ) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

-- --------------------------------------------------------
--
-- 表的结构 `hash_tags`
--
CREATE TABLE
  `hash_tags` (
    `id` bigint (20) NOT NULL,
    `user_id` bigint (20) NOT NULL,
    `peer_type` int (11) NOT NULL,
    `peer_id` bigint (20) NOT NULL,
    `hash_tag` varchar(128) COLLATE utf8mb4_unicode_ci NOT NULL,
    `hash_tag_message_id` int (11) NOT NULL,
    `deleted` tinyint (1) NOT NULL DEFAULT '0',
    `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
  ) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

-- --------------------------------------------------------
--
-- 表的结构 `imported_contacts`
--
CREATE TABLE
  `imported_contacts` (
    `id` bigint (20) NOT NULL,
    `user_id` bigint (20) NOT NULL,
    `imported_user_id` bigint (20) NOT NULL,
    `deleted` tinyint (1) NOT NULL DEFAULT '0',
    `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
  ) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

-- --------------------------------------------------------
--
-- 表的结构 `messages`
--
CREATE TABLE
  `messages` (
    `id` bigint (20) NOT NULL,
    `user_id` bigint (20) NOT NULL,
    `user_message_box_id` int (11) NOT NULL,
    `dialog_id1` bigint (20) NOT NULL,
    `dialog_id2` bigint (20) NOT NULL,
    `dialog_message_id` bigint (20) NOT NULL,
    `sender_user_id` bigint (20) NOT NULL,
    `peer_type` int (11) NOT NULL,
    `peer_id` bigint (20) NOT NULL,
    `random_id` bigint (20) NOT NULL DEFAULT '0',
    `message_filter_type` int (11) NOT NULL DEFAULT '0',
    `message_data` json DEFAULT NULL,
    `message` varchar(6000) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
    `mentioned` tinyint (1) NOT NULL DEFAULT '0',
    `media_unread` tinyint (1) NOT NULL DEFAULT '0',
    `pinned` tinyint (1) NOT NULL DEFAULT '0',
    `date2` bigint (20) NOT NULL DEFAULT '0',
    `deleted` tinyint (1) NOT NULL DEFAULT '0',
    `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
  ) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

-- --------------------------------------------------------
--
-- 表的结构 `phone_books`
--
CREATE TABLE
  `phone_books` (
    `id` bigint (20) NOT NULL,
    `user_id` bigint (20) NOT NULL DEFAULT '0',
    `auth_key_id` bigint (20) NOT NULL,
    `client_id` bigint (20) NOT NULL,
    `phone` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL,
    `first_name` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL,
    `last_name` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL,
    `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
  ) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

-- --------------------------------------------------------
--
-- 表的结构 `photos`
--
CREATE TABLE
  `photos` (
    `id` bigint (20) NOT NULL,
    `photo_id` bigint (20) NOT NULL,
    `access_hash` bigint (20) NOT NULL,
    `has_stickers` tinyint (1) NOT NULL DEFAULT '0',
    `dc_id` int (11) NOT NULL DEFAULT '2',
    `date2` bigint (20) NOT NULL DEFAULT '0',
    `has_video` tinyint (1) NOT NULL DEFAULT '0',
    `size_id` bigint (20) NOT NULL DEFAULT '0',
    `video_size_id` bigint (20) NOT NULL DEFAULT '0',
    `input_file_name` varchar(128) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
    `ext` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
    `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
  ) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

-- --------------------------------------------------------
--
-- 表的结构 `photo_sizes`
--
CREATE TABLE
  `photo_sizes` (
    `id` bigint (20) NOT NULL,
    `photo_size_id` bigint (20) NOT NULL,
    `size_type` char(1) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
    `volume_id` bigint (20) NOT NULL,
    `local_id` int (11) NOT NULL,
    `secret` bigint (20) NOT NULL,
    `width` int (11) NOT NULL,
    `height` int (11) NOT NULL,
    `file_size` int (11) NOT NULL,
    `file_path` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
    `has_stripped` tinyint (1) NOT NULL DEFAULT '0',
    `stripped_bytes` varchar(4096) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
    `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
  ) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

-- --------------------------------------------------------
--
-- 表的结构 `popular_contacts`
--
CREATE TABLE
  `popular_contacts` (
    `id` bigint (20) NOT NULL,
    `phone` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL,
    `importers` int (11) NOT NULL DEFAULT '1',
    `deleted` tinyint (1) NOT NULL DEFAULT '0',
    `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `update_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
  ) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

-- --------------------------------------------------------
--
-- 表的结构 `predefined_users`
--
CREATE TABLE
  `predefined_users` (
    `id` bigint (20) NOT NULL,
    `phone` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL,
    `first_name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
    `last_name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
    `username` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
    `code` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL,
    `verified` tinyint (1) NOT NULL DEFAULT '0',
    `registered_user_id` bigint (20) NOT NULL DEFAULT '0',
    `deleted` tinyint (1) NOT NULL DEFAULT '0',
    `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
  ) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

-- --------------------------------------------------------
--
-- 表的结构 `unregistered_contacts`
--
CREATE TABLE
  `unregistered_contacts` (
    `id` bigint (20) NOT NULL,
    `phone` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL,
    `importer_user_id` bigint (20) NOT NULL,
    `import_first_name` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL,
    `import_last_name` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL,
    `imported` tinyint (1) NOT NULL DEFAULT '0',
    `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
  ) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

-- --------------------------------------------------------
--
-- 表的结构 `username`
--
CREATE TABLE
  `username` (
    `id` bigint (20) NOT NULL,
    `username` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL,
    `peer_type` int (11) NOT NULL DEFAULT '0',
    `peer_id` bigint (20) NOT NULL DEFAULT '0',
    `deleted` tinyint (1) NOT NULL DEFAULT '0',
    `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
  ) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

-- --------------------------------------------------------
--
-- 表的结构 `users`
--
CREATE TABLE
  `users` (
    `id` bigint (20) NOT NULL,
    `user_type` int (11) NOT NULL DEFAULT '2',
    `access_hash` bigint (20) NOT NULL,
    `secret_key_id` bigint (20) NOT NULL DEFAULT '0',
    `first_name` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
    `last_name` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
    `username` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
    `phone` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL,
    `country_code` varchar(3) COLLATE utf8mb4_unicode_ci NOT NULL,
    `verified` tinyint (1) NOT NULL DEFAULT '0',
    `support` tinyint (1) NOT NULL DEFAULT '0',
    `scam` tinyint (1) NOT NULL DEFAULT '0',
    `fake` tinyint (1) NOT NULL DEFAULT '0',
    `about` varchar(128) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
    `state` int (11) NOT NULL DEFAULT '0',
    `is_bot` tinyint (1) NOT NULL DEFAULT '0',
    `account_days_ttl` int (11) NOT NULL DEFAULT '180',
    `photo_id` bigint (20) NOT NULL DEFAULT '0',
    `restricted` tinyint (1) NOT NULL DEFAULT '0',
    `restriction_reason` varchar(128) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
    `archive_and_mute_new_noncontact_peers` tinyint (1) NOT NULL DEFAULT '0',
    `deleted` tinyint (1) NOT NULL DEFAULT '0',
    `delete_reason` varchar(128) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
    `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
  ) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

-- --------------------------------------------------------
--
-- 表的结构 `user_contacts`
--
CREATE TABLE
  `user_contacts` (
    `id` bigint (20) NOT NULL,
    `owner_user_id` bigint (20) NOT NULL,
    `contact_user_id` bigint (20) NOT NULL,
    `contact_phone` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
    `contact_first_name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
    `contact_last_name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
    `mutual` tinyint (1) NOT NULL DEFAULT '0',
    `is_deleted` tinyint (1) NOT NULL DEFAULT '0',
    `date2` bigint (20) NOT NULL,
    `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
  ) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

-- --------------------------------------------------------
--
-- 表的结构 `user_global_privacy_settings`
--
CREATE TABLE
  `user_global_privacy_settings` (
    `id` bigint (20) NOT NULL,
    `user_id` bigint (20) NOT NULL,
    `archive_and_mute_new_noncontact_peers` tinyint (1) NOT NULL DEFAULT '0',
    `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
  ) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

-- --------------------------------------------------------
--
-- 表的结构 `user_notify_settings`
--
CREATE TABLE
  `user_notify_settings` (
    `id` bigint (20) NOT NULL,
    `user_id` bigint (20) NOT NULL,
    `peer_type` int (11) NOT NULL,
    `peer_id` bigint (20) NOT NULL,
    `show_previews` int (11) NOT NULL DEFAULT '-1',
    `silent` int (11) NOT NULL DEFAULT '-1',
    `mute_until` int (11) NOT NULL DEFAULT '-1',
    `sound` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'default',
    `deleted` tinyint (1) NOT NULL DEFAULT '0',
    `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
  ) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

-- --------------------------------------------------------
--
-- 表的结构 `user_peer_blocks`
--
CREATE TABLE
  `user_peer_blocks` (
    `id` bigint (20) NOT NULL,
    `user_id` bigint (20) NOT NULL,
    `peer_type` int (11) NOT NULL,
    `peer_id` bigint (20) NOT NULL,
    `date` bigint (20) NOT NULL DEFAULT '0',
    `deleted` tinyint (1) NOT NULL DEFAULT '0',
    `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
  ) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

-- --------------------------------------------------------
--
-- 表的结构 `user_peer_settings`
--
CREATE TABLE
  `user_peer_settings` (
    `id` bigint (20) NOT NULL,
    `user_id` bigint (20) NOT NULL,
    `peer_type` int (11) NOT NULL,
    `peer_id` bigint (20) NOT NULL,
    `hide` tinyint (1) NOT NULL DEFAULT '0',
    `report_spam` tinyint (1) NOT NULL DEFAULT '0',
    `add_contact` tinyint (1) NOT NULL DEFAULT '0',
    `block_contact` tinyint (1) NOT NULL DEFAULT '0',
    `share_contact` tinyint (1) NOT NULL DEFAULT '0',
    `need_contacts_exception` tinyint (1) NOT NULL DEFAULT '0',
    `report_geo` tinyint (1) NOT NULL DEFAULT '0',
    `autoarchived` tinyint (1) NOT NULL DEFAULT '0',
    `invite_members` tinyint (1) NOT NULL DEFAULT '0',
    `geo_distance` int (11) NOT NULL DEFAULT '0',
    `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
  ) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

-- --------------------------------------------------------
--
-- 表的结构 `user_presences`
--
CREATE TABLE
  `user_presences` (
    `id` bigint (20) NOT NULL,
    `user_id` bigint (20) NOT NULL,
    `last_seen_at` bigint (20) NOT NULL,
    `expires` int (10) NOT NULL DEFAULT '0',
    `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
  ) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

-- --------------------------------------------------------
--
-- 表的结构 `user_privacies`
--
CREATE TABLE
  `user_privacies` (
    `id` bigint (20) NOT NULL,
    `user_id` bigint (20) NOT NULL,
    `key_type` int (11) NOT NULL DEFAULT '0',
    `rules` json NOT NULL,
    `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
  ) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

-- --------------------------------------------------------
--
-- 表的结构 `user_profile_photos`
--
CREATE TABLE
  `user_profile_photos` (
    `id` bigint (20) NOT NULL,
    `user_id` bigint (20) NOT NULL,
    `photo_id` bigint (20) NOT NULL,
    `date2` bigint (20) NOT NULL COMMENT '排序',
    `deleted` tinyint (1) NOT NULL DEFAULT '0',
    `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
  ) ENGINE = InnoDB DEFAULT CHARSET = utf8;

-- --------------------------------------------------------
--
-- 表的结构 `user_pts_updates`
--
CREATE TABLE
  `user_pts_updates` (
    `id` bigint (20) NOT NULL,
    `user_id` bigint (20) NOT NULL,
    `pts` int (11) NOT NULL,
    `pts_count` int (11) NOT NULL,
    `update_type` tinyint (4) NOT NULL DEFAULT '0',
    `update_data` json NOT NULL,
    `date2` bigint (20) NOT NULL,
    `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
  ) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

-- --------------------------------------------------------
--
-- 表的结构 `user_settings`
--
CREATE TABLE
  `user_settings` (
    `id` bigint (20) NOT NULL,
    `user_id` bigint (20) NOT NULL,
    `key2` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL,
    `value` varchar(512) COLLATE utf8mb4_unicode_ci NOT NULL,
    `deleted` tinyint (1) NOT NULL DEFAULT '0',
    `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
  ) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

-- --------------------------------------------------------
--
-- 表的结构 `video_sizes`
--
CREATE TABLE
  `video_sizes` (
    `id` bigint (20) NOT NULL,
    `video_size_id` bigint (20) NOT NULL,
    `size_type` char(1) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
    `volume_id` bigint (20) NOT NULL,
    `local_id` int (11) NOT NULL,
    `secret` bigint (20) NOT NULL,
    `width` int (11) NOT NULL,
    `height` int (11) NOT NULL,
    `file_size` int (11) NOT NULL DEFAULT '0',
    `video_start_ts` double NOT NULL DEFAULT '0',
    `file_path` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
    `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
  ) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

--
-- 转储表的索引
--
--
-- 表的索引 `auths`
--
ALTER TABLE `auths` ADD PRIMARY KEY (`id`),
ADD UNIQUE KEY `auth_key_id` (`auth_key_id`);

--
-- 表的索引 `auth_keys`
--
ALTER TABLE `auth_keys` ADD PRIMARY KEY (`id`),
ADD UNIQUE KEY `auth_key_id` (`auth_key_id`);

--
-- 表的索引 `auth_key_infos`
--
ALTER TABLE `auth_key_infos` ADD PRIMARY KEY (`id`),
ADD UNIQUE KEY `auth_key_id` (`auth_key_id`);

--
-- 表的索引 `auth_seq_updates`
--
ALTER TABLE `auth_seq_updates` ADD PRIMARY KEY (`id`),
ADD UNIQUE KEY `auth_id` (`auth_id`, `user_id`, `seq`);

--
-- 表的索引 `auth_users`
--
ALTER TABLE `auth_users` ADD PRIMARY KEY (`id`),
ADD UNIQUE KEY `auth_key_id` (`auth_key_id`, `user_id`),
ADD KEY `auth_key_id_2` (`auth_key_id`, `user_id`, `deleted`);

--
-- 表的索引 `bots`
--
ALTER TABLE `bots` ADD PRIMARY KEY (`id`),
ADD UNIQUE KEY `bot_id` (`bot_id`),
ADD UNIQUE KEY `token` (`token`);

--
-- 表的索引 `bot_commands`
--
ALTER TABLE `bot_commands` ADD PRIMARY KEY (`id`),
ADD KEY `bot_id` (`bot_id`);

--
-- 表的索引 `chats`
--
ALTER TABLE `chats` ADD PRIMARY KEY (`id`);

--
-- 表的索引 `chat_invites`
--
ALTER TABLE `chat_invites` ADD PRIMARY KEY (`id`),
ADD UNIQUE KEY `link` (`link`),
ADD KEY `chat_id` (`chat_id`, `permanent`, `admin_id`),
ADD KEY `chat_id_2` (`chat_id`, `admin_id`);

--
-- 表的索引 `chat_invite_participants`
--
ALTER TABLE `chat_invite_participants` ADD PRIMARY KEY (`id`),
ADD UNIQUE KEY `link` (`link`, `user_id`),
ADD KEY `link_2` (`link`);

--
-- 表的索引 `chat_participants`
--
ALTER TABLE `chat_participants` ADD PRIMARY KEY (`id`),
ADD UNIQUE KEY `chat_id_2` (`chat_id`, `user_id`),
ADD KEY `chat_id` (`chat_id`);

--
-- 表的索引 `devices`
--
ALTER TABLE `devices` ADD PRIMARY KEY (`id`),
ADD UNIQUE KEY `auth_key_id` (`auth_key_id`, `user_id`, `token_type`);

--
-- 表的索引 `dialogs`
--
ALTER TABLE `dialogs` ADD PRIMARY KEY (`id`),
ADD UNIQUE KEY `user_id` (`user_id`, `peer_type`, `peer_id`),
ADD UNIQUE KEY `user_id_2` (`user_id`, `peer_dialog_id`);

--
-- 表的索引 `dialog_filters`
--
ALTER TABLE `dialog_filters` ADD PRIMARY KEY (`id`);

--
-- 表的索引 `documents`
--
ALTER TABLE `documents` ADD PRIMARY KEY (`id`),
ADD KEY `document_id` (`document_id`);

--
-- 表的索引 `encrypted_files`
--
ALTER TABLE `encrypted_files` ADD PRIMARY KEY (`id`);

--
-- 表的索引 `hash_tags`
--
ALTER TABLE `hash_tags` ADD PRIMARY KEY (`id`),
ADD UNIQUE KEY `user_id_4` (`user_id`, `hash_tag`, `hash_tag_message_id`),
ADD KEY `user_id` (`user_id`, `hash_tag`),
ADD KEY `user_id_2` (`user_id`, `peer_type`, `peer_id`, `hash_tag`),
ADD KEY `user_id_3` (`user_id`, `hash_tag_message_id`);

--
-- 表的索引 `imported_contacts`
--
ALTER TABLE `imported_contacts` ADD PRIMARY KEY (`id`),
ADD UNIQUE KEY `user_id` (`user_id`),
ADD UNIQUE KEY `user_id_2` (`user_id`, `imported_user_id`);

--
-- 表的索引 `messages`
--
ALTER TABLE `messages` ADD PRIMARY KEY (`id`),
ADD UNIQUE KEY `user_id_2` (`user_id`, `user_message_box_id`),
ADD KEY `user_id` (`user_id`, `dialog_id1`, `dialog_id2`);

--
-- 表的索引 `phone_books`
--
ALTER TABLE `phone_books` ADD PRIMARY KEY (`id`),
ADD UNIQUE KEY `auth_key_id` (`auth_key_id`, `client_id`);

--
-- 表的索引 `photos`
--
ALTER TABLE `photos` ADD PRIMARY KEY (`id`),
ADD UNIQUE KEY `photo_id` (`photo_id`);

--
-- 表的索引 `photo_sizes`
--
ALTER TABLE `photo_sizes` ADD PRIMARY KEY (`id`),
ADD UNIQUE KEY `photo_size_id` (`photo_size_id`, `size_type`),
ADD KEY `photo_id` (`photo_size_id`),
ADD KEY `volume_id` (`volume_id`, `local_id`);

--
-- 表的索引 `popular_contacts`
--
ALTER TABLE `popular_contacts` ADD PRIMARY KEY (`id`),
ADD UNIQUE KEY `phone` (`phone`);

--
-- 表的索引 `predefined_users`
--
ALTER TABLE `predefined_users` ADD PRIMARY KEY (`id`),
ADD UNIQUE KEY `phone` (`phone`);

--
-- 表的索引 `unregistered_contacts`
--
ALTER TABLE `unregistered_contacts` ADD PRIMARY KEY (`id`),
ADD UNIQUE KEY `phone` (`phone`, `importer_user_id`),
ADD KEY `phone_2` (`phone`, `importer_user_id`, `imported`),
ADD KEY `phone_3` (`phone`);

--
-- 表的索引 `username`
--
ALTER TABLE `username` ADD PRIMARY KEY (`id`),
ADD UNIQUE KEY `username` (`username`);

--
-- 表的索引 `users`
--
ALTER TABLE `users` ADD PRIMARY KEY (`id`),
ADD UNIQUE KEY `phone` (`phone`);

--
-- 表的索引 `user_contacts`
--
ALTER TABLE `user_contacts` ADD PRIMARY KEY (`id`),
ADD UNIQUE KEY `owner_user_id` (`owner_user_id`, `contact_user_id`);

--
-- 表的索引 `user_global_privacy_settings`
--
ALTER TABLE `user_global_privacy_settings` ADD PRIMARY KEY (`id`),
ADD UNIQUE KEY `user_id` (`user_id`);

--
-- 表的索引 `user_notify_settings`
--
ALTER TABLE `user_notify_settings` ADD PRIMARY KEY (`id`),
ADD UNIQUE KEY `user_id` (`user_id`, `peer_type`, `peer_id`);

--
-- 表的索引 `user_peer_blocks`
--
ALTER TABLE `user_peer_blocks` ADD PRIMARY KEY (`id`),
ADD UNIQUE KEY `user_id_2` (`user_id`, `peer_type`, `peer_id`),
ADD KEY `user_id` (`user_id`);

--
-- 表的索引 `user_peer_settings`
--
ALTER TABLE `user_peer_settings` ADD PRIMARY KEY (`id`),
ADD UNIQUE KEY `user_id` (`user_id`, `peer_type`, `peer_id`);

--
-- 表的索引 `user_presences`
--
ALTER TABLE `user_presences` ADD PRIMARY KEY (`id`),
ADD UNIQUE KEY `user_id` (`user_id`);

--
-- 表的索引 `user_privacies`
--
ALTER TABLE `user_privacies` ADD PRIMARY KEY (`id`),
ADD UNIQUE KEY `user_id` (`user_id`, `key_type`);

--
-- 表的索引 `user_profile_photos`
--
ALTER TABLE `user_profile_photos` ADD PRIMARY KEY (`id`),
ADD UNIQUE KEY `user_id` (`user_id`, `photo_id`),
ADD KEY `user_id_2` (`user_id`);

--
-- 表的索引 `user_pts_updates`
--
ALTER TABLE `user_pts_updates` ADD PRIMARY KEY (`id`),
ADD KEY `user_id` (`user_id`, `pts`);

--
-- 表的索引 `user_settings`
--
ALTER TABLE `user_settings` ADD PRIMARY KEY (`id`),
ADD UNIQUE KEY `user_id` (`user_id`, `key2`);

--
-- 表的索引 `video_sizes`
--
ALTER TABLE `video_sizes` ADD PRIMARY KEY (`id`),
ADD UNIQUE KEY `video_size_id` (`video_size_id`, `size_type`),
ADD KEY `volume_id` (`volume_id`, `local_id`),
ADD KEY `video_size_id_2` (`video_size_id`);

--
-- 在导出的表使用AUTO_INCREMENT
--
--
-- 使用表AUTO_INCREMENT `auths`
--
ALTER TABLE `auths` MODIFY `id` bigint (20) NOT NULL AUTO_INCREMENT,
AUTO_INCREMENT = 202910;

--
-- 使用表AUTO_INCREMENT `auth_keys`
--
ALTER TABLE `auth_keys` MODIFY `id` bigint (20) NOT NULL AUTO_INCREMENT,
AUTO_INCREMENT = 213484;

--
-- 使用表AUTO_INCREMENT `auth_seq_updates`
--
ALTER TABLE `auth_seq_updates` MODIFY `id` bigint (20) NOT NULL AUTO_INCREMENT;

--
-- 使用表AUTO_INCREMENT `auth_users`
--
ALTER TABLE `auth_users` MODIFY `id` bigint (20) NOT NULL AUTO_INCREMENT,
AUTO_INCREMENT = 120061;

--
-- 使用表AUTO_INCREMENT `bots`
--
ALTER TABLE `bots` MODIFY `id` bigint (20) NOT NULL AUTO_INCREMENT,
AUTO_INCREMENT = 13;

--
-- 使用表AUTO_INCREMENT `bot_commands`
--
ALTER TABLE `bot_commands` MODIFY `id` bigint (20) NOT NULL AUTO_INCREMENT,
AUTO_INCREMENT = 44;

--
-- 使用表AUTO_INCREMENT `chats`
--
ALTER TABLE `chats` MODIFY `id` bigint (20) NOT NULL AUTO_INCREMENT,
AUTO_INCREMENT = 120031;

--
-- 使用表AUTO_INCREMENT `chat_invites`
--
ALTER TABLE `chat_invites` MODIFY `id` bigint (20) NOT NULL AUTO_INCREMENT,
AUTO_INCREMENT = 35;

--
-- 使用表AUTO_INCREMENT `chat_invite_participants`
--
ALTER TABLE `chat_invite_participants` MODIFY `id` bigint (20) NOT NULL AUTO_INCREMENT,
AUTO_INCREMENT = 3;

--
-- 使用表AUTO_INCREMENT `chat_participants`
--
ALTER TABLE `chat_participants` MODIFY `id` bigint (20) NOT NULL AUTO_INCREMENT,
AUTO_INCREMENT = 120068;

--
-- 使用表AUTO_INCREMENT `devices`
--
ALTER TABLE `devices` MODIFY `id` bigint (20) NOT NULL AUTO_INCREMENT,
AUTO_INCREMENT = 7;

--
-- 使用表AUTO_INCREMENT `dialogs`
--
ALTER TABLE `dialogs` MODIFY `id` bigint (20) NOT NULL AUTO_INCREMENT,
AUTO_INCREMENT = 152283;

--
-- 使用表AUTO_INCREMENT `dialog_filters`
--
ALTER TABLE `dialog_filters` MODIFY `id` bigint (20) NOT NULL AUTO_INCREMENT,
AUTO_INCREMENT = 8;

--
-- 使用表AUTO_INCREMENT `documents`
--
ALTER TABLE `documents` MODIFY `id` bigint (20) NOT NULL AUTO_INCREMENT,
AUTO_INCREMENT = 120762;

--
-- 使用表AUTO_INCREMENT `encrypted_files`
--
ALTER TABLE `encrypted_files` MODIFY `id` bigint (20) NOT NULL AUTO_INCREMENT;

--
-- 使用表AUTO_INCREMENT `hash_tags`
--
ALTER TABLE `hash_tags` MODIFY `id` bigint (20) NOT NULL AUTO_INCREMENT,
AUTO_INCREMENT = 5;

--
-- 使用表AUTO_INCREMENT `imported_contacts`
--
ALTER TABLE `imported_contacts` MODIFY `id` bigint (20) NOT NULL AUTO_INCREMENT,
AUTO_INCREMENT = 4;

--
-- 使用表AUTO_INCREMENT `messages`
--
ALTER TABLE `messages` MODIFY `id` bigint (20) NOT NULL AUTO_INCREMENT,
AUTO_INCREMENT = 155566;

--
-- 使用表AUTO_INCREMENT `phone_books`
--
ALTER TABLE `phone_books` MODIFY `id` bigint (20) NOT NULL AUTO_INCREMENT,
AUTO_INCREMENT = 91195;

--
-- 使用表AUTO_INCREMENT `photos`
--
ALTER TABLE `photos` MODIFY `id` bigint (20) NOT NULL AUTO_INCREMENT,
AUTO_INCREMENT = 90105;

--
-- 使用表AUTO_INCREMENT `photo_sizes`
--
ALTER TABLE `photo_sizes` MODIFY `id` bigint (20) NOT NULL AUTO_INCREMENT,
AUTO_INCREMENT = 121104;

--
-- 使用表AUTO_INCREMENT `popular_contacts`
--
ALTER TABLE `popular_contacts` MODIFY `id` bigint (20) NOT NULL AUTO_INCREMENT;

--
-- 使用表AUTO_INCREMENT `predefined_users`
--
ALTER TABLE `predefined_users` MODIFY `id` bigint (20) NOT NULL AUTO_INCREMENT;

--
-- 使用表AUTO_INCREMENT `unregistered_contacts`
--
ALTER TABLE `unregistered_contacts` MODIFY `id` bigint (20) NOT NULL AUTO_INCREMENT,
AUTO_INCREMENT = 91062;

--
-- 使用表AUTO_INCREMENT `username`
--
ALTER TABLE `username` MODIFY `id` bigint (20) NOT NULL AUTO_INCREMENT,
AUTO_INCREMENT = 90183;

--
-- 使用表AUTO_INCREMENT `users`
--
ALTER TABLE `users` MODIFY `id` bigint (20) NOT NULL AUTO_INCREMENT,
AUTO_INCREMENT = 136907713;

--
-- 使用表AUTO_INCREMENT `user_contacts`
--
ALTER TABLE `user_contacts` MODIFY `id` bigint (20) NOT NULL AUTO_INCREMENT,
AUTO_INCREMENT = 60039;

--
-- 使用表AUTO_INCREMENT `user_global_privacy_settings`
--
ALTER TABLE `user_global_privacy_settings` MODIFY `id` bigint (20) NOT NULL AUTO_INCREMENT,
AUTO_INCREMENT = 90025;

--
-- 使用表AUTO_INCREMENT `user_notify_settings`
--
ALTER TABLE `user_notify_settings` MODIFY `id` bigint (20) NOT NULL AUTO_INCREMENT,
AUTO_INCREMENT = 67;

--
-- 使用表AUTO_INCREMENT `user_peer_blocks`
--
ALTER TABLE `user_peer_blocks` MODIFY `id` bigint (20) NOT NULL AUTO_INCREMENT,
AUTO_INCREMENT = 8;

--
-- 使用表AUTO_INCREMENT `user_peer_settings`
--
ALTER TABLE `user_peer_settings` MODIFY `id` bigint (20) NOT NULL AUTO_INCREMENT,
AUTO_INCREMENT = 90018;

--
-- 使用表AUTO_INCREMENT `user_presences`
--
ALTER TABLE `user_presences` MODIFY `id` bigint (20) NOT NULL AUTO_INCREMENT,
AUTO_INCREMENT = 90075;

--
-- 使用表AUTO_INCREMENT `user_privacies`
--
ALTER TABLE `user_privacies` MODIFY `id` bigint (20) NOT NULL AUTO_INCREMENT,
AUTO_INCREMENT = 90193;

--
-- 使用表AUTO_INCREMENT `user_profile_photos`
--
ALTER TABLE `user_profile_photos` MODIFY `id` bigint (20) NOT NULL AUTO_INCREMENT,
AUTO_INCREMENT = 13;

--
-- 使用表AUTO_INCREMENT `user_pts_updates`
--
ALTER TABLE `user_pts_updates` MODIFY `id` bigint (20) NOT NULL AUTO_INCREMENT,
AUTO_INCREMENT = 156759;

--
-- 使用表AUTO_INCREMENT `user_settings`
--
ALTER TABLE `user_settings` MODIFY `id` bigint (20) NOT NULL AUTO_INCREMENT,
AUTO_INCREMENT = 3;

--
-- 使用表AUTO_INCREMENT `video_sizes`
--
ALTER TABLE `video_sizes` MODIFY `id` bigint (20) NOT NULL AUTO_INCREMENT;
   
ALTER TABLE `chat_participants` ADD `groupcall_default_join_as_peer_type` INT NOT NULL DEFAULT '0' AFTER `left_at`,
ADD `groupcall_default_join_as_peer_id` BIGINT NOT NULL DEFAULT '0' AFTER `groupcall_default_join_as_peer_type`;

ALTER TABLE `dialogs` ADD `theme_emoticon` VARCHAR(64) NOT NULL DEFAULT '' AFTER `has_scheduled`;
 
ALTER TABLE `photo_sizes` ADD `cached_type` INT NOT NULL DEFAULT '0' AFTER `file_path`;

ALTER TABLE `photo_sizes` ADD `cached_bytes` VARCHAR(4096) NOT NULL DEFAULT '' AFTER `cached_type`;

ALTER TABLE `photo_sizes`
DROP INDEX `volume_id`;

ALTER TABLE `photo_sizes`
DROP `volume_id`,
DROP `local_id`,
DROP `secret`,
DROP `has_stripped`,
DROP `stripped_bytes`;

ALTER TABLE `video_sizes`
DROP INDEX `volume_id`;

ALTER TABLE `video_sizes`
DROP `volume_id`,
DROP `local_id`,
DROP `secret`;
 
ALTER TABLE `chats` ADD `available_reactions` VARCHAR(128) NOT NULL DEFAULT '' AFTER `migrated_to_access_hash`;

ALTER TABLE `messages` ADD `reaction` VARCHAR(16) NOT NULL DEFAULT '' AFTER `pinned`,
ADD `reaction_date` BIGINT NOT NULL DEFAULT '0' AFTER `reaction`;
 
ALTER TABLE dialog_filters ADD UNIQUE (user_id, dialog_filter_id);
 
ALTER TABLE `chats` ADD `noforwards` BOOLEAN NOT NULL DEFAULT FALSE AFTER `deactivated`;
 
ALTER TABLE `chat_invite_participants` ADD `chat_id` BIGINT NOT NULL AFTER `id`;
 
ALTER TABLE `messages` ADD `reaction_unread` BOOLEAN NOT NULL DEFAULT FALSE AFTER `reaction_date`;

ALTER TABLE `messages` ADD `has_reaction` BOOLEAN NOT NULL DEFAULT FALSE AFTER `pinned`;
 
ALTER TABLE `pwm`.`documents`
DROP INDEX `document_id`,
ADD UNIQUE `document_id` (`document_id`) USING BTREE;

ALTER TABLE `user_contacts` ADD INDEX (`owner_user_id`);

ALTER TABLE `auth_key_infos` CHANGE `id` `id` BIGINT (20) NOT NULL AUTO_INCREMENT;

ALTER TABLE `encrypted_files` CHANGE `file_size` `file_size` BIGINT NOT NULL;

ALTER TABLE `documents` CHANGE `file_size` `file_size` BIGINT NOT NULL;

ALTER TABLE `users` ADD `premium` BOOLEAN NOT NULL DEFAULT FALSE AFTER `fake`;

ALTER TABLE `dialogs` ADD `ttl_period` INT NOT NULL DEFAULT '0' AFTER `has_scheduled`;

ALTER TABLE `messages` ADD `ttl_period` INT NOT NULL DEFAULT '0' AFTER `date2`;

ALTER TABLE `chats` ADD `ttl_period` INT NOT NULL DEFAULT '0' AFTER `noforwards`;

ALTER TABLE `chats` ADD `available_reactions_type` INT NOT NULL DEFAULT '0' AFTER `migrated_to_access_hash`;

ALTER TABLE `users` ADD `emoji_status_document_id` BIGINT NOT NULL DEFAULT '0' AFTER `archive_and_mute_new_noncontact_peers`,
ADD `emoji_status_until` INT NOT NULL DEFAULT '0' AFTER `emoji_status_document_id`;

ALTER TABLE `auth_users` ADD `state` INT NOT NULL DEFAULT '0' AFTER `region`;
 

ALTER TABLE `chat_participants` ADD `is_bot` BOOLEAN NOT NULL DEFAULT FALSE AFTER `groupcall_default_join_as_peer_id`;

ALTER TABLE `users` ADD `stories_max_id` INT NOT NULL DEFAULT '0' AFTER `emoji_status_until`;

ALTER TABLE `user_contacts` ADD `close_friend` BOOLEAN NOT NULL DEFAULT FALSE AFTER `mutual`;

ALTER TABLE `users` ADD `color` INT NOT NULL DEFAULT '0' AFTER `stories_max_id`,
ADD `color_background_emoji_id` BIGINT NOT NULL DEFAULT '0' AFTER `color`,
ADD `profile_color` INT NOT NULL DEFAULT '0' AFTER `color_background_emoji_id`,
ADD `profile_color_background_emoji_id` BIGINT NOT NULL DEFAULT '0' AFTER `profile_color`;
 
CREATE TABLE
  IF NOT EXISTS `saved_dialogs` (
    `id` bigint NOT NULL AUTO_INCREMENT,
    `user_id` bigint NOT NULL,
    `peer_type` int NOT NULL,
    `peer_id` bigint NOT NULL,
    `pinned` bigint NOT NULL DEFAULT '0',
    `top_message` int NOT NULL,
    `deleted` tinyint (1) NOT NULL DEFAULT '0',
    `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    UNIQUE KEY `user_id` (`user_id`, `peer_type`, `peer_id`),
    KEY `user_id_2` (`user_id`)
  ) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_general_ci;

ALTER TABLE `messages` ADD `saved_peer_type` INT NOT NULL DEFAULT '0' AFTER `ttl_period`,
ADD `saved_peer_id` BIGINT NOT NULL DEFAULT '0' AFTER `saved_peer_type`;

ALTER TABLE `dialog_filters` ADD `is_chatlist` BOOLEAN NOT NULL DEFAULT FALSE AFTER `dialog_filter_id`;

ALTER TABLE `dialog_filters` ADD `has_my_invites` INT NOT NULL DEFAULT '0' AFTER `is_chatlist`;

ALTER TABLE `dialog_filters` ADD `slug` VARCHAR(128) NOT NULL DEFAULT '' AFTER `is_chatlist`;

ALTER TABLE `dialog_filters` ADD `joined_by_slug` BOOLEAN NOT NULL DEFAULT FALSE AFTER `is_chatlist`;

-- user_global_privacy_settings
ALTER TABLE `user_global_privacy_settings` ADD `keep_archived_unmuted` BOOLEAN NOT NULL DEFAULT FALSE AFTER `archive_and_mute_new_noncontact_peers`,
ADD `keep_archived_folders` BOOLEAN NOT NULL DEFAULT FALSE AFTER `keep_archived_unmuted`,
ADD `hide_read_marks` BOOLEAN NOT NULL DEFAULT FALSE AFTER `keep_archived_folders`,
ADD `new_noncontact_peers_require_premium` BOOLEAN NOT NULL DEFAULT FALSE AFTER `hide_read_marks`;

-- users: birthday
ALTER TABLE `users` ADD `birthday` CHAR(10) NOT NULL DEFAULT '' AFTER `profile_color_background_emoji_id`;

ALTER TABLE `user_contacts` ADD `stories_hidden` BOOLEAN NOT NULL DEFAULT FALSE AFTER `close_friend`;

ALTER TABLE `dialogs` ADD `unread_reactions_count` INT NOT NULL DEFAULT '0' AFTER `unread_mentions_count`;

-- Creating the wallpapers table to store predefined wallpapers
CREATE TABLE
  `wallpapers` (
    `id` BIGINT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `slug` VARCHAR(255) NOT NULL,
    `title` VARCHAR(255) NOT NULL,
    `pattern` BOOLEAN NOT NULL DEFAULT FALSE,
    `dark` BOOLEAN NOT NULL DEFAULT FALSE,
    `document_id` BIGINT DEFAULT NULL, -- Foreign key to `documents` table for pattern images
    `access_hash` BIGINT NOT NULL,
    `background_color` INT DEFAULT NULL,
    `second_background_color` INT DEFAULT NULL,
    `third_background_color` INT DEFAULT NULL,
    `fourth_background_color` INT DEFAULT NULL,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT `fk_wallpapers_document_id` FOREIGN KEY (`document_id`) REFERENCES `documents` (`document_id`) ON DELETE SET NULL
  ) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4;

-- Creating the user_wallpapers table to store user-specific wallpaper selections
CREATE TABLE
  `user_wallpapers` (
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
  ) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

-- Creating the wallpaper_settings table
CREATE TABLE
  `wallpaper_settings` (
    `id` BIGINT NOT NULL AUTO_INCREMENT,
    `wallpaper_id` BIGINT NOT NULL,
    `blur` TINYINT (1) DEFAULT 0,
    `motion` TINYINT (1) DEFAULT 0,
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
    CONSTRAINT `fk_wallpaper_settings_wallpaper_id` FOREIGN KEY (`wallpaper_id`) REFERENCES `wallpapers` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
  ) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

-- Creating the themes table
CREATE TABLE
  `themes` (
    `id` BIGINT NOT NULL AUTO_INCREMENT,
    `slug` VARCHAR(255) NOT NULL,
    `title` VARCHAR(255) NOT NULL,
    `creator` TINYINT (1) DEFAULT 0,
    `default` TINYINT (1) DEFAULT 0,
    `for_chat` TINYINT (1) DEFAULT 0,
    `access_hash` BIGINT NOT NULL,
    `document_id` BIGINT DEFAULT NULL,
    `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`)
  ) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

-- Creating the theme_settings table
CREATE TABLE
  `theme_settings` (
    `id` BIGINT NOT NULL AUTO_INCREMENT,
    `theme_id` BIGINT NOT NULL,
    `message_colors_animated` TINYINT (1) DEFAULT 0,
    `base_theme` VARCHAR(255) DEFAULT NULL,
    `accent_color` INT DEFAULT NULL,
    `outbox_accent_color` INT DEFAULT NULL,
    `message_colors` JSON DEFAULT NULL,
    `wallpaper_id` BIGINT DEFAULT NULL,
    `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    CONSTRAINT `fk_theme_settings_theme_id` FOREIGN KEY (`theme_id`) REFERENCES `themes` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT `fk_theme_settings_wallpaper_id` FOREIGN KEY (`wallpaper_id`) REFERENCES `wallpapers` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
  ) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

-- Creating the user_themes table (User's Custom Themes)
CREATE TABLE
  `user_themes` (
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
  ) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;
-- Creating the reactions table with indexes and foreign keys
CREATE TABLE `reactions` (
                             `id` BIGINT NOT NULL AUTO_INCREMENT PRIMARY KEY,    -- Primary key
                             `user_id` BIGINT NOT NULL,                          -- User ID (foreign key to users table)
                             `message_id` BIGINT NOT NULL,                       -- Message ID (foreign key to messages table)
                             `reaction` VARCHAR(255) NOT NULL,                   -- The reaction (e.g., emoji)
                             `peer_id` BIGINT NOT NULL,                          -- The peer ID (chat or user)
                             `peer_type` INT NOT NULL,                           -- The peer type (e.g., user, group, etc.)
                             `read` TINYINT(1) NOT NULL DEFAULT 0,               -- Whether the reaction has been read
                             `reported` TINYINT(1) NOT NULL DEFAULT 0,           -- Whether the reaction has been reported
                             `created_at` BIGINT NOT NULL,                       -- Unix timestamp when the reaction was added
                             `updated_at` BIGINT NOT NULL                        -- Unix timestamp for updates
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Adding indexes for optimization
CREATE INDEX `idx_user_id` ON `reactions` (`user_id`);
CREATE INDEX `idx_message_id` ON `reactions` (`message_id`);
CREATE INDEX `idx_peer_id_peer_type` ON `reactions` (`peer_id`, `peer_type`);
CREATE INDEX `idx_read` ON `reactions` (`read`);

-- Adding foreign key constraints for data integrity
ALTER TABLE `reactions`
    ADD CONSTRAINT `fk_reactions_user_id` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
    ADD CONSTRAINT `fk_reactions_message_id` FOREIGN KEY (`message_id`) REFERENCES `messages` (`id`) ON DELETE CASCADE;




INSERT INTO
  users (
    id,
    user_type,
    access_hash,
    secret_key_id,
    first_name,
    last_name,
    username,
    phone,
    country_code,
    verified,
    support,
    scam,
    fake,
    premium,
    about,
    state,
    is_bot,
    account_days_ttl,
    photo_id,
    restricted,
    restriction_reason,
    archive_and_mute_new_noncontact_peers,
    emoji_status_document_id,
    emoji_status_until,
    deleted,
    delete_reason,
    created_at,
    updated_at
  )
VALUES
  (
    777000,
    4,
    6599886787491911851,
    6895602324158323006,
    'Pwm',
    'Service',
    'pwm',
    '42777',
    '',
    1,
    0,
    0,
    0,
    0,
    '',
    0,
    0,
    180,
    0,
    0,
    '',
    0,
    0,
    0,
    0,
    '',
    '2018-09-25 13:43:11',
    '2021-12-17 12:40:51'
  );
 
 ALTER TABLE `users`
    ADD COLUMN `Email` varchar(128) NULL,
    ADD COLUMN `RegistrationEmail` varchar(128) NULL,
    ADD COLUMN `RegistrationPhone` varchar(20) NULL,
    ADD COLUMN `Gender` int NULL,
    ADD COLUMN `LastAccessDate` datetime NULL,
    ADD COLUMN `Token` varchar(2048) NULL,
    ADD COLUMN `Active` tinyint NULL,
    ADD COLUMN `OnlineStatus` varchar(16) NULL,
    ADD COLUMN `MaxContactCount` int NULL,
    ADD COLUMN `MaxFavoriteCount` int NULL,
    ADD COLUMN `TokenTimestamp` datetime NULL,
    ADD COLUMN `LastLogin` datetime NULL,
    ADD COLUMN `AvatarThumbFileId` varchar(255) NULL,
    ADD COLUMN `IOSPushToken` varchar(255) NULL,
    ADD COLUMN `AndroidPushToken` varchar(255) NULL,
    ADD COLUMN `DefaultMessageToPartner` varchar(512) NULL,
    ADD COLUMN `MaxAllowedPartners` int NULL,
    ADD COLUMN `YearOfBirth` int NULL,
    ADD COLUMN `Area` int NULL,
    ADD COLUMN `PlayWith` int NULL,
    ADD COLUMN `RegisteredByFacebook` tinyint NULL,
    ADD COLUMN `ReferenceAccount` varchar(50) NULL,
    ADD COLUMN `RegistrationId` varchar(100) NULL,
    ADD COLUMN `PartnersFromAge` int NULL,
    ADD COLUMN `PartnersToAge` int NULL,
    ADD COLUMN `PartnersGender` int NULL,
    ADD COLUMN `Passions` LONGTEXT NULL,
    ADD COLUMN `ActiveTimestamp` datetime NULL,
    ADD COLUMN `Platform` varchar(50) NULL,
    ADD COLUMN `LatestAppVersion` varchar(50) NULL,
    ADD COLUMN `LastSuggestedPartners` LONGTEXT NULL,
    ADD COLUMN `LastFetchSuggestionTimestamp` datetime NULL,
    ADD COLUMN `Regions` varchar(256) NULL,
    ADD COLUMN `RegistrationTime` datetime NULL,
    ADD COLUMN `Religion` varchar(256) NULL,
    ADD COLUMN `PartnerReligions` varchar(256) NULL,
    ADD COLUMN `RegistrationType` varchar(50) NULL,
    ADD COLUMN `PartnerRegions` varchar(256) NULL,
    ADD COLUMN `RegistrationValidated` tinyint NULL;

 
/****** Object:  Table `pwm`.`net_Areas`    Script Date: 10/21/2024 8:17:05 PM ******/


CREATE TABLE `pwm`.`net_Areas`(
	`Id` int AUTO_INCREMENT NOT NULL,
	`Area` varchar(200) NULL,
	`Latitude` decimal(9, 6) NULL,
	`Longitude` decimal(9, 6) NULL,
 CONSTRAINT `PK_Areas` PRIMARY KEY 
(
	`Id` ASC
)
)
;
/****** Object:  Table `pwm`.`net_Brands`    Script Date: 10/21/2024 8:17:05 PM ******/


CREATE TABLE `pwm`.`net_Brands`(
	`Id` int AUTO_INCREMENT NOT NULL,
	`BrandName` varchar(200) NULL,
 CONSTRAINT `PK_Brands` PRIMARY KEY 
(
	`Id` ASC
)
)
;
/****** Object:  Table `pwm`.`net_BroadcastMessage`    Script Date: 10/21/2024 8:17:05 PM ******/


CREATE TABLE `pwm`.`net_BroadcastMessage`(
	`BroadcastMessageId` int AUTO_INCREMENT NOT NULL,
	`CreationTime` datetime NOT NULL,
	`ModificationTime` datetime NULL,
	`StartTime` datetime NOT NULL,
	`ExpirationTime` datetime NOT NULL,
	`HtmlContent` LONGTEXT NOT NULL,
	`Title` varchar(256) NULL,
 CONSTRAINT `PK_BroadcastMessage` PRIMARY KEY 
(
	`BroadcastMessageId` ASC
)
)
;
/****** Object:  Table `pwm`.`net_BroadcastMessageUser`    Script Date: 10/21/2024 8:17:05 PM ******/


CREATE TABLE `pwm`.`net_BroadcastMessageUser`(
	`Id` int AUTO_INCREMENT NOT NULL,
	`BroadcastMessageId` int NULL,
	`UserId` bigint(20) NULL,
	`UserReceived` datetime NULL,
	`UserConfirmedTimestamp` datetime NULL,
	`Status` varchar(2048) NULL,
 CONSTRAINT `PK_BroadcastMessageUser` PRIMARY KEY 
(
	`Id` ASC
)
)
;
/****** Object:  Table `pwm`.`net_Chain`    Script Date: 10/21/2024 8:17:05 PM ******/


CREATE TABLE `pwm`.`net_Chain`(
	`Id` int AUTO_INCREMENT NOT NULL,
	`ChainId` varchar(50) NOT NULL,
	`SeqNum` int NULL,
	`TaskId` varchar(50) NOT NULL,
 CONSTRAINT `PK_Chain` PRIMARY KEY 
(
	`Id` ASC
)
)
;
/****** Object:  Table `pwm`.`net_CompletedChain`    Script Date: 10/21/2024 8:17:05 PM ******/


CREATE TABLE `pwm`.`net_CompletedChain`(
	`CompletedChainId` int AUTO_INCREMENT NOT NULL,
	`ChainId` varchar(50) NOT NULL,
	`TaskId` varchar(50) NOT NULL,
	`CompletedTaskId` int NOT NULL,
 CONSTRAINT `PK_CompletedChain` PRIMARY KEY 
(
	`CompletedChainId` ASC
)
)
;
/****** Object:  Table `pwm`.`net_CompletedTask`    Script Date: 10/21/2024 8:17:05 PM ******/


CREATE TABLE `pwm`.`net_CompletedTask`(
	`CompletedTaskId` int AUTO_INCREMENT NOT NULL,
	`PairGameId` int NOT NULL,
	`PlayerId` bigint(20) NULL,
	`Timestamp` datetime NULL,
	`GameConfigId` int NULL,
	`ChainTaskId` varchar(50) NULL,
	`TaskId` varchar(50) NOT NULL,
 CONSTRAINT `PK_CompletedTask` PRIMARY KEY 
(
	`CompletedTaskId` ASC
)
)
;
/****** Object:  Table `pwm`.`net_ConfigurableText`    Script Date: 10/21/2024 8:17:05 PM ******/


CREATE TABLE `pwm`.`net_ConfigurableText`(
	`Id` int AUTO_INCREMENT NOT NULL,
	`Name` varchar(50) NULL,
 CONSTRAINT `PK_ConfigurableText` PRIMARY KEY 
(
	`Id` ASC
)
)
;
/****** Object:  Table `pwm`.`net_Country`    Script Date: 10/21/2024 8:17:05 PM ******/


CREATE TABLE `pwm`.`net_Country`(
	`Id` int AUTO_INCREMENT NOT NULL,
	`Name` varchar(50) NULL,
	`ShortName` varchar(20) NULL,
	`Description` varchar(1024) NULL,
 CONSTRAINT `PK_Countries` PRIMARY KEY 
(
	`Id` ASC
)
)
;
/****** Object:  Table `pwm`.`net_Emoticon`    Script Date: 10/21/2024 8:17:05 PM ******/


CREATE TABLE `pwm`.`net_Emoticon`(
	`Id` int AUTO_INCREMENT NOT NULL,
	`Identifier` varchar(255) NOT NULL,
	`FileId` varchar(255) NOT NULL,
	`Created` datetime NOT NULL,
	`Modified` datetime NOT NULL,
 CONSTRAINT `PK_Emoticon` PRIMARY KEY 
(
	`Id` ASC
)
)
;
/****** Object:  Table `pwm`.`net_FillText`    Script Date: 10/21/2024 8:17:05 PM ******/


CREATE TABLE `pwm`.`net_FillText`(
	`Id` int AUTO_INCREMENT NOT NULL,
	`TaskId` varchar(50) NOT NULL,
	`LanguageId` int NOT NULL,
	`TextForM` varchar(2048) NULL,
	`TextForF` varchar(2048) NULL,
 CONSTRAINT `PK_FillText` PRIMARY KEY 
(
	`Id` ASC
)
)
;
/****** Object:  Table `pwm`.`net_Game`    Script Date: 10/21/2024 8:17:05 PM ******/


CREATE TABLE `pwm`.`net_Game`(
	`GameId` int AUTO_INCREMENT NOT NULL,
	`Type` int NULL,
	`Level` int NULL,
	`Title` varchar(512) NULL,
	`TimeLimit` int NULL,
	`Comments` varchar(1024) NULL,
	`MaxStepsAlone` int NULL,
 CONSTRAINT `PK_Game` PRIMARY KEY 
(
	`GameId` ASC
)
)
;
/****** Object:  Table `pwm`.`net_GameConfig`    Script Date: 10/21/2024 8:17:05 PM ******/


CREATE TABLE `pwm`.`net_GameConfig`(
	`Id` int AUTO_INCREMENT NOT NULL,
	`GameId` int NOT NULL,
	`TaskForM` varchar(50) NULL,
	`TaskForF` varchar(50) NULL,
	`Seq` int NULL,
 CONSTRAINT `PK_GameConfig` PRIMARY KEY 
(
	`Id` ASC
)
)
;
/****** Object:  Table `pwm`.`net_GameType`    Script Date: 10/21/2024 8:17:05 PM ******/


CREATE TABLE `pwm`.`net_GameType`(
	`Id` int AUTO_INCREMENT NOT NULL,
	`Description` varchar(1024) NULL,
 CONSTRAINT `PK_GameType` PRIMARY KEY 
(
	`Id` ASC
)
)
;
/****** Object:  Table `pwm`.`net_Gender`    Script Date: 10/21/2024 8:17:05 PM ******/


CREATE TABLE `pwm`.`net_Gender`(
	`Id` int NOT NULL,
	`Name` varchar(50) NULL,
 CONSTRAINT `PK_Genders` PRIMARY KEY 
(
	`Id` ASC
)
)
;
/****** Object:  Table `pwm`.`net_GeneratorParameters`    Script Date: 10/21/2024 8:17:05 PM ******/


CREATE TABLE `pwm`.`net_GeneratorParameters`(
	`Id` int AUTO_INCREMENT NOT NULL,
	`Name` varchar(250) NULL,
	`Factor` double NULL,
	`BaseValue` int NULL,
 CONSTRAINT `PK_GeneratorParameters` PRIMARY KEY 
(
	`Id` ASC
)
)
;
/****** Object:  Table `pwm`.`net_GeographicalArea`    Script Date: 10/21/2024 8:17:05 PM ******/


CREATE TABLE `pwm`.`net_GeographicalArea`(
	`Id` int AUTO_INCREMENT NOT NULL,
	`TitleEn` varchar(100) NULL,
	`TitleHeb` varchar(100) NULL,
	`MatchKey` varchar(100) NULL,
 CONSTRAINT `PK_GeographicalArea` PRIMARY KEY 
(
	`Id` ASC
)
)
;
/****** Object:  Table `pwm`.`net_Group`    Script Date: 10/21/2024 8:17:05 PM ******/


CREATE TABLE `pwm`.`net_Group`(
	`Id` int AUTO_INCREMENT NOT NULL,
	`UserId` bigint(20) NOT NULL,
	`Name` varchar(255) NOT NULL,
	`Description` text NULL,
	`GroupPassword` varchar(255) NOT NULL,
	`Cate;ryId` int NOT NULL,
	`AvatarFileId` varchar(255) NOT NULL,
	`AvatarThumFileId` varchar(255) NOT NULL,
	`Created` datetime NOT NULL,
	`Modified` datetime NOT NULL,
 CONSTRAINT `PK_Group` PRIMARY KEY 
(
	`Id` ASC
)
)
;
/****** Object:  Table `pwm`.`net_GroupCate;ry`    Script Date: 10/21/2024 8:17:05 PM ******/


CREATE TABLE `pwm`.`net_GroupCate;ry`(
	`Id` int AUTO_INCREMENT NOT NULL,
	`Title` varchar(255) NOT NULL,
	`AvatarFileId` varchar(255) NOT NULL,
	`Created` datetime NOT NULL,
	`Modified` datetime NOT NULL,
 CONSTRAINT `PK_GroupCate;ry` PRIMARY KEY 
(
	`Id` ASC
)
)
;
/****** Object:  Table `pwm`.`net_GroupWatchLog`    Script Date: 10/21/2024 8:17:05 PM ******/


CREATE TABLE `pwm`.`net_GroupWatchLog`(
	`Id` int AUTO_INCREMENT NOT NULL,
	`UserId` bigint(20) NOT NULL,
	`GroupId` int NOT NULL,
	`Created` datetime NOT NULL,
 CONSTRAINT `PK_GroupWatchLog` PRIMARY KEY 
(
	`Id` ASC
)
)
;
/****** Object:  Table `pwm`.`net_HistoryChain`    Script Date: 10/21/2024 8:17:05 PM ******/


CREATE TABLE `pwm`.`net_HistoryChain`(
	`Id` int AUTO_INCREMENT NOT NULL,
	`ChainId` varchar(50) NOT NULL,
	`SeqNum` int NULL,
	`TaskId` varchar(50) NOT NULL,
 CONSTRAINT `PK_HistoryChain` PRIMARY KEY 
(
	`Id` ASC
)
)
;
/****** Object:  Table `pwm`.`net_HistoryCompletedChain`    Script Date: 10/21/2024 8:17:05 PM ******/


CREATE TABLE `pwm`.`net_HistoryCompletedChain`(
	`CompletedChainId` int AUTO_INCREMENT NOT NULL,
	`ChainId` varchar(50) NOT NULL,
	`TaskId` varchar(50) NOT NULL,
	`CompletedTaskId` int NOT NULL,
 CONSTRAINT `PK_HistoryCompletedChain` PRIMARY KEY 
(
	`CompletedChainId` ASC
)
)
;
/****** Object:  Table `pwm`.`net_HistoryCompletedTask`    Script Date: 10/21/2024 8:17:05 PM ******/


CREATE TABLE `pwm`.`net_HistoryCompletedTask`(
	`CompletedTaskId` int AUTO_INCREMENT NOT NULL,
	`PairGameId` int NOT NULL,
	`PlayerId` bigint(20) NULL,
	`Timestamp` datetime NULL,
	`GameConfigId` int NULL,
	`ChainTaskId` varchar(50) NULL,
 CONSTRAINT `PK_HistoryCompletedTask` PRIMARY KEY 
(
	`CompletedTaskId` ASC
)
)
;
/****** Object:  Table `pwm`.`net_HistoryGame`    Script Date: 10/21/2024 8:17:05 PM ******/


CREATE TABLE `pwm`.`net_HistoryGame`(
	`GameId` int AUTO_INCREMENT NOT NULL,
	`Type` int NULL,
	`Level` int NULL,
	`Title` varchar(512) NULL,
	`TimeLimit` int NULL,
	`Comments` varchar(1024) NULL,
	`MaxStepsAlone` int NULL,
 CONSTRAINT `PK_HistoryGame` PRIMARY KEY 
(
	`GameId` ASC
)
)
;
/****** Object:  Table `pwm`.`net_HistoryGameConfig`    Script Date: 10/21/2024 8:17:05 PM ******/


CREATE TABLE `pwm`.`net_HistoryGameConfig`(
	`Id` int AUTO_INCREMENT NOT NULL,
	`GameId` int NOT NULL,
	`TaskForM` varchar(50) NULL,
	`TaskForF` varchar(50) NULL,
	`Seq` int NULL,
 CONSTRAINT `PK_HistoryGameConfig` PRIMARY KEY 
(
	`Id` ASC
)
)
;
/****** Object:  Table `pwm`.`net_HistoryMessage`    Script Date: 10/21/2024 8:17:05 PM ******/


CREATE TABLE `pwm`.`net_HistoryMessage`(
	`Id` int AUTO_INCREMENT NOT NULL,
	`FromUserId` int NOT NULL,
	`ToUserId` int NOT NULL,
	`ToGroupId` int NULL,
	`ToGroupName` varchar(255) NULL,
	`Body` LONGTEXT NULL,
	`MessageTargetType` varchar(10) NOT NULL,
	`MessageType` varchar(10) NOT NULL,
	`EmoticonImageUrl` varchar(255) NULL,
	`PictureFileId` varchar(255) NULL,
	`PictureThumbFileId` varchar(255) NULL,
	`VoiceFileId` varchar(255) NULL,
	`VideoFileId` varchar(255) NULL,
	`Longitude` double NULL,
	`Latitude` double NULL,
	`Valid` int NULL,
	`FromUsername` varchar(255) NULL,
	`ToUsername` varchar(255) NULL,
	`Created` datetime NOT NULL,
	`ReadAt` datetime NULL,
	`ReportCount` int NULL,
	`PairId` int NOT NULL,
	`Type` int NULL,
	`PairGameId` int NULL,
	`SessionId` int NULL,
	`GameConfigId` int NULL,
	`MessengerId` int NULL,
 CONSTRAINT `PK_HistoryMessage` PRIMARY KEY 
(
	`Id` ASC
)
)
;
/****** Object:  Table `pwm`.`net_HistoryPairGame`    Script Date: 10/21/2024 8:17:05 PM ******/


CREATE TABLE `pwm`.`net_HistoryPairGame`(
	`PairGameId` int AUTO_INCREMENT NOT NULL,
	`PlayerPairId` int NULL,
	`GameId` int NULL,
	`Timestamp` datetime NULL,
	`IsActive` tinyint NULL,
	`Description` varchar(50) NULL,
	`Player1StepsAlone` int NULL,
	`Player2StepsAlone` int NULL,
	`Seq` int NULL,
	`IsFinished` tinyint NULL,
 CONSTRAINT `PK_HistoryPairGame` PRIMARY KEY 
(
	`PairGameId` ASC
)
)
;
/****** Object:  Table `pwm`.`net_HistoryPlayerPair`    Script Date: 10/21/2024 8:17:05 PM ******/


CREATE TABLE `pwm`.`net_HistoryPlayerPair`(
	`PlayerPairId` int NOT NULL,
	`Player1` bigint(20) NOT NULL,
	`Player2` bigint(20) NOT NULL,
	`Description` varchar(1024) NULL,
	`Timestamp` datetime NULL,
	`IsActive` tinyint NULL,
 CONSTRAINT `PK_HistoryPlayerPair` PRIMARY KEY 
(
	`PlayerPairId` ASC
)
)
;
/****** Object:  Table `pwm`.`net_HistoryTaskAnswer`    Script Date: 10/21/2024 8:17:05 PM ******/


CREATE TABLE `pwm`.`net_HistoryTaskAnswer`(
	`Id` int AUTO_INCREMENT NOT NULL,
	`OrderNumber` int NULL,
	`CompletedTaskId` int NOT NULL,
	`AttachedText` varchar(1024) NULL,
	`AnswerText` varchar(1024) NULL,
	`MediaPath` varchar(1024) NULL,
	`Timestamp` datetime NULL,
 CONSTRAINT `PK_HistoryTaskAnswer` PRIMARY KEY 
(
	`Id` ASC
)
)
;
/****** Object:  Table `pwm`.`net_Image`    Script Date: 10/21/2024 8:17:05 PM ******/


CREATE TABLE `pwm`.`net_Image`(
	`Id` int AUTO_INCREMENT NOT NULL,
	`Caption` varchar(128) NULL,
	`Description` varchar(512) NULL,
	`ImageUrl` varchar(512) NULL,
 CONSTRAINT `PK_Images` PRIMARY KEY 
(
	`Id` ASC
)
)
;
/****** Object:  Table `pwm`.`net_Keywords`    Script Date: 10/21/2024 8:17:05 PM ******/


CREATE TABLE `pwm`.`net_Keywords`(
	`Id` int AUTO_INCREMENT NOT NULL,
	`Keyword` varchar(50) NULL,
 CONSTRAINT `PK_Keywords` PRIMARY KEY 
(
	`Id` ASC
)
)
;
/****** Object:  Table `pwm`.`net_Language`    Script Date: 10/21/2024 8:17:05 PM ******/


CREATE TABLE `pwm`.`net_Language`(
	`Id` int AUTO_INCREMENT NOT NULL,
	`Description` varchar(1024) NULL,
 CONSTRAINT `PK_Languages` PRIMARY KEY 
(
	`Id` ASC
)
)
;
/****** Object:  Table `pwm`.`net_Log`    Script Date: 10/21/2024 8:17:05 PM ******/


CREATE TABLE `pwm`.`net_Log`(
	`Id` int AUTO_INCREMENT NOT NULL,
	`LogLevelId` int NOT NULL,
	`ShortMessage` LONGTEXT NOT NULL,
	`FullMessage` LONGTEXT NULL,
	`IpAddress` varchar(200) NULL,
	`CustomerId` int NULL,
	`PageUrl` LONGTEXT NULL,
	`ReferrerUrl` LONGTEXT NULL,
	`CreatedOnUtc` datetime NOT NULL,
	`Type` int NULL,
	`ServerIP` varchar(200) NULL,
	`ServerName` varchar(500) NULL,
PRIMARY KEY 
(
	`Id` ASC
)
)
;
/****** Object:  Table `pwm`.`net_LoginSession`    Script Date: 10/21/2024 8:17:05 PM ******/


CREATE TABLE `pwm`.`net_LoginSession`(
	`Id` int AUTO_INCREMENT NOT NULL,
	`UserId` bigint(20) NOT NULL,
	`Token` varchar(100) NOT NULL,
	`CreateOn` datetime NOT NULL,
	`UpdateOn` datetime NULL,
	`ExpireOn` datetime NULL,
	`IsActive` tinyint NOT NULL,
	`DeviceToken` varchar(250) NULL,
	`DeviceType` int NULL,
 CONSTRAINT `PK_LoginSession` PRIMARY KEY 
(
	`Id` ASC
)
)
;
/****** Object:  Table `pwm`.`net_MediaComment`    Script Date: 10/21/2024 8:17:05 PM ******/


CREATE TABLE `pwm`.`net_MediaComment`(
	`Id` int AUTO_INCREMENT NOT NULL,
	`MessageId` int NOT NULL,
	`UserId` bigint(20) NOT NULL,
	`Username` varchar(255) NOT NULL,
	`Comment` text NULL,
	`Created` datetime NULL,
 CONSTRAINT `PK_MediaComment` PRIMARY KEY 
(
	`Id` ASC
)
)
;
/****** Object:  Table `pwm`.`net_Message`    Script Date: 10/21/2024 8:17:05 PM ******/


CREATE TABLE `pwm`.`net_Message`(
	`Id` int AUTO_INCREMENT NOT NULL,
	`FromUserId` int NOT NULL,
	`ToUserId` int NOT NULL,
	`ToGroupId` int NULL,
	`ToGroupName` varchar(255) NULL,
	`Body` LONGTEXT NULL,
	`MessageTargetType` varchar(10) NOT NULL,
	`MessageType` varchar(10) NOT NULL,
	`EmoticonImageUrl` varchar(255) NULL,
	`PictureFileId` varchar(255) NULL,
	`PictureThumbFileId` varchar(255) NULL,
	`VoiceFileId` varchar(255) NULL,
	`VideoFileId` varchar(255) NULL,
	`Longitude` double NULL,
	`Latitude` double NULL,
	`Valid` int NULL,
	`FromUsername` varchar(255) NULL,
	`ToUsername` varchar(255) NULL,
	`Created` datetime NOT NULL,
	`ReadAt` datetime NULL,
	`ReportCount` int NULL,
	`PairId` int NOT NULL,
	`Type` int NULL,
	`PairGameId` int NULL,
	`GameConfigId` int NULL,
	`ChainId` varchar(50) NULL,
	`ReceivedAt` datetime NULL,
 CONSTRAINT `PK_Message` PRIMARY KEY 
(
	`Id` ASC
)
)
;
/****** Object:  Table `pwm`.`net_NewGameRules`    Script Date: 10/21/2024 8:17:05 PM ******/


CREATE TABLE `pwm`.`net_NewGameRules`(
	`Id` int AUTO_INCREMENT NOT NULL,
	`Brand` int NULL,
	`PairsGameNumber` int NULL,
	`PlayerMaxGameNumber` int NULL,
	`TaskNumberInGame` int NULL,
	`TaskWasNotUse` varchar(50) NULL,
	`UniqueType` varchar(50) NULL,
	`UniqueSubType` varchar(50) NULL,
	`TaskType` varchar(50) NULL,
	`MinScore` int NULL,
	`MaxScore` int NULL,
 CONSTRAINT `PK_NewGameRules` PRIMARY KEY 
(
	`Id` ASC
)
)
;
/****** Object:  Table `pwm`.`net_News`    Script Date: 10/21/2024 8:17:05 PM ******/


CREATE TABLE `pwm`.`net_News`(
	`Id` int AUTO_INCREMENT NOT NULL,
	`UserId` bigint(20) NOT NULL,
	`Title` varchar(255) NOT NULL,
	`Content` text NOT NULL,
	`StoryUrl` text NOT NULL,
	`Created` datetime NOT NULL,
	`Modified` datetime NOT NULL,
 CONSTRAINT `PK_News` PRIMARY KEY 
(
	`Id` ASC
)
)
;
/****** Object:  Table `pwm`.`net_NewsComment`    Script Date: 10/21/2024 8:17:05 PM ******/


CREATE TABLE `pwm`.`net_NewsComment`(
	`Id` int AUTO_INCREMENT NOT NULL,
	`StoryId` int NOT NULL,
	`UserId` bigint(20) NOT NULL,
	`Username` varchar(255) NOT NULL,
	`Comment` text NULL,
	`Created` datetime NULL,
 CONSTRAINT `PK_NewsComment` PRIMARY KEY 
(
	`Id` ASC
)
)
;
/****** Object:  Table `pwm`.`net_Notification`    Script Date: 10/21/2024 8:17:05 PM ******/


CREATE TABLE `pwm`.`net_Notification`(
	`Id` int AUTO_INCREMENT NOT NULL,
	`UserId` bigint(20) NOT NULL,
	`FromUserId` int NOT NULL,
	`ToGroupId` int NOT NULL,
	`TargetType` varchar(16) NOT NULL,
	`Message` varchar(255) NOT NULL,
	`UserImageUrl` varchar(255) NULL,
	`Count` int NOT NULL,
	`Created` datetime NOT NULL,
	`Modified` datetime NOT NULL,
 CONSTRAINT `PK_Notification` PRIMARY KEY 
(
	`Id` ASC
)
)
;
/****** Object:  Table `pwm`.`net_OffensiveReport`    Script Date: 10/21/2024 8:17:05 PM ******/


CREATE TABLE `pwm`.`net_OffensiveReport`(
	`Id` int AUTO_INCREMENT NOT NULL,
	`PlayerId` bigint(20) NULL,
	`OffensivePlayerId` bigint(20) NULL,
 CONSTRAINT `PK_OffensiveReport` PRIMARY KEY 
(
	`Id` ASC
)
)
;
/****** Object:  Table `pwm`.`net_PairGame`    Script Date: 10/21/2024 8:17:05 PM ******/


CREATE TABLE `pwm`.`net_PairGame`(
	`PairGameId` int AUTO_INCREMENT NOT NULL,
	`PlayerPairId` int NULL,
	`GameId` int NULL,
	`Timestamp` datetime NULL,
	`IsActive` tinyint NULL,
	`Description` varchar(50) NULL,
	`Player1StepsAlone` int NULL,
	`Player2StepsAlone` int NULL,
	`Seq` int NULL,
	`IsFinished` tinyint NULL,
	`SessionId` int NULL,
 CONSTRAINT `PK_PairGame` PRIMARY KEY 
(
	`PairGameId` ASC
)
)
;
/****** Object:  Table `pwm`.`net_PairStatus`    Script Date: 10/21/2024 8:17:05 PM ******/


CREATE TABLE `pwm`.`net_PairStatus`(
	`Id` int NOT NULL,
	`Name` varchar(50) NULL,
 CONSTRAINT `PK_PairStatus` PRIMARY KEY 
(
	`Id` ASC
)
)
;
/****** Object:  Table `pwm`.`net_Passion`    Script Date: 10/21/2024 8:17:05 PM ******/


CREATE TABLE `pwm`.`net_Passion`(
	`PassionId` int AUTO_INCREMENT NOT NULL,
	`TitleEn` varchar(100) NULL,
	`TitleHeb` varchar(100) NULL,
 CONSTRAINT `PK_Passion` PRIMARY KEY 
(
	`PassionId` ASC
)
)
;
/****** Object:  Table `pwm`.`net_PasswordChangeRequest`    Script Date: 10/21/2024 8:17:05 PM ******/


CREATE TABLE `pwm`.`net_PasswordChangeRequest`(
	`Id` int AUTO_INCREMENT NOT NULL,
	`UserId` bigint(20) NOT NULL,
	`Token` varchar(255) NOT NULL,
	`Valid` tinyint NOT NULL,
	`Created` datetime NOT NULL,
 CONSTRAINT `PK_PasswordChangeRequest` PRIMARY KEY 
(
	`Id` ASC
)
)
;
/****** Object:  Table `pwm`.`net_PlayerPair`    Script Date: 10/21/2024 8:17:05 PM ******/


CREATE TABLE `pwm`.`net_PlayerPair`(
	`PlayerPairId` int AUTO_INCREMENT NOT NULL,
	`Player1` bigint(20) NOT NULL,
	`Player2` bigint(20) NOT NULL,
	`Description` varchar(1024) NULL,
	`Timestamp` datetime NULL,
	`IsActive` tinyint NULL,
	`Status` int NULL,
	`RemovedByPlayer1` tinyint NULL,
	`RemovedByPlayer2` tinyint NULL,
	`ContinueByPlayer1` tinyint NULL,
	`ContinueByPlayer2` tinyint NULL,
	`PairingTime` datetime NULL,
 CONSTRAINT `PK_PlayerPair` PRIMARY KEY 
(
	`PlayerPairId` ASC
)
)
;
/****** Object:  Table `pwm`.`net_Q234`    Script Date: 10/21/2024 8:17:05 PM ******/


CREATE TABLE `pwm`.`net_Q234`(
	`Id` int AUTO_INCREMENT NOT NULL,
	`TaskId` varchar(50) NOT NULL,
	`LanguageId` int NOT NULL,
	`A1Text` varchar(1024) NULL,
	`A1Image` int NULL,
	`A2Text` varchar(1024) NULL,
	`A2Image` int NULL,
	`A3Text` varchar(1024) NULL,
	`A3Image` int NULL,
	`A4Text` varchar(1024) NULL,
	`A4Image` int NULL,
 CONSTRAINT `PK_Q234` PRIMARY KEY 
(
	`Id` ASC
)
)
;
/****** Object:  Table `pwm`.`net_ResourceString`    Script Date: 10/21/2024 8:17:05 PM ******/


CREATE TABLE `pwm`.`net_ResourceString`(
	`Id` int NOT NULL,
	`ResourceKey` varchar(50) NULL,
	`En` LONGTEXT NULL,
	`He` LONGTEXT NULL,
 CONSTRAINT `PK_ResourceString` PRIMARY KEY 
(
	`Id` ASC
)
)
;
/****** Object:  Table `pwm`.`net_Role`    Script Date: 10/21/2024 8:17:05 PM ******/


CREATE TABLE `pwm`.`net_Role`(
	`Id` int NOT NULL,
	`Name` varchar(50) NULL,
	`Description` varchar(512) NULL,
 CONSTRAINT `PK_Roles` PRIMARY KEY 
(
	`Id` ASC
)
)
;
/****** Object:  Table `pwm`.`net_SexualOrientation`    Script Date: 10/21/2024 8:17:05 PM ******/


CREATE TABLE `pwm`.`net_SexualOrientation`(
	`SexualOrientationId` int NOT NULL,
	`TitleEn` varchar(100) NULL,
	`TitleHeb` varchar(100) NULL,
 CONSTRAINT `PK_SexualOrientation` PRIMARY KEY 
(
	`SexualOrientationId` ASC
)
)
;
/****** Object:  Table `pwm`.`net_SysParam`    Script Date: 10/21/2024 8:17:05 PM ******/


CREATE TABLE `pwm`.`net_SysParam`(
	`Id` int AUTO_INCREMENT NOT NULL,
	`MaxOfPartners` int NULL,
	`AdminEmail` varchar(50) NULL,
	`DisableEditingAvatar` tinyint NULL,
	`RequirePhoneVerfication` tinyint NULL,
	`AndroidInviteMessage` LONGTEXT NULL,
	`iOSInviteMessage` LONGTEXT NULL,
	`StaticPartnerDuration` int NULL,
	`StaticPartnerUnit` varchar(10) NULL,
	`PartnerMatchingAgeUp` int NULL,
	`PartnerMatchingAgeDowm` int NULL,
	`LatestAppVersion` varchar(50) NULL,
	`AgeRangeUpperLimit` int NULL,
	`AgeRangeLowerLimit` int NULL,
	`PlayButtonIdleTime` int NULL,
	`HobbiesListVisible` tinyint NULL,
	`PlayNowMode` int NULL,
	`PlayNowMessageKey` varchar(100) NULL,
	`DefaultRegisterUserState` int NULL,
 CONSTRAINT `PK_SysParam` PRIMARY KEY 
(
	`Id` ASC
)
)
;
/****** Object:  Table `pwm`.`net_TaskAnswer`    Script Date: 10/21/2024 8:17:05 PM ******/


CREATE TABLE `pwm`.`net_TaskAnswer`(
	`Id` int AUTO_INCREMENT NOT NULL,
	`OrderNumber` int NULL,
	`CompletedTaskId` int NOT NULL,
	`AttachedText` varchar(1024) NULL,
	`AnswerText` varchar(1024) NULL,
	`MediaPath` varchar(1024) NULL,
	`Timestamp` datetime NULL,
	`Score` int NULL,
	`Offensive` varchar(1024) NULL,
 CONSTRAINT `PK_TaskAnswer` PRIMARY KEY 
(
	`Id` ASC
)
)
;
/****** Object:  Table `pwm`.`net_TaskAnswerFeedback`    Script Date: 10/21/2024 8:17:05 PM ******/


CREATE TABLE `pwm`.`net_TaskAnswerFeedback`(
	`Id` int AUTO_INCREMENT NOT NULL,
	`Seq` int NULL,
	`CompletedTaskId` int NOT NULL,
	`PlayerId` bigint(20) NOT NULL,
	`Comment` varchar(1024) NULL,
	`Timestamp` datetime NULL,
	`LikeTypeId` int NULL,
 CONSTRAINT `PK_TaskAnswerComment` PRIMARY KEY 
(
	`Id` ASC
)
)
;
/****** Object:  Table `pwm`.`net_TaskAuthor`    Script Date: 10/21/2024 8:17:05 PM ******/


CREATE TABLE `pwm`.`net_TaskAuthor`(
	`Id` int AUTO_INCREMENT NOT NULL,
	`AuthorName` varchar(128) NULL,
 CONSTRAINT `PK_TaskAuthor` PRIMARY KEY 
(
	`Id` ASC
)
)
;
/****** Object:  Table `pwm`.`net_TaskKeyword`    Script Date: 10/21/2024 8:17:05 PM ******/


CREATE TABLE `pwm`.`net_TaskKeyword`(
	`Id` int AUTO_INCREMENT NOT NULL,
	`TaskId` varchar(50) NULL,
	`KeywordId` int NULL,
 CONSTRAINT `PK_TaskKeyword` PRIMARY KEY 
(
	`Id` ASC
)
)
;
/****** Object:  Table `pwm`.`net_TaskLike`    Script Date: 10/21/2024 8:17:05 PM ******/


CREATE TABLE `pwm`.`net_TaskLike`(
	`Id` int AUTO_INCREMENT NOT NULL,
	`Name` varchar(50) NULL,
	`ImagePath` varchar(512) NULL,
	`IsActive` tinyint NULL,
 CONSTRAINT `PK_TaskLikes` PRIMARY KEY 
(
	`Id` ASC
)
)
;
/****** Object:  Table `pwm`.`net_TaskMaxStep`    Script Date: 10/21/2024 8:17:05 PM ******/


CREATE TABLE `pwm`.`net_TaskMaxStep`(
	`Id` int AUTO_INCREMENT NOT NULL,
	`TaskId` varchar(50) NOT NULL,
	`PlayerPairId` int NOT NULL,
	`PlayerId` bigint(20) NOT NULL,
	`MaxAloneSteps` int NOT NULL,
 CONSTRAINT `PK_TaskMaxStep` PRIMARY KEY 
(
	`Id` ASC
)
)
;
/****** Object:  Table `pwm`.`net_TaskNotification`    Script Date: 10/21/2024 8:17:05 PM ******/


CREATE TABLE `pwm`.`net_TaskNotification`(
	`Id` int AUTO_INCREMENT NOT NULL,
	`CompletedTaskId` int NOT NULL,
	`PlayerFromId` bigint(20) NOT NULL,
	`PlayerToId` bigint(20) NOT NULL,
	`Timestamp` datetime NULL,
 CONSTRAINT `PK_TaskNotification` PRIMARY KEY 
(
	`Id` ASC
)
)
;
/****** Object:  Table `pwm`.`net_Tasks`    Script Date: 10/21/2024 8:17:05 PM ******/

CREATE TABLE `pwm`.`net_Tasks` (
    `Seq` int AUTO_INCREMENT NOT NULL,
    `TaskId` varchar(50) NOT NULL,
    `Type` int NULL,
    `SubType` int NULL,
    `SubSubType` int NULL,
    `Status` int NULL,
    `Title` varchar(256) NULL,
    `TimeLimit` int NULL,
    `ForMale` tinyint NULL,
    `ForFemale` tinyint NULL,
    `FromAge` int NULL,
    `ToAge` int NULL,
    `AvailabilityLevel` int NULL,
    `PrivacyLevel` int NULL,
    `IntimacyLevel` int NULL,
    `EaseLevel` int NULL,
    `ThinkLevel` int NULL,
    `CourageLevel` int NULL,
    `InsertDate` datetime NULL,
    `LastUpdateDate` datetime NULL,
    `Score` int NULL,
    `Author` int NULL,
    `InUseCount` int NULL,
    CONSTRAINT `PK_Tasks` PRIMARY KEY (`Seq`)
); 
ALTER TABLE `net_tasks`
  ADD KEY `TaskId` (`TaskId`);

/****** Object:  Table `pwm`.`net_TaskStatus`    Script Date: 10/21/2024 8:17:05 PM ******/


CREATE TABLE `pwm`.`net_TaskStatus`(
	`Id` int AUTO_INCREMENT NOT NULL,
	`Description` varchar(1024) NULL,
 CONSTRAINT `PK_TaskStatus` PRIMARY KEY 
(
	`Id` ASC
)
)
;
/****** Object:  Table `pwm`.`net_TaskSubSubType`    Script Date: 10/21/2024 8:17:05 PM ******/


CREATE TABLE `pwm`.`net_TaskSubSubType`(
	`Id` int AUTO_INCREMENT NOT NULL,
	`SubType` int NULL,
	`Description` varchar(1024) NULL,
 CONSTRAINT `PK_TaskSubSubType` PRIMARY KEY 
(
	`Id` ASC
)
)
;
/****** Object:  Table `pwm`.`net_TaskSubType`    Script Date: 10/21/2024 8:17:05 PM ******/


CREATE TABLE `pwm`.`net_TaskSubType`(
	`Id` int AUTO_INCREMENT NOT NULL,
	`TypeId` int NOT NULL,
	`Description` varchar(1024) NULL,
 CONSTRAINT `PK_TaskSubTypes` PRIMARY KEY 
(
	`Id` ASC
)
)
;
/****** Object:  Table `pwm`.`net_TaskText`    Script Date: 10/21/2024 8:17:05 PM ******/


CREATE TABLE `pwm`.`net_TaskText`(
	`Id` int AUTO_INCREMENT NOT NULL,
	`TaskId` varchar(50) NOT NULL,
	`LanguageId` int NOT NULL,
	`TextForM` varchar(1024) NULL,
	`TextForF` varchar(1024) NULL,
	`BackgroundImage` int NULL,
	`CommonDescription` varchar(1024) NULL,
 CONSTRAINT `PK_TaskText` PRIMARY KEY 
(
	`Id` ASC
)
)
;
/****** Object:  Table `pwm`.`net_TaskType`    Script Date: 10/21/2024 8:17:05 PM ******/


CREATE TABLE `pwm`.`net_TaskType`(
	`Id` int AUTO_INCREMENT NOT NULL,
	`Description` varchar(1024) NULL,
 CONSTRAINT `PK_TaskTypes` PRIMARY KEY 
(
	`Id` ASC
)
)
;
/****** Object:  Table `pwm`.`net_TextInMultiLanguages`    Script Date: 10/21/2024 8:17:05 PM ******/


CREATE TABLE `pwm`.`net_TextInMultiLanguages`(
	`Id` int AUTO_INCREMENT NOT NULL,
	`TextId` int NULL,
	text LONGTEXT NULL,
	`LanguageId` int NULL,
 CONSTRAINT `PK_TextInMultiLanguages` PRIMARY KEY 
(
	`Id` ASC
)
)
;
/****** Object:  Table `pwm`.`net_TimesForTask`    Script Date: 10/21/2024 8:17:05 PM ******/


CREATE TABLE `pwm`.`net_TimesForTask`(
	`Id` int AUTO_INCREMENT NOT NULL,
	`TaskId` varchar(50) NOT NULL,
	`FromTime` datetime NULL,
	`ToTime` datetime NULL,
 CONSTRAINT `PK_TimesForTasks` PRIMARY KEY 
(
	`Id` ASC
)
)
; 
/****** Object:  Table `pwm`.`net_UserBlock`    Script Date: 10/21/2024 8:17:05 PM ******/


CREATE TABLE `pwm`.`net_UserBlock`(
	`Id` int NOT NULL,
	`UserId` bigint(20) NOT NULL,
	`BlockByUser` int NOT NULL,
	`CreateOn` datetime NOT NULL,
 CONSTRAINT `PK_UserBlock` PRIMARY KEY 
(
	`Id` ASC
)
)
;
/****** Object:  Table `pwm`.`net_UserCompensation`    Script Date: 10/21/2024 8:17:05 PM ******/


CREATE TABLE `pwm`.`net_UserCompensation`(
	`Id` int AUTO_INCREMENT NOT NULL,
	`UserId` bigint(20) NULL,
 CONSTRAINT `PK_UserCompensation` PRIMARY KEY 
(
	`Id` ASC
)
)
;
/****** Object:  Table `pwm`.`net_UserContact`    Script Date: 10/21/2024 8:17:05 PM ******/


CREATE TABLE `pwm`.`net_UserContact`(
	`Id` int AUTO_INCREMENT NOT NULL,
	`UserId` bigint(20) NOT NULL,
	`ContactUserId` int NOT NULL,
	`Created` datetime NOT NULL,
 CONSTRAINT `PK_UserContact` PRIMARY KEY 
(
	`Id` ASC
)
)
;
/****** Object:  Table `pwm`.`net_UserDislike`    Script Date: 10/21/2024 8:17:05 PM ******/


CREATE TABLE `pwm`.`net_UserDislike`(
	`Id` int AUTO_INCREMENT NOT NULL,
	`UserId` bigint(20) NOT NULL,
	`DislikeId` int NOT NULL,
	`Timestamp` datetime NULL,
	`MessageId` int NULL,
 CONSTRAINT `PK_UserDislike` PRIMARY KEY 
(
	`Id` ASC
)
)
;
/****** Object:  Table `pwm`.`net_UserExtension`    Script Date: 10/21/2024 8:17:05 PM ******/


CREATE TABLE `pwm`.`net_UserExtension`(
	`UserId` bigint(20) NOT NULL,
	`Height` int NULL,
	`Info` varchar(2000) NULL,
 CONSTRAINT `PK_UserExtension` PRIMARY KEY 
(
	`UserId` ASC
)
)
;
/****** Object:  Table `pwm`.`net_UserGroup`    Script Date: 10/21/2024 8:17:05 PM ******/


CREATE TABLE `pwm`.`net_UserGroup`(
	`Id` int AUTO_INCREMENT NOT NULL,
	`UserId` bigint(20) NOT NULL,
	`GroupId` int NOT NULL,
	`Created` datetime NOT NULL,
 CONSTRAINT `PK_UserGroup` PRIMARY KEY 
(
	`Id` ASC
)
)
;
/****** Object:  Table `pwm`.`net_UserReport`    Script Date: 10/21/2024 8:17:05 PM ******/


CREATE TABLE `pwm`.`net_UserReport`(
	`Id` int NOT NULL,
	`UserId` bigint(20) NOT NULL,
	`ReportBy` int NOT NULL,
	`CreateOn` datetime NOT NULL,
	`ReportType` int NOT NULL,
 CONSTRAINT `PK_UserReport` PRIMARY KEY 
(
	`Id` ASC
)
)
;
/****** Object:  Table `pwm`.`net_UserTracking`    Script Date: 10/21/2024 8:17:05 PM ******/


CREATE TABLE `pwm`.`net_UserTracking`(
	`UserId` bigint(20) NOT NULL,
	`Country` varchar(50) NULL,
	`CountryCode` varchar(10) NULL,
	`Region` varchar(50) NULL,
	`RegionName` varchar(50) NULL,
	`City` varchar(50) NULL,
	`Zip` varchar(50) NULL,
	`Latitude` double NULL,
	`Longitude` double NULL,
	`TimeZone` varchar(50) NULL,
	`IP` varchar(50) NULL,
 CONSTRAINT `PK_UserTracking_1` PRIMARY KEY 
(
	`UserId` ASC
)
);
INSERT `pwm`.`net_Areas` (`Id`, `Area`, `Latitude`, `Longitude`) VALUES (1, N'תל אביב', CAST(32.087948 AS Decimal(9, 6)), CAST(34.762226 AS Decimal(9, 6)));
INSERT `pwm`.`net_Areas` (`Id`, `Area`, `Latitude`, `Longitude`) VALUES (2, N'ירושלים', CAST(31.796445 AS Decimal(9, 6)), CAST(35.105319 AS Decimal(9, 6)));
INSERT `pwm`.`net_Areas` (`Id`, `Area`, `Latitude`, `Longitude`) VALUES (3, N'חיפה', CAST(32.799689 AS Decimal(9, 6)), CAST(34.981756 AS Decimal(9, 6)));
INSERT `pwm`.`net_Areas` (`Id`, `Area`, `Latitude`, `Longitude`) VALUES (4, N'באר שבע', CAST(31.261509 AS Decimal(9, 6)), CAST(34.755867 AS Decimal(9, 6)));
  
INSERT `pwm`.`net_ConfigurableText` (`Id`, `Name`) VALUES (1, N'end_game');
INSERT `pwm`.`net_ConfigurableText` (`Id`, `Name`) VALUES (2, N'confirm_continue_play');
INSERT `pwm`.`net_ConfigurableText` (`Id`, `Name`) VALUES (3, N'account_disabled');
INSERT `pwm`.`net_ConfigurableText` (`Id`, `Name`) VALUES (1003, N'play_now_message');
INSERT `pwm`.`net_ConfigurableText` (`Id`, `Name`) VALUES (1004, N'guide_invite_friends');
INSERT `pwm`.`net_ConfigurableText` (`Id`, `Name`) VALUES (1005, N'guide_play_with_partner');
INSERT `pwm`.`net_ConfigurableText` (`Id`, `Name`) VALUES (1006, N'guide_send_message');
INSERT `pwm`.`net_ConfigurableText` (`Id`, `Name`) VALUES (1007, N'guide_play');
INSERT `pwm`.`net_ConfigurableText` (`Id`, `Name`) VALUES (1008, N'guide_play_now_button');
INSERT `pwm`.`net_ConfigurableText` (`Id`, `Name`) VALUES (1009, N'welcome');

INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (1967, N'F1001', 1, N'חשוב לי מה אחרים אומרים עלי `99`, אני מבקר את עצמי יותר מידי `99`, אני מדבר אל עצמי לפעמים `99`', N'חשוב לי מה אחרים אומרים עלי `99`, אני מבקרת את עצמי יותר מידי `99`, אני מדברת אל עצמי לפעמים `99`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (1968, N'F1002', 1, N'בשנה האחרונה הרגשתי בודד `99`, שתקתי רוב הזמן `99`, בכיתי הרבה `99`, אכלתי הרבה שוקולד `99`', N'בשנה האחרונה הרגשתי בודדה `99`, שתקתי רוב הזמן `99`, בכיתי הרבה `99`, אכלתי הרבה שוקולד `99`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (1969, N'F1003', 1, N'אני מביא שקיות מהבית כדי לא לבזבז שקיות חדשות מהסופרמרקט `99`, אני מדפיס מסמכים משני צידי הנייר במדפסת `99`, אני מתקלח מקלחת קצרה לחסוך במים `99`', N'אני מביאה שקיות מהבית כדי לא לבזבז שקיות חדשות מהסופרמרקט `99`, אני מדפיסה מסמכים משני צידי הנייר במדפסת `99`, אני מתקלחת מקלחת קצרה לחסוך במים `99`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (1970, N'F1004', 1, N'כל חודש אני שם כסף בצד `99`, אני יודע בדיוק כמה אני מבזבז בשבוע על מותרת `99`, אני משתדל לקנות בגדים בסיילים ובסופי עונה `99`', N'כל חודש אני שמה כסף בצד `99`, אני יודעת בדיוק כמה אני מבזבזת בשבוע על מותרת `99`, אני משתדלת לקנות בגדים בסיילים ובסופי עונה `99`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (1971, N'F1005', 1, N'אני יוזם ומארח אצלי מסיבות מידי פעם `99`, אני עובד על ביזנס משלי `99`, אני זה שיוזם יציאות עם החבר''ה `99`', N'אני יוזמת ומארחת אצלי מסיבות מידי פעם `99`, אני עובדת על ביזנס משלי `99`, אני זה שיוזמת יציאות עם החבר''ה `99`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (1972, N'F1006', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (1973, N'F1007', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (1974, N'F1008', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (1975, N'F1009', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (1976, N'F1010', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (1977, N'F1011', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (1978, N'F1012', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (1979, N'F1014', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (1980, N'F1015', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (1981, N'F1016', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (1982, N'F1017', 1, N'אין לי בעיה לצחצח שיניים במברשת שלה `99`, אין לי בעיה לערבב איתה מנות במסעדה באותו הסכו"ם `99`, אין לי בעיה אם היא משתעלת על האוכל שלי `99`', N'אין לי בעיה לצחצח שיניים במברשת שלו `99`, אין לי בעיה לערבב איתו מנות במסעדה באותו הסכו"ם `99`, אין לי בעיה אם הוא משתעל על האוכל שלי `99`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (1983, N'F1018', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (1984, N'F1022', 1, N'אני ממליץ לך לראות את הסרט `999`, ואת סדרת הטלוויזיה `999`', N'אני ממליצה לך לראות את הסרט `999`, ואת סדרת הטלוויזיה `999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (1985, N'F1023', 1, N'אני ממליץ לך על הפאב\בר `999` כי הוא `999`, ועל המסעדה `999` בגלל `999`', N'אני ממליץ לך על הפאב\בר `999` כי הוא `999`, ועל המסעדה `999` בגלל `999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (1986, N'F1024', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (1987, N'F1025', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (1988, N'F1026', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (1989, N'F1027', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (1990, N'F1029', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (1991, N'F1030', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (1992, N'F1031', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (1993, N'F1032', 1, N'אם יציעו לי אני אשמח להשתתף בתכנית הריאליטי `99`, מעוניין להיות הבמאי של התכנית `99`, ובאקטואליה לשמש כתב לענייני `99`', N'אם יציעו לי אני אשמח להשתתף בתכנית הריאליטי `99`, מעוניינת להיות במאית של התכנית `99`, ובאקטואליה לשמש כתבת לענייני `99`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (1994, N'F1033', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (1995, N'F1034', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (1996, N'F1035', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (1997, N'F1036', 1, N'בגד ים צמוד או מכנסי גלישה? `99`, להשתזף על החול או לשחות בים? `99`, חוף מבודד, או חוף מוכרז עם מציל? `99`', N'ביקיני או שלם? `99`, להשתזף על החול או לשחות בים? `99`, חוף מבודד, או חוף מוכרז עם מציל? `99`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (1998, N'F1037', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (1999, N'F1038', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2000, N'F1039', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2001, N'F1040', 1, N'ליטוף בעורף `99`, נשיקה בצוואר `99`, דגדוג בבטן `99`, לחיצות בכף הרגל `99`', N'ליטוף בעורף `99`, נשיקה בצוואר `99`, דגדוג בבטן `99`, לחיצות בכף הרגל `99`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2002, N'F1041', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2003, N'F1042', 1, N'רקדתי בגשם `99`, חניתי פעם באדום לבן `99`, הייתי מעורב בתאונת דרכים `99`', N'רקדתי בגשם `99`, חניתי פעם באדום לבן `99`, הייתי מעורבת בתאונת דרכים `99`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2004, N'F1043', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2005, N'F1044', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2006, N'F1045', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2007, N'F1046', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2008, N'F1047', 1, N'אני מתגעגע ל`999`', N'אני מתגעגעת ל`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2009, N'F1048', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2010, N'F1049', 1, N'להתאהב באמת זה `999`', N'להתאהב באמת זה `999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2011, N'F1050', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2012, N'F1051', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2013, N'F1052', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2014, N'F1053', 1, N'אני בוחש את הקפה `99` סיבוב השעון, אני מוריד מכנסיים (בישיבה או עמידה) ב`99`, וכשאני מסיים להתקלח אני קודם כל מנגב את ה`99`', N'אני בוחשת את הקפה `99` סיבוב השעון, אני מורידה מכנסיים (בישיבה או עמידה) ב`99`, וכשאני מסיימת להתקלח אני קודם כל מנגבת את ה`99`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2015, N'F1054', 1, N'חמאת בוטנים `99`, דבש `99`, טחינה `99`, ריבה `99`', N'חמאת בוטנים `99`, דבש `99`, טחינה `99`, ריבה `99`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2016, N'F1159', 1, N'בא לי לפנק את עצמי עכשיו ב`99` ', N'בא לי לפנק את עצמי עכשיו ב`99` ');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2017, N'F1160', 1, N'אף פעם לא יצאתי עם אישה ש`99`', N'אף פעם לא יצאתי עם גבר ש`99`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2018, N'F1161', 1, N'אף פעם לא סיפרתי להורים שלי שאני `99`', N'אף פעם לא סיפרתי להורים שלי שאני `99`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2019, N'F1162', 1, N'בספורט וכושר גופני אני זורם בכיף עד שזה מגיע ל`99`', N'בכושר גופני אני זורמת בכיף עד שזה מגיע ל`99`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2020, N'F1163', 1, N'בטיולים בטבע אני זורם בכיף עד שזה מגיע ל`99`', N'בטיולים בטבע אני זורמת בכיף עד שזה מגיע ל`99`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2021, N'F1164', 1, N'אני אוהב לבלות בחוף הים עד שזה הופך ל`99`', N'אני אוהבת לבלות בחוף הים עד שזה הופך ל`99`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2022, N'F1165', 1, N'אף פעם לא אכלתי `99` אבל דווקא בא לי לנסות.', N'אף פעם לא אכלתי `99` אבל דווקא בא לי לנסות.');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2023, N'F1168', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2024, N'F1169', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2025, N'F1170', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2026, N'F1171', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2027, N'F1172', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2028, N'F1173', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2029, N'F1174', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2030, N'F1175', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2031, N'F1176', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2032, N'F1177', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2033, N'F1180', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2034, N'F1182', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2035, N'F1183', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2036, N'F1184', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2037, N'F1190', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2038, N'F1195', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2039, N'F1196', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2040, N'F1197', 1, N'היתה לנו פגישה `99` ומאוד נהניתי אבל לצערי `99`, אז אני מציע ש`999`', N'היתה לנו פגישה `99` ומאוד נהניתי אבל לצערי `99`, אז אני מציע ש`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2041, N'F1198', 1, N'רציתי להגיד שיש לך (99) הכי מדהים אהבתי בעיקר את ה(99) הבולט שלך ואת ה(99) השובב שלך ואני אשמח ל(99) אותך.', N'רציתי להגיד שיש לך (99) הכי מדהים אהבתי בעיקר את ה(99) הבולט שלך ואת ה(99) השובב שלך ואני אשמח ל(99) אותך.');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2042, N'F1199', 1, N'זה לא מה שאת חושבת. אני בסך הכל (99) והיא בסך הכל (99), ואני והיא בסך הכל (99). ', N'זה לא מה שאתה חושב.  אני בסך הכל (99) והוא בסך הכל (99), (99) ואני והוא בסך הכל (99). ');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2043, N'F1204', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2044, N'F1205', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2045, N'F1206', 1, N'למנה ראשונה אגיש `99` \ למנה עיקרית אכין `99` \ לקינוח אגיש `99` \ ולשתות אגיש `99`', N'למנה ראשונה אגיש `99` \ למנה עיקרית אכין `99` \ לקינוח אגיש `99` \ ולשתות אגיש `99`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2046, N'F1207', 1, N'לדייט אלבש `99` \ כמוסיקת רקע אשים `99` \ אחר כך אציע לה לראות ב -VOD את הסרט `99`, ובסוף אציע לה `99`', N'לדייט אלבש `99` \ כמוסיקת רקע אשים `99` \ אחר כך אציע לו לראות ב -VOD את הסרט `99`, ובסוף אציע לו `99`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2047, N'F1209', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2048, N'F1212', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2049, N'F1213', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2050, N'F1214', 1, N'גובה חשוב לי `9` אחוז, ומשקל חשוב לי `9` אחוז, (ביחד 100%).', N'גובה חשוב לי `9` אחוז, ומשקל חשוב לי `9` אחוז, (ביחד 100%).');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2051, N'F1215', 1, N'שנינות חשובה לי `9` אחוז, ונראית טוב חשוב לי `9` אחוז, (ביחד 100%).', N'שכל חשוב לי `9` אחוז, וחיטוב חשוב לי `9` אחוז, (ביחד 100%).');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2052, N'F1216', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2053, N'F1217', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2054, N'F1226', 1, N'לאנשים שמתגאים שיש להם אלפי חברים בפייסבוק מגיע `99`, ולאנשים שכל הזמן עסוקים בסמארטפון שלהם באמצע פגישה מגיע `99`', N'לאנשים שמתגאים שיש להם אלפי חברים בפייסבוק מגיע `99`, ולאנשים שכל הזמן עסוקים בסמארטפון שלהם באמצע פגישה מגיע `99`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2055, N'F1227', 1, N'לאנשים שלווים ממך סכום לא גדול ולא מחזירים מגיע `99` ולאנשים שמפרסמים בפייסבוק רק דברים מחמיאים, וכמה שנפלא להם מגיע `99`', N'לאנשים שלווים ממך סכום לא גדול ולא מחזירים מגיע `99` ולאנשים שמפרסמים בפייסבוק רק דברים מחמיאים, וכמה שנפלא להם מגיע `99`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2056, N'F1228', 1, N'לנהג שזורק קופסת סיגריות ריקה מחלון המכונית מגיע `99`, ולנהג שצופר חצי שעה לחבר שלו שיירד, מגיע `99`', N'לנהג שזורק קופסת סיגריות ריקה מחלון המכונית מגיע `99`, ולנהג שצופר חצי שעה לחבר שלו שיירד, מגיע `99`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2057, N'F1229', 1, N'לנהג שחוסם את התנועה בחניה כפולה וכשמעירים לו הוא עונה "מה אתה ממהר" מגיע עונש `99`, ולנהג שנוסע לאט באוטוסטרדה במסלול הכי שמאלי מגיע `99`', N'לנהג שחוסם את התנועה בחניה כפולה וכשמעירים לו הוא עונה "מה אתה ממהר" מגיע עונש `99`, ולנהג שנוסע לאט באוטוסטרדה במסלול הכי שמאלי מגיע `99`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2058, N'F1230', 1, N'לנהג שחונה בחניית נכה מגיע `99`, ולנהג שנדחף ברגע האחרון ועוקף את כולם בתור בפניה מגיע `99`', N'לנהג שחונה בחניית נכה מגיע `99`, ולנהג שנדחף ברגע האחרון ועוקף את כולם בתור בפניה מגיע `99`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2059, N'F1231', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2060, N'F1232', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2061, N'F1233', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2062, N'F1234', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2063, N'F1235', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2064, N'F1236', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2065, N'F1237', 1, N'`99` להכין פסטה ברוטב עגבניות \ `99` להכין סטייק או שיפוד \ `99` לטגן שניצל. ', N'`99` להכין פסטה ברוטב עגבניות \ `99` להכין סטייק או שיפוד \ `99` לטגן שניצל. ')
;
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2066, N'F1238', 1, N'`99` לאפות עוגה טעימה \ `99` לפנק בסלט פירות מגניב \ `99` להכין טירמיסו', N'`99` לאפות עוגה טעימה \ `99` לפנק בסלט פירות מגניב \ `99` להכין טירמיסו');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2067, N'F1239', 1, N'`99` להכין מרק עדשים \ `99` לטגן כרוביות \ `99` להכין שקשוקה מהממת', N'`99` להכין מרק עדשים \ `99` לטגן כרוביות \ `99` להכין שקשוקה מהממת');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2068, N'F1240', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2069, N'F1241', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2070, N'F1242', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2071, N'F1243', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2072, N'F1244', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2073, N'F1245', 1, N'את כל הזמן רואה `99` ואת כל הזמן שופכת עלי `99` ומשגעת אותי עם ה`99` שלך', N'אתה כל הזמן רואה `99` ואתה כל הזמן שופך עלי `99` ומשגע אותי עם ה`99` שלך');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2074, N'F1246', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2075, N'F1247', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2076, N'F1248', 1, N'הי. בדיוק נזכרתי ש`99` ואני במקרה כאן עם ה`99` שלי. מתאים לך ש`99`?', N'הי. בדיוק נזכרתי ש`99` ואני במקרה כאן עם ה`99` שלי. מתאים לך ש`99`?');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2077, N'F1249', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2078, N'F1250', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2079, N'F1251', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2080, N'F1252', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2081, N'F1253', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2082, N'F1254', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2083, N'F1255', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2084, N'F1256', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2085, N'F1257', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2086, N'F1258', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2087, N'F1259', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2088, N'F1260', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2089, N'F1261', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2090, N'F1262', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2091, N'F1263', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2092, N'F1264', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2093, N'F1265', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2094, N'F1266', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2095, N'F1267', 1, N'דרג את איכות הדייט עם מילים כמו "מעולה \ גרוע \ סביר -  לצאת להופעה ביחד `99`, לנקות דירה ביחד `99`, לעשות כושר בפארק ביחד `99`', N'דרגי את איכות הדייט עם מילים כמו "מעולה \ גרוע \ סביר - לצאת להופעה ביחד `99`, לנקות דירה ביחד `99`, לעשות כושר בפארק ביחד `99`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2096, N'F1268', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2097, N'F1269', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2098, N'F1270', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2099, N'F1271', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2100, N'F1272', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2101, N'F1273', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2102, N'F1274', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2103, N'F1275', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2104, N'F1276', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2105, N'F1277', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2106, N'F1278', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2107, N'F1279', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2108, N'F1280', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2109, N'F1281', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2110, N'F1282', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2111, N'F1283', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2112, N'F1284', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2113, N'F1285', 1, N'דרג את איכות הדייט עם מילים כמו "מעולה \ גרוע \ סביר - לצאת לפאב `99`, בית קפה `99`, ספסל בפארק `99`, סרט קולנוע `99`', N'דרגי את איכות הדייט עם מילים כמו "מעולה \ גרוע \ סביר - לצאת לפאב `99`, בית קפה `99`, ספסל בפארק `99`, סרט קולנוע `99`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2114, N'F1286', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2115, N'F1287', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2116, N'F1288', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2117, N'F1289', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2118, N'F1290', 1, N'נמאס לי שאת תמיד `200` ואת אף פעם לא `200` ', N'נמאס לי שאתה תמיד `999` ואתה אף פעם לא `999` ');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2119, N'F1291', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2120, N'F1292', 1, N'מעדיף להיות הכי חכמה `9` אחוז, הכי חטוב `9` אחוז, הכי מפורסם `9` (ביחד 100%).', N'מעדיפה להיות הכי חכמה `9` אחוז, הכי חטובה `9` אחוז, הכי מפורסמת `9` (ביחד 100%).');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2121, N'F1293', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2122, N'F1294', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2123, N'F1295', 1, N'לראות סרט באולם קולנוע לבד זה `99`, לטייל בחוץ לארץ לבד זה `99`, ללמוד לבחינות לבד זה `99`', N'לראות סרט באולם קולנוע לבד זה `99`, לטייל בחוץ לארץ לבד זה `99`, ללמוד לבחינות לבד זה `99`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2124, N'F1297', 1, N'השלם את החסר רק במילים כן או לא. אני `30` יודע להכין חביתה, אני `30` יודע להכין עוף בתנור, אני `30` יודע להכין ירקות מוקפצים, אני `30` יודע להכין קוקטיילים מגניבים.', N'השלימי את החסר רק בכן או לא. אני `30` יודעת להכין חביתה, אני `30` יודעת להכין עוף בתנור, אני `30` יודעת להכין ירקות מוקפצים, אני `30` יודעת להכין קוקטיילים מגניבים.');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2125, N'F1298', 1, N'השלם את החסר רק במילים כן או לא. אני `30` יודע להכין עוגת דבש, אני `30` יודע להכין סלט פירות, אני `30` יודע להכין טירמיסו, אני `30` יודע להכין פנקייק.', N'השלימי את החסר רק בכן או לא. אני `30` יודעת להכין עוגת דבש, אני `30` יודעת להכין סלט פירות, אני `30` יודעת להכין טירמיסו, אני `30` יודעת להכין פנקייק.');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2126, N'F1299', 1, N'השלם את החסר רק במילים כן או לא. אני `30` יודע להכין שיפודים במנגל, אני `30` יודע להכין מרק ירקות, אני `30` יודע להכין טוסט, אני `30` יודע להכין שניצל.', N'השלימי את החסר רק בכן או לא. אני `30` יודעת להכין חביתה, אני `30` יודעת להכין עוף בתנור, אני `30` יודעת להכין ירקות מוקפצים, אני `30` יודעת להכין קוקטיילים מגניבים.');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2127, N'F1300', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2128, N'F1302', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2129, N'F1304', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2130, N'F1305', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2131, N'F1307', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2132, N'F1308', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2133, N'F1309', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2134, N'F1310', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2135, N'F1311', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2136, N'F1312', 1, N'אני אוהב מיץ תפוחים `99`, מיץ אשכוליות `99`, קולה `99`, סודה `99`, ג''ין טוניק `99`', N'אני אוהבת מיץ תפוחים `99`, מיץ אשכוליות `99`, קולה `99`, סודה `99`, ג''ין טוניק `99`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2137, N'F1313', 1, N'בדרך כלל בבקרים אני `99` אבל לעומת זאת בלילות אני `99`', N'בדרך כלל בבקרים אני `99` אבל לעומת זאת בלילות אני `99`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2138, N'F1314', 1, N'תכיני לי בבקשה `99`, `99` סוכר, ו`99` חלב', N'תכין לי בבקשה `99`, `99` סוכר, ו`99` חלב');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2139, N'F1315', 1, N'אם אני שומע את הזמר\ת `99` אני תולש את השערות כאן ועכשיו! ', N'אם אני שומעת את הזמר\ת `99` אני תולשת את השערות כאן ועכשיו! ');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2140, N'F1316', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2141, N'F1317', 1, N'הנשיקה הראשונה שלי היתה בגיל `99`, זה קרה ב`99` וזה היה עם `99`', N'הנשיקה הראשונה שלי היתה בגיל `99`, זה קרה ב`99` וזה היה עם `99`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2142, N'F1318', 1, N'המסעדה הכי טובה שאכלתי בה אי פעם היא `99`, ואכלתי שם `99`', N'המסעדה הכי טובה שאכלתי בה אי פעם היא `99`, ואכלתי שם `99`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2143, N'F1321', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2144, N'F1322', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2145, N'F1323', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2146, N'F1324', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2147, N'F1325', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2148, N'F1326', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2149, N'F1327', 1, N'בטיסה אני אוהב לשבת ליד ה`99` (חלון או מעבר), ואני מעביר את הזמן ב`99`', N'בטיסה אני אוהבת לשבת ליד ה`99` (חלון או מעבר), ואני מעבירה את הזמן ב`99`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2150, N'F1328', 1, N'כשאני רוצה לקרוא חדשות, אני בדרך כלל גולש באתר `99`, וחוץ מזה אני אוהב לגלוש באתר `99`', N'כשאני רוצה לקרוא חדשות, אני בדרך כלל גולשת באתר `99`, וחוץ מזה אני אוהבת לגלוש באתר `99`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2151, N'F1329', 1, N'אתמול היה לי יום `200`, ומחר אני מרגיש שהולך להיות `200`', N'אתמול היה לי יום `200`, ומחר אני מרגישה שהולך להיות `200`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2152, N'F1330', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2153, N'F1331', 1, N'בקיץ בחוף הים, אני בדרך כלל מבלה את הזמן ב`99`, ואני אוהב להישאר שם `99` ', N'בקיץ בחוף הים, אני בדרך כלל מבלה את הזמן ב`99`, ואני אוהבת להישאר שם `99`  ');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2154, N'F1332', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2155, N'F1333', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2156, N'F1334', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2157, N'F1335', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2158, N'F1336', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2159, N'F1337', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2160, N'F1338', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2161, N'F1339', 1, N'אם היתה אולימפיאדה בענף `99`, אני בוודאות יכול להתחרות שם בכבוד', N'אם היתה אולימפיאדה בענף `99`, אני בוודאות יכולה להתחרות שם בכבוד');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2162, N'F1340', 1, N'הציון הכי גבוה שקיבלתי בחיי הוא `99` במקצוע `99`, והציון הכי נמוך הוא `99` במקצוע `99` ', N'הציון הכי גבוה שקיבלתי בחיי הוא `99` במקצוע `99`, והציון הכי נמוך הוא `99` במקצוע `99` ');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2163, N'F1341', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2164, N'F1342', 1, N'אני חושב שהרכבת פאזלים זה `99` ואני ממש `99` בזה', N'אני חושבת שהרכבת פאזלים מרובי חלקים זה `99` ואני ממש `99` בזה');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2165, N'F1343', 1, N'`999`', N'`999`')
;
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2166, N'F1344', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2167, N'F1345', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2168, N'F1346', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2169, N'F1347', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2170, N'F1348', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2171, N'F1349', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2172, N'F1350', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2173, N'F1351', 1, N'חשוב לי שהחברה שלי תרגש אותי `99`, חשוב לי שהיא תצחיק אותי `99`, חשוב לי שהיא תפנק אותי `99`', N'חשוב לי שהחבר שלי ירגש אותי `99`, חשוב לי שהוא יצחיק אותי `99`, חשוב לי שהוא יפנק אותי `99`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2174, N'F1352', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2175, N'F1353', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2176, N'F1354', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2177, N'F1355', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2178, N'F1356', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2179, N'F1357', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2180, N'F1358', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2181, N'F1359', 1, N'`99` אתחתן עם מישהי שרוצה להיות פרופסורית למתמטיקה, {99` שאתחתן עם מישהי שרוצה להיות פוליטיקאית,', N'`99` שאתחתן עם מישהו שרוצה להיות פרופסור למתמטיקה, {99` שאתחתן עם מישהי שרוצה להיות פוליטיקאי,');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2182, N'F1360', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2183, N'F1361', 1, N'`99` שאתחתן עם עורכת דין, `99` שאתחתן עם מישהי שרוצה להתנדב באפריקה', N'`99` שאתחתן עם עורך דין, `99` שאתחתן עם מישהו שרוצה להתנדב באפריקה');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2184, N'F1362', 1, N'ספר או סרט - `99`, חומוסיה או איטלקית - `99`, מזרחית או רוקנ''רול - `99`', N'ספר או סרט - `99`, חומוסיה או איטלקית - `99`, מזרחית או רוקנ''רול - `99`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2185, N'F1363', 1, N'שיר לועזי או עברי - `99`, הפוך או אספרסו - `99`, אופניים חשמליים או רגילים - `99`', N'שיר לועזי או עברי - `99`, הפוך או אספרסו - `99`, אופניים חשמליים או רגילים `99`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2186, N'F1364', 1, N'לישון בפיג''מה או בעירום - `99`, רגליים ארוכות או חיוך מקסים - `99`, קומדיה רומנטית או סרט אקשן - `99`', N'לישון בפיג''מה או בעירום - `99`, רגליים ארוכות או חיוך מקסים - `99`, קומדיה רומנטית או סרט אקשן - `99`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2187, N'F1369', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2188, N'F1370', 1, N'אני לובש עכשיו חולצה בצבע `99`, מכנסיים בצבע `99` ותחתונים בצבע `099`', N'אני לובשת עכשיו חולצה בצבע `99`, מכנסיים בצבע `99` ותחתונים בצבע `099`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2189, N'F1371', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2190, N'F1372', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2191, N'F1373', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2192, N'F1374', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2193, N'F1376', 1, N'אם הבוס שלי יבקש ממני `99`, אין סיכוי בעולם שאסכים. ', N'אם הבוס שלי יבקש ממני `99`, אין סיכוי בעולם שאסכים. ');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2194, N'F1377', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2195, N'F1378', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2196, N'F1379', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2197, N'F1380', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2198, N'F1381', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2199, N'F1382', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2200, N'F1383', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2201, N'F1384', 1, N'`99` בוקסר רחבים, `99` בוקסר צמודים, `99` טנגה, ויש לי גם `99`', N'`99` חוטיני, `99` גזרה גבוהה, `99` גזרה נמוכה, `99` מקסי, `99` בייבידול, ויש לי גם `99`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2202, N'F1385', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2203, N'F1386', 1, N'מכונית ספורט `99`, קרם פנים `99`, מכשיר סלולרי `99`, רמקולים איכותיים `99`, כנות `99`', N'מכונית ספורט `99`, קרם פנים `99`, מכשיר סלולרי `99`, רמקולים איכותיים `99`, כנות `99`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2204, N'F1387', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2205, N'F1388', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2206, N'F1389', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2207, N'F1390', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2208, N'F1391', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2209, N'F1392', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2210, N'F1393', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2211, N'F1394', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2212, N'F1395', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2213, N'F1396', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2214, N'F1397', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2215, N'F1398', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2216, N'F1399', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2217, N'F1400', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2218, N'F1403', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2219, N'F1404', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2220, N'F1405', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2221, N'F1406', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2222, N'F1407', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2223, N'F1408', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2224, N'F1409', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2225, N'F1410', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2226, N'F1411', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2227, N'F1415', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2228, N'F1416', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2229, N'F1417', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2230, N'F1418', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2231, N'F1419', 1, N'הלוואי ויכולתי לחלוק `99` עם מישהי עכשיו', N'הלוואי ויכולתי לחלוק `99` עם מישהו עכשיו');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2232, N'F1420', 1, N'שלום, אני `99`. אני `999` ובנוסף `999`', N'שלום, אני `99`. אני `999` ובנוסף `999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2233, N'F1421', 1, N'היי, אני `99` ואני `999` וגם `999` ', N'היי, אני `99` ואני `999` וגם `999` ');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2234, N'F1422', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2235, N'F1423', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2236, N'F1424', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2237, N'F1425', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2238, N'F1426', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2239, N'F1427', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2240, N'F1428', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2241, N'F1429', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2242, N'F1431', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2243, N'F1432', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2244, N'F1433', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2245, N'F1434', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2246, N'F1435', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2247, N'F1436', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2248, N'F1437', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2249, N'F1438', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2250, N'F1439', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2251, N'F1440', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2252, N'F1441', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2253, N'F1442', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2254, N'F1443', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2255, N'F1444', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2256, N'F1445', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2257, N'F1446', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2258, N'F1448', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2259, N'F1449', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2260, N'F1456', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2261, N'F1457', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2262, N'F1459', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2263, N'F1460', 1, N'החולצה היפה הלבנה נצבעה בכביסה `99`, הכתימו לי את החולצה הלבנה ביין אדום `99`, מכונית השפריצה עלי כשעברתי ליד שלולית', N'החולצה היפה הלבנה נצבעה בכביסה `99`, הכתימו לי את החולצה הלבנה ביין אדום `99`, מכונית השפריצה עלי כשעברתי ליד שלולית');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2264, N'F1461', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2265, N'F1462', 1, N'התפשטתי ואז גיליתי שאין מים חמים במקלחת `99`, סיימתי את כל ההכנות לבישול אבל בדיוק נגמר הגז `99`, מילאתי עגלה בסופר, ואז ראיתי ששכחתי את הארנק בבית', N'התפשטתי ואז גיליתי שאין מים חמים במקלחת `99`, סיימתי את כל ההכנות לבישול אבל בדיוק נגמר הגז `99`, מילאתי עגלה בסופר, ואז ראיתי ששכחתי את הארנק בבית')
;
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2266, N'F1463', 1, N'ננעלת פעם מחוץ לבית? `99`, יוצא לך מידי פעם לשכוח איפה שמת את הטלפון? `99`, יצא לך ששכחת משהו מתבשל על הגז וזה נשרף? `99`', N'ננעלת פעם מחוץ לבית? `99`, יוצא לך מידי פעם לשכוח איפה שמת את הטלפון? `99`, יצא לך ששכחת משהו מתבשל על הגז וזה נשרף? `99`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2267, N'F1464', 1, N'לראות טלוויזיה או להקשיב למוסיקה? `99`, חופשה בהרים או חופשה על החוף? `99` להיות רואה ואינו נראה, או קורא מחשבות? `99`', N'לראות טלוויזיה או להקשיב למוסיקה? `99`, חופשה בהרים או חופשה על החוף? `99` להיות רואה ואינו נראה, או קורא מחשבות? `99`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2268, N'F1465', 1, N'בחור קרח או עם שערות בגב ובכתפיים? `99`, בחור נמוך ומצחיק או גבוה ויבשוש? `99`, מוות בטביעה או מוות בתליה?', N'בחורה מגולחת לגמרי, או נטורל? `99`, בחורה נמוכה ומצחיקה או גבוהה ויבשושה? `99`, מוות בטביעה או מוות בתליה?');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2269, N'F1466', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2270, N'F1468', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2271, N'F1469', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2272, N'F1470', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2273, N'F1471', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2274, N'F1472', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2275, N'F1473', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2276, N'F1474', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2277, N'F1475', 1, N'שוקולד או תותים? `99`, לדבר או להקשיב? `99`, אחרי העבודה, הליכה רגועה, או ריצה `99`', N'שוקולד או תותים? `99`, לדבר או להקשיב? `99`, אחרי העבודה, הליכה רגועה, או ריצה `99`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2278, N'F1476', 1, N'לראות הצגה או משחק כדורגל? `99`, לרוץ או ללכת? `99`, טלוויזיה או קולנוע? `99` ', N'לראות הצגה או משחק כדורגל? `99`, לרוץ או ללכת? `99`,  טלוויזיה או קולנוע? `99`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2279, N'F1477', 1, N'לעצב מכונית או לעצב בית? `99`, לגור בתל אביב או בגליל? `99`, לתכנן טיול מראש, או ספונטני? `99`', N'לעצב מכונית או לעצב בית? `99`, לגור בתל אביב או בגליל? `99`, לתכנן טיול מראש, או ספונטני? `99`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2280, N'F1478', 1, N'בוקר או לילה? `99`, טיול אוהלים במדבר או מלון ספא באילת? `99`, אפל או אנדרואיד? `99`', N'בוקר או לילה? `99`, טיול אוהלים במדבר או מלון ספא באילת? `99`, אפל או אנדרואיד? `99`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2281, N'F1479', 1, N'לוס אנג''לס `99`, סניף של H&M `99`, סניף של איקאה `99`', N'לוס אנג''לס `99`, סניף של H&M `99`, סניף של איקאה `99`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2282, N'F1480', 1, N'טיפול פסיכולוגי `99`, טיפול כירופרקטי `99`, טיפול קוסמטי `99`', N'טיפול פסיכולוגי `99`, טיפול כירופרקטי `99`, טיפול קוסמטי `99`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2283, N'F1481', 1, N'נגינה בכלי כלשהו `99`, סדר וניקיון `99`, ארגון ותכנון `99`', N'נגינה בכלי כלשהו `99`, סדר וניקיון `99`, ארגון ותכנון `99`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2284, N'F1482', 1, N'ניהול מו"מ להוריד מחיר של רכב משומש`99`, פירוק והרכבה של מכשירים חשמליים `99`, התנהלות פיננסית נכונה `99`, ', N'ניהול מו"מ להוריד מחיר של רכב משומש`99`, פירוק והרכבה של מכשירים חשמליים `99`, התנהלות פיננסית נכונה `99`, ');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2285, N'F1483', 1, N'שירה `99`, בישול `99`, עיצוב גרפי `99`', N'שירה `99`, בישול `99`, עיצוב גרפי `99`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2286, N'F1484', 1, N'להיות טיפ טופ בלבוש `99`, לרקוד ואלס `99`, להבין בקוקטיילים אלכוהולים `99`', N'להיות טיפ טופ בלבוש `99`, לרקוד ואלס `99`, להבין בקוקטיילים אלכוהולים `99`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2287, N'F1485', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2288, N'F1487', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2289, N'F1488', 1, N'הכי חשוב `99`, אחר כך `99` ובסוף `99`', N'הכי חשוב `99`, אחר כך `99` ובסוף `99`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2290, N'F1489', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2291, N'F1490', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2292, N'F1491', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2293, N'F1492', 1, N'כשאני פוגש מישהי חדשה `99` חשובה ההופעה שלה, `99` חשובה לי האישיות שלה, `99` חשוב לי החיוך שלה', N'כשאני פוגשת מישהו חדש, `99` חשובה לי הופעה שלו, `99` חשובה לי האישיות שלו, `99` חשוב לי החיוך שלו');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2294, N'F1493', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2295, N'F1494', 1, N'סיאנסים (העלאת המתים) `99`, קלפי טארוט `99`, נומרולוגיה `99`', N'סיאנסים (העלאת המתים) `99`, קלפי טארוט `99`, נומרולוגיה `99`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2296, N'F1495', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2297, N'F1496', 1, N'החברים שלך אומרים שאתה כריזמטי - `99`, שאתה אינטלגנטי - `99`, שאתה עפיפון - `99`', N'החברים שלך אומרים שאת כריזמטית - `99`, שאת אינטלגנטי\ת - `99`, שאת עפיפון - `99`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2298, N'F1497', 1, N'החברים שלך אומרים שאתה כיפי - `99`, שאתה נחוש והחלטי - `99`, שאתה פצצת אנרגיה - `99`', N'החברים שלך אומרים שאת כיפית - `99`, שאת נחושת והחלטית - `99`, שאת פצצת אנרגיה - `99`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2299, N'F1498', 1, N'החברים שלך אומרים שאתה מצחיק - `99`, שאתה יצירתי - `99`, שאתה מתלבש טיפ טופ - `99`', N'החברים שלך אומרים שאת מצחיקה - `99`, שאת יצירתית - `99`, שאת מתלבשת טיפ טופ - `99`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2300, N'F1499', 1, N'החברים שלך אומרים שאתה יודע לפתור כל בעיה - `99`, שאתה שמח ומאושר - `99`, שאתה מלא ברוגע בשלווה - `99`', N'החברים שלך אומרים שאת יודעת לפתור כל בעיה - `99`, שאת שמחה ומאושרת - `99`, שאת מלאה ברוגע בשלווה - `99`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2301, N'F1500', 1, N'החברים שלך אומרים שיש בך צד מסתורי ומוזר - `99`, שיש לך ביטחון עצמי - `99`, שאתה בהחלט יודע ליהנות ולבלות - `99`', N'החברים שלך אומרים שיש בך צד מסתורי ומוזר - `99`, שיש לך ביטחון עצמי - `99`, שאת בהחלט יודעת ליהנות ולבלות - `99`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2302, N'F1501', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2303, N'F1502', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2304, N'F1503', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2305, N'F1504', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2306, N'F1505', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2307, N'F1506', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2308, N'F1507', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2309, N'F1508', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2310, N'F1509', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2311, N'F1510', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2312, N'F1511', 1, N'הישגיות בקריירה `99`, רומנטיקה `99`, חברים טובים `99`', N'הישגיות בקריירה `99`, רומנטיקה `99`, חברים טובים `99`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2313, N'F1512', 1, N'קארמה `99`, פרופורציות `99`, אוכל `99`, משפחה `99`', N'קארמה `99`, פרופורציות `99`, אוכל `99`, משפחה `99`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2314, N'F1513', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2315, N'F1514', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2316, N'F1515', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2317, N'F1516', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2318, N'F1517', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2319, N'F1518', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2320, N'F1519', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2321, N'F1520', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2322, N'F1521', 1, N'חליפה רשמית `99`, עיצוב תסרוקת מוקפד `99`,  חולצת בד עם כפתורים `99`', N'נעלי עקב `99`, חצאית מיני `99`,  איפור יומי `99`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2323, N'F1522', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2324, N'F1523', 1, N'אני מתקלח `99` דקות, אחרי המקלחת אני בוחר בגדים ליציאה תוך `99` דקות, ולוקח לי להתלבש ולהתכונן ליציאה `99` דקות ', N'אני נוהגת להתקלח `99` דקות, אחרי המקלחת אני בוחרת בגדים תוך `99` דקות, ולוקח לי להתלבש ולהתכונן ליציאה תוך `99` דקות');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2325, N'F1524', 1, N'אני אוכל ארוחת בוקר ב `99` דקות, מסיים קניה שבועית בסופרמרקט תוך `99` דקות, מצחצח שיניים לפני השינה תוך `99` דקות', N'אני אוכלת ארוחת בוקר ב `99` דקות, מסיימת קניה שבועית בסופרמרקט תוך `99` דקות, מצחצחת שיניים לפני השינה תוך `99` דקות');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2326, N'F1525', 1, N'עם כמה כריות אתה ישן? `99`, מזרן רך או קשה? `99`, חלון פתוח או סגור? `99`', N'עם כמה כריות את ישנה? `99`, מזרן רך או קשה? `99`, חלון פתוח או סגור? `99`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2327, N'F1526', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2328, N'F1527', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2329, N'F1528', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2330, N'F1529', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2331, N'F1530', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2332, N'F1531', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2333, N'F1532', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2334, N'F1533', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2335, N'F1534', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2336, N'F1535', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2337, N'F1536', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2338, N'F1537', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2339, N'F1538', 1, N'עם `99` אדבר על בעיות בזוגיות, עם `99` אדבר על כסף, עם `99` אדבר על הפנטזיות שלי', N'עם `99` אדבר על בעיות בזוגיות, עם `99` אדבר על כסף, עם `99` אדבר על הפנטזיות שלי');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2340, N'F1539', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2341, N'F1540', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2342, N'F1541', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2343, N'F1542', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2344, N'F1543', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2345, N'F1544', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2346, N'F1545', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2347, N'F1546', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2348, N'F1547', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2349, N'F1548', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2350, N'F1549', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2351, N'F1550', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2352, N'F1551', 1, N'עגילים - `99`, ענק - `99`, צמידים - `99`, פירסינג - `99`', N'עגילים - `99`, ענק - `99`, צמידים - `99`, פירסינג - `99`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2353, N'F1552', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2354, N'F1553', 1, N'פיקניק רומנטי בפארק - `99`,  סרט קולנוע - `99`, צניחה חופשית - `99`, הליכה ספורטיבית - `99`, בית קפה - `99`', N'פיקניק רומנטי בפארק - `99`,  סרט קולנוע - `99`, צניחה חופשית - `99`, הליכה ספורטיבית - `99`, בית קפה - `99`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2355, N'F1554', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2356, N'F1555', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2357, N'F1556', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2358, N'F1557', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2359, N'F1558', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2360, N'F1559', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2361, N'F1560', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2362, N'F1561', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2363, N'F1562', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2364, N'F1563', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2365, N'F1564', 1, N'`999`', N'`999`')
;
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2366, N'F1565', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2367, N'F1566', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2368, N'F1567', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2369, N'F1568', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2370, N'F1569', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2371, N'F1570', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2372, N'F1571', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2373, N'F1572', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2374, N'F1573', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2375, N'F1574', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2376, N'F1575', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2377, N'F1576', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2378, N'F1578', 1, N'סמארטפון הוא בדרגת חשיבות `99`, מלאי חטיפים מלוחים `99`,  ספרים טובים `99`, פרטנרית לזוגיות `99`', N'סמארטפון הוא בדרגת חשיבות `99`, מלאי חטיפים מלוחים `99`,  ספרים טובים `99`, פרטנר לזוגיות `99`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2379, N'F1579', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2380, N'F1580', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2381, N'F1581', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2382, N'F1582', 1, N'אני `99`  מאמין בגלגול נשמות, אני `99` מאמין ברוחות, אני `99` מאמין בטלפתיה', N'אני `99` מאמינה בגלגול נשמות, אני `99` מאמינה ברוחות, אני `99` מאמינה בטלפתיה');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2383, N'F1583', 1, N'אני `99`  מאמין בגן עדן וגיהנום, אני `99` מאמין בגורל קבוע מראש, אני `99` מאמין בתקשורת עם המתים', N'אני `99`  מאמיןנה בגן עדן וגיהנום, אני `99` מאמינה בגורל קבוע מראש, אני `99` מאמינה בתקשורת עם המתים');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2384, N'F1584', 1, N'במקום הראשון `99`, במקום השני `99`, במקום השלישי `99` ', N'במקום הראשון `99`, במקום השני `99`, במקום השלישי `99` ');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2385, N'F1585', 1, N'מתי בפעם האחרונה קראת ספר `99`, הלכת לתיאטרון `99`, הפגנת בהפגנה `99`', N'מתי בפעם האחרונה קראת ספר `99`, הלכת לתיאטרון `99`, הפגנת בהפגנה `99`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2386, N'F1586', 1, N'אולם אירועים מפואר `99`,  גן אירועים `99`, ביער נידח בארגון עצמי `99`, לאס וגאס `99`, חתונה צנועה בגינה של ההורים', N'אולם אירועים מפואר `99`,  גן אירועים `99`, ביער נידח בארגון עצמי `99`, לאס וגאס `99`, חתונה צנועה בגינה של ההורים');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2387, N'F1587', 1, N'את קצת `99`, ואני קצת `99`, ונראה לי ש`99`', N'אתה קצת `99`, ואני קצת `99`, ונראה לי ש`99`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2388, N'F1588', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2389, N'F1589', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2390, N'F1590', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2391, N'F1591', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2392, N'F1592', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2393, N'F1593', 1, N'מפגש בהפסקה בקפיטריה `99`, פתקים תוך כדי שיעור `99`, לימוד זוגי ביחד למבחן `99`', N'מפגש בהפסקה בקפיטריה `99`, פתקים תוך כדי שיעור `99`, לימוד זוגי ביחד למבחן `99`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2394, N'F1594', 1, N'אני מוכן לצאת עם מישהי שהיא מקסימום  `99` שנים מעל, ומקסימום `99` שנים מתחתלגילי. ', N'אני מוכנה לצאת עם מישהו מקסימום `99` שנים מעל, ומקסימום `99` שנים מתחת לגילי. ');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2395, N'F1595', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2396, N'F1596', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2397, N'F1597', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2398, N'F1598', 1, N'גיק מחשבים דומה לי ב `99` אחוז, ערס עם שרשראות דומה לי ב `99` אחוז, שרירן מנופח דומה לי ב `99` אחוז', N'`99` אחוז סיכוי שאצא עם גיק מחשבים, `99` סיכוי שאצא עם ערס עם שרשראות, `99` סיכוי שאבחר בשרירן מנופח');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2399, N'F1599', 1, N'`99` סיכוי שאצא עם אחת עם לוק של דוגמנית אבל לא מבריקה במיוחד, `99` אחוז סיכוי שאצא עם חדת לשון שתמיד מנצחת בויכוח, `99` סיכוי שאצא עם ביישנית ', N'לוק של דוגמנית אבל לא מבריקה במיוחד דומה לי ב `99` אחוז, תמיד מנצחת בויכוח דומה לי ב `99` אחוז, ביישנית דומה לי ב `99` אחוז');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2400, N'F1600', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2401, N'F1601', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2402, N'F1602', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2403, N'F1603', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2404, N'F1604', 1, N'אני חושב שנשים שמתחילות עם גברים זה `99` בגלל ש`99`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2405, N'F1606', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2406, N'F1607', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2407, N'F1608', 1, N'לגרום לה לצחוק `99`, לפנק אותה בליטופים `99`, להקשיב לה `99` ', N'לגרום לו לצחוק `99`, לפנק אותו בליטופים `99`, להקשיב לו `99` ');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2408, N'F1609', 1, N'לקנות לה מתנות `99`, לקחת אותה לטיולים מושקעים `99`, להעריף עליה תשומת לב `99`', N'לקנות לו מתנות `99`, לקחת אותו לטיולים מושקעים `99`, להעריף עליו תשומת לב `99`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2409, N'F1610', 1, N'להחמיא לה על הלוק שלה `99`, להחמיא לה על השכל שלה `99`, להחמיא לה על האישיות שלה `99`', N'להחמיא לו על הלוק שלו `99`, להחמיא לו על השכל שלו `99`, להחמיא לו על האישיות שלו `99` ');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2410, N'F1611', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2411, N'F1612', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2412, N'F1613', 1, N'אני ריאליסט `99`, אני וורקוהוליק `99`, אני איש של אתגרים `99`', N'אני ריאליסטית `99`, אני וורקוהולית `99`, אני אישה של אתגרים `99`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2413, N'F1614', 1, N'אני זאב בודד `99`, יש לי ביטחון עצמי גבוה `99`, אוני אוהב להוביל `99`', N'אני זאבה בודדה `99`, יש לי ביטחון עצמי גבוה `99`, אני אוהבת להוביל `99`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2414, N'F1615', 1, N'ספורטאית `99`, יודעת לבשל `99`, אמנית יוצרת `99`', N'ספורטאי `99`, יודע לבשל `99`, אמן יוצר `99`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2415, N'F1616', 1, N'רקדנית `99`, נהגת משאית `99`, שוטרת `99`', N'רקדן `99`, נהג משאית `99`, שוטר `99`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2416, N'F1617', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2417, N'F1618', 1, N'סקי `99` טיפוס הרים `99`, צניחה חופשית `99`', N'סקי `99` טיפוס הרים `99`, צניחה חופשית `99`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2418, N'F1619', 1, N'גלישת גלים `99`, טיול לקוטב `99`, אופני שטח `99`', N'גלישת גלים `99`, טיול לקוטב `99`, אופני שטח `99`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2419, N'F1620', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2420, N'F1621', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2421, N'F1622', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2422, N'F1623', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2423, N'F1624', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2424, N'F1625', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2425, N'F1626', 1, N'נשיקה חושנית `99`, מיקס ערוך של שירים יפים `99`, שוקולד בלגי', N'נשיקה חושנית `99`, מיקס ערוך של שירים יפים `99`, שוקולד בלגי');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2426, N'F1627', 1, N'טיול בשדה בגשם `99`, מסיבת הפתעה `99`, גור כלבים `99`', N'טיול בשדה בגשם `99`, מסיבת הפתעה `99`, גור כלבים `99`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2427, N'F1628', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2428, N'F1629', 1, N'מעצב שיער `99`, חקלאי `99` מורה דרך `99`', N'מעצבת שיער `99`, חקלאית `99` מורת דרך `99`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2429, N'F1630', 1, N'נהג מונית `99`, טייס `99`, זמר חתונות `99`', N'נהגת מונית `99`, טייסת `99`, זמר חתונות `99`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2430, N'F1631', 1, N'עורך דין `99`, רואה חשבון `99`, בלש משטרה `99`', N'עורכת דין `99`, רואת חשבון `99`, בלשית משטרה `99`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2431, N'F1632', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2432, N'F1633', 1, N'ליצן החבורה `99`, המשוגע שבחבורה `99`, הבחור הטוב שאפשר לסמוך עליו `99` ', N'ליצנית החבורה `99`, המשוגעת שבחבורה `99`, הבחורה הטובה שאפשר לסמוך עליה `99` ');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2433, N'F1634', 1, N'יש לה טעם רע בבגדים `99`, היא קנאית `99`, לוקחת את כל השמיכה בחורף `99` ', N'יש לו טעם רע בבגדים `99`, הוא קנאי `99`, לוקח את כל השמיכה בחורף `99` ');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2434, N'F1635', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2435, N'F1636', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2436, N'F1637', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2437, N'F1638', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2438, N'F1639', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2439, N'F1640', 1, N'זה עושה לי חשק ל`999`', N'זה עושה לי חשק ל`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2440, N'F1641', 1, N'זה עושה לי חשק ל`999`', N'זה עושה לי חשק ל`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2441, N'F1642', 1, N'אלכוהול `99`, כושר גופני `99`, סרט בטלוויזיה `99`', N'אלכוהול `99`, כושר גופני `99`, סרט בטלוויזיה `99`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2442, N'F1643', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2443, N'F1644', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2444, N'F1645', 1, N'אינטלגנציה רגשית `99`, מסירות `99`, היכולת להיות שרוטה לפעמים `99`', N'אינטלגנציה רגשית `99`, מסירות `99`, היכולת להיות שרוט לפעמים `99`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2445, N'F1646', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2446, N'F1647', 1, N'אנוכי `99`, עצלן `99`, אדיש `99`', N'אנוכית `99`, עצלנית `99`, אדישה `99`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2447, N'F1648', 1, N'קמצן `99`, זאב בודד `99`, קילר `99`', N'קמצנית `99`, זאבה בודדה `99`, קילרית `99`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2448, N'F1649', 1, N'יער ענקי מלא ערפל `99`, בית קברות `99`, סמטא חשוכה בלילה בעיר `99`', N'יער ענקי מלא ערפל `99`, בית קברות `99`, סמטא חשוכה בלילה בעיר `99`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2449, N'F1650', 1, N'פסגת האוורסט `99`, ג''ונגלים בברזיל `99`, טיסה לירח `99`, ', N'פסגת האוורסט `99`, ג''ונגלים בברזיל `99`, טיסה לירח `99`, ');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2450, N'F1651', 1, N'אנטארקטיקה `99`, צלילה בקרקעית הים `99`, ראפטינג בצרפת `99`', N'אנטארקטיקה `99`, צלילה בקרקעית הים `99`, ראפטינג בצרפת `99`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2451, N'F1653', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2452, N'F1654', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2453, N'F1655', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2454, N'F1656', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2455, N'F1657', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2456, N'F1658', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2457, N'F1659', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2458, N'F1660', 1, N'משחק הקופסא הפייבוריטי הוא `99`, משחק ארקייד הכי שווה הוא `99`, ומשחק קלפים הכי הכי הוא `99`', N'משחק הקופסא הפייבוריטי הוא `99`, משחק ארקייד הכי שווה הוא `99`, ומשחק קלפים הכי הכי הוא `99`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2459, N'F1661', 1, N'לשאוב אבק `99`, לכבס ולתלות כביסה `99`, לשטוף כלים `99`', N'לשאוב אבק `99`, לכבס ולתלות כביסה `99`, לשטוף כלים `99`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2460, N'F1662', 1, N'לשפוך את הפח `99`, לשטוף את הבית `99`, לסדר את חדר עבודה `99`', N'לשפוך את הפח `99`, לשטוף את הבית `99`, לסדר את חדר עבודה `99`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2461, N'F1663', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2462, N'F1664', 1, N'סדר וניקיון במחברות `999`, משתתף בשיעורים `999`, יש לו פונטציאל `99` והוא מממש אותו `99`', N'סדר וניקיון במחברות `999`, משתתף בשיעורים `999`, יש לו פונטציאל `999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2463, N'F1665', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2464, N'F1666', 1, N'מפטפט בשיעור `99`, מתייחס בכבוד למורה `99`, מתייצב בזמן לכל השיעורים `99`', N'מפטפטת בשיעור `99`, מתייחסת בכבוד למורה `99`, מתייצבת בזמן לכל השיעורים `99`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2465, N'F1667', 1, N'עד כמה רומנטי? הליכה בשלג `99`, טבילה בכינרת `99`, מלון 5 כוכבים באילת `99`', N'עד כמה רומנטי? הליכה בשלג `99`, טבילה בכינרת `99`, מלון 5 כוכבים באילת `99`')
;
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2466, N'F1668', 1, N'עד כמה רומנטי? סביב למדורה עם גיטרה `99`, צפיה במיטה בסדרה אהובה `99`, בניית רהיט של איקאה ביחד `99`, ', N'עד כמה רומנטי? סביב למדורה עם גיטרה `99`, צפיה במיטה בסדרה אהובה `99`, בניית רהיט של איקאה ביחד `99`, ');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2467, N'F1669', 1, N'אני שוטף את הבית `99` פעמים בשבוע, מכבס בגדים `99` פעמים בחודש, ומסדר את החדר שלי `99` פעמים בשנה', N'אני שוטפת את הבית `99` פעמים בשבוע, מכבסת בגדים `99` פעמים בחודש, ומסדרת את החדר שלי `99` פעמים בשנה');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2468, N'F1670', 1, N'מישהי שישבה בכלא על עבירת גניבה `99`, מישהי שעברה ילדות קשה `99`, מישהי שנעצרה על אלימות `99`', N'מישהו שישב בכלא על עבירת גניבה `99`, משהו שעבר ילדות קשה `99`, מישהו שנעצר על אלימות `99`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2469, N'F1671', 1, N'מישהי שתפסת אותה בשקר `99`, מישהי שבגדה בחבר הקודם שלה `99`, מישהי שהזריקה בעבר הרואין אבל עכשיו נקיה `99` ', N'מישהו שתפסת אותו בשקר `99`, מישהו שבגד בחברה הקודמת שלו `99`, מישהו שהזריק בעבר הירואין ועכשיו הוא נקי `99`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2470, N'F1672', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2471, N'F1673', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2472, N'F1674', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2473, N'F1675', 1, N'ידע כללי רחב `99`, הבנה באנשים `99`, אתה בולדוזר `99`', N'ידע כללי רחב `99`, הבנה באנשים `99`, את בולדוזרית `99`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2474, N'F1676', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2475, N'F1677', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2476, N'F1678', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2477, N'F1679', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2478, N'F1680', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2479, N'F1681', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2480, N'F1682', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2481, N'F1683', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2482, N'F1684', 1, N'סופגניה בחנוכה `99`, מציה בפסח `99`, אזני המן בפורים `99`', N'סופגניה בחנוכה `99`, מציה בפסח `99`, אזני המן בפורים `99`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2483, N'F1685', 1, N'צפיה בטלוויזיה `99`, לשכב\לשבת על החוף `99`, שופינג `99`', N'צפיה בטלוויזיה `99`, לשכב\לשבת על החוף `99`, שופינג `99`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2484, N'F1686', 1, N'בעוד 20 שנה יהיו לי `99` ילדים, אגור ב`99`, אעבוד ב`99`, והתחביב שלי יהיה `99`', N'בעוד 20 שנה יהיו לי `99` ילדים, אגור ב`99`, אעבוד ב`99`, והתחביב שלי יהיה `99`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2485, N'F1687', 1, N'אני פוחד מנחש `99`, עקרב `99`, עכביש `99`, ג''וק `99`', N'אני פוחדת מנחש `99`, עקרב `99`, עכביש `99`, ג''וק `99`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2486, N'F1688', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2487, N'F1689', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2488, N'F1690', 1, N'החברים שלי יודעים שאם צריך, תמיד אפשר לסמוך עלי שאוכל להשיג להם `999`', N'החברים שלי יודעים שאם צריך, תמיד אפשר לסמוך עלי שאוכל להשיג להם `999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2489, N'F1691', 1, N'`99` לי נעליים יעודיות להליכה, `99` לי ערכת גז לקמפינג, `99` לי אוהל מתקפל, `99` לי שק שינה', N'`99` לי נעליים יעודיות להליכה, `99` לי ערכת גז לקמפינג, `99` לי אוהל מתקפל, `99` לי שק שינה');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2490, N'F1692', 1, N'כסף `99`, לעזור לאחרים `99`, קריירה `99`, אהבה `99`', N'כסף `99`, לעזור לאחרים `99`, קריירה `99`, אהבה `99`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2491, N'F1693', 1, N'כדי להתעורר אני משתמש בנודניק `99` פעמים, לוקח לי `99` דקות להתעורר לגמרי ולהתחיל לתפקד, ובדרך כלל המצב רוח שלי בבוקר הוא `99`', N'כדי להתעורר אני משתמשת בנודניק `99` פעמים, לוקח לי `99` דקות להתעורר לגמרי ולהתחיל לתפקד, ובדרך כלל המצב רוח שלי בבוקר הוא `99`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2492, N'F1694', 1, N'ריצת 5 ק"מ ב 5 בבוקר `99`, שחיית בוקר לפני העבודה `99`, לקום ב-5 לראות את הזריחה בים `99`', N'ריצת 5 ק"מ ב 5 בבוקר `99`, שחיית בוקר לפני העבודה `99`, לקום ב-5 לראות את הזריחה בים `99`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2493, N'F1695', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2494, N'F1696', 1, N'חשפן `99`, מנחה באח הגדול `99`, מציל בים `99`', N'חשפנית `99`, מנחה באח הגדול `99`, מצילה בים `99`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2495, N'F1697', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2496, N'F1698', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2497, N'F1699', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2498, N'F1700', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2499, N'F1701', 1, N'קנאה `99`, שחצנות `99`, עצלנות `99`', N'קנאה `99`, שחצנות `99`, עצלנות `99`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2500, N'F1702', 1, N'אכילה בלי שליטה מתוך בולמוס `99`, זלזול ביקרים לך `99`, התנשאות `99`', N'אכילה בלי שליטה מתוך בולמוס `99`, זלזול ביקרים לך `99`, התנשאות `99`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2501, N'F1703', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2502, N'F1704', 1, N'נסיעה באופניים `99`, טיול בחוף הים `99`, לתפוס תנומה `99`, להמשיך לשחק איתך `99`', N'נסיעה באופניים `99`, טיול בחוף הים `99`, לתפוס תנומה `99`, להמשיך לשחק איתך `99`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2503, N'F1705', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2504, N'F1706', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2505, N'F1707', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2506, N'F1708', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2507, N'F1709', 1, N'אופנוע הארלי דווידסון `99`, למבורגיני `99`, רכב שטח 4X4 `99`', N'אופנוע הארלי דווידסון `99`,  למבורגיני `99`, רכב שטח 4X4 `99`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2508, N'F1710', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2509, N'F1711', 1, N'בבית קפה - לקוח שצועק בסלולרי `99`, קבצן שנכנס לבקש נדבה מהאורחים `99`, לקוחות שנכנסו אחריך מקבלים שירות הרבה לפניך 99`, המנה שהגיעה אחרת ממה שהזמנת `99`', N'בבית קפה - לקוח שצועק בסלולרי `99`, קבצן שנכנס לבקש נדבה מהאורחים `99`, לקוחות שנכנסו אחריך מקבלים שירות הרבה לפניך `99`, המנה שהגיעה אחרת ממה שהזמנת `99`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2510, N'F1712', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2511, N'F1713', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2512, N'F1714', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2513, N'F1715', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2514, N'F1716', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2515, N'F1717', 1, N'מסאז'' עם שמן `99`, ארוחה במסעדה על צוק בגרנד קניון `99`, לשבת ביציע המכובדים בגמר המונדיאל `99`', N'מסאז'' עם שמן `99`, ארוחה במסעדה על צוק בגרנד קניון `99`, לשבת ביציע המכובדים בגמר המונדיאל `99`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2516, N'F1718', 1, N'עד כמה אתה פוחד לטוס `99`, ממקומות גבוהים `99`, ממקומות סגורים `99`', N'עד כמה את פוחדת לטוס `99`, ממקומות גבוהים `99`, ממקומות סגורים `99`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2517, N'F1719', 1, N'עד כמה אתה פוחד מחושך `99`, מוות `99`, ברקים ורעמים `99`', N'עד כמה את פוחדת מחושך `99`, מוות `99`, ברקים ורעמים `99`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2518, N'F1720', 1, N'ביקור במוזיאון אמנות `99`, הרצאה על פיסיקת קוונטים `99`, סיור באתר חפירות ארכיאולוגיות `99`', N'ביקור במוזיאון אמנות `99`, הרצאה על פיסיקת קוונטים `99`, סיור באתר חפירות ארכיאולוגיות `99`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2519, N'F1721', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2520, N'F1722', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2521, N'F1723', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2522, N'F1724', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2523, N'F1725', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2524, N'F1726', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2525, N'F1727', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2526, N'F1728', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2527, N'F1729', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2528, N'F1730', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2529, N'F1731', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2530, N'F1732', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2531, N'F1733', 1, N'אשת חלומותי תהיה `99`, וגם `99`, וחייבת להיות `99`', N'גבר חלומותי יהיה `99`, וגם `99`, וחייב להיות `99`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2532, N'F1734', 1, N'שקרים `99`, חוסר בקרבה פיזית `99`, בעיות תקשורת `99`, הקפדה על לבוש `99`', N'שקרים `99`, חוסר בקרבה פיזית `99`, בעיות תקשורת `99`, הקפדה על לבוש `99`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2533, N'F1735', 1, N'ריבים וצעקות `99`, חוסר כבוד `99`, זלזול `99`, ההורים שלה מעצבנים `99`', N'ריבים וצעקות `99`, חוסר כבוד `99`, זלזול `99`,  ההורים שלו מעצבנים `99`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2534, N'F1736', 1, N'היעדר ניצוץ `99`, עסוקה מידי בעבודה `99`, לא מרוויחה מספיק `99`', N'היעדר ניצוץ `99`, עסוק מידי בעבודה `99`, לא מרוויח מספיק `99`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2535, N'F1737', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2536, N'F1738', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2537, N'F1739', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2538, N'F1740', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2539, N'F1741', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2540, N'F1742', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2541, N'F1744', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2542, N'F1745', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2543, N'F1747', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2544, N'F1748', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2545, N'F1749', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2546, N'F1750', 1, N'אני אוהב אותך כל כך, בשבילי את ה`99` וה`99`, והלוואי ש`99`', N'אני אוהבת אותך כל כך, בשבילי אתה ה`99` וה`99`, והלוואי ש`99`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2547, N'F1751', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2548, N'F1752', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2549, N'F1753', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2550, N'F1754', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2551, N'F1755', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2552, N'F1756', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2553, N'F1757', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2554, N'F1758', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2555, N'F1759', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2556, N'F1760', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2557, N'F1761', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2558, N'F1762', 1, N'ריח של גשם ראשון `99`, עוגת תפוחים `99`, חוף ים `99`, גויאבה `99`', N'ריח של גשם ראשון `99`, עוגת תפוחים `99`, חוף ים `99`, גויאבה `99`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2559, N'F1763', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2560, N'F1764', 1, N'גשם זה עצבות `99`, גשם זה אושר `99` ובמילים שלך - גשם זה `99`', N'גשם זה עצבות `99`, גשם זה אושר `99` ובמילים שלך - גשם זה `99`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2561, N'F1766', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2562, N'F1767', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2563, N'F1768', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2564, N'F1769', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2565, N'F1770', 1, N'`999`', N'`999`')
;
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2566, N'F1771', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2567, N'F1772', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2568, N'F1773', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2569, N'F1774', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2570, N'F1776', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2571, N'F1778', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2572, N'F1779', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2573, N'F1780', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2574, N'F1783', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2575, N'F1784', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2576, N'F1785', 1, N'גלגל"צ `99`, רדיו מנטה `99`, 88FM `99`, 103FM `99`, רשת גימל `99`, תחנה שאתה מאוד אוהב ולא ברשימה `99`', N'גלגל"צ `99`, רדיו מנטה `99`, 88FM `99`, 103FM `99`, רשת גימל `99`, תחנה שאת מאוד אוהבת ולא ברשימה `99`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2577, N'F1786', 1, N'קפיצה ביחד על טרמפולינה `99`, טיול בחסקה `99`, שיעור ריקוד סלסה `99`', N'קפיצה ביחד על טרמפולינה `99`, טיול בחסקה `99`, שיעור ריקוד סלסה `99`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2578, N'F1787', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2579, N'F1788', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2580, N'F1789', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2581, N'F1790', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2582, N'F1791', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2583, N'F1792', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2584, N'F1793', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2585, N'F1794', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2586, N'F1795', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2587, N'F1796', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2588, N'F1797', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2589, N'F1798', 1, N'אני משלם חשבונות בזמן `99`, אני בודק דפי בנק `99`, אף פעם אין לי מינוס `99`', N'אני משלמת חשבונות בזמן `99`, אני בודקת דפי בנק `99`, אף פעם אין לי מינוס `99`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2590, N'F1799', 1, N'אני אוהב לטייל טיולי אוהלים `99`, אני יכול להירדם גם על הרצפה `99`, אני מתקלח גם אם אין מים חמים `99`', N'אני אוהבת לטייל טיולי אוהלים `99`, אני יכולה להירדם גם על הרצפה `99`, אני מתקלחת גם אם אין מים חמים `99`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2591, N'F1800', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2592, N'F1801', 1, N'נקניקיה בלחמניה `99`, המבורגר `99`, שווארמה `99`', N'נקניקיה בלחמניה `99`, המבורגר `99`, שווארמה `99`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2593, N'F1802', 1, N'מלוואח או ג''חנון `99`, פיצוחים `99`, גלידה `99`', N'מלוואח או ג''חנון `99`, פיצוחים `99`, גלידה `99`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2594, N'F1803', 1, N'הפיצה שאני אוהב תהיה מורכבת מ`999`', N'הפיצה שאני אוהבת תהיה מורכבת מ`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2595, N'F1804', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2596, N'F1805', 1, N'להניע רכב בכבלים `99`, להחליף שקית לשואב אבק `99`, להחליף מיתר לגיטרה `99` ', N'אני יודעת להניע רכב בכבלים `99`, להחליף שקית לשואב אבק `99`, להחליף מיתר לגיטרה `99` ');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2597, N'F1807', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2598, N'F1808', 1, N'אתה חמוד `99`, אפשר לדבר איתך כמו חבר טוב `99`, יש לך בייבי פייס `99`', N'את בחורה זורמת `99`, אפשר לדבר איתך כמו חברה טובה `99`, יש לך בייבי פייס `99`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2599, N'F1809', 1, N'זה בסדר, אני ממילא לא אוהבת יותר מידי שרירים `99`, אל תהיה לחוץ, דווקא יש לך גוף סבבה `99`, אתה לא כמו כולם `99` ', N'זה בסדר, אני ממילא לא אוהב רזות מידי  `99`, את כוסית `99`, את יכולה להיראות טוב כשאת משקיעה `99`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2600, N'F1810', 1, N'חשפנית `99`, דוגמנית בינלאומית `99`, מדריכת טיולים לחו"ל `99`', N'חשפן `99`, קצין משטרה בשטח `99`, ימאי בספינה `99`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2601, N'F1811', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2602, N'F1812', 1, N'די ג''יי `99`, דיילת טעימות בסופרמרקט `99`, ברוקר בבורסה `99`, אפשר לוותר גם על `99`', N'די ג''יי `99`, דיילת טעימות בסופרמרקט `99`, ברוקר בבורסה `99`, אפשר לוותר גם על `99`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2603, N'F1813', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2604, N'F1814', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2605, N'F1815', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2606, N'F1816', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2607, N'F1817', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2608, N'F1818', 1, N'החיים שלי יפים כי `999`, וגם בגלל `999`', N'החיים שלי יפים כי `999`, וגם בגלל `999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2609, N'F1819', 1, N'אני פוחד שמחר בבוקר לפתע `999`', N'אני פוחדת שמחר בבוקר לפתע `999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2610, N'F1820', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2611, N'F1821', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2612, N'F1823', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2613, N'F1824', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2614, N'F1825', 1, N'להיות עשיר `99`, ללמוד דברים חדשים `99`, שיהיו לי חברים טובים שאפשר לסמוך עליהם `99`', N'להיות עשירה `99`, ללמוד דברים חדשים `99`, שיהיו לי חברים טובים שאפשר לסמוך עליהם `99`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2615, N'F1826', 1, N'לשמור על כושר גופני טוב `99`, לחלוק את חיי עם מישהי `99`, להתחטב כדי שיגידו לי תמיד שאני נראה מעולה `99`', N'לשמור על כושר גופני טוב `99`, לחלוק את חיי עם מישהו `99`, להתחטב כדי שיגידו לי תמיד שאני נראית מעולה `99`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2616, N'F1827', 1, N'`999`', N'`999`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2617, N'F1828', 1, N'אני מוכשר בהרבה דברים `99`, אני סנוב `99`, החיים שלי מדהימים `99`', N'אני מוכשרת בהרבה דברים `99`, אני סנובית `99`, החיים שלי מדהימים `99`');
INSERT `pwm`.`net_FillText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES (2618, N'F1829', 1, N'אין מצב שאני יוצא מהבית בלי להסתכל במראה קודם `99`, לפעמים אני מרגיש שאני כישלון `99`, אני נוהג לחלום בהקיץ `99`', N'אין מצב שאני יוצאת מהבית בלי להסתכל במראה קודם `99`, לפעמים אני מרגישת שאני כישלון `99`, אני נוהגת לחלום בהקיץ `99`');
 
INSERT `pwm`.`net_GameType` (`Id`, `Description`) VALUES (1, N'Introduction');
INSERT `pwm`.`net_GameType` (`Id`, `Description`) VALUES (2, N'familiarity');
INSERT `pwm`.`net_GameType` (`Id`, `Description`) VALUES (3, N'well known')

;
INSERT `pwm`.`net_Gender` (`Id`, `Name`) VALUES (1, N'Male');
INSERT `pwm`.`net_Gender` (`Id`, `Name`) VALUES (2, N'Female');
INSERT `pwm`.`net_Gender` (`Id`, `Name`) VALUES (3, N'Everyone');
INSERT `pwm`.`net_GeneratorParameters` (`Id`, `Name`, `Factor`, `BaseValue`) VALUES (1, N'Nearby', 20, 100);
INSERT `pwm`.`net_GeneratorParameters` (`Id`, `Name`, `Factor`, `BaseValue`) VALUES (2, N'Number Of Partners', 20, 60);
INSERT `pwm`.`net_GeneratorParameters` (`Id`, `Name`, `Factor`, `BaseValue`) VALUES (3, N'Hours since last action', 20, 100);
INSERT `pwm`.`net_GeneratorParameters` (`Id`, `Name`, `Factor`, `BaseValue`) VALUES (4, N'Number of played games', 20, 100);
INSERT `pwm`.`net_GeneratorParameters` (`Id`, `Name`, `Factor`, `BaseValue`) VALUES (5, N'Compensation', 20, 0);
INSERT `pwm`.`net_GeneratorParameters` (`Id`, `Name`, `Factor`, `BaseValue`) VALUES (6, N'Age similarity', 88, 100);

INSERT `pwm`.`net_GeographicalArea` (`Id`, `TitleEn`, `TitleHeb`, `MatchKey`) VALUES (1, N'All', N'הכל', N'all');
INSERT `pwm`.`net_GeographicalArea` (`Id`, `TitleEn`, `TitleHeb`, `MatchKey`) VALUES (2, N'Center', N'מרכז', N'center');
INSERT `pwm`.`net_GeographicalArea` (`Id`, `TitleEn`, `TitleHeb`, `MatchKey`) VALUES (3, N'Jerusalem', N'ירושלים', N'jerusalem');
INSERT `pwm`.`net_GeographicalArea` (`Id`, `TitleEn`, `TitleHeb`, `MatchKey`) VALUES (4, N'North', N'צפון', N'north');
INSERT `pwm`.`net_GeographicalArea` (`Id`, `TitleEn`, `TitleHeb`, `MatchKey`) VALUES (5, N'South', N'דרום', N'south');

INSERT `pwm`.`net_Image` (`Id`, `Caption`, `Description`, `ImageUrl`) VALUES (1, N'Desert.jpg', N'Desert.jpg', N'/pwm/Content/UserFiles/Upload/Images/Desert.jpg');
INSERT `pwm`.`net_Image` (`Id`, `Caption`, `Description`, `ImageUrl`) VALUES (2, N'1.png', N'1.png', N'/pwm/Content/UserFiles/Upload/Images/1.png');
INSERT `pwm`.`net_Image` (`Id`, `Caption`, `Description`, `ImageUrl`) VALUES (3, N'1.jpg', N'1.jpg', N'/Content/UserFiles/Upload/Images/1.jpg');
INSERT `pwm`.`net_Image` (`Id`, `Caption`, `Description`, `ImageUrl`) VALUES (4, N'101-F041-20160416073412405.jpg', N'101-F041-20160416073412405.jpg', N'/Content/UserFiles/Upload/Images/101-F041-20160416073412405.jpg');
INSERT `pwm`.`net_Image` (`Id`, `Caption`, `Description`, `ImageUrl`) VALUES (1004, N'hamburger-8.jpg', N'hamburger-8.jpg', N'/Content/UserFiles/Upload/Images/hamburger-8.jpg');
INSERT `pwm`.`net_Image` (`Id`, `Caption`, `Description`, `ImageUrl`) VALUES (1005, N'entertainment-perfect-first-dance-629.jpg', N'entertainment-perfect-first-dance-629.jpg', N'/Content/UserFiles/Upload/Images/entertainment-perfect-first-dance-629.jpg');
INSERT `pwm`.`net_Image` (`Id`, `Caption`, `Description`, `ImageUrl`) VALUES (1006, N'coffee.jpg', N'coffee.jpg', N'/Content/UserFiles/Upload/Images/coffee.jpg');

INSERT `pwm`.`net_Keywords` (`Id`, `Keyword`) VALUES (5, N'סמס');
INSERT `pwm`.`net_Keywords` (`Id`, `Keyword`) VALUES (6, N'במטבח');
INSERT `pwm`.`net_Keywords` (`Id`, `Keyword`) VALUES (7, N'KITCHEN');
INSERT `pwm`.`net_Keywords` (`Id`, `Keyword`) VALUES (8, N'משטרה');
INSERT `pwm`.`net_Keywords` (`Id`, `Keyword`) VALUES (9, N'עירום');
INSERT `pwm`.`net_Keywords` (`Id`, `Keyword`) VALUES (10, N'NUM');
INSERT `pwm`.`net_Keywords` (`Id`, `Keyword`) VALUES (11, N'מזל');

INSERT `pwm`.`net_Language` (`Id`, `Description`) VALUES (1, N'Hebrew');
INSERT `pwm`.`net_Language` (`Id`, `Description`) VALUES (2, N'English');
INSERT `pwm`.`net_Language` (`Id`, `Description`) VALUES (3, N'French');
INSERT `pwm`.`net_Language` (`Id`, `Description`) VALUES (4, N'Spanish');

INSERT `pwm`.`net_NewGameRules` (`Id`, `Brand`, `PairsGameNumber`, `PlayerMaxGameNumber`, `TaskNumberInGame`, `TaskWasNotUse`, `UniqueType`, `UniqueSubType`, `TaskType`, `MinScore`, `MaxScore`) VALUES (1, NULL, 2, 2, 5, N'2,1', N'1,1', NULL, N'0', 2, 8);
INSERT `pwm`.`net_NewGameRules` (`Id`, `Brand`, `PairsGameNumber`, `PlayerMaxGameNumber`, `TaskNumberInGame`, `TaskWasNotUse`, `UniqueType`, `UniqueSubType`, `TaskType`, `MinScore`, `MaxScore`) VALUES (4, NULL, 1, 1, 5, N'2,1', N'1,1', NULL, NULL, NULL, NULL);
 
INSERT `pwm`.`net_PairStatus` (`Id`, `Name`) VALUES (1, N'Playing');
INSERT `pwm`.`net_PairStatus` (`Id`, `Name`) VALUES (2, N'End');
INSERT `pwm`.`net_PairStatus` (`Id`, `Name`) VALUES (3, N'Disconnect');
INSERT `pwm`.`net_PairStatus` (`Id`, `Name`) VALUES (4, N'Offensive');
INSERT `pwm`.`net_Passion` (`PassionId`, `TitleEn`, `TitleHeb`) VALUES (27, N'Pineapple pizza', N'פיצה אננס');
INSERT `pwm`.`net_Passion` (`PassionId`, `TitleEn`, `TitleHeb`) VALUES (28, N'Collecting rubber ducks', N'איסוף ברווזי גומי');
INSERT `pwm`.`net_Passion` (`PassionId`, `TitleEn`, `TitleHeb`) VALUES (29, N'Gardening at night', N'גינון בלילה');
INSERT `pwm`.`net_Passion` (`PassionId`, `TitleEn`, `TitleHeb`) VALUES (30, N'Jumping in puddles', N'קפיצה בשלוליות');
INSERT `pwm`.`net_Passion` (`PassionId`, `TitleEn`, `TitleHeb`) VALUES (31, N'Imitation of singers', N'חיקוי זמרים');
INSERT `pwm`.`net_Passion` (`PassionId`, `TitleEn`, `TitleHeb`) VALUES (32, N'Cheese sculpture', N'פיסול גבינה');
INSERT `pwm`.`net_Passion` (`PassionId`, `TitleEn`, `TitleHeb`) VALUES (33, N'Emoji song', N'שירת אימוג''י');
INSERT `pwm`.`net_Passion` (`PassionId`, `TitleEn`, `TitleHeb`) VALUES (34, N'Arguments with yourself', N'ויכוחים עם עצמך');
INSERT `pwm`.`net_Passion` (`PassionId`, `TitleEn`, `TitleHeb`) VALUES (35, N'Fruit juggling', N'ג''אגלינג פירות');
INSERT `pwm`.`net_Passion` (`PassionId`, `TitleEn`, `TitleHeb`) VALUES (36, N'A trip to the bottom of the sea', N'טיול בקרקעית הים');
INSERT `pwm`.`net_Passion` (`PassionId`, `TitleEn`, `TitleHeb`) VALUES (37, N'Peeling sabers', N'קילוף סברס');
  
;
INSERT `pwm`.`net_Role` (`Id`, `Name`, `Description`) VALUES (1, N'Admin', N'Can perform all configuration and maintenance activities on the database');
INSERT `pwm`.`net_Role` (`Id`, `Name`, `Description`) VALUES (2, N'Registered', N'Player');
INSERT `pwm`.`net_Role` (`Id`, `Name`, `Description`) VALUES (3, N'Anonymous', N'Not registered')
;
INSERT `pwm`.`net_SexualOrientation` (`SexualOrientationId`, `TitleEn`, `TitleHeb`) VALUES (1, N'Straight', N'סטרייט');
INSERT `pwm`.`net_SexualOrientation` (`SexualOrientationId`, `TitleEn`, `TitleHeb`) VALUES (2, N'Gay', N'גיי');
INSERT `pwm`.`net_SexualOrientation` (`SexualOrientationId`, `TitleEn`, `TitleHeb`) VALUES (3, N'Lesbian', N'לסבית');
INSERT `pwm`.`net_SexualOrientation` (`SexualOrientationId`, `TitleEn`, `TitleHeb`) VALUES (4, N'Bisexual', N'דו');
INSERT `pwm`.`net_SexualOrientation` (`SexualOrientationId`, `TitleEn`, `TitleHeb`) VALUES (5, N'Asexual', N'א מיני');
INSERT `pwm`.`net_SysParam` (`Id`, `MaxOfPartners`, `AdminEmail`, `DisableEditingAvatar`, `RequirePhoneVerfication`, `AndroidInviteMessage`, `iOSInviteMessage`, `StaticPartnerDuration`, `StaticPartnerUnit`, `PartnerMatchingAgeUp`, `PartnerMatchingAgeDowm`, `LatestAppVersion`, `AgeRangeUpperLimit`, `AgeRangeLowerLimit`, `PlayButtonIdleTime`, `HobbiesListVisible`, `PlayNowMode`, `PlayNowMessageKey`, `DefaultRegisterUserState`) VALUES (1, 6, N'info@play-with-me.net', 0, 1, N'`name` invited you to play. Click `url` to start!', N'`name` invited you to play. Click `url` to start!', 4, N'hour', NULL, NULL, N'3.2.6', -1, -1, 10, 1, 3, N'play_now_message', 2);
 
INSERT `pwm`.`net_TaskAuthor` (`Id`, `AuthorName`) VALUES (1, N'author 1');
INSERT `pwm`.`net_TaskAuthor` (`Id`, `AuthorName`) VALUES (2, N'author 2');
INSERT `pwm`.`net_TaskAuthor` (`Id`, `AuthorName`) VALUES (3, N'author 3');

INSERT `pwm`.`net_TaskKeyword` (`Id`, `TaskId`, `KeywordId`) VALUES (15, N'Q0116', 5);
INSERT `pwm`.`net_TaskKeyword` (`Id`, `TaskId`, `KeywordId`) VALUES (16, N'Q0116', 7);
INSERT `pwm`.`net_TaskKeyword` (`Id`, `TaskId`, `KeywordId`) VALUES (22, N'F040', 7);
INSERT `pwm`.`net_TaskKeyword` (`Id`, `TaskId`, `KeywordId`) VALUES (23, N'Q0113', 10);
INSERT `pwm`.`net_TaskKeyword` (`Id`, `TaskId`, `KeywordId`) VALUES (26, N'T0023', 6);
INSERT `pwm`.`net_TaskKeyword` (`Id`, `TaskId`, `KeywordId`) VALUES (27, N'T0023', 11);
INSERT `pwm`.`net_TaskKeyword` (`Id`, `TaskId`, `KeywordId`) VALUES (28, N'F039', 8);
INSERT `pwm`.`net_TaskKeyword` (`Id`, `TaskId`, `KeywordId`) VALUES (29, N'F039', 9);
INSERT `pwm`.`net_TaskKeyword` (`Id`, `TaskId`, `KeywordId`) VALUES (32, N'Q0115', 5);

INSERT `pwm`.`net_TaskLike` (`Id`, `Name`, `ImagePath`, `IsActive`) VALUES (1, N'1', N'like.png', 1);
INSERT `pwm`.`net_TaskLike` (`Id`, `Name`, `ImagePath`, `IsActive`) VALUES (2, N'2', N'unlike.png', 1);

INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1725, N'-1', 1, 17, NULL, 3, N'איזו רמת יכולת ריכוז יש לך? עד כמה קל להסיח את דעתך?', 1, 1, 1, 23, 67, 5, 5, 5, 5, 5, 5, CAST(N'2024-07-27T04:57:37.860' AS DateTime), CAST(N'2024-07-27T04:57:37.857' AS DateTime), 7, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1660, N'F1001', 6, 91, NULL, 3, N'חשוב לי מה אחרים אומרים עלי `99`, אני מבקר את עצמי יותר מידי `99`, אני מדבר אל עצמי לפעמים `99`', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 4, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1661, N'F1002', 6, 91, NULL, 3, N'בשנה האחרונה הרגשתי בודד `99`, שתקתי רוב הזמן `99`, בכיתי הרבה `99`, אכלתי הרבה שוקולד `99`', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 4, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1267, N'F1003', 6, 52, NULL, 3, N'אני מביא שקיות מהבית כדי לא לבזבז שקיות חדשות מהסופרמרקט `99`, אני מדפיס מסמכים משני צידי הנייר במדפסת `99`, אני מתקלח מקלחת קצרה לחסוך במים `99`', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 4, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1268, N'F1004', 6, 52, NULL, 3, N'כל חודש אני שם כסף בצד `99`, אני יודע בדיוק כמה אני מבזבז בשבוע על מותרת `99`, אני משתדל לקנות בגדים בסיילים ובסופי עונה `99`', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 4, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1659, N'F1005', 6, 91, NULL, 3, N'אני יוזם ומארח אצלי מסיבות `99`, אני עובד על ביזנס משלי `99`, אני זה שיוזם יציאות עם החבר''ה `99`', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 4, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1104, N'F1006', 6, 42, NULL, 3, N'תאר\י במדויק את הלבוש שלך במסיבה האחרונה שרקדת בה', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 3, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1203, N'F1007', 6, 51, NULL, 3, N'בחתונה, האם אתם בקטע של לימוזינה ופאר, או משהו צנוע יותר?', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 3, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1436, N'F1008', 6, 75, NULL, 3, N'אם הצד השני מתלבט ביניכם לבין עוד מישהו\י, האם תנסי להתחרות, או שתוותרו מראש?', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 4, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1206, N'F1009', 6, 51, NULL, 3, N'באיזה אופן הכי קל לך להתבטא ולתקשר מול גבר\אישה שאת\ה לא מכיר\הה? ', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 3, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1437, N'F1010', 6, 75, NULL, 3, N'האם קרה לך שהכל נראה שחור בלילה, אבל בבבוקר היית הרבה יותר מעודד? אם כן, במה היה מדובר?', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 4, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1657, N'F1011', 6, 91, NULL, 3, N'האם אתה מסוגל להירדם תוך כדי התכבלות עם מישהי, או שאתה זקוק למרחב שלך?', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 4, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1658, N'F1012', 6, 91, NULL, 3, N'באיזה תחומים הזיכרון שלך הכי טוב? למשל, פרצופים, שמות, מספרים, זיכרון רגשי, וכו''...', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 3, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1269, N'F1014', 4, 4, NULL, 3, N'אילו אפליקציות אתה בודק בסלולרי דבר ראשון אחרי שאתה מתעורר בבוקר?', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2024-04-16T09:24:49.657' AS DateTime), 2, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1204, N'F1015', 6, 51, NULL, 3, N'האם אתה מרגיש טוב עם זה שהחברה שלך תצא לפגישות עם ידידים גברים אחד על אחד, רק שניהם, בערב?', 0, 1, 1, 18, 99, 5, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 4, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1270, N'F1016', 6, 52, NULL, 3, N'איך אתם ישינים? על הגב, על הבטן, על הצד? עם כמה כריות, וכמה פעמים אתם מתעוררים בלילה?', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 4, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1662, N'F1017', 6, 91, NULL, 3, N'אין לי בעיה לצחצח שיניים במברשת שלה `99`, אין לי בעיה לערבב איתה מנות במסעדה באותו הסכו"ם `99`, אין לי בעיה אם היא משתעלת על האוכל שלי `99`', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 5, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1287, N'F1018', 6, 59, NULL, 3, N'אילו שלושה מאכלים אין סיכוי שתאכל', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 3, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1288, N'F1022', 6, 59, NULL, 3, N'אני ממליץ לך לראות את הסרט `999`, ואת סדרת הטלוויזיה `999`', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 4, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1289, N'F1023', 6, 59, NULL, 3, N'אני ממליץ לך על הפאב\בר `999` כי הוא `999`, ועל המסעדה `999` בגלל `999`', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 4, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1205, N'F1024', 6, 51, NULL, 3, N'איזה דבר אחד יכול לעשות לך טרן אוף אצל אישה?', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 4, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1105, N'F1025', 6, 43, NULL, 3, N'איזה אדם שמעורב בחיים שלך אתה מעריץ בענק?', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 3, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1512, N'F1026', 6, 78, NULL, 3, N'מה הדבר הכי מצחיק שקרה לך אי פעם בדייט?', 0, 1, 1, 18, 99, 4, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 4, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1513, N'F1027', 6, 78, NULL, 3, N'מה הדבר הכי הזוי שקרה לך אי פעם בדייט?', 0, 1, 1, 18, 99, 4, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 4, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1290, N'F1029', 6, 59, NULL, 3, N'מהי המתנה הכי לא שווה ולא מתאימה שקיבלת? ', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 3, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1106, N'F1030', 6, 43, NULL, 3, N'אם היתה לך גישה ללא הגבלת זמן או כסף לחנות אחת. איזו חנות זו היתה? ', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 3, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1656, N'F1031', 6, 91, NULL, 3, N'איזה הרגל מעצבן יש לך, שמישהו או מישהי שחי לידך מספיק זמן היה מעיד עליו?', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 3, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1202, N'F1032', 6, 51, NULL, 3, N'אם יציעו לי אני אבחר להשתתף בתכנית הריאליטי `99`, להיות במאי של התכנית `99`, ולשמש בערוץ 2 ככתב לענייני `99`', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 3, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1107, N'F1033', 6, 43, NULL, 3, N'יש לך משימה להיות מיליונר תוך 5 שנים. מה התכנית שלך?', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 3, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1201, N'F1034', 6, 51, NULL, 3, N'איזה חוק שאינו קיים בספר החוקים, היית מחוקק בעצמך לו יכולת?', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 3, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1511, N'F1035', 6, 78, NULL, 3, N'מהו הדבר הכי מטופש שעשית אי פעם בחייך', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 3, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1109, N'F1036', 6, 43, NULL, 3, N'בגד ים צמוד או מכנסי גלישה? `99`, להשתזף על החול או לשחות בים? `99`, חוף מבודד, או חוף מוכרז? `99`', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 2, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1304, N'F1037', 6, 61, NULL, 3, N'מהו הדבר הכי מצחיק שקרה לך השבוע?', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 3, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1509, N'F1038', 6, 78, NULL, 3, N'מהו הטיפ הגבוה ביותר שהשראת למלצר\ית, ומה היה כל כך מיוחד?', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 2, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1108, N'F1039', 6, 43, NULL, 3, N'הרכב לך אישה עם 5 תכונות מהרשימה שלפניך, כשחייבות להופיע לפחות 2 תכונות שליליות: יפה, חכמה, אתלטית, עשירה, יודעת להקשיב, חייכנית עם גישה חיובית - מכוערת, טיפשה, בלי גרוש, לא קשובה, מרירה עם גישה שלילית', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 4, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1199, N'F1040', 6, 51, NULL, 3, N'ליטוף בעורף `99`, נשיקה בצוואר `99`, דגדוג בבטן `99`, לחיצות בכף הרגל `99`', 0, 1, 1, 18, 99, 4, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 2, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1200, N'F1041', 6, 51, NULL, 3, N'עם מי אתם מתייעצים בבחירת הבגדים התחתונים שלכם?', 0, 1, 1, 18, 99, 4, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 2, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1510, N'F1042', 6, 78, NULL, 3, N'רקדתי בגשם `99`, חניתי פעם באדום לבן `99`, הייתי מעורב בתאונת דרכים `99`', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 3, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1305, N'F1043', 6, 61, NULL, 3, N'מהי המחמאה הכי גדולה שמישהו נתן לך בזמן האחרון?', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 3, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1110, N'F1044', 6, 43, NULL, 3, N'אם תוכל להיות בכל גיל שתבחר למשך שבוע, מה תבחר ומה תעשה בשבוע הזה?', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 3, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1552, N'F1045', 6, 85, NULL, 3, N'מה עשית בדיוק לפני שעה?', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 3, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1553, N'F1046', 6, 85, NULL, 3, N'מהו הזמן הממושך ביותר בו לא ישנת, ומה היתה הסיבה?', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 4, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1197, N'F1047', 6, 51, NULL, 3, N'למה אתה מתגעגע?', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 2, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1198, N'F1048', 6, 51, NULL, 3, N'עד כמה מרתיעה אותך (או מושכת אותך) מישהי שבפוקוס חזק על הלוק שלה (שיער, בגדים, מוצרי טיפוח וכו''..) ', 0, 1, 1, 18, 99, 4, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 2, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1183, N'F1049', 6, 46, NULL, 3, N'להתאהב באמת זה `999`', 0, 1, 1, 18, 99, 4, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 3, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1655, N'F1050', 6, 91, NULL, 3, N'מתי בפעם האחרונה אמרו לך שאתה מטורף (או משוגע, או מחורפן), ולמה?', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 3, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1184, N'F1051', 6, 46, NULL, 3, N'מה אתה אומר על המשפט: "נשים אוהבות שגברים מתאמצים לכבוש אותן, כי הן לא אלא רוצה שהגבר יקבל שום דבר בחינם". ', 0, 1, 1, 18, 99, 5, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 2, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1185, N'F1052', 6, 46, NULL, 3, N'מה אתה אומר על המשפט: "גברים שמשחקים נכון את המשחק, יצליחו לכבוש יותר בחורות"', 0, 1, 1, 18, 99, 5, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 2, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1271, N'F1053', 6, 52, NULL, 3, N'אני בוחש את הקפה `99` סיבוב השעון, אני מוריד מכנסיים (בישיבה או עמידה) ב`99`, וכשאני מסיים להתקלח אני קודם כל מנגב את ה`99`', 0, 1, 1, 18, 99, 4, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 4, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1286, N'F1054', 6, 59, NULL, 3, N'חמאת בוטנים `99`, דבש `99`, טחינה `99`, ריבה `99`', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 3, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1103, N'F1159', 6, 41, NULL, 3, N'בא לי לפנק את עצמי', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 4, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1097, N'F1160', 6, 38, NULL, 3, N'אף פעם לא יצאתי עם אישה ', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 3, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1098, N'F1161', 6, 38, NULL, 3, N'אף פעם לא סיפרתי להורים שלי', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 3, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1531, N'F1162', 6, 79, NULL, 3, N'בכושר גופני אני זורם בכיף עד שזה מגיע ל', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 4, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1532, N'F1163', 6, 79, NULL, 3, N'בטיולים בחיק הטבע אני זורם בכיף עד שזה מגיע', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 4, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1533, N'F1164', 6, 79, NULL, 3, N'אני אוהב לבלות בחוף הים עד שזה מגיע ל', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 1, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1096, N'F1165', 6, 38, NULL, 3, N'אף פעם לא אכלתי', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 3, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1514, N'F1168', 6, 78, NULL, 3, N'תכניות טלוויזיה שאהבת בתור ילד', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 2, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1515, N'F1169', 6, 78, NULL, 3, N'מקצועות שהצטיינת בתיכון', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 4, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1516, N'F1170', 6, 78, NULL, 3, N'הערצת סלב כילד', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 2, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1517, N'F1171', 6, 78, NULL, 3, N'ספרו על מחווה מרגשת שמישהו עשה עבורכם בחודש האחרון', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 3, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1377, N'F1172', 6, 70, NULL, 3, N'זכית ב 50 מיליון בלוטו 1', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 4, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1378, N'F1173', 6, 70, NULL, 3, N'זכית ב 50 מיליון בלוטו 2', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 5, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1379, N'F1174', 6, 70, NULL, 3, N'זכית ב 50 מיליון בלוטו 3', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 3, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1380, N'F1175', 6, 70, NULL, 3, N'מי יופיע בחתונה שלך?', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 2, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1381, N'F1176', 6, 70, NULL, 3, N'עם מי תרצה להיתקע במעלית?', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 4, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1382, N'F1177', 6, 70, NULL, 3, N'עם מי בא לך לשתות עכשיו קפה?', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 4, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1540, N'F1180', 6, 83, NULL, 3, N'הצליל שהכי מעצבן אותי', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 2, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1541, N'F1182', 6, 83, NULL, 3, N'איך אתה מרגיע את עצמך כשמעצבנים אותך?', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 4, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1036, N'F1183', 6, 33, NULL, 3, N'איזו מנה עיקרית אתה הכי אוהב לאכול?', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 3, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1037, N'F1184', 6, 33, NULL, 3, N'איזה קינוח בא לך עכשיו?', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 3, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1611, N'F1190', 6, 88, NULL, 3, N'מה היתה הפעם האחרונה שבכית? למה?', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 4, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1375, N'F1195', 6, 70, NULL, 3, N'איזה מפורסם היית רוצה להיות?', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 1, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1376, N'F1196', 6, 70, NULL, 3, N'איזו דמות מסרט היית רוצה להיות?', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 1, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1029, N'F1197', 6, 31, NULL, 3, N'יצאת עם מישהי נחמדה, אבל אתה מרגיש שזה לא זה. כתוב לה SMS בו אתה מודיע שאתה לא מעוניין, אבל בו זמנית אתה חייב להחמיא לה ולהעלות לה את הביטחון העצמי', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 2, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1030, N'F1198', 6, 31, NULL, 3, N'להחמיא ב-SMS בלי להיות ישיר', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 4, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1031, N'F1199', 6, 31, NULL, 3, N'תירוצים על מבט במלצרית', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 5, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1285, N'F1204', 6, 56, NULL, 3, N'האם יש החלטה שלקחתם אתמול שהתחטרתם עליה? ', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 1, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1539, N'F1205', 6, 82, NULL, 3, N'את מי בא לך לחבק כשאתה עצוב?', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 3, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1100, N'F1206', 6, 40, NULL, 3, N'להכין ארוחת ערב רומנטית - אוכל', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 5, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1101, N'F1207', 6, 40, NULL, 3, N'להכין ארוחת ערב רומנטית - אווירה', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 5, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1042, N'F1209', 6, 33, NULL, 3, N'נניח שיש לך אספקה בלתי מוגבלת של אוכל מסוג אחד, מה תבחר?', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 3, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1367, N'F1212', 6, 67, NULL, 3, N'אוהב בחורות מאופרות בקפידה?', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 2, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1368, N'F1213', 6, 67, NULL, 3, N'בגדים צמודים', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 3, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1369, N'F1214', 6, 67, NULL, 3, N'גובה או משקל', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 3, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1370, N'F1215', 6, 67, NULL, 3, N'שכל חיטוב', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 3, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1488, N'F1216', 6, 76, NULL, 3, N'מחמאות סרק', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 3, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1489, N'F1217', 6, 76, NULL, 3, N'לאחר לפגישות', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 2, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1534, N'F1226', 6, 81, NULL, 3, N'מה העונש לאנשים שמשוויצים בהרבה חברים בפייסבוק, ועסוקים בסמאטפון באמצע פגישה. ', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 4, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1535, N'F1227', 6, 81, NULL, 3, N'מה העונש לאנשים שמלווים ולא מחזירים, ומפרסמים בפייסבוק רק דברים מחמיאים על עצמם', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 4, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1536, N'F1228', 6, 81, NULL, 3, N'מה העונש לנהג שזורק קופסת סיגריות ו נהג שצופר חצי שעה לחבר שלו', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 4, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1537, N'F1229', 6, 81, NULL, 3, N'מה העונש לנהג שחונה חניה כפולה ועונה "מה אתה ממהר", ולנהג שנוסע לאט במסלול שמאלי', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 4, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1538, N'F1230', 6, 81, NULL, 3, N'מה העונש לנהג שחונה החניית נכה, ולנהג שעוקף את כולם בתור בפניה ימינה ונדחף ברגע האחרון. ', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 4, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1191, N'F1231', 6, 50, NULL, 3, N'מה אתה עושה כשאתה רואה ג''וק?', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 3, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1192, N'F1232', 6, 50, NULL, 3, N'הכיור עולה על גדותיו בגלל סתימה. תתקנו לבד?', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 3, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1193, N'F1233', 6, 50, NULL, 3, N'אופס, באמצע נסיעה, פנצ''ר. תתקן לבד? ', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 2, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1194, N'F1234', 6, 50, NULL, 3, N'הכפתור בחולצה נתלש', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 3, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1195, N'F1235', 6, 50, NULL, 3, N'צריך לתלות תמונה', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 2, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1196, N'F1236', 6, 50, NULL, 3, N'המחשב מקרטע', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 2, 1, NULL)
;
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1301, N'F1237', 6, 60, NULL, 3, N'יודע להכין פסטה ברוטב, סטייק, שניצל. ', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 4, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1302, N'F1238', 6, 60, NULL, 3, N'יודע להכין עוגה, סלט פירות, טירמיסו', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 4, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1303, N'F1239', 6, 60, NULL, 3, N'יודע להכין מרק עדשים, לטגן כרוביות, שקשוקה מהממת. ', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 4, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1443, N'F1240', 6, 75, NULL, 3, N'האם יכול להיות שתגיד "אני אוהב אותך" אחרי 3 ימים?', 0, 1, 1, 18, 99, 4, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 4, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1444, N'F1241', 6, 75, NULL, 3, N'מה תגיד אם היא מסמסת לך כל 10 דקות?', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 4, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1445, N'F1242', 6, 75, NULL, 3, N'לפגוש את ההורים אחרי חודש היכרות', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 4, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1446, N'F1243', 6, 75, NULL, 3, N'להתנשק בפומבי', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 4, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1447, N'F1244', 6, 75, NULL, 3, N'להחזיק ידיים ברחוב ', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 3, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1022, N'F1245', 6, 31, NULL, 3, N'להיפרד ב SMS, שופכת עלי, משגעת אותי, רואה כל הזמן....', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 4, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1023, N'F1246', 6, 31, NULL, 3, N'להיפרד ב SMS, בהודעה חייבת להופיע המילה - קטן\גדול', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 4, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1024, N'F1247', 6, 31, NULL, 3, N'SMS פרידה, כשבהודעה מילים בנות שתי אותיות בלבד', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 2, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1025, N'F1248', 6, 31, NULL, 3, N'SMS במטרה שהאקס יזמין אותך, מבלי להיראות להוטה', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 4, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1609, N'F1249', 6, 86, NULL, 3, N'כתוב קללה שאתה מחבב במיוחד', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 2, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1450, N'F1250', 6, 75, NULL, 3, N'האם בחורה בחרה עבורך פעם בגדים בחנות?', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 2, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1272, N'F1251', 6, 52, NULL, 3, N'כמה זוגות נעליים יש לך בטוטאל?', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 4, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1441, N'F1252', 6, 75, NULL, 3, N'כמה זמן לוקח לך לבחור בגדים בבוקר לצאת איתם מהבית?', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 3, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1442, N'F1253', 6, 75, NULL, 3, N'לקנות בגד חדש במיוחד לאירוע', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 3, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1026, N'F1254', 6, 31, NULL, 3, N'SMS שזה לא ילך תוך שימוש במושגים מעולם הרפואה\כדורגל', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 4, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1027, N'F1255', 6, 31, NULL, 3, N'החברה בגדה, סרב לה, תוך שאתה משתמש במונחים מעולם המוסיקה', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 4, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1448, N'F1256', 6, 75, NULL, 3, N'מכריחים אותך להתחתן עם מישהו מתחום החדשות', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 3, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1273, N'F1257', 6, 52, NULL, 3, N'איך אתה אוהב לעשות כושר?', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 2, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1274, N'F1258', 6, 52, NULL, 3, N'האם קרה לך שהיית עצבני ואיבדת את זה לגמרי? אם כן, מה עיצבן אותך?', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 3, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1275, N'F1259', 6, 52, NULL, 3, N'אתה לא נרדם בלילה, איך אתה מעביר את הזמן?', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 4, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1276, N'F1260', 6, 52, NULL, 3, N'מה תנשנש במצב רוח רע?', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 4, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1438, N'F1261', 6, 75, NULL, 3, N'את מי תרצה להכיר - נסיכה, מדענית פיסיקה, פירסומאית', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 2, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1439, N'F1262', 6, 75, NULL, 3, N'מה לא כדאי לגבר להגיד בדייט ראשון איתך?', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 4, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1440, N'F1263', 6, 75, NULL, 3, N'אם היא מתלהבת ממך מייד', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 4, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1179, N'F1264', 6, 46, NULL, 3, N'אחרי כמה זמן לצפות לבלעדיות בקשר?', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 5, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1180, N'F1265', 6, 46, NULL, 3, N'תסכים לצאת לשני דייטים במקביל?', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 5, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1181, N'F1266', 6, 46, NULL, 3, N'האם תסכים אם תדע שהיא קבעה דייט נוסף אחריך?', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 5, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1182, N'F1267', 6, 46, NULL, 3, N'דייט איכותי? הופעה, לנקות דירה, להתעמל ביחד', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 4, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1092, N'F1268', 6, 36, NULL, 3, N'לאיזו תקופה היית רוצה לנסוע במנהרת זמן?', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 2, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1093, N'F1269', 6, 36, NULL, 3, N'למחוק רגע מהעבר', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 2, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1094, N'F1270', 6, 36, NULL, 3, N'לשחזר רגע מהעבר', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 2, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1095, N'F1271', 6, 36, NULL, 3, N'לבלות עם כוכבת קולנוע', 0, 1, 1, 18, 99, 4, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 2, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1452, N'F1272', 6, 75, NULL, 3, N'להיות זבוב על הקיר', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 2, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1478, N'F1273', 6, 76, NULL, 3, N'איזה מספר אתה אם 1 זה הכי זרוק ו-10 זה הכי מקפיד בלבוש?', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 3, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1479, N'F1274', 6, 76, NULL, 3, N'איזה מספר אתה אם 1 זה הכי הכי אוהב להיות בבית ו-10 זה בליין? ', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 3, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1480, N'F1275', 6, 76, NULL, 3, N'איזה מספר אתה אם 1 זה הכי פחדן ו-10 זה הכי אמיץ? ', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 3, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1481, N'F1276', 6, 76, NULL, 3, N'איזה מספר אתה אם 1 זה הכי מתבודד ו-10 זה הכי חברותי?', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 3, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1482, N'F1277', 6, 76, NULL, 3, N'איזה מספר אתה אם 1 זה הכי ריאליסטי ו-10 זה הכי פנטזיונר?', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 3, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1483, N'F1278', 6, 76, NULL, 3, N'איזה מספר אתה אם 1 זה הכי פסימי ו-10 זה הכי אופטימי?', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 3, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1484, N'F1279', 6, 76, NULL, 3, N'איזה מספר אתה אם 1 זה הכי מתוכנן ו-10 זה הכי ספונטני?', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 3, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1485, N'F1280', 6, 76, NULL, 3, N'איזה מספר אתה אם 1 זה הכי קשוח ו-10 זה הכי בוכה בסרטים?', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 3, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1486, N'F1281', 6, 76, NULL, 3, N'איזה מספר אתה אם 1 זה הכי לא יכול להתחייב ו-10 זה הכי אוהב מערכות יחסים?', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 3, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1487, N'F1282', 6, 76, NULL, 3, N'איזה מספר אתה אם 1 זה הכי עקשן ו-10 זה הכי מוותר וזורם?', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 3, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1291, N'F1283', 6, 59, NULL, 3, N'איזה משקה אתה אוהב לשתות בפאב?', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 3, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1292, N'F1284', 6, 59, NULL, 3, N'שיר שאתה אוהב בפאב', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 3, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1293, N'F1285', 6, 59, NULL, 3, N'איזה דייט יותר איכותי בעיניך? פאב, בית קפה, או ספסל בפארק? ', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 3, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1451, N'F1286', 6, 75, NULL, 3, N'להשתכר בפאב', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 3, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1294, N'F1287', 6, 59, NULL, 3, N'איזו בירה אתה שותה?', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 3, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1295, N'F1288', 6, 59, NULL, 3, N'זאנר סרטים אקסטרימי שאתם אוהבים', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 3, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1102, N'F1289', 6, 41, NULL, 3, N'לאיזה מקום בעולם הכי בא לך לנסוע עכשיו?', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 2, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1028, N'F1290', 6, 31, NULL, 3, N'להיפרד בSMS את תמיד, ואת אף פעם', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 3, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1038, N'F1291', 6, 33, NULL, 3, N'איזה אוכל אתה אלוף בלהכין?', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 3, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1113, N'F1292', 6, 43, NULL, 3, N'חכם, חטוב, או מפורסם?', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 4, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1556, N'F1293', 6, 85, NULL, 3, N'ממי קיבלת מסאז אחרון?', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 2, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1111, N'F1294', 6, 43, NULL, 3, N'את מי תיקח איתך לאי בודד?', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 2, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1554, N'F1295', 6, 85, NULL, 3, N'לראות סרט באולם קולנוע לבד זה `99`, לטייל בחוץ לארץ לבד זה `99`, ללמוד לבחינות לבד זה `99`', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 4, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1039, N'F1297', 6, 33, NULL, 3, N'יודעים להכין חביתה, עוף, ירקות מוקפצים', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 3, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1040, N'F1298', 6, 33, NULL, 3, N'יודעים להכין עוגת דבש, סלט פירות, טירמיסו, פנקייק', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 3, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1041, N'F1299', 6, 33, NULL, 3, N'יודעים להכין שיפודים במנגל, מרק ירקות, טוסט, שניצל', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 3, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1112, N'F1300', 6, 43, NULL, 3, N'שפשפת מנורה, איזה מפורסם היית רוצה להיות?', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 2, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1449, N'F1302', 6, 75, NULL, 3, N'פרצה שריפה בבית - מה תצילו?', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 4, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1555, N'F1304', 6, 85, NULL, 3, N'באיזה תחום אתה יכול ללמד שיעור פרטי?', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 3, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1084, N'F1305', 6, 35, NULL, 3, N'האם יש לך קעקוע, איפה ואיזה?', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 2, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1085, N'F1307', 6, 35, NULL, 3, N'כינוי או שם חיבה שנוהגים לכנות אותך', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 3, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1086, N'F1308', 6, 35, NULL, 3, N'איך אתה מזיז את הגוף כדי לא להיות בטטה', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 3, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1087, N'F1309', 6, 35, NULL, 3, N'באיזה צד של המיטה אתה ישן?', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 2, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1574, N'F1310', 6, 85, NULL, 3, N'כתוב 3 תחפושות שהתחפשת בפורים בעבר, ומה היתה התחפושת הכי שווה מהן אי פעם? ', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 2, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1126, N'F1311', 6, 43, NULL, 3, N'באיזה כלי נגינה היית רוצה לדעת לנגן?', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 2, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1127, N'F1312', 6, 43, NULL, 3, N'במה לבחור מבין מיץ תפוחים, תפוזים, סודה, או קולה', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 3, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1079, N'F1313', 6, 35, NULL, 3, N'איך אתם בבקרים \ בלילות?', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 2, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1080, N'F1314', 6, 35, NULL, 3, N'איך אתם שותים את הקפה\תה שלכם', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 2, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1081, N'F1315', 6, 35, NULL, 3, N'אם אני שומע את הזמר___, אני תולש את השערות', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 3, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1082, N'F1316', 6, 35, NULL, 3, N'כמה זמן ביום אתה מבלה בפייסבוק?', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 1, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1083, N'F1317', 6, 35, NULL, 3, N'הנשיקה הראשונה היתה עם, במקום ___, בגיל ___', 0, 1, 1, 18, 99, 4, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 4, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1575, N'F1318', 6, 85, NULL, 3, N'מה המסעדה הכי טובה, ומה אכלת שם', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 3, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1576, N'F1321', 6, 85, NULL, 3, N'באיזה גיל עשית רישיון נהיגה, וכמה טסטים לקח לך לעבור?', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 2, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1577, N'F1322', 6, 85, NULL, 3, N'באיזה ספורט אתה אוהב לצפות בטלוויזיה, עם מי?', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 2, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1578, N'F1323', 6, 85, NULL, 3, N'מה אכלת הבוקר?', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 4, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1579, N'F1324', 6, 85, NULL, 3, N'מה אתה מסבן ראשון במקלחת?', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 3, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1463, N'F1325', 6, 75, NULL, 3, N'נניח שיתפסו אותך לוטש עיניים במישהי, באיזה חלק של הגוף שלה תביט?', 0, 1, 1, 18, 99, 4, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 3, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1128, N'F1326', 6, 43, NULL, 3, N'איזה חשבון אתם הכי שונאים לשלם?', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 2, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1466, N'F1327', 6, 75, NULL, 3, N'חלון או מעבר, ואיך אתה מעביר את הזמן בטיסות?', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 3, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1129, N'F1328', 6, 43, NULL, 3, N'איזה אתר אינטרנט אתם אוהבים לגלוש, גם לחדשות וגם לסתם... ', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 2, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1462, N'F1329', 6, 75, NULL, 3, N'איזה יום היה לך אתמול, ומה נראה לך שיהיה מחר? ', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 3, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1572, N'F1330', 6, 85, NULL, 3, N'ספר על חפץ שלך, בעלך ערך משמעותי ומיוחד עבורך', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 3, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1573, N'F1331', 6, 85, NULL, 3, N'בים אני בדרך כלל מבלה ב--- ונשאר שם ___ זמן', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 2, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1506, N'F1332', 6, 78, NULL, 3, N'מאכל מיוחד שאמא הכינה', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 2, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1477, N'F1333', 6, 76, NULL, 3, N'איזה מספר אתה אם 1 מופנים, 10 מוחצן', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 2, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1505, N'F1334', 6, 78, NULL, 3, N'מאכל דוחה במיוחד שיצא לכם לאכול בעבר', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 1, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1571, N'F1335', 6, 85, NULL, 3, N'איזה סיגנון אתם הכי אוהבים לרקוד?', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 2, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1507, N'F1336', 6, 78, NULL, 3, N'איזה סרט הכי אהבת כשהיית ילד?', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 2, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1562, N'F1337', 6, 85, NULL, 3, N'מהי ההופעה האחרונה שראית ומתי?', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 3, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1563, N'F1338', 6, 85, NULL, 3, N'איזה מזל אתה והאם אתה מאמין באסטרולוגיה?', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 2, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1464, N'F1339', 6, 75, NULL, 3, N'אם היתה אולימפיאדה בענף `99`, אני יכול להתחרות שם בכבוד', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 3, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1565, N'F1340', 6, 85, NULL, 3, N'ציון הכי גבוה, וציון הכי נמוך באיזה מקצועות?', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 4, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1566, N'F1341', 6, 85, NULL, 3, N'האם אתם אוספים משהו? (בולים..) ', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 2, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1567, N'F1342', 6, 85, NULL, 3, N'איך אתם עם פאזלים', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 2, 1, NULL)
;
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1568, N'F1343', 6, 85, NULL, 3, N'איך בילת את השבת האחרונה?', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 4, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1569, N'F1344', 6, 85, NULL, 3, N'כמה חברים הכי טובים יש לך? ', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 3, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1570, N'F1345', 6, 85, NULL, 3, N'ספר שקראת שהרשים אותך מאוד', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 2, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1508, N'F1346', 6, 78, NULL, 3, N'העבודה הכי ביזארית שעבדת בעבר', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 3, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1465, N'F1347', 6, 75, NULL, 3, N'כשאתם עם חבר''ה, אתם במרכז או בצד?', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 3, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1564, N'F1348', 6, 85, NULL, 3, N'האם יצא לך להופיע\להרצות מול קבוצה גדולה של אנשים?', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 3, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1458, N'F1349', 6, 75, NULL, 3, N'בערב אחרי יום עבודה מתיש, איזה בילוי הכי מתחשק לך? ', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 4, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1116, N'F1350', 6, 43, NULL, 3, N'איזו עונה אתם הכי אוהבים? למה?', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 2, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1117, N'F1351', 6, 43, NULL, 3, N'חשוב לי שהחברה שלי תרגש אותי `99`, חשוב לי שהיא תצחיק אותי `99`, חשוב לי שהיא תפנק אותי `99`', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 4, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1558, N'F1352', 6, 85, NULL, 3, N'ממה אתם הכי נעלבים?', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 3, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1559, N'F1353', 6, 85, NULL, 3, N'ספר על משהו אחד שאתה מאושר ממנו בחייך כיום', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 4, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1118, N'F1354', 6, 43, NULL, 3, N'איפה לגור? דירת פנטהאוז עם נוף מדהים לים, או בית עם גינה?', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 2, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1119, N'F1355', 6, 43, NULL, 3, N'מה בעבודה שלך אתה הכי אוהב?', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 3, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1120, N'F1356', 6, 43, NULL, 3, N'איזה סרט שאתה אוהב יצא לך לראות הרבה פעמים ואין לך בעיה לצפות בו שוב?', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 2, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1461, N'F1357', 6, 75, NULL, 3, N'נניח שבחורה תבחר בך לפי שיר שתשמיע לה מהנגן שלך. איזה שיר תשים?', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 3, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1121, N'F1358', 6, 43, NULL, 3, N'כשאתה בחו"ל אתה בעניין של תרבות ואמנות, או בעניין של בילויים והופעות?', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 2, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1122, N'F1359', 6, 43, NULL, 3, N'להתחתן עם פוליטיקאי, עם פרופסור למתמטיקה', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 2, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1459, N'F1360', 6, 75, NULL, 3, N'להיות בן זוג של שחקנית שמצטלמת לסצינות סקס', 0, 1, 1, 18, 99, 4, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 3, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1460, N'F1361', 6, 75, NULL, 3, N'להתחתן עם עורך דין, מישהו שמתנדב באפריקה', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 2, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1123, N'F1362', 6, 43, NULL, 3, N'ספר או סרט, חומוסיה או איטלקית, מזרחית או רוקנרול', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 2, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1124, N'F1363', 6, 43, NULL, 3, N'שיר לועזרי או עברית, או פניים חשמליים או רגילים, נס או שחור בבוקר', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 2, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1125, N'F1364', 6, 43, NULL, 3, N'לישון בפיג''מה או בעירום, רגליים ארוכות או חיוך מקסים, קומדיה רומנטית או סרט אקשן', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 4, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1560, N'F1369', 6, 85, NULL, 3, N'מה יש לך בכיסים עכשיו?', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 3, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1561, N'F1370', 6, 85, NULL, 3, N'מה אתה לובש עכשיו?', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 4, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1115, N'F1371', 6, 43, NULL, 3, N'איזו חובת תחזוקת בית אתה הכי שונא לעשות?', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 3, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1557, N'F1372', 6, 85, NULL, 3, N'האם אתם שמים לעצמכם גבול כשאתם שותים אלכוהול בבילוי בערב?', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 2, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1454, N'F1373', 6, 75, NULL, 3, N'אם תשתתף בחידון, באיזה נושא היית זוכה מקום ראשון?', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 3, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1088, N'F1374', 6, 35, NULL, 3, N'איזה הרגל של אחד החברים שלך מטריף לך את השכל?', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 3, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1457, N'F1376', 6, 75, NULL, 3, N'אם הבוס שלי יבקש ממני `99`, אין סיכוי בעולם שאסכים. ', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 4, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1296, N'F1377', 6, 59, NULL, 3, N'איזה שיר רומנטי\קיטשי אתה הכי אוהב?', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 3, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1456, N'F1378', 6, 75, NULL, 3, N'אם אתה יוצא לדייט בקולנוע, האם אתה נבוך כשמקרינים סצינת סקס?', 0, 1, 1, 18, 99, 4, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 2, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1089, N'F1379', 6, 35, NULL, 3, N'האם יש מאכל שאתה אוהב לאכול במיטה?', 0, 1, 1, 18, 99, 4, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 3, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1455, N'F1380', 6, 75, NULL, 3, N'אם יגידו לך שאתה דומה למישהו מפורסם, למי אתה דומה?', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 1, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1114, N'F1381', 6, 43, NULL, 3, N'איזה סוג מסאז'' אתם הכי אוהבים?', 0, 1, 1, 18, 99, 4, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 1, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1090, N'F1382', 6, 35, NULL, 3, N'האם יצא לך לטייל לפחות כמה ימים לבד לבד? אם כן, באיזו סיטואציה?', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 3, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1297, N'F1383', 6, 59, NULL, 3, N'האם אתה אוהב להירדם עם מוסיקה? אם כן, איזה סוג?', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 4, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1091, N'F1384', 6, 35, NULL, 3, N'אילו תחתונים יש לכם במגירה? (השלמת טקסט) ', 0, 1, 1, 18, 99, 4, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 3, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1453, N'F1385', 6, 75, NULL, 3, N'מה יעשה אותך מאושר יותר בזה הרגע?', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 3, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1153, N'F1386', 6, 43, NULL, 3, N'עד כמה חשוב, קרם, פייסבוק, רמקולים, כנות', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 4, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1599, N'F1387', 6, 85, NULL, 3, N'באיזה גיל שתית לראשונה אלכוהול? איזה משקה זה היה? ', 0, 1, 1, 18, 99, 4, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 4, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1600, N'F1388', 6, 85, NULL, 3, N'ספר על משהו חשוב אחד, שכל מי שמכיר אותך אפילו קצת, בטוח יודע עליך. ', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 4, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1151, N'F1389', 6, 43, NULL, 3, N'מה אתם רוצים להיות כשתהיו "גדולים"?', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 2, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1060, N'F1390', 6, 35, NULL, 3, N'האם יש לך פוביה כלשהי? מהי?', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 4, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1407, N'F1391', 6, 75, NULL, 3, N'היית רוצה להיות מפורסם? באיזה תחום?', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 3, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1408, N'F1392', 6, 75, NULL, 3, N'כשאתה מחייג, האם יוצא לך לעשות חזרות בראש על מה שאתה הולך להגיד? ', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 2, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1061, N'F1393', 6, 35, NULL, 3, N'האם אתה שר במקלחת? איזה שיר שרת לעצמךלאחרונה?', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 3, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1601, N'F1394', 6, 85, NULL, 3, N'האם יצא לך לשיר בפני קהל? באיזו סיטואציה?', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 4, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1371, N'F1395', 6, 68, NULL, 3, N'מה עדיף? שיהיה לה גוף מדהים, אבל טיפשה במיוחד, או גוף ממוצע, וחכמה במיוחד?', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 4, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1372, N'F1396', 6, 68, NULL, 3, N'מה עדיף? חיוך מיליון דולר אבל צחוק מעצבן, או חיוך עקום אבל צחוק מקסים ומדבק?', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 3, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1063, N'F1397', 6, 35, NULL, 3, N'עד כמה חשוב לך שהיא תהיה בנאדם רגיש לאחרים?', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 3, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1373, N'F1398', 6, 68, NULL, 3, N'מה עדיף? יפיפיה ומתחילים איתה, או ממוצעת וכך אין לה פיתויים?', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 4, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1402, N'F1399', 6, 75, NULL, 3, N'האם אתם מאמינים שיש דבר כזה "נפש תאומה"?', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 3, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1062, N'F1400', 6, 35, NULL, 3, N'ספרו על תכונה אחת שבה אתם דומים לאבא\אמא', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 3, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1403, N'F1403', 6, 75, NULL, 3, N'העתיקו לכאן הודעה כלשהי שכתבתם, שמייצגת את מצב הרוח שלכם היום', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 3, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1404, N'F1404', 6, 75, NULL, 3, N'עד כמה זה נכון, שאפשר להתאהב באדם יותר בזמן שהוא מפגין חולשה ופגיעות? ', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 2, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1405, N'F1405', 6, 75, NULL, 3, N'אם פוגעים בך מאוד בחוסר צדק משווע, האם אתה נוטה לפגוע בחזרה?', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 3, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1406, N'F1406', 6, 75, NULL, 3, N'אם היה לך כדור בדולח שיודע הכל על החיים, על העתיד על הכל... מה היית רוצה לדעת?', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 4, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1064, N'F1407', 6, 35, NULL, 3, N'כמה אתה זוכר את החלומות שלך?', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 3, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1602, N'F1408', 6, 85, NULL, 3, N'ספר על הישג שאתה גאה בו מהתקופה האחרונה', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 4, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1409, N'F1409', 6, 75, NULL, 3, N'החבר\ה הכי טוב\ה מבקש\ת עזרה כספית, האם תסכימו?', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 4, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1410, N'F1410', 6, 75, NULL, 3, N'האם אתה נוהג לקנות באינטרנט? כמה קניות עשית בשנה האחרונה למשל?', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 3, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1065, N'F1411', 6, 35, NULL, 3, N'ספר על זיכרון נעים מהשנים האחרונות', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 3, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1415, N'F1415', 6, 75, NULL, 3, N'איזה עצה בנושא דייטים תיתן לעצמך הצעיר יותר, מהניסיון שלך כיום? ', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 4, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1416, N'F1416', 6, 75, NULL, 3, N'מה זה עושה לך אם בחורה מסמיקה בגללך?', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 3, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1417, N'F1417', 6, 75, NULL, 3, N'אחרי דייט, כמה פעמים תסמס לה עד שתחליט לוותר, אם היא לא עונה?', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 4, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1495, N'F1418', 6, 78, NULL, 3, N'קרה שאחרים לא הבינו אותך נכון? אם כן, באיזה עניין?', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 2, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1152, N'F1419', 6, 43, NULL, 3, N'מה בא לך לחלוק?', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 4, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1411, N'F1420', 6, 75, NULL, 3, N'איך תציג את עצמך בתחילת פגישת עבודה עם אנשים שאתה לא מכיר?', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 3, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1412, N'F1421', 6, 75, NULL, 3, N'חבר שלך מפגיש אותך עם חבר''ה שלו שאינך מכיר. איך תציג את עצמך בפניהם? ', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 4, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1413, N'F1422', 6, 75, NULL, 3, N'נניח שהוזמנת למפגש מחזור של התיכון שלך. כתבו משפט קצר שבזכותו כולם יזהו מייד מי אתם. ', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 4, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1414, N'F1423', 6, 75, NULL, 3, N'מארגנים תחרות כישרונות, ומותר להתחרות בכל תחום שקיים בעולם. במה תבקש להתחרות?', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 3, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1066, N'F1424', 6, 35, NULL, 3, N'איזה בגד הכי מחמיא לך? ', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 3, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1178, N'F1425', 6, 46, NULL, 3, N'כמה זמן מותר לאחר לדייט, מבלי שזה נחשב איחור?', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 2, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1597, N'F1426', 6, 85, NULL, 3, N'מהו הזמן הארוך ביותר שנסעת רצוף במכונית? באיזו סיטואציה זה קרה?', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 3, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1277, N'F1427', 6, 53, NULL, 3, N'מה הדבר המוזר ביותר שאכלת אי פעם בחופשה?', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 2, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1278, N'F1428', 6, 53, NULL, 3, N'איפה היתה החופשה הגרועה ביותר שהיתה לך? למה היא היתה כל כך גרועה?', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 3, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1279, N'F1429', 6, 53, NULL, 3, N'איפה היתה החופשה הטובה ביותר שהיתה לך? מה עשה אותה כל כך טובה?', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 2, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1280, N'F1431', 6, 53, NULL, 3, N'באילו ארצות כבר ביקרת? יאללה לשפוך... ', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 4, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1598, N'F1432', 6, 85, NULL, 3, N'איפה אתה נמצא עכשיו ולמה?', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 4, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1490, N'F1433', 6, 77, NULL, 3, N'מהי העבודה הכי כיפית שהיתה לך?', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 4, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1491, N'F1434', 6, 77, NULL, 3, N'מהי העבודה הכי מבאסת שהיתה לך?', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 4, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1492, N'F1435', 6, 77, NULL, 3, N'תאר את ההבנה והכישורים שלך במחשב', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 2, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1393, N'F1436', 6, 75, NULL, 3, N'אם היית עף על עצמך באופן מוגזם, איך היית מתאר את עצמך בחצי משפט?', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 2, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1067, N'F1437', 6, 35, NULL, 3, N'מה הדבר הכי טוב שקרה לך בשבוע האחרון?', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 4, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1068, N'F1438', 6, 35, NULL, 3, N'לאיזה רגע אחד בשבוע אתה הכי מחכה כל השבוע?', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 4, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1394, N'F1439', 6, 75, NULL, 3, N'בתוך מציאות של איזה סרט קולנוע מתחשק לך לחיות את החיים?', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 3, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1395, N'F1440', 6, 75, NULL, 3, N'יש לך אפשרות לקנות מכונית חדשה בלי מגבלת כסף, איזה רכב תקנה?', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 3, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1396, N'F1441', 6, 75, NULL, 3, N'יש לך אפשרות לשנות תכונה אחת שלך, איזו תכונה תשנה?', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 3, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1397, N'F1442', 6, 75, NULL, 3, N'בעוד 10 שנים מהיום, במה אתה רואה את עצמך עוסק?', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 2, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1398, N'F1443', 6, 75, NULL, 3, N'נניח שיש לך אפשרות להעלים כמה שעות מהיומן שלך בשבוע הקרוב, מה תמחק?', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 4, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1399, N'F1444', 6, 75, NULL, 3, N'נניח שהיה אפשר לענות לך במדויק על שאלה אחת מכל סוג שעולה לך בראש. איזו שאלה תשאלי?', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 3, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1400, N'F1445', 6, 75, NULL, 3, N'איזו מיומנות וירטואוזית הכי בא לך שתהיה לך?', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 3, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1401, N'F1446', 6, 75, NULL, 3, N'יש לך אפשרות לקרוא מחשבות של מישהו. מי זה יהיה?', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 2, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1069, N'F1448', 6, 35, NULL, 3, N'למי אתה הכי מתגעגע עכשיו??', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 4, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1070, N'F1449', 6, 35, NULL, 3, N'באיזה מצב רוח קמת הבוקר? ', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 4, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1493, N'F1456', 6, 78, NULL, 3, N'האם יצא לך לקבל משלוח זר פרחים? אם כן, על מה קיבלת אותם בפעם האחרונה שזה קרה?', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 4, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1494, N'F1457', 6, 78, NULL, 3, N'האם השתתפת פעם בתחרות ספורט עם מדליה או גביע? האם זכית פעם? אם כן, במה?', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 4, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1603, N'F1459', 6, 85, NULL, 3, N'מה הדבר הכי מוזר ששמת אי פעם במקרר?', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 3, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1391, N'F1460', 6, 75, NULL, 3, N'החולצה היפה הלבנה נצבעה בכביסה `99`, הכתימו לי את החולצה הלבנה ביין אדום `99`, מכונית השפריצה עלי כשעברתי ליד שלולית', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 3, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1605, N'F1461', 6, 85, NULL, 3, N'האם יוצא לך להסתובב עם שתי גרביים שהן לא זוג?', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 1, 1, NULL)
;
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1392, N'F1462', 6, 75, NULL, 3, N'התפשטתי ואז גיליתי שאין מים חמים במקלחת `99`, סיימתי את כל ההכנות לבישול אבל בדיוק נגמר הגז `99`, מילאתי עגלה בסופר, ואז ראיתי ששכחתי את הארנק בבית', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 3, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1604, N'F1463', 6, 85, NULL, 3, N'ננעלת פעם מחוץ לבית? `99`, יוצא לך מידי פעם לשכוח איפה שמת את הטלפון? `99`, יצא לך ששכחת משהו מתבשל על הגז וזה נשרף? `99`', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 3, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1223, N'F1464', 6, 51, NULL, 3, N'לראות טלוויזיה או להקשיב למוסיקה? `99`, חופשה בהרים או חופשה על החוף? `99` להיות רואה ואינו נראה, או קורא מחשבות? `99`', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 1, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1224, N'F1465', 6, 51, NULL, 3, N'בחור קרח או עם שערות בגב ובכתפיים? `99`, בחור נמוך ומצחיק או גבוה ויבשוש? `99`, מוות בטביעה או מוות בתליה?', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 3, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1071, N'F1466', 6, 35, NULL, 3, N'האם יצא לך להיפרד ממישהי בטלפון\SMS\מייל? אם כן, איך היא קיבלה את זה?', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 3, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1388, N'F1468', 6, 73, NULL, 3, N'מה הדבר הכי שרוט שאתם יכולים להגיד על המשפחה שלכם בכמה מילים?', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 3, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1613, N'F1469', 6, 90, NULL, 3, N'תאר את החוויה שלך מהתיכון ב 2-3 מילים בלבד. ', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 4, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1072, N'F1470', 6, 35, NULL, 3, N'מה אתם יכולים להגיד על החבר\ה הכי מוזר\ה שיש לכם?', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 3, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1073, N'F1471', 6, 35, NULL, 3, N'ממה אתם הכי מודאגים השבוע?', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 4, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1336, N'F1472', 6, 61, NULL, 3, N'מה הדבר הכי מעודד שקרה לך השבוע?', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 4, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1387, N'F1473', 6, 73, NULL, 3, N'ההבדל ביני לבין אבא שלי הוא:', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 4, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1322, N'F1474', 6, 61, NULL, 3, N'איזה דבר יוצא דופן עשית בחודש האחרון?', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 4, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1219, N'F1475', 6, 51, NULL, 3, N'שוקולד או תותים? לדבר או להקשיב? תאילנד או יפן? ', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 3, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1220, N'F1476', 6, 51, NULL, 3, N'לראות הצגה או משחק כדורגל? לרוץ או ללכת? טלוויזיה או קולנוע? ', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 3, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1221, N'F1477', 6, 51, NULL, 3, N'לעצב מכונית או לעצב בית? `99`, לגור בתל אביב או בגליל? `99`, לתכנן טיול מראש, או ספונטני? `99`', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 3, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1222, N'F1478', 6, 51, NULL, 3, N'בוקר או לילה? `99`, טיול אוהלים במדבר או מלון ספא באילת? `99`, אפל או אנדרואיד? `99`', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 3, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1189, N'F1479', 6, 49, NULL, 3, N'לוס אנג''לס `99`, סניף של H&M `99`, סניף של איקאה `99`', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 3, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1190, N'F1480', 6, 49, NULL, 3, N'טיפול פסיכולוגי `99`, טיפול כירופרקטי `99`, טיפול קוסמטי `99`', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 3, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1625, N'F1481', 6, 91, NULL, 3, N'נגינה בכלי כלשהו `99`, סדר וניקיון `99`, ארגון ותכנון `99`', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 3, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1626, N'F1482', 6, 91, NULL, 3, N'ניהול מו"מ להוריד מחיר של רכב `99`, פירוק והרכבה של מכשירים חשמליים `99`, התנהלות פיננסית נכונה `99`, ', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 4, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1627, N'F1483', 6, 91, NULL, 3, N'שירה `99`, בישול `99`, עיצוב גרפי `99`', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 4, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1628, N'F1484', 6, 91, NULL, 3, N'להיות טיפ טופ בלבוש `99`, לרקוד ואלס `99`, להבין בקוקטיילים אלכוהולים `99`', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 4, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1043, N'F1485', 6, 33, NULL, 3, N'מהו המאכל הכי מוזר שאכלת אי פעם?', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 2, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1284, N'F1487', 6, 55, NULL, 3, N'האם היה לך חלום שהספקת לממש? כם כן, מהו?', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 2, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1623, N'F1488', 6, 91, NULL, 3, N'דרג לפי סדר חשיבות, מה היית מעדיף לקרוא אצל אנשים -  רגשות, מחשבות, או את העתיד?', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 3, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1624, N'F1489', 6, 91, NULL, 3, N'אם היית יכול להגביר פי כמה את אחת התכונות החיוביות שלך. איזו תכונה היית מגביר? ', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 3, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1044, N'F1490', 6, 34, NULL, 3, N'על מה החמיאו לך לאחרונה?', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 3, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1621, N'F1491', 6, 91, NULL, 3, N'במה אתה טוב יותר? אינטואיציה רגשית, יכולת מחשבה או יכולת זיכרון? ', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 3, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1207, N'F1492', 6, 51, NULL, 3, N'כשאני פוגש מישהי חדשה `99` חשובה ההופעה שלה, `99` חשובה לי האישיות שלה, `99` חשוב לי החיוך שלה', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 4, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1050, N'F1493', 6, 34, NULL, 3, N'האם לדעתך החברים שלך את\ה מתנהל\ת לפי אינטואציה, או לפי חשיבה הגיונית? האם הם צודקים?', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 1, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1211, N'F1494', 6, 51, NULL, 3, N'סיאנסים (העלאת המתים) `99`, קלפי טארוט `99`, נומרולוגיה `99`', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 3, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1620, N'F1495', 6, 91, NULL, 3, N'כמה קל לך לזהות כשעושים עליך מנפילוציות רגשיות? ואיך אתה מגיב כשזה קורה?', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 3, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1045, N'F1496', 6, 34, NULL, 3, N'החברים שלך אומרים שאתה כריזמטי - `99`, שאתה אינטלגנטי - `99`, שאתה עפיפון - `99`', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 4, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1046, N'F1497', 6, 34, NULL, 3, N'החברים שלך אומרים שאתה כיפי - `99`, שאתה נחוש והחלטי - `99`, שאתה פצצת אנרגיה - `99`', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 4, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1047, N'F1498', 6, 34, NULL, 3, N'החברים שלך אומרים שאתה מצחיק - `99`, שאתה יצירתי - `99`, שאתה מתלבש טיפ טופ - `99`', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 4, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1048, N'F1499', 6, 34, NULL, 3, N'החברים שלך אומרים שאתה יודע לפתור כל בעיה - `99`, שאתה שמח ומאושר - `99`, שאתה מלא ברוגע בשלווה - `99`', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 4, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1049, N'F1500', 6, 34, NULL, 3, N'החברים שלך אומרים שיש בך צד מסתורי ומוזר - `99`, שיש לך ביטחון עצמי - `99`, שאתה בהחלט יודע ליהנות ולבלות - `99`', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 4, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1622, N'F1501', 6, 91, NULL, 3, N'האם את יודעת לפלרטט עם זרים בקלות, או שלוקח לך זמן להיפתח?', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 4, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1212, N'F1502', 6, 51, NULL, 3, N'מה בא לך יותר היום? מפגש עם חברים הכולל שיחות עם כמה אנשים, או מפגש מעמיק אחד על אחד?', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 4, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1213, N'F1503', 6, 51, NULL, 3, N'מה בא לך יותר עכשיו? לראות הופעה בפארק, או לצאת לבר עם חברים? ', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 4, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1051, N'F1504', 6, 35, NULL, 3, N'האם יצא לך להתחיל עם גברים? ולגבר, האם מישהי התחילה איתך פעם?', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 4, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1208, N'F1505', 6, 51, NULL, 3, N'אם אתה חייב לבחור, עדיף שהיא תהיה ספונטנית, או מסתורית?', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 2, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1209, N'F1506', 6, 51, NULL, 3, N'אם אתה חייב לבחור, עדיף שהיא תהיה יודעת להקשיב, או יודעת לדבר?', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 3, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1210, N'F1507', 6, 51, NULL, 3, N'האם עדיף שאתה תהיה כל העולם שלה, או שיהיו לה תחומי עניין שיעסיקו אותה גם בלעדיך?', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 1, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1052, N'F1508', 6, 35, NULL, 3, N'החברה אומרת לך שהיא רוצה לצאת לניו יורק לשבוע חופשת בנות בלעדיך. איך תרגיש עם זה?', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 4, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1053, N'F1509', 6, 35, NULL, 3, N'החברה בנסיעת עבודה בחו"ל, ובגלל נסיבות, היא תצטרך לישון באותו החדר במלון עם עמית לעבודה שהוא גבר. האם זה מקובל עליך?', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 4, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1363, N'F1510', 6, 64, NULL, 3, N'כתבו רעיון לדייט שאינו מקובל בדרך כלל, לדוגמא -  דייט בחנות ספרים תוך כדי בחירת ספר. ', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 3, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1163, N'F1511', 6, 43, NULL, 3, N'דרג מה חשוב בחיים - הישגיות בקריירה `99`, רומנטיקה `99`, חברים טובים `99`', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 3, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1164, N'F1512', 6, 43, NULL, 3, N'דרג מ 1 עד 10 מה חשוב בחיים קארמה `99`, פרופורציות `99`, אוכל `99`, משפחה `99`', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 3, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1054, N'F1513', 6, 35, NULL, 3, N'באיזה תחום אם מעצבנים אותך - פחד אלוהים להסתבך איתך? ', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 3, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1055, N'F1514', 6, 35, NULL, 3, N'באיזה תחום אתה מוותר תמיד, שאפשר להגדי אותך לגמרי פרייר? ', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 3, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1323, N'F1515', 6, 61, NULL, 3, N'מה גרם לך לחייך ביום יומיים האחרונים?', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 4, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1324, N'F1516', 6, 61, NULL, 3, N'מה עיצבן אותך במיוחד בשבוע האחרון?', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 4, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1325, N'F1517', 6, 61, NULL, 3, N'מה העציב אותך בשבוע האחרון?', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 4, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1326, N'F1518', 6, 61, NULL, 3, N'מה איכזב אותך בשבוע האחרון?', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 4, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1143, N'F1519', 6, 43, NULL, 3, N'אילו שלושה דברים הכי מעצבנים אותך בחיים?', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 3, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1056, N'F1520', 6, 35, NULL, 3, N'האם אי פעם קינאת בחבר שלך? אם כן, מה? ', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 2, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1331, N'F1521', 6, 61, NULL, 3, N'באילו מהאביזרים הלא נוחים הבאים את משתמשת \ חשוב להשתמש? נעלי עקב, סידור שיער, איפור.', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 3, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1332, N'F1522', 6, 61, NULL, 3, N'אם אתה צריך לצאת ב 8:00 בבוקר מהבית, לאיזו שעה תכוון שעון? ', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 3, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1333, N'F1523', 6, 61, NULL, 3, N'אני מתקלח `99` דקות, אחרי המקלחת אני בוחר בגדים ליציאה תוך `99` דקות, ולוקח לי להתלבש ולהתכונן ליציאה `99` דקות ', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 4, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1334, N'F1524', 6, 61, NULL, 3, N'אני אוכל ארוחת בוקר ב `99` דקות, מסיים קניה שבועית בסופרמרקט תוך `99` דקות, מצחצח שיניים לפני השינה תוך `99` דקות', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 4, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1335, N'F1525', 6, 61, NULL, 3, N'עם כמה כריות אתה ישן? `99`, מזרן רך או קשה? `99`, חלון פתוח או סגור? `99`', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 4, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1619, N'F1526', 6, 91, NULL, 3, N'עד כמה אתם רגועים ושלווים? ', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 3, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1057, N'F1527', 6, 35, NULL, 3, N'באיזה תחום אתם מרגישים חסרי ביטחון לפעמים?', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 2, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1329, N'F1528', 6, 61, NULL, 3, N'באיזו דרך אתה נפגש עם הידידות שלך? חיבוק, לחיצת יד, נפנוף לשלום, חיוך, נשיקה בלחי, נשיקה קלה בשפתיים?', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 2, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1330, N'F1529', 6, 61, NULL, 3, N'מתי קיללת בפעם האחרונה, ומה היתה הקללה?', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 3, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1390, N'F1530', 6, 75, NULL, 3, N'מודיעים לך בהפתעה שקיבלת את עבודת החלומות שלך. איך תגיב? (למשל, ניתור ביחד עם "יש!" או רק חיוך סיפוק וכו''...)', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 2, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1214, N'F1531', 6, 51, NULL, 3, N'מה הכי כדאי לעשות מייד אחרי השחרור מצה"ל? טיול גדול (איפה?), לימודים, סתם לחיות?', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 2, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1328, N'F1532', 6, 61, NULL, 3, N'איך אתה מעביר את הזמן כשאתה לבד בבית בערב, אחרי יום עבודה מתיש?', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 3, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1058, N'F1533', 6, 35, NULL, 3, N'האם אתה מחשיב את עצמך כ"יודע להתלבש"? האם אתה קונה לעצמך לבד את הבגדים?', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 4, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1362, N'F1534', 6, 63, NULL, 3, N'האם כילד היית נוהג לאכול כל הזמן "שניצל ואורז", או שקיבלת גם אוכל ביתי מושקע יותר? ', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 3, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1389, N'F1535', 6, 73, NULL, 3, N'איזה בילוי הכי מועדף עליך כשאתה עם המשפחה שלך?', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 3, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1159, N'F1536', 6, 43, NULL, 3, N'איזה בילוי הכי מועדף עליך כשאתה עם החבר''ה שלך?', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 3, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1160, N'F1537', 6, 43, NULL, 3, N'נניח שאתה יוצא לדייט חשוב וקיבלת תקציב בלתי מוגבל לקנות בגדים. מה תלבש?', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 3, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1161, N'F1538', 6, 43, NULL, 3, N'עם `99` אדבר על בעיות בזוגיות, עם `99` אדבר על כסף, עם `99` אדבר על הפנטזיות שלי', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 3, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1162, N'F1539', 6, 43, NULL, 3, N'באילו נושאים אתם עקשנים ומתקשים לוותר?', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 1, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1059, N'F1540', 6, 35, NULL, 3, N'עד כמה אתה מנומס עם גינונים בסטייל בריטי אירופאי קלאסי?', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 1, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1327, N'F1541', 6, 61, NULL, 3, N'עם מי התווכחת בשבוע האחרון ועל מה?', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 1, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1216, N'F1542', 6, 51, NULL, 3, N'איזו קריירה אתה חושב שהכי מתאימה לך? ', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 2, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1217, N'F1543', 6, 51, NULL, 3, N'עד כמה בא לך להיות "הבוס" ולנהל אחרים? ', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 2, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1218, N'F1544', 6, 51, NULL, 3, N'אתה בקניון ועכשיו קיבלת 1,000 ₪. על מה תבזבז אותם?', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 3, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1617, N'F1545', 6, 91, NULL, 3, N'עד כמה אתה דייקן ופרפקציוניסט?', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 3, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1618, N'F1546', 6, 91, NULL, 3, N'האם אתה חולמני, או איש של תכלס?', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 3, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1154, N'F1547', 6, 43, NULL, 3, N'בוקר. אתה עומד לצאת מהבית, ולפתע מודיעים לך שהפגישה נדחתה בשעתיים. איך תעביר את הזמן בבית?', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 3, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1616, N'F1548', 6, 91, NULL, 3, N'עד כמה אתה טיפוס שיודע להזיז אנשים, מסוגל לארגן הפגנות, לידר? ', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 2, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1215, N'F1549', 6, 51, NULL, 3, N'היום - בית עם גינה או פנטהאוז במרכז העיר? ועוד 10 שנים? ', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 2, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1614, N'F1550', 6, 91, NULL, 3, N'האם את פמיניסטית שחושבת שצריך שיוויון מוחלט? או שלפעמים אולד פאשן זה נחמד לך?', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 1, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1155, N'F1551', 6, 43, NULL, 3, N'עגילים - `99`, ענק - `99`, צמידים - `99`, פירסינג - `99`', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 3, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1156, N'F1552', 6, 43, NULL, 3, N'קיבלת יום חופש! פראי ומשוגע - `99`, תרגעו כולכם, קודם אני שותה קפה - `99`, מרתון סדרות ב VOD - `99`', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 3, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1157, N'F1553', 6, 43, NULL, 3, N'מהו הדייט השני האידיאלי בעיניך? דרג מ 1 עד 10', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 4, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1158, N'F1554', 6, 43, NULL, 3, N'נשלחת למשימה במאדים על ידי נאסא. אילו שלושה דברים תקח איתך לחללית?', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 4, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1615, N'F1555', 6, 91, NULL, 3, N'אם היו מאבחנים אצלך איזו הפרעה אישיותית, מה היא היתה?', 0, 1, 1, 18, 99, 4, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 3, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1606, N'F1556', 6, 85, NULL, 3, N'מה אתה רואה בטלוויזיה במיטה לפני השניה?', 0, 1, 1, 18, 99, NULL, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), NULL, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1607, N'F1557', 6, 85, NULL, 3, N'לאיזה הרגל אתה מכור באופן קשה?', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 4, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1608, N'F1558', 6, 85, NULL, 3, N'לאיזה מאכל אתה מכור באופן הרסני?', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 4, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1144, N'F1559', 6, 43, NULL, 3, N'אם תוכל לסגור חשבון עם מישהו מהעבר שפגע בך שלא בצדק, על מה ועם מי זה יהיה? ', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 3, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1074, N'F1560', 6, 35, NULL, 3, N'קרה לך שידידה התקשרה אליך לבוא לבכות לך? על מה?', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 3, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1366, N'F1561', 6, 66, NULL, 3, N'תאר את הלבוש שלך כשיצאת אתמול בבוקר מהבית.', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 4, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1422, N'F1562', 6, 75, NULL, 3, N'הבוס שלך מספר בדיחה ממש לא מצחיקה. מה תעשה?', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 3, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1647, N'F1563', 6, 91, NULL, 3, N'בכללי אתה טיפוס חסכן או בזבזן? ', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 3, 1, NULL)
;
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1141, N'F1564', 6, 43, NULL, 3, N'בחר שתי תכונות שהכי נחשבות בעיניך מהרשימה: מלאת השראה, מהפנטית, אמיצה, מבריקה, יודעת להקשיב, יודעת להתלבש', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 4, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1142, N'F1565', 6, 43, NULL, 3, N'אהבה היא: מסובכת, מדהימה, מפחידה, אוויר לנשימה, מכאיבה, עיוורת. בחרי מהרשימה (או הוסיפי משלך)', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 4, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1648, N'F1566', 6, 91, NULL, 3, N'עד כמה אתם נחשבים בעיני עצמכם לכאלה שנפתחים בקלות ויודעים לשתף דברים אינטימיים?', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 4, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1649, N'F1567', 6, 91, NULL, 3, N'האם השתנית הרבה מכפי שהיית לפני 5 שנים? אם כן, במה?', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 3, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1586, N'F1568', 6, 85, NULL, 3, N'האם יצא לך מתישהו להעיר לאישה הערה מביכה, למשל שיש לה ריח רע מהפה? למי? ומה?', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 3, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1587, N'F1569', 6, 85, NULL, 3, N'האם אתה בקשר עם חברי ילדות? עם כמה ומי?', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 2, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1645, N'F1570', 6, 91, NULL, 3, N'האם באופן כללי חם לך? על איזו טמפרטורה אתה מכוון את המזגן בקיץ? אתה אוהב שהרוח עליך?', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 3, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1646, N'F1571', 6, 91, NULL, 3, N'האם באופן כללי קר לך? עם איזו שמיכה אתה ישן בחורף? עם כמה שכבות אתה יוצא מהבית ביום חורפי?', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 3, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1319, N'F1572', 6, 61, NULL, 3, N'מה אתה נוהג לומר לאנשים שמקטרים ומתלוננים כל הזמן? ', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 1, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1320, N'F1573', 6, 61, NULL, 3, N'כמה פעמים הכנת בשבועיים האחרונים ארוחת ערב מושקעת? מה הכנת בעיקר? ', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 4, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1585, N'F1574', 6, 85, NULL, 3, N'כמה זוגות נעליים יש לך בטוטאל? בבקשה פרט\י... (כולל סנדלים, כפכפים, קרוקס, הכל הולך)', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 4, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1316, N'F1575', 6, 61, NULL, 3, N'האם יצא לך להיות בשנה האחרונה ממש שיכור\ה? באילו נסיבות?', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 2, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1317, N'F1576', 6, 61, NULL, 3, N'כמה שעות את\ה ישנ\ה בממוצע בלילה? כמה היית רוצה לישון? ', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 3, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1318, N'F1578', 6, 61, NULL, 3, N'את שנתיים באי בודד. קבע דרגת חשיבות מ 1 עד 10  לדברים מהרשימה שלדעתך חשוב שיהיו איתך שם.  ', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 4, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1075, N'F1579', 6, 35, NULL, 3, N'פרט חלום אופטימי שאתה זוכר שחלמת.', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 2, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1076, N'F1580', 6, 35, NULL, 3, N'פרט חלום מפחיד שאתה זוכר שחלמת', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 2, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1383, N'F1581', 6, 71, NULL, 3, N'האם יצא לך פעם שחזית משהו והוא התגשם במדויק באופן מפתיע? אם כן, מה זה היה?', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 2, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1384, N'F1582', 6, 71, NULL, 3, N'אני `99`  מאמין בגלגול נשמות, אני `99` מאמין ברוחות, אני `99` מאמין בטלפתיה', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 3, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1385, N'F1583', 6, 71, NULL, 3, N'אני `99`  מאמין בגן עדן וגיהנום, אני `99` מאמין בגורל קבוע מראש, אני `99` מאמין בתקשורת עם המתים', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 3, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1239, N'F1584', 6, 51, NULL, 3, N'במקום הראשון `99`, במקום השני `99`, במקום השלישי `99` ', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 4, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1584, N'F1585', 6, 85, NULL, 3, N'מתי בפעם האחרונה קראת ספר `99`, הלכת לתיאטרון `99`, הפגנת בהפגנה אידיאולוגית `99`', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 3, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1238, N'F1586', 6, 51, NULL, 3, N'איפה את\ה חולם\ת להתחתן? תן\י ציון מ 1 עד 10 ללוקיישנים הבאים:', 0, 1, 1, 18, 99, 4, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 3, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1419, N'F1587', 6, 75, NULL, 3, N'הוזמנת למסיבה עם החברה החדשה שלך, והיא מדברת עם גברים אחרים המון, יותר מאשר איתך. כתוב לה SMS', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 3, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1420, N'F1588', 6, 75, NULL, 3, N'אתה מפגיש את החברה החדשה עם ההורים שלך. מה יהיה נחשב בעיניך להתנהגות לא מכובדת מצידה. ', 0, 1, 1, 18, 99, 4, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 3, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1421, N'F1589', 6, 75, NULL, 3, N'תן דוגמא ל"איך אסור להתנהג איתך בדייט ראשון". ', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 3, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1583, N'F1590', 6, 85, NULL, 3, N'כמה נכון המשפט -  "הרבה בנות נמשכות דווקא לגברים שמתנהגים כמו חארות?"', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 2, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1225, N'F1591', 6, 51, NULL, 3, N'כמה נכון המשפט -  "הרבה גברים נמשכים דווקא לבנות שמתעללות בהם רגשית?"', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 2, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1174, N'F1592', 6, 45, NULL, 3, N'אתה יוצא לבליינד דייט והיא מבקשת שאתה תבחר לבדך את מקום ואופי הבילוי - מה תבחר?', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 3, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1175, N'F1593', 6, 45, NULL, 3, N'באוניברסיטה! דרג מ 1 עד 10 איזה דייט מועדף עליך. מפגש בהפסקה בקפיטריה `99`, פתקים תוך כדי שיעור `99`, לימוד זוגי ביחד למבחן `99`', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 2, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1176, N'F1594', 6, 45, NULL, 3, N'אני מוכן לצאת עם מישהי מקסימום `99` שנים מעל, ומקסימום `99` שנים מתחת לגילי. ', 0, 1, 1, 18, 99, 4, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 4, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1502, N'F1595', 6, 78, NULL, 3, N'איזה דבר אחד עשית בעבר, שמחשיב אותך להרפתקן בעיניך?', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 4, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1418, N'F1596', 6, 75, NULL, 3, N'גורלך תלוי באיכות הסנדוויץ שתכין עבורה. תאר את הרכב הסנדוויץ. ', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 2, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1140, N'F1597', 6, 43, NULL, 3, N'ספר על גבר (ידוע) אחד שמרשים אותך כל כך עד שאתה אומר "אני מת להיות כמוהו"', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 2, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1188, N'F1598', 6, 47, NULL, 3, N'`99` אחוז סיכוי שאצא עם גיק מחשבים, `99` סיכוי שאצא עם ערס עם שרשראות, `99` סיכוי שאבחר בשרירן מנופח', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 5, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1177, N'F1599', 6, 45, NULL, 3, N'`99` סיכוי שאצא עם פצצה אבל מטומטמת, `99` אחוז סיכוי שאצא עם חדת לשון שתמיד מנצחת בויכוח, `99` סיכוי שאצא עם ביישנית במיוחד', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 5, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1321, N'F1600', 6, 61, NULL, 3, N'איזה דבר מטופש שאת\ה מתחרט\ת עליו, עשית בשבוע האחרון?', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 4, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1226, N'F1601', 6, 51, NULL, 3, N'אילו סוגי מדים (כל סוג של בגדי עבודה) עושים לך את זה אצל אישה?', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 4, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1227, N'F1602', 6, 51, NULL, 3, N'עד כמה גברים בסטאטוס חברתי\ניהולי גבוה, או עמדת כוח, עושים לך את זה? ', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 3, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1582, N'F1603', 6, 85, NULL, 3, N'האם יצא לך להשתמש בסקס אפיל שלך בכוונה כדי להשיג משהו? אם כן, תן דוגמא', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 2, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1236, N'F1604', 6, 51, NULL, 3, N'אם גבר מוצא חן בעיניך, האם תתחילי איתו ישירות, או שמקסימום תפילי מטפחת ותקווי שהוא ימשיך את העבודה משם?', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 4, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1134, N'F1606', 6, 43, NULL, 3, N'מציעים לך משכורת מובטחת לכל החיים תמורת ויתור על לימודים\קריירה. מה הסכום  החודשי ברוטו שפחות ממנו לא תסכים לעיסקה?', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 4, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1135, N'F1607', 6, 43, NULL, 3, N'מציעים לך משכורת מובטחת לכל החיים תמורת ירידה מהארץ. מה הסכום  החודשי ברוטו שפחות ממנו לא תסכים לעיסקה?', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 4, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1136, N'F1608', 6, 43, NULL, 3, N'לגרום לה לצחוק `99`, לפנק אותה בליטופים `99`, להקשיב לה `99` ', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 4, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1137, N'F1609', 6, 43, NULL, 3, N'לקנות לה מתנות `99`, לקחת אותה לטיולים מושקעים `99`, להעריף עליה תשומת לב', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 4, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1138, N'F1610', 6, 43, NULL, 3, N'להחמיא לה על הלוק שלה `99`, להחמיא לה על השכל שלה `99`, להחמיא לה על האישיות שלה `99`', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 4, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1139, N'F1611', 6, 43, NULL, 3, N'נניח שיש מסיבת חברים והגיע הקטע שכל אחד חייב לתת 2-3 דקות הופעה, לא משנה מה. במה תופיע?', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 4, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1077, N'F1612', 6, 35, NULL, 3, N'מה גורם לכם להרגיש סקסיים?', 0, 1, 1, 18, 99, 4, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 3, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1650, N'F1613', 6, 91, NULL, 3, N'אני ריאליסט `99`, אני וורקוהוליק `99`, אני איש של אתגרים `99`', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 4, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1651, N'F1614', 6, 91, NULL, 3, N'אני זאב בודד `99`, יש לי ביטחון עצמי גבוה `99`, אוני אוהב להוביל `99`', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 4, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1132, N'F1615', 6, 43, NULL, 3, N'ספורטאית `99`, יודעת לבשל `99`, אמנית יוצרת `99`', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 4, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1133, N'F1616', 6, 43, NULL, 3, N'רקדנית `99`, נהגת משאית `99`, שוטרת `99`', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 4, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1078, N'F1617', 6, 35, NULL, 3, N'אתה בדייט עכשיו. איזה חיסרון שלך תנסה להצניע?', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 3, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1130, N'F1618', 6, 43, NULL, 3, N'סקי `99` טיפוס הרים `99`, צניחה חופשית `99`', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 3, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1131, N'F1619', 6, 43, NULL, 3, N'גלישת גלים `99`, טיול לקוטב `99`, אופני שטח `99`', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 3, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1228, N'F1620', 6, 51, NULL, 3, N'בילוי טוב זה:', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 2, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1229, N'F1621', 6, 51, NULL, 3, N'מה בא לך עכשיו? פרפרים בבטן, או נוחות ורוגע? ומה אתה מתכוון לעשות כדי להשיג את זה?', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 2, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1653, N'F1622', 6, 91, NULL, 3, N'אם אתה בראיון עבודה. איזו תכונה שלך תעדיף להסתיר?', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 2, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1654, N'F1623', 6, 91, NULL, 3, N'האם יש לך צד נשי כלשהו? אם כן, איך זה מתבטא?', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 2, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1581, N'F1624', 6, 85, NULL, 3, N'תאר מחווה רומנטית דביקה במיוחד שעשית בשביל אישה', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 2, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1230, N'F1625', 6, 51, NULL, 3, N'מישהי שאתה יוצא איתה כבר חודש מביאה לך בהפתעה מתנה ארוזה. מה תרצה שיהיה בקופסא?', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 3, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1231, N'F1626', 6, 51, NULL, 3, N'נשיקה חושנית `99`, מיקס ערוך של שירים יפים `99`, שוקולד בלגי', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 3, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1232, N'F1627', 6, 51, NULL, 3, N'טיול בשדה בגשם `99`, מסיבת הפתעה `99`, גור כלבים `99`', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 3, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1504, N'F1628', 6, 78, NULL, 3, N'האם מישהו פעם אמר לך משפט ששינה לך את החיים במובן מסוים? אם כן, מה?', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 2, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1233, N'F1629', 6, 51, NULL, 3, N'עד כמה היית רוצה לעבוד במקצועות הבאים: (מאוד, קצת, בכלל לא ,וכו''...) ', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 3, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1234, N'F1630', 6, 51, NULL, 3, N'עד כמה היית רוצה לעבוד במקצועות הבאים: (מאוד, קצת, בכלל לא ,וכו''...) ', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 3, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1235, N'F1631', 6, 51, NULL, 3, N'עד כמה היית רוצה לעבוד במקצועות הבאים: (מאוד, קצת, בכלל לא , וכו''...) ', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 3, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1386, N'F1632', 6, 73, NULL, 3, N'מתי היתה הפעם האחרונה שאמא שלך קנתה לך בגדים? מה היא קנתה?', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 3, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1652, N'F1633', 6, 91, NULL, 3, N'עד כמה התכונות הללו מגדירות אותך? (מאוד, קצת, בכלל לא, וכו''...) ', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 4, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1237, N'F1634', 6, 51, NULL, 3, N'האם אתה מוכן להיות עם מישהי ש: יש לה טעם רע בבגדים `99`, היא קנאית `99`, לוקחת את כל השמיכה בחורף `99` ', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 4, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1503, N'F1635', 6, 78, NULL, 3, N'האם הרגשת פעם בפאניקה אמיתית? אם כן, ממה?', 0, 1, 1, 18, 99, 4, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 4, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1580, N'F1636', 6, 85, NULL, 3, N'האם שיקרת אי פעם לבוס שלך? בקשר למה?', 0, 1, 1, 18, 99, 4, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 3, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1244, N'F1637', 6, 51, NULL, 3, N'עם איזה שיר היית רוצה להתעורר בבוקר?', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 3, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1640, N'F1638', 6, 91, NULL, 3, N'האם אתה זקוק ל''תנאים'' מסוימים כדי להירדם, או שאתה נרדם בקלות גם על ערימת אבנים?', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 3, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1641, N'F1639', 6, 91, NULL, 3, N'כמה עמוק אתה ישן? האם אתה מתעורר מכל רעש קטן, או שגם תותח לא יעיר אותך?', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 3, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1428, N'F1640', 6, 75, NULL, 3, N'שבת בבוקר. בחוץ גשם וסערה. זה עושה לי חשק ל', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 4, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1429, N'F1641', 6, 75, NULL, 3, N'בחוץ חמסין כבד. זה עושה לי חשק ל', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 4, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1639, N'F1642', 6, 91, NULL, 3, N'מה עוזר לך להירגע? דרג מ 1 עד 10', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 4, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1497, N'F1643', 6, 78, NULL, 3, N'האם יצא לך פעם לנאום בפני קהל? אם כן, איך היתה ההרגשה?', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 2, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1635, N'F1644', 6, 91, NULL, 3, N'תאר מקרה בו הצד הרך והאמפטי שלך בא לידי ביטוי', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 3, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1245, N'F1645', 6, 51, NULL, 3, N'דרגי עד כמה חשובות לך התכונות הבאות אצל בן הזוג: אינטלגנציה רגשית `99`, מסירות `99`, היכולת להיות שרוטה לפעמים `99`', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 3, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1427, N'F1646', 6, 75, NULL, 3, N'ממי כדאי שתבקש סליחה ביום כיפור? ועל מה?', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 4, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1642, N'F1647', 6, 91, NULL, 3, N'עד כמה זה נכון אם אחרים יגידו לך שאתה: (מאוד, בכלל לא, קצת וכו''...) ', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 4, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1643, N'F1648', 6, 91, NULL, 3, N'עד כמה זה נכון אם אחרים יגידו לך שאתה: (מאוד, בכלל לא, קצת וכו''...) ', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 4, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1644, N'F1649', 6, 91, NULL, 3, N'עד כמה מפחיד אותך לטייל ב: יער ענקי מלא ערפל `99`, בית קברות `99`, סמטא חשוכה בלילה בעיר `99`', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 4, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1145, N'F1650', 6, 43, NULL, 3, N'דרגי עד כמה בא לך שההרפתקאה הבאה שלך תהיה ב: סגת האוורסט `99`, ג''ונגלים בברזיל `99`, טיסה לירח `99`, ', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 4, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1146, N'F1651', 6, 43, NULL, 3, N'דרג עד בא לך שההרפתקאה הבאה שלך תהיה ב: אנטארקטיקה `99`, צלילה בקרקעית הים `99`, ראפטינג בצרפת `99`', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 4, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1426, N'F1653', 6, 75, NULL, 3, N'על מה לא תסלח בחיים אם יעשו לך?', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 3, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1636, N'F1654', 6, 91, NULL, 3, N'כמה מהר או לאט אתה מתעצבן,  וכמה מהר או לאט אתה נרגע? ', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 3, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1637, N'F1655', 6, 91, NULL, 3, N'האם שברת פעם משהו מתוך כעס? מה זה היה ואיך?', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 2, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1638, N'F1656', 6, 91, NULL, 3, N'האם לפעמים את מדוכאת או מדוכדכת בלי סיבה? אם כן, איך את יוצאת מזה?', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 3, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1588, N'F1657', 6, 85, NULL, 3, N'מנה כמה חברים טובים יש לך מכל תקופה (הילדות, הצבא, עבודה, וכו''... ) ', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 2, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1312, N'F1658', 6, 61, NULL, 3, N'מה אכלת אתמול לארוחת צהריים? (בבקשה לפרט הכל!)', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 4, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1313, N'F1659', 6, 61, NULL, 3, N'מה אכלת אתמול לארוחת ערב? בבקשה לפרט הכל)', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 4, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1496, N'F1660', 6, 78, NULL, 3, N'איזה משחקים שיחקת הכי הרבה בחיים?', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 4, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1240, N'F1661', 6, 51, NULL, 3, N'לשאוב אבק `99`, לכבס ולתלות כביסה `99`, לשטוף כלים `99`', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 4, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1241, N'F1662', 6, 51, NULL, 3, N'לשפוך את הפח `99`, לשטוף את הבית `99`, לסדר את חדר עבודה `99`', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 4, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1498, N'F1663', 6, 78, NULL, 3, N'מתי בפעם האחרונה רבת עם מישהו מהמשפחה שלך? על מה?', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 3, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1499, N'F1664', 6, 78, NULL, 3, N'תאר את ההערכות שקיבלת בתיכון', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 4, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1634, N'F1665', 6, 91, NULL, 3, N'עד כמה אתה טיפוס של "מולטי בילויים" לערב אחד, מול "בילוי אחד ויחיד זה מספיק"?', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 3, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1501, N'F1666', 6, 78, NULL, 3, N'תאר את ההערכות שקיבלת בתיכון', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 4, 1, NULL)
;
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1242, N'F1667', 6, 51, NULL, 3, N'דרג מהרשימה, עד כמה רומנטי כל דבר בעיניך: (מאוד, קצת, בכלל לא, וכו''...)', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 4, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1243, N'F1668', 6, 51, NULL, 3, N'דרג מהרשימה, עד כמה רומנטי כל דבר בעיניך: (מאוד, קצת, בכלל לא, וכו''...)', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 4, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1314, N'F1669', 6, 61, NULL, 3, N'אני שוטף את הבית `99` פעמים בשבוע, מכבס בגדים `99` פעמים בחודש, ומסדר את החדר שלי `99` פעמים בשנה', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 4, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1424, N'F1670', 6, 75, NULL, 3, N'מישהי שישבה בכלא על עבירת גניבה `99`, מישהי שעברה ילדות קשה `99`, מישהי שנעצרה על אלימות `99`', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 3, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1425, N'F1671', 6, 75, NULL, 3, N'מישהי שתפסת אותה בשקר `99`, מישהי שבגדה בחבר הקודם שלה `99`, מישהי שהזריקה בעבר הרואין אבל עכשיו נקיה `99` ', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 3, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1173, N'F1672', 6, 45, NULL, 3, N'האם היה מקרה שבו פסלת מישהי מראש בגלל משהו (שאינו צורה חיצונית)? אם כן, בגלל מה?', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 3, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1500, N'F1673', 6, 78, NULL, 3, N'תאר ב 2-4 מילים את תקופת הילדות שלך', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 2, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1315, N'F1674', 6, 61, NULL, 3, N'ספר על משהו מיוחד ויוצא דופן שעשית השבוע', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 3, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1633, N'F1675', 6, 91, NULL, 3, N'עד כמה נכונות לגביך התכונות הבאות: (נכון מאוד, בכלל לא, קצת, וכו...)', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 3, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1423, N'F1676', 6, 75, NULL, 3, N'תאר במשפט קצר או כותרת את הסרט שיעשו על החיים שלך', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 3, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1632, N'F1677', 6, 91, NULL, 3, N'כשאתה לבד, האם אתה מחפש להפסיק את זה כמה שיותר מהר, או שאתה נהנה להיות לבד?', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 2, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1590, N'F1678', 6, 85, NULL, 3, N'האם אתה חושב שאתה עובד קשה מידי? מה סוג העבודה שלך?', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 3, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1591, N'F1679', 6, 85, NULL, 3, N'באיזה ביטוי יוצא לך להשתמש הרבה (למשל - "Been there, done that" או "זו לא תכנית כבקשתך" וכו''..)', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 2, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1592, N'F1680', 6, 85, NULL, 3, N'כתוב לפחות 3 חטיפים מלוחים לא בריאים שאתה מכור אליהם', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 3, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1593, N'F1681', 6, 85, NULL, 3, N'כתוב לפחות 3 דברים מתוקים וממש לא בריאים שאתה מכור אליהם', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 3, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1434, N'F1682', 6, 75, NULL, 3, N'ידידה שלך שואלת אותך אם היא השמינה, ואתה רואה בבירור שכן, והרבה. איך תשיב?', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 4, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1435, N'F1683', 6, 75, NULL, 3, N'למה בא לך להתחפש בפורים הקרוב?', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 2, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1298, N'F1684', 6, 59, NULL, 3, N'תאר עד כמה אתה אוהב דברים לא בריאים בחגים: (אוהב מאוד, בכלל לא, קצת, וכו''...)', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 4, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1589, N'F1685', 6, 85, NULL, 3, N'מה משך הזמן הכי גדול ברציפות שבו עשית את הפעילויות הבאות: צפיה בטלוויזיה `99`, לשכב\לשבת על החוף `99`, שופינג `99`', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 4, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1433, N'F1686', 6, 75, NULL, 3, N'תארי את עצמך בעוד 20 שנה:', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 4, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1630, N'F1687', 6, 91, NULL, 3, N'תאר כמה אתה פוחד מ: חש `99`, עקרב `99`, עכביש `99`, ג''וק `99`', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 4, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1631, N'F1688', 6, 91, NULL, 3, N'עד כמה אתה טיפוס שאוהב ילדים? (ילדים של בני משפחה שלך וכו''...)', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 3, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1472, N'F1689', 6, 75, NULL, 3, N'איזה דבר אחד היה צריך להשתנות אתמול, כדי שאתמול יהיה יום מוצלח במיוחד?', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 3, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1309, N'F1690', 6, 61, NULL, 3, N'במה אפשר לסמוך עליך?', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 3, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1594, N'F1691', 6, 85, NULL, 3, N'נניח שמזמינים אותך לטיול טבע של יומיים בסופ"ש הקרוב. השב במילים "יש" או "אין"', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 4, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1248, N'F1692', 6, 51, NULL, 3, N'מה נחשבת הצלחה בעיניך? כסף `99`, לעזור לאחרים `99`, קריירה `99`, אהבה `99`', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 4, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1306, N'F1693', 6, 61, NULL, 3, N'אני צריך לכוון נודניק `99` פעמים, לוקח לי `99` דקות להתעורר לגמרי ולהתחיל לתפקד, ובדרך כלל המצב רוח שלי בבוקר הוא `99`', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 4, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1307, N'F1694', 6, 61, NULL, 3, N'ריצת 5 ק"מ ב 5 בבוקר `99`, שחיית בוקר לפני העבודה `99`, לקום ב-5 לראות את הזריחה בים `99`', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 4, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1308, N'F1695', 6, 61, NULL, 3, N'איך נראות בדרך כלל ארוחות הצהריים שלך? כבדות עם בשר, או סלטים קלילים, או משהו אחר?', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 2, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1247, N'F1696', 6, 51, NULL, 3, N'נניח שמציעים לכם עבודה זמנית ליום אחד, דרגו כמה אתם מעוניינים ב: חשפנית `99`, מנחה באח הגדול `99`, מצילה בים `99`', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 3, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1432, N'F1697', 6, 75, NULL, 3, N'חבר שלך יוצא לדייט עם מישהי שהיא בענק מעל לליגה שלו. איזו עצה תיתן לו לקראת הדייט?', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 2, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1147, N'F1698', 6, 43, NULL, 3, N'יש קריוקי ואתה חייב לשיר. באיזה שיר תבחר? באיזה שיר חליפי?', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 4, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1310, N'F1699', 6, 61, NULL, 3, N'הסתכל מבעד לחלון שלידך. מה אתה רואה? ', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 3, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1148, N'F1700', 6, 43, NULL, 3, N'מה התכניות שלך לסוף השבוע הקרוב?', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 3, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1281, N'F1701', 6, 54, NULL, 3, N'חטאים', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 4, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1282, N'F1702', 6, 54, NULL, 3, N'האם אתה מודה שחטאת בעבר באחד מהחטאים האלה: (מודה, לא מודה, קצת וכו''... )', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 4, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1610, N'F1703', 6, 87, NULL, 3, N'האם יצא לך לקנא (קנאה שלילית וצורבת) באחד החברים שלך?', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 3, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1149, N'F1704', 6, 43, NULL, 3, N'נסיעה באופניים `99`, טיול בחוף הים `99`, לתפוס תנומה `99`, להמשיך לשחק איתך `99`', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 4, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1629, N'F1705', 6, 91, NULL, 3, N'האם אתה נחשב בעיני החבר''ה שלך כיועץ טוב? איזו עצה נתת לאחרונה לחבר\ה? ', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 3, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1150, N'F1706', 6, 43, NULL, 3, N'נניח שהיתה לך מילגה חלומית ללמוד איפה שתרצה ומה שתרצה. מה היית לומד, ואיפה?', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 4, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1596, N'F1707', 6, 85, NULL, 3, N'ספר על חפץ שאתה אובססיבי לגביו, ולמה', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 4, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1283, N'F1708', 6, 54, NULL, 3, N'ספר על איסור חמור שאתה משתוקק מאוד  להפר אותו', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 4, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1246, N'F1709', 6, 51, NULL, 3, N'עד כמה כלי הרכב מחרמן אותך? אופנוע הארלי דווידסון `99`, מרצדס ספורט `99`, רכב שטח 4X4 `99`', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 3, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1311, N'F1710', 6, 61, NULL, 3, N'אם האוכל במסעדה לא טעים אבל השירות טוב, איזה טיפ תשאיר למלצר\ית, אם בכלל?', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 3, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1430, N'F1711', 6, 75, NULL, 3, N'עד כמה חצוף בעיניך בבית קפה? לקוח שצועק בסלולרי `99`, קבצן שנכנס לבקש נדבה מהאורחים `99`, לקוחות שנכנסו אחריך מקבלים שירות הרבה לפניך', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 3, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1431, N'F1712', 6, 75, NULL, 3, N'מה היית רוצה לומר בסתר ליבך לאמא שמתעלמת מהצרחות של התינוק שלה באמצע בית קפה?', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 2, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1595, N'F1713', 6, 85, NULL, 3, N'מתי היתה החופשה האחרונה שלך, איפה, ולכמה זמן?', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 3, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1257, N'F1714', 6, 51, NULL, 3, N'אם מותר לך לבחור רק אחד - היית מתקן את החיים האישיים, או המקצועיים שלך? ומה היית מתקן?', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 3, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1519, N'F1715', 6, 78, NULL, 3, N'מהי התקופה הכי טובה בחייך. ולמה?', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 3, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1099, N'F1716', 6, 39, NULL, 3, N'האם יצא לך להישאר בקשר טוב עם אקסית שלך גם אחרי הפרידה?', 0, 1, 1, 18, 99, 4, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 3, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1165, N'F1717', 6, 43, NULL, 3, N'מסאז'' עם שמן `99`, ארוחה במסעדה על צוק בגרנד קניון `99`, לשבת ביציע המכובדים בגמר המונדיאל `99`', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 4, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1542, N'F1718', 6, 84, NULL, 3, N'עד כמה את\ה פוחד\ת מ: לטוס `99`, מקומות גבוהים `99`, מקומות סגורים `99`', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 4, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1543, N'F1719', 6, 84, NULL, 3, N'עד כמה את\ה פוחד\ת מ: ', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 4, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1262, N'F1720', 6, 51, NULL, 3, N'ביקור במוזיאון אמנות `99`, הרצאה על פיסיקת קוונטים `99`, סיור באתר חפירות ארכיאולוגיות `99`', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 3, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1166, N'F1721', 6, 43, NULL, 3, N'אתה צריך לקרוא לסופה בשם של אדם שאתה שונא. מה השם, ומדוע אתה שונא אותו\אותה?', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 2, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1169, N'F1722', 6, 44, NULL, 3, N'האם בכית פעם בגלל פרידה? אם כן, באילו נסיבות?', 0, 1, 1, 18, 99, 4, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 3, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1170, N'F1723', 6, 44, NULL, 3, N'האם בכית פעם בגלל שהפסדת הזדמנות? על מה? ואם לא, איך הגבת אל הפסד הזדמנות?', 0, 1, 1, 18, 99, 4, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 3, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1171, N'F1724', 6, 44, NULL, 3, N'האם בכית פעם בגלל מוות? באילו נסיבות?', 0, 1, 1, 18, 99, 5, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 3, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1172, N'F1725', 6, 44, NULL, 3, N'האם בכית פעם בגלל ריב עם ההורים? אם כן, באילו נסיבות?', 0, 1, 1, 18, 99, 4, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 3, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1548, N'F1726', 6, 85, NULL, 3, N'אחרי תקופה לחוצה, באיזה אופן אתה מרשה לעצמך להתפרק?', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 3, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1256, N'F1727', 6, 51, NULL, 3, N'לאיזו מטרה בא לך לתרום כסף?', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 4, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1520, N'F1728', 6, 78, NULL, 3, N'מהי מערכת היחסים הארוכה ביותר שהיתה לך? מדוע היא הסתיימה?', 0, 1, 1, 18, 99, 5, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 3, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1521, N'F1729', 6, 78, NULL, 3, N'כמה מערכות יחסים היו לך? כמה מתוכן משמעותיות?', 0, 1, 1, 18, 99, 5, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 3, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1522, N'F1730', 6, 78, NULL, 3, N'מה היתה התקופה הארוכה ביותר שלקח לך להתאושש מכאב פרידה?', 0, 1, 1, 18, 99, 5, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 3, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1523, N'F1731', 6, 78, NULL, 3, N'מה היתה התקופה הקצרה ביותר שלקח לך להתאושש מהכאב? ', 0, 1, 1, 18, 99, 5, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 3, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1259, N'F1732', 6, 51, NULL, 3, N'הרכב את אשת חלומותיך - בחר 3 תכונות בלבד מהנ"ל: הומור, כנות, אינטלגנציה, ביטחון עצמי, סקס טוב, מעגל חברתי רחב,  קריירה טובה', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 4, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1260, N'F1733', 6, 51, NULL, 3, N'אשת חלומותי תהיה `99`, וגם `99`, וחייבת להיות `99`', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 4, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1352, N'F1734', 6, 62, NULL, 3, N'על מה תפרק מערכת יחסים?  שקרים `99`, חוסר התאמה בסקס `99`, בעיות תקשורת `99`', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 4, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1353, N'F1735', 6, 62, NULL, 3, N'על מה תפרק מערכת יחסים?  ריבים וצעקות `99`, חוסר כבוד `99`, זלזול `99`', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 4, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1354, N'F1736', 6, 62, NULL, 3, N'על מה תפרק מערכת יחסים?  היעדר ניצוץ `99`, עסוקה מידי בעבודה `99`, לא מרוויחה מספיק `99`', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 4, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1355, N'F1737', 6, 62, NULL, 3, N'אחרי כמה זמן היכרות מותר להגיד "אני אוהבת אותך"?', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 4, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1356, N'F1738', 6, 62, NULL, 3, N'בשדה תעופה - האם אתם נפרדים במהירות, או מושכים פרידה עם מיליון חיבוקים ונשיקות?', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 3, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1357, N'F1739', 6, 62, NULL, 3, N'האם בחורה עשתה לך פעם עוול? אם כן, מהו?', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 3, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1358, N'F1740', 6, 62, NULL, 3, N'בזמן שאתה נמצא במערכת יחסים, האם זה בסדר לדעתך לפלרטט עם נשים אחרות?', 0, 1, 1, 18, 99, 4, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 4, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1359, N'F1741', 6, 62, NULL, 3, N'בזמן שאתה במערכת יחסים איתו, האם זה בסדר מבחינתך שהיא תפלרטט עם גברים אחרים?', 0, 1, 1, 18, 99, 4, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 4, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1670, N'F1742', 6, 91, NULL, 3, N'איפה אתה על הסקאלה? עקשן שקשה להסתדר איתך, או אחד שתמיד מוותר?', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 2, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1258, N'F1744', 6, 51, NULL, 3, N'נניח שאתה חייב להפקיד את הגורל שלך בידי מישהו שיקבע הכל עבורך. מי זה יהיה? (בלי הורים)', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 2, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1524, N'F1745', 6, 78, NULL, 3, N'ספר על משהו אחד שאתה מאוד מתחרט לגביו בחייך', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 3, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1549, N'F1747', 6, 85, NULL, 3, N'על מה חשבת אתמול בלילה לפני השינה?', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 4, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1666, N'F1748', 6, 91, NULL, 3, N'כשרע, כדאי לחשוב על דברים חיוביים אבל לא תמיד זה מצליח. יש לך שיטה אחרת שעובדת עבורך?', 0, 1, 1, 18, 99, 4, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 3, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1667, N'F1749', 6, 91, NULL, 3, N'האם כיום אתה יותר אמפטי כלפי אנשים מאשר פעם, או יותר ביקורתי? ', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 2, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1032, N'F1750', 6, 32, NULL, 3, N'נסח מכתב אהבה הכי דביקי בעולם: אני אוהב אותך כל כך, בשבילי את ה`99` וה`99`, והלוואי ש`99`', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 2, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1360, N'F1751', 6, 62, NULL, 3, N'כשהיית בזוגיות, עד כמה הרגשת  פתוח לדבר על היחסים הזוגיים שלך עם חברים או משפחה?', 0, 1, 1, 18, 99, 4, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 2, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1669, N'F1752', 6, 91, NULL, 3, N'האם אתה בדרך כלל מהדברנים, או מהשתקנים?', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 2, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1361, N'F1753', 6, 62, NULL, 3, N'האם היתה לך מערכת יחסים שבה התקשית לבטוח בה? אם כן, מדוע?', 0, 1, 1, 18, 99, 4, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 3, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1668, N'F1754', 6, 91, NULL, 3, N'האם אתה בדרך כלל נמנע מקונפליקטים, או שאין לך בעיה להתווכח ולעמוד על שלך?', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 3, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1338, N'F1755', 6, 61, NULL, 3, N'עד כמה החדר שלך מסודר עכשיו בזה הרגע?', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 4, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1374, N'F1756', 6, 69, NULL, 3, N'שלח קישור (למשל ל-youtube) של שיר שמרגיע אותך', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 3, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1612, N'F1757', 6, 89, NULL, 3, N'עד כמה אתה אוהב ומשחק משחקי ווידאו? אם כן, איזה משחקים אתה הכי אוהב?', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 2, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1263, N'F1758', 6, 51, NULL, 3, N'במשפט אחד - מהי תכנית 5 השנים שלך?', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 2, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1264, N'F1759', 6, 51, NULL, 3, N'תאר את ארוחת הבוקר שלך', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 4, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1529, N'F1760', 6, 78, NULL, 3, N'ספר על משהו אחד שמגיע לך להיות גאה בו בחייך', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 3, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1530, N'F1761', 6, 78, NULL, 3, N'האם הקרבת אי פעם הקרבה גדולה מאוד למען מישהו אחר? אם כן, איזו הקרבה ולמי?', 0, 1, 1, 18, 99, 4, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 3, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1299, N'F1762', 6, 59, NULL, 3, N'מה דעתך לגבי הריחות הבאים? (כל מילת תואר שעולה לך בראש)', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 3, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1550, N'F1763', 6, 85, NULL, 3, N'פרט (כן, תטרח קצת, לא נורא) את כל זוגות המכנסיים שיש לך בארון, כולל סוג וצבע', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 3, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1300, N'F1764', 6, 59, NULL, 3, N'כמה זה נכון? (לא נכון, קצת, נכון מאוד וכו''...) ', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 3, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1525, N'F1766', 6, 78, NULL, 3, N'תאר מקרה שבו כעסת על ביקורת, אבל אחרי זמן הבנת שהביקורת היתה נכונה', 0, 1, 1, 18, 99, 4, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 3, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1526, N'F1767', 6, 78, NULL, 3, N'האם אתה זוכר מקרה שבו מישהו הוריד לך את הביטחון? מי ועל מה?', 0, 1, 1, 18, 99, 4, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 3, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1344, N'F1768', 6, 62, NULL, 3, N'האם יש לך אקסית שאתה חבר שלה בפייסבוק? אם לא, האם יצא לך להציץ בפייסבוק של אקס?', 0, 1, 1, 18, 99, 5, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 3, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1345, N'F1769', 6, 62, NULL, 3, N'האם חבר או חברה טובים איכזבו אותך פעם? אם כן, במה?', 0, 1, 1, 18, 99, 4, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 3, 1, NULL)
;
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1346, N'F1770', 6, 62, NULL, 3, N'האם ידוע לך על מישהו שמקנא בך? אם כן, מדוע הוא מקנא?', 0, 1, 1, 18, 99, 4, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 3, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1347, N'F1771', 6, 62, NULL, 3, N'האם יצא לך להכיר מישהי בסיטואציה לא רומנטית, ורק אחרי זמן רב (לפחות כמה חודשים) להרגיש לפתע משיכה אליה?', 0, 1, 1, 18, 99, 5, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 3, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1348, N'F1772', 6, 62, NULL, 3, N'עד כמה אתה מרגיש בנוח אם לחברה שלך יש ידידים קרובים?', 0, 1, 1, 18, 99, 4, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 3, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1349, N'F1773', 6, 62, NULL, 3, N'מה היתה הפעם האחרונה שבה אמרת למישהו "מצטער"?', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 3, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1350, N'F1774', 6, 62, NULL, 3, N'האם אתה מרגיש בנוח אם החברה שלך תשמור על קשר עם אקס שלה?', 0, 1, 1, 18, 99, 4, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 4, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1663, N'F1776', 6, 91, NULL, 3, N'עד כמה אתה אסרטיבי? קיבלת חביתה לא ממש חמה מהמלצר\ית. מה תעשה?', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 3, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1527, N'F1778', 6, 78, NULL, 3, N'ספר על פעם שבה עברת על החוק', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 3, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1528, N'F1779', 6, 78, NULL, 3, N'ספר על מקרה שבו לא עשית את מה שאתה תמיד מטיף לעשות', 0, 1, 1, 18, 99, 4, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 2, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1337, N'F1780', 6, 61, NULL, 3, N'ספר על משהו יפה שראית היום', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 4, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1665, N'F1783', 6, 91, NULL, 3, N'האם אתה מחליט וחותך מהר, או שאתה נוהג להתלבט הרבה עד שאתה מחליט?', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 3, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1471, N'F1784', 6, 75, NULL, 3, N'נניח שעכשיו 4 בבוקר. אתה ער. מדוע?', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 4, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1253, N'F1785', 6, 51, NULL, 3, N'דרגו עד כמה את אוהבים את תחנות הרדיו:', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 4, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1167, N'F1786', 6, 43, NULL, 3, N'אתם צריכים לארגן פעילות לדייט הבא שלכם. איך נראות לכם ההצעות הבאות?', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 4, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1467, N'F1787', 6, 75, NULL, 3, N'איך מכעיסים אותך?', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 4, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1468, N'F1788', 6, 75, NULL, 3, N'עד כמה אתה מאמץ את הקונספט שאם פגשת מישהי שווה במיוחד, כדאי לנסות לדחות כמה שיותר את הקטע הפיסי ביניכם.', 0, 1, 1, 18, 99, 5, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 3, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1261, N'F1789', 6, 51, NULL, 3, N'האם לגור עם ההורים זה לא בא בחשבון, או שזה דווא יכול להתאים לפעמים כדי לחסוך כסף?', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 3, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1469, N'F1790', 6, 75, NULL, 3, N'אתה מלצר במסעדה, יש מצב שתאכל מתוך צלחת שלקוח השאיר ולא סיים הכל? ', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 3, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1470, N'F1791', 6, 75, NULL, 3, N'פגשת מישהי נדירה וזה נראה רציני. מיהם שלושת הראשונים שתספר להם על כך?', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 3, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1551, N'F1792', 6, 85, NULL, 3, N'מה התכניות שלך למחר?', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 4, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1351, N'F1793', 6, 62, NULL, 3, N'האם יצא לך להודות שטעית, גם אם חשבת שבכלל לא טעית, רק כדי לסיים באווירה טובה  ויכוח עם אישה?', 0, 1, 1, 18, 99, 4, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 4, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1664, N'F1794', 6, 91, NULL, 3, N'האם אתם נוהגים לאגור חפצים מהעבר, או שאתם מעדיפים לזרוק כמה שיותר?', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 3, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1545, N'F1795', 6, 85, NULL, 3, N'עם מי ואיך חגגת את יום ההולדת האחרון שלך?', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 3, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1546, N'F1796', 6, 85, NULL, 3, N'ממה הופתעת מאוד בזמן האחרון?', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 3, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1473, N'F1797', 6, 75, NULL, 3, N'באיזה מקרה לאחרונה העדפת לסתום את הפה, למרות שהיה לך הרבה מה להגיד? ', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 4, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1364, N'F1798', 6, 65, NULL, 3, N'איך אתה מתנהל עם כספים? אני משלם חשבונות בזמן `99`, אני בודק דפי בנק `99`, אף פעם אין לי מינוס `99`', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 4, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1266, N'F1799', 6, 52, NULL, 3, N'עד כמה את\ה מפונק\ת? אני אוהב לטייל טיולי אוהלים `99`, אני יכול להירדם גם על הרצפה `99`, אני מתקלח גם אם אין מים חמים `99`', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 4, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1339, N'F1800', 6, 61, NULL, 3, N'מה האתגר שלך לשבוע הקרוב?', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 4, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1033, N'F1801', 6, 33, NULL, 3, N'נקניקיה בלחמניה `99`, המבורגר `99`, שווארמה `99`', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 3, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1034, N'F1802', 6, 33, NULL, 3, N'מלוואח או ג''חנון `99`, פיצוחים `99`, גלידה `99`', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 3, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1035, N'F1803', 6, 33, NULL, 3, N'הרכב לעצמך פיצה חלומית גורמה', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 3, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1252, N'F1804', 6, 51, NULL, 3, N'יש לך כסף לשני טיפולי מניקור פדיקור, או שני ג''ינסים, או טלפון סלולרי סיני. במה תבחר? (מותר לך לבקש משהו אחר שעלותו דומה)', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 4, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1547, N'F1805', 6, 85, NULL, 3, N'אני יודע להניע רכב בכבלים `99`, להחליף שקית לשואב אבק `99`, להחליף מיתר לגיטרה `99` ', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 4, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1249, N'F1807', 6, 51, NULL, 3, N'איזה שיר תשירי במקלחת הקרובה שלך?', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 3, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1250, N'F1808', 6, 51, NULL, 3, N'אתה חמוד `99`, אפשר לדבר איתך כמו חבר טוב `99`, יש לך בייבי פייס `99`', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 4, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1251, N'F1809', 6, 51, NULL, 3, N'זה בסדר, אני ממילא לא אוהבת יותר מידי שרירים `99`, אל תהיה לחוץ, דווקא יש לך סבבה `99`, אתה לא כמו כולם `99` ', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 4, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1168, N'F1810', 6, 43, NULL, 3, N'עד כמה תסכימו להיות בני\בנות זוג של: חשפנית `99`, דוגמנית בינלאומית `99`, מדריכת טיולים לחו"ל `99`', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 4, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1475, N'F1811', 6, 75, NULL, 3, N'החבר שלך מודיע לך שהוא מתכוון לנסוע לכנס מקצועי (עם הרבה נשים שעובדות איתו), שם כולם יכנסו עירומים לגמרי למעיינות חמים. מה תגובתך?', 0, 1, 1, 18, 99, 5, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 4, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1186, N'F1812', 6, 46, NULL, 3, N'עד כמה המקצועות הבאים מיותרים בעיניך', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 4, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1187, N'F1813', 6, 46, NULL, 3, N'עד כמה חלומות יכולים לחזות את העתיד, או מנבאים את התשוקות הפנימיות שלנו? מה דעתך?', 0, 1, 1, 18, 99, 5, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 3, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1365, N'F1814', 6, 65, NULL, 3, N'נסי להעריך כמה כסף הוצאת בשנה האחרונה על מוצרי טיפוח? (איפור, בושם, קרמים וכו'')', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 5, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1518, N'F1815', 6, 78, NULL, 3, N'ספר על משהו מיותר לגמרי שעשית בחיים שלך, שהיה סתם בזבוז זמן', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 4, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1342, N'F1816', 6, 62, NULL, 3, N'ליד איזה אנשים אתה מרגיש הכי רגוע ושלא שופטים אותך? (ספר על 2-3) ', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 4, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1343, N'F1817', 6, 62, NULL, 3, N'האם אתה מדמיין מצב שבו תוותר על מעבר לחו"ל לקידום בקריירה, בגלל אהבה? האם קרה לך?', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 4, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1341, N'F1818', 6, 61, NULL, 3, N'למה החיים שלך יפים? החיים שלי יפים כי `999`, וגם בגלל `999`', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 4, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1544, N'F1819', 6, 84, NULL, 3, N'אני פוחד שמחר בבוקר לפתע `999`', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 3, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1474, N'F1820', 6, 75, NULL, 3, N'במה לא מבינים אותך, וזה מתסכל אותך?', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 3, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1340, N'F1821', 6, 61, NULL, 3, N'מה יושב לך על הלב עכשיו?', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 3, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1265, N'F1823', 6, 52, NULL, 3, N'תאר הרגל יומיומי שמרגיע אותך', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 3, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1673, N'F1824', 1, 17, NULL, 3, N'איזו רמת יכולת ריכוז יש לך? עד כמה קל להסיח את דעתך?', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2024-07-27T04:58:42.773' AS DateTime), 3, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1254, N'F1825', 6, 51, NULL, 3, N'להיות עשיר `99`, ללמוד דברים חדשים `99`, שיהיו לי חברים טובים שאפשר לסמוך עליהם `99`', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 4, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1255, N'F1826', 6, 51, NULL, 3, N'לשמור על כושר גופני טוב `99`, לחלוק את חיי עם מישהי `99`, שיגידו לי תמיד שאני נראה מעולה `99`', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 4, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1476, N'F1827', 6, 75, NULL, 3, N'תאר מקרה בו פישלת (למשל, היית צריך לשמור על כלב של חבר, והוא ברח)', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 3, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1671, N'F1828', 6, 91, NULL, 3, N'אני מוכשר מאוד `99`, אני סנוב `99`, החיים שלי מדהימים `99`', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 4, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1672, N'F1829', 6, 91, NULL, 3, N'אני מסתכל על עצמי הרבה במראה `99`, לפעמים אני מרגיש שאני כישלון `99`, אני נוהג לחלום בהקיץ `99`', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:46:32.513' AS DateTime), CAST(N'2023-08-09T10:46:32.513' AS DateTime), 4, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1675, N'P1001', 4, NULL, NULL, 3, N'מה תלבש לדייט? הנח את בגדים על משטח וצלם', 0, 1, 1, 18, 99, 4, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:50:07.270' AS DateTime), CAST(N'2023-08-09T10:50:07.270' AS DateTime), 5, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1676, N'P1002', 4, NULL, NULL, 3, N'צלם את הספר שהיית שם על השולחן כדי שיחשבו שאתה אינטלקטואל', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:50:07.270' AS DateTime), CAST(N'2023-08-09T10:50:07.270' AS DateTime), 5, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1677, N'P1003', 4, NULL, NULL, 3, N'ההורים באים לביקור פתע! צלם את מה שהיית מעלים מהשטח מיידית.', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:50:07.270' AS DateTime), CAST(N'2023-08-09T10:50:07.270' AS DateTime), 5, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1678, N'P1004', 4, NULL, NULL, 3, N'צלם מתנה גרועה שאתה שונא, אבל שומר משום מה.', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:50:07.270' AS DateTime), CAST(N'2023-08-09T10:50:07.270' AS DateTime), 3, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1679, N'P1005', 4, NULL, NULL, 3, N'צלם את פנים ארון הבגדים שלך. ', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:50:07.270' AS DateTime), CAST(N'2023-08-09T10:50:07.270' AS DateTime), 4, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1680, N'P1006', 4, NULL, NULL, 3, N'צלם את הנעליים הכי שוות שלך', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:50:07.270' AS DateTime), CAST(N'2023-08-09T10:50:07.270' AS DateTime), 4, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1681, N'P1007', 4, NULL, NULL, 3, N'צלם את הנעליים הכי מע''פנות שלך. ', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:50:07.270' AS DateTime), CAST(N'2023-08-09T10:50:07.270' AS DateTime), 4, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1682, N'P1008', 4, NULL, NULL, 3, N'צלם את כיור המטבח כפי שהוא נראה כרגע. ', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:50:07.270' AS DateTime), CAST(N'2023-08-09T10:50:07.270' AS DateTime), 4, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1683, N'P1009', 4, NULL, NULL, 3, N'צלם חפץ בדירה שלך שהיית תורם ללא היסוס.', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:50:07.270' AS DateTime), CAST(N'2023-08-09T10:50:07.270' AS DateTime), 5, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1684, N'P1010', 4, NULL, NULL, 3, N'צלם משהו שיתאר את המצב רוח שלך בזה הרגע. ', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:50:07.270' AS DateTime), CAST(N'2023-08-09T10:50:07.270' AS DateTime), 5, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1685, N'P1011', 4, NULL, NULL, 3, N'צלם את שולחן העבודה שלך.', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:50:07.270' AS DateTime), CAST(N'2023-08-09T10:50:07.270' AS DateTime), 5, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1686, N'P1012', 4, NULL, NULL, 3, N'צלם את מדף המקרר שלך.', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:50:07.270' AS DateTime), CAST(N'2023-08-09T10:50:07.270' AS DateTime), 5, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1687, N'P1013', 4, NULL, NULL, 3, N'צלם את כף היד שלך', 0, 1, 1, 18, 99, 4, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:50:07.270' AS DateTime), CAST(N'2023-08-09T10:50:07.270' AS DateTime), 4, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1688, N'P1014', 4, NULL, NULL, 3, N'נניח שתקבל מיליון דולר במזומן, צלם את המקום בו היית מחביא אותם בדירה', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:50:07.270' AS DateTime), CAST(N'2023-08-09T10:50:07.270' AS DateTime), 3, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1689, N'P1015', 4, NULL, NULL, 3, N'צלם בגד שהיית צריך לזרוק מזמן. ', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:50:07.270' AS DateTime), CAST(N'2023-08-09T10:50:07.270' AS DateTime), 5, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1690, N'P1016', 4, NULL, NULL, 3, N'צלם את מדף הספרים שלך (או חלק ממנו), באופן שאפשר יהיה לזהות את כותרי הספרים. ', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:50:07.270' AS DateTime), CAST(N'2023-08-09T10:50:07.270' AS DateTime), 5, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1691, N'P1017', 4, NULL, NULL, 3, N'שלח צילום מסך של מסך הבית שלך ', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:50:07.270' AS DateTime), CAST(N'2023-08-09T10:50:07.270' AS DateTime), 4, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1692, N'P1018', 4, NULL, NULL, 3, N'צלם את המיטה בה אתה ישן. ', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:50:07.270' AS DateTime), CAST(N'2023-08-09T10:50:07.270' AS DateTime), 5, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1693, N'P1019', 4, NULL, NULL, 3, N'צלם את משקפי השמש שלך.', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:50:07.270' AS DateTime), CAST(N'2023-08-09T10:50:07.270' AS DateTime), 5, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1694, N'P1020', 4, NULL, NULL, 3, N'צלם את השמפו ו\או את הסבון בהם אתה משתמש. ', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:50:07.270' AS DateTime), CAST(N'2023-08-09T10:50:07.270' AS DateTime), 5, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1695, N'P1021', 4, NULL, NULL, 3, N'אם אם תיתן את המיטה שלך לאורח בלילה, צלם את המקום בבית שבו אתה תישן. ', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:50:07.270' AS DateTime), CAST(N'2023-08-09T10:50:07.270' AS DateTime), 4, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1696, N'P1022', 4, NULL, NULL, 3, N'צלם משהו כחול', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:50:07.270' AS DateTime), CAST(N'2023-08-09T10:50:07.270' AS DateTime), 4, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1697, N'P1023', 4, NULL, NULL, 3, N'צלם משהו אדום', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:50:07.270' AS DateTime), CAST(N'2023-08-09T10:50:07.270' AS DateTime), 4, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1698, N'P1024', 4, NULL, NULL, 3, N'צלם משהו צהוב', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:50:07.270' AS DateTime), CAST(N'2023-08-09T10:50:07.270' AS DateTime), 4, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1699, N'P1025', 4, NULL, NULL, 3, N'צלם משהו שחור', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:50:07.270' AS DateTime), CAST(N'2023-08-09T10:50:07.270' AS DateTime), 4, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1700, N'P1026', 4, NULL, NULL, 3, N'צלם משהו לבן', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:50:07.270' AS DateTime), CAST(N'2023-08-09T10:50:07.270' AS DateTime), 4, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1701, N'P1027', 4, NULL, NULL, 3, N'צלם משהו ירוק', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:50:07.270' AS DateTime), CAST(N'2023-08-09T10:50:07.270' AS DateTime), 4, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1702, N'P1028', 4, NULL, NULL, 3, N'צייר איש\ה על דף נייר, צלם ושלח. ', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:50:07.270' AS DateTime), CAST(N'2023-08-09T10:50:07.270' AS DateTime), 4, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1703, N'P1029', 4, NULL, NULL, 3, N'כתוב על דף נייר משפט כלשהו, צלם ושלח', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:50:07.270' AS DateTime), CAST(N'2023-08-09T10:50:07.270' AS DateTime), 4, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1704, N'P1030', 4, NULL, NULL, 3, N'צייר בית על דף נייר, צלם ושלח', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:50:07.270' AS DateTime), CAST(N'2023-08-09T10:50:07.270' AS DateTime), 4, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1705, N'P1031', 4, NULL, NULL, 3, N'צייר על דף נייר פרצוף מחייך סמיילי, צלם ושלח', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:50:07.270' AS DateTime), CAST(N'2023-08-09T10:50:07.270' AS DateTime), 4, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1706, N'P1032', 4, NULL, NULL, 3, N'שלח תמונה כלשהי מהגלריה (מבלי לחשוף שום דבר לא רצוי, כמובן)', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:50:07.270' AS DateTime), CAST(N'2023-08-09T10:50:07.270' AS DateTime), 4, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1707, N'P1033', 4, NULL, NULL, 3, N'צלם משהו מהמקום בו אתה נמצא עכשיו', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:50:07.270' AS DateTime), CAST(N'2023-08-09T10:50:07.270' AS DateTime), 5, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1708, N'P1034', 4, NULL, NULL, 3, N'צלם את כוס הקפה שלך', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:50:07.270' AS DateTime), CAST(N'2023-08-09T10:50:07.270' AS DateTime), 4, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1709, N'P1035', 4, NULL, NULL, 3, N'צלם את ארוחת הבוקר שלך', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:50:07.270' AS DateTime), CAST(N'2023-08-09T10:50:07.270' AS DateTime), 4, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1710, N'P1036', 4, NULL, NULL, 3, N'אתה יוצא מהבית לרחוב - צלם את מה שאתה רואה', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:50:07.270' AS DateTime), CAST(N'2023-08-09T10:50:07.270' AS DateTime), 4, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1711, N'P1037', 4, NULL, NULL, 3, N'צלם רהיט בבית שלך', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:50:07.270' AS DateTime), CAST(N'2023-08-09T10:50:07.270' AS DateTime), 4, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1712, N'P1038', 4, NULL, NULL, 3, N'צלם קישוט על הקיר בחדר שלך', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:50:07.270' AS DateTime), CAST(N'2023-08-09T10:50:07.270' AS DateTime), 4, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1713, N'P1039', 4, NULL, NULL, 3, N'הסתכל מהחלון בדירה\בית - צלם מה שאתה רואה', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:50:07.270' AS DateTime), CAST(N'2023-08-09T10:50:07.270' AS DateTime), 4, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1714, N'P1040', 4, NULL, NULL, 3, N'צלם אחד מהתמרוקים שלך (גילוח, דיאודורנט, וכו''...)', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:50:07.270' AS DateTime), CAST(N'2023-08-09T10:50:07.270' AS DateTime), 4, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1715, N'P1041', 4, NULL, NULL, 3, N'פתח מגירה וצלם את מה שבפנים', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:50:07.270' AS DateTime), CAST(N'2023-08-09T10:50:07.270' AS DateTime), 3, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1716, N'P1042', 4, NULL, NULL, 3, N'צלם חפץ בבית שאתה נוהג להעביר איתו זמן פנוי', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:50:07.270' AS DateTime), CAST(N'2023-08-09T10:50:07.270' AS DateTime), 4, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1717, N'P1043', 4, NULL, NULL, 3, N'צלם זו גרביים נקיות שלך', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:50:07.270' AS DateTime), CAST(N'2023-08-09T10:50:07.270' AS DateTime), 2, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1718, N'P1044', 4, NULL, NULL, 3, N'צלם חפץ שאיתו אתה מתקן דברים', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:50:07.270' AS DateTime), CAST(N'2023-08-09T10:50:07.270' AS DateTime), 3, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1719, N'P1045', 4, NULL, NULL, 3, N'צלם מכנסיים קצרות שלך', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:50:07.270' AS DateTime), CAST(N'2023-08-09T10:50:07.270' AS DateTime), 5, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1720, N'P1046', 4, NULL, NULL, 3, N'צלם מכנסיים ארוכות שלך', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:50:07.270' AS DateTime), CAST(N'2023-08-09T10:50:07.270' AS DateTime), 5, 1, NULL)
;
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1721, N'P1047', 4, NULL, NULL, 3, N'צלם חולצת יום יום שלך', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:50:07.270' AS DateTime), CAST(N'2023-08-09T10:50:07.270' AS DateTime), 5, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1722, N'P1048', 4, NULL, NULL, 3, N'צלם נעלי ספורט שלך', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:50:07.270' AS DateTime), CAST(N'2023-08-09T10:50:07.270' AS DateTime), 5, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1723, N'P1049', 4, NULL, NULL, 3, N'צלם משהו לאכול שאתה מנשנש כשאתה במצב רוח רע', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:50:07.270' AS DateTime), CAST(N'2023-08-09T10:50:07.270' AS DateTime), 4, 1, NULL);
INSERT `pwm`.`net_Tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES (1724, N'P1050', 4, NULL, NULL, 3, N'אם יש לך קעקוע איפשהו על הגוף, צלם אותו, אם לא, צלם איפה שהיית שם קעקוע בגוף ', 0, 1, 1, 18, 99, 4, 5, 5, 5, 5, 5, CAST(N'2023-08-09T10:50:07.270' AS DateTime), CAST(N'2023-08-09T10:50:07.270' AS DateTime), 3, 1, NULL);

INSERT `pwm`.`net_TaskStatus` (`Id`, `Description`) VALUES (1, N'Draft 1');
INSERT `pwm`.`net_TaskStatus` (`Id`, `Description`) VALUES (2, N'Draft 2');
INSERT `pwm`.`net_TaskStatus` (`Id`, `Description`) VALUES (3, N'Approved ');
INSERT `pwm`.`net_TaskStatus` (`Id`, `Description`) VALUES (4, N'Cancelled');

INSERT `pwm`.`net_TaskSubSubType` (`Id`, `SubType`, `Description`) VALUES (5, 17, N'q2 s1 ss1');
INSERT `pwm`.`net_TaskSubSubType` (`Id`, `SubType`, `Description`) VALUES (10, 17, N'q2 s1 ss2');
INSERT `pwm`.`net_TaskSubSubType` (`Id`, `SubType`, `Description`) VALUES (11, 2, N'q3-image-ss1');
INSERT `pwm`.`net_TaskSubSubType` (`Id`, `SubType`, `Description`) VALUES (12, 3, N'q4-image-ss1');
INSERT `pwm`.`net_TaskSubSubType` (`Id`, `SubType`, `Description`) VALUES (13, 4, N'photo s1 ss1');
INSERT `pwm`.`net_TaskSubSubType` (`Id`, `SubType`, `Description`) VALUES (14, 28, N'הולכי 4');

INSERT `pwm`.`net_TaskSubType` (`Id`, `TypeId`, `Description`) VALUES (2, 2, N'Image');
INSERT `pwm`.`net_TaskSubType` (`Id`, `TypeId`, `Description`) VALUES (3, 3, N'Image');
INSERT `pwm`.`net_TaskSubType` (`Id`, `TypeId`, `Description`) VALUES (4, 4, N'צילומי אנשים');
INSERT `pwm`.`net_TaskSubType` (`Id`, `TypeId`, `Description`) VALUES (5, 5, N'Image');
INSERT `pwm`.`net_TaskSubType` (`Id`, `TypeId`, `Description`) VALUES (17, 1, N'מי לוקח');
INSERT `pwm`.`net_TaskSubType` (`Id`, `TypeId`, `Description`) VALUES (18, 1, N'Q2 s2');
INSERT `pwm`.`net_TaskSubType` (`Id`, `TypeId`, `Description`) VALUES (20, 6, N'New');
INSERT `pwm`.`net_TaskSubType` (`Id`, `TypeId`, `Description`) VALUES (21, 6, N'TEST');
INSERT `pwm`.`net_TaskSubType` (`Id`, `TypeId`, `Description`) VALUES (26, 1, N'Q2 s3');
INSERT `pwm`.`net_TaskSubType` (`Id`, `TypeId`, `Description`) VALUES (27, 4, N'צילומי נוף');
INSERT `pwm`.`net_TaskSubType` (`Id`, `TypeId`, `Description`) VALUES (28, 4, N'צילומי חיות');
INSERT `pwm`.`net_TaskSubType` (`Id`, `TypeId`, `Description`) VALUES (29, 6, N'אם היית');
INSERT `pwm`.`net_TaskSubType` (`Id`, `TypeId`, `Description`) VALUES (31, 6, N'SMS');
INSERT `pwm`.`net_TaskSubType` (`Id`, `TypeId`, `Description`) VALUES (32, 6, N'אהבה');
INSERT `pwm`.`net_TaskSubType` (`Id`, `TypeId`, `Description`) VALUES (33, 6, N'אוכל');
INSERT `pwm`.`net_TaskSubType` (`Id`, `TypeId`, `Description`) VALUES (34, 6, N'אומרים עלי');
INSERT `pwm`.`net_TaskSubType` (`Id`, `TypeId`, `Description`) VALUES (35, 6, N'אישי');
INSERT `pwm`.`net_TaskSubType` (`Id`, `TypeId`, `Description`) VALUES (36, 6, N'אם ');
INSERT `pwm`.`net_TaskSubType` (`Id`, `TypeId`, `Description`) VALUES (37, 6, N'אני לא מבין');
INSERT `pwm`.`net_TaskSubType` (`Id`, `TypeId`, `Description`) VALUES (38, 6, N'אף פעם לא');
INSERT `pwm`.`net_TaskSubType` (`Id`, `TypeId`, `Description`) VALUES (39, 6, N'אקס');
INSERT `pwm`.`net_TaskSubType` (`Id`, `TypeId`, `Description`) VALUES (40, 6, N'ארוחת ערב');
INSERT `pwm`.`net_TaskSubType` (`Id`, `TypeId`, `Description`) VALUES (41, 6, N'בא לי');
INSERT `pwm`.`net_TaskSubType` (`Id`, `TypeId`, `Description`) VALUES (42, 6, N'בגדים');
INSERT `pwm`.`net_TaskSubType` (`Id`, `TypeId`, `Description`) VALUES (43, 6, N'בחירה');
INSERT `pwm`.`net_TaskSubType` (`Id`, `TypeId`, `Description`) VALUES (44, 6, N'בכי');
INSERT `pwm`.`net_TaskSubType` (`Id`, `TypeId`, `Description`) VALUES (45, 6, N'דייט');
INSERT `pwm`.`net_TaskSubType` (`Id`, `TypeId`, `Description`) VALUES (46, 6, N'דעות');
INSERT `pwm`.`net_TaskSubType` (`Id`, `TypeId`, `Description`) VALUES (47, 6, N'דרוג');
INSERT `pwm`.`net_TaskSubType` (`Id`, `TypeId`, `Description`) VALUES (48, 6, N'הורים');
INSERT `pwm`.`net_TaskSubType` (`Id`, `TypeId`, `Description`) VALUES (49, 6, N'הייתי');
INSERT `pwm`.`net_TaskSubType` (`Id`, `TypeId`, `Description`) VALUES (50, 6, N'הנדימן');
INSERT `pwm`.`net_TaskSubType` (`Id`, `TypeId`, `Description`) VALUES (51, 6, N'העדפות');
INSERT `pwm`.`net_TaskSubType` (`Id`, `TypeId`, `Description`) VALUES (52, 6, N'הרגלים');
INSERT `pwm`.`net_TaskSubType` (`Id`, `TypeId`, `Description`) VALUES (53, 6, N'חופשה');
INSERT `pwm`.`net_TaskSubType` (`Id`, `TypeId`, `Description`) VALUES (54, 6, N'חטאים');
INSERT `pwm`.`net_TaskSubType` (`Id`, `TypeId`, `Description`) VALUES (55, 6, N'חלום');
INSERT `pwm`.`net_TaskSubType` (`Id`, `TypeId`, `Description`) VALUES (56, 6, N'חרטה');
INSERT `pwm`.`net_TaskSubType` (`Id`, `TypeId`, `Description`) VALUES (57, 6, N'חשוב או לא');
INSERT `pwm`.`net_TaskSubType` (`Id`, `TypeId`, `Description`) VALUES (58, 6, N'טלוויזיה');
INSERT `pwm`.`net_TaskSubType` (`Id`, `TypeId`, `Description`) VALUES (59, 6, N'טעם');
INSERT `pwm`.`net_TaskSubType` (`Id`, `TypeId`, `Description`) VALUES (60, 6, N'יודע לבשל');
INSERT `pwm`.`net_TaskSubType` (`Id`, `TypeId`, `Description`) VALUES (61, 6, N'יום יום');
INSERT `pwm`.`net_TaskSubType` (`Id`, `TypeId`, `Description`) VALUES (62, 6, N'יחסים');
INSERT `pwm`.`net_TaskSubType` (`Id`, `TypeId`, `Description`) VALUES (63, 6, N'ילדות');
INSERT `pwm`.`net_TaskSubType` (`Id`, `TypeId`, `Description`) VALUES (64, 6, N'יצירתי');
INSERT `pwm`.`net_TaskSubType` (`Id`, `TypeId`, `Description`) VALUES (65, 6, N'כסף');
INSERT `pwm`.`net_TaskSubType` (`Id`, `TypeId`, `Description`) VALUES (66, 6, N'לבוש');
INSERT `pwm`.`net_TaskSubType` (`Id`, `TypeId`, `Description`) VALUES (67, 6, N'לוק');
INSERT `pwm`.`net_TaskSubType` (`Id`, `TypeId`, `Description`) VALUES (68, 6, N'מה עדיף');
INSERT `pwm`.`net_TaskSubType` (`Id`, `TypeId`, `Description`) VALUES (69, 6, N'מוסיקה');
INSERT `pwm`.`net_TaskSubType` (`Id`, `TypeId`, `Description`) VALUES (70, 6, N'מי');
INSERT `pwm`.`net_TaskSubType` (`Id`, `TypeId`, `Description`) VALUES (71, 6, N'מיסטיקה');
INSERT `pwm`.`net_TaskSubType` (`Id`, `TypeId`, `Description`) VALUES (72, 6, N'מפחיד');
INSERT `pwm`.`net_TaskSubType` (`Id`, `TypeId`, `Description`) VALUES (73, 6, N'משפחה');
INSERT `pwm`.`net_TaskSubType` (`Id`, `TypeId`, `Description`) VALUES (74, 6, N'ניקיון');
INSERT `pwm`.`net_TaskSubType` (`Id`, `TypeId`, `Description`) VALUES (75, 6, N'סיטואציות');
INSERT `pwm`.`net_TaskSubType` (`Id`, `TypeId`, `Description`) VALUES (76, 6, N'סקאלה');
INSERT `pwm`.`net_TaskSubType` (`Id`, `TypeId`, `Description`) VALUES (77, 6, N'עבודה');
INSERT `pwm`.`net_TaskSubType` (`Id`, `TypeId`, `Description`) VALUES (78, 6, N'עבר');
INSERT `pwm`.`net_TaskSubType` (`Id`, `TypeId`, `Description`) VALUES (79, 6, N'עד שזה מגיע ל');
INSERT `pwm`.`net_TaskSubType` (`Id`, `TypeId`, `Description`) VALUES (80, 6, N'עונש');
INSERT `pwm`.`net_TaskSubType` (`Id`, `TypeId`, `Description`) VALUES (81, 6, N'עונש מתאים');
INSERT `pwm`.`net_TaskSubType` (`Id`, `TypeId`, `Description`) VALUES (82, 6, N'עצב');
INSERT `pwm`.`net_TaskSubType` (`Id`, `TypeId`, `Description`) VALUES (83, 6, N'עצבים');
INSERT `pwm`.`net_TaskSubType` (`Id`, `TypeId`, `Description`) VALUES (84, 6, N'פחד');
INSERT `pwm`.`net_TaskSubType` (`Id`, `TypeId`, `Description`) VALUES (85, 6, N'פרטים');
INSERT `pwm`.`net_TaskSubType` (`Id`, `TypeId`, `Description`) VALUES (86, 6, N'קללות');
INSERT `pwm`.`net_TaskSubType` (`Id`, `TypeId`, `Description`) VALUES (87, 6, N'קנאה');
INSERT `pwm`.`net_TaskSubType` (`Id`, `TypeId`, `Description`) VALUES (88, 6, N'רגשות');
INSERT `pwm`.`net_TaskSubType` (`Id`, `TypeId`, `Description`) VALUES (89, 6, N'תחביבים');
INSERT `pwm`.`net_TaskSubType` (`Id`, `TypeId`, `Description`) VALUES (90, 6, N'תיכון');
INSERT `pwm`.`net_TaskSubType` (`Id`, `TypeId`, `Description`) VALUES (91, 6, N'תכונות');

INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1309, N'F1001', 1, N'עד כמה נכונים בעיניך המשפטים הבאים: (מאוד, בכלל לא, קצת וכו''...)', N'עד כמה נכונים בעיניך המשפטים הבאים: (מאוד, בכלל לא, קצת וכו''...)', NULL, NULL);
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1310, N'F1002', 1, N'עד כמה נכונים בעיניך המשפטים הבאים: (מאוד, בכלל לא, קצת וכו''...)', N'עד כמה נכונים בעיניך המשפטים הבאים: (מאוד, בכלל לא, קצת וכו''...)', NULL, NULL);
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1311, N'F1003', 1, N'בוא נראה כמה אתה ירוק! עד כמה נכונים המשפטים הבאים? (בכלל לא, מאוד, קצת, וכו''...) ', N'בואי נראה כמה את ירוקה! עד כמה נכונים המשפטים הבאים? (בכלל לא, מאוד, קצת, וכו''...) ', NULL, NULL);
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1312, N'F1004', 1, N'עד כמה נכונים המשפטים הבאים? (בכלל לא, מאוד, קצת, וכו''...) ', N'עד כמה נכונים המשפטים הבאים? (בכלל לא, מאוד, קצת, וכו''...) ', NULL, NULL);
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1313, N'F1005', 1, N'בוא נראה כמה אתה יזם באופי! עד כמה נכונים המשפטים הבאים? (הרבה, קצת, בכלל לא, תמיד, וכו''...) ', N'בוא נראה כמה את יזמת באופי! עד כמה נכונים המשפטים הבאים? (הרבה, קצת, בכלל לא, תמיד, וכו''...) ', NULL, NULL);
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1314, N'F1006', 1, N'תאר במדויק את הלבוש שלך במסיבה האחרונה שרקדת בה', N'תארי במדויק את הלבוש שלך במסיבה האחרונה שרקדת בה', NULL, N'תאר\י במדויק את הלבוש שלך במסיבה האחרונה שרקדת בה');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1315, N'F1007', 1, N'כשתתחתן, האם אתה בקטע של חתונה עם לימוזינה ופאר, או שאתה אוהב משהו צנוע יותר?', N'כשתתחתני, האם את בקטע של חתונה עם לימוזינה ופאר, או שאת אוהבת משהו צנוע יותר?', NULL, N'בחתונה, האם אתם בקטע של לימוזינה ופאר, או משהו צנוע יותר?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1316, N'F1008', 1, N'אם תדע שלבחורה שמוצאת חן בעיניך יש מחזר  נוסף, והיא מתלבטת ביניכם, האם תנסה להתחרות על ליבה, או שתוותר מראש?', N'אם תדעי שלגבר שמוצא חן בעיניך יש מחזרת  נוספת, והוא מתלבט ביניכן, האם תנסי להתחרות על ליבו, או שתוותרי מראש?', NULL, N'אם הצד השני מתלבט ביניכם לבין עוד מישהו\י, האם תנסי להתחרות, או שתוותרו מראש?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1317, N'F1009', 1, N'באיזה אופן הכי קל לך לתקשר ולהרגיש נוח מול בחורה שאתה לא מכיר? (זה יכול להיות כל דבר, למשל - משחק טניס, פתירת תשבץ היגיון ביחד, צפיה באירוויזיון, וכו''...)', N'באיזה אופן הכי קל לך לתקשר ולהרגיש נוח מול גבר זר שאת לא מכירה? (זה יכול להיות כל דבר, למשל - משחק טניס, פתירת תשבץ היגיון ביחד, צפיה באירוויזיון, וכו''...)', NULL, N'באיזה אופן הכי קל לך להתבטא ולתקשר מול גבר\אישה שאת\ה לא מכיר\הה? ');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1318, N'F1010', 1, N'האם קרה לך שהכל נראה שחור בלילה, אבל בבבוקר היית הרבה יותר מעודד? אם כן, במה היה מדובר?', N'האם קרה לך שהכל נראה שחור בלילה, אבל בבבוקר היית הרבה יותר מעודדת? אם כן, במה היה מדובר?', NULL, N'האם קרה לך שהכל נראה שחור בלילה, אבל בבבוקר היית הרבה יותר מעודד\ת? אם כן, במה היה מדובר?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1319, N'F1011', 1, N'האם אתה מסוגל להירדם תוך כדי התכבלות עם מישהי, או שאתה זקוק למרחב שלך?', N'האם את מסוגלת להירדם תוך כדי התכרבלות עם מישהו, או שאת זקוקה למרחב שלך?', NULL, N'האם אתם מסוגלים להירדם תוך כדי התכרבלות עם מישהו\י, או שאתם זקוקים למרחב שלכם?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1320, N'F1012', 1, N'באיזה תחומים הזיכרון שלך הכי טוב? למשל, פרצופים, שמות, מספרים, זיכרון רגשי, וכו''...', N'באיזה תחומים הזיכרון שלך הכי טוב? למשל, פרצופים, שמות, מספרים, זיכרון רגשי, וכו''...', NULL, N'באיזה תחומים הזיכרון שלך הכי טוב? למשל, פרצופים, שמות, מספרים, זיכרון רגשי, וכו''...');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1321, N'F1014', 1, N'אילו אפליקציות אתה בודק בסלולרי דבר ראשון אחרי שאתה מתעורר בבוקר?', N'אילו אפליקציות את בודדקת בסלולרי דבר ראשון אחרי שאת מתעוררת בבוקר?', NULL, N'אילו אפליקציות אתם בודקים בסלולרי דבר ראשון אחרי שאתם מתעוררים בבוקר?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1322, N'F1015', 1, N'האם אתה מרגיש טוב עם זה שהחברה שלך תצא לפגישות עם ידידים גברים אחד על אחד, רק שניהם, בערב?', N'האם את מרגישה טוב עם זה שהחבר שלך ייצא לפגישות עם ידידות אחד על אחד, רק שניהם,  בערב?', NULL, N'איך אתם מרגישים עם זה שהחבר\ה ייצא עם ידידים\ידידות לפגישות אחד על אחד בערב?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1323, N'F1016', 1, N'איך אתה ישן? על הבטן, על הגב, על הצד? עם כמה כריות, וכמה פעמים אתה מתעורר בכל לילה בממוצע?', N'איך את ישנה? על הבטן, על הגב, על הצד? עם כמה כריות, וכמה פעמים את מתעוררת בכל לילה בממוצע?', NULL, N'איך אתם ישינים? על הגב, על הבטן, על הצד? עם כמה כריות, וכמה פעמים אתם מתעוררים בלילה?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1324, N'F1017', 1, N'עד כמה נכונים המשפטים הבאים? (לא נכון, נכון, קצת, וכו''...) ', N'עד כמה נכונים המשפטים הבאים? (לא נכון, נכון, קצת, וכו''...) ', NULL, NULL);
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1325, N'F1018', 1, N'אילו שלושה מאכלים אין סיכוי שתאכל', N'אילו שלושה מאכלים אין סיכוי שתאכלי', NULL, N'אילו שלושה מאכלים אין סיכוי שתאכל\י');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1326, N'F1022', 1, N'פינת ההמלצה:', N'פינת ההמלצה:', NULL, NULL);
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1327, N'F1023', 1, N'פינת ההמלצה:', N'פינת ההמלצה:', NULL, NULL);
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1328, N'F1024', 1, N'איזה דבר אחד יכול לעשות לך טרן אוף אצל אישה?', N'איזה דבר אחד יכול לעשות לך טרן אוף אצל גבר?', NULL, N'איזה דבר אחד יכול לעשות לך טרן אוף אצל גבר\אישה?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1329, N'F1025', 1, N'איזה אדם שמעורב בחיים שלך אתה מעריץ בענק?', N'איזה אדם שמעורב בחיים שלך את מעריצה בענק?', NULL, N'איזה אדם שמעורב בחיים שלכים אתם מעריצים בענק?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1330, N'F1026', 1, N'מה הדבר הכי מצחיק שקרה לך אי פעם בדייט?', N'מה הדבר הכי מצחיק שקרה לך אי פעם בדייט?', NULL, N'מה הדבר הכי מצחיק שקרה לך אי פעם בדייט?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1331, N'F1027', 1, N'מה הדבר הכי הזוי שקרה לך אי פעם בדייט?', N'מה הדבר הכי הזוי שקרה לך אי פעם בדייט?', NULL, N'מה הדבר הכי הזוי שקרה לך אי פעם בדייט?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1332, N'F1029', 1, N'מהי המתנה הכי לא שווה ולא מתאימה שקיבלת? ', N'מהי המתנה הכי לא שווה ולא מתאימה שקיבלת? ', NULL, N'מהי המתנה הכי לא שווה ולא מתאימה שקיבלת? ');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1333, N'F1030', 1, N'אם היתה לך גישה ללא הגבלת זמן או כסף לקניות חופשיות בחנות אחת. איזו חנות זו היתה? ', N'אם היתה לך גישה ללא הגבלת זמן או כסף לקניות חופשיות בחנות אחת. איזו חנות זו היתה? ', NULL, N'אם היתה לך גישה ללא הגבלת זמן או כסף לחנות אחת. איזו חנות זו היתה? ');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1334, N'F1031', 1, N'איזה הרגל מעצבן יש לך, שמישהו או מישהי שחי לידך מספיק זמן היה מעיד עליו?', N'איזה הרגל מעצבן יש לך, שמישהו או מישהי שחי לידך מספיק זמן היה מעיד עליו?', NULL, N'איזה הרגל מעצבן יש לך, שמישהו או מישהי שחי לידך מספיק זמן היה מעיד עליו?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1335, N'F1032', 1, N'בוא תהיה רגע בטלוויזיה', N'בואי תהיי רגע בטלוויזיה', NULL, NULL);
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1336, N'F1033', 1, N'יש לך משימה להיות מיליונר תוך 5 שנים. מה התכנית שלך כדי להשיג את זה?', N'יש לך משימה להיות מיליונרית תוך 5 שנים. מה התכנית שלך כדי להשיג את זה?', NULL, N'יש לך משימה להיות מיליונר\ית תוך 5 שנים. מה התכנית שלך?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1337, N'F1034', 1, N'איזה חוק שאינו קיים בספר החוקים, היית מחוקק בעצמך לו יכולת?', N'איזה חוק שאינו קיים בספר החוקים, היית מחוקקת בעצמך לו יכולת?', NULL, N'איזה חוק שאינו קיים בספר החוקים, היית מחוקק\ת בעצמך לו יכולת?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1338, N'F1035', 1, N'מהו הדבר הכי מטופש שעשית אי פעם בחייך', N'מהו הדבר הכי מטופש שעשית אי פעם בחייך', NULL, N'מהו הדבר הכי מטופש שעשית אי פעם בחייך');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1339, N'F1036', 1, N'הולכים לים', N'הולכים לים', NULL, NULL);
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1340, N'F1037', 1, N'מהו הדבר הכי מצחיק שקרה לך השבוע?', N'מהו הדבר הכי מצחיק שקרה לך השבוע?', NULL, N'מהו הדבר הכי מצחיק שקרה לך השבוע?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1341, N'F1038', 1, N'מהו הטיפ הגבוה ביותר שהשראת למלצר\ית, ומה היה כל כך מיוחד?', N'מהו הטיפ הגבוה ביותר שהשראת למלצר\ית, ומה היה כל כך מיוחד?', NULL, N'מהו הטיפ הגבוה ביותר שהשראת למלצר\ית, ומה היה כל כך מיוחד?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1342, N'F1039', 1, N'הרכב לך אישה עם 5 תכונות מהרשימה שלפניך, כשחייבות להופיע לפחות 2 תכונות שליליות: יפה, חכמה, אתלטית, עשירה, יודעת להקשיב, חייכנית עם גישה חיובית - מכוערת, טיפשה, בלי גרוש, לא קשובה, מרירה עם גישה שלילית (מותר להיות יצירתי ולהמציא בעצמך)', N'הרכיבי לך גבר עם 5 תכונות מהרשימה שלפניך, כשחייבות להופיע לפחות 2 תכונות שליליות: יפה, חכם, אתלטי, עשיר, יודע להקשיב, חייכני עם גישה חיובית - מכוער, טיפש, בלי גרוש, לא קשוב, מרירה עם גישה שלילית. (מותר להיות יצירתית ולהמציא בעצמך)', NULL, N'הרכיבו בן\בת זוג עם 5 תכונות מהרשימה');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1343, N'F1040', 1, N'עד כמה נעים לך? (מאוד, בכלל לא, קצת וכו''...) ', N'עד כמה נעים לך? (מאוד, בכלל לא, קצת וכו''...) ', NULL, N'עד כמה נעים לך? ');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1344, N'F1041', 1, N'עם מי אתה מתייעץ בבחירת התחתונים שלך?', N'עם מי את מתייעצת בבחירת החזיות\תחתונים שלך?', NULL, N'עם מי אתם מתייעצים בבחירת הבגדים התחתונים שלכם?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1345, N'F1042', 1, N'כן או לא? ', N'כן או לא? ', NULL, NULL);
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1346, N'F1043', 1, N'מהי המחמאה הכי גדולה שמישהו נתן לך בזמן האחרון?', N'מהי המחמאה הכי גדולה שמישהו נתן לך בזמן האחרון?', NULL, N'מהי המחמאה הכי גדולה שמישהו נתן לך בזמן האחרון?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1347, N'F1044', 1, N'אם תוכל להיות בכל גיל שתבחר למשך שבוע, מה תבחר ומה תעשה בשבוע הזה?', N'אם תוכלי להיות בכל גיל שתבחרי למשך שבוע, מה תבחרי ומה תעשי בשבוע הזה?', NULL, N'אם תוכל\י להיות בכל גיל שתבחר\י למשך שבוע, מה תבחר\י ומה תעשה\י בשבוע הזה?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1348, N'F1045', 1, N'מה עשית בדיוק לפני שעה?', N'מה עשית בדיוק לפני שעה?', NULL, N'מה עשית בדיוק לפני שעה?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1349, N'F1046', 1, N'מהו הזמן הממושך ביותר בו לא ישנת, ומה היתה הסיבה?', N'מהו הזמן הממושך ביותר בו לא ישנת, ומה היתה הסיבה?', NULL, N'מהו הזמן הממושך ביותר בו לא ישנת, ומה היתה הסיבה?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1350, N'F1047', 1, N'געגוע', N'געגוע', NULL, NULL);
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1351, N'F1048', 1, N'עד כמה מרתיעה אותך (או מושכת אותך) מישהי שבפוקוס חזק על הלוק שלה (שיער, בגדים, מוצרי טיפוח וכו''..) ', N'עד כמה מרתיע אותך (או מושך אותך) מישהו שבפוקוס חזק על הלוק שלו (שיער, בגדים, מוצרי טיפוח וכו''...)', NULL, N'עד כמה מרתיע אותך (או מושך אותך) מישהו\י שבפוקוס חזק על הלוק שלו\שלה?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1352, N'F1049', 1, N'התאהבות', N'התאהבות', NULL, NULL);
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1353, N'F1050', 1, N'מתי בפעם האחרונה אמרו לך שאתה מטורף (או משוגע, או מחורפן), ולמה?', N'מתי בפעם האחרונה אמרו לך שאת מטורפת (או משוגעת, או מחורפנת), ולמה?', NULL, N'מתי בפעם האחרונה אמרו לכם שאתם מטורפים (או משוגעים או מחורפנים), ולמה?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1354, N'F1051', 1, N'מה אתה אומר על המשפט: "נשים אוהבות שגברים מתאמצים לכבוש אותן, כי הן לא אלא רוצה שהגבר יקבל שום דבר בחינם". ', N'מה את אומרת על המשפט: "נשים אוהבות שגברים מתאמצים לכבוש אותן, כי הן לא אלא רוצה שהגבר יקבל שום דבר בחינם". ', NULL, N'מה את\ה אומר\ת על המשפט: "נשים אוהבות שגברים מתאמצים לכבוש אותן, כי הן לא אלא רוצה שהגבר יקבל שום דבר בחינם". ');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1355, N'F1052', 1, N'מה אתה אומר על המשפט: "גברים שמשחקים נכון את המשחק, יצליחו לכבוש יותר בחורות"', N'מה את אומרת על המשפט: "גברים שמשחקים נכון את המשחק, יצליחו לכבוש יותר בחורות"', NULL, N'מה את\ה אומר\ת על המשפט: "גברים שמשחקים נכון את המשחק, יצליחו לכבוש יותר בחורות"');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1356, N'F1053', 1, N'הרגלים', N'הרגלים', NULL, NULL);
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1357, N'F1054', 1, N'עד כמה אתה אוהב את הממרחים הבאים? (בכלל לא, מאוד, קצת וכו''...) ', N'עד כמה את אוהבת את הממרחים הבאים? (בכלל לא, מאוד, קצת וכו''...) ', NULL, NULL);
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1358, N'F1159', 1, N'השלם את החסר', N'השלימי את החסר', NULL, NULL);
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1359, N'F1160', 1, N'השלם את החסר', N'השלימי את החסר', NULL, NULL);
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1360, N'F1161', 1, N'השלם את החסר', N'השלימי את החסר', NULL, NULL);
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1361, N'F1162', 1, N'השלם את החסר', N'השלימי את החסר', NULL, NULL);
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1362, N'F1163', 1, N'השלם את החסר', N'השלימי את החסר', NULL, NULL);
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1363, N'F1164', 1, N'השלם את החסר', N'השלימי את החסר', NULL, NULL);
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1364, N'F1165', 1, N'השלם את החסר', N'השלימי את החסר', NULL, NULL);
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1365, N'F1168', 1, N'איזו תכנית טלווזיה הכי אהבת בתור ילד?', N'איזו תכנית טלווזיה הכי אהבת בתור ילדה?', NULL, N'איזו תכנית טלווזיה הכי אהבת בתור ילדה?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1366, N'F1169', 1, N'באיזה תחום הצטיינת בתיכון?', N'באיזה תחום הצטיינת בתיכון?', NULL, N'באיזה מקצוע הצטיינתם בתיכון?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1367, N'F1170', 1, N'ספר על סלב כלשהו שהערצת כילד ועכשיו אתה מרגיש שזה היה מגוחך', N'ספרי על סלב כלשהו שהערצת כילדה ועכשיו את מרגישה שזה היה מגוחך?', NULL, N'ספרו על סלב כלשהו שהערצתם כילד ועכשיו אתם מרגישים שזה היה מגוחך?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1368, N'F1171', 1, N'ספר על מחווה מרגשת שמישהו עשה עבורך בחודש האחרון', N'ספרי על מחווה מרגשת שמישהו עשה עבורך בחודש האחרון', NULL, N'ספרו על מחווה מרגשת שמישהו עשה עבורכם בחודש האחרון');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1369, N'F1172', 1, N'זכית בחמישים מיליון למי תיתן מיליון?', N'זכית בחמישים מיליון. למי תתני מיליון?', NULL, N'זכיתם בחמישים מיליון. למי תתנו מיליון?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1370, N'F1173', 1, N'זכית בחמישים מיליון. מה תהיה הרכישה המוגזמת הראשונה שלך?', N'זכית בחמישים מיליון. מה תהיה הרכישה המוגזמת הראשונה שלך?', NULL, N'זכית בחמישים מיליון. מה תהיה הרכישה המוגזמת הראשונה שלך?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1371, N'F1174', 1, N'זכית בחמישים מיליון. על מי תוציא חוזה חיסול?', N'זכית בחמישים מיליון. על מי תוציאי חוזה חיסול?', NULL, N'זכית בחמישים מיליון. על מי תוציאו חוזה חיסול?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1372, N'F1175', 1, N'מי היית רוצה שיופיע בחתונה שלך?', N'מי היית רוצה שיופיע בחתונה שלך?', NULL, N'מי יופיע בחתונה שלך?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1373, N'F1176', 1, N'עם מי תרצה להיתקע במעלית?', N'עם מי תרצי להיתקע במעלית?', NULL, N'עם מי תרצו להיתקע במעלית?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1374, N'F1177', 1, N'עם מי בא לך לשתות עכשיו קפה?', N'עם מי בא לך לשתות עכשיו קפה?', NULL, N'עם מי בא לך לשתות עכשיו קפה?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1375, N'F1180', 1, N'איזה רעש הכי מעצבן אותך?', N'איזה רעש הכי מעצבן אותך?', NULL, N'הרעש שהכי מעצבן אותי');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1376, N'F1182', 1, N'איך אתה מרגיע את עצמך כשמעצבנים אותך?', N'איך את מרגיעה את עצמך כשמעצבנים אותך?', NULL, N'איך אתם מרגיעים את עצמכם כשמעצבנים אתכם?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1377, N'F1183', 1, N'איזו מנה עיקרית אתה הכי אוהב לאכול?', N'איזו מנה עיקרית את הכי אוהבת לאכול?', NULL, N'איזו מנה עיקרית אתם הכי אוהבים לאכול?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1378, N'F1184', 1, N'איזה קינוח בא לך עכשיו?', N'איזה קינוח בא לך עכשיו?', NULL, N'איזה קינוח בא לך עכשיו?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1379, N'F1190', 1, N'מה היתה הפעם האחרונה שבכית?', N'מה היתה הפעם האחרונה שבכית? ', NULL, N'מה היתה הפעם האחרונה שבכית?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1380, N'F1195', 1, N'איזה מפורסם היית רוצה להיות?', N'איזה מפורסמת היית רוצה להיות?', NULL, N'איזה מפורסם\ת היית רוצה להיות?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1381, N'F1196', 1, N'איזו דמות מסרט היית רוצה להיות?', N'איזו דמות מסרט היית רוצה להיות?', NULL, N'איזו דמות מסרט היית רוצה להיות?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1382, N'F1197', 1, N'יצאת עם מישהי נחמדה, אבל אתה מרגיש שזה לא זה. כתוב לה SMS בו אתה מודיע שאתה לא מעוניין, אבל בו זמנית אתה חייב להחמיא לה ולהעלות לה את הביטחון העצמי', N'יצאת עם מישהו נחמד, אבל את מרגישה שזה לא זה. כתבי לו SMS בו את מודיעה שאת לא מעוניינת, אבל בו זמנית את חייבת להחמיא לו ולהעלות לו את הביטחון העצמי', NULL, N'יצאתם עם מישהו נחמד אבל זה לא זה. כתבו לו\ה בSMS שאתם לא מעוניינים, אבל בו זמנית אתם צריכים להעלות לו\ה את הביטחון העצמי. ');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1383, N'F1198', 1, N'פגשת בחורה סקסית במיוחד. החמא לה ב-SMS אבל אסור לך להיות ישיר מידי אחרת היא תפסול אותך מייד', N'פגשת בחור סקסי במיוחד. החמיאי לו ב-SMS אבל אסור לך להיות ישירה מידי אחרת הוא יחשוב שאת קלה להשגה ויאבד עניין', NULL, N'החמיאו ב-SMS בלי להיות ישירים מידי');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1384, N'F1199', 1, N'הבחור שאיתך תפס אותך לוטשת מבט במלצר החמוד במסעדה ועכשיו הראש שלך על הגיליוטינה. מה תגידי להגנתך?', N'הבחור שאיתך תפס אותך לוטשת מבט במלצר החמוד במסעדה ועכשיו הראש שלך על הגיליוטינה. מה תגידי להגנתך?', NULL, N'נתפסתם לוטשים מבט במלצר\ית. מה תגידו להגנתכם?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1385, N'F1204', 1, N'ספר על החלטה שלקחת השבוע ואתה מתחרט עליה ', N'ספרי על חלטה שלקחת השבוע ואת מתחרטת עליה', NULL, N'האם יש החלטה שלקחתם אתמול ואתם מתחרטים עליה?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1386, N'F1205', 1, N'את מי בא לך לחבק כשאתה עצוב?', N'את מי בא לך לחבק כשאת עצובה? ', NULL, N'את מי בא לכם לחבק כשאתם עצובים?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1387, N'F1206', 1, N'הזמנת בחורה לדייט רומנטי כשאתה מבשל את הארוחה אצלך. ', N'הזמנת בחור לדייט רומנטי כשאת מבשלת את הארוחה אצלך.', NULL, N'הזמנתם את הבחור\ה לדייט רומנטי אצלכם בדירה. מה תגישו? (אחר כך תנו בצ''אט ציון לבחירות של הצד השני)');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1388, N'F1207', 1, N'הזמנת בחורה לדייט רומנטי אצלך בבית. ', N'הזמנת בחור לדייט רומנטי אצלך בבית. ', NULL, N'הזמנתם את הבחור\ה לדייט רומנטי אצלכם בבית. (אחר כך בצ''אט, תנו ציון מ 1-10 לבחירות של הצד השני)');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1389, N'F1209', 1, N'נניח שיש לך אספקה בלתי מוגבלת של אוכל מסוג אחד, מה תבחר?', N'נניח שיש לך אספקה בלתי מוגבלת של אוכל מסוג אחד, מה תבחרי?', NULL, N'נניח שיש לך אספקה בלתי מוגבלת של אוכל מסוג אחד, מה תבחר\י?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1390, N'F1212', 1, N'אתה אוהב שבחורות מתאפרות או שאתה בעד נטורל? ', N'את אוהבת להתאפר, או שאת בדרך כלל נטורל?', NULL, N'באיזו מידה אתם מחשיבים איפור בקפידה? אן שאולי עדיף נטורל...');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1391, N'F1213', 1, N'האם אתה לובש מידי פעם עם בגדים צמודים? האם אתה אוהב שבחורות לובשות בגדים צמודים? ', N'האם את לובשת מידי פעם בגדים צמודים? האם את אוהבת שגברים לובשים בגדים צמודים?', NULL, N'עד כמה אתם אוהבים \ לובשים בגדים צמודים?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1392, N'F1214', 1, N'תאר באחוזים, מה חשוב יותר, גובה או משקל?', N'תארי באחוזים, מה חשוב יותר, גובה או משקל?', NULL, N'תארו באחוזים, מה חשוב יותר, גובה או משקל?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1393, N'F1215', 1, N'תאר באחוזים, מה חשוב יותר, שתהיה שנונה או שתיראה טוב. ', N'תארי באחוזים, מה חשוב יותר, שיהיה שנון או שייראה טוב?', NULL, N'תארו באחוזים, מה חשוב יותר, שכל או חיטוב?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1394, N'F1216', 1, N'איזה מספר אתה אם 10 זה שופך באופן חופשי מחמאות סרק, ו-1 זה אומר רק אמת בפרצוף', N'איזה מספר את אם 10 זה שופכת באופן חופשי מחמאות סרק, ו-1 זה אומרת רק אמת בפרצוף', NULL, N'מ-0 עד 10 כמה אתם נוהגים לתת מחמאות סרק?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1395, N'F1217', 1, N'מ-0 עד 10, כמה יוצא לך לאחר לפגישות? (0 זה אף פעם, 10 זה כל הזמן) ', N'מ-0 עד 10, כמה יוצא לך לאחר לפגישות? (0 זה אף פעם, 10 זה כל הזמן) ', NULL, N'מ-0 עד 10, כמה יוצא לך לאחר לפגישות? (0 זה אף פעם, 10 זה כל הזמן) ');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1396, N'F1226', 1, N'בחר את העונש מבין "על תנאי", "נידוי חברתי",  "מוות בעינויים" (ואפשר גם להמציא עונש אחר)', N'בחרי את העונש מבין "על תנאי", "נידוי חברתי",  "מוות בעינויים" (ואפשר גם להמציא עונש אחר)', NULL, NULL);
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1397, N'F1227', 1, N'בחר את העונש מבין "על תנאי", "נידוי חברתי",  "מוות בעינויים" (ואפשר גם להמציא עונש אחר)', N'בחרי את העונש מבין "על תנאי", "נידוי חברתי",  "מוות בעינויים" (ואפשר גם להמציא עונש אחר)', NULL, NULL);
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1398, N'F1228', 1, N'בחר את העונש מבין "על תנאי", "נידוי חברתי",  "מחלות קשות" (ואפשר גם להמציא עונש אחר)', N'בחרי את העונש מבין "על תנאי", "נידוי חברתי",  "מחלות קשות" (ואפשר גם להמציא עונש אחר)', NULL, NULL);
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1399, N'F1229', 1, N'בחר את העונש מבין "על תנאי", "נידוי חברתי",  "מחלות קשות" (ואפשר גם להמציא עונש אחר)', N'בחרי את העונש מבין "על תנאי", "נידוי חברתי",  "מחלות קשות" (ואפשר גם להמציא עונש אחר)', NULL, NULL);
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1400, N'F1230', 1, N'בחר את העונש מבין "על תנאי", "כריתת יד", "אומללות אינסופית" (ואפשר גם להמציא עונש אחר)', N'בחרי את העונש מבין "על תנאי", "מוות בעינויים", "אומללות אינסופית" (ואפשר גם להמציא עונש אחר)', NULL, NULL);
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1401, N'F1231', 1, N'מה אתה עושה כשאתה רואה ג''וק בגודל של ביואיק?', N'מה את עושה כשאת רואה ג''וק בגודל של ביואיק?', NULL, N'מה את\ה עושה כשאת\ה רואה ג''וק?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1402, N'F1232', 1, N'הכיור עולה על גדותיו בגלל סתימה. תתקן לבד או מה?', N'הכיור עולה על גדותיו בגלל סתימה. תתקני לבד או מה? ', NULL, N'הכיור עולה על גדותיו בגלל סתימה. תתקנו לבד?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1403, N'F1233', 1, N'אופס, באמצע נסיעה, פנצ''ר. תתקן לבד?', N'אופס, באמצע נסיעה, פנצ''ר. תתקני לבד? ', NULL, N'אופס, באמצע נסיעה, פנצ''ר. תתקנו לבד?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1404, N'F1234', 1, N'הכפתור בחולצה נתלש. תתפור בעצמך? תיתן לאמא לתפור? תשאיר את זה ככה? ', N'הכפתור בחולצה נתלש. תתפרי בעצמך? תתני לאמא לתפור? תשאירי את זה ככה? ', NULL, N'הכפתור בחולצה נתלש. מה תעשו?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1405, N'F1235', 1, N'צריך לתלות תמונה. תעשה את זה בעצמך? ', N'צריך לתלות תמונה. תעשי את זה בעצמך? ', NULL, N'צריך לתלות תמונה שקניתם. תעשו את זה לבד? ');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1406, N'F1236', 1, N'המחשב עושה בעיות. האם תנסה לתקן לבד, או ישר תקרא לטכנאי? ', N'המחשב עושה בעיות. האם תנסי לתקן לבד, או ישר תקראי לטכנאי?', NULL, N'המחשב מקרטע. האם תנסו לתקן לבד או ישר תקראו לטכנאי. ');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1407, N'F1237', 1, N'השלם את החסר במילים "יודע", או "קצת יודע", או "אין לי מושג".', N'השלימי את החסר במילים "יודעת", "קצת יודעת", או "אין לי מושג"', NULL, NULL)
;
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1408, N'F1238', 1, N'השלם את החסר במילים "יודע", או "קצת יודע", או "אין לי מושג".', N'השלימי את החסר במילים "אני יודעת", "אני קצת יודעת", או "אין לי מושג איך"', NULL, NULL);
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1409, N'F1239', 1, N'השלם את החסר במילים "יודע", או "קצת יודע", או "אין לי מושג".', N'השלימי את החסר במילים "אני יודעת", "אני קצת יודעת", או "אין לי מושג איך"', NULL, NULL);
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1410, N'F1240', 1, N'האם יכול להיות מצב שבו תתאהב במישהי מייד ותגיד לה "אני אוהב אותך" אחרי שבוע?', N'האם יכול להיות מצב שבו תתאהבי במישהו מייד ותגידי לו "אני אוהבת אותך" אחרי שבוע היכרות?', NULL, N'האם אפשר להתאהב תוך שבוע?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1411, N'F1241', 1, N'אהבה חדשה ומרגשת. מה תגיד אם היא מסמסת לך כל 10 דקות? ', N'אהבה חדשה ומרגשת. מה תגידי אם הוא מסמס לך כל 10 דקות? ', NULL, N'אהבה חדשה ומרגשת. מה תגידו אם אתם מקבלים ממנו\ה SMS כל 10 דקות?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1412, N'F1242', 1, N'מה תגיד אם היא תזמין אותך לפגוש את ההורים שלה אחרי חודש היכרות?', N'מה תגידי אם הוא יזמין אותך לפגוש את ההורים שלו אחרי חודש היכרות?', NULL, N'מה תגידו אם הוא\היא יזמינו אתכם לפגוש את ההורים אחרי חודש היכרות?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1413, N'F1243', 1, N'להתנשק בפומבי זה:', N'להתנשק בפומבי זה:', NULL, N'להתנשק בפומבי זה:');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1414, N'F1244', 1, N'להחזיק ידיים ברחוב זה: (כיף, לא כיף, מביך, מרגש)', N'להחזיק ידיים ברחוב זה: (כיף, לא כיף, מביך, מרגש)', NULL, N'להחזיק ידיים ברחוב זה:');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1415, N'F1245', 1, N'אתה רוצה להיפרד מהחברה שלך, ואתה חייב לעשות זאת ב-SMS. השלם:', N'את רוצה להיפרד מהחבר שלך ואת חייבת לעשות זאת ב-SMS. השלימי:', NULL, N'אתם רוצים להיפרד מהחבר\ה, ואתם חייבים לעשות זאת ב SM-. השלימו:');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1416, N'F1246', 1, N'כתוב SMS פרידה מהחברה שלך, כשבהודעה חייבת להופיע המילה "גדול". ', N'כתבי SMS פרידה מהחבר שלך, כשבהודעה חייבת להופיע המילה "קטן". ', NULL, N'כתבו SMS פרידה מהחבר\ה, כשבהודעה חייבת להופיע המילה גדול\קטן. ');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1417, N'F1247', 1, N'כתוב SMS פרידה מהחברה שלך, כשבהודעה יהיו מילים בנות שתי אותיות בלבד. ', N'כתבי SMS פרידה מהחבר שלך, כשבהודעה יהיו מילים בנות שתי אותיות בלבד. ', NULL, N'כתבו SMS פרידה מהחבר\ה, כשבהודעה יהיו מילים בנות שתי אותיות בלבד. ');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1418, N'F1248', 1, N'סמס לאקסית במטרה שהיא תזמין אותך אליה, מבלי להיראות להוט', N'סמסי לאקס במטרה שהוא יזמין אותך אליו, מבלי להיראות להוטה', NULL, N'סמסו לאקס\ית, במטרה לקבל הזמנה, אבל מבלי להיראות להוטים. ');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1419, N'F1249', 1, N'כתוב קללה שאתה מחבב במיוחד', N'כתבי קללה שאת מחבבת במיוחד', NULL, N'כתבו קללה שאתם מחבבים במיוחד');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1420, N'F1250', 1, N'האם בחורה בחרה עבורך פעם בגדים בחנות? באיזו סיטואציה זה קרה? (ולא, אמא שלך, זה לא נחשב)', N'האם בחור בחר עבורך פעם בגדים בחנות? באיזו סיטואציה זה קרה? ', NULL, N'האם בחור\ה בחרו עבורכם פעם בגדים בחנות?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1421, N'F1251', 1, N'פרט את כל זוגות הנעליים שיש לך... (כולל סנדלים, כפכפים, קרוקס, הכל הולך)', N'פרטי את כל זוגות הנעליים שיש לך... (כולל סנדלים, כפכפים, קרוקס, הכל הולך)', NULL, N'כמה זוגות נעליים יש לך בטוטאל? בבקשה תפרט\י... (כולל סנדלים, כפכפים, קרוקס, הכל הולך)');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1422, N'F1252', 1, N'כמה זמן בממוצע לוקח לך לבחור בגדים, כדי לצאת איתם בבוקר מהבית?', N'כמה זמן בממוצע לוקח לך לבחור בגדים, כדי לצאת איתם בבוקר מהבית?', NULL, N'כמה זמן בממוצע לוקח לך לבחור בגדים, כדי לצאת איתם בבוקר מהבית?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1423, N'F1253', 1, N'האם יצא לך לקנות בגד חדש במיוחד לאירוע ספציפי? תן דוגמא... ', N'האם יצא לך לקנות בגד חדש במיוחד לאירוע ספציפי? תני דוגמא... ', NULL, N'האם יצא לך לקנות בגד חדש במיוחד לאירוע ספציפי? תן\י דוגמא... ');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1424, N'F1254', 1, N'כתוב SMS לבחורה חדשה שפגשת, ותסביר שזה לא ילך ביניכם, כשאתה משתמש במונחים מעולם הרפואה. ', N'כתבי SMS לבחור חדש שפגשת, ותסבירי שזה לא ילך ביניכם, כשאת משתמשת במונחים מעולם הכדורגל.', NULL, N'כתבו SMS לבחור\ה חדש\ה שזה לא ילך ביניכם, תוך שאתם משתמשים במונחים מעולם הכדורגל\רפואה');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1425, N'F1255', 1, N'החברה שלך בגדה בך ומבקשת מחילה. סרב לה ב-SMS תוך שאתה משתמש במונחים מעולם המוסיקה. ', N'החבר שלך בגד בך ומבקש מחילה. סרבי לו ב SMS תוך שאת משתמשת במונחים מעולם המוסיקה. ', NULL, N'החבר\ה שלך בגד\ה בך ומבקש\ת מחילה. סרבו לו ב SMS תוך שאתם משתמשים במונחים מעולם המוסיקה. ');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1426, N'F1256', 1, N'מכריחים אותך להתחתן עם אחת מהשלוש- מיקי חיימוביץ, גאולה אבן, יונית לוי. במי תבחר ולמה?', N'מכריחים אותך להתחתן עם אחד מהשלושה - יעקב אילון, גיא זוהר, איתי אנגל. במי תבחרי ולמה?', NULL, N'מכריחים אתכם להתחתן עם מישהו מתחום החדשות. עם מי זה יהיה? ');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1427, N'F1257', 1, N'איפה בא לך לגור?', N'איפה בא לך לגור?', NULL, N'איפה בא לך לגור?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1428, N'F1258', 1, N'ספר על מקרה שבו היית עצבנית ואיבדת את זה לגמרי.', N'ספרי על מקרה שבו היית עצבנית ואיבדת את זה לגמרי. ', NULL, N'האם קרה לך שהיית עצבני\ת ואיבדת את זה לגמרי? אם כן, מה עיצבן אותך?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1429, N'F1259', 1, N'אתה לא נרדם בלילה, איך אתה מעביר את הזמן?', N'את לא נרדמת בלילה, איך את מעבירה את הזמן?', NULL, N'את\ה לא נרדם\ת בלילה, איך מעביר\ה את הזמן?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1430, N'F1260', 1, N'מה תנשנש כשאתה במצב רוח רע?', N'מה תנשנשי כשאת במצב רוח רע?', NULL, N'מה תנשנש\י כשאת\ה במצב רוח רע?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1431, N'F1261', 1, N'את מי תרצה להכיר מהשלוש? נסיכה, מדענית פיסיקה, או פסיכולוגית', N'את מי תרצי להכיר מהשלושה? נסיך, מדען פיסיקה, או פסיכולוג', NULL, N'את מי מהשלושה תרצו להכיר? נסיך\ה, מדען\ית פיסיקה, או פסיכולוג\ית');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1432, N'F1262', 1, N'מה לא כדאי לבחורה להגיד בדייט ראשון איתך?', N'מה לא כדאי לגבר להגיד בדייט ראשון איתך?', NULL, N'מה לא כדאי להגיד בדייט ראשון איתך?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1433, N'F1263', 1, N'מה זה עושה לך אם היא מתלהבת ממך בגלוי ישר על ההתחלה?', N'מה זה עושה לך אם הוא מתלהב ממך בגלוי ישר על ההתחלה?', NULL, N'מה זה עושה לך אם הוא\היא מתלהב\ת ממך ישר על ההתחלה?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1434, N'F1264', 1, N'אחרי כמה דייטים\זמן הגיוני לצפות לבלעדיות בקשר?', N'אחרי כמה דייטים\זמן הגיוני לצפות לבלעדיות בקשר?', NULL, N'אחרי כמה דייטים\זמן הגיוני לצפות לבלעדיות בקשר?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1435, N'F1265', 1, N'האם יש מצב שתקבע מראש שני דייטים עם בחורות שונות לאותו השבוע?', N'האם יש מצב שתקבעי מראש שני דייטים עם גברים שונים לאותו השבוע?', NULL, N'האם יש מצב שתקבעו מראש שני דייטים עם אחרים\ות לאותו השבוע?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1436, N'F1266', 1, N'האם תסכים לצאת איתה אם תדע שהיא כבר קבעה דייט נוסף עם אחר לאותו השבוע?', N'האם תסכימי לצאת איתו, אם תדעי שהוא כבר קבע דייט נוסף עם אחרת לאותו השבוע?', NULL, N'האם תסכימו לצאת לדייט אם תדעו שהוא\היא קבעו דייט נוסף לאותו השבוע?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1437, N'F1267', 1, N'איזה דייט איכותי בעיניך?', N'איזה דייט איכותי בעינייך?', NULL, NULL);
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1438, N'F1268', 1, N'אם היתה לך מכונת זמן, לאיזו תקופה היה בא לך לנסוע?', N'אם היתה לך מכונת זמן, לאיזו תקופה היה בא לך לנסוע?', NULL, N'אם היתה לך מכונת זמן, לאיזו תקופה היה בא לך לנסוע?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1439, N'F1269', 1, N'אם יכולת למחוק רגע מהעבר שלך, איזה רגע היית מוחק?', N'אם יכולת למחוק רגע מהעבר שלך, איזה רגע היית מוחקת?', NULL, N'אם יכולת למחוק רגע מהעבר שלך, איזה רגע היית מוחק\ת?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1440, N'F1270', 1, N'אם יכולת לשחזר רגע מהעבר שלך, איזה רגע היית משחזר?', N'אם יכולת לשחזר רגע מהעבר שלך, איזה רגע היית משחזרת?', NULL, N'אם יכולת לשחזר רגע מהעבר שלך, איזה רגע היית משחזר\ת?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1441, N'F1271', 1, N'אתה יכול לקבל לילה סוער עם כוכבת קולנוע. במי תבחר?', N'את יכולה לקבל לילה סוער עם כוכב קולנוע. במי תבחרי?', NULL, N'אתם יכולים לקבל בילוי סוער עם כוכב\ת קולנוע. במי תבחרו?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1442, N'F1272', 1, N'איפה תבחר להיות זבוב על הקיר? (למשל, בחדר שבו דנים בהעלאת שכר שלך, או בחדר שבו האקסית מספרת לחברה שלה מדוע נפרדה ממך, וכו''... )', N'איפה תבחרי להיות זבוב על הקיר? (למשל בחדר שבו דנים בהעלאת שכר שלך, או בחדר שבו האקס מספר לחבר שלו מדוע נפרד ממך, וכו''..) ', NULL, N'איפה תבחרו להיות זבוב על הקיר?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1443, N'F1273', 1, N'איזה מספר אתה אם 1 זה הכי זרוק ו-10 זה הכי מקפיד בלבוש?', N'איזה מספר את אם 1 זה הכי זרוקה ו-10 זה הכי מקפידה בלבוש?', NULL, N'איזה מספר את\ה אם 1 זה הכי זרוק\ה ו-10 זה הכי מקפיד\ה בלבוש?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1444, N'F1274', 1, N'איזה מספר אתה אם 1 זה הכי הכי אוהב להיות בבית ו-10 זה בליין? ', N'איזה מספר את אם 1 זה הכי הכי אוהבת להיות בבית ו-10 זה בליינית? ', NULL, N'איזה מספר את\ה אם 1 זה הכי הכי אוהב\ת להיות בבית ו-10 זה בליינ\ית? ');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1445, N'F1275', 1, N'איזה מספר אתה אם 1 זה הכי פחדן ו-10 זה הכי אמיץ? ', N'איזה מספר את אם 1 זה הכי פחדנית ו-10 זה הכי אמיצה? ', NULL, N'איזה מספר את\ה אם 1 זה הכי פחדנ\ית ו-10 זה הכי אמיצ\ה? ');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1446, N'F1276', 1, N'איזה מספר אתה אם 1 זה הכי מתבודד ו-10 זה הכי חברותי?', N'איזה מספר את אם 1 זה הכי מתבודדת ו-10 זה הכי חברותית?', NULL, N'איזה מספר את\ה אם 1 זה הכי מתבודד\ת ו-10 זה הכי חברותי\ת?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1447, N'F1277', 1, N'איזה מספר אתה אם 1 זה הכי ריאליסטי ו-10 זה הכי פנטזיונר?', N'איזה מספר את אם 1 זה הכי ריאליסטית ו-10 זה הכי פנטזיונרית?', NULL, N'איזה מספר את\ה אם 1 זה הכי ריאליסטי\ת ו-10 זה הכי פנטזיונר\ית?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1448, N'F1278', 1, N'איזה מספר אתה אם 1 זה הכי פסימי ו-10 זה הכי אופטימי?', N'איזה מספר את אם 1 זה הכי פסימית ו-10 זה הכי אופטימית?', NULL, N'איזה מספר את\ה אם 1 זה הכי פסימי\ת ו-10 זה הכי אופטימי\ת?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1449, N'F1279', 1, N'איזה מספר אתה אם 1 זה הכי מתוכנן ו-10 זה הכי ספונטני?', N'איזה מספר את אם 1 זה הכי מתוכננת ו-10 זה הכי ספונטנית?', NULL, N'איזה מספר את\ה אם 1 זה הכי מתוכננ\ת ו-10 זה הכי ספונטני\ת?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1450, N'F1280', 1, N'איזה מספר אתה אם 1 זה הכי קשוח ו-10 זה הכי בוכה בסרטים?', N'איזה מספר את אם 1 זה הכי קשוחה ו-10 זה הכי בוכה בסרטים?', NULL, N'איזה מספר את\ה אם 1 זה הכי קשוח\ה ו-10 זה הכי בוכה בסרטים?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1451, N'F1281', 1, N'איזה מספר אתה אם 1 זה הכי לא יכול להתחייב ו-10 זה הכי אוהב מערכות יחסים?', N'איזה מספר את אם 1 זה הכי לא יכולה להתחייב ו-10 זה הכי אוהבת מערכות יחסים?', NULL, N'איזה מספר את\ה אם 1 זה הכי לא יכול\ה להתחייב ו-10 זה הכי אוהב\ת מערכות יחסים?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1452, N'F1282', 1, N'איזה מספר אתה אם 1 זה הכי עקשן ו-10 זה הכי מוותר וזורם?', N'איזה מספר את אם 1 זה הכי עקשנית ו-10 זה הכי מוותרת וזורמת?', NULL, N'איזה מספר את\ה אם 1 זה הכי עקשנ\ית ו-10 זה הכי מוותר\ת וזורמ\ת?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1453, N'F1283', 1, N'איזה משקה אתה אוהב לשתות בפאב?', N'איזה משקה את אוהבת לשתות בפאב?', NULL, N'איזה משקה אתם אוהבים לשתות בפאב?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1454, N'F1284', 1, N'תן שיר אחד שאם תשמע אותו בפאב, תקום ותגיד "ריספקט"', N'תני שיר אחד שאם תשמעי אותו מתנגן בפאב, תקומי ותגידי "ריספקט"', NULL, N'שיר אחד שאם תשמעו אותו בפאב תקומו ותגידו "ריספקט"');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1455, N'F1285', 1, N'איזה דייט איכותי בעיניך?', N'איזה דייט איכותי בעינייך?', NULL, NULL);
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1456, N'F1286', 1, N'האם יצא לך להשתכר בפאב שהיה צריך לאסוף אותך מהרצפה?', N'האם יצא לך להשתכר בפאב שהיה צריך לאסוף אותך מהרצפה?', NULL, N'האם יצא לך להשתכר בפאב שהיה צריך לאסוף אותך מהרצפה?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1457, N'F1287', 1, N'איזה סוג בירה אתה הכי אוהב?', N'איזה סוג בירה את הכי אוהבת?', NULL, N'איזה סוג בירה אתם הכי אוהבים?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1458, N'F1288', 1, N'ספר על ז''אנר סרטים אקסטרימי שאתה אוהב.  ', N'ספרי על ז''אנר סרטים אקסטרימי שאת אוהבת.', NULL, N'ספרו על ז''אנר סרטים אקסטרימי שאתם אוהבים, למשל סרטים על ערפדים, אימה, וכו''... ');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1459, N'F1289', 1, N'לאיזה מקום בעולם הכי בא לך לנסוע עכשיו?', N'לאיזה מקום בעולם הכי בא לך לנסוע עכשיו?', NULL, N'לאיזה מקום בעולם הכי בא לך לנסוע עכשיו?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1460, N'F1290', 1, N'היפרד מחברה שלך ב-SMS', N'היפרדי מחבר שלך ב-SMS', NULL, N'פרידה ב SMS');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1461, N'F1291', 1, N'טוב, בתכלס, איזה אוכל טעים אתה אלוף בלהכין?', N'טוב, תכלס, איזה אוכל טעים את אלופה בלהכין?', NULL, N'טוב, תכלס, איזה אוכל טעים את\ה יודע\ת להכין?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1462, N'F1292', 1, N'תאר באחוזים את סדר העדיפויות עבורך', N'תארי באחוזים את סדר העדיפויות עבורך', NULL, NULL);
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1463, N'F1293', 1, N'מי האחרון\ה שעשה\תה לך מסאז''? ואיפה?', N'מי האחרון\ה שעשה\תה לך מסאז''? ואיפה?', NULL, N'מי האחרון\ה שעשה\תה לך מסאז''? ואיפה?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1464, N'F1294', 1, N'את מי תיקח איתך לאי בודד? ומה תעשו שם כל הזמן? ', N'את מי תקחי איתך לאי בודד? ומה תעשו שם כל הזמן?', NULL, N'את מי תקח\י איתך לאי בודד?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1465, N'F1295', 1, N'השב ב "נחמד, מעולה, לא נורא, מבאס" וכו''...', N'השיבי ב "נחמד, מעולה, לא נורא, מבאס" וכו''...', NULL, NULL);
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1466, N'F1297', 1, N'אילו דברים אתה יודע להכין? השלם את החסר רק במילים כן או לא או ככה ככה ', N'אילו דברים את יודעת להכין? השלימי את החסר רק בכן או לא או ככה ככה ', NULL, NULL);
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1467, N'F1298', 1, N'אילו דברים אתה יודע להכין? השלם את החסר רק במילים כן או לא או ככה ככה ', N'אילו דברים את יודעת להכין? השלימי את החסר רק בכן או לא או ככה ככה ', NULL, NULL);
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1468, N'F1299', 1, N'אילו דברים אתה יודע להכין? השלם את החסר רק במילים כן או לא או ככה ככה ', N'אילו דברים את יודעת להכין? השלימי את החסר רק בכן או לא או ככה ככה ', NULL, NULL);
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1469, N'F1300', 1, N'שיפשפת מנורה והג''יני אמרה שתוכל להיות מי \ מה שאתה רוצה למשך שבוע. איזה מפורסם היית רוצה להיות? ', N'שיפשפת מנורה והג''יני אמרה שתוכלי להיות מי \ מה שאת רוצה למשך שבוע. איזו מפורסמת היית רוצה להיות?', NULL, N'איזה מפורסם\ת היית רוצה להיות? ');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1470, N'F1302', 1, N'פרצה שריפה בבית – אילו שלושה פריטים תציל?', N'פרצה שריפה בבית – אילו שלושה פריטים תצילי?', NULL, N'פרצה שריפה בבית – אילו שלושה פריטים תצילו? ');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1471, N'F1304', 1, N'אם יציעו לך ללמד אחרים באופן פרטי משהו שאתה מומחה בו תמורת כסף טוב. מה זה יהיה? ', N'אם יציעו לך ללמד אחרים באופן פרטי משהו שאת מומחית בו תמורת כסף טוב. מה זה יהיה? ', NULL, N'במה אתם הכי טובים ללמד אחרים באופן פרטי? ');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1472, N'F1305', 1, N'האם יש לך על הגוף קעקוע? איפה? מה מצויר?', N'האם יש לך על הגוף קעקוע? איפה? מה מצויר?', NULL, N'האם יש לך על הגוף קעקוע? איפה? מה מצויר?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1473, N'F1307', 1, N'ספר על כינוי או שם חיבה שהחברים\משפחה נוהגים לכנות אותך', N'ספרי על כינוי או שם חיבה שהחברים\משפחה נוהגים לכנות אותך', NULL, N'ספר\י על כינוי או שם חיבה שהחברים\משפחה נוהגים לכנות אותך');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1474, N'F1308', 1, N'ספר איך אתה מזיז את הגוף שלך במהלך השבוע כדי לשמור על כושר ולא להיות בטטה ', N'ספרי איך את מזיזה את הגוף שלך במהלך השבוע כדי לשמור על כושר ולא להיות בטטה', NULL, N'ספרו איך אתם מזיזים את הגוף שלכם במהלך השבוע כדי להיות בטטה');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1475, N'F1309', 1, N'באיזה צד של המיטה אתה ישן? ', N'באיזה צד של המיטה את ישנה? ', NULL, N'באיזה צד של המיטה אתם ישנים?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1476, N'F1310', 1, N'מה היתה התחפושת הכי שווה  אי פעם שהתחפשת בפורים? ', N'מה היתה התחפושת הכי שווה  אי פעם שהתחפשת בפורים? ', NULL, N'למה התחפשת בפורים?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1477, N'F1311', 1, N'באיזה כלי נגינה היית רוצה לדעת לנגן?', N'באיזה כלי נגינה היית רוצה לדעת לנגן?', NULL, N'באיזה כלי נגינה היית רוצה לדעת לנגן?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1478, N'F1312', 1, N'השב ב מילים כמו "מאוד, בכלל לא, ככה ככה"', N'השיבי ב מילים כמו "מאוד, בכלל לא, ככה ככה"', NULL, NULL);
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1479, N'F1313', 1, N'איך אתה בבקרים ובלילות?', N'איך את בבקרים ובלילות?', NULL, NULL);
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1480, N'F1314', 1, N'רוצה משהו חם לשתות?', N'רוצה משהו חם לשתות?', NULL, N'רוצה משהו חם לשתות?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1481, N'F1315', 1, N'השלם', N'השלימי', NULL, NULL);
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1482, N'F1316', 1, N'כמה זמן בממוצע ביום אתה מבלה ברשתות חברתיות?', N'כמה זמן בממוצע ביום את מבלה ברשתות חברתיות?', NULL, N'כמה זמן בממוצע ביום אתם מבלים ברשתות חברתיות?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1483, N'F1317', 1, N'נשיקה ראשונה', N'נשיקה ראשונה', NULL, NULL);
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1484, N'F1318', 1, N'מסעדה', N'מסעדה', NULL, NULL);
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1485, N'F1321', 1, N'באיזה גיל עשית רישיון נהיגה, וכמה טסטים לקח לך לעבור?', N'באיזה גיל עשית רישיון נהיגה, וכמה טסטים לקח לך לעבור?', NULL, N'באיזה גיל עשית רישיון נהיגה, וכמה טסטים לקח לך לעבור?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1486, N'F1322', 1, N'באיזה סוג ספורט אתה הכי אוהב לצפות בטלוויזיה? עם מי?', N'באיזה סוג ספורט את הכי אוהבת לצפות בטלוויזיה? עם מי? ', NULL, N'באיזה סוג ספורט את\ה הכי אוהב\ת לצפות בטלויזיה? ');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1487, N'F1323', 1, N'מה אכלת הבוקר?', N'מה אכלת הבוקר?', NULL, N'מה אכלת הבוקר?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1488, N'F1324', 1, N'מה אתה מסבן ראשון במקלחת?', N'מה את מסבנת ראשונה במקלחת?', NULL, N'איזה איבר אתם מסבנים ראשון במקלחת?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1489, N'F1325', 1, N'נניח שיתפסו אותך לוטש עיניים במישהי, באיזה חלק של הגוף שלה תביט?', N'נניח שיתפסו אותך לוטשת עיניים במישהו, באיזה חלק של הגוף שלו תביטי? ', NULL, N'נניח שתופסים אותך לוטשים עיניים במישהו\י, באיזה חלק של הגוף שלו\ה תביט\י? ');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1490, N'F1326', 1, N'איזה חשבון אתה הכי שונא לשלם? ', N'איזה חשבון את הכי שונאת לשלם? ', NULL, N'איזה חשבון אתם הכי שונאים לשלם?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1491, N'F1327', 1, N'טיסה', N'טיסה', NULL, NULL);
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1492, N'F1328', 1, N'גלישה באינטרנט', N'גלישה באינטרנט', NULL, NULL);
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1493, N'F1329', 1, N'מה המצב?', N'מה המצב?', NULL, NULL);
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1494, N'F1330', 1, N'ספר על חפץ שלך, בעלך ערך משמעותי ומיוחד עבורך', N'ספרי על חפץ שלך, בעל ערך משמעותי ומיוחד עבורך', NULL, N'ספרו על חפץ שלכם, בעל ערך משמעותי ומיוחד עבוכם');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1495, N'F1331', 1, N'איך אתה מבלה בחוף הים? וכמה זמן?', N'איך את מבלה בחוף הים? וכמה זמן?', NULL, NULL);
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1496, N'F1332', 1, N'ספר על מאכל טעים במיוחד, שאמא שלך היתה מכינה לך כשהיית ילד', N'ספרי על מאכל טעים במיוחד שאמא שלך היתה מכינה לך כשהיית ילדה', NULL, N'ספרו על מאכל טעים במיוחד שאמא היתה מכינה כשהייתם ילדים');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1497, N'F1333', 1, N'איזה מספר אתה אם 1 זה הכי מופנם, ו-10 זה הכי מוחצן?', N'איזה מספר את אם 1 זה הכי מופנם, ו-10 זה הכי מוחצן?', NULL, N'איזה מספר אתם אם 1 זה הכי מופנמים ו-10 זה הכי מוחצנים?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1498, N'F1334', 1, N'ספר על מאכל דוחה במיוחד שאתה שונא לאכול:', N'ספרי על מאכל דוחה במיוחד שאת שונאת לאכול:', NULL, N'ספרו על מאכל דוחה ביוחד שיצא לכם לאכול בעבר');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1499, N'F1335', 1, N'איזה סיגנון אתה הכי אוהב לרקוד?', N'איזה סיגנון את הכי אוהבת לרקוד?', NULL, N'איזה סיגנון אתם הכי אוהבים לרקוד? ');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1500, N'F1336', 1, N'איזה סרט הכי אהבת כשהיית ילד?', N'איזה סרט הכי אהבת כשהיית ילדה?', NULL, N'איזה סרט הכי אהבת כשהיית ילד\ה?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1501, N'F1337', 1, N'מהי ההופעה האחרונה שראית ומתי?', N'מהי ההופעה האחרונה שראית ומתי?', NULL, N'מהי ההופעה האחרונה שראית ומתי?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1502, N'F1338', 1, N'איזה מזל אתה, והאם אתה בכלל מאמין באסטרולוגיה?', N'איזה מזל את, והאם את בכלל מאמינה באסטרולוגיה?', NULL, N'איזה מזל את\ה והאם את\ה בכלל מאמינ\ה באסטרולוגיה? ');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1503, N'F1339', 1, N'במה אתה ממש טוב?', N'במה את ממש טובה?', NULL, NULL);
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1504, N'F1340', 1, N'תעודה', N'תעודה', NULL, NULL);
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1505, N'F1341', 1, N'האם אתה אספן של משהו? (בולים, מפיות, דמויות מסטארטרק וכו''... ) ', N'האם אתה אספן של משהו? (בולים, מפיות, דמויות מסטארטרק וכו''... ) ', NULL, N'האם אתם אספנים של משהו?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1506, N'F1342', 1, N'איך אתה עם פאזלים?', N'איך את עם פאזלים?', NULL, N'איך אתם עם פאזלים?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1507, N'F1343', 1, N'איך בילית את השבת האחרונה?', N'איך בילית את השבת האחרונה?', NULL, N'איך בילית את השבת האחרונה?')
;
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1508, N'F1344', 1, N'כמה חברים הכי טובים יש לך? (כאלה שתעשה הכל בשבילם), וכמה חברים \ ידידים רגילים?', N'כמה חברים הכי טובים יש לך? (כאלה שתעשי הכל בשבילם), וכמה חברים \ ידידים רגילים?', NULL, N'כמה חברים הכי טובים יש לך?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1509, N'F1345', 1, N'ספר על ספר שקראת שהרשים אותך מאוד ', N'ספרי על ספר שקראת שהרשים אותך מאוד', NULL, N'ספרו על ספר שקראתם שהרשים אתכם מאוד');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1510, N'F1346', 1, N'ספר על העבודה הכי ביזארית שיצא לך לעבוד בה בעבר?', N'ספרי על העבודה הכי ביזארית שיצא לך לעבוד בה בעבר?', NULL, N'ספר\י על העבודה הכי ביזארית שיצא לך לעבוד בה בעבר?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1511, N'F1347', 1, N'כשאתה יחד עם חבר''ה, האם אתה פעיל במרכז, או מביט מהצד ומהתערב בקטנה?', N'כשאת יחד עם חבר''ה, האם את פעילה במרכז, או מביטה מהצד ומתערבת בקטנה?', NULL, N'כשאתם עם חברה, האם אתם במרכז, או בצד?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1512, N'F1348', 1, N'האם יצא לך להופיע\להרצות מול קבוצה גדולה של אנשים? איפה?', N'האם יצא לך להופיע\להרצות מול קבוצה גדולה של אנשים? איפה?', NULL, N'האם יצא לך להופיע\להרצות מול קבוצה גדולה של אנשים?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1513, N'F1349', 1, N' ערב, אתה מחוק וגמור מעייפות אחרי יום עבודה מתיש, בקושי עומד. לאיזה בילוי תסכים בכל זאת?', N' ערב, את מחוקה וגמורה מעייפות אחרי יום עבודה מתיש, בקושי עומדת. לאיזה בילוי תסכימי בכל זאת?', NULL, N'בערב אחרי יום עבודה מתיש, איזה בילוי הכי מתחשק לך? ');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1514, N'F1350', 1, N'איזו עונה אתה הכי אוהב? ', N'איזו עונה את הכי אוהבת? ', NULL, N'איזו עונה אתם הכי אוהבים? למה?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1515, N'F1351', 1, N'דרג כל פרמטר מ-1 עד 10 ', N'דרגי כל פרמטר -1 עד 10', NULL, NULL);
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1516, N'F1352', 1, N'ממה אתה הכי נעלב?', N'ממה את הכי נעלבת?', NULL, N'ממה אתם הכי נעלבים?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1517, N'F1353', 1, N'ספר על משהו אחד שאתה מאושר ממנו בחייך כיום', N'ספרי על משהו אחד שאת מאושרת ממנו בחייך כיום', NULL, N'ספרו על משהו אחד שאתם מאושרים ממנו בחייכם כיום');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1518, N'F1354', 1, N'פנטהאוז עם נוף מדהים לים, או בית בכפר עם גינה? או משהו אחר?', N'פנטהאוז עם נוף מדהים לים, או בית בכפר עם גינה? או משהו אחר?', NULL, N'איפה לגור? דירת פנטהאוז עם נוף מדהים לים, או בית עם גינה?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1519, N'F1355', 1, N'מה בעבודה שלך אתה הכי אוהב?', N'מה בעבודה שלך את הכי אוהבת?', NULL, N'מה בעבודה שלך את\ה הכי אוהב\ת');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1520, N'F1356', 1, N'איזה סרט שאתה אוהב יצא לך לראות הרבה פעמים ואין לך בעיה לצפות בו שוב?', N'איזה סרט שאת אוהת יצא לך לראות הרבה פעמים ואין לך בעיה לצפות בו שוב?', NULL, N'איזה סרט אתם אוהבים ובא לכם לצפות שוב ושוב?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1521, N'F1357', 1, N'נניח שבחורה תבחר בך לפי שיר שתשמיע לה מהנגן שלך. איזה שיר תשים כדי לעשות עליה רושם?', N'נניח שבחור יבחר בך לפי שיר שתשמיעי לו מהנגן שלך. איזה שיר תשימי כדי לעשות עליו רושם?', NULL, N'נניח שיבחרו בכם לפי שיר, איזה שיר תשמיעו?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1522, N'F1358', 1, N'חו"ל - הופעות וריקודים, או תרבות ואמנות? או משהו אחר?', N'בחופשה חו"ל - הופעות וריקודים, או תרבות ואמנות? או משהו אחר?', NULL, N'כשאתם בחו"ל, אתם בעניין של תרבות ואמנות, או בעניין של בילויים והופעות?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1523, N'F1359', 1, N'השלם במילים "יש מצב" או "אין מצב". ', N'השלימי במילים "יש מצב" או "אין מצב"', NULL, NULL);
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1524, N'F1360', 1, N'האם יש מצב שתהיה בן זוג של שחקנית שצריכה לצלם סצינות פיזיות עם  גברים אחרים על המסך בסרטי מיינסטרים?', N'האם יש מצב שתהיי בת זוג של שחקן שצריך לצלם סצינות פיזיות עם נשים אחרות על המסך בסרטי מיינסטרים?', NULL, N'האם יש מצב שתהיו בני זוג של שחקנים שצריכים לצלם סצינות פיזיות עם אחרים\ות בסרטי מיינסטרים?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1525, N'F1361', 1, N'השלם במילים "יש מצב" או "אין מצב". ', N'השלימי במילים "יש מצב" או "אין מצב"', NULL, NULL);
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1526, N'F1362', 1, N'במה תבחר נכון לרגע זה?', N'במה תבחרי נכון לרגע זה? ', NULL, NULL);
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1527, N'F1363', 1, N'במה תבחר נכון לרגע זה?', N'במה תבחרי נכון לרגע זה? ', NULL, NULL);
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1528, N'F1364', 1, N'במה תבחר נכון לרגע זה?', N'במה תבחרי נכון לרגע זה? ', NULL, NULL);
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1529, N'F1369', 1, N'מה יש לך בכיסים עכשיו?', N'מה יש לך בכיסים עכשיו?', NULL, N'מה יש לך בכיסים עכשיו?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1530, N'F1370', 1, N'מה אתה לובש עכשיו?', N'מה את לובשת עכשיו?', NULL, NULL);
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1531, N'F1371', 1, N'איזו חובת תחזוקת בית אתה הכי שונא לעשות?', N'איזו חובת תחזוקת בית את הכי שונאת לעשות?', NULL, N'איזו חובת תחזוקת בית אתם הכי שונאים לעשות?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1532, N'F1372', 1, N'אתה שותה אלכוהול בבר. מה הגבול שלך מבחינת כמות או מספר משקאות?', N'את שותה אלכוהול בבר. מה הגבול שלך מבחינת כמות, או מספר משקאות?', NULL, N'האם אתם שמים לעצמכם גבול כשאתם שותים אלכוהול בבילוי בערב?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1533, N'F1373', 1, N'אם תשתתף בחידון, באיזה נושא היית זוכה מקום ראשון?', N'אם תשתתפי בחידון, באיזה נושא היית זוכה מקום ראשון?', NULL, N'אם תשתתף\י בחידון, באיזה נושא היית זוכה מקום ראשון?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1534, N'F1374', 1, N'איזה הרגל של אחד החברים שלך מטריף לך את השכל?', N'איזה הרגל של אחת החברות שלך מטריף לך את השכל?', NULL, N'איזה הרגל של אחד החברים\ות שלך מטריף לך את השכל?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1535, N'F1376', 1, N'השלם:', N'השלימי:', NULL, NULL);
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1536, N'F1377', 1, N'איזה שיר קיטשי אתה הכי אוהב?', N'איזה שיר קיטשי את הכי אוהבת?', NULL, N'איזה שיר רומנטי\קיטשי אתם הכי אוהבים?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1537, N'F1378', 1, N'אתה נבוך כשאתה בחברה ומקרינים סצינת סקס?', N'את נבוכה, כשאת בחברה ומקרינים סצינת סקס?', NULL, N'אם אתם יוצאים לדייט סרט, האם אתם נבוכים כשמקרינים סצינת סקס?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1538, N'F1379', 1, N'מה אתה אוהב לאכול במיטה?', N'מה את אוהבת לאכול במיטה?', NULL, N'האם יש מאכל שאתם אוהבים לאכול במיטה?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1539, N'F1380', 1, N'אם יגידו לך שאתה דומה למישהו מפורסם, למי אתה דומה?', N'אם יגידו לך שאת דומה למישהי מפורסמת, למי את דומה? ', NULL, N'אם אתם דומים למפורסם\ת, למי? ');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1540, N'F1381', 1, N'איזה סוג מסאז'' אתה הכי אוהב?', N'איזה סוג מסאז'' את הכי אוהבת? ', NULL, N'איזה סוג מסאז'' אתם הכי אוהבים?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1541, N'F1382', 1, N'האם יצא לך לטייל משך זמן של לפחות כמה ימים לבד לבד? אם כן, באיזו סיטואציה?', N'האם יצא לך לטייל משך זמן של לפחות כמה ימים לבד לבד? אם כן, באיזו סיטואציה?', NULL, N'האם יצא לך לטייל לפחות כמה ימים לבד לבד? אם כן, באיזו סיטואציה?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1542, N'F1383', 1, N'האם אתה אוהב להירדם עם מוסיקה? איזה?', N'האם את אוהבת להירדם עם מוסיקה? איזה?', NULL, N'האם אתם אוהבים להירדם עם מוסיקה? אם כן, איזה סוג? ');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1543, N'F1384', 1, N'אילו תחתונים יש לך במגירה? ענה ב"כן ו"לא" ', N'אילו תחתונים יש לך במגירה? עני ב"כן ו"לא" ', NULL, N'אילו תחתונים יש לכם במגירה?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1544, N'F1385', 1, N'מה יעשה אותך מאושר יותר בזה הרגע?', N'מה יעשה אותך מאושר יותר בזה הרגע?', NULL, N'מה יעשה אותך מאושר יותר בזה הרגע?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1545, N'F1386', 1, N'השב ב מילים כמו "מאוד, בכלל לא, ככה ככה"', N'השיבי ב מילים כמו "מאוד, בכלל לא, ככה ככה"', NULL, NULL);
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1546, N'F1387', 1, N'באיזה גיל שתית לראשונה אלכוהול? איזה משקה זה היה? ', N'באיזה גיל שתית לראשונה אלכוהול? איזה משקה זה היה? ', NULL, N'באיזה גיל שתית לראשונה אלכוהול? איזה משקה זה היה? ');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1547, N'F1388', 1, N'ספר על משהו חשוב אחד, שכל מי שמכיר אותך אפילו קצת, בטוח יודע עליך. ', N'ספרי על משהו חשוב אחד, שכל מי שמכיר אותך אפילו קצת, בטוח יודע עליך. ', NULL, N'ספר\י על משהו חשוב אחד, שכל מי שמכיר אותך אפילו קצת, בטוח יודע עליך. ');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1548, N'F1389', 1, N'מה אתה רוצה להיות כשתהיה "גדול"? ', N'מה את רוצה להיות כשתהיי "גדולה"? ', NULL, N'מה אתם רוצים להיות כשתהיו "גדולים"?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1549, N'F1390', 1, N'האם יש לך פוביה כלשהי? מהי?', N'האם יש לך פוביה כלשהי? מהי?', NULL, N'האם יש לך פוביה כלשהי? מהי?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1550, N'F1391', 1, N'חולם להיות מפורסם? באיזה תחום?', N'חולמת להיות מפורסמת? באיזה תחום?', NULL, N'הייתם רוצים להיות מפורסמים? באיזה תחום?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1551, N'F1392', 1, N'כשאתה מחייג למישהי, האם יוצא לך לעשות חזרות בראש על מה שאתה הולך להגיד? יש לך דוגמא?', N'כשאת מחייגת למישהו, האם יוצא לך לעשות חזרות בראש על מה שאת הולכת להגיד? יש לך דוגמא?', NULL, N'כשאת\ה מחייג\ת, האם יוצא לך לעשות חזרות בראש על מה שאת\ה הולך\ת להגיד? ');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1552, N'F1393', 1, N'האם אתה שר במקלחת? איזה שיר?', N'האם את שרה במקלחת? איזה שיר? ', NULL, N'האם את\ה שר\ה במקלחת? איזה שיר שרת לעצמך לאחרונה? ');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1553, N'F1394', 1, N'האם יצא לך לשיר בפני קהל? איפה?', N'האם יצא לך לשיר בפני קהל? איפה?', NULL, N'האם יצא לך לשיר בפני קהל? באיזו סיטואציה?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1554, N'F1395', 1, N'מה עדיף? שיהיה לה גוף מדהים, והיא טיפשה במיוחד, או גוף ממוצע, וחכמה במיוחד?', N'מה עדיף? שיהיה לו גוף מדהים והוא טיפש במיוחד? או גוף ממוצע והוא חכם במיוחד?', NULL, N'מה עדיף? גוף מדהים בלי שכל בכלל? או גוף ממוצע וחכם\ה במיוחד?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1555, N'F1396', 1, N'מה עדיף? שיהיה לה חיוך מיליון דולר עם צחוק מעצבן, או חיוך עקום עם צחוק מקסים ומדבק?', N'מה עדיף? שיהיה לו חיוך מיליון דולר עם צחוק מעצבן, או חיוך עקום עם צחוק מקסים ומדבק?', NULL, N'מה עדיף? שיהיה לו\לה חיוך מיליון דולר אבל צחוק מעצבן, או חיוך עקום אבל צחוק מקסים ומדבק?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1556, N'F1397', 1, N'עד כמה חשוב לך שהיא תהיה בנאדם רגיש לאחרים?', N'עד כמה חשוב לך שהוא יהיה בנאדם רגיש לאחרים?', NULL, N'עד כמה חשוב לך שהוא\היא יהיו בנאדם רגיש לאחרים?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1557, N'F1398', 1, N'מה עדיף? שהיא תהיה יפיפיה וגברים יתחילו איתה כל הזמן, או שתהיה ממוצעת, וכך היא תיתקל בפחות פיתויים ביום יום?', N'מה עדיף? שהוא יהיה יפיוף ובחורות יתחילו איתו כל הזמן, או שיהיה ממוצע, וכך הוא יתקל בפחות פיתויים ביום יום?', NULL, N'מה עדיף? שהוא\היא יהיו יפיופים ויתחילו איתם כל הזמן, או שיהיו ממוצעים וכך יתקלו בפחות פיתויים ביום יום?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1558, N'F1399', 1, N'האם אתה מאמין שיש דבר כזה בחורה שהיא "נפש תאומה" שלך? ', N'האם את מאמינה שיש דבר כזה גבר שהוא "נפש תאומה" שלך?', NULL, N'האם אתם מאמינים שיש דבר כזה "נפש תאומה"?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1559, N'F1400', 1, N'ספר על תכונה אחת שבה אתה מאוד דומה לאבא שלך', N'ספרי על תכונה אחת שבה את מאוד דומה לאמא שלך', NULL, N'ספרו על תכונה אחת שבה אתם דומים לאבא\אמא');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1560, N'F1403', 1, N'גש לשיחות וואטסאפ שלך. העתק לכאן הודעה כלשהי שכתבת שמייצגת את מצב הרוח שלך היום', N'גשי לשיחות וואטסאפ שלך. העתיקי לכאן הודעה כלשהי שכתבת שמייצגת את מצב הרוח שלך היום', NULL, N'העתיקו לכאן הודעה כלשהי שכתבתם, שמייצגת את מצב הרוח שלכם היום');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1561, N'F1404', 1, N'עד כמה זה נכון, שאפשר להתאהב באדם יותר בזמן שהוא מפגין חולשה ופגיעות? ', N'עד כמה זה נכון, שאפשר להתאהב באדם יותר בזמן שהוא מפגין חולשה ופגיעות? ', NULL, N'עד כמה זה נכון, שאפשר להתאהב באדם יותר בזמן שהוא מפגין חולשה ופגיעות? ');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1562, N'F1405', 1, N'אם פוגעים בך מאוד בחוסר צדק משווע, האם אתה נוטה לפגוע בחזרה?', N'אם פוגעים בך מאוד בחוסר צדק משווע, האם את נוטה לפגוע בחזרה?', NULL, N'אם פוגעים בך מאוד בחוסר צדק משווע, האם את\ה נוטה לפגוע בחזרה?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1563, N'F1406', 1, N'אם היה לך כדור בדולח שיודע על העתיד שלך... מה היית רוצה לדעת?', N'אם היה לך כדור בדולח שיודע על העתיד שלך... מה היית רוצה לדעת?', NULL, N'אם היה לך כדור בדולח שיודע הכל על החיים, על העתיד על הכל... מה היית רוצה לדעת?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1564, N'F1407', 1, N'כמה אתה זוכר את החלומות שלך?', N'כמה את זוכרת את החלומות שלך? ', NULL, N'איזה אחוז מהחלומות שלכם אתם זוכרים?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1565, N'F1408', 1, N'ספר על הישג שאתה גאה בו מהתקופה האחרונה', N'ספרי על הישג שאתה גאה בו מהתקופה האחרונה', NULL, N'ספר\י על הישג שאתה גאה בו מהתקופה האחרונה');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1566, N'F1409', 1, N'החבר\ה הכי טוב שלך מבקש\ת ממך עזרה כספית. תסכים, או שהחברות לא כוללת כסף?', N'החבר\ה הכי טובה שלך מבקש\ת ממך עזרה כספית. תסכימי, או שהחברות לא כוללת כסף?', NULL, N'החבר\ה הכי טוב\ה מבקש\ת עזרה כספית, האם תסכימו?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1567, N'F1410', 1, N'כמה קניות עשית בשנה האחרונה באינטרנט?', N'כמה קניות עשית בשנה האחרונה באינטרנט?', NULL, N'האם אתם נוהגים לקנות באינטרנט? כמה קניות עשיתם למשל בשנה האחרונה?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1568, N'F1411', 1, N'ספר על זיכרון נעים', N'ספרי על זיכרון נעים', NULL, N'ספ\רי על זיכרון נעים מהשנים האחרונות');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1569, N'F1415', 1, N'איזה עצה בנושא דייטים תיתן לעצמך הצעיר יותר, מהניסיון שלך כיום? (למשל - תבוא בלי ציפיות, ככה לא תתאכזב)', N'איזו עצה בנושא דייטים תתני לעצמך הצעירה יותר, מהניסיון שלך כיום? (למשל - תבואי בלי ציפיות, ככה לא תתאכזבי)', NULL, N'איזו עצה בנושא דייטים הייתם נותנים לעצמכם הצעירים יותר מהניסיון שלכם כיום?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1570, N'F1416', 1, N'מה זה עושה לך אם בחורה מסמיקה בגללך?', N'מה זה עושה לך אם בחור מסמיק בגללך?', NULL, N'מה זה עושה לכם אם מישהו\י מסמיק\ה בגללך?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1571, N'F1417', 1, N'היה לך דייט עם מישהי ונדמה לך שהלך טוב, אבל היא לא עונה ל-SMSים ממך. כמה פעמים תסמס לה עד שתחליט לוותר?', N'היה לך דייט עם מישהו ונדמה שהכל הלך טוב, אבל הוא נעלם ולא עונה ל-SMSים. כמה פעמים\זמן עד שתחליטי לוותר?', NULL, N'היה לכם דייט ונדמה שהכל הלך טוב, אבל הצד השני נעלם ולא עונה. כמה זמן\פעמים תנסו ליצור קשר עד שתחליטו לוותר?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1572, N'F1418', 1, N'קרה שאחרים לא הבינו אותך נכון? אם כן, באיזה עניין?', N'קרה שאחרים לא הבינו אותך נכון? אם כן, באיזה עניין?', NULL, N'קרה שאחרים לא הבינו אותך נכון? אם כן, באיזה עניין?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1573, N'F1419', 1, N'מה בא לך לחלוק?', N'מה בא לך לחלוק?', NULL, NULL);
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1574, N'F1420', 1, N'איך תציג את עצמך בתחילת פגישת עבודה עם אנשים שאתה לא מכיר?', N'איך תציגי את עצמך בתחילת פגישת עבודה עם אנשים שאת לא מכירה?', NULL, N'איך תציגו את עצמכם בתחילת פגישת עבודה עם אנשים שאתם לא מכירים?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1575, N'F1421', 1, N'חבר שלך מפגיש אותך עם חבר''ה שלו שאינך מכיר. איך תציג את עצמך בפניהם? ', N'חברה שלך מפגישה אותך עם חבר''ה שלה שאינך מכירה. איך תציגי את עצמך בפניהם?', NULL, N'חבר\ה שלכם מציגה בפניכם חבר''ה שאינכם מכירים. איך תציגו את עצמכם?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1576, N'F1422', 1, N'נניח שהוזמנת למפגש מחזור של התיכון שלך. כתוב משפט קצר שבזכותו כולם יזהו מייד מי אתה. ', N'נניח שהוזמנת למפגש מחזור של התיכון שלך. כתבי משפט קצר שבזכותו כולם יזהו מייד מי את. ', NULL, N'נניח שהוזמנת למפגש מחזור של התיכון שלך. כתבו משפט קצר שבזכותו כולם יזהו מייד מי אתם. ');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1577, N'F1423', 1, N'מארגנים תחרות כישרונות, ומותר להתחרות בכל תחום שקיים בעולם. במה תבקש להתחרות?', N'מארגנים תחרות כישרונות, ומותר להתחרות בכל תחום שקיים בעולם. במה תבקשי להתחרות?', NULL, N'מארגנים תחרות כישרונות, ומותר להתחרות בכל תחום שקיים בעולם. במה תבקשו להתחרות?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1578, N'F1424', 1, N'איזה בגד הכי מחמיא לך? ', N'איזה בגד הכי מחמיא לך? ', NULL, N'איזה בגד הכי מחמיא לך? ');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1579, N'F1425', 1, N'כמה זמן מותר לאחר לדייט, מבלי שזה נחשב איחור?', N'כמה זמן מותר לאחר לדייט, מבלי שזה נחשב איחור?', NULL, N'כמה זמן מותר לאחר לדייט, מבלי שזה נחשב איחור?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1580, N'F1426', 1, N'מהו הזמן הארוך ביותר שנסעת רצוף במכונית? באיזו סיטואציה זה קרה?', N'מהו הזמן הארוך ביותר שנסעת רצוף במכונית? באיזו סיטואציה זה קרה?', NULL, N'מהו הזמן הארוך ביותר שנסעת רצוף במכונית? באיזו סיטואציה זה קרה?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1581, N'F1427', 1, N'מה הדבר המוזר ביותר שאכלת אי פעם בחופשה?', N'מה הדבר המוזר ביותר שאכלת אי פעם בחופשה?', NULL, N'מה הדבר המוזר ביותר שאכלת אי פעם בחופשה?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1582, N'F1428', 1, N'איפה היתה החופשה הגרועה ביותר שהיתה לך? למה היא היתה כל כך גרועה?', N'איפה היתה החופשה הגרועה ביותר שהיתה לך? למה היא היתה כל כך גרועה?', NULL, N'איפה היתה החופשה הגרועה ביותר שהיתה לך? למה היא היתה כל כך גרועה?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1583, N'F1429', 1, N'איפה היתה החופשה הטובה ביותר שהיתה לך? מה עשה אותה כל כך טובה?', N'איפה היתה החופשה הטובה ביותר שהיתה לך? מה עשה אותה כל כך טובה?', NULL, N'איפה היתה החופשה הטובה ביותר שהיתה לך? מה עשה אותה כל כך טובה?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1584, N'F1431', 1, N'באילו ארצות כבר ביקרת? יאללה לשפוך... ', N'באילו ארצות כבר ביקרת? יאללה לשפוך... ', NULL, N'באילו ארצות כבר ביקרת? יאללה לשפוך... ');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1585, N'F1432', 1, N'איפה אתה נמצא עכשיו ולמה?', N'איפה את נמצאת עכשיו ולמה?', NULL, N'איפה אתם נמצאים עכשיו ולמה?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1586, N'F1433', 1, N'מהי העבודה הכי כיפית שהיתה לך?', N'מהי העבודה הכי כיפית שהיתה לך?', NULL, N'מהי העבודה הכי כיפית שהיתה לך?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1587, N'F1434', 1, N'מהי העבודה הכי מבאסת שהיתה לך?', N'מהי העבודה הכי מבאסת שהיתה לך?', NULL, N'מהי העבודה הכי מבאסת שהיתה לך?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1588, N'F1435', 1, N'תאר במילה אחת את ההבנה והכישורים שלך במחשב', N'תארי את ההבנה והכישורים שלך במחשב', NULL, N'תאר\י את ההבנה והכישורים שלך במחשב');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1589, N'F1436', 1, N'אם היית עף על עצמך באופן מוגזם, איך היית מתאר את עצמך בחצי משפט?', N'אם היית עפה על עצמך באופן מוגזם, איך היית מתארת את עצמך בחצי משפט? ', NULL, N'אם היית עפ\ה על עצמך באופן מוגזם, איך היית מתאר\ת את עצמך בחצי משפט? ');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1590, N'F1437', 1, N'מה הדבר הכי טוב שקרה לך בשבוע האחרון?', N'מה הדבר הכי טוב שקרה לך בשבוע האחרון?', NULL, N'מה הדבר הכי טוב שקרה לך בשבוע האחרון?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1591, N'F1438', 1, N'לאיזה רגע אחד אתה מחכה במיוחד כל השבוע ולא תסכים שיקחו לך אותו?', N'לאיזה רגע אחד את מחכה במיוחד כל השבוע ולא תסכימי שיקחו לך אותו?', NULL, N'לאיזה רגע אחד בשבוע, את\ה הכי מחכה כל השבוע?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1592, N'F1439', 1, N'בתוך מציאות של איזה סרט קולנוע מתחשק לך לחיות את החיים?', N'בתוך מציאות של איזה סרט קולנוע מתחשק לך לחיות את החיים?', NULL, N'בתוך מציאות של איזה סרט קולנוע מתחשק לך לחיות את החיים?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1593, N'F1440', 1, N'יש לך אפשרות לקנות מכונית חדשה בלי מגבלת כסף, איזה רכב תקנה?', N'יש לך אפשרות לקנות מכונית חדשה בלי מגבלת כסף, איזה רכב תקני?', NULL, N'יש לכם אפשרות לקנות מכונית חדשה בלי מגבלת כסף, איזה רכב תקנו?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1594, N'F1441', 1, N'יש לך אפשרות לשנות תכונה אחת שלך, איזו תכונה תשנה?', N'יש לך אפשרות לשנות תכונה אחת שלך, איזו תכונה תשני?', NULL, N'יש לכם אפשרות לשנות תכונה אחת שלך, איזו תכונה תשנו?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1595, N'F1442', 1, N'בעוד 10 שנים מהיום, במה אתה רואה את עצמך עוסק?', N'בעוד 10 שנים מהיום, במה את רואה את עצמך עוסקת?', NULL, N'בעוד 10 שנים מהיום, במה את\ה רואה את עצמך עוסק\ת?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1596, N'F1443', 1, N'נניח שיש לך אפשרות להעלים כמה שעות מהיומן שלך בשבוע הקרוב, מה תמחק?', N'נניח שיש לך אפשרות להעלים כמה שעות מהיומן שלך בשבוע הקרוב, מה תמחקי?', NULL, N'נניח שיש לך אפשרות להעלים כמה שעות מהיומן שלך בשבוע הקרוב, מה תמחק\י?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1597, N'F1444', 1, N'נניח שהיה אפשר לענות לך במדויק על שאלה אחת מכל סוג שעולה לך בראש. איזו שאלה תשאלי?', N'נניח שהיה אפשר לענות לך במדויק על שאלה אחת מכל סוג שעולה לך בראש. איזו שאלה תשאל?', NULL, N'נניח שהיה אפשר לענות לך במדויק על שאלה אחת מכל סוג שעולה לך בראש. איזו שאלה תשאל\י?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1598, N'F1445', 1, N'איזו מיומנות וירטואוזית הכי בא לך שתהיה לך?', N'איזו מיומנות וירטואוזית הכי בא לך שתהיה לך?', NULL, N'איזו מיומנות וירטואוזית הכי בא לך שתהיה לך?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1599, N'F1446', 1, N'יש לך אפשרות לקרוא מחשבות של מישהו. מי זה יהיה?', N'יש לך אפשרות לקרוא מחשבות של מישהו. מי זה יהיה?', NULL, N'יש לך אפשרות לקרוא מחשבות של מישהו. מי זה יהיה?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1600, N'F1448', 1, N'למי אתה הכי מתגעגע עכשיו??', N'למי את הכי מתגעגעת עכשיו?', NULL, N'למי אתם הכי מתגעגעים עכשיו?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1601, N'F1449', 1, N'באיזה מצב רוח קמת הבוקר? ', N'באיזה מצב רוח קמת הבוקר? ', NULL, N'באיזה מצב רוח קמת הבוקר? ');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1602, N'F1456', 1, N'האם יצא לך לקבל משלוח זר פרחים? אם כן, על מה קיבלת אותם בפעם האחרונה שזה קרה?', N'האם יצא לך לקבל משלוח זר פרחים? אם כן, על מה קיבלת אותם בפעם האחרונה שזה קרה?', NULL, N'האם יצא לך לקבל משלוח זר פרחים? אם כן, על מה קיבלת אותם בפעם האחרונה שזה קרה?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1603, N'F1457', 1, N'האם השתתפת פעם בתחרות ספורט עם מדליה או גביע? האם זכית פעם? אם כן, במה?', N'האם השתתפת פעם בתחרות ספורט עם מדליה או גביע? האם זכית פעם? אם כן, במה?', NULL, N'האם השתתפת פעם בתחרות ספורט עם מדליה או גביע? האם זכית פעם? אם כן, במה?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1604, N'F1459', 1, N'מה הדבר הכי מוזר ששמת אי פעם במקרר?', N'מה הדבר הכי מוזר ששמת אי פעם במקרר?', NULL, N'מה הדבר הכי מוזר ששמת אי פעם במקרר?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1605, N'F1460', 1, N'האם זה "אסון" או "לא נורא"', N'האם זה "אסון" או "לא נורא"', NULL, N'האם זה "אסון" או "לא נורא"');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1606, N'F1461', 1, N'האם יוצא לך להסתובב עם שתי גרביים שהן לא זוג?', N'האם יוצא לך להסתובב עם שתי גרביים שהן לא זוג?', NULL, N'האם יוצא לך להסתובב עם שתי גרביים שהן לא זוג?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1607, N'F1462', 1, N'האם זה "אסון" או "לא נורא"', N'האם זה "אסון" או "לא נורא"', NULL, N'האם זה "אסון" או "לא נורא"')
;
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1608, N'F1463', 1, N'בוא נראה אם אתה מפוזר או לא', N'בואו נראה אם את מפוזרת או לא', NULL, N'בואו נראה אם אתם מפוזרים או לא');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1609, N'F1464', 1, N'מה עדיף? ', N'מה עדיף? ', NULL, N'מה עדיף? ');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1610, N'F1465', 1, N'מה עדיף?', N'מה עדיף?', NULL, N'מה עדיף?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1611, N'F1466', 1, N'האם יצא לך להיפרד ממישהי בטלפון\SMS\מייל? אם כן, איך היא קיבלה את זה?', N'האם יצא לך להיפרד ממישהו בטלפון\SMS\מייל? אם כן, איך הוא קיבל את זה? ', NULL, N'האם יצא לך להיפרד ממישהי\ו בטלפון\SMS\מייל? אם כן, איך הוא\היא קיבל\ה את זה? ');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1612, N'F1468', 1, N'מה הדבר הכי שרוט שאתה יכול להגיד על המשפחה שלך בכמה מילים? ', N'מה הדבר הכי שרוט שאת יכולה להגיד על המשפחה שלך בכמה מילים?', NULL, N'מה הדבר הכי שרוט שאתם יכולים להגיד על המשפחה שלכם בכמה מילים?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1613, N'F1469', 1, N'תאר את החוויה שלך מהתיכון ב 2-3 מילים בלבד. ', N'תארי את החוויה שלך מהתיכון ב 2-3 מילים בלבד. ', NULL, N'תאר\י את החוויה שלך מהתיכון ב 2-3 מילים בלבד. ');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1614, N'F1470', 1, N'מה אתה יכול להגיד על החבר הכי מוזר שיש לך? ', N'מה את יכולה להגיד על החברה הכי מוזרה שיש לך?', NULL, N'מה אתם יכולים להגיד על החבר\ה הכי מוזר\ה שיש לכם?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1615, N'F1471', 1, N'ממה אתה הכי מודאג השבוע?', N'ממה את הכי מודאגת השבוע?', NULL, N'ממה אתם הכי מודאגים השבוע?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1616, N'F1472', 1, N'מה הדבר הכי מעודד שקרה לך השבוע?', N'מה הדבר הכי מעודד שקרה לך השבוע?', NULL, N'מה הדבר הכי מעודד שקרה לך השבוע?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1617, N'F1473', 1, N'ההבדל ביני לבין אבא שלי הוא:', N'ההבדל ביני לבין אמא שלי הוא:', NULL, N'ההבדל ביני לבין אבא\אמא שלי הוא:');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1618, N'F1474', 1, N'איזה דבר יוצא דופן עשית בחודש האחרון?', N'איזה דבר יוצא דופן עשית בחודש האחרון?', NULL, N'איזה דבר יוצא דופן עשית בחודש האחרון?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1619, N'F1475', 1, N'בחר', N'בחרי', NULL, NULL);
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1620, N'F1476', 1, N'בחר', N'בחרי', NULL, NULL);
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1621, N'F1477', 1, N'מה אתה מעדיף?', N'מה את מעדיפה?', NULL, NULL);
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1622, N'F1478', 1, N'מה עדיף?', N'מה עדיף?', NULL, NULL);
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1623, N'F1479', 1, N'השלם ב"הייתי" או "לא הייתי" ', N'השלימי ב"הייתי" או "לא הייתי" ', NULL, NULL);
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1624, N'F1480', 1, N'השלם ב"הייתי" או "לא הייתי" ', N'השלימי ב"הייתי" או "לא הייתי" ', NULL, NULL);
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1625, N'F1481', 1, N'השב ב מילים כמו "מאוד, בכלל לא, ככה ככה"', N'השיבי ב מילים כמו "מאוד, בכלל לא, ככה ככה"', NULL, NULL);
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1626, N'F1482', 1, N'השב ב מילים כמו "מאוד, בכלל לא, ככה ככה"', N'השיבי ב מילים כמו "מאוד, בכלל לא, ככה ככה"', NULL, NULL);
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1627, N'F1483', 1, N'השב ב מילים כמו "מאוד, בכלל לא, ככה ככה"', N'השיבי ב מילים כמו "מאוד, בכלל לא, ככה ככה"', NULL, NULL);
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1628, N'F1484', 1, N'השב ב מילים כמו "מאוד, בכלל לא, ככה ככה"', N'השיבי ב מילים כמו "מאוד, בכלל לא, ככה ככה"', NULL, NULL);
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1629, N'F1485', 1, N'מהו המאכל הכי מוזר שאכלת אי פעם?', N'מהו המאכל הכי מוזר שאכלת אי פעם?', NULL, N'מהו המאכל הכי מוזר שאכלת אי פעם?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1630, N'F1487', 1, N'האם היה לך חלום שהספקת לממש? כם כן, מהו?', N'האם היה לך חלום שהספקת לממש? כם כן, מהו?', NULL, N'האם היה לך חלום שהספקת לממש? כם כן, מהו?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1631, N'F1488', 1, N'דרג לפי סדר חשיבות, מה היית מעדיף לקרוא אצל אנשים -  רגשות, מחשבות, או את העתיד?', N'דרגי לפי סדר חשיבות, מה היית מעדיפה לקרוא אצל אנשים -  רגשות, מחשבות, או את העתיד?', NULL, N'דרגו לפי סדר חשיבות, מה הייתם מעדיפים לקרוא אצל אנשים -  רגשות, מחשבות, או את העתיד?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1632, N'F1489', 1, N'אם היית יכול להגביר פי כמה את אחת התכונות החיוביות שלך. איזו תכונה היית מגביר? ', N'אם היית יכולה להגביר פי כמה את אחת התכונות החיוביות שלך. איזו תכונה היית מגבירה? ', NULL, N'אם היית יכול\ה להגביר פי כמה את אחת התכונות החיוביות שלך. איזו תכונה היית מגביר\ה? ');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1633, N'F1490', 1, N'על מה החמיאו לך לאחרונה?', N'על מה החמיאו לך לאחרונה?', NULL, N'על מה החמיאו לך לאחרונה?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1634, N'F1491', 1, N'במה אתה טוב יותר? אינטואיציה רגשית, יכולת מחשבה או יכולת זיכרון? ', N'במה את טובה יותר? אינטואיציה רגשית, יכולת מחשבה או יכולת זיכרון? ', NULL, N'במה את\ה טוב\ה יותר? אינטואיציה רגשית, יכולת מחשבה או יכולת זיכרון? ');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1635, N'F1492', 1, N'השב ב מילים כמו "מאוד, בכלל לא, ככה ככה"', N'השיבי ב מילים כמו "מאוד, בכלל לא, ככה ככה"', NULL, NULL);
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1636, N'F1493', 1, N'האם לדעתך החברים שלך אתה מתנהל לפי אינטואציה, או לפי חשיבה הגיונית? האם הם צודקים?', N'האם לדעתך החברים שלך את מתנהלת לפי אינטואציה, או לפי חשיבה הגיונית? האם הם צודקים?', NULL, N'האם לדעתך החברים שלך את\ה מתנהל\ת לפי אינטואציה, או לפי חשיבה הגיונית? האם הם צודקים?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1637, N'F1494', 1, N'מאמין או לא מאמין? ', N'מאמינה או לא מאמינה?', NULL, N'מאמין\ה או לא? ');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1638, N'F1495', 1, N'כמה קל לך לזהות כשעושים עליך מנפילוציות רגשיות? ואיך אתה מגיב כשזה קורה?', N'כמה קל לך לזהות כשעושים עליך מנפילוציות רגשיות? ואיך את מגיבה כשזה קורה?', NULL, N'כמה קל לך לזהות כשעושים עליך מנפילוציות רגשיות? ואיך את\ה מגיב\ה כשזה קורה?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1639, N'F1496', 1, N'נכון או לא נכון?', N'נכון או לא נכון?', NULL, NULL);
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1640, N'F1497', 1, N'נכון או לא נכון?', N'נכון או לא נכון?', NULL, NULL);
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1641, N'F1498', 1, N'נכון או לא נכון?', N'נכון או לא נכון?', NULL, NULL);
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1642, N'F1499', 1, N'נכון או לא נכון?', N'נכון או לא נכון?', NULL, NULL);
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1643, N'F1500', 1, N'נכון או לא נכון?', N'נכון או לא נכון?', NULL, NULL);
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1644, N'F1501', 1, N'האם אתה יודע לפלרטט עם זרים בקלות, או שלוקח לך זמן להיפתח?', N'האם את יודעת לפלרטט עם זרים בקלות, או שלוקח לך זמן להיפתח?', NULL, N'האם את\ה יודעת לפלרטט עם זרים בקלות, או שלוקח לך זמן להיפתח?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1645, N'F1502', 1, N'מה בא לך יותר היום? מפגש עם חברים הכולל שיחות עם כמה אנשים, או מפגש מעמיק אחד על אחד?', N'מה בא לך יותר היום? מפגש עם חברים הכולל שיחות עם כמה אנשים, או מפגש מעמיק אחד על אחד?', NULL, N'מה בא לך יותר היום? מפגש עם חברים הכולל שיחות עם כמה אנשים, או מפגש מעמיק אחד על אחד?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1646, N'F1503', 1, N'מה בא לך יותר עכשיו? לראות הופעה בפארק, או לצאת לבר עם חברים? ', N'מה בא לך יותר עכשיו? לראות הופעה בפארק, או לצאת לבר עם חברים? ', NULL, N'מה בא לך יותר עכשיו? לראות הופעה בפארק, או לצאת לבר עם חברים? ');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1647, N'F1504', 1, N'האם בנות התחילו איתך פעם? אם כן, איך זה הרגיש?', N'האם יצא לך להתחיל עם גברים? אם כן, איך הם קיבלו את זה?', NULL, N'האם יצא לך להתחיל עם גברים? ולגבר, האם מישהי התחילה איתך פעם?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1648, N'F1505', 1, N'אם אתה חייב לבחור, עדיף שהיא תהיה ספונטנית, או מסתורית?', N'אם את חייבת לבחור, עדיף שהוא יהיה ספונטני, או מסתורי? ', NULL, N'אם את\ה חייב\ת לבחור, עדיף שהוא\היא יהיו ספונטני\ת או מסתור\ית');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1649, N'F1506', 1, N'אם אתה חייב לבחור, עדיף שהיא תהיה יודעת להקשיב, או יודעת לדבר?', N'אם את חייבת לבחור, עדיף שהוא יהיה יודע להקשיב או יודע לדבר? ', NULL, N'אם את\ה חייב\ת לבחור, עדיף שהוא\היא יהיו יודע\ת להקשיב או יודע\ת לדבר?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1650, N'F1507', 1, N'האם עדיף שאתה תהיה כל העולם שלה, או שיהיו לה תחומי עניין שיעסיקו אותה גם בלעדיך?', N'האם עדיף שאת תהיי כל העולם שלו, או שיהיו לו תחומי עניין שיעסיקו אותו גם בלעדייך? ', NULL, N'האם עדיף שאתם תהיו כל העולם עבור בן\בת הזוג, או שיהיו להם תחומי עניין שיעסיקו אותם גם בלעדיכם?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1651, N'F1508', 1, N'החברה אומרת לך שהיא רוצה לצאת לניו יורק לשבוע חופשת בנות בלעדיך. איך תרגיש עם זה?', N'החבר אומר לך שהוא רוצה לצאת לחופשת לתאילנד לשבוע חופשת בנים בלעדייך. איך תרגישי עם זה?', NULL, N'החבר\ה אומר\ת שהוא\היא רוצה לצאת לחופשת בנים\בנות בלעדיכם, איך תרגישו עם זה?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1652, N'F1509', 1, N'החברה בנסיעת עבודה בחו"ל, ובגלל נסיבות, היא תצטרך לישון באותו החדר במלון עם עמית לעבודה שהוא גבר. האם זה מקובל עליך?', N'החבר בנסיעת עבודה בחו"ל ובגלל נסיבות הוא יצטרך לישון באותו החדר במלון עם עמיתה לעבודה שהיא בחורה. האם זה מקובל עלייך?', NULL, N'בן\בת הזוג בחו"ל והם נאלצים לישון באותו החדר עם בן\בת המין השני. האם זה מקובל עליכם? ');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1653, N'F1510', 1, N'כתוב רעיון לדייט שאינו מקובל בדרך כלל, לדוגמא -  דייט בחנות ספרים תוך כדי בחירת ספר. ', N'כתבי רעיון לדייט שאינו מקובל בדרך כלל, לדוגמא -  דייט בחנות ספרים תוך כדי בחירת ספר. ', NULL, N'כתבו רעיון לדייט שאינו מקובל בדרך כלל, לדוגמא -  דייט בחנות ספרים תוך כדי בחירת ספר. ');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1654, N'F1511', 1, N'דרג עד כמה חשובים לך הערכים הבאים, במילים כמו "מאוד, בכלל לא, ככה ככה" ', N'דרגי עד כמה חשובים לך הערכים הבאים, במילים כמו "מאוד, בכלל לא, ככה ככה" ', NULL, NULL);
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1655, N'F1512', 1, N'דרג עד כמה חשובים לך הערכים הבאים, במילים כמו "מאוד, בכלל לא, ככה ככה" ', N'דרגי עד כמה חשובים לך הערכים הבאים, במילים כמו "מאוד, בכלל לא, ככה ככה" ', NULL, NULL);
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1656, N'F1513', 1, N'באיזה דבר אם מעצבנים אותך בו - פחד אלוהים להסתבך איתך?', N'באיזה דבר אם מעצבנים אותך בו - פחד אלוהים להסתבך איתך?', NULL, N'באיזה תחום אם מעצבנים אותך - פחד אלוהים להסתבך איתך?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1657, N'F1514', 1, N'באיזה תחום אתה מוותר תמיד, שאפשר להגדיר אותך לגמרי פרייר? ', N'באיזה תחום את מוותרת תמיד, שאפשר להגדיר אותך לגמרי פריירית? ', NULL, N'באיזה תחום אתם מוותרים תמיד, שאפשר להגדיר אתכם לגמרי פריירים?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1658, N'F1515', 1, N'מה גרם לך לחייך ביום יומיים האחרונים?', N'מה גרם לך לחייך ביום יומיים האחרונים?', NULL, N'מה גרם לך לחייך ביום יומיים האחרונים?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1659, N'F1516', 1, N'מה עיצבן אותך במיוחד בשבוע האחרון?', N'מה עיצבן אותך במיוחד בשבוע האחרון?', NULL, N'מה עיצבן אותך במיוחד בשבוע האחרון?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1660, N'F1517', 1, N'מה העציב אותך בשבוע האחרון?', N'מה העציב אותך בשבוע האחרון?', NULL, N'מה העציב אותך בשבוע האחרון?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1661, N'F1518', 1, N'מה איכזב אותך בשבוע האחרון?', N'מה איכזב אותך בשבוע האחרון?', NULL, N'מה איכזב אותך בשבוע האחרון?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1662, N'F1519', 1, N'אילו שלושה דברים הכי מעצבנים אותך בחיים?', N'אילו שלושה דברים הכי מעצבנים אותך בחיים?', NULL, N'אילו שלושה דברים הכי מעצבנים אותך בחיים?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1663, N'F1520', 1, N'האם אי פעם קינאת בחבר שלך? אם כן, מה? ', N'האם אי פעם קינאת בחברה שלך? אם כן, מה? ', NULL, N'האם אי פעם קינאת בחבר\ה שלך? אם כן, מה? ');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1664, N'F1521', 1, N'באיזו מידה אתה נוהג להשתמש בדברים הלא נוחים הבאים, השב במילים "הרבה, בכלל לא, קצת" וכו''... ', N'באיזו מידה את נוהגת להשתמש בדברים הלא נוחים הבאים, השיבי במילים "הרבה, בכלל לא, קצת" וכו''... ', NULL, N'באילו מהאביזרים הלא נוחים הבאים אתם משתמשים?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1665, N'F1522', 1, N'אם אתה צריך לצאת ב 8:00 בבוקר מהבית, לאיזו שעה תכוון שעון? ', N'אם את צריכה לצאת ב 8:00 בבוקר מהבית, לאיזו שעה תכווני שעון? ', NULL, N'אם אתם צריכים לצאת ב 8:00 בבוקר מהבית, לאיזו שעה תכוונו שעון? ');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1666, N'F1523', 1, N'מהר או לאט?', N'מהר או לאט?', NULL, N'מהר או לאט?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1667, N'F1524', 1, N'מהר או לאט?', N'מהר או לאט?', NULL, N'מהר או לאט?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1668, N'F1525', 1, N'איך אתה ישן?', N'איך את ישנה? ', NULL, NULL);
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1669, N'F1526', 1, N'עד כמה אתה בחור רגוע מלא בשלווה? ', N'עד כמה את בחורה רגועה ושלווה? ', NULL, N'עד כמה אתם רגועים ושלווים? ');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1670, N'F1527', 1, N'באיזה תחום אתה מרגיש חסר ביטחון לפעמים? ', N'באיזה תחום את מרגישה חסרת ביטחון לפעמים?', NULL, N'באיזה תחום אתם מרגישים חסרי ביטחון לפעמים?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1671, N'F1528', 1, N'באיזו דרך אתה נפגש עם הידידות שלך? חיבוק, לחיצת יד, נפנוף לשלום, חיוך, נשיקה בלחי, נשיקה קלה בשפתיים?', N'באיזו דרך את נפגשת עם הידידים שלך? חיבוק, לחיצת יד, נפנוף לשלום, חיוך, נשיקה בלחי, נשיקה קלה בשפתיים?', NULL, N'באיזו דרך את\ה נפגשת עם הידידים\ות שלך? חיבוק, לחיצת יד, נפנוף לשלום, חיוך, נשיקה בלחי, נשיקה קלה בשפתיים?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1672, N'F1529', 1, N'מתי קיללת בפעם האחרונה, ומה היתה הקללה?', N'מתי קיללת בפעם האחרונה, ומה היתה הקללה?', NULL, N'מתי קיללת בפעם האחרונה, ומה היתה הקללה?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1673, N'F1530', 1, N'מודיעים לך בהפתעה שקיבלת את עבודת החלומות שלך. איך תגיב? (למשל, ניתור ביחד עם "יש!" או רק חיוך סיפוק וכו''...)', N'מודיעים לך בהפתעה שהתקבלת לעבודת החלומות שלך. איך תגיבי? (למשל, ניתור ביחד עם "יש!" או רק חיוך סיפוק וכו''...)', NULL, N'מודיעים לך בהפתעה שהתקבלת לעבודת החלומות שלך. איך תגיב\י? (למשל, ניתור ביחד עם "יש!" או רק חיוך סיפוק וכו''...)');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1674, N'F1531', 1, N'מה הכי כדאי לעשות מייד אחרי השחרור מצה"ל? טיול גדול (איפה?), לימודים, סתם לחיות?', N'מה הכי כדאי לעשות מייד אחרי השחרור מצה"ל? טיול גדול (איפה?), לימודים, סתם לחיות?', NULL, N'מה הכי כדאי לעשות מייד אחרי השחרור מצה"ל? טיול גדול (איפה?), לימודים, סתם לחיות?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1675, N'F1532', 1, N'איך אתה מעביר את הזמן כשאתה לבד בבית בערב, אחרי יום עבודה מתיש?', N'איך את מעבירה את הזמן כשאת לבד בבית בערב, אחרי יום עבודה מתיש?', NULL, N'איך אתם מעבירים את הזמן כשאתם לבד בבית בערב אחרי יום עבודה מתיש?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1676, N'F1533', 1, N'האם אתה מחשיב את עצמך כ"יודע להתלבש"? האם אתה קונה לעצמך לבד את הבגדים?', N'האם את מחשיבה את עצמך כ"יודעת להתלבש"? האם את קונה לעצמך לבד את הבגדים? ', NULL, N'האם אתם מחשיבים את עצמכם כ"יודעים להתלבש"? האם אתם קונים לעצמכם לבד את הבגדים?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1677, N'F1534', 1, N'האם כילד היית נוהג לאכול כל הזמן "שניצל ואורז", או שקיבלת גם אוכל ביתי מושקע יותר?  איזה מאכל הכי אהבת בילדות?', N'האם כילדה היית נוהגת לאכול כל הזמן "שניצל ואורז", או שקיבלת גם אוכל ביתי מושקע יותר?  איזה מאכל הכי אהבת בילדות?', NULL, N'האם כילד\ה היית נוהג\ת לאכול כל הזמן "שניצל ואורז", או שקיבלת גם אוכל ביתי מושקע יותר? ');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1678, N'F1535', 1, N'איזה בילוי הכי מועדף עליך כשאתה עם המשפחה שלך?', N'איזה בילוי הכי מועדף עליך כשאת עם המשפחה שלך?', NULL, N'איזה בילוי הכי מועדף עליך כשאת\ה עם המשפחה שלך?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1679, N'F1536', 1, N'איזה בילוי הכי מועדף עליך כשאתה עם החבר''ה שלך?', N'איזה בילוי הכי מועדף עליך כשאת עם החבר''ה שלך?', NULL, N'איזה בילוי הכי מועדף עליך כשאת\ה עם החבר''ה שלך?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1680, N'F1537', 1, N'נניח שאתה יוצא לדייט חשוב וקיבלת תקציב בלתי מוגבל לקנות בגדים. מה תלבש?', N'נניח שאת יוצאת לדייט חשוב וקיבלת תקציב בלתי מוגבל לקנות בגדים. מה תלבשי?', NULL, N'נניח שאת\ה יוצא\ת לדייט חשוב וקיבלת תקציב בלתי מוגבל לקנות בגדים. מה תלבש\י?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1681, N'F1538', 1, N'בחר עם מי לדבר על כל נושא: (למשל - משפחה \ חברה טובה \ בוס \ פורום אנונימי וכו''...) ', N'בחרי עם מי לדבר על כל נושא: (למשל - משפחה \ חברה טובה \ בוס \ פורום אנונימי וכו''...) ', NULL, N'בחר\י עם מי לדבר על כל נושא');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1682, N'F1539', 1, N'באילו נושאים אתה עקשן ומתקשה לוותר?', N'באילו נושאים את עקשנית ומתקשית לוותר?', NULL, N'באילו נושאים אתם עקשנים ומתקשים לוותר?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1683, N'F1540', 1, N'עד כמה אתה זורם עם נימוס בסטייל בריטי אירופאי קלאסי?', N'עד כמה את זורמת עם נימוס בסטייל בריטי אירופאי קלאסי?', NULL, N'עד כמה אתם מנומסים עם גינונים בסטייל בריטי אירופאי קלאסי?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1684, N'F1541', 1, N'עם מי התווכחת בשבוע האחרון ועל מה?', N'עם מי התווכחת בשבוע האחרון ועל מה?', NULL, N'עם מי התווכחת בשבוע האחרון ועל מה?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1685, N'F1542', 1, N'איזו קריירה אתה חושב שהכי מתאימה לך? ', N'איזו קריירה את חושבת שהכי מתאימה לך? ', NULL, N'איזו קריירה את\ה חושב\ת שהכי מתאימה לך? ');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1686, N'F1543', 1, N'עד כמה מתאים לך להיות "הבוס" ולנהל אחרים? ', N'עד כמה מתאים לך להיות "הבוס" ולנהל אחרים? ', NULL, N'עד כמה בא לך להיות "הבוס" ולנהל אחרים? ');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1687, N'F1544', 1, N'אתה בקניון ועכשיו קיבלת 1,000 ₪. על מה תבזבז אותם?', N'את בקניון ועכשיו קיבלת 1,000 ₪. על מה תבזבזי אותם?', NULL, N'את\ה בקניון ועכשיו קיבלת 500 ₪. על מה תבזבז\י אותם?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1688, N'F1545', 1, N'עד כמה אתה דייקן ופרפקציוניסט?', N'עד כמה את דייקנית ופרפקציוניסטית?', NULL, N'עד כמה אתם דייקנים ופרפקציוניסטים?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1689, N'F1546', 1, N'האם אתה חולמני, או איש של תכלס?', N'האם את חולמנית או אישה של תכלס? ', NULL, N'האם אתם חולמניים או אנשים של תכלס?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1690, N'F1547', 1, N'בוקר. אתה עומד לצאת מהבית, ולפתע מודיעים לך שהפגישה נדחתה בשעתיים. איך תעביר את הזמן בבית?', N'בוקר. את עומדת לצאת מהבית, ולפתע מודיעים לך שהפגישה נדחתה בשעתיים. איך תעבירי את הזמן בבית? ', NULL, N'בוקר, אתם עומדים לצאת מהבית, ולפתע מודיעים לכם שהפגישה נדחתה בשעתיים. איך תעבירו את הזמן בבית?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1691, N'F1548', 1, N'עד כמה אתה טיפוס שיודע להזיז אנשים, מסוגל לארגן הפגנות, לידר? ', N'עד כמה את טיפוס שיודעת להזיז אנשים, מסוגלת לארגן הפגנות, לידרית? ', NULL, N'עד כמה אתם טיפוסים שיודעים להזיז אנשים, מסוגלים לארגן הפגנות, לידרים? ');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1692, N'F1549', 1, N'היום - בית עם גינה או פנטהאוז במרכז העיר? ועוד 10 שנים? ', N'היום - בית עם גינה או פנטהאוז במרכז העיר? ועוד 10 שנים? ', NULL, N'היום - בית עם גינה או פנטהאוז במרכז העיר? ועוד 10 שנים? ');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1693, N'F1550', 1, N'האם את פמיניסטית שחושבת שצריך שיוויון מוחלט? או שלפעמים אולד פאשן זה נחמד לך?', N'האם אתה פמיניסטי שחושב שצריך שיוויון מוחלט? או שלפעמים אולד פאשן זה נחמד לך?', NULL, N'האם את\ה פמיניסטי\ת שחושב \תשצריך שיוויון מוחלט? או שלפעמים אולד פאשן זה נחמד לך?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1694, N'F1551', 1, N'אילו תכשיטים אתה אוהב אם היא תשים עליה, ובאיזו מידה. השתמש במילים "מאוד, קצת, בינוני"', N'אילו תכשיטים את אוהבת לשים עליך, ובאיזו מידה, השתמשי במילים "מאוד, קצת, בינוני"', NULL, NULL);
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1695, N'F1552', 1, N'מחר יום חופש! איך תבחר לבלות אותו? ', N'מחר יום חופש. איך תבחרי לבלות אותו?', NULL, N'מחר יום חופש. איך תבחרו לבלות אותו?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1696, N'F1553', 1, N'מהו הדייט השני האידיאלי בעיניך? דרג מ 1 עד 10', N'מהו הדייט השני האידיאלי בעיניך? דרג מ 1 עד 10', NULL, N'מהו הדייט השני האידיאלי בעיניך?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1697, N'F1554', 1, N'נשלחת למשימה במאדים על ידי נאסא. אילו שלושה דברים תקח איתך לחללית?', N'נשלחת למשימה במאדים על ידי נאסא. אילו שלושה דברים תקחי איתך לחללית?', NULL, N'נשלחת למשימה במאדים על ידי נאסא. אילו שלושה דברים תקח\י איתך לחללית?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1698, N'F1555', 1, N'אם היו מאבחנים אצלך איזו הפרעה אישיותית, מה היא היתה?', N'אם היו מאבחנים אצלך איזו הפרעה אישיותית, מה היא היתה?', NULL, N'אם היו מאבחנים אצלך איזו הפרעה אישיותית, מה היא היתה?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1699, N'F1556', 1, N'מה אתה רואה בטלוויזיה במיטה לפני השניה?', N'מה את רואה בטלוויזיה במיטה לפני השניה?', NULL, N'מה את\ה רואה בטלוויזיה במיטה לפני השניה?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1700, N'F1557', 1, N'לאיזה הרגל אתה מכור באופן קשה?', N'לאיזה הרגל את מכורה באופן קשה?', NULL, N'לאיזה הרגל מכורים באופן קשה? ');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1701, N'F1558', 1, N'לאיזה מאכל אתה מכור באופן הרסני?', N'לאיזה מאכל את מכורה באופן הרסני?', NULL, N'לאיזה מאכל אתם מכורים באופן הרסני?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1702, N'F1559', 1, N'אם תוכל לסגור חשבון עם מישהו מהעבר שפגע בך שלא בצדק, על מה ועם מי זה יהיה? ', N'אם תוכלי לסגור חשבון עם מישהו מהעבר שפגע בך שלא בצדק, על מה ועם מי זה יהיה? ', NULL, N'אם תוכל\י לסגור חשבון עם מישהו מהעבר שפגע בך שלא בצדק, על מה ועם מי זה יהיה? ');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1703, N'F1560', 1, N'קרה לך שידידה התקשרה אליך לבוא לבכות לך? על מה?', N'קרה לך שידיד התקשר אליך לבוא לבכות לך? על מה?', NULL, N'קרה לך שידיד\ה התקשר אליך לבוא לבכות לך? על מה?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1704, N'F1561', 1, N'תאר את הלבוש שלך כשיצאת אתמול בבוקר מהבית.', N'תארי את הלבוש שלך כשיצאת אתמול בבוקר מהבית.', NULL, N'תאר\י את הלבוש שלך כשיצאת אתמול בבוקר מהבית.');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1705, N'F1562', 1, N'הבוס שלך מספר בדיחה ממש לא מצחיקה. מה תעשה?', N'הבוס שלך מספר בדיחה ממש לא מצחיקה. מה תעשי?', NULL, N'הבוס שלך מספר בדיחה ממש לא מצחיקה. מה תעשה\י?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1706, N'F1563', 1, N'בכללי אתה טיפוס חסכן או בזבזן? ', N'בכללי את טיפוס של חסכנית או בזבזנית?', NULL, N'בכללי אתם טיפוסים חסכנים או בזבזנים?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1707, N'F1564', 1, N'בחר שתי תכונות שהכי נחשבות בעיניך מהרשימה: מלאת השראה, מבט חודר, אמיצה, מבריקה, יודעת להקשיב, יודעת להתלבש, רוקדת מדהים.', N'בחרי שתי תכונות שהכי נחשבות בעיניך מהרשימה: מלא השראה, מבט חודר, אמיץ, מבריק, יודע להקשיב, יודע להתלבש', NULL, N'בחרו שתי תכונות שהכי נחשבות בעיניכם מהרשימה:')
;
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1708, N'F1565', 1, N'אהבה היא: מסובכת, מדהימה, מפחידה, אוויר לנשימה, מכאיבה, עיוורת. בחר מהרשימה (או הוסף משלך)', N'אהבה היא: מסובכת, מדהימה, מפחידה, אוויר לנשימה, מכאיבה, עיוורת. בחרי מהרשימה (או הוסיפי משלך)', NULL, N'אהבה היא: מסובכת, מדהימה, מפחידה, אוויר לנשימה, מכאיבה, עיוורת. בחרו מהרשימה (או הוסיפו משלך)');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1709, N'F1566', 1, N'עד כמה אתה נחשב בעיני אעצמך לגבר שנפתח בקלות ויודע לשתף דברים אינטימיים?', N'עד כמה את נחשבת בעיני עצמך לאישה שנפתחת בקלות ויודעת לשתף דברים אינטימיים?', NULL, N'עד כמה אתם נחשבים בעיני עצמכם לכאלה שנפתחים בקלות ויודעים לשתף דברים אינטימיים?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1710, N'F1567', 1, N'האם השתנית הרבה מכפי שהיית לפני 5 שנים? אם כן, במה?', N'האם השתנית הרבה מכפי שהיית לפני 5 שנים? אם כן, במה?', NULL, N'האם השתנית הרבה מכפי שהיית לפני 5 שנים? אם כן, במה?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1711, N'F1568', 1, N'האם יצא לך מתישהו להעיר לאישה הערה מביכה, למשל שיש לה ריח רע מהפה? למי? ומה?', N'האם יצא לך מתישהו להעיר לגבר הערה מביכה, למשל שיש לו ריח רע מהפה? למי ומה?', NULL, N'האם יצא לכם מתישהו להעיר לגבר הערה מביכה? ');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1712, N'F1569', 1, N'האם אתה בקשר עם חברי ילדות? עם כמה ומי?', N'האם את בקשר עם חברי ילדות? עם כמה ומי?', NULL, N'האם את\ה בקשר עם חברי ילדות? עם כמה ומי?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1713, N'F1570', 1, N'על איזו טמפרטורה אתה מכוון את המזגן בקיץ? אתה אוהב שהרוח עליך?', N'על איזו טמפרטורה את מכוונת את המזגן בקיץ? את אוהבת שהרוח עליך?', NULL, N'האם באופן כללי חם לכם? על איזו טמפרטורה אתם מכוונים את המזגן? אתם אוהבים שהרוח עליכם?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1714, N'F1571', 1, N'האם באופן כללי קר לך? עם איזו שמיכה אתה ישן בחורף? עם כמה שכבות אתה יוצא מהבית ביום חורפי?', N'האם באופן כללי קר לך? עם איזו שמיכה את ישנה בחורף? עם כמה שכבות את יוצאת מהבית ביום חורפי?', NULL, N'האם באופן כללי קר לך? עם איזו שמיכה את\ה ישנ\ה בחורף? עם כמה שכבות את\ה יוצא\ת מהבית ביום חורפי?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1715, N'F1572', 1, N'מה אתה נוהג לומר לאנשים שמקטרים ומתלוננים כל הזמן? ', N'מה את נוהגת לומר לאנשים שמקטרים ומתלוננים כל הזמן?', NULL, N'מה אתם נוהגים לומר לאנשים שמקטרים ומתלוננים כל הזמן?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1716, N'F1573', 1, N'כמה פעמים הכנת בשבועיים האחרונים ארוחת ערב? מה הכנת בעיקר? ', N'כמה פעמים הכנת בשבועיים האחרונים ארוחת ערב? מה הכנת בעיקר? ', NULL, N'כמה פעמים הכנת בשבועיים האחרונים ארוחת ערב מושקעת? מה הכנת בעיקר? ');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1717, N'F1574', 1, N'כמה זוגות נעליים יש לך בטוטאל? בבקשה פרט... (כולל סנדלים, כפכפים, קרוקס, הכל הולך)', N'כמה זוגות נעליים יש לך בטוטאל? בבקשה פרטי... (כולל סנדלים, כפכפים, קרוקס, הכל הולך)', NULL, N'כמה זוגות נעליים יש לך בטוטאל? בבקשה פרט\י... (כולל סנדלים, כפכפים, קרוקס, הכל הולך)');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1718, N'F1575', 1, N'האם יצא לך להיות בשנה האחרונה ממש שיכור? באילו נסיבות?', N'האם יצא לך להיות בשנה האחרונה ממש שיכורה? באילו נסיבות?', NULL, N'האם יצא לך להיות בשנה האחרונה ממש שיכור\ה? באילו נסיבות?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1719, N'F1576', 1, N'כמה שעות אתה ישן בממוצע בלילה? כמה היית רוצה לישון? ', N'כמה שעות את ישנה בממוצע בלילה? כמה היית רוצה לישון? ', NULL, N'כמה שעות את\ה ישנ\ה בממוצע בלילה? כמה היית רוצה לישון? ');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1720, N'F1578', 1, N'אתה שנתיים באי בודד. קבע דרגת חשיבות לדברים מהרשימה שלדעתך חשוב שיהיו איתך שם. השתמש במילים "חשוב מאוד, לא חשוב, קצת חשוב, וכו''"', N'את שנתיים באי בודד. קבעי דרגת חשיבות לדברים מהרשימה שלדעתך חשוב שיהיו איתך שם. השתמשי במילים "חשוב מאוד, לא חשוב, קצת חשוב, וכו''"', NULL, N'אתם שנתיים באי בודד');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1721, N'F1579', 1, N'פרט חלום אופטימי שאתה זוכר שחלמת.', N'פרטי חלום אופטימי שאתה זוכר שחלמת.', NULL, N'פרט\י חלום אופטימי שאתה זוכר שחלמת.');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1722, N'F1580', 1, N'פרט בבקשה חלום מפחיד שאתה זוכר שחלמת', N'פרטי בבקשה חלום מפחיד שאת זוכרת שחלמת', NULL, N'פרט\י חלום מפחיד שאתה זוכר שחלמת');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1723, N'F1581', 1, N'האם יצא לך פעם שחזית משהו והוא התגשם במדויק באופן מפתיע? אם כן, מה?', N'האם יצא לך פעם שחזית משהו והוא התגשם במדויק באופן מפתיע? אם כן, מה?', NULL, N'האם יצא לך פעם שחזית משהו והוא התגשם במדויק באופן מפתיע? אם כן, מה זה היה?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1724, N'F1582', 1, N'השלם במילים "כן" או "לא" או "קצת"', N'השלימי במילים "כן" או "לא" או "קצת"', NULL, NULL);
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1725, N'F1583', 1, N'השלם במילים "כן" או "לא" או "קצת"', N'השלימי במילים "כן" או "לא" או "קצת"', NULL, NULL);
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1726, N'F1584', 1, N'דרג מה יותר חשוב: קריירה טובה יותר, השכלה רחבה יותר, משפחה גדולה יותר?', N'דרגי מה יותר חשוב: קריירה טובה יותר, השכלה רחבה יותר, משפחה גדולה יותר?', NULL, N'דרגו מה יותר חשוב');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1727, N'F1585', 1, N'מתי בפעם האחרונה:', N'מתי בפעם האחרונה:', NULL, NULL);
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1728, N'F1586', 1, N'איפה אתה חולם להתחתן? תן ציון מ 1 עד 10 ללוקיישנים הבאים:', N'איפה את חולמת להתחתן? תני ציון מ 1 עד 10 ללוקיישנים הבאים:', NULL, N'איפה את\ה חולם\ת להתחתן? ');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1729, N'F1587', 1, N'הוזמנת למסיבה עם החברה החדשה שלך, והיא מדברת עם גברים אחרים המון, יותר מאשר איתך. כתוב לה SMS', N'הוזמנת למסיבה עם החבר החדש שלך, והוא מדבר עם נשים אחרות המון, יותר מאשר איתך. כתבי לו SMS', NULL, N'כתבו SMS לחבר\ה החדש\ה שמקדיש\ה יותר זמן לאחרים מאשר אליכם');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1730, N'F1588', 1, N'אתה מפגיש את החברה החדשה עם ההורים שלך. מה יהיה נחשב בעיניך להתנהגות לא מכובדת מצידה. ', N'את מפגישה את החבר החדש עם ההורים שלך. מה יהיה נחשבך בעיניך להתנהגות לא מכובדת מצידו?', NULL, N'אתם מפגישים את החבר\ה החדש\ה עם ההורים. מה נחשבת בעיניכם התנהגות לא מכובדת?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1731, N'F1589', 1, N'תן דוגמא ל"איך אסור להתנהג איתך בדייט ראשון". ', N'תני דוגמא ל"איך אסור להתנהג איתך בדייט ראשון". ', NULL, N'תן\י דוגמא ל"איך אסור להתנהג איתך בדייט ראשון". ');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1732, N'F1590', 1, N'כמה נכון המשפט -  "הרבה בנות נמשכות דווקא לגברים שמתנהגים כמו חארות?"', N'כמה נכון המשפט -  "הרבה בנות נמשכות דווקא לגברים שמתנהגים כמו חארות?"', NULL, N'כמה נכון המשפט -  "הרבה בנות נמשכות דווקא לגברים שמתנהגים כמו חארות?"');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1733, N'F1591', 1, N'כמה נכון המשפט -  "הרבה גברים נמשכים דווקא לבנות שמתעללות בהם רגשית?"', N'כמה נכון המשפט -  "הרבה גברים נמשכים דווקא לבנות שמתעללות בהם רגשית?"', NULL, N'כמה נכון המשפט -  "הרבה גברים נמשכים דווקא לבנות שמתעללות בהם רגשית?"');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1734, N'F1592', 1, N'אתה יוצא לבליינד דייט והיא מבקשת שאתה תבחר לבדך את מקום ואופי הבילוי - מה תבחר?', N'את יוצאת  לבליינד דייט והוא מבקש שאת תבחרי לבדך את מקום ואופי הבילוי. מה תבחרי?', NULL, N'אתם יוצאים לבליינד דייט, ואתם צריכים לבחור לבד את מקום ואופי הבילוי');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1735, N'F1593', 1, N'באוניברסיטה! איזה דייט מועדף עליך. השב במילים כמו "מעולה, גרוע, סביר" ', N'באוניברסיטה! איזה דייט מועדף עליך. השיבי במילים כמו "מעולה, גרוע, סביר" ', NULL, N'באוניברסיטה! איזה דייט מועדף עליך.');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1736, N'F1594', 1, N'מה פער הגילאים המקסימלי המקובל עליך?', N'מה פער הגילאים המקסימלי המקובל עליך?', NULL, NULL);
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1737, N'F1595', 1, N'איזה דבר אחד עשית בעבר, שמחשיב אותך להרפתקן בעיניך?', N'איזה דבר אחד עשית בעבר, שמחשיב אותך להרפתקנית בעיניך?', NULL, N'איזה דבר אחד עשית בעבר, שמחשיב אותך להרפתקן\ית בעיניך?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1738, N'F1596', 1, N'גורלך תלוי באיכות הסנדוויץ שתכין עבורה. תאר את הסנדוויץ. ', N'גורלך תלוי באיכות הסנדוויץ שתכיני עבורו. תארי את הסנדוויץ. ', NULL, N'גורלך תלוי באיכות הסנדוויץ שתכינ\י עבורו\ה. תאר\י את הרכב הסנדוויץ. ');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1739, N'F1597', 1, N'ספר על גבר (ידוע) אחד שמרשים אותך כל כך עד שאתה אומר "אני מת להיות כמוהו"', N'ספרי על אישה אחת (ידועה) שמרשימה אותך כל כך, עד שאת אומרת "אני מתה להיות כמוה"', NULL, N'ספרו על מישהו\י שמרשימים אתכם כל כך עד שאתם רוצים להיות כמוהם\הן');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1740, N'F1598', 1, N'דרג מ 1 עד 100 כמה אתה דומה לגברים הבאים:', N'את בבר, ומולך עומדים שלושה גברים. דרגי מ 1 עד 100 את הסיכויים במי מהם תבחרי. ', NULL, NULL);
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1741, N'F1599', 1, N'אתה בבר ומולך עומדות שלוש נשים. דרג מ 1 עד 100 את הסיכויים במי מהן תבחר. ', N'דרגי מ 1 עד 100 עד כמה את דומה לנשים הבאות:', NULL, NULL);
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1742, N'F1600', 1, N'איזה דבר מטופש שאתה מתחרט עליו, עשית בשבוע האחרון?', N'איזה דבר מטופש שאת מתחרטת עליו, עשית בשבוע האחרון?', NULL, N'איזה דבר מטופש שאת\ה מתחרט\ת עליו, עשית בשבוע האחרון?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1743, N'F1601', 1, N'אילו סוגי מדים (כל סוג של בגדי עבודה) עושים לך את זה אצל אישה?', N'אילו סוגי מדים (כל סוג של בגדי עבודה) עושים לך את זה אצל גבר?', NULL, N'אילו סוגי מדים (כל סוג של בגדי עבודה) עושים לך את זה אצל אישה\גבר?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1744, N'F1602', 1, N'עד כמה גברים בסטאטוס חברתי\ניהולי גבוה, או עמדת כוח, עושים לך את זה? ', N'עד כמה נשים בסטאטוס חברתי\ניהולי גבוה, או עמדת כוח, עושים לך את זה? ', NULL, N'עד כמה נשים\גברים בסטאטוס חברתי\ניהולי גבוה, או עמדת כוח, עושים לך את זה? ');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1745, N'F1603', 1, N'האם יצא לך להשתמש בסקס אפיל שלך בכוונה כדי להשיג משהו? אם כן, תן דוגמא', N'האם יצא לך להשתמש בסקס אפיל שלך בכוונה כדי להשיג משהו? אם כן, תני דוגמא', NULL, N'האם יצא לך להשתמש בסקס אפיל שלך בכוונה כדי להשיג משהו? אם כן, תן\י דוגמא');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1746, N'F1604', 1, N'מה דעתך על נשים אמיצות שלא מתביישות להתחיל עם גבר ישירות?', N'אם גבר מוצא חן בעיניך, האם תתחילי איתו ישירות, או שמקסימום תפילי מטפחת ותקווי שהוא ימשיך את העבודה משם?', NULL, NULL);
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1747, N'F1606', 1, N'מציעים לך משכורת מובטחת לכל החיים תמורת ויתור על לימודים\קריירה. מה הסכום  החודשי ברוטו שפחות ממנו לא תסכים לעיסקה?', N'מציעים לך משכורת מובטחת לכל החיים תמורת ויתור על לימודים\קריירה. מה הסכום  החודשי ברוטו שפחות ממנו לא תסכימי לעיסקה?', NULL, NULL);
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1748, N'F1607', 1, N'מציעים לך משכורת מובטחת לכל החיים תמורת ירידה מהארץ. מה הסכום  החודשי ברוטו שפחות ממנו לא תסכים לעיסקה?', N'מציעים לך משכורת מובטחת לכל החיים תמורת ירידה מהארץ. מה הסכום  החודשי ברוטו שפחות ממנו לא תסכימי לעיסקה?', NULL, NULL);
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1749, N'F1608', 1, N'דרג מ 1 עד 10 עד כמה כדאיות הדרכים הבאות כדי להרשים אישה:', N'דרגי מ 1 עד 10 עד כמה כדאיות הדרכים הבאות כדי להרשים גבר:', NULL, N'עד כמה כדאיות הדרכים הבאות כדי להרשים גבר\אישה:');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1750, N'F1609', 1, N'דרג מ 1 עד 10 עד כמה כדאיות הדרכים הבאות כדי להרשים אישה:', N'דרגי מ 1 עד 10 עד כמה כדאיות הדרכים הבאות כדי להרשים גבר:', NULL, N'עד כמה כדאיות הדרכים הבאות כדי להרשים גבר\אישה:');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1751, N'F1610', 1, N'דרג מ 1 עד 10 עד כמה כדאיות הדרכים הבאות כדי להרשים אישה:', N'דרגי מ 1 עד 10 עד כמה כדאיות הדרכים הבאות כדי להרשים גבר:', NULL, N'עד כמה כדאיות הדרכים הבאות כדי להרשים גבר\אישה:');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1752, N'F1611', 1, N'נניח שיש מסיבת חברים והגיע הקטע שכל אחד חייב לתת 2-3 דקות הופעה, לא משנה מה. במה תופיע?', N'נניח שיש מסיבת חברים והגיע הקטע שכל אחד חייב לתת 2-3 דקות הופעה, לא משנה מה. במה תופיעי?', NULL, N'נניח שיש מסיבת חברים והגיע הקטע שכל אחד חייב לתת 2-3 דקות הופעה, לא משנה מה. במה תופיע\י?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1753, N'F1612', 1, N'ספר מה גורם לך להרגיש יותר סקסי? האם זה כשאתה מתעמל? שנותנים לך מחמאות? כשאתה מתלבש יפה, או משהו אחר?', N'ספרי מה גורם לך להרגיש יותר סקסית? האם זה כשאת מתעמלת? שנותנים לך מחמאות? כשאת מתלבשת יפה, או משהו אחר?', NULL, N'מה גורם לכם להרגיש סקסיים?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1754, N'F1613', 1, N'עד כמה נכונות לגביך התכונות הבאות: (נכון מאוד, בכלל לא, קצת, וכו...)', N'עד כמה נכונות לגביך התכונות הבאות: (נכון מאוד, בכלל לא, קצת, וכו...)', NULL, NULL);
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1755, N'F1614', 1, N'עד כמה נכונות לגביך התכונות הבאות: (נכון מאוד, בכלל לא, קצת, וכו...)', N'עד כמה נכונות לגביך התכונות הבאות: (נכון מאוד, בכלל לא, קצת, וכו...)', NULL, NULL);
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1756, N'F1615', 1, N'את מי תעדיף מהאפשרויות הבאות? דרג מ 1 עד 10', N'את מי תעדיפי מהאפשרויות הבאות? דרג מ 1 עד 10', NULL, N'את מי תעדיפו מהאפשרויות הבאות? דרגו מ 1 עד 10');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1757, N'F1616', 1, N'את מי תעדיף מהאפשרויות הבאות? דרג מ 1 עד 10', N'את מי תעדיפי מהאפשרויות הבאות? דרג מ 1 עד 10', NULL, N'את מי תעדיפו מהאפשרויות הבאות? דרגו מ 1 עד 10');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1758, N'F1617', 1, N'נניח שאתה בדייט עכשיו. איזה חיסרון שלך תנסה להצניע?', N'נניח שאת בדייט עכשיו. איזה חיסרון שלך תנסי להצניע?', NULL, N'אתם בדייט עכשיו. איזה חיסרון שלכם תנסו להצניע?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1759, N'F1618', 1, N'כמה אתה בעניין של אקסטרים? כתוב עד כמה בא לך עכשיו: (מאוד\ בכלל לא\ קצת\ וכו''... )', N'כמה את בעניין של אקסטרים? כתבי עד כמה בא לך עכשיו: (מאוד\ בכלל לא\ קצת\ וכו''... )', NULL, N'כמה אתם בעניין של אקסטרים? ');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1760, N'F1619', 1, N'כמה אתה בעניין של אקסטרים? כתוב עד כמה בא לך עכשיו: (מאוד\ בכלל לא\ קצת\ וכו''... )', N'כמה את בעניין של אקסטרים? כתבי עד כמה בא לך עכשיו: (מאוד\ בכלל לא\ קצת\ וכו''... )', NULL, N'כמה אתם בעניין של אקסטרים? ');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1761, N'F1620', 1, N'בילוי טוב ומרגש זה:', N'בילוי טוב זה:', NULL, N'בילוי טוב זה:');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1762, N'F1621', 1, N'מה בא לך עכשיו? פרפרים בבטן, או נוחות ורוגע? ומה אתה מתכוון לעשות כדי להשיג את זה?', N'מה בא לך עכשיו? פרפרים בבטן, או נוחות ורוגע? ומה את מתכוונת לעשות כדי להשיג את זה?', NULL, N'מה בא לך עכשיו? פרפרים בבטן, או נוחות ורוגע? ומה את\ה מתכוון\ת לעשות כדי להשיג את זה?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1763, N'F1622', 1, N'אם אתה בראיון עבודה. איזו תכונה שלך תעדיף להסתיר?', N'את בראיון עבודה עכשיו. איזו תכונה שלך תעדיפי להסתיר?', NULL, N'אתם בראיון עבודה עכשיו. איזו תכונה שלכם תעדיפו להסתיר?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1764, N'F1623', 1, N'האם יש לך צד נשי כלשהו? אם כן, איך זה מתבטא?', N'האם יש בך צד גברי כלשהו? אם כן, איך זה מתבטא? ', NULL, NULL);
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1765, N'F1624', 1, N'תאר מחווה רומנטית דביקה במיוחד שעשית בשביל אישה', N'תארי מחווה רומנטית דביקה במיוחד שעשית בשביל גבר', NULL, N'תאר\י מחווה רומנטית דביקה במיוחד שעשית בשביל גבר\אישה');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1766, N'F1625', 1, N'מישהי שאתה יוצא איתה כבר חודש מביאה לך בהפתעה מתנה ארוזה. מה תרצה שיהיה בקופסא?', N'מישהו שאת יוצאת איתו כבר חודש מביא לך בהפתעה מתנה ארוזה. מה תרצי שיהיה בקופסא?', NULL, N'מישהו\י שאתם יוצאים איתו\איתה כבר חודש מביא לכם בהפתעה מתנה ארוזה. מה תרצו שיהיה בקופסא?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1767, N'F1626', 1, N'יש לך יום הולדת. מה היית רוצה לקבל מהחברה? (דרג במילים כמו מאוד, בכלל לא, קצת, וכו''...)', N'יש לך יום הולדת. מה היית רוצה לקבל מהחבר? (דרגי במילים כמו מאוד, בכלל לא, קצת, וכו''...)', NULL, N'איזו מתנה הייתם רוצים לקבל מהחבר\ה ליום ההולדת?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1768, N'F1627', 1, N'יש לך יום הולדת. מה היית רוצה לקבל מהחברה? (דרג במילים כמו מאוד, בכלל לא, קצת, וכו''...)', N'יש לך יום הולדת. מה היית רוצה לקבל מהחברה? (דרג במילים כמו מאוד, בכלל לא, קצת, וכו''...)', NULL, N'איזו מתנה הייתם רוצים לקבל מהחבר\ה ליום ההולדת?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1769, N'F1628', 1, N'האם מישהו פעם אמר לך משפט ששינה לך את החיים במובן מסוים? אם כן, מה?', N'האם מישהו פעם אמר לך משפט ששינה לך את החיים במובן מסוים? אם כן, מה?', NULL, N'האם מישהו פעם אמר לך משפט ששינה לך את החיים במובן מסוים? אם כן, מה?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1770, N'F1629', 1, N'עד כמה היית רוצה לעבוד במקצועות הבאים: (מאוד, קצת, בכלל לא ,וכו''...) ', N'עד כמה היית רוצה לעבוד במקצועות הבאים: (מאוד, קצת, בכלל לא ,וכו''...) ', NULL, N'עד כמה היית רוצה לעבוד במקצועות הבאים: ');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1771, N'F1630', 1, N'עד כמה היית רוצה לעבוד במקצועות הבאים: (מאוד, קצת, בכלל לא , וכו''...) ', N'עד כמה היית רוצה לעבוד במקצועות הבאים: (מאוד, קצת, בכלל לא, וכו''...) ', NULL, N'עד כמה היית רוצה לעבוד במקצועות הבאים: ');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1772, N'F1631', 1, N'עד כמה היית רוצה לעבוד במקצועות הבאים: (מאוד, קצת, בכלל לא , וכו''...) ', N'עד כמה היית רוצה לעבוד במקצועות הבאים: (מאוד, קצת, בכלל לא , וכו''...) ', NULL, N'עד כמה היית רוצה לעבוד במקצועות הבאים: ');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1773, N'F1632', 1, N'מתי היתה הפעם האחרונה שאמא שלך קנתה לך בגדים? מה היא קנתה?', N'מתי היתה הפעם האחרונה שאמא שלך קנתה לך בגדים? מה היא קנתה?', NULL, N'מתי היתה הפעם האחרונה שאמא שלך קנתה לך בגדים? מה היא קנתה?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1774, N'F1633', 1, N'עד כמה התכונות הללו מגדירות אותך? (מאוד, קצת, בכלל לא, וכו''...) ', N'עד כמה התכונות הללו מגדירות אותך? (מאוד, קצת, בכלל לא, וכו''...) ', NULL, N'עד כמה התכונות הללו מגדירות אותך?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1775, N'F1634', 1, N'האם אתה מוכן להיות עם מישהי ש... (השב במילים כמו "מאוד, בכלל לא, אולי, ככה ככה, וכו''..."', N'האם את מוכנה להיות עם מישהו ש.... (השיבי במילים כמו "מאוד, בכלל לא, אולי, ככה ככה, וכו''..."', NULL, N'עד כמה אתם מוכנים להיות עם מישהו\י ש:');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1776, N'F1635', 1, N'האם הרגשת פעם בפאניקה אמיתית? אם כן, ממה?', N'האם הרגשת פעם בפאניקה אמיתית? אם כן, ממה?', NULL, N'האם הרגשת פעם בפאניקה אמיתית? אם כן, ממה?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1777, N'F1636', 1, N'האם שיקרת אי פעם לבוס שלך? בקשר למה?', N'האם שיקרת אי פעם לבוס שלך? בקשר למה?', NULL, N'האם שיקרת אי פעם לבוס שלך? בקשר למה?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1778, N'F1637', 1, N'עם איזה שיר היית רוצה להתעורר בבוקר?', N'עם איזה שיר היית רוצה להתעורר בבוקר?', NULL, N'עם איזה שיר היית רוצה להתעורר בבוקר?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1779, N'F1638', 1, N'האם אתה זקוק ל''תנאים'' מסוימים כדי להירדם, או שאתה נרדם בקלות גם על ערימת אבנים?', N'האם את זקוקה ל''תנאים'' מסוימים כדי להירדם, או שאת נרדמת בקלות גם על ערימת אבנים?', NULL, N'האם אתם זקוקים לתנאים מסוימים כדי להירדם, או שאתם נרדמים בקלות גם על ערימת אבנים?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1780, N'F1639', 1, N'כמה עמוק אתה ישן? האם אתה מתעורר מכל רעש קטן, או שגם תותח לא יעיר אותך?', N'כמה עמוק את ישנה? האם את מתעוררת מכל רעש קטן, או שגם תותח לא יעיר אותך?', NULL, N'כמה עמוק אתם ישנים? האם אתם מתעוררים מכל רעש קטן, או שגם תותח לא יעיר אתכם?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1781, N'F1640', 1, N'שבת בבוקר. בחוץ גשם וסערה. ', N'שבת בבוקר. בחוץ גשם וסערה. ', NULL, N'שבת בבוקר. בחוץ גשם וסערה. ');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1782, N'F1641', 1, N'בחוץ חמסין כבד. ', N'בחוץ חמסין כבד. ', NULL, N'בחוץ חמסין כבד. ');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1783, N'F1642', 1, N'מה עוזר לך להירגע? דרג מ 1 עד 10', N'מה עוזר לך להירגע? דרגי מ 1 עד 10', NULL, N'מה עוזר לך להירגע?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1784, N'F1643', 1, N'האם יצא לך פעם לנאום בפני קהל? אם כן, איך היתה ההרגשה?', N'האם יצא לך פעם לנאום בפני קהל? אם כן, איך היתה ההרגשה?', NULL, N'האם יצא לך פעם לנאום בפני קהל? אם כן, איך היתה ההרגשה?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1785, N'F1644', 1, N'באיזה מקרה ספציפי הצד הרך והאמפטי שלך בא לידי ביטוי?', N'באיזה מקרה ספציפי הצד הרך והאמפטי שלך בא לידי ביטוי?', NULL, N'באיזה מקרה ספציפי הצד הרך והאמפטי שלך בא לידי ביטוי?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1786, N'F1645', 1, N'דרג עד כמה חשובות לך התכונות הבאות אצל בת הזוג... (השב במילים "מאוד, בכלל לא, קצת", וכו...', N'דרגי עד כמה חשובות לך התכונות הבאות אצל בן הזוג (השיבי במילים "מאוד, בכלל לא, קצת", וכו...', NULL, N'דרג\י עד כמה חשובות לך התכונות הבאות אצל בן\בת הזוג:');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1787, N'F1646', 1, N'ממי כדאי שתבקש סליחה ביום כיפור? ועל מה?', N'ממי כדאי שתבקשי סליחה ביום כיפור? ועל מה?', NULL, N'ממי כדאי שתבקש\י סליחה ביום כיפור? ועל מה?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1788, N'F1647', 1, N'עד כמה תתבייש אם אחרים יגידו שאתה: (מאוד, בכלל לא, קצת וכו''...) ', N'עד כמה זה נכון אם אחרים יגידו לך שאת: (מאוד, בכלל לא, קצת וכו''...) ', NULL, N'עד כמה זה נכון אם אחרים יגידו שאתם: ');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1789, N'F1648', 1, N'עד כמה תתבייש אם אחרים יגידו שאתה: (מאוד, בכלל לא, קצת וכו''...) ', N'עד כמה זה נכון אם אחרים יגידו לך שאת: (מאוד, בכלל לא, קצת וכו''...) ', NULL, N'עד כמה זה נכון אם אחרים יגידו שאתם: ');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1790, N'F1649', 1, N'עד כמה מפחיד אותך לטייל ב: (מאוד, בכלל לא, קצת וכו''...) ', N'עד כמה מפחיד אותך לטייל ב: (מאוד, בכלל לא, קצת וכו''...) ', NULL, N'עד כמה מפחיד אותך לטייל ב:');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1791, N'F1650', 1, N'דרג עד כמה בא לך שההרפתקאה הבאה שלך תהיה ב: (מאוד, בכלל לא, קצת וכו''...)', N'דרגי עד כמה בא לך שההרפתקאה הבאה שלך תהיה ב: (מאוד, בכלל לא, קצת וכו''...)', NULL, N'דרג\י עד כמה בא לך שההרפתקאה הבאה שלך תהיה ב: ');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1792, N'F1651', 1, N'דרג עד כמה בא לך שההרפתקאה הבאה שלך תהיה ב: (מאוד, בכלל לא, קצת וכו''...)', N'דרגי עד כמה בא לך שההרפתקאה הבאה שלך תהיה ב: (מאוד, בכלל לא, קצת וכו''...)', NULL, N'דרג\י עד כמה בא לך שההרפתקאה הבאה שלך תהיה ב: ');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1793, N'F1653', 1, N'על מה לא תסלח בחיים אם יעשו לך אותו?', N'על מה לא תסלחי בחיים אם יעשו לך אותו?', NULL, N'על מה לא תסלח\י בחיים אם יעשו לך אותו?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1794, N'F1654', 1, N'כמה מהר או לאט אתה מתעצבן,  וכמה מהר או לאט אתה נרגע? ', N'כמה מהר או לאט את מתעצבנת  וכמה מהר או לאט את נרגעת? ', NULL, N'כמה מהר אתם מתעצבנים, וכמה מהר אתם נרגעים?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1795, N'F1655', 1, N'האם שברת פעם משהו מתוך כעס? מה זה היה ואיך?', N'האם שברת פעם משהו מתוך כעס? מה זה היה ואיך?', NULL, N'האם שברת פעם משהו מתוך כעס? מה זה היה ואיך?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1796, N'F1656', 1, N'האם לפעמים אתה מדוכא או מדוכדך בלי סיבה? אם כן, איך אתה יוצא מזה?', N'האם לפעמים את מדוכאת או מדוכדכת בלי סיבה? אם כן, איך את יוצאת מזה?', NULL, N'האם לפעמים אתם מדוכאים או מדוכדכים בלי סיבה? איך אתם יוצאים מזה? ');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1797, N'F1657', 1, N'ספר כמה חברים טובים יש לך מכל תקופה (הילדות, הצבא, עבודה, וכו''... ) ', N'ספרי כמה חברים טובים יש לך מכל תקופה (הילדות, הצבא, עבודה, וכו''... ) ', NULL, N'ספר\י כמה חברים טובים יש לך מכל תקופה (הילדות, הצבא, עבודה, וכו''... ) ');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1798, N'F1658', 1, N'מה אכלת אתמול לארוחת צהריים? (בבקשה לפרט הכל!)', N'מה אכלת אתמול לארוחת צהריים? (בבקשה לפרט הכל!)', NULL, N'מה אכלת אתמול לארוחת צהריים? (בבקשה לפרט הכל!)');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1799, N'F1659', 1, N'מה אכלת אתמול לארוחת ערב? בבקשה לפרט הכל)', N'מה אכלת אתמול לארוחת ערב? בבקשה לפרט הכל)', NULL, N'מה אכלת אתמול לארוחת ערב? בבקשה לפרט הכל)');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1800, N'F1660', 1, N'איזה משחקים שיחקת הכי הרבה בחיים?', N'איזה משחקים שיחקת הכי הרבה בחיים?', NULL, N'איזה משחקים שיחקת הכי הרבה בחיים?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1801, N'F1661', 1, N'עד כמה מבאסות העבודות הבאות? (הכי מבאס, קצת מבאס, לא מבאס, וכו''...) ', N'עד כמה מבאסות העבודות הבאות? (הכי מבאס, קצת מבאס, לא מבאס, וכו''...) ', NULL, N'עד כמה מבאסות העבודות הבאות?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1802, N'F1662', 1, N'עד כמה מבאסות העבודות הבאות? (הכי מבאס, קצת מבאס, לא מבאס, וכו''...) ', N'עד כמה מבאסות העבודות הבאות? (הכי מבאס, קצת מבאס, לא מבאס, וכו''...) ', NULL, N'עד כמה מבאסות העבודות הבאות?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1803, N'F1663', 1, N'מתי בפעם האחרונה רבת עם אמא שלך? ועל מה?', N'מתי בפעם האחרונה רבת עם מישהו מהמשפחה שלך? על מה?', NULL, N'מתי בפעם האחרונה רבת עם אמא שלך? ועל מה?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1804, N'F1664', 1, N'תאר את ההערכות שקיבלת בתיכון', N'תארי את ההערכות שקיבלת בתיכון', NULL, N'תאר\י את ההערכות שקיבלת בתיכון');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1805, N'F1665', 1, N'עד כמה אתה טיפוס של "מולטי בילויים" לערב אחד, מול "בילוי אחד ויחיד זה מספיק"?', N'עד כמה את טיפוס של "מולטי בילויים" לערב אחד, מול "בילוי אחד ויחיד זה מספיק"?', NULL, N'עד כמה את\ה טיפוס של "מולטי בילויים" לערב אחד, מול "בילוי אחד ויחיד זה מספיק"?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1806, N'F1666', 1, N'תאר את ההערכות שקיבלת בתיכון', N'תארי את ההערכות שקיבלת בתיכון', NULL, N'תאר\י את ההערכות שקיבלת בתיכון');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1807, N'F1667', 1, N'דרג מהרשימה, עד כמה רומנטי כל דבר בעיניך: (מאוד, קצת, בכלל לא, וכו''...)', N'דרגי מהרשימה, עד כמה רומנטי כל דבר בעיניך: (מאוד, קצת, בכלל לא, וכו''...)', NULL, N'עד כמה רומנטי כל דבר בעיניך: ')
;
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1808, N'F1668', 1, N'דרג מהרשימה, עד כמה רומנטי כל דבר בעיניך: (מאוד, קצת, בכלל לא, וכו''...)', N'דרגי מהרשימה, עד כמה רומנטי כל דבר בעיניך: (מאוד, קצת, בכלל לא, וכו''...)', NULL, N'עד כמה רומנטי כל דבר בעיניך: ');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1809, N'F1669', 1, N'כמה אתה מסודר ונקי?', N'כמה את מסודרת ונקיה?', NULL, N'כמה אתם מסודרים ונקיים?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1810, N'F1670', 1, N'באילו מקרים היית פוסל מישהי מראש? (ענה ב"פוסל" או "לא פוסל")', N'באילו מקרים היית פוסלת מישהו מראש? (ענה ב"פוסלת" או "לא פוסלת")', NULL, N'באילו מקרים הייתם פוסלים מישהו\י מראש?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1811, N'F1671', 1, N'באילו מקרים היית פוסל מישהי מראש? (ענה ב"פוסל" או "לא פוסל")', N'באילו מקרים היית פוסלת מישהו מראש? (ענה ב"פוסלת" או "לא פוסלת")', NULL, N'באילו מקרים הייתם פוסלים מישהו\י מראש?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1812, N'F1672', 1, N'האם היה מקרה שבו פסלת מישהי מראש בגלל משהו (שאינו צורה חיצונית)? אם כן, בגלל מה?', N'האם היה מקרה שבו פסלת מישהו מראש בגלל משהו (שאינו צורה חיצונית)? אם כן, בגלל מה?', NULL, N'האם היה מקרה שבו פסלת מישהו\י מראש בגלל משהו (שאינו צורה חיצונית)? אם כן, בגלל מה?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1813, N'F1673', 1, N'תאר ב 2-4 מילים את תקופת הילדות שלך', N'תארי ב 2-4 מילים את תקופת הילדות שלך', NULL, N'תאר\י ב 2-4 מילים את תקופת הילדות שלך');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1814, N'F1674', 1, N'ספר על משהו מיוחד ויוצא דופן שעשית השבוע', N'ספרי על משהו מיוחד ויוצא דופן שעשית השבוע', NULL, N'ספר\י על משהו מיוחד ויוצא דופן שעשית השבוע');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1815, N'F1675', 1, N'עד כמה נכונות לגביך התכונות הבאות: (נכון מאוד, בכלל לא, קצת, וכו...)', N'עד כמה נכונות לגביך התכונות הבאות: (נכון מאוד, בכלל לא, קצת, וכו...)', NULL, N'עד כמה נכונות לגביך התכונות הבאות: ');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1816, N'F1676', 1, N'תאר במשפט קצר או כותרת את הסרט שיעשו על החיים שלך', N'תארי במשפט קצר או כותרת את הסרט שיעשו על החיים שלך', NULL, N'תאר\י במשפט קצר או כותרת את הסרט שיעשו על החיים שלך');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1817, N'F1677', 1, N'כשאתה לבד, האם אתה מחפש להפסיק את זה כמה שיותר מהר, או שאתה נהנה להיות לבד?', N'כשאת לבד, האם את מחפשת להפסיק את זה כמה שיותר מהר, או נהנית להיות לבד?', NULL, N'כשאתם לבד, האם אתם מחפשים להפסיק את זה, או נהנים להיות לבד?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1818, N'F1678', 1, N'האם אתה חושב שאתה עובד קשה מידי? מה סוג העבודה שלך?', N'האם את חושבת שאת עובדת קשה מידי? מה סוג העבודה שלך?', NULL, N'האם אתם חושבים שאתם עובדים קשה מידי? מה סוג העבודה שלכם?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1819, N'F1679', 1, N'באיזה ביטוי יוצא לך להשתמש הרבה (למשל - Been there, done that)', N'באיזה ביטוי יוצא לך להשתמש הרבה (למשל - "Been there, done that" או "זו לא תכנית כבקשתך" וכו''..)', NULL, N'באיזה ביטוי יוצא לך להשתמש הרבה (למשל - "Been there, done that" או "זו לא תכנית כבקשתך" וכו''..)');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1820, N'F1680', 1, N'כתוב לפחות 3 חטיפים מלוחים לא בריאים שאתה מכור אליהם', N'כתבי לפחות 3 חטיפים מלוחים לא בריאים שאת מכורה אליהם', NULL, N'כתבו לפחות 3 חטיפים מלוחים וממש לא בריאים שאתם מכורים אליהם');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1821, N'F1681', 1, N'כתוב לפחות 3 דברים מתוקים וממש לא בריאים שאתה מכור אליהם', N'כתבי לפחות 3 דברים מתוקים וממש לא בריאים שאת מכורה אליהם', NULL, N'כתבו לפחות 3 דברים מתוקים וממש לא בריאים שאתם מכורים אליהם');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1822, N'F1682', 1, N'ידידה שלך שואלת אותך אם היא השמינה, ואתה רואה בבירור שכן, והרבה. איך תשיב?', N'ידיד שלך שואל אותך אם הוא השמין, ואת רואה בבירור שכן, והרבה. איך תגיבי?', NULL, N'ידיד\ה שלכם שואל\ת אתכם אם הוא\היא השמינ\ה. אתם רואים שכן. איך תגיבו?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1823, N'F1683', 1, N'למה בא לך להתחפש בפורים הקרוב?', N'למה בא לך להתחפש בפורים הקרוב?', NULL, N'למה בא לך להתחפש בפורים הקרוב?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1824, N'F1684', 1, N'תאר עד כמה אתה אוהב דברים לא בריאים בחגים: (אוהב מאוד, בכלל לא, קצת, וכו''...)', N'תארי עד כמה את אוהבת דברים לא בריאים בחגים: (אוהבת מאוד, בכלל לא, קצת, וכו''...)', NULL, N'עד כמה את\ה אוהב\ת דברים לא בריאים בחגים: ');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1825, N'F1685', 1, N'מה משך הזמן הכי גדול ברציפות שבו עשית את הפעילויות הבאות:', N'מה משך הזמן הכי גדול ברציפות שבו עשית את הפעילויות הבאות:', NULL, N'מה משך הזמן הכי גדול ברציפות שבו עשית את הפעילויות הבאות:');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1826, N'F1686', 1, N'תאר את עצמך בעוד 20 שנה:', N'תארי את עצמך בעוד 20 שנה:', NULL, NULL);
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1827, N'F1687', 1, N'תאר כמה אתה פוחד מ: (בכלל לא, קצת, הרבה מאוד וכו''...) ', N'תאר כמה את פוחדת מ: (בכלל לא, קצת, הרבה מאוד וכו''...) ', NULL, NULL);
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1828, N'F1688', 1, N'עד כמה אתה טיפוס שאוהב ילדים? (ילדים של בני משפחה שלך וכו''...)', N'עד כמה את טיפוס שאוהבת ילדים? (ילדים של בני משפחה שלך וכו''...)', NULL, N'עד כמה אתם אוהבים ילדים?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1829, N'F1689', 1, N'איזה דבר אחד היה צריך להשתנות אתמול, כדי שאתמול יהיה יום מוצלח במיוחד? ואם היה ממילא מוצלח, מה הסיבה שהיה כזה מוצלח?', N'איזה דבר אחד היה צריך להשתנות אתמול, כדי שאתמול יהיה יום מוצלח במיוחד? ואם היה ממילא מוצלח, מה הסיבה שהיה כזה מוצלח?', NULL, N'איזה דבר אחד היה צריך להשתנות אתמול, כדי שאתמול יהיה יום מוצלח במיוחד?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1830, N'F1690', 1, N'במה אפשר לסמוך עליך?', N'במה אפשר לסמוך עליך?', NULL, NULL);
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1831, N'F1691', 1, N'נניח שמזמינים אותך לטיול טבע של יומיים בסופ"ש הקרוב. השב במילים "יש" או "אין"', N'נניח שמזמינים אותך לטיול טבע יומיים בסופ"ש הקרוב. השיבי במילים "יש" או "אין"', NULL, N'טיול בטבע');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1832, N'F1692', 1, N'מה נחשבת הצלחה בחיים בעיניך? דרג את הערכים הבאים: (בכלל לא, קצת, חשוב מאוד, וכו''...)', N'מה נחשבת הצלחה בחיים בעיניך? דרגי את הערכים הבאים: (בכלל לא, קצת, חשוב מאוד, וכו''...)', NULL, N'מה נחשבת הצלחה בחיים בעיניך?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1833, N'F1693', 1, N'איך אתה בבקרים?', N'איך את בבקרים?', NULL, N'איך אתם בבקרים?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1834, N'F1694', 1, N'איך אתה בבקרים? דרג את הפעיליות הבאות: (נורא ואיום, מעולה, ככה ככה, וכו''..) ', N'איך את בבקרים? דרגי את הפעיליות הבאות: (נורא ואיום, מעולה, ככה ככה, וכו''..) ', NULL, N'איך אתם בבקרים? ');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1835, N'F1695', 1, N'איך נראות בדרך כלל ארוחות הצהריים שלך? כבדות עם בשר, או סלטים קלילים?', N'איך נראות בדרך כלל ארוחות הצהריים שלך? כבדות עם בשר, או סלטים קלילים, או משהו אחר?', NULL, N'איך נראות בדרך כלל ארוחות הצהריים שלך? כבדות עם בשר, או סלטים קלילים, או משהו אחר?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1836, N'F1696', 1, N'נניח שמציעים לך עבודה זמנית ליום אחד. דרג עד כמה אתה מעוניין ב: (בכלל לא, מאוד, קצת, וכו''...) ', N'נניח שמציעים לך עבודה זמנית ליום אחד. דרגי עד כמה אתה מעוניינת ב: (בכלל לא, מאוד, קצת, וכו''...) ', NULL, N'נניח שמציעים לכם עבודה זמנית ליום אחד, דרגו כמה אתם מעוניינים ב:');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1837, N'F1697', 1, N'חבר שלך יוצא לדייט עם מישהי שהיא בענק מעל לליגה שלו. איזו עצה תיתן לו לקראת הדייט?', N'חברה שלך יוצאת לדייט עם מישהו שהוא בענק מעל לליגה שלה. איזו עצה תתני לה לקראת הדייט?', NULL, N'חבר\ה שלך יוצא\ת לדייט עם מישהו\י שהוא\היא בענק מעל לליגה שלו\ה. איזו עצה תתנ\י לה\ו לקראת הדייט?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1838, N'F1698', 1, N'יש קריוקי ואתה חייב לשיר. באיזה שיר תבחר? במידה שאין, תן שיר חליפי', N'יש קריוקי ואת חייבת לשיר. באיזה שיר תבחרי? באיזה שיר חליפי?', NULL, N'יש קריוקי ואתם חייבים לשיר. באיזה שיר תבחרו? באיזה שיר חליפי?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1839, N'F1699', 1, N'הסתכל מבעד לחלון שלידך. מה אתה רואה? ', N'הסתכלי מבעד לחלון שלידך. מה את רואה? ', NULL, N'הסתכל\י מבעד לחלון שלידך. מה את\ה רואה?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1840, N'F1700', 1, N'מה התכניות שלך לסוף השבוע הקרוב?', N'מה התכניות שלך לסוף השבוע הקרוב?', NULL, N'מה התכניות שלך לסוף השבוע הקרוב?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1841, N'F1701', 1, N'האם אתה מודה שחטאת בעבר באחד מהחטאים האלה: (מודה, לא מודה, קצת וכו''... )', N'האם את מודה שחטאת בעבר באחד מהחטאים האלה: (מודה, לא מודה, קצת וכו''... )', NULL, N'האם את\ה מודה שחטאת בעבר באחד מהחטאים האלה:');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1842, N'F1702', 1, N'האם אתה מודה שחטאת בעבר באחד מהחטאים האלה: (מודה, לא מודה, קצת וכו''... )', N'האם את מודה שחטאת בעבר באחד מהחטאים האלה: (מודה, לא מודה, קצת וכו''... )', NULL, N'האם את\ה מודה שחטאת בעבר באחד מהחטאים האלה:');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1843, N'F1703', 1, N'האם יצא לך לקנא (קנאה שלילית וצורבת) באחד החברים שלך? אם כן, על מה?', N'האם יצא לך לקנא (קנאה שלילית וצורבת) באחת החברות שלך? אם כן, על מה?', NULL, N'האם יצא לך לקנא (קנאה שלילית וצורבת) באחד\ת החברים\ות שלך?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1844, N'F1704', 1, N'עד כמה בא לך לעשות בזה הרגע את הפעילויות הבאות (מאוד, בכלל לא, קצת וכו''...) ', N'עד כמה בא לך לעשות בזה הרגע את הפעילויות הבאות (מאוד, בכלל לא, קצת וכו''...) ', NULL, N'עד כמה בא לך לעשות בזה הרגע את הפעילויות הבאות:');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1845, N'F1705', 1, N'האם אתה נחשב בעיני החבר''ה שלך כיועץ טוב? איזו עצה נתת לאחרונה? ', N'האם את נחשבת בעיני החבר''ה שלך כיועצת טובה? איזו עצה טובה נתת לאחרונה? ', NULL, N'האם אתם נחשבים בעיני החברים כיועצים טובים? איזה עצה נתתם לאחרונה?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1846, N'F1706', 1, N'נניח שהיתה לך מילגה חלומית ללמוד איפה שתרצה ומה שתרצה. מה היית לומד, ואיפה?', N'נניח שהיתה לך מילגה חלומית ללמוד איפה שתרצי ומה שתרצי. מה היית לומדת, ואיפה?', NULL, N'נניח שהיתה לכם מילגה חלומית ללמוד איפה שתרצו ומה שתרצו. מה הייתם לומדים ואיפה?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1847, N'F1707', 1, N'ספר על חפץ שאתה אובססיבי לגביו, ולמה', N'ספרי על חפץ שאת אובססיבית לגביו, ולמה', NULL, N'ספרו על חפץ שאתם אובססיבים לגביו, ולמה');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1848, N'F1708', 1, N'ספר על איסור חמור שאתה משתוקק מאוד  להפר אותו', N'ספרי על איסור חמור שאת משתוקקת מאוד להפר אותו', NULL, N'ספרו על איסור חמור שאתם משתוקקים מאוד להפר אותו');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1849, N'F1709', 1, N'עד כמה כלי הרכב מחרמן אותך? (מאוד, בכלל לא, קצת, וכו''...) ', N'עד כמה כלי הרכב מחרמן אותך? (מאוד, בכלל לא, קצת, וכו''...) ', NULL, N'עד כמה כלי הרכב מחרמן אותך? ');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1850, N'F1710', 1, N'אם האוכל במסעדה לא טעים אבל השירות טוב, איזה טיפ תשאיר למלצר\ית, אם בכלל?', N'אם האוכל במסעדה לא טעים אבל השירות טוב, איזה טיפ תשאירי למלצר\ית, אם בכלל?', NULL, N'אם האוכל במסעדה לא טעים אבל השירות טוב, איזה טיפ תשאירי למלצר\ית, אם בכלל?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1851, N'F1711', 1, N'עד כמה חצוף בעיניך בבית קפה? (מאוד, בכלל לא, קצת וכו''...) ', N'עד כמה חצוף בעיניך בבית קפה? (מאוד, בכלל לא, קצת וכו''...) ', NULL, N'עד כמה חצוף בעיניך בבית קפה? ');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1852, N'F1712', 1, N'מה היית רוצה לומר בסתר ליבך לאמא שמתעלמת מהצרחות של התינוק שלה באמצע בית קפה?', N'מה היית רוצה לומר בסתר ליבך לאמא שמתעלמת מהצרחות של התינוק שלה באמצע בית קפה?', NULL, N'מה היית רוצה לומר בסתר ליבך לאמא שמתעלמת מהצרחות של התינוק שלה באמצע בית קפה?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1853, N'F1713', 1, N'מתי היתה החופשה האחרונה שלך, איפה, ולכמה זמן?', N'מתי היתה החופשה האחרונה שלך, איפה, ולכמה זמן?', NULL, N'מתי היתה החופשה האחרונה שלך, איפה, ולכמה זמן?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1854, N'F1714', 1, N'אם מותר לך לבחור רק אחד - היית מתקן את החיים האישיים, או המקצועיים שלך? ומה היית מתקן?', N'אם מותר לך לבחור רק אחד - היית מתקנת את החיים האישיים, או המקצועיים שלך? ומה היית מתקנת?', NULL, N'אם מותר לך לבחור רק אחד - היית מתקנ\ת את החיים האישיים, או המקצועיים שלך? ומה היית מתקנ\ת?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1855, N'F1715', 1, N'מהי התקופה הכי טובה בחייך. ולמה?', N'מהי התקופה הכי טובה בחייך. ולמה?', NULL, N'מהי התקופה הכי טובה בחייך. ולמה?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1856, N'F1716', 1, N'האם יצא לך להישאר בקשר טוב עם אקסית שלך גם אחרי הפרידה?', N'האם יצא לך להישאר בקשר טוב עם אקס שלך גם אחרי הפרידה?', NULL, N'האם יצא לך להישאר בקשר טוב עם אקס\ית שלך גם אחרי הפרידה?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1857, N'F1717', 1, N'דרג את מדד התענוג (הכי בעולם, לא מעניין, ככה ככה וכו''...) ', N'דרגי את מדד התענוג (הכי בעולם, לא מעניין, ככה ככה וכו''...) ', NULL, N'דרגי את מדד התענוג ');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1858, N'F1718', 1, N'פוביות', N'פוביות', NULL, NULL);
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1859, N'F1719', 1, N'פוביות', N'פוביות', NULL, NULL);
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1860, N'F1720', 1, N'עד כמה תאהב בילוי שמכיל: (בכלל לא, מאוד, קצת וכו''...) ', N'עד כמה תאהבי בילוי שמכיל: (בכלל לא, מאוד, קצת וכו''...) ', NULL, N'עד כמה תאהב\י בילוי שמכיל: ');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1861, N'F1721', 1, N'אתה צריך לקרוא לסופה בשם של אדם שאתה שונא. מה השם, ומדוע אתה שונא אותו\אותה?', N'את צריכה לקרוא לסופה בשם של אדם שאתה שונאת. מה השם, ומדוע את שונאת אותו\אותה?', NULL, N'אתם צריכים לקרוא לסופה בשם של אדם שאתם שונאים. מה השם, ומדוע אתם שונאים אותו\אותה?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1862, N'F1722', 1, N'האם בכית פעם בגלל פרידה? אם כן, באילו נסיבות?', N'האם בכית פעם בגלל פרידה? אם כן, באילו נסיבות?', NULL, N'האם בכית פעם בגלל פרידה? אם כן, באילו נסיבות?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1863, N'F1723', 1, N'האם בכית פעם בגלל שהפסדת הזדמנות? על מה? ואם לא, איך הגבת אל הפסד הזדמנות?', N'האם בכית פעם בגלל שהפסדת הזדמנות? על מה? ואם לא, איך הגבת אל הפסד הזדמנות?', NULL, N'האם בכית פעם בגלל שהפסדת הזדמנות? על מה? ואם לא, איך הגבת אל הפסד הזדמנות?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1864, N'F1724', 1, N'האם בכית פעם בגלל מוות? באילו נסיבות?', N'האם בכית פעם בגלל מוות? באילו נסיבות?', NULL, N'האם בכית פעם בגלל מוות? באילו נסיבות?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1865, N'F1725', 1, N'האם בכית פעם בגלל ריב עם ההורים? אם כן, באילו נסיבות?', N'האם בכית פעם בגלל ריב עם ההורים? אם כן, באילו נסיבות?', NULL, N'האם בכית פעם בגלל ריב עם ההורים? אם כן, באילו נסיבות?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1866, N'F1726', 1, N'אחרי תקופה לחוצה, באיזה אופן אתה מרשה לעצמך להתפרק?', N'אחרי תקופה לחוצה, באיזה אופן את מרשה לעצמך להתפרק?', NULL, N'אחרי תקופה לחוצה, באיזה אופן את\ה מרשה לעצמך להתפרק?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1867, N'F1727', 1, N'לאיזו מטרה בא לך לתרום כסף?', N'לאיזו מטרה בא לך לתרום כסף?', NULL, N'לאיזו מטרה בא לך לתרום כסף?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1868, N'F1728', 1, N'מהי מערכת היחסים הארוכה ביותר שהיתה לך? מדוע היא הסתיימה?', N'מהי מערכת היחסים הארוכה ביותר שהיתה לך? מדוע היא הסתיימה?', NULL, N'מהי מערכת היחסים הארוכה ביותר שהיתה לך? מדוע היא הסתיימה?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1869, N'F1729', 1, N'כמה מערכות יחסים היו לך? כמה מתוכן משמעותיות?', N'כמה מערכות יחסים היו לך? כמה מתוכן משמעותיות?', NULL, N'כמה מערכות יחסים היו לך? כמה מתוכן משמעותיות?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1870, N'F1730', 1, N'בהנחה שנפרדו ממך פעם. מה היתה התקופה הארוכה ביותר שלקח לך להתאושש מהכאב? ', N'מה היתה התקופה הארוכה ביותר שלקח לך להתאושש מכאב פרידה?', NULL, N'מה היתה התקופה הארוכה ביותר שלקח לך להתאושש מכאב פרידה?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1871, N'F1731', 1, N'בהנחה שנפרדו ממך פעם. מה היתה התקופה הקצרה ביותר שלקח לך להתאושש מהכאב? ', N'מה היתה התקופה הקצרה ביותר שלקח לך להתאושש מהכאב? ', NULL, N'מה היתה התקופה הקצרה ביותר שלקח לך להתאושש מהכאב? ');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1872, N'F1732', 1, N'הרכב את אשת חלומותיך - בחר 3 תכונות בלבד מהנ"ל: הומור, כנות, אינטלגנציה, ביטחון עצמי, סקס טוב, מעגל חברתי רחב,  קריירה טובה', N'הרכיבי את גבר חלומותיך - בחרי 3 תכונות בלבד מהנ"ל: הומור, כנות, אינטלגנציה, ביטחון עצמי, סקס טוב, מעגל חברתי רחב,  קריירה טובה', NULL, N'הרכיבו את גבר\אשת חלומותיך - בחרו 3 תכונות בלבד:');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1873, N'F1733', 1, N'הרכב את האישה האידיאלית: ', N'הרכיבי את הגבר האידיאלי:', NULL, N'הרכב\הרכיבי את גבר\אשת האידיאלים: ');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1874, N'F1734', 1, N'על מה תפרק מערכת יחסים? (כן, לא, אולי וכו''...) ', N'על מה תפרקי מערכת יחסים? (כן, לא, אולי וכו''...) ', NULL, N'על מה תפרק\י מערכת יחסים? ');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1875, N'F1735', 1, N'על מה תפרק מערכת יחסים? (כן, לא, אולי וכו''...) ', N'על מה תפרקי מערכת יחסים? (כן, לא, אולי וכו''...) ', NULL, N'על מה תפרק\י מערכת יחסים? ');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1876, N'F1736', 1, N'על מה תפרק מערכת יחסים? (כן, לא, אולי וכו''...) ', N'על מה תפרקי מערכת יחסים? (כן, לא, אולי וכו''...) ', NULL, N'על מה תפרק\י מערכת יחסים? ');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1877, N'F1737', 1, N'אחרי כמה זמן היכרות מותר להגיד "אני אוהבת אותך"?', N'אחרי כמה זמן היכרות מותר להגיד "אני אוהב אותך"?', NULL, N'אחרי כמה זמן היכרות מותר להגיד "אני אוהב\ת אותך"?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1878, N'F1738', 1, N'בשדה התעופה - האם אתה נפרד במהירות, או מושך פרידה עם מיליון חיבוקים ונשיקות?', N'בשדה התעופה - האם את נפרדת במהירות, או מושכת פרידה עם מיליון חיבוקים ונשיקות?', NULL, N'בשדה תעופה - האם אתם נפרדים במהירות, או מושכים פרידה עם מיליון חיבוקים ונשיקות?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1879, N'F1739', 1, N'האם בחורה עשתה לך פעם עוול? אם כן, מהו?', N'האם גבר עשה לך פעם עוול? אם כן, מהו?', NULL, N'האם גבר\אישה עשו לכם פעם עוול? מהו?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1880, N'F1740', 1, N'בזמן שאתה נמצא במערכת יחסים, האם תרשה לעצמך לפלרטט עם נשים אחרות?', N'בזמן שאת נמצאת במערכת יחסים, האם תרשי לעצמך לפלרטט עם גברים אחרים?', NULL, N'בזמן שאתם במערכת יחסים, האם אתם מרשים לעצמכם לפלרטט עם גברים\נשים אחרים\ות?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1881, N'F1741', 1, N'בזמן שאתה במערכת יחסים איתו, האם זה בסדר מבחינתך שהיא תפלרטט עם גברים אחרים?', N'בזמן שאת במערכת יחסים איתו, האם זה בסדר מבחינתך שהוא יפלרטט עם נשים אחרות?', NULL, N'בזמן שאתם במערכת יחסים, האם זה בסדר שהוא\היא יפלרטטו עם גברים\נשים אחרים\ות?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1882, N'F1742', 1, N'איפה אתה על הסקאלה? עקשן שקשה להסתדר איתך, או אחד שתמיד מוותר?', N'איפה את על הסקאלה? אחת שקשה להסתדר איתך, או אחת שתמיד מוותרת?', NULL, N'איפה אתם על הסקאלה? עקשנים, או וותרנים?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1883, N'F1744', 1, N'נניח שאתה חייב להפקיד את הגורל שלך בידי מישהו שיקבע הכל עבורך. מי זה יהיה? (בלי הורים)', N'נניח שאת חייבת להפקיד את הגורל שלך בידי מישהו שיקבע הכל עבורך. מי זה יהיה? (בלי הורים)', NULL, N'נניח שאת\ה חייב\ת להפקיד את הגורל שלך בידי מישהו שיקבע הכל עבורך. מי זה יהיה? ');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1884, N'F1745', 1, N'ספר על משהו אחד שאתה מאוד מתחרט לגביו בחייך', N'ספרי על משהו אחד שאת מאוד מתחרטת לגביו בחייך', NULL, N'ספרו על משהו אחד שאתם מאוד מתחרטים לגביו בחיים');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1885, N'F1747', 1, N'על מה חשבת אתמול בלילה לפני השינה ממש לפני שנרדמת?', N'על מה חשבת אתמול בלילה לפני השינה ממש לפני שנרדמת?', NULL, N'על מה חשבת אתמול בלילה לפני השינה ממש לפני שנרדמת?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1886, N'F1748', 1, N'כשרע, כדאי לחשוב על דברים חיוביים אבל לא תמיד זה מצליח. יש לך שיטה אחרת שעובדת עבורך?', N'כשרע, כדאי לחשוב על דברים חיוביים אבל לא תמיד זה מצליח. יש לך שיטה אחרת שעובדת עבורך?', NULL, N'כשרע, כדאי לחשוב על דברים חיוביים אבל לא תמיד זה מצליח. יש לך שיטה אחרת שעובדת עבורך?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1887, N'F1749', 1, N'האם כיום אתה יותר אמפטי כלפי אנשים מאשר פעם, או יותר ביקורתי? ', N'האם כיום את יותר אמפטית כלפי אנשים מאשר פעם, או יותר ביקורתית? ', NULL, N'האם כיום את\ה יותר אמפטי\ת כלפי אנשים מאשר פעם, או יותר ביקורתי\ת? ');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1888, N'F1750', 1, N'נסח מכתב אהבה הכי דביקי בעולם לאהובה הדמיונית שלך', N'נסחי מכתב אהבה הכי דביקי בעולם לאהוב הדמיוני שלך:', NULL, N'נסח\י מכתב אהבה הכי דביקי בעולם:');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1889, N'F1751', 1, N'כשהיית בזוגיות, עד כמה הרגשת  פתוח לדבר על היחסים הזוגיים שלך עם חברים או משפחה?', N'כשהיית בזוגיות, עד כמה הרגשת  פתוחה לדבר על היחסים הזוגיים שלך עם חברים או משפחה?', NULL, N'כשהיית בזוגיות, עד כמה הרגשת  פתוח\ה לדבר על היחסים הזוגיים שלך עם חברים או משפחה?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1890, N'F1752', 1, N'האם אתה בדרך כלל מהדברנים, או מהשתקנים?', N'האם את בדרך כלל מהדברנים, או מהשתקנים?', NULL, N'האם את\ה בדרך כלל מהדברנים, או מהשתקנים?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1891, N'F1753', 1, N'האם היתה לך מערכת יחסים שבה התקשית לבטוח בה? אם כן, מדוע?', N'האם היתה לך מערכת יחסים שבה התקשית לבטוח בו? אם כן, מדוע?', NULL, N'האם היתה לך מערכת יחסים שבה התקשית לבטוח בו\בה? אם כן, מדוע?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1892, N'F1754', 1, N'האם אתה בדרך כלל נמנע מקונפליקטים, או שאין לך בעיה להתווכח ולעמוד על שלך?', N'האם את בדרך כלל נמנעת מקונפליקטים, או שאין לך בעיה להתווכח ולעמוד על שלך?', NULL, N'האם את\ה בדרך כלל נמנע\ת מקונפליקטים, או שאין לך בעיה להתווכח ולעמוד על שלך?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1893, N'F1755', 1, N'עד כמה החדר שלך מסודר עכשיו בזה הרגע?', N'עד כמה החדר שלך מסודר עכשיו בזה הרגע?', NULL, N'עד כמה החדר שלך מסודר עכשיו בזה הרגע?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1894, N'F1756', 1, N'שלח קישור (למשל ל-youtube) של שיר שמרגיע אותך', N'שלחי קישור (למשל ל-youtube) של שיר שמרגיע אותך', NULL, N'שלח\י קישור (למשל ל-youtube) של שיר שמרגיע אותך');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1895, N'F1757', 1, N'עד כמה אתה אוהב ומשחק משחקי ווידאו? אם כן, איזה משחקים אתה הכי אוהב?', N'עד כמה את אוהבת ומשחקת משחקי ווידאו? אם כן, איזה משחקים את הכי אוהבת?', NULL, N'עד כמה את\ה אוהב\ת ומשחק\ת משחקי ווידאו? אם כן, איזה משחקים את\ה הכי אוהב\ת?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1896, N'F1758', 1, N'במשפט אחד - מהי תכנית 5 השנים שלך?', N'במשפט אחד - מהי תכנית 5 השנים שלך?', NULL, N'במשפט אחד - מהי תכנית 5 השנים שלך?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1897, N'F1759', 1, N'מה תרצה לארוחת בוקר? בורקס? חביתה עם לחם מלא? או אולי מוזלי? או רעיון אחר?', N'תארי את ארוחת הבוקר שלך', NULL, N'תארו את ארוחת הבוקר שלכם');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1898, N'F1760', 1, N'ספר על משהו אחד שמגיע לך להיות גאה בו בחייך', N'ספרי על משהו אחד שמגיע לך להיות גאה בו בחייך', NULL, N'ספר\י על משהו אחד שמגיע לך להיות גאה בו בחייך');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1899, N'F1761', 1, N'האם הקרבת אי פעם הקרבה גדולה מאוד למען מישהו אחר? אם כן, איזו הקרבה ולמי?', N'האם הקרבת אי פעם הקרבה גדולה מאוד למען מישהו אחר? אם כן, איזו הקרבה ולמי?', NULL, N'האם הקרבת אי פעם הקרבה גדולה מאוד למען מישהו אחר? אם כן, איזו הקרבה ולמי?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1900, N'F1762', 1, N'מה דעתך לגבי הריחות הבאים? (כל מילת תואר שעולה לך בראש)', N'מה דעתך לגבי הריחות הבאים? (כל מילת תואר שעולה לך בראש)', NULL, NULL);
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1901, N'F1763', 1, N'פרט (כן, תטרח קצת, לא נורא) את כל זוגות המכנסיים שיש לך בארון, כולל סוג וצבע', N'פרטי (כן, תטרחי קצת, לא נורא) את כל זוגות המכנסיים שיש לך בארון, כולל סוג וצבע', NULL, N'זוגות המכנסיים שיש לך בארון, כולל סוג וצבע');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1902, N'F1764', 1, N'כמה זה נכון? (לא נכון, קצת, נכון מאוד וכו''...) ', N'כמה זה נכון? (לא נכון, קצת, נכון מאוד וכו''...) ', NULL, NULL);
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1903, N'F1766', 1, N'תאר מקרה שבו כעסת על ביקורת שהעבירו עליך, אבל אחרי זמן הבנת שהביקורת היתה נכונה', N'תארי מקרה שבו כעסת על ביקורת שהעבירו עליך, אבל אחרי זמן הבנת שהביקורת היתה נכונה', NULL, N'תאר\י מקרה שבו כעסת על ביקורת, אבל אחרי זמן הבנת שהביקורת היתה נכונה');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1904, N'F1767', 1, N'האם אתה זוכר מקרה שבו מישהו הוריד לך את הביטחון? מי ועל מה?', N'האם את זוכרת מקרה שבו מישהו הוריד לך את הביטחון? מי ועל מה?', NULL, N'האם את\ה זוכר\ת מקרה שבו מישהו הוריד לך את הביטחון? מי ועל מה?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1905, N'F1768', 1, N'האם יש לך אקסית שאתה חבר שלה בפייסבוק? אם לא, האם יצא לך להציץ בפייסבוק של אקס?', N'האם יש לך אקס שאת חברה שלו בפייסבוק? אם לא, האם יצא לך להציץ בפייסבוק של אקס?', NULL, N'האם יש לך אקס\ית שאת\ה חבר\ה שלו בפייסבוק? אם לא, האם יצא לך להציץ בפייסבוק של אקס\ית?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1906, N'F1769', 1, N'האם חבר או חברה טובים איכזבו אותך פעם? אם כן, במה?', N'האם חבר או חברה טובים איכזבו אותך פעם? אם כן, במה?', NULL, N'האם חבר או חברה טובים איכזבו אותך פעם? אם כן, במה?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1907, N'F1770', 1, N'האם ידוע לך על מישהו שמקנא בך? אם כן, מדוע הוא מקנא?', N'האם ידוע לך על מישהו שמקנא בך? אם כן, מדוע הוא מקנא?', NULL, N'האם ידוע לך על מישהו שמקנא בך? אם כן, מדוע הוא מקנא?')
;
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1908, N'F1771', 1, N'האם יצא לך להכיר מישהי בסיטואציה לא רומנטית, ורק אחרי זמן רב (לפחות כמה חודשים) להרגיש לפתע משיכה אליה?', N'האם יצא לך להכיר מישהו בסיטואציה לא רומנטית, ורק אחרי זמן רב (לפחות כמה חודשים) להרגיש לפתע משיכה אליו?', NULL, N'האם יצא לך להכיר מישהו\י בסיטואציה לא רומנטית, ורק אחרי זמן רב (לפחות כמה חודשים) להרגיש לפתע משיכה אליו\ה?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1909, N'F1772', 1, N'עד כמה היית מרגיש בנוח אם לחברה שלך יש ידידים קרובים?', N'עד כמה היית מרגישה בנוח אם לחבר שלך יש ידידות קרובות? ', NULL, N'עד כמה את\ה מרגיש\ה בנוח אם לחבר\ה שלך יש ידידות קרובות \ ידידים קרובים? ');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1910, N'F1773', 1, N'מה היתה הפעם האחרונה שבה אמרת למישהו "מצטער"?', N'מה היתה הפעם האחרונה שבה אמרת למישהו "מצטערת"?', NULL, N'מה היתה הפעם האחרונה שבה אמרת למישהו "מצטער\ת"?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1911, N'F1774', 1, N'האם אתה מרגיש בנוח אם החברה שלך תשמור על קשר עם אקס שלה?', N'האם את מרגישה בנוח עם החבר שלך ישמור על קשר עם אקסית שלו?', NULL, N'האם אתם מרגישים בנוח עם החבר\ה שלכם שומר\ת על קשר עם אקסים\יות?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1912, N'F1776', 1, N'עד כמה אתה אסרטיבי? קיבלת מנת צהריים לא ממש חמה מהמלצר\ית. מה תעשה?', N'עד כמה את אסרטיבית? קיבלת מנת צהריים לא ממש חמה מהמלצר\ית. מה תעשי?', NULL, N'עד כמה אתם אסרטיביים? קיבלתם חביתה לא ממש חמה מהמלצר\ית. מה תעשו?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1913, N'F1778', 1, N'ספר על פעם שבה עברת על החוק', N'ספרי על פעם שבה עברת על החוק', NULL, N'ספר\י על פעם שבה עברת על החוק');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1914, N'F1779', 1, N'ספר על מקרה שבו לא עשית את מה שאתה תמיד מטיף לעשות', N'ספרי על מקרה שבו לא עשית את מה שאת תמיד מטיפה לעשות', NULL, N'ספרו על מקרה שבו לא עשיתם את מה שאתם תמיד מטיפים לעשות');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1915, N'F1780', 1, N'ספר על משהו יפה שראית היום', N'ספרי על משהו יפה שראית היום', NULL, N'ספר\י על משהו יפה שראית היום');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1916, N'F1783', 1, N'האם אתה מחליט וחותך מהר, או שאתה נוהג להתלבט הרבה עד שאתה מחליט?', N'האם את מחליטה וחותכת מהר, או שאת נוהגת להתלבט הרבה עד שאת מחליטה?', NULL, N'האם אתם מחליטים מהר, או שאתם נוהגים להתלבט הרבה?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1917, N'F1784', 1, N'נניח שעכשיו 4 בבוקר. אתה ער. מדוע?', N'נניח שעכשיו 4 בבוקר. את ערה. מדוע?', NULL, N'נניח שעכשיו 4 בבוקר. את\ה ער\ה. מדוע?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1918, N'F1785', 1, N'דרג עד כמה אתה אוהב את תחנות הרדיו? (אוהב מאוד, בכלל לא, קצת וכו''...)', N'דרגי עד כמה את אוהבת את תחנות הרדיו? (אוהבת מאוד, בכלל לא, קצת וכו''...)', NULL, N'דרגו עד כמה את אוהבים את תחנות הרדיו:');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1919, N'F1786', 1, N'אתה צריך לארגן פעילות לדייט הבא שלך. איך נראות לך ההצעות הבאןת? (מעולה, גרוע, ככה ככה, וכו''...) ', N'את צריכה לארגן פעילות לדייט הבא שלך. איך נראות לך ההצעות הבאות? (מעולה, גרוע, ככה ככה וכו''...) ', NULL, N'אתם צריכים לארגן פעילות לדייט הבא שלכם');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1920, N'F1787', 1, N'איך מכעיסים אותך?', N'איך מכעיסים אותך?', NULL, N'איך מכעיסים אותך?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1921, N'F1788', 1, N'עד כמה אתה מאמץ את הקונספט שאם פגשת מישהי שווה במיוחד, כדאי לנסות לדחות כמה שיותר את הקטע הפיסי ביניכם.', N'עד כמה אתה מאמצת את הקונספט שאם פגשת מישהו שווה במיוחד, כדאי לנסות לדחות כמה שיותר את הקטע הפיסי ביניכם.', NULL, N'עד כמה את\ה מאמצת את הקונספט שאם פגשת מישהו\הי שווה במיוחד, כדאי לנסות לדחות כמה שיותר את הקטע הפיסי ביניכם.');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1922, N'F1789', 1, N'האם לגור עם ההורים זה לא בא בחשבון, או שזה דווא יכול להתאים לפעמים כדי לחסוך כסף?', N'האם לגור עם ההורים זה לא בא בחשבון, או שזה דווא יכול להתאים לפעמים כדי לחסוך כסף?', NULL, N'האם לגור עם ההורים זה לא בא בחשבון, או שזה דווא יכול להתאים לפעמים כדי לחסוך כסף?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1923, N'F1790', 1, N'אתה מלצר במסעדה, יש מצב שתאכל מתוך צלחת שלקוח השאיר ולא סיים הכל? ', N'את מלצרית במסעדה, יש מצב שתאכלי מתוך צלחת שלקוח השאיר ולא סיים הכל? ', NULL, N'את\ה מלצר\ית במסעדה, יש מצב שתאכל\י מתוך צלחת שלקוח השאיר ולא סיים הכל? ');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1924, N'F1791', 1, N'פגשת מישהי נדירה וזה נראה רציני. מיהם שלושת הראשונים שתספר להם על כך?', N'פגשת מישהו נדיר וזה נראה רציני. מיהם שלושת הראשונים שתספרי להם על כך?', NULL, N'פגשת מישהו\י נדיר וזה נראה רציני. מיהם שלושת הראשונים שתספר\י להם על כך?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1925, N'F1792', 1, N'מה התכניות שלך למחר?', N'מה התכניות שלך למחר?', NULL, N'מה התכניות שלך למחר?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1926, N'F1793', 1, N'האם יצא לך להודות שטעית, גם אם חשבת שבכלל לא טעית, רק כדי לסיים באווירה טובה  ויכוח עם אישה? עם מי זה היה?', N'האם יצא לך להודות שטעית, גם אם חשבת שבכלל לא טעית, רק כדי לסיים באווירה טובה ויכוח עם גבר? עם מי זה היה.', NULL, N'האם יצא לך להודות שטעית, גם אם חשבת שבכלל לא טעית, רק כדי לסיים באווירה טובה ויכוח עם גבר\אישה?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1927, N'F1794', 1, N'האם אתה נוהג לאגור חפצים מהעבר, או שאתה מעדיף לזרוק כמה שיותר?', N'האם את נוהגת לאגור חפצים מהעבר, או שאת מעדיפה לזרוק כמה שיותר?', NULL, N'האם אתם נוהגים לאגור חפצים מהעבר, או שאתם מעדיפים לזרוק כמה שיותר?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1928, N'F1795', 1, N'עם מי ואיך חגגת את יום ההולדת האחרון שלך?', N'עם מי ואיך חגגת את יום ההולדת האחרון שלך?', NULL, N'עם מי ואיך חגגת את יום ההולדת האחרון שלך?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1929, N'F1796', 1, N'ממה הופתעת מאוד בזמן האחרון?', N'ממה הופתעת מאוד בזמן האחרון?', NULL, N'ממה הופתעת מאוד בזמן האחרון?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1930, N'F1797', 1, N'באיזה מקרה לאחרונה העדפת לסתום את הפה, למרות שהיה לך הרבה מה להגיד? ', N'באיזה מקרה לאחרונה העדפת לסתום את הפה, למרות שהיה לך הרבה מה להגיד? ', NULL, N'באיזה מקרה לאחרונה העדפת לסתום את הפה, למרות שהיה לך הרבה מה להגיד? ');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1931, N'F1798', 1, N'איך אתה מתנהל עם כספים? (בכלל לא, תמיד, לפעמים, וכו''...) ', N'איך את מתנהלת עם כספים? (בכלל לא, תמיד, לפעמים, וכו''...) ', NULL, N'איך את\ה מתנהל\ת עם כספים? ');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1932, N'F1799', 1, N'עד כמה אתה מפונק? (בכלל לא, הרבה, קצת, וכו''...)', N'עד כמה את מפונקת? (בכלל לא, הרבה, קצת, וכו''...)', NULL, N'עד כמה את\ה מפונק\ת? ');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1933, N'F1800', 1, N'מה האתגר שלך לשבוע הקרוב?', N'מה האתגר שלך לשבוע הקרוב?', NULL, N'מה האתגר שלך לשבוע הקרוב?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1934, N'F1801', 1, N'איזה ג''אנקפוד אתה אוהב? (בכלל לא, מאוד, קצת, וכו''...) ', N'איזה ג''אנקפוד את אוהבת? (בכלל לא, מאוד, קצת, וכו''...) ', NULL, N'איזה ג''אנקפוד אתם אוהבים?  ');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1935, N'F1802', 1, N'איזה ג''אנקפוד אתה אוהב? (בכלל לא, מאוד, קצת, וכו''...) ', N'איזה ג''אנקפוד את אוהבת? (בכלל לא, מאוד, קצת, וכו''...) ', NULL, N'איזה ג''אנקפוד אתם אוהבים? ');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1936, N'F1803', 1, N'הרכב לעצמך פיצה חלומית גורמה', N'הרכיבי לעצמך פיצה חלומית גורמה', NULL, N'הרכיבו לעצמכם פיצה חלומית גורמה');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1937, N'F1804', 1, N'יש לך כסף לשני טיפולי מניקור פדיקור, או שני ג''ינסים, או טלפון סלולרי סיני. במה תבחר? (מותר לך לבקש משהו אחר שעלותו דומה)', N'יש לך כסף לשני טיפולי מניקור פדיקור, או שני ג''ינסים, או טלפון סלולרי סיני. במה תבחרי? (מותר לך לבקש משהו אחר שעלותו דומה)', NULL, N'יש לך כסף לשני טיפולי מניקור פדיקור, או שני ג''ינסים, או טלפון סלולרי סיני. במה תבחר\י? (מותר לך לבקש משהו אחר שעלותו דומה)');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1938, N'F1805', 1, N'מה אתה יודע לעשות? (בכלל לא, בוודאי, קצת, וכו''...) ', N'מה את יודעת לעשות? (בכלל לא, בוודאי, קצת, וכו''...) ', NULL, NULL);
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1939, N'F1807', 1, N'איזה שיר תשיר במקלחת הקרובה שלך?', N'איזה שיר תשירי במקלחת הקרובה שלך?', NULL, N'איזה שיר תשיר\י במקלחת הקרובה שלך?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1940, N'F1808', 1, N'עד כמה תאהב לקבל את המחמאות הבאות מאישה: (אוי ואבוי, מממ... יאמי, קצת, וכו''...) ', N'עד כמה תאהבי לקבל את המחמאות הבאות מגבר: (אוי ואבוי, מממ... יאמי, קצת, וכו''...) ', NULL, N'עד כמה תאהב\י לקבל את המחמאות הבאות מגבר\אישה: ');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1941, N'F1809', 1, N'עד כמה תאהב לקבל את המחמאות הבאות מאישה: (אוי ואבוי, מממ... יאמי, קצת, וכו''...) ', N'עד כמה תאהבי לקבל את המחמאות הבאות מגבר: (אוי ואבוי, מממ... יאמי, קצת, וכו''...) ', NULL, N'עד כמה תאהב\י לקבל את המחמאות הבאות מגבר\אישה: ');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1942, N'F1810', 1, N'עד כמה תסכים להיות בן זוג של: (לא בא בחשבון, אולי, בכיף, וכו''...) ', N'עד כמה תסכימי להיות בת זוג של: (לא בא בחשבון, אולי, בכיף, וכו''...) ', NULL, N'עד כמה תסכימו להיות בני\בנות זוג של:');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1943, N'F1811', 1, N'החבר שלך מודיע לך שהוא מתכוון לנסוע לכנס מקצועי (עם הרבה נשים שעובדות איתו), שם כולם יכנסו גם לבריכה וג''קוזי. מה תגובתך?', N'החברה שלך מודיעה לך שהיא מתכוונת לנסוע לכנס מקצועי (עם הרבה גברים שעובדים איתה), שם כולם יכנסו גם לבריכה וג''קוזי. מה תגובתך?', NULL, N'החבר\ה שלך מודיע\ה לך שהיא\הוא מתכוונ\ת לנסוע לכנס מקצועי (עם הרבה גברים \נשיםשעובדים איתו\ה), שם כולם יכנסו גם לבריכה וג''קוזי. מה תגובתך?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1944, N'F1812', 1, N'עד כמה המקצועות הבאים מיותרים בעיניך, (מיותר לגמרי, לא מיותר, אולי, וכו''..) הוסף מקצוע שלדעתך גם הוא מיותר:', N'עד כמה המקצועות הבאים מיותרים בעיניך, (מיותר לגמרי, לא מיותר, אולי, וכו''..) הוסיפי מקצוע שלדעתך גם הוא מיותר:', NULL, N'עד כמה המקצועות הבאים מיותרים בעיניך?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1945, N'F1813', 1, N'עד כמה חלומות יכולים לחזות את העתיד, או מנבאים את התשוקות הפנימיות שלנו? מה דעתך?', N'עד כמה חלומות יכולים לחזות את העתיד, או מנבאים את התשוקות הפנימיות שלנו? מה דעתך?', NULL, N'עד כמה חלומות יכולים לחזות את העתיד, או מנבאים את התשוקות הפנימיות שלנו? מה דעתך?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1946, N'F1814', 1, N'נסה להעריך כמה כסף הוצאת בשנה האחרונה על מוצרי טיפוח? (אפטרשייב, בושם, קרמים וכו'')', N'נסי להעריך כמה כסף הוצאת בשנה האחרונה על מוצרי טיפוח? (איפור, בושם, קרמים וכו'')', NULL, N'נסה\י להעריך כמה כסף הוצאת בשנה האחרונה על מוצרי טיפוח? (איפור, בושם, קרמים וכו'')');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1947, N'F1815', 1, N'ספר על משהו מיותר לגמרי שעשית בחיים שלך, שהיה סתם בזבוז זמן', N'ספרי על משהו מיותר לגמרי שעשית בחיים שלך, שהיה סתם בזבוז זמן', NULL, N'ספר\י על משהו מיותר לגמרי שעשית בחיים שלך, שהיה סתם בזבוז זמן');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1948, N'F1816', 1, N'ליד איזה אנשים אתה מרגיש הכי רגוע ושלא שופטים אותך? (ספר על 2-3) ', N'ליד איזה אנשים את מרגישה הכי רגועה ושלא שופטים אותך? (ספרי על 2-3) ', NULL, N'ליד איזה אנשים אתם מרגישים הכי רגועים ושלא שופטים אתכם? (ספרו על 2-3) ');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1949, N'F1817', 1, N'האם אתה מדמיין מצב שבו תוותר על מעבר לחו"ל לקידום בקריירה, בגלל אהבה? האם קרה לך?', N'האם את מדמיינת מצב שבו תוותרי על מעבר לחו"ל לקידום בקריירה, בגלל אהבה? האם קרה לך?', NULL, N'האם אתם מדמיינים מצב שבו תוותרו על מעבר לחו"ל לקידום בקריירה, בגלל אהבה? האם קרה לכם?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1950, N'F1818', 1, N'למה החיים שלך יפים?', N'למה החיים שלך יפים?', NULL, N'למה החיים שלך יפים?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1951, N'F1819', 1, N'השלים', N'השלימי', NULL, N'השלימו:');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1952, N'F1820', 1, N'במה לא מבינים אותך, וזה מתסכל אותך?', N'במה לא מבינים אותך, וזה מתסכל אותך?', NULL, N'במה לא מבינים אותך, וזה מתסכל אותך?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1953, N'F1821', 1, N'מה יושב לך על הלב עכשיו?', N'מה יושב לך על הלב עכשיו?', NULL, N'מה יושב לך על הלב עכשיו?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1954, N'F1823', 1, N'תאר הרגל יומיומי שמרגיע אותך', N'תארי הרגל יומיומי שמרגיע אותך', NULL, N'תאר\י הרגל יומיומי שמרגיע אותך');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1955, N'F1824', 1, N'איזו רמת יכולת ריכוז יש לך? עד כמה קל להסיח את דעתך?', N'איזו רמת יכולת ריכוז יש לך? עד כמה קל להסיח את דעתך?', NULL, N'איזו רמת יכולת ריכוז יש לך? עד כמה קל להסיח את דעתך?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1956, N'F1825', 1, N'עד כמה חשובות לך המטרות הבאות? (מאוד, בכלל לא, קצת, וכו''...)', N'עד כמה חשובות לך המטרות הבאות? (מאוד, בכלל לא, קצת, וכו''...)', NULL, N'עד כמה חשובות לך המטרות הבאות?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1957, N'F1826', 1, N'עד כמה חשובות לך המטרות הבאות? (מאוד, בכלל לא, קצת, וכו''...)', N'עד כמה חשובות לך המטרות הבאות? (מאוד, בכלל לא, קצת, וכו''...)', NULL, N'עד כמה חשובות לך המטרות הבאות?');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1958, N'F1827', 1, N'תאר מקרה בו פישלת (למשל, היית צריך לשמור על כלב של חבר, והוא ברח)', N'תארי מקרה בו פישלת (למשל, היית צריכה לשמור על כלב של חבר, והוא ברח)', NULL, N'תאר\י מקרה בו פישלת (למשל, היית צריכ\ה לשמור על כלב של חבר, והוא ברח)');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1959, N'F1828', 1, N'עד כמה נכונים בעיניך המשפטים הבאים: (מאוד, בכלל לא, קצת וכו''...)', N'עד כמה נכונים בעיניך המשפטים הבאים: (מאוד, בכלל לא, קצת וכו''...)', NULL, NULL);
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1960, N'F1829', 1, N'עד כמה נכונים בעיניך המשפטים הבאים: (מאוד, בכלל לא, קצת וכו''...)', N'עד כמה נכונים בעיניך המשפטים הבאים: (מאוד, בכלל לא, קצת וכו''...)', NULL, NULL);
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1961, N'P1001', 1, N'מה תלבש לדייט? הנח את בגדים על משטח וצלם', N'מה תלבשי לדייט? הניחי את בגדים על משטח וצלמי.', NULL, N'לבוש לדייט');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1962, N'P1002', 1, N'צלם את הספר שהיית שם על השולחן כדי שיחשבו שאתה אינטלקטואל', N'צלמי את הספר שהיית שמה על השולחן כדי שיחשבו שאת אינטלקטואלית.', NULL, N'ספר אינטלקטואלי');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1963, N'P1003', 1, N'ההורים באים לביקור פתע! צלם את מה שהיית מעלים מהשטח מיידית.', N'ההורים באים לביקור פתע! צלמי את מה שהיית מעלימה מהשטח מיידית.', NULL, N'להעלים דחוף כשההורים באים');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1964, N'P1004', 1, N'צלם מתנה גרועה שאתה שונא, אבל שומר משום מה.', N'צלמי מתנה גרועה שאת שונאת, אבל שומרת משום מה.', NULL, N'מתנה גרועה  ');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1965, N'P1005', 1, N'צלם את פנים ארון הבגדים שלך. ', N'צלמי את פנים ארון הבגדים שלך. ', NULL, N'ארון הבגדים');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1966, N'P1006', 1, N'צלם את הנעליים הכי שוות שלך', N'צלמי את הנעליים הכי שוות שלך', NULL, N'נעליים הכי שוות');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1967, N'P1007', 1, N'צלם את הנעליים הכי מע''פנות שלך. ', N'צלמי את הנעליים הכי מע''פנות שלך. ', NULL, N'נעליים הכי מע''פנות');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1968, N'P1008', 1, N'צלם את כיור המטבח כפי שהוא נראה כרגע. ', N'צלמי את כיור המטבח כפי שהוא נראה כרגע. ', NULL, N'כיור המטבח');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1969, N'P1009', 1, N'צלם חפץ בדירה שלך שהיית תורם ללא היסוס.', N'צלמי חפץ בדירה שלך שהיית תורמת ללא היסוס.', NULL, N'חפץ לתרומה');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1970, N'P1010', 1, N'צלם משהו שיתאר את המצב רוח שלך בזה הרגע. ', N'צלמי משהו שיתאר את המצב רוח שלך בזה הרגע. ', NULL, N'מצב הרוח בזה הרגע');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1971, N'P1011', 1, N'צלם את שולחן העבודה שלך.', N'צלמי את שולחן העבודה שלך.', NULL, N'שולחן העבודה');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1972, N'P1012', 1, N'צלם את מדף המקרר שלך.', N'צלמי את מדף המקרר שלך.', NULL, N'מדף המקרר');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1973, N'P1013', 1, N'צלם את כף היד שלך', N'צלמי את כף היד שלך', NULL, N'כף היד');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1974, N'P1014', 1, N'נניח שתקבל מיליון דולר במזומן, צלם את המקום בו היית מחביא אותם בדירה', N'נניח שתקבלי מיליון דולר במזומן, צלמי את המקום בו היית מחביאה אותם בדירה.', NULL, N'להחביא מיליון דולר');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1975, N'P1015', 1, N'צלם בגד שהיית צריך לזרוק מזמן. ', N'צלמי בגד שהיית צריכה לזרוק מזמן. ', NULL, N'בגד לזריקה');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1976, N'P1016', 1, N'צלם את מדף הספרים שלך (או חלק ממנו), באופן שאפשר יהיה לזהות את כותרי הספרים. ', N'צלמי את מדף הספרים שלך (או חלק ממנו), באופן שאפשר יהיה לזהות את כותרי הספרים. ', NULL, N'מדף הספרים');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1977, N'P1017', 1, N'שלח צילום מסך של מסך הבית בטלפון שלך ', N'שלחי צילום מסך של מסך הבית בטלפון שלך', NULL, N'מסך הבית בטלפון');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1978, N'P1018', 1, N'צלם את המיטה בה אתה ישן. ', N'צלמי את המיטה בה את ישנה. ', NULL, N'מיטה');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1979, N'P1019', 1, N'צלם את משקפי השמש שלך.', N'צלמי את משקפי השמש שלך.', NULL, N'משקפי השמש');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1980, N'P1020', 1, N'צלם את השמפו ו\או את הסבון בהם אתה משתמש. ', N'צלמי את השמפו ו\או את הסבון איתם את משתמשת. ', NULL, N'שמפו');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1981, N'P1021', 1, N'אם אם תיתן את המיטה שלך לאורח בלילה, צלם את המקום בבית שבו אתה תישן. ', N'אם אם תיתני את המיטה שלך לאורח בלילה, צלמי את המקום בבית שבו את תישני. ', NULL, N'מקום לישון כשיש אורחים');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1982, N'P1022', 1, N'צלם משהו כחול', N'צלמי משהו כחול', NULL, N'משהו כחול');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1983, N'P1023', 1, N'צלם משהו אדום', N'צלמי משהו אדום', NULL, N'משהו אדום');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1984, N'P1024', 1, N'צלם משהו צהוב', N'צלמי משהו צהוב', NULL, N'משהו צהוב');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1985, N'P1025', 1, N'צלם משהו שחור', N'צלמי משהו שחור', NULL, N'משהו שחור');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1986, N'P1026', 1, N'צלם משהו לבן', N'צלמי משהו לבן', NULL, N'משהו לבן');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1987, N'P1027', 1, N'צלם משהו ירוק', N'צלמי משהו ירוק', NULL, N'משהו ירוק');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1988, N'P1028', 1, N'צייר איש\ה על דף נייר, צלם ושלח. ', N'ציירי על דף נייר איש\ה, צלמי ושלחי. ', NULL, N'ציור של איש\ה');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1989, N'P1029', 1, N'כתוב על דף נייר משפט כלשהו, צלם ושלח', N'כתבי על דף נייר משפט כלשהו, צלמי ושלחי', NULL, N'כתב יד');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1990, N'P1030', 1, N'צייר בית על דף נייר, צלם ושלח', N'ציירי על דף נייר בית, צלמי ושלחי', NULL, N'ציור של בית');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1991, N'P1031', 1, N'צייר על דף נייר פרצוף מחייך סמיילי, צלם ושלח', N'ציירי על דף נייר פרצוף מחייך סמיילי, צלמי ושלחי', NULL, N'פרצוף סמיילי');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1992, N'P1032', 1, N'שלח תמונה כלשהי מהגלריה (מבלי לחשוף שום דבר לא רצוי, כמובן)', N'שלחי תמונה כלשהי מהגלריה (מבלי לחשוף שום דבר לא רצוי, כמובן)', NULL, N'תמונה מהגלריה');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1993, N'P1033', 1, N'צלם משהו מהמקום בו אתה נמצא עכשיו', N'צלמי משהו מהמקום בו את נמצאת עכשיו', NULL, N'המקום בו אני נמצא\ת עכשיו');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1994, N'P1034', 1, N'צלם את כוס הקפה שלך', N'צלמי את כוס הקפה שלך', NULL, N'כוס הקפה');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1995, N'P1035', 1, N'צלם את ארוחת הבוקר שלך', N'צלמי את ארוחת הבוקר שלך', NULL, N'ארוחת הבוקר');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1996, N'P1036', 1, N'אתה יוצא מהבית לרחוב - צלם את מה שאתה רואה', N'את יוצאת מהבית לרחוב - צלמי את מה שאת רואה', NULL, N'הרחוב ליד הבית');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1997, N'P1037', 1, N'צלם רהיט בבית שלך', N'צלמי רהיט בבית שלך', NULL, N'רהיט');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1998, N'P1038', 1, N'צלם קישוט על הקיר בחדר שלך', N'צלמי קישוט על הקיר בחדר שלך', NULL, N'קישוט על הקיר');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (1999, N'P1039', 1, N'הסתכל מהחלון בדירה\בית - צלם מה שאתה רואה', N'הסתכלי מהחלון בדירה\בית - צלמי מה שאת רואה', NULL, N'מה שרואים מהחלון');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (2000, N'P1040', 1, N'צלם אחד מהתמרוקים שלך (גילוח, דיאודורנט, וכו''...)', N'צלמי אחד מהתמרוקים שלך ', NULL, N'תמרוקים');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (2001, N'P1041', 1, N'פתח מגירה וצלם את מה שבפנים', N'פתחי מגירה וצלמי את מה שבפנים', NULL, N'פנים המגירה');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (2002, N'P1042', 1, N'צלם חפץ בבית שאתה נוהג להעביר איתו זמן פנוי', N'צלמי חפץ בבית שאת נוהגת להעביר איתו זמן פנוי', NULL, N'חפץ לזמן פנוי');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (2003, N'P1043', 1, N'צלם זו גרביים נקיות שלך', N'צלמי זוג גרביים נקיות שלך', NULL, N'זוג גרביים');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (2004, N'P1044', 1, N'צלם חפץ שאיתו אתה מתקן דברים', N'צלמי חפץ שאיתו את מתקנת דברים', NULL, N'חפץ לתיקון דברים');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (2005, N'P1045', 1, N'צלם מכנסיים קצרות שלך', N'צלמי מכנסיים קצרות\חצאית שלך', NULL, N'מכנסיים קצרות\חצאית');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (2006, N'P1046', 1, N'צלם מכנסיים ארוכות שלך', N'צלמי מכנסיים ארוכות\שמלה שלך', NULL, N'מכנסיים ארוכות\שמלה');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (2007, N'P1047', 1, N'צלם חולצת יום יום שלך', N'צלמי חולצת יום יום שלך', NULL, N'חולצת יום יום')
;
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (2008, N'P1048', 1, N'צלם נעלי ספורט שלך', N'צלמי נעלי ספורט שלך', NULL, N'נעלי ספורט');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (2009, N'P1049', 1, N'צלם משהו לאכול שאתה מנשנש כשאתה במצב רוח רע', N'צלמי משהו לאכול שאת מנשנשת כשאת במצב רוח רע', NULL, N'נשנוש למצב רוח רע');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (2010, N'P1050', 1, N'אם יש לך קעקוע איפשהו על הגוף, צלם אותו, אם לא, צלם איפה שהיית שם קעקוע בגוף ', N'אם יש לך קעקוע איפשהו על הגוף, צלמי אותו. אם לא, צלמי איפה היית שמה קעקוע בגוף', NULL, N'קעקוע');
INSERT `pwm`.`net_TaskText` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES (2011, N'-1', 1, N'איזו רמת יכולת ריכוז יש לך? עד כמה קל להסיח את דעתך?  aaaa', N'איזו רמת יכולת ריכוז יש לך? עד כמה קל להסיח את דעתך?ddddd', NULL, N'AA');

INSERT `pwm`.`net_TaskType` (`Id`, `Description`) VALUES (1, N'Q-2');
INSERT `pwm`.`net_TaskType` (`Id`, `Description`) VALUES (2, N'Q-3');
INSERT `pwm`.`net_TaskType` (`Id`, `Description`) VALUES (3, N'Q-4');
INSERT `pwm`.`net_TaskType` (`Id`, `Description`) VALUES (4, N'Photo');
INSERT `pwm`.`net_TaskType` (`Id`, `Description`) VALUES (5, N'Video');
INSERT `pwm`.`net_TaskType` (`Id`, `Description`) VALUES (6, N'Fill text');
INSERT `pwm`.`net_TaskType` (`Id`, `Description`) VALUES (14, N'Q Chain');
INSERT `pwm`.`net_TaskType` (`Id`, `Description`) VALUES (15, N'Voice');

INSERT `pwm`.`net_TextInMultiLanguages` (`Id`, `TextId`, text, `LanguageId`) VALUES (1, 1, N'%3Chtml%3E%0A%3Chead%3E%0A%09%3Ctitle%3E%3C%2Ftitle%3E%0A%3C%2Fhead%3E%0A%3Cbody%3E%0A%3Cp%3E%D7%94%D7%9E%D7%A9%D7%97%D7%A7%20%D7%94%D7%A1%D7%AA%D7%99%D7%99%D7%9D%3C%2Fp%3E%0A%3C%2Fbody%3E%0A%3C%2Fhtml%3E%0A', 1);
INSERT `pwm`.`net_TextInMultiLanguages` (`Id`, `TextId`, text, `LanguageId`) VALUES (2, 1, N'%3Chtml%3E%0A%3Chead%3E%0A%09%3Ctitle%3E%3C%2Ftitle%3E%0A%3C%2Fhead%3E%0A%3Cbody%3E%0A%3Cp%3EGame%20ended!!%3C%2Fp%3E%0A%3C%2Fbody%3E%0A%3C%2Fhtml%3E%0A', 2);
INSERT `pwm`.`net_TextInMultiLanguages` (`Id`, `TextId`, text, `LanguageId`) VALUES (3, 1, N'End Game', 3);
INSERT `pwm`.`net_TextInMultiLanguages` (`Id`, `TextId`, text, `LanguageId`) VALUES (4, 1, N'End Game', 4);
INSERT `pwm`.`net_TextInMultiLanguages` (`Id`, `TextId`, text, `LanguageId`) VALUES (5, 2, N'%3Chtml%3E%0A%3Chead%3E%0A%09%3Ctitle%3E%3C%2Ftitle%3E%0A%3C%2Fhead%3E%0A%3Cbody%3E%0A%3Cp%3E%3F%D7%94%D7%90%D7%9D%20%D7%9C%D7%94%D7%9E%D7%A9%D7%99%D7%9A%20%D7%9C%D7%9E%D7%A9%D7%97%D7%A7%20%D7%A0%D7%95%D7%A1%D7%A3%3C%2Fp%3E%0A%3C%2Fbody%3E%0A%3C%2Fhtml%3E%0A', 1);
INSERT `pwm`.`net_TextInMultiLanguages` (`Id`, `TextId`, text, `LanguageId`) VALUES (6, 2, N'Do you want to continue playing with your partner?', 2);
INSERT `pwm`.`net_TextInMultiLanguages` (`Id`, `TextId`, text, `LanguageId`) VALUES (7, 2, N'Do you want to continue playing with your partner?', 3);
INSERT `pwm`.`net_TextInMultiLanguages` (`Id`, `TextId`, text, `LanguageId`) VALUES (8, 2, N'Do you want to continue playing with your partner?', 4);
INSERT `pwm`.`net_TextInMultiLanguages` (`Id`, `TextId`, text, `LanguageId`) VALUES (9, 3, N'%3Chtml%3E%0A%3Chead%3E%0A%09%3Ctitle%3E%3C%2Ftitle%3E%0A%3C%2Fhead%3E%0A%3Cbody%3E%0A%3Cp%3EYour%20account%20has%20been%20%3Cstrong%3Edisabled%3C%2Fstrong%3E.%20pay%20via%26nbsp%3B%3Ca%20href%3D%22http%3A%2F%2Fwww.;ogle.com%22%3Ewww.;ogle.com%3C%2Fa%3E%26nbsp%3B%20HEB%3C%2Fp%3E%0A%3C%2Fbody%3E%0A%3C%2Fhtml%3E%0A', 1);
INSERT `pwm`.`net_TextInMultiLanguages` (`Id`, `TextId`, text, `LanguageId`) VALUES (10, 3, N'%3Chtml%3E%0A%3Chead%3E%0A%09%3Ctitle%3E%3C%2Ftitle%3E%0A%3C%2Fhead%3E%0A%3Cbody%3E%0A%3Cp%3EYour%20account%20has%20been%20%3Cspan%20style%3D%22color%3A%23e74c3c%22%3E%3Cstrong%3Edisabled%3C%2Fstrong%3E%3C%2Fspan%3E.%20Pay%20via%26nbsp%3B%3Ca%20href%3D%22http%3A%2F%2Fwww.;ogle.com%22%3Ewww.;ogle.com%3C%2Fa%3E%20ENG%3C%2Fp%3E%0A%3C%2Fbody%3E%0A%3C%2Fhtml%3E%0A', 2);
INSERT `pwm`.`net_TextInMultiLanguages` (`Id`, `TextId`, text, `LanguageId`) VALUES (11, 3, N'Your account has been disabled.', 3);
INSERT `pwm`.`net_TextInMultiLanguages` (`Id`, `TextId`, text, `LanguageId`) VALUES (12, 3, N'Your account has been disabled.', 4);
INSERT `pwm`.`net_TextInMultiLanguages` (`Id`, `TextId`, text, `LanguageId`) VALUES (1009, 1003, N'%3Chtml%3E%0A%3Chead%3E%0A%09%3Ctitle%3E%3C%2Ftitle%3E%0A%3C%2Fhead%3E%0A%3Cbody%3E%0A%3Cp%3EYou%20have%20reached%20the%20daily%20quota.%20Try%20again%20tomorrow%20HEB%3C%2Fp%3E%0A%3C%2Fbody%3E%0A%3C%2Fhtml%3E%0A', 1);
INSERT `pwm`.`net_TextInMultiLanguages` (`Id`, `TextId`, text, `LanguageId`) VALUES (1010, 1003, N'%3Chtml%3E%0A%3Chead%3E%0A%09%3Ctitle%3E%3C%2Ftitle%3E%0A%3C%2Fhead%3E%0A%3Cbody%3E%0A%3Cp%3EYou%20have%20reached%20the%20daily%20quota.%20Try%20again%20tomorrow%3C%2Fp%3E%0A%3C%2Fbody%3E%0A%3C%2Fhtml%3E%0A', 2);
INSERT `pwm`.`net_TextInMultiLanguages` (`Id`, `TextId`, text, `LanguageId`) VALUES (1011, 1003, N'You have reached the daily quota. Try again tomorrow', 3);
INSERT `pwm`.`net_TextInMultiLanguages` (`Id`, `TextId`, text, `LanguageId`) VALUES (1012, 1003, N'You have reached the daily quota. Try again tomorrow', 4);
INSERT `pwm`.`net_TextInMultiLanguages` (`Id`, `TextId`, text, `LanguageId`) VALUES (1013, 1004, N'%3Chtml%3E%0A%3Chead%3E%0A%09%3Ctitle%3E%3C%2Ftitle%3E%0A%3C%2Fhead%3E%0A%3Cbody%3E%0A%3Cp%3E%D7%9C%D7%97%D7%A6%2F%D7%99%20%D7%9B%D7%90%D7%9F%20%D7%91%D7%A9%D7%91%D7%99%D7%9C%20%D7%9C%D7%94%D7%96%D7%9E%D7%99%D7%9F%20%D7%A4%D7%A8%D7%98%D7%A0%D7%A8%20%D7%9C%D7%9E%D7%A9%D7%97%D7%A7%3C%2Fp%3E%0A%3C%2Fbody%3E%0A%3C%2Fhtml%3E%0A', 1);
INSERT `pwm`.`net_TextInMultiLanguages` (`Id`, `TextId`, text, `LanguageId`) VALUES (1014, 1004, N'Click here to invite more friends to play together', 2);
INSERT `pwm`.`net_TextInMultiLanguages` (`Id`, `TextId`, text, `LanguageId`) VALUES (1015, 1004, N'Click here to invite more friends to play together', 3);
INSERT `pwm`.`net_TextInMultiLanguages` (`Id`, `TextId`, text, `LanguageId`) VALUES (1016, 1004, N'Click here to invite more friends to play together', 4);
INSERT `pwm`.`net_TextInMultiLanguages` (`Id`, `TextId`, text, `LanguageId`) VALUES (1017, 1005, N'%3Chtml%3E%0A%3Chead%3E%0A%09%3Ctitle%3E%3C%2Ftitle%3E%0A%3C%2Fhead%3E%0A%3Cbody%3E%0A%3Cp%3E%D7%91%D7%A0%D7%99%20%D7%94%D7%96%D7%95%D7%92%20%D7%A9%D7%94%D7%95%D7%AA%D7%90%D7%9E%D7%95%20%D7%A2%D7%9C%20%D7%99%D7%93%D7%99%20%D7%94%D7%9E%D7%A2%D7%A8%D7%9B%D7%AA%3C%2Fp%3E%0A%3C%2Fbody%3E%0A%3C%2Fhtml%3E%0A', 1);
INSERT `pwm`.`net_TextInMultiLanguages` (`Id`, `TextId`, text, `LanguageId`) VALUES (1018, 1005, N'%3Chtml%3E%0A%3Chead%3E%0A%09%3Ctitle%3E%3C%2Ftitle%3E%0A%3C%2Fhead%3E%0A%3Cbody%3E%0A%3Cp%3EHere%20are%20your%20current%20partners%20assigned%20by%20the%20system%3C%2Fp%3E%0A%3C%2Fbody%3E%0A%3C%2Fhtml%3E%0A', 2);
INSERT `pwm`.`net_TextInMultiLanguages` (`Id`, `TextId`, text, `LanguageId`) VALUES (1019, 1005, N'%3Chtml%3E%0A%3Chead%3E%0A%09%3Ctitle%3E%3C%2Ftitle%3E%0A%3C%2Fhead%3E%0A%3Cbody%3E%0A%3Cp%3EHere%20are%20your%20current%20partners%20assigned%20by%20the%20system%3C%2Fp%3E%0A%3C%2Fbody%3E%0A%3C%2Fhtml%3E%0A', 3);
INSERT `pwm`.`net_TextInMultiLanguages` (`Id`, `TextId`, text, `LanguageId`) VALUES (1020, 1005, N'%3Chtml%3E%0A%3Chead%3E%0A%09%3Ctitle%3E%3C%2Ftitle%3E%0A%3C%2Fhead%3E%0A%3Cbody%3E%0A%3Cp%3EHere%20are%20your%20current%20partners%20assigned%20by%20the%20system%3C%2Fp%3E%0A%3C%2Fbody%3E%0A%3C%2Fhtml%3E%0A', 4);
INSERT `pwm`.`net_TextInMultiLanguages` (`Id`, `TextId`, text, `LanguageId`) VALUES (1021, 1006, N'%3Chtml%3E%0A%3Chead%3E%0A%09%3Ctitle%3E%3C%2Ftitle%3E%0A%3C%2Fhead%3E%0A%3Cbody%3E%0A%3Cp%3E%D7%A9%D7%9C%D7%99%D7%97%D7%AA%20%D7%94%D7%95%D7%93%D7%A2%D7%95%D7%AA%20%D7%A6%26%2339%3B%D7%90%D7%98%3C%2Fp%3E%0A%3C%2Fbody%3E%0A%3C%2Fhtml%3E%0A', 1);
INSERT `pwm`.`net_TextInMultiLanguages` (`Id`, `TextId`, text, `LanguageId`) VALUES (1022, 1006, N'This is for typing and sending messages', 2);
INSERT `pwm`.`net_TextInMultiLanguages` (`Id`, `TextId`, text, `LanguageId`) VALUES (1023, 1006, N'This is for typing and sending messages', 3);
INSERT `pwm`.`net_TextInMultiLanguages` (`Id`, `TextId`, text, `LanguageId`) VALUES (1024, 1006, N'This is for typing and sending messages', 4);
INSERT `pwm`.`net_TextInMultiLanguages` (`Id`, `TextId`, text, `LanguageId`) VALUES (1025, 1007, N'%3Chtml%3E%0A%3Chead%3E%0A%09%3Ctitle%3E%3C%2Ftitle%3E%0A%3C%2Fhead%3E%0A%3Cbody%3E%0A%3Cp%3E%D7%9C%D7%97%D7%A6%2F%D7%99%20%D7%9C%D7%94%D7%AA%D7%97%D7%9C%D7%AA%20%D7%94%D7%9E%D7%A9%D7%97%D7%A7%3C%2Fp%3E%0A%3C%2Fbody%3E%0A%3C%2Fhtml%3E%0A', 1);
INSERT `pwm`.`net_TextInMultiLanguages` (`Id`, `TextId`, text, `LanguageId`) VALUES (1026, 1007, N'Click here to start playing with your partner', 2);
INSERT `pwm`.`net_TextInMultiLanguages` (`Id`, `TextId`, text, `LanguageId`) VALUES (1027, 1007, N'Click here to start playing with your partner', 3);
INSERT `pwm`.`net_TextInMultiLanguages` (`Id`, `TextId`, text, `LanguageId`) VALUES (1028, 1007, N'Click here to start playing with your partner', 4);
INSERT `pwm`.`net_TextInMultiLanguages` (`Id`, `TextId`, text, `LanguageId`) VALUES (1029, 1008, N'%3Chtml%3E%0A%3Chead%3E%0A%09%3Ctitle%3E%3C%2Ftitle%3E%0A%3C%2Fhead%3E%0A%3Cbody%3E%0A%3Cp%3E%3Cspan%20style%3D%22color%3A%23e74c3c%22%3E%3Cstrong%3E%D7%9C%D7%97%D7%A6%2F%D7%99%20%D7%9B%D7%90%D7%9F%20%D7%91%D7%A9%D7%91%D7%99%D7%9C%3C%2Fstrong%3E%3C%2Fspan%3E%20%D7%9C%D7%A9%D7%97%D7%A7%20%3Cspan%20style%3D%22background-color%3A%23f1c40f%22%3E%D7%A2%D7%9D%20%D7%A4%D7%A8%D7%98%D7%A0%D7%A8%20%D7%97%D7%93%D7%A9%3C%2Fspan%3E%3C%2Fp%3E%0A%3C%2Fbody%3E%0A%3C%2Fhtml%3E%0A', 1);
INSERT `pwm`.`net_TextInMultiLanguages` (`Id`, `TextId`, text, `LanguageId`) VALUES (1030, 1008, N'Click here to play with the most suitable player', 2);
INSERT `pwm`.`net_TextInMultiLanguages` (`Id`, `TextId`, text, `LanguageId`) VALUES (1031, 1008, N'Click here to play with the most suitable player', 3);
INSERT `pwm`.`net_TextInMultiLanguages` (`Id`, `TextId`, text, `LanguageId`) VALUES (1032, 1008, N'Click here to play with the most suitable player', 4);
INSERT `pwm`.`net_TextInMultiLanguages` (`Id`, `TextId`, text, `LanguageId`) VALUES (1033, 1009, N'%3Chtml%3E%0A%3Chead%3E%0A%09%3Ctitle%3E%3C%2Ftitle%3E%0A%3C%2Fhead%3E%0A%3Cbody%3E%0A%3Cp%3E%D7%A9%D7%9C%D7%95%D7%9D%20%D7%A9%D7%9C%D7%95%D7%9D%3C%2Fp%3E%0A%0A%3Cp%3E%3Cspan%20style%3D%22font-family%3AArial%2CHelvetica%2Csans-serif%22%3E%3Cstrong%3EWelcome%20to%20Play%20with%20Me!%3C%2Fstrong%3E%20%F0%9F%8C%9F%3Cbr%20%2F%3E%0AYour%20journey%20to%20meaningful%20connections%20starts%20here.%20Whether%20you%26%2339%3Bre%20looking%20for%20love%2C%20friendship%2C%20or%20just%20great%20conversations%2C%20you%26%2339%3Bve%20come%20to%20the%20right%20place.%3C%2Fspan%3E%3C%2Fp%3E%0A%0A%3Cp%3E%3Cspan%20style%3D%22font-family%3AArial%2CHelvetica%2Csans-serif%22%3E%E2%9C%A8%20%3Cstrong%3EReady%20to%20meet%20someone%20amazing%3F%3C%2Fstrong%3E%3Cbr%20%2F%3E%0ATake%20a%20moment%20to%20set%20up%20your%20profile%2C%20explore%20matches%2C%20and%20get%20to%20know%20people%20who%20share%20your%20vibe.%3C%2Fspan%3E%3C%2Fp%3E%0A%0A%3Cp%3E%3Cspan%20style%3D%22font-family%3AArial%2CHelvetica%2Csans-serif%22%3ELet%20the%20conversations%20flow%20and%20the%20connections%20grow.%20We%26rsquo%3Bre%20here%20to%20make%20every%20interaction%20memorable.%20%E2%9D%A4%EF%B8%8F%3C%2Fspan%3E%3C%2Fp%3E%0A%0A%3Cp%3E%3Cspan%20style%3D%22font-family%3AArial%2CHelvetica%2Csans-serif%22%3EEnjoy%20the%20experience%2C%3Cbr%20%2F%3E%0A%3Cstrong%3EThe%20Play%20with%20Me%20Team%3C%2Fstrong%3E%3C%2Fspan%3E%3C%2Fp%3E%0A%3C%2Fbody%3E%0A%3C%2Fhtml%3E%0A', 1);
INSERT `pwm`.`net_TextInMultiLanguages` (`Id`, `TextId`, text, `LanguageId`) VALUES (1034, 1009, N'%3Chtml%3E%0A%3Chead%3E%0A%09%3Ctitle%3E%3C%2Ftitle%3E%0A%3C%2Fhead%3E%0A%3Cbody%3E%0A%3Cp%3E%3Cspan%20style%3D%22font-family%3AArial%2CHelvetica%2Csans-serif%22%3E%3Cstrong%3EWelcome%20to%20Play%20with%20Me!%3C%2Fstrong%3E%20%F0%9F%8C%9F%3Cbr%20%2F%3E%0AYour%20journey%20to%20meaningful%20connections%20starts%20here.%20Whether%20you%26%2339%3Bre%20looking%20for%20love%2C%20friendship%2C%20or%20just%20great%20conversations%2C%20you%26%2339%3Bve%20come%20to%20the%20right%20place.%3C%2Fspan%3E%3C%2Fp%3E%0A%0A%3Cp%3E%3Cspan%20style%3D%22font-family%3AArial%2CHelvetica%2Csans-serif%22%3E%E2%9C%A8%20%3Cstrong%3EReady%20to%20meet%20someone%20amazing%3F%3C%2Fstrong%3E%3Cbr%20%2F%3E%0ATake%20a%20moment%20to%20set%20up%20your%20profile%2C%20explore%20matches%2C%20and%20get%20to%20know%20people%20who%20share%20your%20vibe.%3C%2Fspan%3E%3C%2Fp%3E%0A%0A%3Cp%3E%3Cspan%20style%3D%22font-family%3AArial%2CHelvetica%2Csans-serif%22%3ELet%20the%20conversations%20flow%20and%20the%20connections%20grow.%20We%26rsquo%3Bre%20here%20to%20make%20every%20interaction%20memorable.%20%E2%9D%A4%EF%B8%8F%3C%2Fspan%3E%3C%2Fp%3E%0A%0A%3Cp%3E%3Cspan%20style%3D%22font-family%3AArial%2CHelvetica%2Csans-serif%22%3EEnjoy%20the%20experience%2C%3Cbr%20%2F%3E%0A%3Cstrong%3EThe%20Play%20with%20Me%20Team%3C%2Fstrong%3E%3C%2Fspan%3E%3C%2Fp%3E%0A%3C%2Fbody%3E%0A%3C%2Fhtml%3E%0A', 2);
INSERT `pwm`.`net_TextInMultiLanguages` (`Id`, `TextId`, text, `LanguageId`) VALUES (1035, 1009, N'%3Chtml%3E%0A%3Chead%3E%0A%09%3Ctitle%3E%3C%2Ftitle%3E%0A%3C%2Fhead%3E%0A%3Cbody%3E%0A%3Cp%3EWelcome!%3C%2Fp%3E%0A%3C%2Fbody%3E%0A%3C%2Fhtml%3E%0A', 3);
INSERT `pwm`.`net_TextInMultiLanguages` (`Id`, `TextId`, text, `LanguageId`) VALUES (1036, 1009, N'Welcome', 4);

INSERT `pwm`.`net_TimesForTask` (`Id`, `TaskId`, `FromTime`, `ToTime`) VALUES (1, N'F1014', CAST(N'2024-04-16T08:00:00.000' AS DateTime), CAST(N'2024-04-16T17:00:00.000' AS DateTime));
INSERT `pwm`.`net_TimesForTask` (`Id`, `TaskId`, `FromTime`, `ToTime`) VALUES (2, N'-1', CAST(N'2024-07-27T08:00:00.000' AS DateTime), CAST(N'2024-07-27T17:00:00.000' AS DateTime));
INSERT `pwm`.`net_TimesForTask` (`Id`, `TaskId`, `FromTime`, `ToTime`) VALUES (3, N'F1824', CAST(N'2024-07-27T08:00:00.000' AS DateTime), CAST(N'2024-07-27T17:00:00.000' AS DateTime));

ALTER TABLE `pwm`.`net_BroadcastMessageUser`  ADD  CONSTRAINT `FK_BroadcastMessageUser_BroadcastMessage` FOREIGN KEY (`BroadcastMessageId`)
REFERENCES `pwm`.`net_BroadcastMessage` (`BroadcastMessageId`)
;


ALTER TABLE `pwm`.`net_BroadcastMessageUser`  ADD  CONSTRAINT `FK_BroadcastMessageUser_User` FOREIGN KEY (`UserId`)
REFERENCES `pwm`.`users` (`id`)
;


ALTER TABLE `pwm`.`net_Chain`  ADD  CONSTRAINT `FK_Chain_Task` FOREIGN KEY (`ChainId`)
REFERENCES `pwm`.`net_Tasks` (`TaskId`)
ON UPDATE CASCADE
ON DELETE CASCADE
;


ALTER TABLE `pwm`.`net_CompletedChain`  ADD  CONSTRAINT `FK_CompletedChain_CompletedTask` FOREIGN KEY (`CompletedTaskId`)
REFERENCES `pwm`.`net_CompletedTask` (`CompletedTaskId`)
ON UPDATE CASCADE
ON DELETE CASCADE
;


ALTER TABLE `pwm`.`net_CompletedChain`  ADD  CONSTRAINT `FK_CompletedChain_Tasks` FOREIGN KEY (`ChainId`)
REFERENCES `pwm`.`net_Tasks` (`TaskId`)
;


ALTER TABLE `pwm`.`net_CompletedChain`  ADD  CONSTRAINT `FK_CompletedChain_Tasks1` FOREIGN KEY (`TaskId`)
REFERENCES `pwm`.`net_Tasks` (`TaskId`)
;


ALTER TABLE `pwm`.`net_CompletedTask`  ADD  CONSTRAINT `FK_CompletedTask_GameConfig` FOREIGN KEY (`GameConfigId`)
REFERENCES `pwm`.`net_GameConfig` (`Id`)
;


ALTER TABLE `pwm`.`net_CompletedTask`  ADD  CONSTRAINT `FK_CompletedTask_PairGame` FOREIGN KEY (`PairGameId`)
REFERENCES `pwm`.`net_PairGame` (`PairGameId`)
ON UPDATE CASCADE
ON DELETE CASCADE
;


ALTER TABLE `pwm`.`net_CompletedTask`  ADD  CONSTRAINT `FK_CompletedTask_User` FOREIGN KEY (`PlayerId`)
REFERENCES `pwm`.`users` (`id`)
ON UPDATE CASCADE
ON DELETE CASCADE
;


ALTER TABLE `pwm`.`net_FillText`  ADD  CONSTRAINT `FK_FillText_Language` FOREIGN KEY (`LanguageId`)
REFERENCES `pwm`.`net_Language` (`Id`)
;


ALTER TABLE `pwm`.`net_FillText`  ADD  CONSTRAINT `FK_FillText_Task` FOREIGN KEY (`TaskId`)
REFERENCES `pwm`.`net_Tasks` (`TaskId`)
ON UPDATE CASCADE
ON DELETE CASCADE
;


ALTER TABLE `pwm`.`net_Game`  ADD  CONSTRAINT `FK_Game_GameType` FOREIGN KEY (`Type`)
REFERENCES `pwm`.`net_GameType` (`Id`)
ON UPDATE CASCADE
ON DELETE CASCADE
;


ALTER TABLE `pwm`.`net_GameConfig`  ADD  CONSTRAINT `FK_GameConfig_Game` FOREIGN KEY (`GameId`)
REFERENCES `pwm`.`net_Game` (`GameId`)
ON UPDATE CASCADE
ON DELETE CASCADE
;


ALTER TABLE `pwm`.`net_GameConfig`  ADD  CONSTRAINT `FK_GameConfig_TaskF` FOREIGN KEY (`TaskForF`)
REFERENCES `pwm`.`net_Tasks` (`TaskId`)
;


ALTER TABLE `pwm`.`net_GameConfig`  ADD  CONSTRAINT `FK_GameConfig_TaskM` FOREIGN KEY (`TaskForM`)
REFERENCES `pwm`.`net_Tasks` (`TaskId`)
;


ALTER TABLE `pwm`.`net_Message`  ADD  CONSTRAINT `FK_Message_PlayerPair` FOREIGN KEY (`PairId`)
REFERENCES `pwm`.`net_PlayerPair` (`PlayerPairId`)
;


ALTER TABLE `pwm`.`net_PairGame`  ADD  CONSTRAINT `FK_PairGame_Game` FOREIGN KEY (`GameId`)
REFERENCES `pwm`.`net_Game` (`GameId`)
;


ALTER TABLE `pwm`.`net_PairGame`  ADD  CONSTRAINT `FK_PairGame_PlayerPair` FOREIGN KEY (`PlayerPairId`)
REFERENCES `pwm`.`net_PlayerPair` (`PlayerPairId`)
ON UPDATE CASCADE
ON DELETE CASCADE
;


ALTER TABLE `pwm`.`net_PlayerPair`  ADD  CONSTRAINT `FK_PlayerPair_PairStatus` FOREIGN KEY (`Status`)
REFERENCES `pwm`.`net_PairStatus` (`Id`)
;


ALTER TABLE `pwm`.`net_PlayerPair`  ADD  CONSTRAINT `FK_PlayerPair_UserFemale` FOREIGN KEY (`Player2`)
REFERENCES `pwm`.`users` (`id`)
;


ALTER TABLE `pwm`.`net_PlayerPair`  ADD  CONSTRAINT `FK_PlayerPair_UserMale` FOREIGN KEY (`Player1`)
REFERENCES `pwm`.`users` (`id`)
;


ALTER TABLE `pwm`.`net_Q234`  ADD  CONSTRAINT `FK_Q234_Language` FOREIGN KEY (`LanguageId`)
REFERENCES `pwm`.`net_Language` (`Id`)
;


ALTER TABLE `pwm`.`net_Q234`  ADD  CONSTRAINT `FK_Q234_Task` FOREIGN KEY (`TaskId`)
REFERENCES `pwm`.`net_Tasks` (`TaskId`)
ON UPDATE CASCADE
ON DELETE CASCADE
;


ALTER TABLE `pwm`.`net_TaskAnswer`  ADD  CONSTRAINT `FK_TaskAnswer_TaskAnswer` FOREIGN KEY (`CompletedTaskId`)
REFERENCES `pwm`.`net_CompletedTask` (`CompletedTaskId`)
ON UPDATE CASCADE
ON DELETE CASCADE
;


ALTER TABLE `pwm`.`net_TaskAnswerFeedback`  ADD  CONSTRAINT `FK_TaskAnswerComment_TaskAnswer` FOREIGN KEY (`CompletedTaskId`)
REFERENCES `pwm`.`net_CompletedTask` (`CompletedTaskId`)
ON UPDATE CASCADE
ON DELETE CASCADE
;


ALTER TABLE `pwm`.`net_TaskAnswerFeedback`  ADD  CONSTRAINT `FK_TaskAnswerFeedback_TaskLike` FOREIGN KEY (`LikeTypeId`)
REFERENCES `pwm`.`net_TaskLike` (`Id`)
;


ALTER TABLE `pwm`.`net_TaskAnswerFeedback`  ADD  CONSTRAINT `FK_TaskAnswerFeedback_User` FOREIGN KEY (`PlayerId`)
REFERENCES `pwm`.`users` (`id`)
;


ALTER TABLE `pwm`.`net_TaskMaxStep`  ADD  CONSTRAINT `FK_TaskMaxStep_PlayerPair` FOREIGN KEY (`PlayerPairId`)
REFERENCES `pwm`.`net_PlayerPair` (`PlayerPairId`)
ON UPDATE CASCADE
ON DELETE CASCADE
;


ALTER TABLE `pwm`.`net_TaskMaxStep`  ADD  CONSTRAINT `FK_TaskMaxStep_Task` FOREIGN KEY (`TaskId`)
REFERENCES `pwm`.`net_Tasks` (`TaskId`)
;


ALTER TABLE `pwm`.`net_TaskMaxStep`  ADD  CONSTRAINT `FK_TaskMaxStep_User` FOREIGN KEY (`PlayerId`)
REFERENCES `pwm`.`users` (`id`)
ON UPDATE CASCADE
ON DELETE CASCADE
;


ALTER TABLE `pwm`.`net_TaskNotification`  ADD  CONSTRAINT `FK_TaskNotification_CompletedTask` FOREIGN KEY (`CompletedTaskId`)
REFERENCES `pwm`.`net_CompletedTask` (`CompletedTaskId`)
;


ALTER TABLE `pwm`.`net_TaskNotification`  ADD  CONSTRAINT `FK_TaskNotification_User` FOREIGN KEY (`PlayerToId`)
REFERENCES `pwm`.`users` (`id`)
;


ALTER TABLE `pwm`.`net_TaskNotification`  ADD  CONSTRAINT `FK_TaskNotification_UserFrom` FOREIGN KEY (`PlayerFromId`)
REFERENCES `pwm`.`users` (`id`)
ON UPDATE CASCADE
ON DELETE CASCADE
;


ALTER TABLE `pwm`.`net_Tasks`  ADD  CONSTRAINT `FK_Task_TaskSubSubType` FOREIGN KEY (`SubSubType`)
REFERENCES `pwm`.`net_TaskSubSubType` (`Id`)
;


ALTER TABLE `pwm`.`net_Tasks`  ADD  CONSTRAINT `FK_Task_TaskSubType` FOREIGN KEY (`SubType`)
REFERENCES `pwm`.`net_TaskSubType` (`Id`)
;


ALTER TABLE `pwm`.`net_Tasks`  ADD  CONSTRAINT `FK_Tasks_TaskAuthor` FOREIGN KEY (`Author`)
REFERENCES `pwm`.`net_TaskAuthor` (`Id`)
ON UPDATE CASCADE
ON DELETE CASCADE
;


ALTER TABLE `pwm`.`net_Tasks`  ADD  CONSTRAINT `FK_Tasks_TaskStatus` FOREIGN KEY (`Status`)
REFERENCES `pwm`.`net_TaskStatus` (`Id`)
ON UPDATE CASCADE
ON DELETE CASCADE
;


ALTER TABLE `pwm`.`net_Tasks`  ADD  CONSTRAINT `FK_Tasks_TaskTypes` FOREIGN KEY (`Type`)
REFERENCES `pwm`.`net_TaskType` (`Id`)
ON UPDATE CASCADE
ON DELETE CASCADE
;


ALTER TABLE `pwm`.`net_TaskSubSubType`  ADD  CONSTRAINT `FK_TaskSubSubType_TaskSubType` FOREIGN KEY (`SubType`)
REFERENCES `pwm`.`net_TaskSubType` (`Id`)
ON UPDATE CASCADE
ON DELETE CASCADE
;


ALTER TABLE `pwm`.`net_TaskText`  ADD  CONSTRAINT `FK_TaskText_Images` FOREIGN KEY (`BackgroundImage`)
REFERENCES `pwm`.`net_Image` (`Id`)
ON UPDATE CASCADE
ON DELETE CASCADE
;


ALTER TABLE `pwm`.`net_TaskText`  ADD  CONSTRAINT `FK_TaskText_Languages` FOREIGN KEY (`LanguageId`)
REFERENCES `pwm`.`net_Language` (`Id`)
ON UPDATE CASCADE
ON DELETE CASCADE
;


ALTER TABLE `pwm`.`net_TaskText`  ADD  CONSTRAINT `FK_TaskText_Task` FOREIGN KEY (`TaskId`)
REFERENCES `pwm`.`net_Tasks` (`TaskId`)
ON UPDATE CASCADE
ON DELETE CASCADE
;


ALTER TABLE `pwm`.`net_TimesForTask`  ADD  CONSTRAINT `FK_TimesForTask_Task` FOREIGN KEY (`TaskId`)
REFERENCES `pwm`.`net_Tasks` (`TaskId`)
ON UPDATE CASCADE
ON DELETE CASCADE
;


ALTER TABLE `pwm`.`users`  ADD  CONSTRAINT `FK_User_Areas` FOREIGN KEY (`Area`)
REFERENCES `pwm`.`net_Areas` (`Id`)
;  


ALTER TABLE `pwm`.`users`  ADD  CONSTRAINT `FK_Users_Genders` FOREIGN KEY (`Gender`)
REFERENCES `pwm`.`net_Gender` (`Id`)
ON UPDATE CASCADE
ON DELETE CASCADE
;

-- Table: pwm.identify_role
CREATE TABLE pwm.identify_role (
    Id VARCHAR(128) NOT NULL,
    Name VARCHAR(256) NULL,
    NormalizedName VARCHAR(256) NULL,
    ConcurrencyStamp TEXT NULL,
    PRIMARY KEY (Id)
);

-- Table: pwm.identify_role_claims
CREATE TABLE pwm.identify_role_claims (
    Id INT AUTO_INCREMENT NOT NULL,
    RoleId VARCHAR(128) NOT NULL,
    ClaimType TEXT NULL,
    ClaimValue TEXT NULL,
    PRIMARY KEY (Id),
    CONSTRAINT FK_RoleClaims_Role FOREIGN KEY (RoleId)
    REFERENCES pwm.identify_role (Id) ON DELETE CASCADE
);

-- Table: pwm.identify_user
CREATE TABLE pwm.identify_user (
    Id VARCHAR(128) NOT NULL,
    UserName VARCHAR(256) NULL,
    NormalizedUserName VARCHAR(256) NULL,
    Email VARCHAR(256) NULL,
    NormalizedEmail VARCHAR(256) NULL,
    EmailConfirmed BOOLEAN NOT NULL DEFAULT 0,
    PasswordHash TEXT NULL,
    SecurityStamp TEXT NULL,
    ConcurrencyStamp TEXT NULL,
    PhoneNumber TEXT NULL,
    PhoneNumberConfirmed BOOLEAN NOT NULL DEFAULT 0,
    TwoFactorEnabled BOOLEAN NOT NULL DEFAULT 0,
    LockoutEnd DATETIME NULL,
    LockoutEnabled BOOLEAN NOT NULL DEFAULT 0,
    AccessFailedCount INT NOT NULL DEFAULT 0,
    FirstName TEXT NULL,
    LastName TEXT NULL,
    ProfilePicture LONGBLOB NULL,
    UsernameChangeLimit INT NOT NULL DEFAULT 0,
    PRIMARY KEY (Id)
);

-- Table: pwm.identify_user_claims
CREATE TABLE pwm.identify_user_claims (
    Id INT AUTO_INCREMENT NOT NULL,
    UserId VARCHAR(128) NOT NULL,
    ClaimType TEXT NULL,
    ClaimValue TEXT NULL,
    PRIMARY KEY (Id),
    CONSTRAINT FK_UserClaims_User FOREIGN KEY (UserId)
    REFERENCES pwm.identify_user (Id) ON DELETE CASCADE
);

-- Table: pwm.identify_user_logins
CREATE TABLE pwm.identify_user_logins (
    LoginProvider VARCHAR(128) NOT NULL,
    ProviderKey VARCHAR(128) NOT NULL,
    ProviderDisplayName TEXT NULL,
    UserId VARCHAR(128) NOT NULL,
    PRIMARY KEY (LoginProvider, ProviderKey),
    CONSTRAINT FK_UserLogins_User FOREIGN KEY (UserId)
    REFERENCES pwm.identify_user (Id) ON DELETE CASCADE
);

-- Table: pwm.identify_user_roles
CREATE TABLE pwm.identify_user_roles (
    UserId VARCHAR(128) NOT NULL,
    RoleId VARCHAR(128) NOT NULL,
    PRIMARY KEY (UserId, RoleId),
    CONSTRAINT FK_UserRoles_Role FOREIGN KEY (RoleId)
    REFERENCES pwm.identify_role (Id) ON DELETE CASCADE,
    CONSTRAINT FK_UserRoles_User FOREIGN KEY (UserId)
    REFERENCES pwm.identify_user (Id) ON DELETE CASCADE
);

-- Table: pwm.identify_user_tokens
CREATE TABLE pwm.identify_user_tokens (
    UserId VARCHAR(128) NOT NULL,
    LoginProvider VARCHAR(128) NOT NULL,
    Name VARCHAR(128) NOT NULL,
    Value TEXT NULL,
    PRIMARY KEY (UserId, LoginProvider, Name),
    CONSTRAINT FK_UserTokens_User FOREIGN KEY (UserId)
    REFERENCES pwm.identify_user (Id) ON DELETE CASCADE
); 