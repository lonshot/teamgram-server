-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: mysql:3306
-- Generation Time: Dec 13, 2024 at 01:05 PM
-- Server version: 5.7.44
-- PHP Version: 8.2.8

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `pwm`
--

-- --------------------------------------------------------

--
-- Table structure for table `auths`
--

CREATE TABLE `auths` (
  `id` bigint(20) NOT NULL,
  `auth_key_id` bigint(20) NOT NULL,
  `layer` int(11) NOT NULL DEFAULT '0',
  `api_id` int(11) NOT NULL,
  `device_model` varchar(255) NOT NULL DEFAULT '',
  `system_version` varchar(255) NOT NULL DEFAULT '',
  `app_version` varchar(255) NOT NULL DEFAULT '',
  `system_lang_code` varchar(255) NOT NULL DEFAULT '',
  `lang_pack` varchar(255) NOT NULL DEFAULT '',
  `lang_code` varchar(255) NOT NULL DEFAULT '',
  `system_code` varchar(256) NOT NULL DEFAULT '',
  `proxy` varchar(512) NOT NULL DEFAULT '',
  `params` json NOT NULL,
  `client_ip` varchar(32) NOT NULL DEFAULT '',
  `date_active` bigint(20) NOT NULL DEFAULT '0',
  `deleted` tinyint(1) NOT NULL DEFAULT '0',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `auth_keys`
--

CREATE TABLE `auth_keys` (
  `id` bigint(20) NOT NULL,
  `auth_key_id` bigint(20) NOT NULL,
  `body` varchar(512) NOT NULL,
  `deleted` tinyint(1) NOT NULL DEFAULT '0',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `auth_key_infos`
--

CREATE TABLE `auth_key_infos` (
  `id` bigint(20) NOT NULL,
  `auth_key_id` bigint(20) NOT NULL,
  `auth_key_type` int(11) NOT NULL,
  `perm_auth_key_id` bigint(20) NOT NULL DEFAULT '0',
  `temp_auth_key_id` bigint(20) NOT NULL DEFAULT '0',
  `media_temp_auth_key_id` bigint(20) NOT NULL DEFAULT '0',
  `deleted` tinyint(1) NOT NULL DEFAULT '0',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `auth_seq_updates`
--

CREATE TABLE `auth_seq_updates` (
  `id` bigint(20) NOT NULL,
  `auth_id` bigint(20) NOT NULL,
  `user_id` bigint(20) NOT NULL,
  `seq` int(11) NOT NULL DEFAULT '0',
  `update_type` int(11) NOT NULL DEFAULT '0',
  `update_data` json NOT NULL,
  `date2` bigint(20) NOT NULL DEFAULT '0',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `auth_users`
--

CREATE TABLE `auth_users` (
  `id` bigint(20) NOT NULL,
  `auth_key_id` bigint(20) NOT NULL,
  `user_id` bigint(20) NOT NULL DEFAULT '0',
  `hash` bigint(20) NOT NULL DEFAULT '0',
  `layer` int(11) NOT NULL DEFAULT '0',
  `device_model` varchar(128) NOT NULL DEFAULT '',
  `platform` varchar(64) NOT NULL DEFAULT '',
  `system_version` varchar(64) NOT NULL DEFAULT '',
  `api_id` int(11) NOT NULL DEFAULT '0',
  `app_name` varchar(64) NOT NULL DEFAULT '',
  `app_version` varchar(64) NOT NULL DEFAULT '',
  `date_created` bigint(20) NOT NULL DEFAULT '0',
  `date_actived` bigint(20) NOT NULL DEFAULT '0',
  `ip` varchar(64) NOT NULL DEFAULT '',
  `country` varchar(64) NOT NULL DEFAULT '',
  `region` varchar(64) NOT NULL DEFAULT '',
  `state` int(11) NOT NULL DEFAULT '0',
  `deleted` tinyint(1) NOT NULL DEFAULT '0',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `bots`
--

CREATE TABLE `bots` (
  `id` bigint(20) NOT NULL,
  `bot_id` bigint(20) NOT NULL,
  `bot_type` int(11) NOT NULL DEFAULT '0',
  `creator_user_id` bigint(20) NOT NULL DEFAULT '0',
  `token` varchar(128) NOT NULL DEFAULT '',
  `description` varchar(10240) NOT NULL DEFAULT '',
  `bot_chat_history` tinyint(1) NOT NULL DEFAULT '0',
  `bot_nochats` tinyint(1) NOT NULL DEFAULT '1',
  `verified` tinyint(1) NOT NULL DEFAULT '0',
  `bot_inline_geo` tinyint(1) NOT NULL DEFAULT '0',
  `bot_info_version` int(11) NOT NULL DEFAULT '1',
  `bot_inline_placeholder` varchar(128) NOT NULL DEFAULT '',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `bot_commands`
--

CREATE TABLE `bot_commands` (
  `id` bigint(20) NOT NULL,
  `bot_id` bigint(20) NOT NULL,
  `command` varchar(128) NOT NULL DEFAULT '',
  `description` varchar(10240) NOT NULL DEFAULT '',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `chats`
--

CREATE TABLE `chats` (
  `id` bigint(20) NOT NULL,
  `creator_user_id` bigint(20) NOT NULL,
  `access_hash` bigint(20) NOT NULL,
  `random_id` bigint(20) NOT NULL,
  `participant_count` int(11) NOT NULL,
  `title` varchar(255) NOT NULL,
  `about` varchar(255) NOT NULL DEFAULT '',
  `photo_id` bigint(20) NOT NULL DEFAULT '0',
  `default_banned_rights` bigint(20) NOT NULL DEFAULT '0',
  `migrated_to_id` bigint(20) NOT NULL DEFAULT '0',
  `migrated_to_access_hash` bigint(20) NOT NULL DEFAULT '0',
  `available_reactions_type` int(11) NOT NULL DEFAULT '0',
  `available_reactions` varchar(128) NOT NULL DEFAULT '',
  `deactivated` tinyint(1) NOT NULL DEFAULT '0',
  `noforwards` tinyint(1) NOT NULL DEFAULT '0',
  `ttl_period` int(11) NOT NULL DEFAULT '0',
  `version` int(11) NOT NULL DEFAULT '1',
  `date` bigint(20) NOT NULL DEFAULT '0',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `chat_invites`
--

CREATE TABLE `chat_invites` (
  `id` bigint(20) NOT NULL,
  `chat_id` bigint(20) NOT NULL,
  `admin_id` bigint(20) NOT NULL,
  `migrated_to_id` bigint(20) NOT NULL DEFAULT '0',
  `link` varchar(64) COLLATE utf8mb4_bin NOT NULL,
  `permanent` tinyint(1) NOT NULL DEFAULT '0',
  `revoked` tinyint(1) NOT NULL DEFAULT '0',
  `request_needed` tinyint(1) NOT NULL DEFAULT '0',
  `start_date` bigint(20) NOT NULL DEFAULT '0',
  `expire_date` bigint(20) NOT NULL DEFAULT '0',
  `usage_limit` int(11) NOT NULL DEFAULT '0',
  `usage2` int(11) NOT NULL DEFAULT '0',
  `requested` int(11) NOT NULL DEFAULT '0',
  `title` varchar(64) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `date2` bigint(20) NOT NULL,
  `state` int(11) NOT NULL DEFAULT '0',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

-- --------------------------------------------------------

--
-- Table structure for table `chat_invite_participants`
--

CREATE TABLE `chat_invite_participants` (
  `id` bigint(20) NOT NULL,
  `chat_id` bigint(20) NOT NULL,
  `link` varchar(32) COLLATE utf8mb4_bin NOT NULL,
  `user_id` bigint(20) NOT NULL,
  `date2` bigint(20) NOT NULL,
  `deleted` tinyint(1) NOT NULL DEFAULT '0',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

-- --------------------------------------------------------

--
-- Table structure for table `chat_participants`
--

CREATE TABLE `chat_participants` (
  `id` bigint(20) NOT NULL,
  `chat_id` bigint(20) NOT NULL,
  `user_id` bigint(20) NOT NULL,
  `participant_type` int(11) DEFAULT '0',
  `link` varchar(64) NOT NULL DEFAULT '',
  `usage2` int(11) NOT NULL DEFAULT '0',
  `admin_rights` int(11) NOT NULL DEFAULT '0',
  `inviter_user_id` bigint(20) NOT NULL DEFAULT '0',
  `invited_at` bigint(20) NOT NULL DEFAULT '0',
  `kicked_at` bigint(20) NOT NULL DEFAULT '0',
  `left_at` bigint(20) NOT NULL DEFAULT '0',
  `groupcall_default_join_as_peer_type` int(11) NOT NULL DEFAULT '0',
  `groupcall_default_join_as_peer_id` bigint(20) NOT NULL DEFAULT '0',
  `is_bot` tinyint(1) NOT NULL DEFAULT '0',
  `state` int(11) NOT NULL DEFAULT '0',
  `date2` bigint(20) NOT NULL DEFAULT '0',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `devices`
--

CREATE TABLE `devices` (
  `id` bigint(20) NOT NULL,
  `auth_key_id` bigint(20) NOT NULL,
  `user_id` bigint(20) NOT NULL,
  `token_type` int(11) NOT NULL,
  `token` varchar(512) NOT NULL,
  `no_muted` tinyint(1) NOT NULL DEFAULT '0',
  `locked_period` int(11) NOT NULL DEFAULT '0',
  `app_sandbox` tinyint(1) NOT NULL DEFAULT '0',
  `secret` varchar(1024) NOT NULL DEFAULT '',
  `other_uids` varchar(1024) NOT NULL DEFAULT '',
  `state` tinyint(1) NOT NULL DEFAULT '0',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `dialogs`
--

CREATE TABLE `dialogs` (
  `id` bigint(20) NOT NULL,
  `user_id` bigint(20) NOT NULL,
  `peer_type` int(11) NOT NULL DEFAULT '2',
  `peer_id` bigint(20) NOT NULL,
  `peer_dialog_id` bigint(20) NOT NULL,
  `pinned` bigint(20) NOT NULL DEFAULT '0',
  `top_message` int(11) NOT NULL DEFAULT '0',
  `pinned_msg_id` int(11) NOT NULL DEFAULT '0',
  `read_inbox_max_id` int(11) NOT NULL DEFAULT '0',
  `read_outbox_max_id` int(11) NOT NULL DEFAULT '0',
  `unread_count` int(11) NOT NULL DEFAULT '0',
  `unread_mentions_count` int(11) NOT NULL DEFAULT '0',
  `unread_reactions_count` int(11) NOT NULL DEFAULT '0',
  `unread_mark` tinyint(1) NOT NULL DEFAULT '0',
  `draft_type` int(11) NOT NULL DEFAULT '0',
  `draft_message_data` json NOT NULL,
  `folder_id` int(11) NOT NULL DEFAULT '0',
  `folder_pinned` bigint(20) NOT NULL DEFAULT '0',
  `has_scheduled` tinyint(1) NOT NULL DEFAULT '0',
  `ttl_period` int(11) NOT NULL DEFAULT '0',
  `theme_emoticon` varchar(64) NOT NULL DEFAULT '',
  `date2` bigint(20) NOT NULL,
  `deleted` tinyint(1) NOT NULL DEFAULT '0',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `dialog_filters`
--

CREATE TABLE `dialog_filters` (
  `id` bigint(20) NOT NULL,
  `user_id` bigint(20) NOT NULL,
  `dialog_filter_id` int(11) NOT NULL,
  `is_chatlist` tinyint(1) NOT NULL DEFAULT '0',
  `joined_by_slug` tinyint(1) NOT NULL DEFAULT '0',
  `slug` varchar(128) NOT NULL DEFAULT '',
  `has_my_invites` int(11) NOT NULL DEFAULT '0',
  `dialog_filter` json NOT NULL,
  `order_value` bigint(20) NOT NULL DEFAULT '0',
  `deleted` tinyint(1) NOT NULL DEFAULT '0',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `documents`
--

CREATE TABLE `documents` (
  `id` bigint(20) NOT NULL,
  `document_id` bigint(20) NOT NULL,
  `access_hash` bigint(20) NOT NULL,
  `dc_id` int(11) NOT NULL,
  `file_path` varchar(255) NOT NULL,
  `file_size` bigint(20) NOT NULL,
  `uploaded_file_name` varchar(255) NOT NULL DEFAULT '',
  `ext` varchar(32) NOT NULL DEFAULT '',
  `mime_type` varchar(128) NOT NULL DEFAULT '',
  `thumb_id` bigint(20) NOT NULL DEFAULT '0',
  `video_thumb_id` bigint(20) NOT NULL DEFAULT '0',
  `version` int(11) NOT NULL DEFAULT '0',
  `attributes` json NOT NULL,
  `date2` bigint(20) NOT NULL DEFAULT '0',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `encrypted_files`
--

CREATE TABLE `encrypted_files` (
  `id` bigint(20) NOT NULL,
  `encrypted_file_id` bigint(20) NOT NULL,
  `access_hash` bigint(20) NOT NULL,
  `dc_id` int(11) NOT NULL,
  `file_size` bigint(20) NOT NULL,
  `key_fingerprint` int(11) NOT NULL,
  `md5_checksum` varchar(32) NOT NULL DEFAULT '',
  `file_path` varchar(255) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `hash_tags`
--

CREATE TABLE `hash_tags` (
  `id` bigint(20) NOT NULL,
  `user_id` bigint(20) NOT NULL,
  `peer_type` int(11) NOT NULL,
  `peer_id` bigint(20) NOT NULL,
  `hash_tag` varchar(128) NOT NULL,
  `hash_tag_message_id` int(11) NOT NULL,
  `deleted` tinyint(1) NOT NULL DEFAULT '0',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `identify_role`
--

CREATE TABLE `identify_role` (
  `Id` varchar(128) NOT NULL,
  `Name` varchar(256) DEFAULT NULL,
  `NormalizedName` varchar(256) DEFAULT NULL,
  `ConcurrencyStamp` text
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `identify_role`
--

INSERT INTO `identify_role` (`Id`, `Name`, `NormalizedName`, `ConcurrencyStamp`) VALUES
('3689dea7-cae7-4df8-9cc1-f3c00a9cc28f', 'Admin', 'ADMIN', NULL),
('6d939a0c-6186-459f-9972-c4bdaaa7d1da', 'SuperAdmin', 'SUPERADMIN', NULL),
('7d4e2b11-f7e7-44f5-9e7c-7332bd9d639c', 'Basic', 'BASIC', NULL),
('ee5597cd-10cb-4c3b-89c8-0aa54c9dee76', 'Moderator', 'MODERATOR', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `identify_role_claims`
--

CREATE TABLE `identify_role_claims` (
  `Id` int(11) NOT NULL,
  `RoleId` varchar(128) NOT NULL,
  `ClaimType` text,
  `ClaimValue` text
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `identify_user`
--

CREATE TABLE `identify_user` (
  `Id` varchar(128) NOT NULL,
  `UserName` varchar(256) DEFAULT NULL,
  `NormalizedUserName` varchar(256) DEFAULT NULL,
  `Email` varchar(256) DEFAULT NULL,
  `NormalizedEmail` varchar(256) DEFAULT NULL,
  `EmailConfirmed` tinyint(1) NOT NULL DEFAULT '0',
  `PasswordHash` text,
  `SecurityStamp` text,
  `ConcurrencyStamp` text,
  `PhoneNumber` text,
  `PhoneNumberConfirmed` tinyint(1) NOT NULL DEFAULT '0',
  `TwoFactorEnabled` tinyint(1) NOT NULL DEFAULT '0',
  `LockoutEnd` datetime DEFAULT NULL,
  `LockoutEnabled` tinyint(1) NOT NULL DEFAULT '0',
  `AccessFailedCount` int(11) NOT NULL DEFAULT '0',
  `FirstName` text,
  `LastName` text,
  `ProfilePicture` longblob,
  `UsernameChangeLimit` int(11) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `identify_user`
--

INSERT INTO `identify_user` (`Id`, `UserName`, `NormalizedUserName`, `Email`, `NormalizedEmail`, `EmailConfirmed`, `PasswordHash`, `SecurityStamp`, `ConcurrencyStamp`, `PhoneNumber`, `PhoneNumberConfirmed`, `TwoFactorEnabled`, `LockoutEnd`, `LockoutEnabled`, `AccessFailedCount`, `FirstName`, `LastName`, `ProfilePicture`, `UsernameChangeLimit`) VALUES
('f35d993d-00cf-4214-a199-683232e93f98', 'admin', 'ADMIN', 'pwm-admin@inogrity.com', 'PWM-ADMIN@INOGRITY.COM', 1, 'AQAAAAIAAYagAAAAELwOvJaL2DhccOp4VOLp0S5GHKwzfAym2XB8RgfF/lYeapT2a8CD/d2af551dkfmSQ==', 'ECLYRYZGLH74E7ARTOL6APHRQTLLIY2R', '4babdecd-6602-40a6-9e4c-c3f8d769f681', NULL, 1, 0, NULL, 1, 0, 'Super', 'Admin', NULL, 10);

-- --------------------------------------------------------

--
-- Table structure for table `identify_user_claims`
--

CREATE TABLE `identify_user_claims` (
  `Id` int(11) NOT NULL,
  `UserId` varchar(128) NOT NULL,
  `ClaimType` text,
  `ClaimValue` text
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `identify_user_logins`
--

CREATE TABLE `identify_user_logins` (
  `LoginProvider` varchar(128) NOT NULL,
  `ProviderKey` varchar(128) NOT NULL,
  `ProviderDisplayName` text,
  `UserId` varchar(128) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `identify_user_roles`
--

CREATE TABLE `identify_user_roles` (
  `UserId` varchar(128) NOT NULL,
  `RoleId` varchar(128) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `identify_user_roles`
--

INSERT INTO `identify_user_roles` (`UserId`, `RoleId`) VALUES
('f35d993d-00cf-4214-a199-683232e93f98', '3689dea7-cae7-4df8-9cc1-f3c00a9cc28f'),
('f35d993d-00cf-4214-a199-683232e93f98', '6d939a0c-6186-459f-9972-c4bdaaa7d1da'),
('f35d993d-00cf-4214-a199-683232e93f98', '7d4e2b11-f7e7-44f5-9e7c-7332bd9d639c'),
('f35d993d-00cf-4214-a199-683232e93f98', 'ee5597cd-10cb-4c3b-89c8-0aa54c9dee76');

-- --------------------------------------------------------

--
-- Table structure for table `identify_user_tokens`
--

CREATE TABLE `identify_user_tokens` (
  `UserId` varchar(128) NOT NULL,
  `LoginProvider` varchar(128) NOT NULL,
  `Name` varchar(128) NOT NULL,
  `Value` text
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `imported_contacts`
--

CREATE TABLE `imported_contacts` (
  `id` bigint(20) NOT NULL,
  `user_id` bigint(20) NOT NULL,
  `imported_user_id` bigint(20) NOT NULL,
  `deleted` tinyint(1) NOT NULL DEFAULT '0',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `imported_contacts`
--

INSERT INTO `imported_contacts` (`id`, `user_id`, `imported_user_id`, `deleted`, `created_at`) VALUES
(1, 777000, 777001, 0, '2024-11-12 03:19:20'),
(2, 777001, 777001, 0, '2024-11-12 03:19:20'),
(3, 777002, 777001, 0, '2024-11-12 03:19:20');

-- --------------------------------------------------------

--
-- Table structure for table `messages`
--

CREATE TABLE `messages` (
  `id` bigint(20) NOT NULL,
  `user_id` bigint(20) NOT NULL,
  `user_message_box_id` int(11) NOT NULL,
  `dialog_id1` bigint(20) NOT NULL,
  `dialog_id2` bigint(20) NOT NULL,
  `dialog_message_id` bigint(20) NOT NULL,
  `sender_user_id` bigint(20) NOT NULL,
  `peer_type` int(11) NOT NULL,
  `peer_id` bigint(20) NOT NULL,
  `random_id` bigint(20) NOT NULL DEFAULT '0',
  `message_filter_type` int(11) NOT NULL DEFAULT '0',
  `message_data` json DEFAULT NULL,
  `message` varchar(6000) NOT NULL DEFAULT '',
  `mentioned` tinyint(1) NOT NULL DEFAULT '0',
  `media_unread` tinyint(1) NOT NULL DEFAULT '0',
  `pinned` tinyint(1) NOT NULL DEFAULT '0',
  `has_reaction` tinyint(1) NOT NULL DEFAULT '0',
  `reaction` varchar(16) NOT NULL DEFAULT '',
  `reaction_date` bigint(20) NOT NULL DEFAULT '0',
  `reaction_unread` tinyint(1) NOT NULL DEFAULT '0',
  `date2` bigint(20) NOT NULL DEFAULT '0',
  `ttl_period` int(11) NOT NULL DEFAULT '0',
  `saved_peer_type` int(11) NOT NULL DEFAULT '0',
  `saved_peer_id` bigint(20) NOT NULL DEFAULT '0',
  `deleted` tinyint(1) NOT NULL DEFAULT '0',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `PairId` int(11) DEFAULT NULL,
  `PairGameId` int(11) DEFAULT NULL,
  `SessionId` int(11) DEFAULT NULL,
  `GameConfigId` int(11) DEFAULT NULL,
  `MessageType` int(11) DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `net_areas`
--

CREATE TABLE `net_areas` (
  `Id` int(11) NOT NULL,
  `Area` varchar(200) DEFAULT NULL,
  `Latitude` decimal(9,6) DEFAULT NULL,
  `Longitude` decimal(9,6) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `net_areas`
--

INSERT INTO `net_areas` (`Id`, `Area`, `Latitude`, `Longitude`) VALUES
(1, 'תל אביב', 32.801841, 34.987445),
(2, 'ירושלים', 31.796445, 35.105319),
(3, 'חיפה', 32.799689, 34.981756),
(4, 'באר שבע', 31.261509, 34.755867);

-- --------------------------------------------------------

--
-- Table structure for table `net_brands`
--

CREATE TABLE `net_brands` (
  `Id` int(11) NOT NULL,
  `BrandName` varchar(200) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `net_brands`
--

INSERT INTO `net_brands` (`Id`, `BrandName`) VALUES
(5, 'B1');

-- --------------------------------------------------------

--
-- Table structure for table `net_broadcastmessage`
--

CREATE TABLE `net_broadcastmessage` (
  `BroadcastMessageId` int(11) NOT NULL,
  `CreationTime` datetime NOT NULL,
  `ModificationTime` datetime DEFAULT NULL,
  `StartTime` datetime NOT NULL,
  `ExpirationTime` datetime NOT NULL,
  `HtmlContent` longtext NOT NULL,
  `Title` varchar(256) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `net_broadcastmessageuser`
--

CREATE TABLE `net_broadcastmessageuser` (
  `Id` int(11) NOT NULL,
  `BroadcastMessageId` int(11) DEFAULT NULL,
  `UserId` bigint(20) DEFAULT NULL,
  `UserReceived` datetime DEFAULT NULL,
  `UserConfirmedTimestamp` datetime DEFAULT NULL,
  `Status` varchar(2048) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `net_chain`
--

CREATE TABLE `net_chain` (
  `Id` int(11) NOT NULL,
  `ChainId` varchar(50) NOT NULL,
  `SeqNum` int(11) DEFAULT NULL,
  `TaskId` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `net_completedchain`
--

CREATE TABLE `net_completedchain` (
  `CompletedChainId` int(11) NOT NULL,
  `ChainId` varchar(50) NOT NULL,
  `TaskId` varchar(50) NOT NULL,
  `CompletedTaskId` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `net_completedtask`
--

CREATE TABLE `net_completedtask` (
  `CompletedTaskId` int(11) NOT NULL,
  `PairGameId` int(11) NOT NULL,
  `PlayerId` bigint(20) DEFAULT NULL,
  `Timestamp` datetime DEFAULT NULL,
  `GameConfigId` int(11) DEFAULT NULL,
  `ChainTaskId` varchar(50) DEFAULT NULL,
  `TaskId` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `net_configurabletext`
--

CREATE TABLE `net_configurabletext` (
  `Id` int(11) NOT NULL,
  `Name` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `net_configurabletext`
--

INSERT INTO `net_configurabletext` (`Id`, `Name`) VALUES
(1, 'end_game'),
(2, 'confirm_continue_play'),
(3, 'account_disabled'),
(1003, 'play_now_message'),
(1004, 'guide_invite_friends'),
(1005, 'guide_play_with_partner'),
(1006, 'guide_send_message'),
(1007, 'guide_play'),
(1008, 'guide_play_now_button'),
(1009, 'welcome');

-- --------------------------------------------------------

--
-- Table structure for table `net_country`
--

CREATE TABLE `net_country` (
  `Id` int(11) NOT NULL,
  `Name` varchar(50) DEFAULT NULL,
  `ShortName` varchar(20) DEFAULT NULL,
  `Description` varchar(1024) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `net_filltext`
--

CREATE TABLE `net_filltext` (
  `Id` int(11) NOT NULL,
  `TaskId` varchar(50) NOT NULL,
  `LanguageId` int(11) NOT NULL,
  `TextForM` varchar(2048) DEFAULT NULL,
  `TextForF` varchar(2048) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `net_filltext`
--

INSERT INTO `net_filltext` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES
(1967, 'F1001', 1, 'חשוב לי מה אחרים אומרים עלי `99`, אני מבקר את עצמי יותר מידי `99`, אני מדבר אל עצמי לפעמים `99`', 'חשוב לי מה אחרים אומרים עלי `99`, אני מבקרת את עצמי יותר מידי `99`, אני מדברת אל עצמי לפעמים `99`'),
(1968, 'F1002', 1, 'בשנה האחרונה הרגשתי בודד `99`, שתקתי רוב הזמן `99`, בכיתי הרבה `99`, אכלתי הרבה שוקולד `99`', 'בשנה האחרונה הרגשתי בודדה `99`, שתקתי רוב הזמן `99`, בכיתי הרבה `99`, אכלתי הרבה שוקולד `99`'),
(1969, 'F1003', 1, 'אני מביא שקיות מהבית כדי לא לבזבז שקיות חדשות מהסופרמרקט `99`, אני מדפיס מסמכים משני צידי הנייר במדפסת `99`, אני מתקלח מקלחת קצרה לחסוך במים `99`', 'אני מביאה שקיות מהבית כדי לא לבזבז שקיות חדשות מהסופרמרקט `99`, אני מדפיסה מסמכים משני צידי הנייר במדפסת `99`, אני מתקלחת מקלחת קצרה לחסוך במים `99`'),
(1970, 'F1004', 1, 'כל חודש אני שם כסף בצד `99`, אני יודע בדיוק כמה אני מבזבז בשבוע על מותרת `99`, אני משתדל לקנות בגדים בסיילים ובסופי עונה `99`', 'כל חודש אני שמה כסף בצד `99`, אני יודעת בדיוק כמה אני מבזבזת בשבוע על מותרת `99`, אני משתדלת לקנות בגדים בסיילים ובסופי עונה `99`'),
(1971, 'F1005', 1, 'אני יוזם ומארח אצלי מסיבות מידי פעם `99`, אני עובד על ביזנס משלי `99`, אני זה שיוזם יציאות עם החבר\'ה `99`', 'אני יוזמת ומארחת אצלי מסיבות מידי פעם `99`, אני עובדת על ביזנס משלי `99`, אני זה שיוזמת יציאות עם החבר\'ה `99`'),
(1972, 'F1006', 1, '`999`', '`999`'),
(1973, 'F1007', 1, '`999`', '`999`'),
(1974, 'F1008', 1, '`999`', '`999`'),
(1975, 'F1009', 1, '`999`', '`999`'),
(1976, 'F1010', 1, '`999`', '`999`'),
(1977, 'F1011', 1, '`999`', '`999`'),
(1978, 'F1012', 1, '`999`', '`999`'),
(1979, 'F1014', 1, '`999`', '`999`'),
(1980, 'F1015', 1, '`999`', '`999`'),
(1981, 'F1016', 1, '`999`', '`999`'),
(1982, 'F1017', 1, 'אין לי בעיה לצחצח שיניים במברשת שלה `99`, אין לי בעיה לערבב איתה מנות במסעדה באותו הסכו\"ם `99`, אין לי בעיה אם היא משתעלת על האוכל שלי `99`', 'אין לי בעיה לצחצח שיניים במברשת שלו `99`, אין לי בעיה לערבב איתו מנות במסעדה באותו הסכו\"ם `99`, אין לי בעיה אם הוא משתעל על האוכל שלי `99`'),
(1983, 'F1018', 1, '`999`', '`999`'),
(1984, 'F1022', 1, 'אני ממליץ לך לראות את הסרט `999`, ואת סדרת הטלוויזיה `999`', 'אני ממליצה לך לראות את הסרט `999`, ואת סדרת הטלוויזיה `999`'),
(1985, 'F1023', 1, 'אני ממליץ לך על הפאבבר `999` כי הוא `999`, ועל המסעדה `999` בגלל `999`', 'אני ממליץ לך על הפאבבר `999` כי הוא `999`, ועל המסעדה `999` בגלל `999`'),
(1986, 'F1024', 1, '`999`', '`999`'),
(1987, 'F1025', 1, '`999`', '`999`'),
(1988, 'F1026', 1, '`999`', '`999`'),
(1989, 'F1027', 1, '`999`', '`999`'),
(1990, 'F1029', 1, '`999`', '`999`'),
(1991, 'F1030', 1, '`999`', '`999`'),
(1992, 'F1031', 1, '`999`', '`999`'),
(1993, 'F1032', 1, 'אם יציעו לי אני אשמח להשתתף בתכנית הריאליטי `99`, מעוניין להיות הבמאי של התכנית `99`, ובאקטואליה לשמש כתב לענייני `99`', 'אם יציעו לי אני אשמח להשתתף בתכנית הריאליטי `99`, מעוניינת להיות במאית של התכנית `99`, ובאקטואליה לשמש כתבת לענייני `99`'),
(1994, 'F1033', 1, '`999`', '`999`'),
(1995, 'F1034', 1, '`999`', '`999`'),
(1996, 'F1035', 1, '`999`', '`999`'),
(1997, 'F1036', 1, 'בגד ים צמוד או מכנסי גלישה? `99`, להשתזף על החול או לשחות בים? `99`, חוף מבודד, או חוף מוכרז עם מציל? `99`', 'ביקיני או שלם? `99`, להשתזף על החול או לשחות בים? `99`, חוף מבודד, או חוף מוכרז עם מציל? `99`'),
(1998, 'F1037', 1, '`999`', '`999`'),
(1999, 'F1038', 1, '`999`', '`999`'),
(2000, 'F1039', 1, '`999`', '`999`'),
(2001, 'F1040', 1, 'ליטוף בעורף `99`, נשיקה בצוואר `99`, דגדוג בבטן `99`, לחיצות בכף הרגל `99`', 'ליטוף בעורף `99`, נשיקה בצוואר `99`, דגדוג בבטן `99`, לחיצות בכף הרגל `99`'),
(2002, 'F1041', 1, '`999`', '`999`'),
(2003, 'F1042', 1, 'רקדתי בגשם `99`, חניתי פעם באדום לבן `99`, הייתי מעורב בתאונת דרכים `99`', 'רקדתי בגשם `99`, חניתי פעם באדום לבן `99`, הייתי מעורבת בתאונת דרכים `99`'),
(2004, 'F1043', 1, '`999`', '`999`'),
(2005, 'F1044', 1, '`999`', '`999`'),
(2006, 'F1045', 1, '`999`', '`999`'),
(2007, 'F1046', 1, '`999`', '`999`'),
(2008, 'F1047', 1, 'אני מתגעגע ל`999`', 'אני מתגעגעת ל`999`'),
(2009, 'F1048', 1, '`999`', '`999`'),
(2010, 'F1049', 1, 'להתאהב באמת זה `999`', 'להתאהב באמת זה `999`'),
(2011, 'F1050', 1, '`999`', '`999`'),
(2012, 'F1051', 1, '`999`', '`999`'),
(2013, 'F1052', 1, '`999`', '`999`'),
(2014, 'F1053', 1, 'אני בוחש את הקפה `99` סיבוב השעון, אני מוריד מכנסיים (בישיבה או עמידה) ב`99`, וכשאני מסיים להתקלח אני קודם כל מנגב את ה`99`', 'אני בוחשת את הקפה `99` סיבוב השעון, אני מורידה מכנסיים (בישיבה או עמידה) ב`99`, וכשאני מסיימת להתקלח אני קודם כל מנגבת את ה`99`'),
(2015, 'F1054', 1, 'חמאת בוטנים `99`, דבש `99`, טחינה `99`, ריבה `99`', 'חמאת בוטנים `99`, דבש `99`, טחינה `99`, ריבה `99`'),
(2016, 'F1159', 1, 'בא לי לפנק את עצמי עכשיו ב`99` ', 'בא לי לפנק את עצמי עכשיו ב`99` '),
(2017, 'F1160', 1, 'אף פעם לא יצאתי עם אישה ש`99`', 'אף פעם לא יצאתי עם גבר ש`99`'),
(2018, 'F1161', 1, 'אף פעם לא סיפרתי להורים שלי שאני `99`', 'אף פעם לא סיפרתי להורים שלי שאני `99`'),
(2019, 'F1162', 1, 'בספורט וכושר גופני אני זורם בכיף עד שזה מגיע ל`99`', 'בכושר גופני אני זורמת בכיף עד שזה מגיע ל`99`'),
(2020, 'F1163', 1, 'בטיולים בטבע אני זורם בכיף עד שזה מגיע ל`99`', 'בטיולים בטבע אני זורמת בכיף עד שזה מגיע ל`99`'),
(2021, 'F1164', 1, 'אני אוהב לבלות בחוף הים עד שזה הופך ל`99`', 'אני אוהבת לבלות בחוף הים עד שזה הופך ל`99`'),
(2022, 'F1165', 1, 'אף פעם לא אכלתי `99` אבל דווקא בא לי לנסות.', 'אף פעם לא אכלתי `99` אבל דווקא בא לי לנסות.'),
(2023, 'F1168', 1, '`999`', '`999`'),
(2024, 'F1169', 1, '`999`', '`999`'),
(2025, 'F1170', 1, '`999`', '`999`'),
(2026, 'F1171', 1, '`999`', '`999`'),
(2027, 'F1172', 1, '`999`', '`999`'),
(2028, 'F1173', 1, '`999`', '`999`'),
(2029, 'F1174', 1, '`999`', '`999`'),
(2030, 'F1175', 1, '`999`', '`999`'),
(2031, 'F1176', 1, '`999`', '`999`'),
(2032, 'F1177', 1, '`999`', '`999`'),
(2033, 'F1180', 1, '`999`', '`999`'),
(2034, 'F1182', 1, '`999`', '`999`'),
(2035, 'F1183', 1, '`999`', '`999`'),
(2036, 'F1184', 1, '`999`', '`999`'),
(2037, 'F1190', 1, '`999`', '`999`'),
(2038, 'F1195', 1, '`999`', '`999`'),
(2039, 'F1196', 1, '`999`', '`999`'),
(2040, 'F1197', 1, 'היתה לנו פגישה `99` ומאוד נהניתי אבל לצערי `99`, אז אני מציע ש`999`', 'היתה לנו פגישה `99` ומאוד נהניתי אבל לצערי `99`, אז אני מציע ש`999`'),
(2041, 'F1198', 1, 'רציתי להגיד שיש לך (99) הכי מדהים אהבתי בעיקר את ה(99) הבולט שלך ואת ה(99) השובב שלך ואני אשמח ל(99) אותך.', 'רציתי להגיד שיש לך (99) הכי מדהים אהבתי בעיקר את ה(99) הבולט שלך ואת ה(99) השובב שלך ואני אשמח ל(99) אותך.'),
(2042, 'F1199', 1, 'זה לא מה שאת חושבת. אני בסך הכל (99) והיא בסך הכל (99), ואני והיא בסך הכל (99). ', 'זה לא מה שאתה חושב.  אני בסך הכל (99) והוא בסך הכל (99), (99) ואני והוא בסך הכל (99). '),
(2043, 'F1204', 1, '`999`', '`999`'),
(2044, 'F1205', 1, '`999`', '`999`'),
(2045, 'F1206', 1, 'למנה ראשונה אגיש `99`  למנה עיקרית אכין `99`  לקינוח אגיש `99`  ולשתות אגיש `99`', 'למנה ראשונה אגיש `99`  למנה עיקרית אכין `99`  לקינוח אגיש `99`  ולשתות אגיש `99`'),
(2046, 'F1207', 1, 'לדייט אלבש `99`  כמוסיקת רקע אשים `99`  אחר כך אציע לה לראות ב -VOD את הסרט `99`, ובסוף אציע לה `99`', 'לדייט אלבש `99`  כמוסיקת רקע אשים `99`  אחר כך אציע לו לראות ב -VOD את הסרט `99`, ובסוף אציע לו `99`'),
(2047, 'F1209', 1, '`999`', '`999`'),
(2048, 'F1212', 1, '`999`', '`999`'),
(2049, 'F1213', 1, '`999`', '`999`'),
(2050, 'F1214', 1, 'גובה חשוב לי `9` אחוז, ומשקל חשוב לי `9` אחוז, (ביחד 100%).', 'גובה חשוב לי `9` אחוז, ומשקל חשוב לי `9` אחוז, (ביחד 100%).'),
(2051, 'F1215', 1, 'שנינות חשובה לי `9` אחוז, ונראית טוב חשוב לי `9` אחוז, (ביחד 100%).', 'שכל חשוב לי `9` אחוז, וחיטוב חשוב לי `9` אחוז, (ביחד 100%).'),
(2052, 'F1216', 1, '`999`', '`999`'),
(2053, 'F1217', 1, '`999`', '`999`'),
(2054, 'F1226', 1, 'לאנשים שמתגאים שיש להם אלפי חברים בפייסבוק מגיע `99`, ולאנשים שכל הזמן עסוקים בסמארטפון שלהם באמצע פגישה מגיע `99`', 'לאנשים שמתגאים שיש להם אלפי חברים בפייסבוק מגיע `99`, ולאנשים שכל הזמן עסוקים בסמארטפון שלהם באמצע פגישה מגיע `99`'),
(2055, 'F1227', 1, 'לאנשים שלווים ממך סכום לא גדול ולא מחזירים מגיע `99` ולאנשים שמפרסמים בפייסבוק רק דברים מחמיאים, וכמה שנפלא להם מגיע `99`', 'לאנשים שלווים ממך סכום לא גדול ולא מחזירים מגיע `99` ולאנשים שמפרסמים בפייסבוק רק דברים מחמיאים, וכמה שנפלא להם מגיע `99`'),
(2056, 'F1228', 1, 'לנהג שזורק קופסת סיגריות ריקה מחלון המכונית מגיע `99`, ולנהג שצופר חצי שעה לחבר שלו שיירד, מגיע `99`', 'לנהג שזורק קופסת סיגריות ריקה מחלון המכונית מגיע `99`, ולנהג שצופר חצי שעה לחבר שלו שיירד, מגיע `99`'),
(2057, 'F1229', 1, 'לנהג שחוסם את התנועה בחניה כפולה וכשמעירים לו הוא עונה \"מה אתה ממהר\" מגיע עונש `99`, ולנהג שנוסע לאט באוטוסטרדה במסלול הכי שמאלי מגיע `99`', 'לנהג שחוסם את התנועה בחניה כפולה וכשמעירים לו הוא עונה \"מה אתה ממהר\" מגיע עונש `99`, ולנהג שנוסע לאט באוטוסטרדה במסלול הכי שמאלי מגיע `99`'),
(2058, 'F1230', 1, 'לנהג שחונה בחניית נכה מגיע `99`, ולנהג שנדחף ברגע האחרון ועוקף את כולם בתור בפניה מגיע `99`', 'לנהג שחונה בחניית נכה מגיע `99`, ולנהג שנדחף ברגע האחרון ועוקף את כולם בתור בפניה מגיע `99`'),
(2059, 'F1231', 1, '`999`', '`999`'),
(2060, 'F1232', 1, '`999`', '`999`'),
(2061, 'F1233', 1, '`999`', '`999`'),
(2062, 'F1234', 1, '`999`', '`999`'),
(2063, 'F1235', 1, '`999`', '`999`'),
(2064, 'F1236', 1, '`999`', '`999`'),
(2065, 'F1237', 1, '`99` להכין פסטה ברוטב עגבניות  `99` להכין סטייק או שיפוד  `99` לטגן שניצל. ', '`99` להכין פסטה ברוטב עגבניות  `99` להכין סטייק או שיפוד  `99` לטגן שניצל. '),
(2066, 'F1238', 1, '`99` לאפות עוגה טעימה  `99` לפנק בסלט פירות מגניב  `99` להכין טירמיסו', '`99` לאפות עוגה טעימה  `99` לפנק בסלט פירות מגניב  `99` להכין טירמיסו'),
(2067, 'F1239', 1, '`99` להכין מרק עדשים  `99` לטגן כרוביות  `99` להכין שקשוקה מהממת', '`99` להכין מרק עדשים  `99` לטגן כרוביות  `99` להכין שקשוקה מהממת'),
(2068, 'F1240', 1, '`999`', '`999`'),
(2069, 'F1241', 1, '`999`', '`999`'),
(2070, 'F1242', 1, '`999`', '`999`'),
(2071, 'F1243', 1, '`999`', '`999`'),
(2072, 'F1244', 1, '`999`', '`999`'),
(2073, 'F1245', 1, 'את כל הזמן רואה `99` ואת כל הזמן שופכת עלי `99` ומשגעת אותי עם ה`99` שלך', 'אתה כל הזמן רואה `99` ואתה כל הזמן שופך עלי `99` ומשגע אותי עם ה`99` שלך'),
(2074, 'F1246', 1, '`999`', '`999`'),
(2075, 'F1247', 1, '`999`', '`999`'),
(2076, 'F1248', 1, 'הי. בדיוק נזכרתי ש`99` ואני במקרה כאן עם ה`99` שלי. מתאים לך ש`99`?', 'הי. בדיוק נזכרתי ש`99` ואני במקרה כאן עם ה`99` שלי. מתאים לך ש`99`?'),
(2077, 'F1249', 1, '`999`', '`999`'),
(2078, 'F1250', 1, '`999`', '`999`'),
(2079, 'F1251', 1, '`999`', '`999`'),
(2080, 'F1252', 1, '`999`', '`999`'),
(2081, 'F1253', 1, '`999`', '`999`'),
(2082, 'F1254', 1, '`999`', '`999`'),
(2083, 'F1255', 1, '`999`', '`999`'),
(2084, 'F1256', 1, '`999`', '`999`'),
(2085, 'F1257', 1, '`999`', '`999`'),
(2086, 'F1258', 1, '`999`', '`999`'),
(2087, 'F1259', 1, '`999`', '`999`'),
(2088, 'F1260', 1, '`999`', '`999`'),
(2089, 'F1261', 1, '`999`', '`999`'),
(2090, 'F1262', 1, '`999`', '`999`'),
(2091, 'F1263', 1, '`999`', '`999`'),
(2092, 'F1264', 1, '`999`', '`999`'),
(2093, 'F1265', 1, '`999`', '`999`'),
(2094, 'F1266', 1, '`999`', '`999`'),
(2095, 'F1267', 1, 'דרג את איכות הדייט עם מילים כמו \"מעולה  גרוע  סביר -  לצאת להופעה ביחד `99`, לנקות דירה ביחד `99`, לעשות כושר בפארק ביחד `99`', 'דרגי את איכות הדייט עם מילים כמו \"מעולה  גרוע  סביר - לצאת להופעה ביחד `99`, לנקות דירה ביחד `99`, לעשות כושר בפארק ביחד `99`'),
(2096, 'F1268', 1, '`999`', '`999`'),
(2097, 'F1269', 1, '`999`', '`999`'),
(2098, 'F1270', 1, '`999`', '`999`'),
(2099, 'F1271', 1, '`999`', '`999`'),
(2100, 'F1272', 1, '`999`', '`999`'),
(2101, 'F1273', 1, '`999`', '`999`'),
(2102, 'F1274', 1, '`999`', '`999`'),
(2103, 'F1275', 1, '`999`', '`999`'),
(2104, 'F1276', 1, '`999`', '`999`'),
(2105, 'F1277', 1, '`999`', '`999`'),
(2106, 'F1278', 1, '`999`', '`999`'),
(2107, 'F1279', 1, '`999`', '`999`'),
(2108, 'F1280', 1, '`999`', '`999`'),
(2109, 'F1281', 1, '`999`', '`999`'),
(2110, 'F1282', 1, '`999`', '`999`'),
(2111, 'F1283', 1, '`999`', '`999`'),
(2112, 'F1284', 1, '`999`', '`999`'),
(2113, 'F1285', 1, 'דרג את איכות הדייט עם מילים כמו \"מעולה  גרוע  סביר - לצאת לפאב `99`, בית קפה `99`, ספסל בפארק `99`, סרט קולנוע `99`', 'דרגי את איכות הדייט עם מילים כמו \"מעולה  גרוע  סביר - לצאת לפאב `99`, בית קפה `99`, ספסל בפארק `99`, סרט קולנוע `99`'),
(2114, 'F1286', 1, '`999`', '`999`'),
(2115, 'F1287', 1, '`999`', '`999`'),
(2116, 'F1288', 1, '`999`', '`999`'),
(2117, 'F1289', 1, '`999`', '`999`'),
(2118, 'F1290', 1, 'נמאס לי שאת תמיד `200` ואת אף פעם לא `200` ', 'נמאס לי שאתה תמיד `999` ואתה אף פעם לא `999` '),
(2119, 'F1291', 1, '`999`', '`999`'),
(2120, 'F1292', 1, 'מעדיף להיות הכי חכמה `9` אחוז, הכי חטוב `9` אחוז, הכי מפורסם `9` (ביחד 100%).', 'מעדיפה להיות הכי חכמה `9` אחוז, הכי חטובה `9` אחוז, הכי מפורסמת `9` (ביחד 100%).'),
(2121, 'F1293', 1, '`999`', '`999`'),
(2122, 'F1294', 1, '`999`', '`999`'),
(2123, 'F1295', 1, 'לראות סרט באולם קולנוע לבד זה `99`, לטייל בחוץ לארץ לבד זה `99`, ללמוד לבחינות לבד זה `99`', 'לראות סרט באולם קולנוע לבד זה `99`, לטייל בחוץ לארץ לבד זה `99`, ללמוד לבחינות לבד זה `99`'),
(2124, 'F1297', 1, 'השלם את החסר רק במילים כן או לא. אני `30` יודע להכין חביתה, אני `30` יודע להכין עוף בתנור, אני `30` יודע להכין ירקות מוקפצים, אני `30` יודע להכין קוקטיילים מגניבים.', 'השלימי את החסר רק בכן או לא. אני `30` יודעת להכין חביתה, אני `30` יודעת להכין עוף בתנור, אני `30` יודעת להכין ירקות מוקפצים, אני `30` יודעת להכין קוקטיילים מגניבים.'),
(2125, 'F1298', 1, 'השלם את החסר רק במילים כן או לא. אני `30` יודע להכין עוגת דבש, אני `30` יודע להכין סלט פירות, אני `30` יודע להכין טירמיסו, אני `30` יודע להכין פנקייק.', 'השלימי את החסר רק בכן או לא. אני `30` יודעת להכין עוגת דבש, אני `30` יודעת להכין סלט פירות, אני `30` יודעת להכין טירמיסו, אני `30` יודעת להכין פנקייק.'),
(2126, 'F1299', 1, 'השלם את החסר רק במילים כן או לא. אני `30` יודע להכין שיפודים במנגל, אני `30` יודע להכין מרק ירקות, אני `30` יודע להכין טוסט, אני `30` יודע להכין שניצל.', 'השלימי את החסר רק בכן או לא. אני `30` יודעת להכין חביתה, אני `30` יודעת להכין עוף בתנור, אני `30` יודעת להכין ירקות מוקפצים, אני `30` יודעת להכין קוקטיילים מגניבים.'),
(2127, 'F1300', 1, '`999`', '`999`'),
(2128, 'F1302', 1, '`999`', '`999`'),
(2129, 'F1304', 1, '`999`', '`999`'),
(2130, 'F1305', 1, '`999`', '`999`'),
(2131, 'F1307', 1, '`999`', '`999`'),
(2132, 'F1308', 1, '`999`', '`999`'),
(2133, 'F1309', 1, '`999`', '`999`'),
(2134, 'F1310', 1, '`999`', '`999`'),
(2135, 'F1311', 1, '`999`', '`999`'),
(2136, 'F1312', 1, 'אני אוהב מיץ תפוחים `99`, מיץ אשכוליות `99`, קולה `99`, סודה `99`, ג\'ין טוניק `99`', 'אני אוהבת מיץ תפוחים `99`, מיץ אשכוליות `99`, קולה `99`, סודה `99`, ג\'ין טוניק `99`'),
(2137, 'F1313', 1, 'בדרך כלל בבקרים אני `99` אבל לעומת זאת בלילות אני `99`', 'בדרך כלל בבקרים אני `99` אבל לעומת זאת בלילות אני `99`'),
(2138, 'F1314', 1, 'תכיני לי בבקשה `99`, `99` סוכר, ו`99` חלב', 'תכין לי בבקשה `99`, `99` סוכר, ו`99` חלב'),
(2139, 'F1315', 1, 'אם אני שומע את הזמרת `99` אני תולש את השערות כאן ועכשיו! ', 'אם אני שומעת את הזמרת `99` אני תולשת את השערות כאן ועכשיו! '),
(2140, 'F1316', 1, '`999`', '`999`'),
(2141, 'F1317', 1, 'הנשיקה הראשונה שלי היתה בגיל `99`, זה קרה ב`99` וזה היה עם `99`', 'הנשיקה הראשונה שלי היתה בגיל `99`, זה קרה ב`99` וזה היה עם `99`'),
(2142, 'F1318', 1, 'המסעדה הכי טובה שאכלתי בה אי פעם היא `99`, ואכלתי שם `99`', 'המסעדה הכי טובה שאכלתי בה אי פעם היא `99`, ואכלתי שם `99`'),
(2143, 'F1321', 1, '`999`', '`999`'),
(2144, 'F1322', 1, '`999`', '`999`'),
(2145, 'F1323', 1, '`999`', '`999`'),
(2146, 'F1324', 1, '`999`', '`999`'),
(2147, 'F1325', 1, '`999`', '`999`'),
(2148, 'F1326', 1, '`999`', '`999`'),
(2149, 'F1327', 1, 'בטיסה אני אוהב לשבת ליד ה`99` (חלון או מעבר), ואני מעביר את הזמן ב`99`', 'בטיסה אני אוהבת לשבת ליד ה`99` (חלון או מעבר), ואני מעבירה את הזמן ב`99`'),
(2150, 'F1328', 1, 'כשאני רוצה לקרוא חדשות, אני בדרך כלל גולש באתר `99`, וחוץ מזה אני אוהב לגלוש באתר `99`', 'כשאני רוצה לקרוא חדשות, אני בדרך כלל גולשת באתר `99`, וחוץ מזה אני אוהבת לגלוש באתר `99`'),
(2151, 'F1329', 1, 'אתמול היה לי יום `200`, ומחר אני מרגיש שהולך להיות `200`', 'אתמול היה לי יום `200`, ומחר אני מרגישה שהולך להיות `200`'),
(2152, 'F1330', 1, '`999`', '`999`'),
(2153, 'F1331', 1, 'בקיץ בחוף הים, אני בדרך כלל מבלה את הזמן ב`99`, ואני אוהב להישאר שם `99` ', 'בקיץ בחוף הים, אני בדרך כלל מבלה את הזמן ב`99`, ואני אוהבת להישאר שם `99`  '),
(2154, 'F1332', 1, '`999`', '`999`'),
(2155, 'F1333', 1, '`999`', '`999`'),
(2156, 'F1334', 1, '`999`', '`999`'),
(2157, 'F1335', 1, '`999`', '`999`'),
(2158, 'F1336', 1, '`999`', '`999`'),
(2159, 'F1337', 1, '`999`', '`999`'),
(2160, 'F1338', 1, '`999`', '`999`'),
(2161, 'F1339', 1, 'אם היתה אולימפיאדה בענף `99`, אני בוודאות יכול להתחרות שם בכבוד', 'אם היתה אולימפיאדה בענף `99`, אני בוודאות יכולה להתחרות שם בכבוד'),
(2162, 'F1340', 1, 'הציון הכי גבוה שקיבלתי בחיי הוא `99` במקצוע `99`, והציון הכי נמוך הוא `99` במקצוע `99` ', 'הציון הכי גבוה שקיבלתי בחיי הוא `99` במקצוע `99`, והציון הכי נמוך הוא `99` במקצוע `99` '),
(2163, 'F1341', 1, '`999`', '`999`'),
(2164, 'F1342', 1, 'אני חושב שהרכבת פאזלים זה `99` ואני ממש `99` בזה', 'אני חושבת שהרכבת פאזלים מרובי חלקים זה `99` ואני ממש `99` בזה'),
(2165, 'F1343', 1, '`999`', '`999`'),
(2166, 'F1344', 1, '`999`', '`999`'),
(2167, 'F1345', 1, '`999`', '`999`'),
(2168, 'F1346', 1, '`999`', '`999`'),
(2169, 'F1347', 1, '`999`', '`999`'),
(2170, 'F1348', 1, '`999`', '`999`'),
(2171, 'F1349', 1, '`999`', '`999`'),
(2172, 'F1350', 1, '`999`', '`999`'),
(2173, 'F1351', 1, 'חשוב לי שהחברה שלי תרגש אותי `99`, חשוב לי שהיא תצחיק אותי `99`, חשוב לי שהיא תפנק אותי `99`', 'חשוב לי שהחבר שלי ירגש אותי `99`, חשוב לי שהוא יצחיק אותי `99`, חשוב לי שהוא יפנק אותי `99`'),
(2174, 'F1352', 1, '`999`', '`999`'),
(2175, 'F1353', 1, '`999`', '`999`'),
(2176, 'F1354', 1, '`999`', '`999`'),
(2177, 'F1355', 1, '`999`', '`999`'),
(2178, 'F1356', 1, '`999`', '`999`'),
(2179, 'F1357', 1, '`999`', '`999`'),
(2180, 'F1358', 1, '`999`', '`999`'),
(2181, 'F1359', 1, '`99` אתחתן עם מישהי שרוצה להיות פרופסורית למתמטיקה, {99` שאתחתן עם מישהי שרוצה להיות פוליטיקאית,', '`99` שאתחתן עם מישהו שרוצה להיות פרופסור למתמטיקה, {99` שאתחתן עם מישהי שרוצה להיות פוליטיקאי,'),
(2182, 'F1360', 1, '`999`', '`999`'),
(2183, 'F1361', 1, '`99` שאתחתן עם עורכת דין, `99` שאתחתן עם מישהי שרוצה להתנדב באפריקה', '`99` שאתחתן עם עורך דין, `99` שאתחתן עם מישהו שרוצה להתנדב באפריקה'),
(2184, 'F1362', 1, 'ספר או סרט - `99`, חומוסיה או איטלקית - `99`, מזרחית או רוקנ\'רול - `99`', 'ספר או סרט - `99`, חומוסיה או איטלקית - `99`, מזרחית או רוקנ\'רול - `99`'),
(2185, 'F1363', 1, 'שיר לועזי או עברי - `99`, הפוך או אספרסו - `99`, אופניים חשמליים או רגילים - `99`', 'שיר לועזי או עברי - `99`, הפוך או אספרסו - `99`, אופניים חשמליים או רגילים `99`'),
(2186, 'F1364', 1, 'לישון בפיג\'מה או בעירום - `99`, רגליים ארוכות או חיוך מקסים - `99`, קומדיה רומנטית או סרט אקשן - `99`', 'לישון בפיג\'מה או בעירום - `99`, רגליים ארוכות או חיוך מקסים - `99`, קומדיה רומנטית או סרט אקשן - `99`'),
(2187, 'F1369', 1, '`999`', '`999`'),
(2188, 'F1370', 1, 'אני לובש עכשיו חולצה בצבע `99`, מכנסיים בצבע `99` ותחתונים בצבע `099`', 'אני לובשת עכשיו חולצה בצבע `99`, מכנסיים בצבע `99` ותחתונים בצבע `099`'),
(2189, 'F1371', 1, '`999`', '`999`'),
(2190, 'F1372', 1, '`999`', '`999`'),
(2191, 'F1373', 1, '`999`', '`999`'),
(2192, 'F1374', 1, '`999`', '`999`'),
(2193, 'F1376', 1, 'אם הבוס שלי יבקש ממני `99`, אין סיכוי בעולם שאסכים. ', 'אם הבוס שלי יבקש ממני `99`, אין סיכוי בעולם שאסכים. '),
(2194, 'F1377', 1, '`999`', '`999`'),
(2195, 'F1378', 1, '`999`', '`999`'),
(2196, 'F1379', 1, '`999`', '`999`'),
(2197, 'F1380', 1, '`999`', '`999`'),
(2198, 'F1381', 1, '`999`', '`999`'),
(2199, 'F1382', 1, '`999`', '`999`'),
(2200, 'F1383', 1, '`999`', '`999`'),
(2201, 'F1384', 1, '`99` בוקסר רחבים, `99` בוקסר צמודים, `99` טנגה, ויש לי גם `99`', '`99` חוטיני, `99` גזרה גבוהה, `99` גזרה נמוכה, `99` מקסי, `99` בייבידול, ויש לי גם `99`'),
(2202, 'F1385', 1, '`999`', '`999`'),
(2203, 'F1386', 1, 'מכונית ספורט `99`, קרם פנים `99`, מכשיר סלולרי `99`, רמקולים איכותיים `99`, כנות `99`', 'מכונית ספורט `99`, קרם פנים `99`, מכשיר סלולרי `99`, רמקולים איכותיים `99`, כנות `99`'),
(2204, 'F1387', 1, '`999`', '`999`'),
(2205, 'F1388', 1, '`999`', '`999`'),
(2206, 'F1389', 1, '`999`', '`999`'),
(2207, 'F1390', 1, '`999`', '`999`'),
(2208, 'F1391', 1, '`999`', '`999`'),
(2209, 'F1392', 1, '`999`', '`999`'),
(2210, 'F1393', 1, '`999`', '`999`'),
(2211, 'F1394', 1, '`999`', '`999`'),
(2212, 'F1395', 1, '`999`', '`999`'),
(2213, 'F1396', 1, '`999`', '`999`'),
(2214, 'F1397', 1, '`999`', '`999`'),
(2215, 'F1398', 1, '`999`', '`999`'),
(2216, 'F1399', 1, '`999`', '`999`'),
(2217, 'F1400', 1, '`999`', '`999`'),
(2218, 'F1403', 1, '`999`', '`999`'),
(2219, 'F1404', 1, '`999`', '`999`'),
(2220, 'F1405', 1, '`999`', '`999`'),
(2221, 'F1406', 1, '`999`', '`999`'),
(2222, 'F1407', 1, '`999`', '`999`'),
(2223, 'F1408', 1, '`999`', '`999`'),
(2224, 'F1409', 1, '`999`', '`999`'),
(2225, 'F1410', 1, '`999`', '`999`'),
(2226, 'F1411', 1, '`999`', '`999`'),
(2227, 'F1415', 1, '`999`', '`999`'),
(2228, 'F1416', 1, '`999`', '`999`'),
(2229, 'F1417', 1, '`999`', '`999`'),
(2230, 'F1418', 1, '`999`', '`999`'),
(2231, 'F1419', 1, 'הלוואי ויכולתי לחלוק `99` עם מישהי עכשיו', 'הלוואי ויכולתי לחלוק `99` עם מישהו עכשיו'),
(2232, 'F1420', 1, 'שלום, אני `99`. אני `999` ובנוסף `999`', 'שלום, אני `99`. אני `999` ובנוסף `999`'),
(2233, 'F1421', 1, 'היי, אני `99` ואני `999` וגם `999` ', 'היי, אני `99` ואני `999` וגם `999` '),
(2234, 'F1422', 1, '`999`', '`999`'),
(2235, 'F1423', 1, '`999`', '`999`'),
(2236, 'F1424', 1, '`999`', '`999`'),
(2237, 'F1425', 1, '`999`', '`999`'),
(2238, 'F1426', 1, '`999`', '`999`'),
(2239, 'F1427', 1, '`999`', '`999`'),
(2240, 'F1428', 1, '`999`', '`999`'),
(2241, 'F1429', 1, '`999`', '`999`'),
(2242, 'F1431', 1, '`999`', '`999`'),
(2243, 'F1432', 1, '`999`', '`999`'),
(2244, 'F1433', 1, '`999`', '`999`'),
(2245, 'F1434', 1, '`999`', '`999`'),
(2246, 'F1435', 1, '`999`', '`999`'),
(2247, 'F1436', 1, '`999`', '`999`'),
(2248, 'F1437', 1, '`999`', '`999`'),
(2249, 'F1438', 1, '`999`', '`999`'),
(2250, 'F1439', 1, '`999`', '`999`'),
(2251, 'F1440', 1, '`999`', '`999`'),
(2252, 'F1441', 1, '`999`', '`999`'),
(2253, 'F1442', 1, '`999`', '`999`'),
(2254, 'F1443', 1, '`999`', '`999`'),
(2255, 'F1444', 1, '`999`', '`999`'),
(2256, 'F1445', 1, '`999`', '`999`'),
(2257, 'F1446', 1, '`999`', '`999`'),
(2258, 'F1448', 1, '`999`', '`999`'),
(2259, 'F1449', 1, '`999`', '`999`'),
(2260, 'F1456', 1, '`999`', '`999`'),
(2261, 'F1457', 1, '`999`', '`999`'),
(2262, 'F1459', 1, '`999`', '`999`'),
(2263, 'F1460', 1, 'החולצה היפה הלבנה נצבעה בכביסה `99`, הכתימו לי את החולצה הלבנה ביין אדום `99`, מכונית השפריצה עלי כשעברתי ליד שלולית', 'החולצה היפה הלבנה נצבעה בכביסה `99`, הכתימו לי את החולצה הלבנה ביין אדום `99`, מכונית השפריצה עלי כשעברתי ליד שלולית'),
(2264, 'F1461', 1, '`999`', '`999`'),
(2265, 'F1462', 1, 'התפשטתי ואז גיליתי שאין מים חמים במקלחת `99`, סיימתי את כל ההכנות לבישול אבל בדיוק נגמר הגז `99`, מילאתי עגלה בסופר, ואז ראיתי ששכחתי את הארנק בבית', 'התפשטתי ואז גיליתי שאין מים חמים במקלחת `99`, סיימתי את כל ההכנות לבישול אבל בדיוק נגמר הגז `99`, מילאתי עגלה בסופר, ואז ראיתי ששכחתי את הארנק בבית'),
(2266, 'F1463', 1, 'ננעלת פעם מחוץ לבית? `99`, יוצא לך מידי פעם לשכוח איפה שמת את הטלפון? `99`, יצא לך ששכחת משהו מתבשל על הגז וזה נשרף? `99`', 'ננעלת פעם מחוץ לבית? `99`, יוצא לך מידי פעם לשכוח איפה שמת את הטלפון? `99`, יצא לך ששכחת משהו מתבשל על הגז וזה נשרף? `99`'),
(2267, 'F1464', 1, 'לראות טלוויזיה או להקשיב למוסיקה? `99`, חופשה בהרים או חופשה על החוף? `99` להיות רואה ואינו נראה, או קורא מחשבות? `99`', 'לראות טלוויזיה או להקשיב למוסיקה? `99`, חופשה בהרים או חופשה על החוף? `99` להיות רואה ואינו נראה, או קורא מחשבות? `99`'),
(2268, 'F1465', 1, 'בחור קרח או עם שערות בגב ובכתפיים? `99`, בחור נמוך ומצחיק או גבוה ויבשוש? `99`, מוות בטביעה או מוות בתליה?', 'בחורה מגולחת לגמרי, או נטורל? `99`, בחורה נמוכה ומצחיקה או גבוהה ויבשושה? `99`, מוות בטביעה או מוות בתליה?'),
(2269, 'F1466', 1, '`999`', '`999`'),
(2270, 'F1468', 1, '`999`', '`999`'),
(2271, 'F1469', 1, '`999`', '`999`'),
(2272, 'F1470', 1, '`999`', '`999`'),
(2273, 'F1471', 1, '`999`', '`999`'),
(2274, 'F1472', 1, '`999`', '`999`'),
(2275, 'F1473', 1, '`999`', '`999`'),
(2276, 'F1474', 1, '`999`', '`999`'),
(2277, 'F1475', 1, 'שוקולד או תותים? `99`, לדבר או להקשיב? `99`, אחרי העבודה, הליכה רגועה, או ריצה `99`', 'שוקולד או תותים? `99`, לדבר או להקשיב? `99`, אחרי העבודה, הליכה רגועה, או ריצה `99`'),
(2278, 'F1476', 1, 'לראות הצגה או משחק כדורגל? `99`, לרוץ או ללכת? `99`, טלוויזיה או קולנוע? `99` ', 'לראות הצגה או משחק כדורגל? `99`, לרוץ או ללכת? `99`,  טלוויזיה או קולנוע? `99`'),
(2279, 'F1477', 1, 'לעצב מכונית או לעצב בית? `99`, לגור בתל אביב או בגליל? `99`, לתכנן טיול מראש, או ספונטני? `99`', 'לעצב מכונית או לעצב בית? `99`, לגור בתל אביב או בגליל? `99`, לתכנן טיול מראש, או ספונטני? `99`'),
(2280, 'F1478', 1, 'בוקר או לילה? `99`, טיול אוהלים במדבר או מלון ספא באילת? `99`, אפל או אנדרואיד? `99`', 'בוקר או לילה? `99`, טיול אוהלים במדבר או מלון ספא באילת? `99`, אפל או אנדרואיד? `99`'),
(2281, 'F1479', 1, 'לוס אנג\'לס `99`, סניף של H&M `99`, סניף של איקאה `99`', 'לוס אנג\'לס `99`, סניף של H&M `99`, סניף של איקאה `99`'),
(2282, 'F1480', 1, 'טיפול פסיכולוגי `99`, טיפול כירופרקטי `99`, טיפול קוסמטי `99`', 'טיפול פסיכולוגי `99`, טיפול כירופרקטי `99`, טיפול קוסמטי `99`'),
(2283, 'F1481', 1, 'נגינה בכלי כלשהו `99`, סדר וניקיון `99`, ארגון ותכנון `99`', 'נגינה בכלי כלשהו `99`, סדר וניקיון `99`, ארגון ותכנון `99`'),
(2284, 'F1482', 1, 'ניהול מו\"מ להוריד מחיר של רכב משומש`99`, פירוק והרכבה של מכשירים חשמליים `99`, התנהלות פיננסית נכונה `99`, ', 'ניהול מו\"מ להוריד מחיר של רכב משומש`99`, פירוק והרכבה של מכשירים חשמליים `99`, התנהלות פיננסית נכונה `99`, '),
(2285, 'F1483', 1, 'שירה `99`, בישול `99`, עיצוב גרפי `99`', 'שירה `99`, בישול `99`, עיצוב גרפי `99`'),
(2286, 'F1484', 1, 'להיות טיפ טופ בלבוש `99`, לרקוד ואלס `99`, להבין בקוקטיילים אלכוהולים `99`', 'להיות טיפ טופ בלבוש `99`, לרקוד ואלס `99`, להבין בקוקטיילים אלכוהולים `99`'),
(2287, 'F1485', 1, '`999`', '`999`'),
(2288, 'F1487', 1, '`999`', '`999`'),
(2289, 'F1488', 1, 'הכי חשוב `99`, אחר כך `99` ובסוף `99`', 'הכי חשוב `99`, אחר כך `99` ובסוף `99`'),
(2290, 'F1489', 1, '`999`', '`999`'),
(2291, 'F1490', 1, '`999`', '`999`'),
(2292, 'F1491', 1, '`999`', '`999`'),
(2293, 'F1492', 1, 'כשאני פוגש מישהי חדשה `99` חשובה ההופעה שלה, `99` חשובה לי האישיות שלה, `99` חשוב לי החיוך שלה', 'כשאני פוגשת מישהו חדש, `99` חשובה לי הופעה שלו, `99` חשובה לי האישיות שלו, `99` חשוב לי החיוך שלו'),
(2294, 'F1493', 1, '`999`', '`999`'),
(2295, 'F1494', 1, 'סיאנסים (העלאת המתים) `99`, קלפי טארוט `99`, נומרולוגיה `99`', 'סיאנסים (העלאת המתים) `99`, קלפי טארוט `99`, נומרולוגיה `99`'),
(2296, 'F1495', 1, '`999`', '`999`'),
(2297, 'F1496', 1, 'החברים שלך אומרים שאתה כריזמטי - `99`, שאתה אינטלגנטי - `99`, שאתה עפיפון - `99`', 'החברים שלך אומרים שאת כריזמטית - `99`, שאת אינטלגנטית - `99`, שאת עפיפון - `99`'),
(2298, 'F1497', 1, 'החברים שלך אומרים שאתה כיפי - `99`, שאתה נחוש והחלטי - `99`, שאתה פצצת אנרגיה - `99`', 'החברים שלך אומרים שאת כיפית - `99`, שאת נחושת והחלטית - `99`, שאת פצצת אנרגיה - `99`'),
(2299, 'F1498', 1, 'החברים שלך אומרים שאתה מצחיק - `99`, שאתה יצירתי - `99`, שאתה מתלבש טיפ טופ - `99`', 'החברים שלך אומרים שאת מצחיקה - `99`, שאת יצירתית - `99`, שאת מתלבשת טיפ טופ - `99`'),
(2300, 'F1499', 1, 'החברים שלך אומרים שאתה יודע לפתור כל בעיה - `99`, שאתה שמח ומאושר - `99`, שאתה מלא ברוגע בשלווה - `99`', 'החברים שלך אומרים שאת יודעת לפתור כל בעיה - `99`, שאת שמחה ומאושרת - `99`, שאת מלאה ברוגע בשלווה - `99`'),
(2301, 'F1500', 1, 'החברים שלך אומרים שיש בך צד מסתורי ומוזר - `99`, שיש לך ביטחון עצמי - `99`, שאתה בהחלט יודע ליהנות ולבלות - `99`', 'החברים שלך אומרים שיש בך צד מסתורי ומוזר - `99`, שיש לך ביטחון עצמי - `99`, שאת בהחלט יודעת ליהנות ולבלות - `99`'),
(2302, 'F1501', 1, '`999`', '`999`'),
(2303, 'F1502', 1, '`999`', '`999`'),
(2304, 'F1503', 1, '`999`', '`999`'),
(2305, 'F1504', 1, '`999`', '`999`'),
(2306, 'F1505', 1, '`999`', '`999`'),
(2307, 'F1506', 1, '`999`', '`999`'),
(2308, 'F1507', 1, '`999`', '`999`'),
(2309, 'F1508', 1, '`999`', '`999`'),
(2310, 'F1509', 1, '`999`', '`999`'),
(2311, 'F1510', 1, '`999`', '`999`'),
(2312, 'F1511', 1, 'הישגיות בקריירה `99`, רומנטיקה `99`, חברים טובים `99`', 'הישגיות בקריירה `99`, רומנטיקה `99`, חברים טובים `99`'),
(2313, 'F1512', 1, 'קארמה `99`, פרופורציות `99`, אוכל `99`, משפחה `99`', 'קארמה `99`, פרופורציות `99`, אוכל `99`, משפחה `99`'),
(2314, 'F1513', 1, '`999`', '`999`'),
(2315, 'F1514', 1, '`999`', '`999`'),
(2316, 'F1515', 1, '`999`', '`999`'),
(2317, 'F1516', 1, '`999`', '`999`'),
(2318, 'F1517', 1, '`999`', '`999`'),
(2319, 'F1518', 1, '`999`', '`999`'),
(2320, 'F1519', 1, '`999`', '`999`'),
(2321, 'F1520', 1, '`999`', '`999`'),
(2322, 'F1521', 1, 'חליפה רשמית `99`, עיצוב תסרוקת מוקפד `99`,  חולצת בד עם כפתורים `99`', 'נעלי עקב `99`, חצאית מיני `99`,  איפור יומי `99`'),
(2323, 'F1522', 1, '`999`', '`999`'),
(2324, 'F1523', 1, 'אני מתקלח `99` דקות, אחרי המקלחת אני בוחר בגדים ליציאה תוך `99` דקות, ולוקח לי להתלבש ולהתכונן ליציאה `99` דקות ', 'אני נוהגת להתקלח `99` דקות, אחרי המקלחת אני בוחרת בגדים תוך `99` דקות, ולוקח לי להתלבש ולהתכונן ליציאה תוך `99` דקות'),
(2325, 'F1524', 1, 'אני אוכל ארוחת בוקר ב `99` דקות, מסיים קניה שבועית בסופרמרקט תוך `99` דקות, מצחצח שיניים לפני השינה תוך `99` דקות', 'אני אוכלת ארוחת בוקר ב `99` דקות, מסיימת קניה שבועית בסופרמרקט תוך `99` דקות, מצחצחת שיניים לפני השינה תוך `99` דקות'),
(2326, 'F1525', 1, 'עם כמה כריות אתה ישן? `99`, מזרן רך או קשה? `99`, חלון פתוח או סגור? `99`', 'עם כמה כריות את ישנה? `99`, מזרן רך או קשה? `99`, חלון פתוח או סגור? `99`'),
(2327, 'F1526', 1, '`999`', '`999`'),
(2328, 'F1527', 1, '`999`', '`999`'),
(2329, 'F1528', 1, '`999`', '`999`'),
(2330, 'F1529', 1, '`999`', '`999`'),
(2331, 'F1530', 1, '`999`', '`999`'),
(2332, 'F1531', 1, '`999`', '`999`'),
(2333, 'F1532', 1, '`999`', '`999`'),
(2334, 'F1533', 1, '`999`', '`999`'),
(2335, 'F1534', 1, '`999`', '`999`'),
(2336, 'F1535', 1, '`999`', '`999`'),
(2337, 'F1536', 1, '`999`', '`999`'),
(2338, 'F1537', 1, '`999`', '`999`'),
(2339, 'F1538', 1, 'עם `99` אדבר על בעיות בזוגיות, עם `99` אדבר על כסף, עם `99` אדבר על הפנטזיות שלי', 'עם `99` אדבר על בעיות בזוגיות, עם `99` אדבר על כסף, עם `99` אדבר על הפנטזיות שלי'),
(2340, 'F1539', 1, '`999`', '`999`'),
(2341, 'F1540', 1, '`999`', '`999`'),
(2342, 'F1541', 1, '`999`', '`999`'),
(2343, 'F1542', 1, '`999`', '`999`'),
(2344, 'F1543', 1, '`999`', '`999`'),
(2345, 'F1544', 1, '`999`', '`999`'),
(2346, 'F1545', 1, '`999`', '`999`'),
(2347, 'F1546', 1, '`999`', '`999`'),
(2348, 'F1547', 1, '`999`', '`999`'),
(2349, 'F1548', 1, '`999`', '`999`'),
(2350, 'F1549', 1, '`999`', '`999`'),
(2351, 'F1550', 1, '`999`', '`999`'),
(2352, 'F1551', 1, 'עגילים - `99`, ענק - `99`, צמידים - `99`, פירסינג - `99`', 'עגילים - `99`, ענק - `99`, צמידים - `99`, פירסינג - `99`'),
(2353, 'F1552', 1, '`999`', '`999`'),
(2354, 'F1553', 1, 'פיקניק רומנטי בפארק - `99`,  סרט קולנוע - `99`, צניחה חופשית - `99`, הליכה ספורטיבית - `99`, בית קפה - `99`', 'פיקניק רומנטי בפארק - `99`,  סרט קולנוע - `99`, צניחה חופשית - `99`, הליכה ספורטיבית - `99`, בית קפה - `99`'),
(2355, 'F1554', 1, '`999`', '`999`'),
(2356, 'F1555', 1, '`999`', '`999`'),
(2357, 'F1556', 1, '`999`', '`999`'),
(2358, 'F1557', 1, '`999`', '`999`'),
(2359, 'F1558', 1, '`999`', '`999`'),
(2360, 'F1559', 1, '`999`', '`999`'),
(2361, 'F1560', 1, '`999`', '`999`'),
(2362, 'F1561', 1, '`999`', '`999`'),
(2363, 'F1562', 1, '`999`', '`999`'),
(2364, 'F1563', 1, '`999`', '`999`'),
(2365, 'F1564', 1, '`999`', '`999`'),
(2366, 'F1565', 1, '`999`', '`999`'),
(2367, 'F1566', 1, '`999`', '`999`'),
(2368, 'F1567', 1, '`999`', '`999`'),
(2369, 'F1568', 1, '`999`', '`999`'),
(2370, 'F1569', 1, '`999`', '`999`'),
(2371, 'F1570', 1, '`999`', '`999`'),
(2372, 'F1571', 1, '`999`', '`999`'),
(2373, 'F1572', 1, '`999`', '`999`'),
(2374, 'F1573', 1, '`999`', '`999`'),
(2375, 'F1574', 1, '`999`', '`999`'),
(2376, 'F1575', 1, '`999`', '`999`'),
(2377, 'F1576', 1, '`999`', '`999`'),
(2378, 'F1578', 1, 'סמארטפון הוא בדרגת חשיבות `99`, מלאי חטיפים מלוחים `99`,  ספרים טובים `99`, פרטנרית לזוגיות `99`', 'סמארטפון הוא בדרגת חשיבות `99`, מלאי חטיפים מלוחים `99`,  ספרים טובים `99`, פרטנר לזוגיות `99`'),
(2379, 'F1579', 1, '`999`', '`999`'),
(2380, 'F1580', 1, '`999`', '`999`'),
(2381, 'F1581', 1, '`999`', '`999`'),
(2382, 'F1582', 1, 'אני `99`  מאמין בגלגול נשמות, אני `99` מאמין ברוחות, אני `99` מאמין בטלפתיה', 'אני `99` מאמינה בגלגול נשמות, אני `99` מאמינה ברוחות, אני `99` מאמינה בטלפתיה'),
(2383, 'F1583', 1, 'אני `99`  מאמין בגן עדן וגיהנום, אני `99` מאמין בגורל קבוע מראש, אני `99` מאמין בתקשורת עם המתים', 'אני `99`  מאמיןנה בגן עדן וגיהנום, אני `99` מאמינה בגורל קבוע מראש, אני `99` מאמינה בתקשורת עם המתים'),
(2384, 'F1584', 1, 'במקום הראשון `99`, במקום השני `99`, במקום השלישי `99` ', 'במקום הראשון `99`, במקום השני `99`, במקום השלישי `99` '),
(2385, 'F1585', 1, 'מתי בפעם האחרונה קראת ספר `99`, הלכת לתיאטרון `99`, הפגנת בהפגנה `99`', 'מתי בפעם האחרונה קראת ספר `99`, הלכת לתיאטרון `99`, הפגנת בהפגנה `99`'),
(2386, 'F1586', 1, 'אולם אירועים מפואר `99`,  גן אירועים `99`, ביער נידח בארגון עצמי `99`, לאס וגאס `99`, חתונה צנועה בגינה של ההורים', 'אולם אירועים מפואר `99`,  גן אירועים `99`, ביער נידח בארגון עצמי `99`, לאס וגאס `99`, חתונה צנועה בגינה של ההורים'),
(2387, 'F1587', 1, 'את קצת `99`, ואני קצת `99`, ונראה לי ש`99`', 'אתה קצת `99`, ואני קצת `99`, ונראה לי ש`99`'),
(2388, 'F1588', 1, '`999`', '`999`'),
(2389, 'F1589', 1, '`999`', '`999`'),
(2390, 'F1590', 1, '`999`', '`999`'),
(2391, 'F1591', 1, '`999`', '`999`'),
(2392, 'F1592', 1, '`999`', '`999`'),
(2393, 'F1593', 1, 'מפגש בהפסקה בקפיטריה `99`, פתקים תוך כדי שיעור `99`, לימוד זוגי ביחד למבחן `99`', 'מפגש בהפסקה בקפיטריה `99`, פתקים תוך כדי שיעור `99`, לימוד זוגי ביחד למבחן `99`'),
(2394, 'F1594', 1, 'אני מוכן לצאת עם מישהי שהיא מקסימום  `99` שנים מעל, ומקסימום `99` שנים מתחתלגילי. ', 'אני מוכנה לצאת עם מישהו מקסימום `99` שנים מעל, ומקסימום `99` שנים מתחת לגילי. '),
(2395, 'F1595', 1, '`999`', '`999`'),
(2396, 'F1596', 1, '`999`', '`999`'),
(2397, 'F1597', 1, '`999`', '`999`'),
(2398, 'F1598', 1, 'גיק מחשבים דומה לי ב `99` אחוז, ערס עם שרשראות דומה לי ב `99` אחוז, שרירן מנופח דומה לי ב `99` אחוז', '`99` אחוז סיכוי שאצא עם גיק מחשבים, `99` סיכוי שאצא עם ערס עם שרשראות, `99` סיכוי שאבחר בשרירן מנופח'),
(2399, 'F1599', 1, '`99` סיכוי שאצא עם אחת עם לוק של דוגמנית אבל לא מבריקה במיוחד, `99` אחוז סיכוי שאצא עם חדת לשון שתמיד מנצחת בויכוח, `99` סיכוי שאצא עם ביישנית ', 'לוק של דוגמנית אבל לא מבריקה במיוחד דומה לי ב `99` אחוז, תמיד מנצחת בויכוח דומה לי ב `99` אחוז, ביישנית דומה לי ב `99` אחוז'),
(2400, 'F1600', 1, '`999`', '`999`'),
(2401, 'F1601', 1, '`999`', '`999`'),
(2402, 'F1602', 1, '`999`', '`999`'),
(2403, 'F1603', 1, '`999`', '`999`'),
(2404, 'F1604', 1, 'אני חושב שנשים שמתחילות עם גברים זה `99` בגלל ש`99`', '`999`'),
(2405, 'F1606', 1, '`999`', '`999`'),
(2406, 'F1607', 1, '`999`', '`999`'),
(2407, 'F1608', 1, 'לגרום לה לצחוק `99`, לפנק אותה בליטופים `99`, להקשיב לה `99` ', 'לגרום לו לצחוק `99`, לפנק אותו בליטופים `99`, להקשיב לו `99` '),
(2408, 'F1609', 1, 'לקנות לה מתנות `99`, לקחת אותה לטיולים מושקעים `99`, להעריף עליה תשומת לב `99`', 'לקנות לו מתנות `99`, לקחת אותו לטיולים מושקעים `99`, להעריף עליו תשומת לב `99`'),
(2409, 'F1610', 1, 'להחמיא לה על הלוק שלה `99`, להחמיא לה על השכל שלה `99`, להחמיא לה על האישיות שלה `99`', 'להחמיא לו על הלוק שלו `99`, להחמיא לו על השכל שלו `99`, להחמיא לו על האישיות שלו `99` '),
(2410, 'F1611', 1, '`999`', '`999`'),
(2411, 'F1612', 1, '`999`', '`999`'),
(2412, 'F1613', 1, 'אני ריאליסט `99`, אני וורקוהוליק `99`, אני איש של אתגרים `99`', 'אני ריאליסטית `99`, אני וורקוהולית `99`, אני אישה של אתגרים `99`'),
(2413, 'F1614', 1, 'אני זאב בודד `99`, יש לי ביטחון עצמי גבוה `99`, אוני אוהב להוביל `99`', 'אני זאבה בודדה `99`, יש לי ביטחון עצמי גבוה `99`, אני אוהבת להוביל `99`'),
(2414, 'F1615', 1, 'ספורטאית `99`, יודעת לבשל `99`, אמנית יוצרת `99`', 'ספורטאי `99`, יודע לבשל `99`, אמן יוצר `99`'),
(2415, 'F1616', 1, 'רקדנית `99`, נהגת משאית `99`, שוטרת `99`', 'רקדן `99`, נהג משאית `99`, שוטר `99`'),
(2416, 'F1617', 1, '`999`', '`999`'),
(2417, 'F1618', 1, 'סקי `99` טיפוס הרים `99`, צניחה חופשית `99`', 'סקי `99` טיפוס הרים `99`, צניחה חופשית `99`'),
(2418, 'F1619', 1, 'גלישת גלים `99`, טיול לקוטב `99`, אופני שטח `99`', 'גלישת גלים `99`, טיול לקוטב `99`, אופני שטח `99`'),
(2419, 'F1620', 1, '`999`', '`999`'),
(2420, 'F1621', 1, '`999`', '`999`'),
(2421, 'F1622', 1, '`999`', '`999`'),
(2422, 'F1623', 1, '`999`', '`999`'),
(2423, 'F1624', 1, '`999`', '`999`'),
(2424, 'F1625', 1, '`999`', '`999`'),
(2425, 'F1626', 1, 'נשיקה חושנית `99`, מיקס ערוך של שירים יפים `99`, שוקולד בלגי', 'נשיקה חושנית `99`, מיקס ערוך של שירים יפים `99`, שוקולד בלגי'),
(2426, 'F1627', 1, 'טיול בשדה בגשם `99`, מסיבת הפתעה `99`, גור כלבים `99`', 'טיול בשדה בגשם `99`, מסיבת הפתעה `99`, גור כלבים `99`'),
(2427, 'F1628', 1, '`999`', '`999`'),
(2428, 'F1629', 1, 'מעצב שיער `99`, חקלאי `99` מורה דרך `99`', 'מעצבת שיער `99`, חקלאית `99` מורת דרך `99`'),
(2429, 'F1630', 1, 'נהג מונית `99`, טייס `99`, זמר חתונות `99`', 'נהגת מונית `99`, טייסת `99`, זמר חתונות `99`'),
(2430, 'F1631', 1, 'עורך דין `99`, רואה חשבון `99`, בלש משטרה `99`', 'עורכת דין `99`, רואת חשבון `99`, בלשית משטרה `99`'),
(2431, 'F1632', 1, '`999`', '`999`'),
(2432, 'F1633', 1, 'ליצן החבורה `99`, המשוגע שבחבורה `99`, הבחור הטוב שאפשר לסמוך עליו `99` ', 'ליצנית החבורה `99`, המשוגעת שבחבורה `99`, הבחורה הטובה שאפשר לסמוך עליה `99` '),
(2433, 'F1634', 1, 'יש לה טעם רע בבגדים `99`, היא קנאית `99`, לוקחת את כל השמיכה בחורף `99` ', 'יש לו טעם רע בבגדים `99`, הוא קנאי `99`, לוקח את כל השמיכה בחורף `99` '),
(2434, 'F1635', 1, '`999`', '`999`'),
(2435, 'F1636', 1, '`999`', '`999`'),
(2436, 'F1637', 1, '`999`', '`999`'),
(2437, 'F1638', 1, '`999`', '`999`'),
(2438, 'F1639', 1, '`999`', '`999`'),
(2439, 'F1640', 1, 'זה עושה לי חשק ל`999`', 'זה עושה לי חשק ל`999`'),
(2440, 'F1641', 1, 'זה עושה לי חשק ל`999`', 'זה עושה לי חשק ל`999`'),
(2441, 'F1642', 1, 'אלכוהול `99`, כושר גופני `99`, סרט בטלוויזיה `99`', 'אלכוהול `99`, כושר גופני `99`, סרט בטלוויזיה `99`'),
(2442, 'F1643', 1, '`999`', '`999`'),
(2443, 'F1644', 1, '`999`', '`999`'),
(2444, 'F1645', 1, 'אינטלגנציה רגשית `99`, מסירות `99`, היכולת להיות שרוטה לפעמים `99`', 'אינטלגנציה רגשית `99`, מסירות `99`, היכולת להיות שרוט לפעמים `99`'),
(2445, 'F1646', 1, '`999`', '`999`'),
(2446, 'F1647', 1, 'אנוכי `99`, עצלן `99`, אדיש `99`', 'אנוכית `99`, עצלנית `99`, אדישה `99`'),
(2447, 'F1648', 1, 'קמצן `99`, זאב בודד `99`, קילר `99`', 'קמצנית `99`, זאבה בודדה `99`, קילרית `99`'),
(2448, 'F1649', 1, 'יער ענקי מלא ערפל `99`, בית קברות `99`, סמטא חשוכה בלילה בעיר `99`', 'יער ענקי מלא ערפל `99`, בית קברות `99`, סמטא חשוכה בלילה בעיר `99`'),
(2449, 'F1650', 1, 'פסגת האוורסט `99`, ג\'ונגלים בברזיל `99`, טיסה לירח `99`, ', 'פסגת האוורסט `99`, ג\'ונגלים בברזיל `99`, טיסה לירח `99`, '),
(2450, 'F1651', 1, 'אנטארקטיקה `99`, צלילה בקרקעית הים `99`, ראפטינג בצרפת `99`', 'אנטארקטיקה `99`, צלילה בקרקעית הים `99`, ראפטינג בצרפת `99`'),
(2451, 'F1653', 1, '`999`', '`999`'),
(2452, 'F1654', 1, '`999`', '`999`'),
(2453, 'F1655', 1, '`999`', '`999`'),
(2454, 'F1656', 1, '`999`', '`999`'),
(2455, 'F1657', 1, '`999`', '`999`'),
(2456, 'F1658', 1, '`999`', '`999`'),
(2457, 'F1659', 1, '`999`', '`999`'),
(2458, 'F1660', 1, 'משחק הקופסא הפייבוריטי הוא `99`, משחק ארקייד הכי שווה הוא `99`, ומשחק קלפים הכי הכי הוא `99`', 'משחק הקופסא הפייבוריטי הוא `99`, משחק ארקייד הכי שווה הוא `99`, ומשחק קלפים הכי הכי הוא `99`'),
(2459, 'F1661', 1, 'לשאוב אבק `99`, לכבס ולתלות כביסה `99`, לשטוף כלים `99`', 'לשאוב אבק `99`, לכבס ולתלות כביסה `99`, לשטוף כלים `99`'),
(2460, 'F1662', 1, 'לשפוך את הפח `99`, לשטוף את הבית `99`, לסדר את חדר עבודה `99`', 'לשפוך את הפח `99`, לשטוף את הבית `99`, לסדר את חדר עבודה `99`'),
(2461, 'F1663', 1, '`999`', '`999`'),
(2462, 'F1664', 1, 'סדר וניקיון במחברות `999`, משתתף בשיעורים `999`, יש לו פונטציאל `99` והוא מממש אותו `99`', 'סדר וניקיון במחברות `999`, משתתף בשיעורים `999`, יש לו פונטציאל `999`'),
(2463, 'F1665', 1, '`999`', '`999`'),
(2464, 'F1666', 1, 'מפטפט בשיעור `99`, מתייחס בכבוד למורה `99`, מתייצב בזמן לכל השיעורים `99`', 'מפטפטת בשיעור `99`, מתייחסת בכבוד למורה `99`, מתייצבת בזמן לכל השיעורים `99`'),
(2465, 'F1667', 1, 'עד כמה רומנטי? הליכה בשלג `99`, טבילה בכינרת `99`, מלון 5 כוכבים באילת `99`', 'עד כמה רומנטי? הליכה בשלג `99`, טבילה בכינרת `99`, מלון 5 כוכבים באילת `99`'),
(2466, 'F1668', 1, 'עד כמה רומנטי? סביב למדורה עם גיטרה `99`, צפיה במיטה בסדרה אהובה `99`, בניית רהיט של איקאה ביחד `99`, ', 'עד כמה רומנטי? סביב למדורה עם גיטרה `99`, צפיה במיטה בסדרה אהובה `99`, בניית רהיט של איקאה ביחד `99`, '),
(2467, 'F1669', 1, 'אני שוטף את הבית `99` פעמים בשבוע, מכבס בגדים `99` פעמים בחודש, ומסדר את החדר שלי `99` פעמים בשנה', 'אני שוטפת את הבית `99` פעמים בשבוע, מכבסת בגדים `99` פעמים בחודש, ומסדרת את החדר שלי `99` פעמים בשנה'),
(2468, 'F1670', 1, 'מישהי שישבה בכלא על עבירת גניבה `99`, מישהי שעברה ילדות קשה `99`, מישהי שנעצרה על אלימות `99`', 'מישהו שישב בכלא על עבירת גניבה `99`, משהו שעבר ילדות קשה `99`, מישהו שנעצר על אלימות `99`'),
(2469, 'F1671', 1, 'מישהי שתפסת אותה בשקר `99`, מישהי שבגדה בחבר הקודם שלה `99`, מישהי שהזריקה בעבר הרואין אבל עכשיו נקיה `99` ', 'מישהו שתפסת אותו בשקר `99`, מישהו שבגד בחברה הקודמת שלו `99`, מישהו שהזריק בעבר הירואין ועכשיו הוא נקי `99`'),
(2470, 'F1672', 1, '`999`', '`999`'),
(2471, 'F1673', 1, '`999`', '`999`'),
(2472, 'F1674', 1, '`999`', '`999`'),
(2473, 'F1675', 1, 'ידע כללי רחב `99`, הבנה באנשים `99`, אתה בולדוזר `99`', 'ידע כללי רחב `99`, הבנה באנשים `99`, את בולדוזרית `99`'),
(2474, 'F1676', 1, '`999`', '`999`'),
(2475, 'F1677', 1, '`999`', '`999`'),
(2476, 'F1678', 1, '`999`', '`999`'),
(2477, 'F1679', 1, '`999`', '`999`'),
(2478, 'F1680', 1, '`999`', '`999`'),
(2479, 'F1681', 1, '`999`', '`999`'),
(2480, 'F1682', 1, '`999`', '`999`'),
(2481, 'F1683', 1, '`999`', '`999`'),
(2482, 'F1684', 1, 'סופגניה בחנוכה `99`, מציה בפסח `99`, אזני המן בפורים `99`', 'סופגניה בחנוכה `99`, מציה בפסח `99`, אזני המן בפורים `99`'),
(2483, 'F1685', 1, 'צפיה בטלוויזיה `99`, לשכבלשבת על החוף `99`, שופינג `99`', 'צפיה בטלוויזיה `99`, לשכבלשבת על החוף `99`, שופינג `99`'),
(2484, 'F1686', 1, 'בעוד 20 שנה יהיו לי `99` ילדים, אגור ב`99`, אעבוד ב`99`, והתחביב שלי יהיה `99`', 'בעוד 20 שנה יהיו לי `99` ילדים, אגור ב`99`, אעבוד ב`99`, והתחביב שלי יהיה `99`'),
(2485, 'F1687', 1, 'אני פוחד מנחש `99`, עקרב `99`, עכביש `99`, ג\'וק `99`', 'אני פוחדת מנחש `99`, עקרב `99`, עכביש `99`, ג\'וק `99`'),
(2486, 'F1688', 1, '`999`', '`999`'),
(2487, 'F1689', 1, '`999`', '`999`'),
(2488, 'F1690', 1, 'החברים שלי יודעים שאם צריך, תמיד אפשר לסמוך עלי שאוכל להשיג להם `999`', 'החברים שלי יודעים שאם צריך, תמיד אפשר לסמוך עלי שאוכל להשיג להם `999`'),
(2489, 'F1691', 1, '`99` לי נעליים יעודיות להליכה, `99` לי ערכת גז לקמפינג, `99` לי אוהל מתקפל, `99` לי שק שינה', '`99` לי נעליים יעודיות להליכה, `99` לי ערכת גז לקמפינג, `99` לי אוהל מתקפל, `99` לי שק שינה'),
(2490, 'F1692', 1, 'כסף `99`, לעזור לאחרים `99`, קריירה `99`, אהבה `99`', 'כסף `99`, לעזור לאחרים `99`, קריירה `99`, אהבה `99`'),
(2491, 'F1693', 1, 'כדי להתעורר אני משתמש בנודניק `99` פעמים, לוקח לי `99` דקות להתעורר לגמרי ולהתחיל לתפקד, ובדרך כלל המצב רוח שלי בבוקר הוא `99`', 'כדי להתעורר אני משתמשת בנודניק `99` פעמים, לוקח לי `99` דקות להתעורר לגמרי ולהתחיל לתפקד, ובדרך כלל המצב רוח שלי בבוקר הוא `99`'),
(2492, 'F1694', 1, 'ריצת 5 ק\"מ ב 5 בבוקר `99`, שחיית בוקר לפני העבודה `99`, לקום ב-5 לראות את הזריחה בים `99`', 'ריצת 5 ק\"מ ב 5 בבוקר `99`, שחיית בוקר לפני העבודה `99`, לקום ב-5 לראות את הזריחה בים `99`'),
(2493, 'F1695', 1, '`999`', '`999`'),
(2494, 'F1696', 1, 'חשפן `99`, מנחה באח הגדול `99`, מציל בים `99`', 'חשפנית `99`, מנחה באח הגדול `99`, מצילה בים `99`'),
(2495, 'F1697', 1, '`999`', '`999`'),
(2496, 'F1698', 1, '`999`', '`999`'),
(2497, 'F1699', 1, '`999`', '`999`'),
(2498, 'F1700', 1, '`999`', '`999`'),
(2499, 'F1701', 1, 'קנאה `99`, שחצנות `99`, עצלנות `99`', 'קנאה `99`, שחצנות `99`, עצלנות `99`'),
(2500, 'F1702', 1, 'אכילה בלי שליטה מתוך בולמוס `99`, זלזול ביקרים לך `99`, התנשאות `99`', 'אכילה בלי שליטה מתוך בולמוס `99`, זלזול ביקרים לך `99`, התנשאות `99`'),
(2501, 'F1703', 1, '`999`', '`999`'),
(2502, 'F1704', 1, 'נסיעה באופניים `99`, טיול בחוף הים `99`, לתפוס תנומה `99`, להמשיך לשחק איתך `99`', 'נסיעה באופניים `99`, טיול בחוף הים `99`, לתפוס תנומה `99`, להמשיך לשחק איתך `99`'),
(2503, 'F1705', 1, '`999`', '`999`'),
(2504, 'F1706', 1, '`999`', '`999`'),
(2505, 'F1707', 1, '`999`', '`999`'),
(2506, 'F1708', 1, '`999`', '`999`'),
(2507, 'F1709', 1, 'אופנוע הארלי דווידסון `99`, למבורגיני `99`, רכב שטח 4X4 `99`', 'אופנוע הארלי דווידסון `99`,  למבורגיני `99`, רכב שטח 4X4 `99`'),
(2508, 'F1710', 1, '`999`', '`999`'),
(2509, 'F1711', 1, 'בבית קפה - לקוח שצועק בסלולרי `99`, קבצן שנכנס לבקש נדבה מהאורחים `99`, לקוחות שנכנסו אחריך מקבלים שירות הרבה לפניך 99`, המנה שהגיעה אחרת ממה שהזמנת `99`', 'בבית קפה - לקוח שצועק בסלולרי `99`, קבצן שנכנס לבקש נדבה מהאורחים `99`, לקוחות שנכנסו אחריך מקבלים שירות הרבה לפניך `99`, המנה שהגיעה אחרת ממה שהזמנת `99`'),
(2510, 'F1712', 1, '`999`', '`999`'),
(2511, 'F1713', 1, '`999`', '`999`'),
(2512, 'F1714', 1, '`999`', '`999`'),
(2513, 'F1715', 1, '`999`', '`999`'),
(2514, 'F1716', 1, '`999`', '`999`'),
(2515, 'F1717', 1, 'מסאז\' עם שמן `99`, ארוחה במסעדה על צוק בגרנד קניון `99`, לשבת ביציע המכובדים בגמר המונדיאל `99`', 'מסאז\' עם שמן `99`, ארוחה במסעדה על צוק בגרנד קניון `99`, לשבת ביציע המכובדים בגמר המונדיאל `99`'),
(2516, 'F1718', 1, 'עד כמה אתה פוחד לטוס `99`, ממקומות גבוהים `99`, ממקומות סגורים `99`', 'עד כמה את פוחדת לטוס `99`, ממקומות גבוהים `99`, ממקומות סגורים `99`'),
(2517, 'F1719', 1, 'עד כמה אתה פוחד מחושך `99`, מוות `99`, ברקים ורעמים `99`', 'עד כמה את פוחדת מחושך `99`, מוות `99`, ברקים ורעמים `99`'),
(2518, 'F1720', 1, 'ביקור במוזיאון אמנות `99`, הרצאה על פיסיקת קוונטים `99`, סיור באתר חפירות ארכיאולוגיות `99`', 'ביקור במוזיאון אמנות `99`, הרצאה על פיסיקת קוונטים `99`, סיור באתר חפירות ארכיאולוגיות `99`'),
(2519, 'F1721', 1, '`999`', '`999`'),
(2520, 'F1722', 1, '`999`', '`999`'),
(2521, 'F1723', 1, '`999`', '`999`'),
(2522, 'F1724', 1, '`999`', '`999`'),
(2523, 'F1725', 1, '`999`', '`999`'),
(2524, 'F1726', 1, '`999`', '`999`'),
(2525, 'F1727', 1, '`999`', '`999`'),
(2526, 'F1728', 1, '`999`', '`999`'),
(2527, 'F1729', 1, '`999`', '`999`'),
(2528, 'F1730', 1, '`999`', '`999`'),
(2529, 'F1731', 1, '`999`', '`999`'),
(2530, 'F1732', 1, '`999`', '`999`'),
(2531, 'F1733', 1, 'אשת חלומותי תהיה `99`, וגם `99`, וחייבת להיות `99`', 'גבר חלומותי יהיה `99`, וגם `99`, וחייב להיות `99`'),
(2532, 'F1734', 1, 'שקרים `99`, חוסר בקרבה פיזית `99`, בעיות תקשורת `99`, הקפדה על לבוש `99`', 'שקרים `99`, חוסר בקרבה פיזית `99`, בעיות תקשורת `99`, הקפדה על לבוש `99`'),
(2533, 'F1735', 1, 'ריבים וצעקות `99`, חוסר כבוד `99`, זלזול `99`, ההורים שלה מעצבנים `99`', 'ריבים וצעקות `99`, חוסר כבוד `99`, זלזול `99`,  ההורים שלו מעצבנים `99`'),
(2534, 'F1736', 1, 'היעדר ניצוץ `99`, עסוקה מידי בעבודה `99`, לא מרוויחה מספיק `99`', 'היעדר ניצוץ `99`, עסוק מידי בעבודה `99`, לא מרוויח מספיק `99`'),
(2535, 'F1737', 1, '`999`', '`999`'),
(2536, 'F1738', 1, '`999`', '`999`'),
(2537, 'F1739', 1, '`999`', '`999`'),
(2538, 'F1740', 1, '`999`', '`999`'),
(2539, 'F1741', 1, '`999`', '`999`'),
(2540, 'F1742', 1, '`999`', '`999`'),
(2541, 'F1744', 1, '`999`', '`999`'),
(2542, 'F1745', 1, '`999`', '`999`'),
(2543, 'F1747', 1, '`999`', '`999`'),
(2544, 'F1748', 1, '`999`', '`999`'),
(2545, 'F1749', 1, '`999`', '`999`'),
(2546, 'F1750', 1, 'אני אוהב אותך כל כך, בשבילי את ה`99` וה`99`, והלוואי ש`99`', 'אני אוהבת אותך כל כך, בשבילי אתה ה`99` וה`99`, והלוואי ש`99`'),
(2547, 'F1751', 1, '`999`', '`999`'),
(2548, 'F1752', 1, '`999`', '`999`'),
(2549, 'F1753', 1, '`999`', '`999`'),
(2550, 'F1754', 1, '`999`', '`999`'),
(2551, 'F1755', 1, '`999`', '`999`'),
(2552, 'F1756', 1, '`999`', '`999`'),
(2553, 'F1757', 1, '`999`', '`999`'),
(2554, 'F1758', 1, '`999`', '`999`'),
(2555, 'F1759', 1, '`999`', '`999`'),
(2556, 'F1760', 1, '`999`', '`999`'),
(2557, 'F1761', 1, '`999`', '`999`'),
(2558, 'F1762', 1, 'ריח של גשם ראשון `99`, עוגת תפוחים `99`, חוף ים `99`, גויאבה `99`', 'ריח של גשם ראשון `99`, עוגת תפוחים `99`, חוף ים `99`, גויאבה `99`'),
(2559, 'F1763', 1, '`999`', '`999`'),
(2560, 'F1764', 1, 'גשם זה עצבות `99`, גשם זה אושר `99` ובמילים שלך - גשם זה `99`', 'גשם זה עצבות `99`, גשם זה אושר `99` ובמילים שלך - גשם זה `99`'),
(2561, 'F1766', 1, '`999`', '`999`'),
(2562, 'F1767', 1, '`999`', '`999`'),
(2563, 'F1768', 1, '`999`', '`999`'),
(2564, 'F1769', 1, '`999`', '`999`'),
(2565, 'F1770', 1, '`999`', '`999`'),
(2566, 'F1771', 1, '`999`', '`999`'),
(2567, 'F1772', 1, '`999`', '`999`'),
(2568, 'F1773', 1, '`999`', '`999`'),
(2569, 'F1774', 1, '`999`', '`999`'),
(2570, 'F1776', 1, '`999`', '`999`'),
(2571, 'F1778', 1, '`999`', '`999`'),
(2572, 'F1779', 1, '`999`', '`999`'),
(2573, 'F1780', 1, '`999`', '`999`'),
(2574, 'F1783', 1, '`999`', '`999`'),
(2575, 'F1784', 1, '`999`', '`999`'),
(2576, 'F1785', 1, 'גלגל\"צ `99`, רדיו מנטה `99`, 88FM `99`, 103FM `99`, רשת גימל `99`, תחנה שאתה מאוד אוהב ולא ברשימה `99`', 'גלגל\"צ `99`, רדיו מנטה `99`, 88FM `99`, 103FM `99`, רשת גימל `99`, תחנה שאת מאוד אוהבת ולא ברשימה `99`'),
(2577, 'F1786', 1, 'קפיצה ביחד על טרמפולינה `99`, טיול בחסקה `99`, שיעור ריקוד סלסה `99`', 'קפיצה ביחד על טרמפולינה `99`, טיול בחסקה `99`, שיעור ריקוד סלסה `99`'),
(2578, 'F1787', 1, '`999`', '`999`'),
(2579, 'F1788', 1, '`999`', '`999`'),
(2580, 'F1789', 1, '`999`', '`999`'),
(2581, 'F1790', 1, '`999`', '`999`'),
(2582, 'F1791', 1, '`999`', '`999`'),
(2583, 'F1792', 1, '`999`', '`999`'),
(2584, 'F1793', 1, '`999`', '`999`'),
(2585, 'F1794', 1, '`999`', '`999`'),
(2586, 'F1795', 1, '`999`', '`999`'),
(2587, 'F1796', 1, '`999`', '`999`'),
(2588, 'F1797', 1, '`999`', '`999`'),
(2589, 'F1798', 1, 'אני משלם חשבונות בזמן `99`, אני בודק דפי בנק `99`, אף פעם אין לי מינוס `99`', 'אני משלמת חשבונות בזמן `99`, אני בודקת דפי בנק `99`, אף פעם אין לי מינוס `99`'),
(2590, 'F1799', 1, 'אני אוהב לטייל טיולי אוהלים `99`, אני יכול להירדם גם על הרצפה `99`, אני מתקלח גם אם אין מים חמים `99`', 'אני אוהבת לטייל טיולי אוהלים `99`, אני יכולה להירדם גם על הרצפה `99`, אני מתקלחת גם אם אין מים חמים `99`'),
(2591, 'F1800', 1, '`999`', '`999`'),
(2592, 'F1801', 1, 'נקניקיה בלחמניה `99`, המבורגר `99`, שווארמה `99`', 'נקניקיה בלחמניה `99`, המבורגר `99`, שווארמה `99`'),
(2593, 'F1802', 1, 'מלוואח או ג\'חנון `99`, פיצוחים `99`, גלידה `99`', 'מלוואח או ג\'חנון `99`, פיצוחים `99`, גלידה `99`'),
(2594, 'F1803', 1, 'הפיצה שאני אוהב תהיה מורכבת מ`999`', 'הפיצה שאני אוהבת תהיה מורכבת מ`999`'),
(2595, 'F1804', 1, '`999`', '`999`'),
(2596, 'F1805', 1, 'להניע רכב בכבלים `99`, להחליף שקית לשואב אבק `99`, להחליף מיתר לגיטרה `99` ', 'אני יודעת להניע רכב בכבלים `99`, להחליף שקית לשואב אבק `99`, להחליף מיתר לגיטרה `99` '),
(2597, 'F1807', 1, '`999`', '`999`'),
(2598, 'F1808', 1, 'אתה חמוד `99`, אפשר לדבר איתך כמו חבר טוב `99`, יש לך בייבי פייס `99`', 'את בחורה זורמת `99`, אפשר לדבר איתך כמו חברה טובה `99`, יש לך בייבי פייס `99`'),
(2599, 'F1809', 1, 'זה בסדר, אני ממילא לא אוהבת יותר מידי שרירים `99`, אל תהיה לחוץ, דווקא יש לך גוף סבבה `99`, אתה לא כמו כולם `99` ', 'זה בסדר, אני ממילא לא אוהב רזות מידי  `99`, את כוסית `99`, את יכולה להיראות טוב כשאת משקיעה `99`'),
(2600, 'F1810', 1, 'חשפנית `99`, דוגמנית בינלאומית `99`, מדריכת טיולים לחו\"ל `99`', 'חשפן `99`, קצין משטרה בשטח `99`, ימאי בספינה `99`'),
(2601, 'F1811', 1, '`999`', '`999`'),
(2602, 'F1812', 1, 'די ג\'יי `99`, דיילת טעימות בסופרמרקט `99`, ברוקר בבורסה `99`, אפשר לוותר גם על `99`', 'די ג\'יי `99`, דיילת טעימות בסופרמרקט `99`, ברוקר בבורסה `99`, אפשר לוותר גם על `99`');
INSERT INTO `net_filltext` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`) VALUES
(2603, 'F1813', 1, '`999`', '`999`'),
(2604, 'F1814', 1, '`999`', '`999`'),
(2605, 'F1815', 1, '`999`', '`999`'),
(2606, 'F1816', 1, '`999`', '`999`'),
(2607, 'F1817', 1, '`999`', '`999`'),
(2608, 'F1818', 1, 'החיים שלי יפים כי `999`, וגם בגלל `999`', 'החיים שלי יפים כי `999`, וגם בגלל `999`'),
(2609, 'F1819', 1, 'אני פוחד שמחר בבוקר לפתע `999`', 'אני פוחדת שמחר בבוקר לפתע `999`'),
(2610, 'F1820', 1, '`999`', '`999`'),
(2611, 'F1821', 1, '`999`', '`999`'),
(2612, 'F1823', 1, '`999`', '`999`'),
(2613, 'F1824', 1, '`999`', '`999`'),
(2614, 'F1825', 1, 'להיות עשיר `99`, ללמוד דברים חדשים `99`, שיהיו לי חברים טובים שאפשר לסמוך עליהם `99`', 'להיות עשירה `99`, ללמוד דברים חדשים `99`, שיהיו לי חברים טובים שאפשר לסמוך עליהם `99`'),
(2615, 'F1826', 1, 'לשמור על כושר גופני טוב `99`, לחלוק את חיי עם מישהי `99`, להתחטב כדי שיגידו לי תמיד שאני נראה מעולה `99`', 'לשמור על כושר גופני טוב `99`, לחלוק את חיי עם מישהו `99`, להתחטב כדי שיגידו לי תמיד שאני נראית מעולה `99`'),
(2616, 'F1827', 1, '`999`', '`999`'),
(2617, 'F1828', 1, 'אני מוכשר בהרבה דברים `99`, אני סנוב `99`, החיים שלי מדהימים `99`', 'אני מוכשרת בהרבה דברים `99`, אני סנובית `99`, החיים שלי מדהימים `99`'),
(2618, 'F1829', 1, 'אין מצב שאני יוצא מהבית בלי להסתכל במראה קודם `99`, לפעמים אני מרגיש שאני כישלון `99`, אני נוהג לחלום בהקיץ `99`', 'אין מצב שאני יוצאת מהבית בלי להסתכל במראה קודם `99`, לפעמים אני מרגישת שאני כישלון `99`, אני נוהגת לחלום בהקיץ `99`');

-- --------------------------------------------------------

--
-- Table structure for table `net_game`
--

CREATE TABLE `net_game` (
  `GameId` int(11) NOT NULL,
  `Type` int(11) DEFAULT NULL,
  `Level` int(11) DEFAULT NULL,
  `Title` varchar(512) DEFAULT NULL,
  `TimeLimit` int(11) DEFAULT NULL,
  `Comments` varchar(1024) DEFAULT NULL,
  `MaxStepsAlone` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `net_game`
--

INSERT INTO `net_game` (`GameId`, `Type`, `Level`, `Title`, `TimeLimit`, `Comments`, `MaxStepsAlone`) VALUES
(1, 1, 1, 'Game F1599, F1410, F1329, F1333, F1668', 0, NULL, NULL),
(2, 1, 1, 'Game F1337, F1174, F1517, F1395, F1175', 0, NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `net_gameconfig`
--

CREATE TABLE `net_gameconfig` (
  `Id` int(11) NOT NULL,
  `GameId` int(11) NOT NULL,
  `TaskForM` varchar(50) DEFAULT NULL,
  `TaskForF` varchar(50) DEFAULT NULL,
  `Seq` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `net_gameconfig`
--

INSERT INTO `net_gameconfig` (`Id`, `GameId`, `TaskForM`, `TaskForF`, `Seq`) VALUES
(1, 1, 'F1599', 'F1599', 1),
(2, 1, 'F1410', 'F1410', 2),
(3, 1, 'F1329', 'F1329', 3),
(4, 1, 'F1333', 'F1333', 4),
(5, 1, 'F1668', 'F1668', 5),
(6, 2, 'F1337', 'F1337', 1),
(7, 2, 'F1174', 'F1174', 2),
(8, 2, 'F1517', 'F1517', 3),
(9, 2, 'F1395', 'F1395', 4),
(10, 2, 'F1175', 'F1175', 5);

-- --------------------------------------------------------

--
-- Table structure for table `net_gametype`
--

CREATE TABLE `net_gametype` (
  `Id` int(11) NOT NULL,
  `Description` varchar(1024) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `net_gametype`
--

INSERT INTO `net_gametype` (`Id`, `Description`) VALUES
(1, 'Introduction'),
(2, 'familiarity'),
(3, 'well known');

-- --------------------------------------------------------

--
-- Table structure for table `net_gender`
--

CREATE TABLE `net_gender` (
  `Id` int(11) NOT NULL,
  `Name` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `net_gender`
--

INSERT INTO `net_gender` (`Id`, `Name`) VALUES
(1, 'Male'),
(2, 'Female'),
(3, 'Everyone');

-- --------------------------------------------------------

--
-- Table structure for table `net_generatorparameters`
--

CREATE TABLE `net_generatorparameters` (
  `Id` int(11) NOT NULL,
  `Name` varchar(250) DEFAULT NULL,
  `Factor` double DEFAULT NULL,
  `BaseValue` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `net_generatorparameters`
--

INSERT INTO `net_generatorparameters` (`Id`, `Name`, `Factor`, `BaseValue`) VALUES
(1, 'Nearby', 21, 100),
(2, 'Number Of Partners', 23, 60),
(3, 'Hours since last action', 22, 100),
(4, 'Number of played games', 21, 100),
(5, 'Compensation', 20, 0),
(6, 'Age similarity', 88, 100);

-- --------------------------------------------------------

--
-- Table structure for table `net_geographicalarea`
--

CREATE TABLE `net_geographicalarea` (
  `Id` int(11) NOT NULL,
  `TitleEn` varchar(100) DEFAULT NULL,
  `TitleHeb` varchar(100) DEFAULT NULL,
  `MatchKey` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `net_geographicalarea`
--

INSERT INTO `net_geographicalarea` (`Id`, `TitleEn`, `TitleHeb`, `MatchKey`) VALUES
(1, 'All', 'הכל', 'all'),
(2, 'Center', 'מרכז', 'center'),
(3, 'Jerusalem', 'ירושלים', 'jerusalem'),
(4, 'North', 'צפון', 'north'),
(5, 'South', 'דרום', 'south');

-- --------------------------------------------------------

--
-- Table structure for table `net_keywords`
--

CREATE TABLE `net_keywords` (
  `Id` int(11) NOT NULL,
  `Keyword` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `net_keywords`
--

INSERT INTO `net_keywords` (`Id`, `Keyword`) VALUES
(5, 'סמס'),
(6, 'במטבח'),
(7, 'KITCHEN'),
(8, 'משטרה'),
(9, 'עירום'),
(10, 'NUM'),
(11, 'מזל');

-- --------------------------------------------------------

--
-- Table structure for table `net_language`
--

CREATE TABLE `net_language` (
  `Id` int(11) NOT NULL,
  `Description` varchar(1024) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `net_language`
--

INSERT INTO `net_language` (`Id`, `Description`) VALUES
(1, 'Hebrew'),
(2, 'English'),
(3, 'French'),
(4, 'Spanish');

-- --------------------------------------------------------

--
-- Table structure for table `net_loginsession`
--

CREATE TABLE `net_loginsession` (
  `Id` int(11) NOT NULL,
  `UserId` bigint(20) NOT NULL,
  `Token` varchar(100) NOT NULL,
  `CreateOn` datetime NOT NULL,
  `UpdateOn` datetime DEFAULT NULL,
  `ExpireOn` datetime DEFAULT NULL,
  `IsActive` tinyint(4) NOT NULL,
  `DeviceToken` varchar(250) DEFAULT NULL,
  `DeviceType` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `net_mediacomment`
--

CREATE TABLE `net_mediacomment` (
  `Id` int(11) NOT NULL,
  `MessageId` int(11) NOT NULL,
  `UserId` bigint(20) NOT NULL,
  `Username` varchar(255) NOT NULL,
  `Comment` text,
  `Created` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `net_newgamerules`
--

CREATE TABLE `net_newgamerules` (
  `Id` int(11) NOT NULL,
  `Brand` int(11) DEFAULT NULL,
  `PairsGameNumber` int(11) DEFAULT NULL,
  `PlayerMaxGameNumber` int(11) DEFAULT NULL,
  `TaskNumberInGame` int(11) DEFAULT NULL,
  `TaskWasNotUse` varchar(50) DEFAULT NULL,
  `UniqueType` varchar(50) DEFAULT NULL,
  `UniqueSubType` varchar(50) DEFAULT NULL,
  `TaskType` varchar(50) DEFAULT NULL,
  `MinScore` int(11) DEFAULT NULL,
  `MaxScore` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `net_newgamerules`
--

INSERT INTO `net_newgamerules` (`Id`, `Brand`, `PairsGameNumber`, `PlayerMaxGameNumber`, `TaskNumberInGame`, `TaskWasNotUse`, `UniqueType`, `UniqueSubType`, `TaskType`, `MinScore`, `MaxScore`) VALUES
(1, 5, 2, 2, 5, '2,1', '1,1', '1,2', '0,6,5,4,3,1,2,15', 2, 8);

-- --------------------------------------------------------

--
-- Table structure for table `net_news`
--

CREATE TABLE `net_news` (
  `Id` int(11) NOT NULL,
  `UserId` bigint(20) NOT NULL,
  `Title` varchar(255) NOT NULL,
  `Content` text NOT NULL,
  `StoryUrl` text NOT NULL,
  `Created` datetime NOT NULL,
  `Modified` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `net_newscomment`
--

CREATE TABLE `net_newscomment` (
  `Id` int(11) NOT NULL,
  `StoryId` int(11) NOT NULL,
  `UserId` bigint(20) NOT NULL,
  `Username` varchar(255) NOT NULL,
  `Comment` text,
  `Created` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `net_offensivereport`
--

CREATE TABLE `net_offensivereport` (
  `Id` int(11) NOT NULL,
  `PlayerId` bigint(20) DEFAULT NULL,
  `OffensivePlayerId` bigint(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `net_pairgame`
--

CREATE TABLE `net_pairgame` (
  `PairGameId` int(11) NOT NULL,
  `PlayerPairId` int(11) DEFAULT NULL,
  `GameId` int(11) DEFAULT NULL,
  `Timestamp` datetime DEFAULT NULL,
  `IsActive` tinyint(4) DEFAULT NULL,
  `Description` varchar(50) DEFAULT NULL,
  `Player1StepsAlone` int(11) DEFAULT NULL,
  `Player2StepsAlone` int(11) DEFAULT NULL,
  `Seq` int(11) DEFAULT NULL,
  `IsFinished` tinyint(4) DEFAULT NULL,
  `SessionId` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `net_pairstatus`
--

CREATE TABLE `net_pairstatus` (
  `Id` int(11) NOT NULL,
  `Name` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `net_pairstatus`
--

INSERT INTO `net_pairstatus` (`Id`, `Name`) VALUES
(1, 'Playing'),
(2, 'End'),
(3, 'Disconnect'),
(4, 'Offensive');

-- --------------------------------------------------------

--
-- Table structure for table `net_passion`
--

CREATE TABLE `net_passion` (
  `PassionId` int(11) NOT NULL,
  `TitleEn` varchar(100) DEFAULT NULL,
  `TitleHeb` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `net_passion`
--

INSERT INTO `net_passion` (`PassionId`, `TitleEn`, `TitleHeb`) VALUES
(27, 'Pineapple pizza', 'פיצה אננס'),
(28, 'Collecting rubber ducks', 'איסוף ברווזי גומי'),
(29, 'Gardening at night', 'גינון בלילה'),
(30, 'Jumping in puddles', 'קפיצה בשלוליות'),
(31, 'Imitation of singers', 'חיקוי זמרים'),
(32, 'Cheese sculpture', 'פיסול גבינה'),
(33, 'Emoji song', 'שירת אימוג\'י'),
(34, 'Arguments with yourself', 'ויכוחים עם עצמך'),
(35, 'Fruit juggling', 'ג\'אגלינג פירות'),
(36, 'A trip to the bottom of the sea', 'טיול בקרקעית הים'),
(37, 'Peeling sabers', 'קילוף סברס');

-- --------------------------------------------------------

--
-- Table structure for table `net_playerpair`
--

CREATE TABLE `net_playerpair` (
  `PlayerPairId` int(11) NOT NULL,
  `Player1` bigint(20) NOT NULL,
  `Player2` bigint(20) NOT NULL,
  `CurrentPairGameId` int(11) DEFAULT NULL,
  `Description` varchar(1024) DEFAULT NULL,
  `Timestamp` datetime DEFAULT NULL,
  `IsActive` tinyint(4) DEFAULT NULL,
  `Status` int(11) DEFAULT NULL,
  `RemovedByPlayer1` tinyint(4) DEFAULT NULL,
  `RemovedByPlayer2` tinyint(4) DEFAULT NULL,
  `ContinueByPlayer1` tinyint(4) DEFAULT NULL,
  `ContinueByPlayer2` tinyint(4) DEFAULT NULL,
  `PairingTime` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `net_q234`
--

CREATE TABLE `net_q234` (
  `Id` int(11) NOT NULL,
  `TaskId` varchar(50) NOT NULL,
  `LanguageId` int(11) NOT NULL,
  `A1Text` varchar(1024) DEFAULT NULL,
  `A1Image` varchar(128) DEFAULT NULL,
  `A2Text` varchar(1024) DEFAULT NULL,
  `A2Image` varchar(128) DEFAULT NULL,
  `A3Text` varchar(1024) DEFAULT NULL,
  `A3Image` varchar(128) DEFAULT NULL,
  `A4Text` varchar(1024) DEFAULT NULL,
  `A4Image` varchar(128) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `net_q234`
--

INSERT INTO `net_q234` (`Id`, `TaskId`, `LanguageId`, `A1Text`, `A1Image`, `A2Text`, `A2Image`, `A3Text`, `A3Image`, `A4Text`, `A4Image`) VALUES
(1, 'F1824', 1, 'aaa', '1856174242589052928%20(2).png', NULL, NULL, NULL, NULL, NULL, NULL),
(2, 'F1824', 1, NULL, NULL, 'bbbb', NULL, NULL, NULL, NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `net_resourcestring`
--

CREATE TABLE `net_resourcestring` (
  `Id` int(11) NOT NULL,
  `ResourceKey` varchar(50) DEFAULT NULL,
  `En` longtext,
  `He` longtext
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `net_role`
--

CREATE TABLE `net_role` (
  `Id` int(11) NOT NULL,
  `Name` varchar(50) DEFAULT NULL,
  `Description` varchar(512) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `net_role`
--

INSERT INTO `net_role` (`Id`, `Name`, `Description`) VALUES
(1, 'Admin', 'Can perform all configuration and maintenance activities on the database'),
(2, 'Registered', 'Player'),
(3, 'Anonymous', 'Not registered');

-- --------------------------------------------------------

--
-- Table structure for table `net_sexualorientation`
--

CREATE TABLE `net_sexualorientation` (
  `SexualOrientationId` int(11) NOT NULL,
  `TitleEn` varchar(100) DEFAULT NULL,
  `TitleHeb` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `net_sexualorientation`
--

INSERT INTO `net_sexualorientation` (`SexualOrientationId`, `TitleEn`, `TitleHeb`) VALUES
(1, 'Straight', 'סטרייט'),
(2, 'Gay', 'גיי'),
(3, 'Lesbian', 'לסבית'),
(4, 'Bisexual', 'דו'),
(5, 'Asexual', 'א מיני');

-- --------------------------------------------------------

--
-- Table structure for table `net_sysparam`
--

CREATE TABLE `net_sysparam` (
  `Id` int(11) NOT NULL,
  `MaxOfPartners` int(11) DEFAULT NULL,
  `AdminEmail` varchar(50) DEFAULT NULL,
  `DisableEditingAvatar` tinyint(4) DEFAULT NULL,
  `RequirePhoneVerfication` tinyint(4) DEFAULT NULL,
  `AndroidInviteMessage` longtext,
  `iOSInviteMessage` longtext,
  `StaticPartnerDuration` int(11) DEFAULT NULL,
  `StaticPartnerUnit` varchar(10) DEFAULT NULL,
  `PartnerMatchingAgeUp` int(11) DEFAULT NULL,
  `PartnerMatchingAgeDowm` int(11) DEFAULT NULL,
  `LatestAppVersion` varchar(50) DEFAULT NULL,
  `AgeRangeUpperLimit` int(11) DEFAULT NULL,
  `AgeRangeLowerLimit` int(11) DEFAULT NULL,
  `PlayButtonIdleTime` int(11) DEFAULT NULL,
  `HobbiesListVisible` tinyint(4) DEFAULT NULL,
  `PlayNowMode` int(11) DEFAULT NULL,
  `PlayNowMessageKey` varchar(100) DEFAULT NULL,
  `DefaultRegisterUserState` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `net_sysparam`
--

INSERT INTO `net_sysparam` (`Id`, `MaxOfPartners`, `AdminEmail`, `DisableEditingAvatar`, `RequirePhoneVerfication`, `AndroidInviteMessage`, `iOSInviteMessage`, `StaticPartnerDuration`, `StaticPartnerUnit`, `PartnerMatchingAgeUp`, `PartnerMatchingAgeDowm`, `LatestAppVersion`, `AgeRangeUpperLimit`, `AgeRangeLowerLimit`, `PlayButtonIdleTime`, `HobbiesListVisible`, `PlayNowMode`, `PlayNowMessageKey`, `DefaultRegisterUserState`) VALUES
(1, 6, 'info@play-with-me.net', 0, 1, '`name` invited you to play. Click `url` to start!', '`name` invited you to play. Click `url` to start!', 4, 'hour', NULL, NULL, '3.2.6', -1, -1, 10, 1, 3, 'play_now_message', 2);

-- --------------------------------------------------------

--
-- Table structure for table `net_taskanswer`
--

CREATE TABLE `net_taskanswer` (
  `Id` int(11) NOT NULL,
  `OrderNumber` int(11) DEFAULT NULL,
  `CompletedTaskId` int(11) NOT NULL,
  `AttachedText` varchar(1024) DEFAULT NULL,
  `AnswerText` varchar(1024) DEFAULT NULL,
  `MediaPath` varchar(1024) DEFAULT NULL,
  `Timestamp` datetime DEFAULT NULL,
  `Score` int(11) DEFAULT NULL,
  `Offensive` varchar(1024) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `net_taskanswerfeedback`
--

CREATE TABLE `net_taskanswerfeedback` (
  `Id` int(11) NOT NULL,
  `Seq` int(11) DEFAULT NULL,
  `CompletedTaskId` int(11) NOT NULL,
  `PlayerId` bigint(20) NOT NULL,
  `Comment` varchar(1024) DEFAULT NULL,
  `Timestamp` datetime DEFAULT NULL,
  `LikeTypeId` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `net_taskauthor`
--

CREATE TABLE `net_taskauthor` (
  `Id` int(11) NOT NULL,
  `AuthorName` varchar(128) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `net_taskauthor`
--

INSERT INTO `net_taskauthor` (`Id`, `AuthorName`) VALUES
(1, 'author 1'),
(2, 'author 2'),
(3, 'author 3');

-- --------------------------------------------------------

--
-- Table structure for table `net_taskkeyword`
--

CREATE TABLE `net_taskkeyword` (
  `Id` int(11) NOT NULL,
  `TaskId` varchar(50) DEFAULT NULL,
  `KeywordId` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `net_taskkeyword`
--

INSERT INTO `net_taskkeyword` (`Id`, `TaskId`, `KeywordId`) VALUES
(15, 'Q0116', 5),
(16, 'Q0116', 7),
(22, 'F040', 7),
(23, 'Q0113', 10),
(26, 'T0023', 6),
(27, 'T0023', 11),
(28, 'F039', 8),
(29, 'F039', 9),
(32, 'Q0115', 5),
(57, 'F1245', 5),
(58, 'F1245', 6),
(59, 'F1245', 9);

-- --------------------------------------------------------

--
-- Table structure for table `net_tasklike`
--

CREATE TABLE `net_tasklike` (
  `Id` int(11) NOT NULL,
  `Name` varchar(50) DEFAULT NULL,
  `ImagePath` varchar(512) DEFAULT NULL,
  `IsActive` tinyint(4) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `net_tasklike`
--

INSERT INTO `net_tasklike` (`Id`, `Name`, `ImagePath`, `IsActive`) VALUES
(1, '1', 'like.png', 1),
(2, '2', 'unlike.png', 1);

-- --------------------------------------------------------

--
-- Table structure for table `net_taskmaxstep`
--

CREATE TABLE `net_taskmaxstep` (
  `Id` int(11) NOT NULL,
  `TaskId` varchar(50) NOT NULL,
  `PlayerPairId` int(11) NOT NULL,
  `PlayerId` bigint(20) NOT NULL,
  `MaxAloneSteps` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `net_tasknotification`
--

CREATE TABLE `net_tasknotification` (
  `Id` int(11) NOT NULL,
  `CompletedTaskId` int(11) NOT NULL,
  `PlayerFromId` bigint(20) NOT NULL,
  `PlayerToId` bigint(20) NOT NULL,
  `Timestamp` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `net_tasks`
--

CREATE TABLE `net_tasks` (
  `Seq` int(11) NOT NULL,
  `TaskId` varchar(50) NOT NULL,
  `Type` int(11) DEFAULT NULL,
  `SubType` int(11) DEFAULT NULL,
  `SubSubType` int(11) DEFAULT NULL,
  `Status` int(11) DEFAULT NULL,
  `Title` varchar(256) DEFAULT NULL,
  `TimeLimit` int(11) DEFAULT NULL,
  `ForMale` tinyint(4) DEFAULT NULL,
  `ForFemale` tinyint(4) DEFAULT NULL,
  `FromAge` int(11) DEFAULT NULL,
  `ToAge` int(11) DEFAULT NULL,
  `AvailabilityLevel` int(11) DEFAULT NULL,
  `PrivacyLevel` int(11) DEFAULT NULL,
  `IntimacyLevel` int(11) DEFAULT NULL,
  `EaseLevel` int(11) DEFAULT NULL,
  `ThinkLevel` int(11) DEFAULT NULL,
  `CourageLevel` int(11) DEFAULT NULL,
  `InsertDate` datetime DEFAULT NULL,
  `LastUpdateDate` datetime DEFAULT NULL,
  `Score` int(11) DEFAULT NULL,
  `Author` int(11) DEFAULT NULL,
  `InUseCount` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `net_tasks`
--

INSERT INTO `net_tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES
(1022, 'F1245', 6, 20, NULL, 3, 'להיפרד ב SMS, שופכת עלי, משגעת אותי, רואה כל הזמן....', 0, 1, 0, 18, 99, 2, 5, 5, 5, 5, 5, '2024-12-09 14:03:30', '2024-12-09 14:03:30', 4, 1, NULL),
(1023, 'F1246', 6, 31, NULL, 3, 'להיפרד ב SMS, בהודעה חייבת להופיע המילה - קטןגדול', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 4, 1, NULL),
(1024, 'F1247', 6, 31, NULL, 3, 'SMS פרידה, כשבהודעה מילים בנות שתי אותיות בלבד', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 2, 1, NULL),
(1025, 'F1248', 6, 31, NULL, 3, 'SMS במטרה שהאקס יזמין אותך, מבלי להיראות להוטה', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 4, 1, NULL),
(1026, 'F1254', 6, 31, NULL, 3, 'SMS שזה לא ילך תוך שימוש במושגים מעולם הרפואהכדורגל', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 4, 1, NULL),
(1027, 'F1255', 6, 31, NULL, 3, 'החברה בגדה, סרב לה, תוך שאתה משתמש במונחים מעולם המוסיקה', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 4, 1, NULL),
(1028, 'F1290', 6, 31, NULL, 3, 'להיפרד בSMS את תמיד, ואת אף פעם', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 3, 1, NULL),
(1029, 'F1197', 6, 31, NULL, 3, 'יצאת עם מישהי נחמדה, אבל אתה מרגיש שזה לא זה. כתוב לה SMS בו אתה מודיע שאתה לא מעוניין, אבל בו זמנית אתה חייב להחמיא לה ולהעלות לה את הביטחון העצמי', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 2, 1, NULL),
(1030, 'F1198', 6, 31, NULL, 3, 'להחמיא ב-SMS בלי להיות ישיר', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 4, 1, NULL),
(1031, 'F1199', 6, 31, NULL, 3, 'תירוצים על מבט במלצרית', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 5, 1, NULL),
(1032, 'F1750', 6, 32, NULL, 3, 'נסח מכתב אהבה הכי דביקי בעולם: אני אוהב אותך כל כך, בשבילי את ה`99` וה`99`, והלוואי ש`99`', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 2, 1, NULL),
(1033, 'F1801', 6, 33, NULL, 3, 'נקניקיה בלחמניה `99`, המבורגר `99`, שווארמה `99`', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 3, 1, NULL),
(1034, 'F1802', 6, 33, NULL, 3, 'מלוואח או ג\'חנון `99`, פיצוחים `99`, גלידה `99`', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 3, 1, NULL),
(1035, 'F1803', 6, 33, NULL, 3, 'הרכב לעצמך פיצה חלומית גורמה', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 3, 1, NULL),
(1036, 'F1183', 6, 33, NULL, 3, 'איזו מנה עיקרית אתה הכי אוהב לאכול?', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 3, 1, NULL),
(1037, 'F1184', 6, 33, NULL, 3, 'איזה קינוח בא לך עכשיו?', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 3, 1, NULL),
(1038, 'F1291', 6, 33, NULL, 3, 'איזה אוכל אתה אלוף בלהכין?', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 3, 1, NULL),
(1039, 'F1297', 6, 33, NULL, 3, 'יודעים להכין חביתה, עוף, ירקות מוקפצים', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 3, 1, NULL),
(1040, 'F1298', 6, 33, NULL, 3, 'יודעים להכין עוגת דבש, סלט פירות, טירמיסו, פנקייק', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 3, 1, NULL),
(1041, 'F1299', 6, 33, NULL, 3, 'יודעים להכין שיפודים במנגל, מרק ירקות, טוסט, שניצל', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 3, 1, NULL),
(1042, 'F1209', 6, 33, NULL, 3, 'נניח שיש לך אספקה בלתי מוגבלת של אוכל מסוג אחד, מה תבחר?', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 3, 1, NULL),
(1043, 'F1485', 6, 33, NULL, 3, 'מהו המאכל הכי מוזר שאכלת אי פעם?', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 2, 1, NULL),
(1044, 'F1490', 6, 34, NULL, 3, 'על מה החמיאו לך לאחרונה?', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 3, 1, NULL),
(1045, 'F1496', 6, 34, NULL, 3, 'החברים שלך אומרים שאתה כריזמטי - `99`, שאתה אינטלגנטי - `99`, שאתה עפיפון - `99`', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 4, 1, NULL),
(1046, 'F1497', 6, 34, NULL, 3, 'החברים שלך אומרים שאתה כיפי - `99`, שאתה נחוש והחלטי - `99`, שאתה פצצת אנרגיה - `99`', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 4, 1, NULL),
(1047, 'F1498', 6, 34, NULL, 3, 'החברים שלך אומרים שאתה מצחיק - `99`, שאתה יצירתי - `99`, שאתה מתלבש טיפ טופ - `99`', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 4, 1, NULL),
(1048, 'F1499', 6, 34, NULL, 3, 'החברים שלך אומרים שאתה יודע לפתור כל בעיה - `99`, שאתה שמח ומאושר - `99`, שאתה מלא ברוגע בשלווה - `99`', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 4, 1, NULL),
(1049, 'F1500', 6, 34, NULL, 3, 'החברים שלך אומרים שיש בך צד מסתורי ומוזר - `99`, שיש לך ביטחון עצמי - `99`, שאתה בהחלט יודע ליהנות ולבלות - `99`', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 4, 1, NULL),
(1050, 'F1493', 6, 34, NULL, 3, 'האם לדעתך החברים שלך אתה מתנהלת לפי אינטואציה, או לפי חשיבה הגיונית? האם הם צודקים?', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 1, 1, NULL),
(1051, 'F1504', 6, 35, NULL, 3, 'האם יצא לך להתחיל עם גברים? ולגבר, האם מישהי התחילה איתך פעם?', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 4, 1, NULL),
(1052, 'F1508', 6, 35, NULL, 3, 'החברה אומרת לך שהיא רוצה לצאת לניו יורק לשבוע חופשת בנות בלעדיך. איך תרגיש עם זה?', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 4, 1, NULL),
(1053, 'F1509', 6, 35, NULL, 3, 'החברה בנסיעת עבודה בחו\"ל, ובגלל נסיבות, היא תצטרך לישון באותו החדר במלון עם עמית לעבודה שהוא גבר. האם זה מקובל עליך?', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 4, 1, NULL),
(1054, 'F1513', 6, 35, NULL, 3, 'באיזה תחום אם מעצבנים אותך - פחד אלוהים להסתבך איתך? ', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 3, 1, NULL),
(1055, 'F1514', 6, 35, NULL, 3, 'באיזה תחום אתה מוותר תמיד, שאפשר להגדי אותך לגמרי פרייר? ', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 3, 1, NULL),
(1056, 'F1520', 6, 35, NULL, 3, 'האם אי פעם קינאת בחבר שלך? אם כן, מה? ', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 2, 1, NULL),
(1057, 'F1527', 6, 35, NULL, 3, 'באיזה תחום אתם מרגישים חסרי ביטחון לפעמים?', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 2, 1, NULL),
(1058, 'F1533', 6, 35, NULL, 3, 'האם אתה מחשיב את עצמך כ\"יודע להתלבש\"? האם אתה קונה לעצמך לבד את הבגדים?', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 4, 1, NULL),
(1059, 'F1540', 6, 35, NULL, 3, 'עד כמה אתה מנומס עם גינונים בסטייל בריטי אירופאי קלאסי?', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 1, 1, NULL),
(1060, 'F1390', 6, 35, NULL, 3, 'האם יש לך פוביה כלשהי? מהי?', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 4, 1, NULL),
(1061, 'F1393', 6, 35, NULL, 3, 'האם אתה שר במקלחת? איזה שיר שרת לעצמךלאחרונה?', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 3, 1, NULL),
(1062, 'F1400', 6, 35, NULL, 3, 'ספרו על תכונה אחת שבה אתם דומים לאבאאמא', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 3, 1, NULL),
(1063, 'F1397', 6, 35, NULL, 3, 'עד כמה חשוב לך שהיא תהיה בנאדם רגיש לאחרים?', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 3, 1, NULL),
(1064, 'F1407', 6, 35, NULL, 3, 'כמה אתה זוכר את החלומות שלך?', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 3, 1, NULL),
(1065, 'F1411', 6, 35, NULL, 3, 'ספר על זיכרון נעים מהשנים האחרונות', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 3, 1, NULL),
(1066, 'F1424', 6, 35, NULL, 3, 'איזה בגד הכי מחמיא לך? ', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 3, 1, NULL),
(1067, 'F1437', 6, 35, NULL, 3, 'מה הדבר הכי טוב שקרה לך בשבוע האחרון?', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 4, 1, NULL),
(1068, 'F1438', 6, 35, NULL, 3, 'לאיזה רגע אחד בשבוע אתה הכי מחכה כל השבוע?', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 4, 1, NULL),
(1069, 'F1448', 6, 35, NULL, 3, 'למי אתה הכי מתגעגע עכשיו??', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 4, 1, NULL),
(1070, 'F1449', 6, 35, NULL, 3, 'באיזה מצב רוח קמת הבוקר? ', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 4, 1, NULL),
(1071, 'F1466', 6, 35, NULL, 3, 'האם יצא לך להיפרד ממישהי בטלפוןSMSמייל? אם כן, איך היא קיבלה את זה?', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 3, 1, NULL),
(1072, 'F1470', 6, 35, NULL, 3, 'מה אתם יכולים להגיד על החברה הכי מוזרה שיש לכם?', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 3, 1, NULL),
(1073, 'F1471', 6, 35, NULL, 3, 'ממה אתם הכי מודאגים השבוע?', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 4, 1, NULL),
(1074, 'F1560', 6, 35, NULL, 3, 'קרה לך שידידה התקשרה אליך לבוא לבכות לך? על מה?', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 3, 1, NULL),
(1075, 'F1579', 6, 35, NULL, 3, 'פרט חלום אופטימי שאתה זוכר שחלמת.', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 2, 1, NULL),
(1076, 'F1580', 6, 35, NULL, 3, 'פרט חלום מפחיד שאתה זוכר שחלמת', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 2, 1, NULL),
(1077, 'F1612', 6, 35, NULL, 3, 'מה גורם לכם להרגיש סקסיים?', 0, 1, 1, 18, 99, 4, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 3, 1, NULL),
(1078, 'F1617', 6, 35, NULL, 3, 'אתה בדייט עכשיו. איזה חיסרון שלך תנסה להצניע?', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 3, 1, NULL),
(1079, 'F1313', 6, 35, NULL, 3, 'איך אתם בבקרים  בלילות?', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 2, 1, NULL),
(1080, 'F1314', 6, 35, NULL, 3, 'איך אתם שותים את הקפהתה שלכם', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 2, 1, NULL),
(1081, 'F1315', 6, 35, NULL, 3, 'אם אני שומע את הזמר___, אני תולש את השערות', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 3, 1, NULL),
(1082, 'F1316', 6, 35, NULL, 3, 'כמה זמן ביום אתה מבלה בפייסבוק?', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 1, 1, NULL),
(1083, 'F1317', 6, 35, NULL, 3, 'הנשיקה הראשונה היתה עם, במקום ___, בגיל ___', 0, 1, 1, 18, 99, 4, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 4, 1, NULL),
(1084, 'F1305', 6, 35, NULL, 3, 'האם יש לך קעקוע, איפה ואיזה?', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 2, 1, NULL),
(1085, 'F1307', 6, 35, NULL, 3, 'כינוי או שם חיבה שנוהגים לכנות אותך', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 3, 1, NULL),
(1086, 'F1308', 6, 35, NULL, 3, 'איך אתה מזיז את הגוף כדי לא להיות בטטה', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 3, 1, NULL),
(1087, 'F1309', 6, 35, NULL, 3, 'באיזה צד של המיטה אתה ישן?', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 2, 1, NULL),
(1088, 'F1374', 6, 35, NULL, 3, 'איזה הרגל של אחד החברים שלך מטריף לך את השכל?', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 3, 1, NULL),
(1089, 'F1379', 6, 35, NULL, 3, 'האם יש מאכל שאתה אוהב לאכול במיטה?', 0, 1, 1, 18, 99, 4, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 3, 1, NULL),
(1090, 'F1382', 6, 35, NULL, 3, 'האם יצא לך לטייל לפחות כמה ימים לבד לבד? אם כן, באיזו סיטואציה?', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 3, 1, NULL),
(1091, 'F1384', 6, 35, NULL, 3, 'אילו תחתונים יש לכם במגירה? (השלמת טקסט) ', 0, 1, 1, 18, 99, 4, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 3, 1, NULL),
(1092, 'F1268', 6, 36, NULL, 3, 'לאיזו תקופה היית רוצה לנסוע במנהרת זמן?', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 2, 1, NULL),
(1093, 'F1269', 6, 36, NULL, 3, 'למחוק רגע מהעבר', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 2, 1, NULL),
(1094, 'F1270', 6, 36, NULL, 3, 'לשחזר רגע מהעבר', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 2, 1, NULL),
(1095, 'F1271', 6, 36, NULL, 3, 'לבלות עם כוכבת קולנוע', 0, 1, 1, 18, 99, 4, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 2, 1, NULL),
(1096, 'F1165', 6, 38, NULL, 3, 'אף פעם לא אכלתי', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 3, 1, NULL),
(1097, 'F1160', 6, 38, NULL, 3, 'אף פעם לא יצאתי עם אישה ', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 3, 1, NULL),
(1098, 'F1161', 6, 38, NULL, 3, 'אף פעם לא סיפרתי להורים שלי', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 3, 1, NULL),
(1099, 'F1716', 6, 39, NULL, 3, 'האם יצא לך להישאר בקשר טוב עם אקסית שלך גם אחרי הפרידה?', 0, 1, 1, 18, 99, 4, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 3, 1, NULL),
(1100, 'F1206', 6, 40, NULL, 3, 'להכין ארוחת ערב רומנטית - אוכל', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 5, 1, NULL),
(1101, 'F1207', 6, 40, NULL, 3, 'להכין ארוחת ערב רומנטית - אווירה', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 5, 1, NULL),
(1102, 'F1289', 6, 41, NULL, 3, 'לאיזה מקום בעולם הכי בא לך לנסוע עכשיו?', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 2, 1, NULL),
(1103, 'F1159', 6, 41, NULL, 3, 'בא לי לפנק את עצמי', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 4, 1, NULL),
(1104, 'F1006', 6, 42, NULL, 3, 'תארי במדויק את הלבוש שלך במסיבה האחרונה שרקדת בה', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 3, 1, NULL),
(1105, 'F1025', 6, 43, NULL, 3, 'איזה אדם שמעורב בחיים שלך אתה מעריץ בענק?', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 3, 1, NULL),
(1106, 'F1030', 6, 43, NULL, 3, 'אם היתה לך גישה ללא הגבלת זמן או כסף לחנות אחת. איזו חנות זו היתה? ', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 3, 1, NULL),
(1107, 'F1033', 6, 43, NULL, 3, 'יש לך משימה להיות מיליונר תוך 5 שנים. מה התכנית שלך?', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 3, 1, NULL),
(1108, 'F1039', 6, 43, NULL, 3, 'הרכב לך אישה עם 5 תכונות מהרשימה שלפניך, כשחייבות להופיע לפחות 2 תכונות שליליות: יפה, חכמה, אתלטית, עשירה, יודעת להקשיב, חייכנית עם גישה חיובית - מכוערת, טיפשה, בלי גרוש, לא קשובה, מרירה עם גישה שלילית', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 4, 1, NULL),
(1109, 'F1036', 6, 43, NULL, 3, 'בגד ים צמוד או מכנסי גלישה? `99`, להשתזף על החול או לשחות בים? `99`, חוף מבודד, או חוף מוכרז? `99`', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 2, 1, NULL),
(1110, 'F1044', 6, 43, NULL, 3, 'אם תוכל להיות בכל גיל שתבחר למשך שבוע, מה תבחר ומה תעשה בשבוע הזה?', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 3, 1, NULL),
(1111, 'F1294', 6, 43, NULL, 3, 'את מי תיקח איתך לאי בודד?', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 2, 1, NULL),
(1112, 'F1300', 6, 43, NULL, 3, 'שפשפת מנורה, איזה מפורסם היית רוצה להיות?', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 2, 1, NULL),
(1113, 'F1292', 6, 43, NULL, 3, 'חכם, חטוב, או מפורסם?', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 4, 1, NULL),
(1114, 'F1381', 6, 43, NULL, 3, 'איזה סוג מסאז\' אתם הכי אוהבים?', 0, 1, 1, 18, 99, 4, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 1, 1, NULL),
(1115, 'F1371', 6, 43, NULL, 3, 'איזו חובת תחזוקת בית אתה הכי שונא לעשות?', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 3, 1, NULL),
(1116, 'F1350', 6, 43, NULL, 3, 'איזו עונה אתם הכי אוהבים? למה?', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 2, 1, NULL),
(1117, 'F1351', 6, 43, NULL, 3, 'חשוב לי שהחברה שלי תרגש אותי `99`, חשוב לי שהיא תצחיק אותי `99`, חשוב לי שהיא תפנק אותי `99`', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 4, 1, NULL),
(1118, 'F1354', 6, 43, NULL, 3, 'איפה לגור? דירת פנטהאוז עם נוף מדהים לים, או בית עם גינה?', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 2, 1, NULL),
(1119, 'F1355', 6, 43, NULL, 3, 'מה בעבודה שלך אתה הכי אוהב?', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 3, 1, NULL),
(1120, 'F1356', 6, 43, NULL, 3, 'איזה סרט שאתה אוהב יצא לך לראות הרבה פעמים ואין לך בעיה לצפות בו שוב?', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 2, 1, NULL),
(1121, 'F1358', 6, 43, NULL, 3, 'כשאתה בחו\"ל אתה בעניין של תרבות ואמנות, או בעניין של בילויים והופעות?', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 2, 1, NULL),
(1122, 'F1359', 6, 43, NULL, 3, 'להתחתן עם פוליטיקאי, עם פרופסור למתמטיקה', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 2, 1, NULL),
(1123, 'F1362', 6, 43, NULL, 3, 'ספר או סרט, חומוסיה או איטלקית, מזרחית או רוקנרול', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 2, 1, NULL),
(1124, 'F1363', 6, 43, NULL, 3, 'שיר לועזרי או עברית, או פניים חשמליים או רגילים, נס או שחור בבוקר', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 2, 1, NULL),
(1125, 'F1364', 6, 43, NULL, 3, 'לישון בפיג\'מה או בעירום, רגליים ארוכות או חיוך מקסים, קומדיה רומנטית או סרט אקשן', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 4, 1, NULL),
(1126, 'F1311', 6, 43, NULL, 3, 'באיזה כלי נגינה היית רוצה לדעת לנגן?', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 2, 1, NULL),
(1127, 'F1312', 6, 43, NULL, 3, 'במה לבחור מבין מיץ תפוחים, תפוזים, סודה, או קולה', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 3, 1, NULL),
(1128, 'F1326', 6, 43, NULL, 3, 'איזה חשבון אתם הכי שונאים לשלם?', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 2, 1, NULL),
(1129, 'F1328', 6, 43, NULL, 3, 'איזה אתר אינטרנט אתם אוהבים לגלוש, גם לחדשות וגם לסתם... ', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 2, 1, NULL),
(1130, 'F1618', 6, 43, NULL, 3, 'סקי `99` טיפוס הרים `99`, צניחה חופשית `99`', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 3, 1, NULL),
(1131, 'F1619', 6, 43, NULL, 3, 'גלישת גלים `99`, טיול לקוטב `99`, אופני שטח `99`', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 3, 1, NULL),
(1132, 'F1615', 6, 43, NULL, 3, 'ספורטאית `99`, יודעת לבשל `99`, אמנית יוצרת `99`', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 4, 1, NULL),
(1133, 'F1616', 6, 43, NULL, 3, 'רקדנית `99`, נהגת משאית `99`, שוטרת `99`', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 4, 1, NULL),
(1134, 'F1606', 6, 43, NULL, 3, 'מציעים לך משכורת מובטחת לכל החיים תמורת ויתור על לימודיםקריירה. מה הסכום  החודשי ברוטו שפחות ממנו לא תסכים לעיסקה?', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 4, 1, NULL),
(1135, 'F1607', 6, 43, NULL, 3, 'מציעים לך משכורת מובטחת לכל החיים תמורת ירידה מהארץ. מה הסכום  החודשי ברוטו שפחות ממנו לא תסכים לעיסקה?', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 4, 1, NULL),
(1136, 'F1608', 6, 43, NULL, 3, 'לגרום לה לצחוק `99`, לפנק אותה בליטופים `99`, להקשיב לה `99` ', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 4, 1, NULL),
(1137, 'F1609', 6, 43, NULL, 3, 'לקנות לה מתנות `99`, לקחת אותה לטיולים מושקעים `99`, להעריף עליה תשומת לב', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 4, 1, NULL),
(1138, 'F1610', 6, 43, NULL, 3, 'להחמיא לה על הלוק שלה `99`, להחמיא לה על השכל שלה `99`, להחמיא לה על האישיות שלה `99`', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 4, 1, NULL),
(1139, 'F1611', 6, 43, NULL, 3, 'נניח שיש מסיבת חברים והגיע הקטע שכל אחד חייב לתת 2-3 דקות הופעה, לא משנה מה. במה תופיע?', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 4, 1, NULL),
(1140, 'F1597', 6, 43, NULL, 3, 'ספר על גבר (ידוע) אחד שמרשים אותך כל כך עד שאתה אומר \"אני מת להיות כמוהו\"', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 2, 1, NULL),
(1141, 'F1564', 6, 43, NULL, 3, 'בחר שתי תכונות שהכי נחשבות בעיניך מהרשימה: מלאת השראה, מהפנטית, אמיצה, מבריקה, יודעת להקשיב, יודעת להתלבש', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 4, 1, NULL),
(1142, 'F1565', 6, 43, NULL, 3, 'אהבה היא: מסובכת, מדהימה, מפחידה, אוויר לנשימה, מכאיבה, עיוורת. בחרי מהרשימה (או הוסיפי משלך)', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 4, 1, NULL),
(1143, 'F1519', 6, 43, NULL, 3, 'אילו שלושה דברים הכי מעצבנים אותך בחיים?', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 3, 1, NULL),
(1144, 'F1559', 6, 43, NULL, 3, 'אם תוכל לסגור חשבון עם מישהו מהעבר שפגע בך שלא בצדק, על מה ועם מי זה יהיה? ', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 3, 1, NULL),
(1145, 'F1650', 6, 43, NULL, 3, 'דרגי עד כמה בא לך שההרפתקאה הבאה שלך תהיה ב: סגת האוורסט `99`, ג\'ונגלים בברזיל `99`, טיסה לירח `99`, ', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 4, 1, NULL),
(1146, 'F1651', 6, 43, NULL, 3, 'דרג עד בא לך שההרפתקאה הבאה שלך תהיה ב: אנטארקטיקה `99`, צלילה בקרקעית הים `99`, ראפטינג בצרפת `99`', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 4, 1, NULL),
(1147, 'F1698', 6, 43, NULL, 3, 'יש קריוקי ואתה חייב לשיר. באיזה שיר תבחר? באיזה שיר חליפי?', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 4, 1, NULL),
(1148, 'F1700', 6, 43, NULL, 3, 'מה התכניות שלך לסוף השבוע הקרוב?', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 3, 1, NULL),
(1149, 'F1704', 6, 43, NULL, 3, 'נסיעה באופניים `99`, טיול בחוף הים `99`, לתפוס תנומה `99`, להמשיך לשחק איתך `99`', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 4, 1, NULL),
(1150, 'F1706', 6, 43, NULL, 3, 'נניח שהיתה לך מילגה חלומית ללמוד איפה שתרצה ומה שתרצה. מה היית לומד, ואיפה?', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 4, 1, NULL),
(1151, 'F1389', 6, 43, NULL, 3, 'מה אתם רוצים להיות כשתהיו \"גדולים\"?', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 2, 1, NULL),
(1152, 'F1419', 6, 43, NULL, 3, 'מה בא לך לחלוק?', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 4, 1, NULL),
(1153, 'F1386', 6, 43, NULL, 3, 'עד כמה חשוב, קרם, פייסבוק, רמקולים, כנות', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 4, 1, NULL),
(1154, 'F1547', 6, 43, NULL, 3, 'בוקר. אתה עומד לצאת מהבית, ולפתע מודיעים לך שהפגישה נדחתה בשעתיים. איך תעביר את הזמן בבית?', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 3, 1, NULL),
(1155, 'F1551', 6, 43, NULL, 3, 'עגילים - `99`, ענק - `99`, צמידים - `99`, פירסינג - `99`', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 3, 1, NULL),
(1156, 'F1552', 6, 43, NULL, 3, 'קיבלת יום חופש! פראי ומשוגע - `99`, תרגעו כולכם, קודם אני שותה קפה - `99`, מרתון סדרות ב VOD - `99`', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 3, 1, NULL),
(1157, 'F1553', 6, 43, NULL, 3, 'מהו הדייט השני האידיאלי בעיניך? דרג מ 1 עד 10', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 4, 1, NULL),
(1158, 'F1554', 6, 43, NULL, 3, 'נשלחת למשימה במאדים על ידי נאסא. אילו שלושה דברים תקח איתך לחללית?', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 4, 1, NULL),
(1159, 'F1536', 6, 43, NULL, 3, 'איזה בילוי הכי מועדף עליך כשאתה עם החבר\'ה שלך?', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 3, 1, NULL),
(1160, 'F1537', 6, 43, NULL, 3, 'נניח שאתה יוצא לדייט חשוב וקיבלת תקציב בלתי מוגבל לקנות בגדים. מה תלבש?', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 3, 1, NULL),
(1161, 'F1538', 6, 43, NULL, 3, 'עם `99` אדבר על בעיות בזוגיות, עם `99` אדבר על כסף, עם `99` אדבר על הפנטזיות שלי', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 3, 1, NULL),
(1162, 'F1539', 6, 43, NULL, 3, 'באילו נושאים אתם עקשנים ומתקשים לוותר?', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 1, 1, NULL),
(1163, 'F1511', 6, 43, NULL, 3, 'דרג מה חשוב בחיים - הישגיות בקריירה `99`, רומנטיקה `99`, חברים טובים `99`', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 3, 1, NULL),
(1164, 'F1512', 6, 43, NULL, 3, 'דרג מ 1 עד 10 מה חשוב בחיים קארמה `99`, פרופורציות `99`, אוכל `99`, משפחה `99`', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 3, 1, NULL),
(1165, 'F1717', 6, 43, NULL, 3, 'מסאז\' עם שמן `99`, ארוחה במסעדה על צוק בגרנד קניון `99`, לשבת ביציע המכובדים בגמר המונדיאל `99`', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 4, 1, NULL),
(1166, 'F1721', 6, 43, NULL, 3, 'אתה צריך לקרוא לסופה בשם של אדם שאתה שונא. מה השם, ומדוע אתה שונא אותואותה?', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 2, 1, NULL),
(1167, 'F1786', 6, 43, NULL, 3, 'אתם צריכים לארגן פעילות לדייט הבא שלכם. איך נראות לכם ההצעות הבאות?', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 4, 1, NULL),
(1168, 'F1810', 6, 43, NULL, 3, 'עד כמה תסכימו להיות בניבנות זוג של: חשפנית `99`, דוגמנית בינלאומית `99`, מדריכת טיולים לחו\"ל `99`', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 4, 1, NULL),
(1169, 'F1722', 6, 44, NULL, 3, 'האם בכית פעם בגלל פרידה? אם כן, באילו נסיבות?', 0, 1, 1, 18, 99, 4, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 3, 1, NULL),
(1170, 'F1723', 6, 44, NULL, 3, 'האם בכית פעם בגלל שהפסדת הזדמנות? על מה? ואם לא, איך הגבת אל הפסד הזדמנות?', 0, 1, 1, 18, 99, 4, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 3, 1, NULL),
(1171, 'F1724', 6, 44, NULL, 3, 'האם בכית פעם בגלל מוות? באילו נסיבות?', 0, 1, 1, 18, 99, 5, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 3, 1, NULL),
(1172, 'F1725', 6, 44, NULL, 3, 'האם בכית פעם בגלל ריב עם ההורים? אם כן, באילו נסיבות?', 0, 1, 1, 18, 99, 4, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 3, 1, NULL),
(1173, 'F1672', 6, 45, NULL, 3, 'האם היה מקרה שבו פסלת מישהי מראש בגלל משהו (שאינו צורה חיצונית)? אם כן, בגלל מה?', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 3, 1, NULL),
(1174, 'F1592', 6, 45, NULL, 3, 'אתה יוצא לבליינד דייט והיא מבקשת שאתה תבחר לבדך את מקום ואופי הבילוי - מה תבחר?', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 3, 1, NULL),
(1175, 'F1593', 6, 45, NULL, 3, 'באוניברסיטה! דרג מ 1 עד 10 איזה דייט מועדף עליך. מפגש בהפסקה בקפיטריה `99`, פתקים תוך כדי שיעור `99`, לימוד זוגי ביחד למבחן `99`', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 2, 1, NULL),
(1176, 'F1594', 6, 45, NULL, 3, 'אני מוכן לצאת עם מישהי מקסימום `99` שנים מעל, ומקסימום `99` שנים מתחת לגילי. ', 0, 1, 1, 18, 99, 4, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 4, 1, NULL),
(1177, 'F1599', 6, 45, NULL, 3, '`99` סיכוי שאצא עם פצצה אבל מטומטמת, `99` אחוז סיכוי שאצא עם חדת לשון שתמיד מנצחת בויכוח, `99` סיכוי שאצא עם ביישנית במיוחד', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 5, 1, NULL),
(1178, 'F1425', 6, 46, NULL, 3, 'כמה זמן מותר לאחר לדייט, מבלי שזה נחשב איחור?', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 2, 1, NULL),
(1179, 'F1264', 6, 46, NULL, 3, 'אחרי כמה זמן לצפות לבלעדיות בקשר?', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 5, 1, NULL),
(1180, 'F1265', 6, 46, NULL, 3, 'תסכים לצאת לשני דייטים במקביל?', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 5, 1, NULL),
(1181, 'F1266', 6, 46, NULL, 3, 'האם תסכים אם תדע שהיא קבעה דייט נוסף אחריך?', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 5, 1, NULL),
(1182, 'F1267', 6, 46, NULL, 3, 'דייט איכותי? הופעה, לנקות דירה, להתעמל ביחד', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 4, 1, NULL),
(1183, 'F1049', 6, 46, NULL, 3, 'להתאהב באמת זה `999`', 0, 1, 1, 18, 99, 4, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 3, 1, NULL),
(1184, 'F1051', 6, 46, NULL, 3, 'מה אתה אומר על המשפט: \"נשים אוהבות שגברים מתאמצים לכבוש אותן, כי הן לא אלא רוצה שהגבר יקבל שום דבר בחינם\". ', 0, 1, 1, 18, 99, 5, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 2, 1, NULL),
(1185, 'F1052', 6, 46, NULL, 3, 'מה אתה אומר על המשפט: \"גברים שמשחקים נכון את המשחק, יצליחו לכבוש יותר בחורות\"', 0, 1, 1, 18, 99, 5, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 2, 1, NULL),
(1186, 'F1812', 6, 46, NULL, 3, 'עד כמה המקצועות הבאים מיותרים בעיניך', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 4, 1, NULL),
(1187, 'F1813', 6, 46, NULL, 3, 'עד כמה חלומות יכולים לחזות את העתיד, או מנבאים את התשוקות הפנימיות שלנו? מה דעתך?', 0, 1, 1, 18, 99, 5, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 3, 1, NULL),
(1188, 'F1598', 6, 47, NULL, 3, '`99` אחוז סיכוי שאצא עם גיק מחשבים, `99` סיכוי שאצא עם ערס עם שרשראות, `99` סיכוי שאבחר בשרירן מנופח', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 5, 1, NULL),
(1189, 'F1479', 6, 49, NULL, 3, 'לוס אנג\'לס `99`, סניף של H&M `99`, סניף של איקאה `99`', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 3, 1, NULL),
(1190, 'F1480', 6, 49, NULL, 3, 'טיפול פסיכולוגי `99`, טיפול כירופרקטי `99`, טיפול קוסמטי `99`', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 3, 1, NULL),
(1191, 'F1231', 6, 50, NULL, 3, 'מה אתה עושה כשאתה רואה ג\'וק?', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 3, 1, NULL),
(1192, 'F1232', 6, 50, NULL, 3, 'הכיור עולה על גדותיו בגלל סתימה. תתקנו לבד?', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 3, 1, NULL),
(1193, 'F1233', 6, 50, NULL, 3, 'אופס, באמצע נסיעה, פנצ\'ר. תתקן לבד? ', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 2, 1, NULL),
(1194, 'F1234', 6, 50, NULL, 3, 'הכפתור בחולצה נתלש', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 3, 1, NULL),
(1195, 'F1235', 6, 50, NULL, 3, 'צריך לתלות תמונה', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 2, 1, NULL),
(1196, 'F1236', 6, 50, NULL, 3, 'המחשב מקרטע', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 2, 1, NULL),
(1197, 'F1047', 6, 51, NULL, 3, 'למה אתה מתגעגע?', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 2, 1, NULL),
(1198, 'F1048', 6, 51, NULL, 3, 'עד כמה מרתיעה אותך (או מושכת אותך) מישהי שבפוקוס חזק על הלוק שלה (שיער, בגדים, מוצרי טיפוח וכו\'..) ', 0, 1, 1, 18, 99, 4, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 2, 1, NULL),
(1199, 'F1040', 6, 51, NULL, 3, 'ליטוף בעורף `99`, נשיקה בצוואר `99`, דגדוג בבטן `99`, לחיצות בכף הרגל `99`', 0, 1, 1, 18, 99, 4, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 2, 1, NULL),
(1200, 'F1041', 6, 51, NULL, 3, 'עם מי אתם מתייעצים בבחירת הבגדים התחתונים שלכם?', 0, 1, 1, 18, 99, 4, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 2, 1, NULL),
(1201, 'F1034', 6, 51, NULL, 3, 'איזה חוק שאינו קיים בספר החוקים, היית מחוקק בעצמך לו יכולת?', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 3, 1, NULL),
(1202, 'F1032', 6, 51, NULL, 3, 'אם יציעו לי אני אבחר להשתתף בתכנית הריאליטי `99`, להיות במאי של התכנית `99`, ולשמש בערוץ 2 ככתב לענייני `99`', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 3, 1, NULL),
(1203, 'F1007', 6, 51, NULL, 3, 'בחתונה, האם אתם בקטע של לימוזינה ופאר, או משהו צנוע יותר?', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 3, 1, NULL),
(1204, 'F1015', 6, 51, NULL, 3, 'האם אתה מרגיש טוב עם זה שהחברה שלך תצא לפגישות עם ידידים גברים אחד על אחד, רק שניהם, בערב?', 0, 1, 1, 18, 99, 5, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 4, 1, NULL),
(1205, 'F1024', 6, 51, NULL, 3, 'איזה דבר אחד יכול לעשות לך טרן אוף אצל אישה?', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 4, 1, NULL),
(1206, 'F1009', 6, 51, NULL, 3, 'באיזה אופן הכי קל לך להתבטא ולתקשר מול גבראישה שאתה לא מכירהה? ', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 3, 1, NULL),
(1207, 'F1492', 6, 51, NULL, 3, 'כשאני פוגש מישהי חדשה `99` חשובה ההופעה שלה, `99` חשובה לי האישיות שלה, `99` חשוב לי החיוך שלה', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 4, 1, NULL),
(1208, 'F1505', 6, 51, NULL, 3, 'אם אתה חייב לבחור, עדיף שהיא תהיה ספונטנית, או מסתורית?', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 2, 1, NULL),
(1209, 'F1506', 6, 51, NULL, 3, 'אם אתה חייב לבחור, עדיף שהיא תהיה יודעת להקשיב, או יודעת לדבר?', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 3, 1, NULL),
(1210, 'F1507', 6, 51, NULL, 3, 'האם עדיף שאתה תהיה כל העולם שלה, או שיהיו לה תחומי עניין שיעסיקו אותה גם בלעדיך?', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 1, 1, NULL),
(1211, 'F1494', 6, 51, NULL, 3, 'סיאנסים (העלאת המתים) `99`, קלפי טארוט `99`, נומרולוגיה `99`', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 3, 1, NULL),
(1212, 'F1502', 6, 51, NULL, 3, 'מה בא לך יותר היום? מפגש עם חברים הכולל שיחות עם כמה אנשים, או מפגש מעמיק אחד על אחד?', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 4, 1, NULL),
(1213, 'F1503', 6, 51, NULL, 3, 'מה בא לך יותר עכשיו? לראות הופעה בפארק, או לצאת לבר עם חברים? ', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 4, 1, NULL),
(1214, 'F1531', 6, 51, NULL, 3, 'מה הכי כדאי לעשות מייד אחרי השחרור מצה\"ל? טיול גדול (איפה?), לימודים, סתם לחיות?', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 2, 1, NULL),
(1215, 'F1549', 6, 51, NULL, 3, 'היום - בית עם גינה או פנטהאוז במרכז העיר? ועוד 10 שנים? ', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 2, 1, NULL),
(1216, 'F1542', 6, 51, NULL, 3, 'איזו קריירה אתה חושב שהכי מתאימה לך? ', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 2, 1, NULL),
(1217, 'F1543', 6, 51, NULL, 3, 'עד כמה בא לך להיות \"הבוס\" ולנהל אחרים? ', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 2, 1, NULL),
(1218, 'F1544', 6, 51, NULL, 3, 'אתה בקניון ועכשיו קיבלת 1,000 ₪. על מה תבזבז אותם?', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 3, 1, NULL),
(1219, 'F1475', 6, 51, NULL, 3, 'שוקולד או תותים? לדבר או להקשיב? תאילנד או יפן? ', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 3, 1, NULL),
(1220, 'F1476', 6, 51, NULL, 3, 'לראות הצגה או משחק כדורגל? לרוץ או ללכת? טלוויזיה או קולנוע? ', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 3, 1, NULL),
(1221, 'F1477', 6, 51, NULL, 3, 'לעצב מכונית או לעצב בית? `99`, לגור בתל אביב או בגליל? `99`, לתכנן טיול מראש, או ספונטני? `99`', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 3, 1, NULL),
(1222, 'F1478', 6, 51, NULL, 3, 'בוקר או לילה? `99`, טיול אוהלים במדבר או מלון ספא באילת? `99`, אפל או אנדרואיד? `99`', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 3, 1, NULL),
(1223, 'F1464', 6, 51, NULL, 3, 'לראות טלוויזיה או להקשיב למוסיקה? `99`, חופשה בהרים או חופשה על החוף? `99` להיות רואה ואינו נראה, או קורא מחשבות? `99`', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 1, 1, NULL),
(1224, 'F1465', 6, 51, NULL, 3, 'בחור קרח או עם שערות בגב ובכתפיים? `99`, בחור נמוך ומצחיק או גבוה ויבשוש? `99`, מוות בטביעה או מוות בתליה?', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 3, 1, NULL),
(1225, 'F1591', 6, 51, NULL, 3, 'כמה נכון המשפט -  \"הרבה גברים נמשכים דווקא לבנות שמתעללות בהם רגשית?\"', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 2, 1, NULL),
(1226, 'F1601', 6, 51, NULL, 3, 'אילו סוגי מדים (כל סוג של בגדי עבודה) עושים לך את זה אצל אישה?', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 4, 1, NULL),
(1227, 'F1602', 6, 51, NULL, 3, 'עד כמה גברים בסטאטוס חברתיניהולי גבוה, או עמדת כוח, עושים לך את זה? ', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 3, 1, NULL),
(1228, 'F1620', 6, 51, NULL, 3, 'בילוי טוב זה:', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 2, 1, NULL),
(1229, 'F1621', 6, 51, NULL, 3, 'מה בא לך עכשיו? פרפרים בבטן, או נוחות ורוגע? ומה אתה מתכוון לעשות כדי להשיג את זה?', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 2, 1, NULL),
(1230, 'F1625', 6, 29, NULL, 3, 'מישהי שאתה יוצא איתה כבר חודש מביאה לך בהפתעה מתנה ארוזה. מה תרצה שיהיה בקופסא?', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, '2024-11-18 15:36:45', '2024-11-18 15:36:45', 3, 1, NULL),
(1231, 'F1626', 6, 51, NULL, 3, 'נשיקה חושנית `99`, מיקס ערוך של שירים יפים `99`, שוקולד בלגי', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 3, 1, NULL),
(1232, 'F1627', 6, 51, NULL, 3, 'טיול בשדה בגשם `99`, מסיבת הפתעה `99`, גור כלבים `99`', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 3, 1, NULL),
(1233, 'F1629', 6, 51, NULL, 3, 'עד כמה היית רוצה לעבוד במקצועות הבאים: (מאוד, קצת, בכלל לא ,וכו\'...) ', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 3, 1, NULL),
(1234, 'F1630', 6, 51, NULL, 3, 'עד כמה היית רוצה לעבוד במקצועות הבאים: (מאוד, קצת, בכלל לא ,וכו\'...) ', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 3, 1, NULL),
(1235, 'F1631', 6, 51, NULL, 3, 'עד כמה היית רוצה לעבוד במקצועות הבאים: (מאוד, קצת, בכלל לא , וכו\'...) ', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 3, 1, NULL),
(1236, 'F1604', 6, 51, NULL, 3, 'אם גבר מוצא חן בעיניך, האם תתחילי איתו ישירות, או שמקסימום תפילי מטפחת ותקווי שהוא ימשיך את העבודה משם?', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 4, 1, NULL),
(1237, 'F1634', 6, 51, NULL, 3, 'האם אתה מוכן להיות עם מישהי ש: יש לה טעם רע בבגדים `99`, היא קנאית `99`, לוקחת את כל השמיכה בחורף `99` ', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 4, 1, NULL),
(1238, 'F1586', 6, 51, NULL, 3, 'איפה אתה חולםת להתחתן? תןי ציון מ 1 עד 10 ללוקיישנים הבאים:', 0, 1, 1, 18, 99, 4, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 3, 1, NULL),
(1239, 'F1584', 6, 51, NULL, 3, 'במקום הראשון `99`, במקום השני `99`, במקום השלישי `99` ', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 4, 1, NULL),
(1240, 'F1661', 6, 51, NULL, 3, 'לשאוב אבק `99`, לכבס ולתלות כביסה `99`, לשטוף כלים `99`', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 4, 1, NULL),
(1241, 'F1662', 6, 51, NULL, 3, 'לשפוך את הפח `99`, לשטוף את הבית `99`, לסדר את חדר עבודה `99`', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 4, 1, NULL),
(1242, 'F1667', 6, 51, NULL, 3, 'דרג מהרשימה, עד כמה רומנטי כל דבר בעיניך: (מאוד, קצת, בכלל לא, וכו\'...)', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 4, 1, NULL),
(1243, 'F1668', 6, 51, NULL, 3, 'דרג מהרשימה, עד כמה רומנטי כל דבר בעיניך: (מאוד, קצת, בכלל לא, וכו\'...)', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 4, 1, NULL),
(1244, 'F1637', 6, 51, NULL, 3, 'עם איזה שיר היית רוצה להתעורר בבוקר?', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 3, 1, NULL),
(1245, 'F1645', 6, 51, NULL, 3, 'דרגי עד כמה חשובות לך התכונות הבאות אצל בן הזוג: אינטלגנציה רגשית `99`, מסירות `99`, היכולת להיות שרוטה לפעמים `99`', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 3, 1, NULL),
(1246, 'F1709', 6, 51, NULL, 3, 'עד כמה כלי הרכב מחרמן אותך? אופנוע הארלי דווידסון `99`, מרצדס ספורט `99`, רכב שטח 4X4 `99`', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 3, 1, NULL),
(1247, 'F1696', 6, 51, NULL, 3, 'נניח שמציעים לכם עבודה זמנית ליום אחד, דרגו כמה אתם מעוניינים ב: חשפנית `99`, מנחה באח הגדול `99`, מצילה בים `99`', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 3, 1, NULL),
(1248, 'F1692', 6, 51, NULL, 3, 'מה נחשבת הצלחה בעיניך? כסף `99`, לעזור לאחרים `99`, קריירה `99`, אהבה `99`', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 4, 1, NULL),
(1249, 'F1807', 6, 51, NULL, 3, 'איזה שיר תשירי במקלחת הקרובה שלך?', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 3, 1, NULL),
(1250, 'F1808', 6, 51, NULL, 3, 'אתה חמוד `99`, אפשר לדבר איתך כמו חבר טוב `99`, יש לך בייבי פייס `99`', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 4, 1, NULL),
(1251, 'F1809', 6, 51, NULL, 3, 'זה בסדר, אני ממילא לא אוהבת יותר מידי שרירים `99`, אל תהיה לחוץ, דווקא יש לך סבבה `99`, אתה לא כמו כולם `99` ', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 4, 1, NULL),
(1252, 'F1804', 6, 51, NULL, 3, 'יש לך כסף לשני טיפולי מניקור פדיקור, או שני ג\'ינסים, או טלפון סלולרי סיני. במה תבחר? (מותר לך לבקש משהו אחר שעלותו דומה)', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 4, 1, NULL),
(1253, 'F1785', 6, 51, NULL, 3, 'דרגו עד כמה את אוהבים את תחנות הרדיו:', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 4, 1, NULL),
(1254, 'F1825', 6, 51, NULL, 3, 'להיות עשיר `99`, ללמוד דברים חדשים `99`, שיהיו לי חברים טובים שאפשר לסמוך עליהם `99`', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 4, 1, NULL),
(1255, 'F1826', 6, 51, NULL, 3, 'לשמור על כושר גופני טוב `99`, לחלוק את חיי עם מישהי `99`, שיגידו לי תמיד שאני נראה מעולה `99`', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 4, 1, NULL),
(1256, 'F1727', 6, 51, NULL, 3, 'לאיזו מטרה בא לך לתרום כסף?', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 4, 1, NULL),
(1257, 'F1714', 6, 51, NULL, 3, 'אם מותר לך לבחור רק אחד - היית מתקן את החיים האישיים, או המקצועיים שלך? ומה היית מתקן?', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 3, 1, NULL),
(1258, 'F1744', 6, 51, NULL, 3, 'נניח שאתה חייב להפקיד את הגורל שלך בידי מישהו שיקבע הכל עבורך. מי זה יהיה? (בלי הורים)', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 2, 1, NULL),
(1259, 'F1732', 6, 51, NULL, 3, 'הרכב את אשת חלומותיך - בחר 3 תכונות בלבד מהנ\"ל: הומור, כנות, אינטלגנציה, ביטחון עצמי, סקס טוב, מעגל חברתי רחב,  קריירה טובה', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 4, 1, NULL),
(1260, 'F1733', 6, 51, NULL, 3, 'אשת חלומותי תהיה `99`, וגם `99`, וחייבת להיות `99`', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 4, 1, NULL),
(1261, 'F1789', 6, 51, NULL, 3, 'האם לגור עם ההורים זה לא בא בחשבון, או שזה דווא יכול להתאים לפעמים כדי לחסוך כסף?', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 3, 1, NULL),
(1262, 'F1720', 6, 51, NULL, 3, 'ביקור במוזיאון אמנות `99`, הרצאה על פיסיקת קוונטים `99`, סיור באתר חפירות ארכיאולוגיות `99`', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 3, 1, NULL),
(1263, 'F1758', 6, 51, NULL, 3, 'במשפט אחד - מהי תכנית 5 השנים שלך?', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 2, 1, NULL),
(1264, 'F1759', 6, 51, NULL, 3, 'תאר את ארוחת הבוקר שלך', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 4, 1, NULL),
(1265, 'F1823', 6, 52, NULL, 3, 'תאר הרגל יומיומי שמרגיע אותך', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 3, 1, NULL),
(1266, 'F1799', 6, 52, NULL, 3, 'עד כמה אתה מפונקת? אני אוהב לטייל טיולי אוהלים `99`, אני יכול להירדם גם על הרצפה `99`, אני מתקלח גם אם אין מים חמים `99`', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 4, 1, NULL),
(1267, 'F1003', 6, 52, NULL, 3, 'אני מביא שקיות מהבית כדי לא לבזבז שקיות חדשות מהסופרמרקט `99`, אני מדפיס מסמכים משני צידי הנייר במדפסת `99`, אני מתקלח מקלחת קצרה לחסוך במים `99`', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 4, 1, NULL),
(1268, 'F1004', 6, 52, NULL, 3, 'כל חודש אני שם כסף בצד `99`, אני יודע בדיוק כמה אני מבזבז בשבוע על מותרת `99`, אני משתדל לקנות בגדים בסיילים ובסופי עונה `99`', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 4, 1, NULL),
(1269, 'F1014', 4, 4, NULL, 3, 'אילו אפליקציות אתה בודק בסלולרי דבר ראשון אחרי שאתה מתעורר בבוקר?', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2024-04-16 09:24:50', 2, 1, NULL),
(1270, 'F1016', 6, 52, NULL, 3, 'איך אתם ישינים? על הגב, על הבטן, על הצד? עם כמה כריות, וכמה פעמים אתם מתעוררים בלילה?', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 4, 1, NULL),
(1271, 'F1053', 6, 52, NULL, 3, 'אני בוחש את הקפה `99` סיבוב השעון, אני מוריד מכנסיים (בישיבה או עמידה) ב`99`, וכשאני מסיים להתקלח אני קודם כל מנגב את ה`99`', 0, 1, 1, 18, 99, 4, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 4, 1, NULL),
(1272, 'F1251', 6, 52, NULL, 3, 'כמה זוגות נעליים יש לך בטוטאל?', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 4, 1, NULL),
(1273, 'F1257', 6, 52, NULL, 3, 'איך אתה אוהב לעשות כושר?', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 2, 1, NULL),
(1274, 'F1258', 6, 52, NULL, 3, 'האם קרה לך שהיית עצבני ואיבדת את זה לגמרי? אם כן, מה עיצבן אותך?', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 3, 1, NULL),
(1275, 'F1259', 6, 52, NULL, 3, 'אתה לא נרדם בלילה, איך אתה מעביר את הזמן?', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 4, 1, NULL),
(1276, 'F1260', 6, 52, NULL, 3, 'מה תנשנש במצב רוח רע?', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 4, 1, NULL),
(1277, 'F1427', 6, 53, NULL, 3, 'מה הדבר המוזר ביותר שאכלת אי פעם בחופשה?', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 2, 1, NULL),
(1278, 'F1428', 6, 53, NULL, 3, 'איפה היתה החופשה הגרועה ביותר שהיתה לך? למה היא היתה כל כך גרועה?', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 3, 1, NULL),
(1279, 'F1429', 6, 53, NULL, 3, 'איפה היתה החופשה הטובה ביותר שהיתה לך? מה עשה אותה כל כך טובה?', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 2, 1, NULL),
(1280, 'F1431', 6, 53, NULL, 3, 'באילו ארצות כבר ביקרת? יאללה לשפוך... ', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 4, 1, NULL),
(1281, 'F1701', 6, 54, NULL, 3, 'חטאים', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 4, 1, NULL),
(1282, 'F1702', 6, 54, NULL, 3, 'האם אתה מודה שחטאת בעבר באחד מהחטאים האלה: (מודה, לא מודה, קצת וכו\'... )', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 4, 1, NULL),
(1283, 'F1708', 6, 54, NULL, 3, 'ספר על איסור חמור שאתה משתוקק מאוד  להפר אותו', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 4, 1, NULL),
(1284, 'F1487', 6, 55, NULL, 3, 'האם היה לך חלום שהספקת לממש? כם כן, מהו?', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 2, 1, NULL),
(1285, 'F1204', 6, 56, NULL, 3, 'האם יש החלטה שלקחתם אתמול שהתחטרתם עליה? ', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 1, 1, NULL),
(1286, 'F1054', 6, 59, NULL, 3, 'חמאת בוטנים `99`, דבש `99`, טחינה `99`, ריבה `99`', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 3, 1, NULL),
(1287, 'F1018', 6, 59, NULL, 3, 'אילו שלושה מאכלים אין סיכוי שתאכל', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 3, 1, NULL);
INSERT INTO `net_tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES
(1288, 'F1022', 6, 59, NULL, 3, 'אני ממליץ לך לראות את הסרט `999`, ואת סדרת הטלוויזיה `999`', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 4, 1, NULL),
(1289, 'F1023', 6, 59, NULL, 3, 'אני ממליץ לך על הפאבבר `999` כי הוא `999`, ועל המסעדה `999` בגלל `999`', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 4, 1, NULL),
(1290, 'F1029', 6, 59, NULL, 3, 'מהי המתנה הכי לא שווה ולא מתאימה שקיבלת? ', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 3, 1, NULL),
(1291, 'F1283', 6, 59, NULL, 3, 'איזה משקה אתה אוהב לשתות בפאב?', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 3, 1, NULL),
(1292, 'F1284', 6, 59, NULL, 3, 'שיר שאתה אוהב בפאב', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 3, 1, NULL),
(1293, 'F1285', 6, 59, NULL, 3, 'איזה דייט יותר איכותי בעיניך? פאב, בית קפה, או ספסל בפארק? ', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 3, 1, NULL),
(1294, 'F1287', 6, 59, NULL, 3, 'איזו בירה אתה שותה?', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 3, 1, NULL),
(1295, 'F1288', 6, 59, NULL, 3, 'זאנר סרטים אקסטרימי שאתם אוהבים', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 3, 1, NULL),
(1296, 'F1377', 6, 59, NULL, 3, 'איזה שיר רומנטיקיטשי אתה הכי אוהב?', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 3, 1, NULL),
(1297, 'F1383', 6, 59, NULL, 3, 'האם אתה אוהב להירדם עם מוסיקה? אם כן, איזה סוג?', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 4, 1, NULL),
(1298, 'F1684', 6, 59, NULL, 3, 'תאר עד כמה אתה אוהב דברים לא בריאים בחגים: (אוהב מאוד, בכלל לא, קצת, וכו\'...)', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 4, 1, NULL),
(1299, 'F1762', 6, 59, NULL, 3, 'מה דעתך לגבי הריחות הבאים? (כל מילת תואר שעולה לך בראש)', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 3, 1, NULL),
(1300, 'F1764', 6, 59, NULL, 3, 'כמה זה נכון? (לא נכון, קצת, נכון מאוד וכו\'...) ', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 3, 1, NULL),
(1301, 'F1237', 6, 60, NULL, 3, 'יודע להכין פסטה ברוטב, סטייק, שניצל. ', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 4, 1, NULL),
(1302, 'F1238', 6, 60, NULL, 3, 'יודע להכין עוגה, סלט פירות, טירמיסו', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 4, 1, NULL),
(1303, 'F1239', 6, 60, NULL, 3, 'יודע להכין מרק עדשים, לטגן כרוביות, שקשוקה מהממת. ', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 4, 1, NULL),
(1304, 'F1037', 6, 61, NULL, 3, 'מהו הדבר הכי מצחיק שקרה לך השבוע?', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 3, 1, NULL),
(1305, 'F1043', 6, 61, NULL, 3, 'מהי המחמאה הכי גדולה שמישהו נתן לך בזמן האחרון?', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 3, 1, NULL),
(1306, 'F1693', 6, 61, NULL, 3, 'אני צריך לכוון נודניק `99` פעמים, לוקח לי `99` דקות להתעורר לגמרי ולהתחיל לתפקד, ובדרך כלל המצב רוח שלי בבוקר הוא `99`', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 4, 1, NULL),
(1307, 'F1694', 6, 61, NULL, 3, 'ריצת 5 ק\"מ ב 5 בבוקר `99`, שחיית בוקר לפני העבודה `99`, לקום ב-5 לראות את הזריחה בים `99`', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 4, 1, NULL),
(1308, 'F1695', 6, 61, NULL, 3, 'איך נראות בדרך כלל ארוחות הצהריים שלך? כבדות עם בשר, או סלטים קלילים, או משהו אחר?', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 2, 1, NULL),
(1309, 'F1690', 6, 61, NULL, 3, 'במה אפשר לסמוך עליך?', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 3, 1, NULL),
(1310, 'F1699', 6, 61, NULL, 3, 'הסתכל מבעד לחלון שלידך. מה אתה רואה? ', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 3, 1, NULL),
(1311, 'F1710', 6, 61, NULL, 3, 'אם האוכל במסעדה לא טעים אבל השירות טוב, איזה טיפ תשאיר למלצרית, אם בכלל?', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 3, 1, NULL),
(1312, 'F1658', 6, 61, NULL, 3, 'מה אכלת אתמול לארוחת צהריים? (בבקשה לפרט הכל!)', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 4, 1, NULL),
(1313, 'F1659', 6, 61, NULL, 3, 'מה אכלת אתמול לארוחת ערב? בבקשה לפרט הכל)', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 4, 1, NULL),
(1314, 'F1669', 6, 61, NULL, 3, 'אני שוטף את הבית `99` פעמים בשבוע, מכבס בגדים `99` פעמים בחודש, ומסדר את החדר שלי `99` פעמים בשנה', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 4, 1, NULL),
(1315, 'F1674', 6, 61, NULL, 3, 'ספר על משהו מיוחד ויוצא דופן שעשית השבוע', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 3, 1, NULL),
(1316, 'F1575', 6, 61, NULL, 3, 'האם יצא לך להיות בשנה האחרונה ממש שיכורה? באילו נסיבות?', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 2, 1, NULL),
(1317, 'F1576', 6, 61, NULL, 3, 'כמה שעות אתה ישנה בממוצע בלילה? כמה היית רוצה לישון? ', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 3, 1, NULL),
(1318, 'F1578', 6, 61, NULL, 3, 'את שנתיים באי בודד. קבע דרגת חשיבות מ 1 עד 10  לדברים מהרשימה שלדעתך חשוב שיהיו איתך שם.  ', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 4, 1, NULL),
(1319, 'F1572', 6, 61, NULL, 3, 'מה אתה נוהג לומר לאנשים שמקטרים ומתלוננים כל הזמן? ', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 1, 1, NULL),
(1320, 'F1573', 6, 61, NULL, 3, 'כמה פעמים הכנת בשבועיים האחרונים ארוחת ערב מושקעת? מה הכנת בעיקר? ', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 4, 1, NULL),
(1321, 'F1600', 6, 61, NULL, 3, 'איזה דבר מטופש שאתה מתחרטת עליו, עשית בשבוע האחרון?', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 4, 1, NULL),
(1322, 'F1474', 6, 61, NULL, 3, 'איזה דבר יוצא דופן עשית בחודש האחרון?', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 4, 1, NULL),
(1323, 'F1515', 6, 61, NULL, 3, 'מה גרם לך לחייך ביום יומיים האחרונים?', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 4, 1, NULL),
(1324, 'F1516', 6, 61, NULL, 3, 'מה עיצבן אותך במיוחד בשבוע האחרון?', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 4, 1, NULL),
(1325, 'F1517', 6, 61, NULL, 3, 'מה העציב אותך בשבוע האחרון?', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 4, 1, NULL),
(1326, 'F1518', 6, 61, NULL, 3, 'מה איכזב אותך בשבוע האחרון?', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 4, 1, NULL),
(1327, 'F1541', 6, 61, NULL, 3, 'עם מי התווכחת בשבוע האחרון ועל מה?', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 1, 1, NULL),
(1328, 'F1532', 6, 61, NULL, 3, 'איך אתה מעביר את הזמן כשאתה לבד בבית בערב, אחרי יום עבודה מתיש?', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 3, 1, NULL),
(1329, 'F1528', 6, 61, NULL, 3, 'באיזו דרך אתה נפגש עם הידידות שלך? חיבוק, לחיצת יד, נפנוף לשלום, חיוך, נשיקה בלחי, נשיקה קלה בשפתיים?', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 2, 1, NULL),
(1330, 'F1529', 6, 61, NULL, 3, 'מתי קיללת בפעם האחרונה, ומה היתה הקללה?', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 3, 1, NULL),
(1331, 'F1521', 6, 61, NULL, 3, 'באילו מהאביזרים הלא נוחים הבאים את משתמשת  חשוב להשתמש? נעלי עקב, סידור שיער, איפור.', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 3, 1, NULL),
(1332, 'F1522', 6, 61, NULL, 3, 'אם אתה צריך לצאת ב 8:00 בבוקר מהבית, לאיזו שעה תכוון שעון? ', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 3, 1, NULL),
(1333, 'F1523', 6, 61, NULL, 3, 'אני מתקלח `99` דקות, אחרי המקלחת אני בוחר בגדים ליציאה תוך `99` דקות, ולוקח לי להתלבש ולהתכונן ליציאה `99` דקות ', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 4, 1, NULL),
(1334, 'F1524', 6, 61, NULL, 3, 'אני אוכל ארוחת בוקר ב `99` דקות, מסיים קניה שבועית בסופרמרקט תוך `99` דקות, מצחצח שיניים לפני השינה תוך `99` דקות', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 4, 1, NULL),
(1335, 'F1525', 6, 61, NULL, 3, 'עם כמה כריות אתה ישן? `99`, מזרן רך או קשה? `99`, חלון פתוח או סגור? `99`', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 4, 1, NULL),
(1336, 'F1472', 6, 61, NULL, 3, 'מה הדבר הכי מעודד שקרה לך השבוע?', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 4, 1, NULL),
(1337, 'F1780', 6, 61, NULL, 3, 'ספר על משהו יפה שראית היום', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 4, 1, NULL),
(1338, 'F1755', 6, 61, NULL, 3, 'עד כמה החדר שלך מסודר עכשיו בזה הרגע?', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 4, 1, NULL),
(1339, 'F1800', 6, 61, NULL, 3, 'מה האתגר שלך לשבוע הקרוב?', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 4, 1, NULL),
(1340, 'F1821', 6, 61, NULL, 3, 'מה יושב לך על הלב עכשיו?', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 3, 1, NULL),
(1341, 'F1818', 6, 61, NULL, 3, 'למה החיים שלך יפים? החיים שלי יפים כי `999`, וגם בגלל `999`', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 4, 1, NULL),
(1342, 'F1816', 6, 62, NULL, 3, 'ליד איזה אנשים אתה מרגיש הכי רגוע ושלא שופטים אותך? (ספר על 2-3) ', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 4, 1, NULL),
(1343, 'F1817', 6, 62, NULL, 3, 'האם אתה מדמיין מצב שבו תוותר על מעבר לחו\"ל לקידום בקריירה, בגלל אהבה? האם קרה לך?', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 4, 1, NULL),
(1344, 'F1768', 6, 62, NULL, 3, 'האם יש לך אקסית שאתה חבר שלה בפייסבוק? אם לא, האם יצא לך להציץ בפייסבוק של אקס?', 0, 1, 1, 18, 99, 5, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 3, 1, NULL),
(1345, 'F1769', 6, 62, NULL, 3, 'האם חבר או חברה טובים איכזבו אותך פעם? אם כן, במה?', 0, 1, 1, 18, 99, 4, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 3, 1, NULL),
(1346, 'F1770', 6, 62, NULL, 3, 'האם ידוע לך על מישהו שמקנא בך? אם כן, מדוע הוא מקנא?', 0, 1, 1, 18, 99, 4, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 3, 1, NULL),
(1347, 'F1771', 6, 62, NULL, 3, 'האם יצא לך להכיר מישהי בסיטואציה לא רומנטית, ורק אחרי זמן רב (לפחות כמה חודשים) להרגיש לפתע משיכה אליה?', 0, 1, 1, 18, 99, 5, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 3, 1, NULL),
(1348, 'F1772', 6, 62, NULL, 3, 'עד כמה אתה מרגיש בנוח אם לחברה שלך יש ידידים קרובים?', 0, 1, 1, 18, 99, 4, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 3, 1, NULL),
(1349, 'F1773', 6, 62, NULL, 3, 'מה היתה הפעם האחרונה שבה אמרת למישהו \"מצטער\"?', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 3, 1, NULL),
(1350, 'F1774', 6, 62, NULL, 3, 'האם אתה מרגיש בנוח אם החברה שלך תשמור על קשר עם אקס שלה?', 0, 1, 1, 18, 99, 4, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 4, 1, NULL),
(1351, 'F1793', 6, 62, NULL, 3, 'האם יצא לך להודות שטעית, גם אם חשבת שבכלל לא טעית, רק כדי לסיים באווירה טובה  ויכוח עם אישה?', 0, 1, 1, 18, 99, 4, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 4, 1, NULL),
(1352, 'F1734', 6, 62, NULL, 3, 'על מה תפרק מערכת יחסים?  שקרים `99`, חוסר התאמה בסקס `99`, בעיות תקשורת `99`', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 4, 1, NULL),
(1353, 'F1735', 6, 62, NULL, 3, 'על מה תפרק מערכת יחסים?  ריבים וצעקות `99`, חוסר כבוד `99`, זלזול `99`', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 4, 1, NULL),
(1354, 'F1736', 6, 62, NULL, 3, 'על מה תפרק מערכת יחסים?  היעדר ניצוץ `99`, עסוקה מידי בעבודה `99`, לא מרוויחה מספיק `99`', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 4, 1, NULL),
(1355, 'F1737', 6, 62, NULL, 3, 'אחרי כמה זמן היכרות מותר להגיד \"אני אוהבת אותך\"?', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 4, 1, NULL),
(1356, 'F1738', 6, 62, NULL, 3, 'בשדה תעופה - האם אתם נפרדים במהירות, או מושכים פרידה עם מיליון חיבוקים ונשיקות?', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 3, 1, NULL),
(1357, 'F1739', 6, 62, NULL, 3, 'האם בחורה עשתה לך פעם עוול? אם כן, מהו?', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 3, 1, NULL),
(1358, 'F1740', 6, 62, NULL, 3, 'בזמן שאתה נמצא במערכת יחסים, האם זה בסדר לדעתך לפלרטט עם נשים אחרות?', 0, 1, 1, 18, 99, 4, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 4, 1, NULL),
(1359, 'F1741', 6, 62, NULL, 3, 'בזמן שאתה במערכת יחסים איתו, האם זה בסדר מבחינתך שהיא תפלרטט עם גברים אחרים?', 0, 1, 1, 18, 99, 4, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 4, 1, NULL),
(1360, 'F1751', 6, 62, NULL, 3, 'כשהיית בזוגיות, עד כמה הרגשת  פתוח לדבר על היחסים הזוגיים שלך עם חברים או משפחה?', 0, 1, 1, 18, 99, 4, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 2, 1, NULL),
(1361, 'F1753', 6, 62, NULL, 3, 'האם היתה לך מערכת יחסים שבה התקשית לבטוח בה? אם כן, מדוע?', 0, 1, 1, 18, 99, 4, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 3, 1, NULL),
(1362, 'F1534', 6, 63, NULL, 3, 'האם כילד היית נוהג לאכול כל הזמן \"שניצל ואורז\", או שקיבלת גם אוכל ביתי מושקע יותר? ', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 3, 1, NULL),
(1363, 'F1510', 6, 64, NULL, 3, 'כתבו רעיון לדייט שאינו מקובל בדרך כלל, לדוגמא -  דייט בחנות ספרים תוך כדי בחירת ספר. ', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 3, 1, NULL),
(1364, 'F1798', 6, 65, NULL, 3, 'איך אתה מתנהל עם כספים? אני משלם חשבונות בזמן `99`, אני בודק דפי בנק `99`, אף פעם אין לי מינוס `99`', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 4, 1, NULL),
(1365, 'F1814', 6, 65, NULL, 3, 'נסי להעריך כמה כסף הוצאת בשנה האחרונה על מוצרי טיפוח? (איפור, בושם, קרמים וכו\')', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 5, 1, NULL),
(1366, 'F1561', 6, 66, NULL, 3, 'תאר את הלבוש שלך כשיצאת אתמול בבוקר מהבית.', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 4, 1, NULL),
(1367, 'F1212', 6, 67, NULL, 3, 'אוהב בחורות מאופרות בקפידה?', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 2, 1, NULL),
(1368, 'F1213', 6, 67, NULL, 3, 'בגדים צמודים', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 3, 1, NULL),
(1369, 'F1214', 6, 67, NULL, 3, 'גובה או משקל', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 3, 1, NULL),
(1370, 'F1215', 6, 67, NULL, 3, 'שכל חיטוב', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 3, 1, NULL),
(1371, 'F1395', 6, 68, NULL, 3, 'מה עדיף? שיהיה לה גוף מדהים, אבל טיפשה במיוחד, או גוף ממוצע, וחכמה במיוחד?', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 4, 1, NULL),
(1372, 'F1396', 6, 68, NULL, 3, 'מה עדיף? חיוך מיליון דולר אבל צחוק מעצבן, או חיוך עקום אבל צחוק מקסים ומדבק?', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 3, 1, NULL),
(1373, 'F1398', 6, 68, NULL, 3, 'מה עדיף? יפיפיה ומתחילים איתה, או ממוצעת וכך אין לה פיתויים?', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 4, 1, NULL),
(1374, 'F1756', 6, 69, NULL, 3, 'שלח קישור (למשל ל-youtube) של שיר שמרגיע אותך', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 3, 1, NULL),
(1375, 'F1195', 6, 70, NULL, 3, 'איזה מפורסם היית רוצה להיות?', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 1, 1, NULL),
(1376, 'F1196', 6, 70, NULL, 3, 'איזו דמות מסרט היית רוצה להיות?', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 1, 1, NULL),
(1377, 'F1172', 6, 70, NULL, 3, 'זכית ב 50 מיליון בלוטו 1', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 4, 1, NULL),
(1378, 'F1173', 6, 70, NULL, 3, 'זכית ב 50 מיליון בלוטו 2', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 5, 1, NULL),
(1379, 'F1174', 6, 70, NULL, 3, 'זכית ב 50 מיליון בלוטו 3', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 3, 1, NULL),
(1380, 'F1175', 6, 70, NULL, 3, 'מי יופיע בחתונה שלך?', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 2, 1, NULL),
(1381, 'F1176', 6, 29, NULL, 3, 'עם מי תרצה להיתקע במעלית?', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, '2024-11-18 15:29:15', '2024-11-18 15:29:15', 4, 1, NULL),
(1382, 'F1177', 6, 70, NULL, 3, 'עם מי בא לך לשתות עכשיו קפה?', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 4, 1, NULL),
(1383, 'F1581', 6, 71, NULL, 3, 'האם יצא לך פעם שחזית משהו והוא התגשם במדויק באופן מפתיע? אם כן, מה זה היה?', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 2, 1, NULL),
(1384, 'F1582', 6, 71, NULL, 3, 'אני `99`  מאמין בגלגול נשמות, אני `99` מאמין ברוחות, אני `99` מאמין בטלפתיה', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 3, 1, NULL),
(1385, 'F1583', 6, 71, NULL, 3, 'אני `99`  מאמין בגן עדן וגיהנום, אני `99` מאמין בגורל קבוע מראש, אני `99` מאמין בתקשורת עם המתים', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 3, 1, NULL),
(1386, 'F1632', 6, 73, NULL, 3, 'מתי היתה הפעם האחרונה שאמא שלך קנתה לך בגדים? מה היא קנתה?', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 3, 1, NULL),
(1387, 'F1473', 6, 73, NULL, 3, 'ההבדל ביני לבין אבא שלי הוא:', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 4, 1, NULL),
(1388, 'F1468', 6, 73, NULL, 3, 'מה הדבר הכי שרוט שאתם יכולים להגיד על המשפחה שלכם בכמה מילים?', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 3, 1, NULL),
(1389, 'F1535', 6, 73, NULL, 3, 'איזה בילוי הכי מועדף עליך כשאתה עם המשפחה שלך?', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 3, 1, NULL),
(1390, 'F1530', 6, 75, NULL, 3, 'מודיעים לך בהפתעה שקיבלת את עבודת החלומות שלך. איך תגיב? (למשל, ניתור ביחד עם \"יש!\" או רק חיוך סיפוק וכו\'...)', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 2, 1, NULL),
(1391, 'F1460', 6, 75, NULL, 3, 'החולצה היפה הלבנה נצבעה בכביסה `99`, הכתימו לי את החולצה הלבנה ביין אדום `99`, מכונית השפריצה עלי כשעברתי ליד שלולית', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 3, 1, NULL),
(1392, 'F1462', 6, 75, NULL, 3, 'התפשטתי ואז גיליתי שאין מים חמים במקלחת `99`, סיימתי את כל ההכנות לבישול אבל בדיוק נגמר הגז `99`, מילאתי עגלה בסופר, ואז ראיתי ששכחתי את הארנק בבית', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 3, 1, NULL),
(1393, 'F1436', 6, 75, NULL, 3, 'אם היית עף על עצמך באופן מוגזם, איך היית מתאר את עצמך בחצי משפט?', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 2, 1, NULL),
(1394, 'F1439', 6, 75, NULL, 3, 'בתוך מציאות של איזה סרט קולנוע מתחשק לך לחיות את החיים?', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 3, 1, NULL),
(1395, 'F1440', 6, 75, NULL, 3, 'יש לך אפשרות לקנות מכונית חדשה בלי מגבלת כסף, איזה רכב תקנה?', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 3, 1, NULL),
(1396, 'F1441', 6, 75, NULL, 3, 'יש לך אפשרות לשנות תכונה אחת שלך, איזו תכונה תשנה?', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 3, 1, NULL),
(1397, 'F1442', 6, 75, NULL, 3, 'בעוד 10 שנים מהיום, במה אתה רואה את עצמך עוסק?', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 2, 1, NULL),
(1398, 'F1443', 6, 75, NULL, 3, 'נניח שיש לך אפשרות להעלים כמה שעות מהיומן שלך בשבוע הקרוב, מה תמחק?', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 4, 1, NULL),
(1399, 'F1444', 6, 75, NULL, 3, 'נניח שהיה אפשר לענות לך במדויק על שאלה אחת מכל סוג שעולה לך בראש. איזו שאלה תשאלי?', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 3, 1, NULL),
(1400, 'F1445', 6, 75, NULL, 3, 'איזו מיומנות וירטואוזית הכי בא לך שתהיה לך?', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 3, 1, NULL),
(1401, 'F1446', 6, 75, NULL, 3, 'יש לך אפשרות לקרוא מחשבות של מישהו. מי זה יהיה?', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 2, 1, NULL),
(1402, 'F1399', 6, 75, NULL, 3, 'האם אתם מאמינים שיש דבר כזה \"נפש תאומה\"?', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 3, 1, NULL),
(1403, 'F1403', 6, 75, NULL, 3, 'העתיקו לכאן הודעה כלשהי שכתבתם, שמייצגת את מצב הרוח שלכם היום', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 3, 1, NULL),
(1404, 'F1404', 6, 75, NULL, 3, 'עד כמה זה נכון, שאפשר להתאהב באדם יותר בזמן שהוא מפגין חולשה ופגיעות? ', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 2, 1, NULL),
(1405, 'F1405', 6, 75, NULL, 3, 'אם פוגעים בך מאוד בחוסר צדק משווע, האם אתה נוטה לפגוע בחזרה?', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 3, 1, NULL),
(1406, 'F1406', 6, 75, NULL, 3, 'אם היה לך כדור בדולח שיודע הכל על החיים, על העתיד על הכל... מה היית רוצה לדעת?', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 4, 1, NULL),
(1407, 'F1391', 6, 75, NULL, 3, 'היית רוצה להיות מפורסם? באיזה תחום?', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 3, 1, NULL),
(1408, 'F1392', 6, 75, NULL, 3, 'כשאתה מחייג, האם יוצא לך לעשות חזרות בראש על מה שאתה הולך להגיד? ', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 2, 1, NULL),
(1409, 'F1409', 6, 75, NULL, 3, 'החברה הכי טובה מבקשת עזרה כספית, האם תסכימו?', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 4, 1, NULL),
(1410, 'F1410', 6, 75, NULL, 3, 'האם אתה נוהג לקנות באינטרנט? כמה קניות עשית בשנה האחרונה למשל?', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 3, 1, NULL),
(1411, 'F1420', 6, 75, NULL, 3, 'איך תציג את עצמך בתחילת פגישת עבודה עם אנשים שאתה לא מכיר?', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 3, 1, NULL),
(1412, 'F1421', 6, 75, NULL, 3, 'חבר שלך מפגיש אותך עם חבר\'ה שלו שאינך מכיר. איך תציג את עצמך בפניהם? ', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 4, 1, NULL),
(1413, 'F1422', 6, 75, NULL, 3, 'נניח שהוזמנת למפגש מחזור של התיכון שלך. כתבו משפט קצר שבזכותו כולם יזהו מייד מי אתם. ', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 4, 1, NULL),
(1414, 'F1423', 6, 75, NULL, 3, 'מארגנים תחרות כישרונות, ומותר להתחרות בכל תחום שקיים בעולם. במה תבקש להתחרות?', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 3, 1, NULL),
(1415, 'F1415', 6, 75, NULL, 3, 'איזה עצה בנושא דייטים תיתן לעצמך הצעיר יותר, מהניסיון שלך כיום? ', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 4, 1, NULL),
(1416, 'F1416', 6, 75, NULL, 3, 'מה זה עושה לך אם בחורה מסמיקה בגללך?', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 3, 1, NULL),
(1417, 'F1417', 6, 75, NULL, 3, 'אחרי דייט, כמה פעמים תסמס לה עד שתחליט לוותר, אם היא לא עונה?', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 4, 1, NULL),
(1418, 'F1596', 6, 75, NULL, 3, 'גורלך תלוי באיכות הסנדוויץ שתכין עבורה. תאר את הרכב הסנדוויץ. ', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 2, 1, NULL),
(1419, 'F1587', 6, 75, NULL, 3, 'הוזמנת למסיבה עם החברה החדשה שלך, והיא מדברת עם גברים אחרים המון, יותר מאשר איתך. כתוב לה SMS', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 3, 1, NULL),
(1420, 'F1588', 6, 75, NULL, 3, 'אתה מפגיש את החברה החדשה עם ההורים שלך. מה יהיה נחשב בעיניך להתנהגות לא מכובדת מצידה. ', 0, 1, 1, 18, 99, 4, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 3, 1, NULL),
(1421, 'F1589', 6, 75, NULL, 3, 'תן דוגמא ל\"איך אסור להתנהג איתך בדייט ראשון\". ', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 3, 1, NULL),
(1422, 'F1562', 6, 75, NULL, 3, 'הבוס שלך מספר בדיחה ממש לא מצחיקה. מה תעשה?', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 3, 1, NULL),
(1423, 'F1676', 6, 75, NULL, 3, 'תאר במשפט קצר או כותרת את הסרט שיעשו על החיים שלך', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 3, 1, NULL),
(1424, 'F1670', 6, 75, NULL, 3, 'מישהי שישבה בכלא על עבירת גניבה `99`, מישהי שעברה ילדות קשה `99`, מישהי שנעצרה על אלימות `99`', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 3, 1, NULL),
(1425, 'F1671', 6, 75, NULL, 3, 'מישהי שתפסת אותה בשקר `99`, מישהי שבגדה בחבר הקודם שלה `99`, מישהי שהזריקה בעבר הרואין אבל עכשיו נקיה `99` ', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 3, 1, NULL),
(1426, 'F1653', 6, 75, NULL, 3, 'על מה לא תסלח בחיים אם יעשו לך?', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 3, 1, NULL),
(1427, 'F1646', 6, 75, NULL, 3, 'ממי כדאי שתבקש סליחה ביום כיפור? ועל מה?', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 4, 1, NULL),
(1428, 'F1640', 6, 75, NULL, 3, 'שבת בבוקר. בחוץ גשם וסערה. זה עושה לי חשק ל', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 4, 1, NULL),
(1429, 'F1641', 6, 75, NULL, 3, 'בחוץ חמסין כבד. זה עושה לי חשק ל', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 4, 1, NULL),
(1430, 'F1711', 6, 75, NULL, 3, 'עד כמה חצוף בעיניך בבית קפה? לקוח שצועק בסלולרי `99`, קבצן שנכנס לבקש נדבה מהאורחים `99`, לקוחות שנכנסו אחריך מקבלים שירות הרבה לפניך', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 3, 1, NULL),
(1431, 'F1712', 6, 75, NULL, 3, 'מה היית רוצה לומר בסתר ליבך לאמא שמתעלמת מהצרחות של התינוק שלה באמצע בית קפה?', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 2, 1, NULL),
(1432, 'F1697', 6, 75, NULL, 3, 'חבר שלך יוצא לדייט עם מישהי שהיא בענק מעל לליגה שלו. איזו עצה תיתן לו לקראת הדייט?', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 2, 1, NULL),
(1433, 'F1686', 6, 75, NULL, 3, 'תארי את עצמך בעוד 20 שנה:', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 4, 1, NULL),
(1434, 'F1682', 6, 75, NULL, 3, 'ידידה שלך שואלת אותך אם היא השמינה, ואתה רואה בבירור שכן, והרבה. איך תשיב?', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 4, 1, NULL),
(1435, 'F1683', 6, 75, NULL, 3, 'למה בא לך להתחפש בפורים הקרוב?', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 2, 1, NULL),
(1436, 'F1008', 6, 75, NULL, 3, 'אם הצד השני מתלבט ביניכם לבין עוד מישהוי, האם תנסי להתחרות, או שתוותרו מראש?', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 4, 1, NULL),
(1437, 'F1010', 6, 75, NULL, 3, 'האם קרה לך שהכל נראה שחור בלילה, אבל בבבוקר היית הרבה יותר מעודד? אם כן, במה היה מדובר?', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 4, 1, NULL),
(1438, 'F1261', 6, 75, NULL, 3, 'את מי תרצה להכיר - נסיכה, מדענית פיסיקה, פירסומאית', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 2, 1, NULL),
(1439, 'F1262', 6, 75, NULL, 3, 'מה לא כדאי לגבר להגיד בדייט ראשון איתך?', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 4, 1, NULL),
(1440, 'F1263', 6, 75, NULL, 3, 'אם היא מתלהבת ממך מייד', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 4, 1, NULL),
(1441, 'F1252', 6, 75, NULL, 3, 'כמה זמן לוקח לך לבחור בגדים בבוקר לצאת איתם מהבית?', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 3, 1, NULL),
(1442, 'F1253', 6, 75, NULL, 3, 'לקנות בגד חדש במיוחד לאירוע', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 3, 1, NULL),
(1443, 'F1240', 6, 75, NULL, 3, 'האם יכול להיות שתגיד \"אני אוהב אותך\" אחרי 3 ימים?', 0, 1, 1, 18, 99, 4, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 4, 1, NULL),
(1444, 'F1241', 6, 75, NULL, 3, 'מה תגיד אם היא מסמסת לך כל 10 דקות?', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 4, 1, NULL),
(1445, 'F1242', 6, 75, NULL, 3, 'לפגוש את ההורים אחרי חודש היכרות', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 4, 1, NULL),
(1446, 'F1243', 6, 75, NULL, 3, 'להתנשק בפומבי', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 4, 1, NULL),
(1447, 'F1244', 6, 75, NULL, 3, 'להחזיק ידיים ברחוב ', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 3, 1, NULL),
(1448, 'F1256', 6, 75, NULL, 3, 'מכריחים אותך להתחתן עם מישהו מתחום החדשות', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 3, 1, NULL),
(1449, 'F1302', 6, 75, NULL, 3, 'פרצה שריפה בבית - מה תצילו?', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 4, 1, NULL),
(1450, 'F1250', 6, 75, NULL, 3, 'האם בחורה בחרה עבורך פעם בגדים בחנות?', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 2, 1, NULL),
(1451, 'F1286', 6, 75, NULL, 3, 'להשתכר בפאב', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 3, 1, NULL),
(1452, 'F1272', 6, 75, NULL, 3, 'להיות זבוב על הקיר', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 2, 1, NULL),
(1453, 'F1385', 6, 75, NULL, 3, 'מה יעשה אותך מאושר יותר בזה הרגע?', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 3, 1, NULL),
(1454, 'F1373', 6, 75, NULL, 3, 'אם תשתתף בחידון, באיזה נושא היית זוכה מקום ראשון?', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 3, 1, NULL),
(1455, 'F1380', 6, 75, NULL, 3, 'אם יגידו לך שאתה דומה למישהו מפורסם, למי אתה דומה?', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 1, 1, NULL),
(1456, 'F1378', 6, 75, NULL, 3, 'אם אתה יוצא לדייט בקולנוע, האם אתה נבוך כשמקרינים סצינת סקס?', 0, 1, 1, 18, 99, 4, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 2, 1, NULL),
(1457, 'F1376', 6, 75, NULL, 3, 'אם הבוס שלי יבקש ממני `99`, אין סיכוי בעולם שאסכים. ', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 4, 1, NULL),
(1458, 'F1349', 6, 75, NULL, 3, 'בערב אחרי יום עבודה מתיש, איזה בילוי הכי מתחשק לך? ', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 4, 1, NULL),
(1459, 'F1360', 6, 75, NULL, 3, 'להיות בן זוג של שחקנית שמצטלמת לסצינות סקס', 0, 1, 1, 18, 99, 4, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 3, 1, NULL),
(1460, 'F1361', 6, 75, NULL, 3, 'להתחתן עם עורך דין, מישהו שמתנדב באפריקה', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 2, 1, NULL),
(1461, 'F1357', 6, 75, NULL, 3, 'נניח שבחורה תבחר בך לפי שיר שתשמיע לה מהנגן שלך. איזה שיר תשים?', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 3, 1, NULL),
(1462, 'F1329', 6, 75, NULL, 3, 'איזה יום היה לך אתמול, ומה נראה לך שיהיה מחר? ', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 3, 1, NULL),
(1463, 'F1325', 6, 75, NULL, 3, 'נניח שיתפסו אותך לוטש עיניים במישהי, באיזה חלק של הגוף שלה תביט?', 0, 1, 1, 18, 99, 4, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 3, 1, NULL),
(1464, 'F1339', 6, 75, NULL, 3, 'אם היתה אולימפיאדה בענף `99`, אני יכול להתחרות שם בכבוד', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 3, 1, NULL),
(1465, 'F1347', 6, 75, NULL, 3, 'כשאתם עם חבר\'ה, אתם במרכז או בצד?', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 3, 1, NULL),
(1466, 'F1327', 6, 75, NULL, 3, 'חלון או מעבר, ואיך אתה מעביר את הזמן בטיסות?', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 3, 1, NULL),
(1467, 'F1787', 6, 75, NULL, 3, 'איך מכעיסים אותך?', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 4, 1, NULL),
(1468, 'F1788', 6, 75, NULL, 3, 'עד כמה אתה מאמץ את הקונספט שאם פגשת מישהי שווה במיוחד, כדאי לנסות לדחות כמה שיותר את הקטע הפיסי ביניכם.', 0, 1, 1, 18, 99, 5, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 3, 1, NULL),
(1469, 'F1790', 6, 75, NULL, 3, 'אתה מלצר במסעדה, יש מצב שתאכל מתוך צלחת שלקוח השאיר ולא סיים הכל? ', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 3, 1, NULL),
(1470, 'F1791', 6, 75, NULL, 3, 'פגשת מישהי נדירה וזה נראה רציני. מיהם שלושת הראשונים שתספר להם על כך?', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 3, 1, NULL),
(1471, 'F1784', 6, 75, NULL, 3, 'נניח שעכשיו 4 בבוקר. אתה ער. מדוע?', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 4, 1, NULL),
(1472, 'F1689', 6, 75, NULL, 3, 'איזה דבר אחד היה צריך להשתנות אתמול, כדי שאתמול יהיה יום מוצלח במיוחד?', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 3, 1, NULL),
(1473, 'F1797', 6, 75, NULL, 3, 'באיזה מקרה לאחרונה העדפת לסתום את הפה, למרות שהיה לך הרבה מה להגיד? ', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 4, 1, NULL),
(1474, 'F1820', 6, 75, NULL, 3, 'במה לא מבינים אותך, וזה מתסכל אותך?', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 3, 1, NULL),
(1475, 'F1811', 6, 75, NULL, 3, 'החבר שלך מודיע לך שהוא מתכוון לנסוע לכנס מקצועי (עם הרבה נשים שעובדות איתו), שם כולם יכנסו עירומים לגמרי למעיינות חמים. מה תגובתך?', 0, 1, 1, 18, 99, 5, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 4, 1, NULL),
(1476, 'F1827', 6, 75, NULL, 3, 'תאר מקרה בו פישלת (למשל, היית צריך לשמור על כלב של חבר, והוא ברח)', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 3, 1, NULL),
(1477, 'F1333', 6, 76, NULL, 3, 'איזה מספר אתה אם 1 מופנים, 10 מוחצן', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 2, 1, NULL),
(1478, 'F1273', 6, 76, NULL, 3, 'איזה מספר אתה אם 1 זה הכי זרוק ו-10 זה הכי מקפיד בלבוש?', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 3, 1, NULL),
(1479, 'F1274', 6, 76, NULL, 3, 'איזה מספר אתה אם 1 זה הכי הכי אוהב להיות בבית ו-10 זה בליין? ', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 3, 1, NULL),
(1480, 'F1275', 6, 76, NULL, 3, 'איזה מספר אתה אם 1 זה הכי פחדן ו-10 זה הכי אמיץ? ', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 3, 1, NULL),
(1481, 'F1276', 6, 76, NULL, 3, 'איזה מספר אתה אם 1 זה הכי מתבודד ו-10 זה הכי חברותי?', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 3, 1, NULL),
(1482, 'F1277', 6, 76, NULL, 3, 'איזה מספר אתה אם 1 זה הכי ריאליסטי ו-10 זה הכי פנטזיונר?', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 3, 1, NULL),
(1483, 'F1278', 6, 76, NULL, 3, 'איזה מספר אתה אם 1 זה הכי פסימי ו-10 זה הכי אופטימי?', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 3, 1, NULL),
(1484, 'F1279', 6, 76, NULL, 3, 'איזה מספר אתה אם 1 זה הכי מתוכנן ו-10 זה הכי ספונטני?', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 3, 1, NULL),
(1485, 'F1280', 6, 76, NULL, 3, 'איזה מספר אתה אם 1 זה הכי קשוח ו-10 זה הכי בוכה בסרטים?', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 3, 1, NULL),
(1486, 'F1281', 6, 76, NULL, 3, 'איזה מספר אתה אם 1 זה הכי לא יכול להתחייב ו-10 זה הכי אוהב מערכות יחסים?', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 3, 1, NULL),
(1487, 'F1282', 6, 76, NULL, 3, 'איזה מספר אתה אם 1 זה הכי עקשן ו-10 זה הכי מוותר וזורם?', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 3, 1, NULL),
(1488, 'F1216', 6, 76, NULL, 3, 'מחמאות סרק', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 3, 1, NULL),
(1489, 'F1217', 6, 76, NULL, 3, 'לאחר לפגישות', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 2, 1, NULL),
(1490, 'F1433', 6, 77, NULL, 3, 'מהי העבודה הכי כיפית שהיתה לך?', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 4, 1, NULL),
(1491, 'F1434', 6, 77, NULL, 3, 'מהי העבודה הכי מבאסת שהיתה לך?', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 4, 1, NULL),
(1492, 'F1435', 6, 77, NULL, 3, 'תאר את ההבנה והכישורים שלך במחשב', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 2, 1, NULL),
(1493, 'F1456', 6, 78, NULL, 3, 'האם יצא לך לקבל משלוח זר פרחים? אם כן, על מה קיבלת אותם בפעם האחרונה שזה קרה?', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 4, 1, NULL),
(1494, 'F1457', 6, 78, NULL, 3, 'האם השתתפת פעם בתחרות ספורט עם מדליה או גביע? האם זכית פעם? אם כן, במה?', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 4, 1, NULL),
(1495, 'F1418', 6, 78, NULL, 3, 'קרה שאחרים לא הבינו אותך נכון? אם כן, באיזה עניין?', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 2, 1, NULL),
(1496, 'F1660', 6, 78, NULL, 3, 'איזה משחקים שיחקת הכי הרבה בחיים?', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 4, 1, NULL),
(1497, 'F1643', 6, 78, NULL, 3, 'האם יצא לך פעם לנאום בפני קהל? אם כן, איך היתה ההרגשה?', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 2, 1, NULL),
(1498, 'F1663', 6, 78, NULL, 3, 'מתי בפעם האחרונה רבת עם מישהו מהמשפחה שלך? על מה?', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 3, 1, NULL),
(1499, 'F1664', 6, 78, NULL, 3, 'תאר את ההערכות שקיבלת בתיכון', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 4, 1, NULL),
(1500, 'F1673', 6, 78, NULL, 3, 'תאר ב 2-4 מילים את תקופת הילדות שלך', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 2, 1, NULL),
(1501, 'F1666', 6, 78, NULL, 3, 'תאר את ההערכות שקיבלת בתיכון', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 4, 1, NULL),
(1502, 'F1595', 6, 78, NULL, 3, 'איזה דבר אחד עשית בעבר, שמחשיב אותך להרפתקן בעיניך?', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 4, 1, NULL),
(1503, 'F1635', 6, 78, NULL, 3, 'האם הרגשת פעם בפאניקה אמיתית? אם כן, ממה?', 0, 1, 1, 18, 99, 4, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 4, 1, NULL),
(1504, 'F1628', 6, 78, NULL, 3, 'האם מישהו פעם אמר לך משפט ששינה לך את החיים במובן מסוים? אם כן, מה?', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 2, 1, NULL),
(1505, 'F1334', 6, 78, NULL, 3, 'מאכל דוחה במיוחד שיצא לכם לאכול בעבר', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 1, 1, NULL),
(1506, 'F1332', 6, 78, NULL, 3, 'מאכל מיוחד שאמא הכינה', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 2, 1, NULL),
(1507, 'F1336', 6, 78, NULL, 3, 'איזה סרט הכי אהבת כשהיית ילד?', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 2, 1, NULL),
(1508, 'F1346', 6, 78, NULL, 3, 'העבודה הכי ביזארית שעבדת בעבר', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 3, 1, NULL),
(1509, 'F1038', 6, 78, NULL, 3, 'מהו הטיפ הגבוה ביותר שהשראת למלצרית, ומה היה כל כך מיוחד?', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 2, 1, NULL),
(1510, 'F1042', 6, 78, NULL, 3, 'רקדתי בגשם `99`, חניתי פעם באדום לבן `99`, הייתי מעורב בתאונת דרכים `99`', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 3, 1, NULL),
(1511, 'F1035', 6, 78, NULL, 3, 'מהו הדבר הכי מטופש שעשית אי פעם בחייך', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 3, 1, NULL),
(1512, 'F1026', 6, 78, NULL, 3, 'מה הדבר הכי מצחיק שקרה לך אי פעם בדייט?', 0, 1, 1, 18, 99, 4, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 4, 1, NULL),
(1513, 'F1027', 6, 78, NULL, 3, 'מה הדבר הכי הזוי שקרה לך אי פעם בדייט?', 0, 1, 1, 18, 99, 4, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 4, 1, NULL),
(1514, 'F1168', 6, 78, NULL, 3, 'תכניות טלוויזיה שאהבת בתור ילד', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 2, 1, NULL),
(1515, 'F1169', 6, 78, NULL, 3, 'מקצועות שהצטיינת בתיכון', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 4, 1, NULL),
(1516, 'F1170', 6, 78, NULL, 3, 'הערצת סלב כילד', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 2, 1, NULL),
(1517, 'F1171', 6, 78, NULL, 3, 'ספרו על מחווה מרגשת שמישהו עשה עבורכם בחודש האחרון', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 3, 1, NULL),
(1518, 'F1815', 6, 78, NULL, 3, 'ספר על משהו מיותר לגמרי שעשית בחיים שלך, שהיה סתם בזבוז זמן', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 4, 1, NULL),
(1519, 'F1715', 6, 78, NULL, 3, 'מהי התקופה הכי טובה בחייך. ולמה?', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 3, 1, NULL),
(1520, 'F1728', 6, 78, NULL, 3, 'מהי מערכת היחסים הארוכה ביותר שהיתה לך? מדוע היא הסתיימה?', 0, 1, 1, 18, 99, 5, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 3, 1, NULL),
(1521, 'F1729', 6, 78, NULL, 3, 'כמה מערכות יחסים היו לך? כמה מתוכן משמעותיות?', 0, 1, 1, 18, 99, 5, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 3, 1, NULL),
(1522, 'F1730', 6, 78, NULL, 3, 'מה היתה התקופה הארוכה ביותר שלקח לך להתאושש מכאב פרידה?', 0, 1, 1, 18, 99, 5, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 3, 1, NULL),
(1523, 'F1731', 6, 78, NULL, 3, 'מה היתה התקופה הקצרה ביותר שלקח לך להתאושש מהכאב? ', 0, 1, 1, 18, 99, 5, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 3, 1, NULL),
(1524, 'F1745', 6, 78, NULL, 3, 'ספר על משהו אחד שאתה מאוד מתחרט לגביו בחייך', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 3, 1, NULL),
(1525, 'F1766', 6, 78, NULL, 3, 'תאר מקרה שבו כעסת על ביקורת, אבל אחרי זמן הבנת שהביקורת היתה נכונה', 0, 1, 1, 18, 99, 4, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 3, 1, NULL),
(1526, 'F1767', 6, 78, NULL, 3, 'האם אתה זוכר מקרה שבו מישהו הוריד לך את הביטחון? מי ועל מה?', 0, 1, 1, 18, 99, 4, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 3, 1, NULL),
(1527, 'F1778', 6, 78, NULL, 3, 'ספר על פעם שבה עברת על החוק', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 3, 1, NULL),
(1528, 'F1779', 6, 78, NULL, 3, 'ספר על מקרה שבו לא עשית את מה שאתה תמיד מטיף לעשות', 0, 1, 1, 18, 99, 4, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 2, 1, NULL),
(1529, 'F1760', 6, 78, NULL, 3, 'ספר על משהו אחד שמגיע לך להיות גאה בו בחייך', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 3, 1, NULL),
(1530, 'F1761', 6, 78, NULL, 3, 'האם הקרבת אי פעם הקרבה גדולה מאוד למען מישהו אחר? אם כן, איזו הקרבה ולמי?', 0, 1, 1, 18, 99, 4, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 3, 1, NULL),
(1531, 'F1162', 6, 79, NULL, 3, 'בכושר גופני אני זורם בכיף עד שזה מגיע ל', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 4, 1, NULL),
(1532, 'F1163', 6, 79, NULL, 3, 'בטיולים בחיק הטבע אני זורם בכיף עד שזה מגיע', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 4, 1, NULL),
(1533, 'F1164', 6, 79, NULL, 3, 'אני אוהב לבלות בחוף הים עד שזה מגיע ל', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 1, 1, NULL),
(1534, 'F1226', 6, 81, NULL, 3, 'מה העונש לאנשים שמשוויצים בהרבה חברים בפייסבוק, ועסוקים בסמאטפון באמצע פגישה. ', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 4, 1, NULL),
(1535, 'F1227', 6, 81, NULL, 3, 'מה העונש לאנשים שמלווים ולא מחזירים, ומפרסמים בפייסבוק רק דברים מחמיאים על עצמם', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 4, 1, NULL),
(1536, 'F1228', 6, 81, NULL, 3, 'מה העונש לנהג שזורק קופסת סיגריות ו נהג שצופר חצי שעה לחבר שלו', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 4, 1, NULL),
(1537, 'F1229', 6, 81, NULL, 3, 'מה העונש לנהג שחונה חניה כפולה ועונה \"מה אתה ממהר\", ולנהג שנוסע לאט במסלול שמאלי', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 4, 1, NULL),
(1538, 'F1230', 6, 81, NULL, 3, 'מה העונש לנהג שחונה החניית נכה, ולנהג שעוקף את כולם בתור בפניה ימינה ונדחף ברגע האחרון. ', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 4, 1, NULL),
(1539, 'F1205', 6, 82, NULL, 3, 'את מי בא לך לחבק כשאתה עצוב?', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 3, 1, NULL),
(1540, 'F1180', 6, 83, NULL, 3, 'הצליל שהכי מעצבן אותי', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 2, 1, NULL),
(1541, 'F1182', 6, 83, NULL, 3, 'איך אתה מרגיע את עצמך כשמעצבנים אותך?', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 4, 1, NULL),
(1542, 'F1718', 6, 84, NULL, 3, 'עד כמה אתה פוחדת מ: לטוס `99`, מקומות גבוהים `99`, מקומות סגורים `99`', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 4, 1, NULL),
(1543, 'F1719', 6, 84, NULL, 3, 'עד כמה אתה פוחדת מ: ', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 4, 1, NULL),
(1544, 'F1819', 6, 84, NULL, 3, 'אני פוחד שמחר בבוקר לפתע `999`', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 3, 1, NULL),
(1545, 'F1795', 6, 85, NULL, 3, 'עם מי ואיך חגגת את יום ההולדת האחרון שלך?', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 3, 1, NULL),
(1546, 'F1796', 6, 85, NULL, 3, 'ממה הופתעת מאוד בזמן האחרון?', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 3, 1, NULL),
(1547, 'F1805', 6, 85, NULL, 3, 'אני יודע להניע רכב בכבלים `99`, להחליף שקית לשואב אבק `99`, להחליף מיתר לגיטרה `99` ', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 4, 1, NULL),
(1548, 'F1726', 6, 85, NULL, 3, 'אחרי תקופה לחוצה, באיזה אופן אתה מרשה לעצמך להתפרק?', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 3, 1, NULL),
(1549, 'F1747', 6, 85, NULL, 3, 'על מה חשבת אתמול בלילה לפני השינה?', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 4, 1, NULL),
(1550, 'F1763', 6, 85, NULL, 3, 'פרט (כן, תטרח קצת, לא נורא) את כל זוגות המכנסיים שיש לך בארון, כולל סוג וצבע', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 3, 1, NULL),
(1551, 'F1792', 6, 85, NULL, 3, 'מה התכניות שלך למחר?', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 4, 1, NULL),
(1552, 'F1045', 6, 85, NULL, 3, 'מה עשית בדיוק לפני שעה?', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 3, 1, NULL),
(1553, 'F1046', 6, 85, NULL, 3, 'מהו הזמן הממושך ביותר בו לא ישנת, ומה היתה הסיבה?', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 4, 1, NULL),
(1554, 'F1295', 6, 85, NULL, 3, 'לראות סרט באולם קולנוע לבד זה `99`, לטייל בחוץ לארץ לבד זה `99`, ללמוד לבחינות לבד זה `99`', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 4, 1, NULL),
(1555, 'F1304', 6, 85, NULL, 3, 'באיזה תחום אתה יכול ללמד שיעור פרטי?', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 3, 1, NULL),
(1556, 'F1293', 6, 85, NULL, 3, 'ממי קיבלת מסאז אחרון?', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 2, 1, NULL),
(1557, 'F1372', 6, 85, NULL, 3, 'האם אתם שמים לעצמכם גבול כשאתם שותים אלכוהול בבילוי בערב?', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 2, 1, NULL),
(1558, 'F1352', 6, 85, NULL, 3, 'ממה אתם הכי נעלבים?', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 3, 1, NULL),
(1559, 'F1353', 6, 85, NULL, 3, 'ספר על משהו אחד שאתה מאושר ממנו בחייך כיום', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 4, 1, NULL),
(1560, 'F1369', 6, 85, NULL, 3, 'מה יש לך בכיסים עכשיו?', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 3, 1, NULL),
(1561, 'F1370', 6, 85, NULL, 3, 'מה אתה לובש עכשיו?', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 4, 1, NULL),
(1562, 'F1337', 6, 85, NULL, 3, 'מהי ההופעה האחרונה שראית ומתי?', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 3, 1, NULL);
INSERT INTO `net_tasks` (`Seq`, `TaskId`, `Type`, `SubType`, `SubSubType`, `Status`, `Title`, `TimeLimit`, `ForMale`, `ForFemale`, `FromAge`, `ToAge`, `AvailabilityLevel`, `PrivacyLevel`, `IntimacyLevel`, `EaseLevel`, `ThinkLevel`, `CourageLevel`, `InsertDate`, `LastUpdateDate`, `Score`, `Author`, `InUseCount`) VALUES
(1563, 'F1338', 6, 85, NULL, 3, 'איזה מזל אתה והאם אתה מאמין באסטרולוגיה?', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 2, 1, NULL),
(1564, 'F1348', 6, 85, NULL, 3, 'האם יצא לך להופיעלהרצות מול קבוצה גדולה של אנשים?', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 3, 1, NULL),
(1565, 'F1340', 6, 85, NULL, 3, 'ציון הכי גבוה, וציון הכי נמוך באיזה מקצועות?', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 4, 1, NULL),
(1566, 'F1341', 6, 85, NULL, 3, 'האם אתם אוספים משהו? (בולים..) ', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 2, 1, NULL),
(1567, 'F1342', 6, 85, NULL, 3, 'איך אתם עם פאזלים', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 2, 1, NULL),
(1568, 'F1343', 6, 85, NULL, 3, 'איך בילת את השבת האחרונה?', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 4, 1, NULL),
(1569, 'F1344', 6, 85, NULL, 3, 'כמה חברים הכי טובים יש לך? ', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 3, 1, NULL),
(1570, 'F1345', 6, 85, NULL, 3, 'ספר שקראת שהרשים אותך מאוד', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 2, 1, NULL),
(1571, 'F1335', 6, 85, NULL, 3, 'איזה סיגנון אתם הכי אוהבים לרקוד?', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 2, 1, NULL),
(1572, 'F1330', 6, 85, NULL, 3, 'ספר על חפץ שלך, בעלך ערך משמעותי ומיוחד עבורך', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 3, 1, NULL),
(1573, 'F1331', 6, 85, NULL, 3, 'בים אני בדרך כלל מבלה ב--- ונשאר שם ___ זמן', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 2, 1, NULL),
(1574, 'F1310', 6, 85, NULL, 3, 'כתוב 3 תחפושות שהתחפשת בפורים בעבר, ומה היתה התחפושת הכי שווה מהן אי פעם? ', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 2, 1, NULL),
(1575, 'F1318', 6, 85, NULL, 3, 'מה המסעדה הכי טובה, ומה אכלת שם', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 3, 1, NULL),
(1576, 'F1321', 6, 85, NULL, 3, 'באיזה גיל עשית רישיון נהיגה, וכמה טסטים לקח לך לעבור?', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 2, 1, NULL),
(1577, 'F1322', 6, 85, NULL, 3, 'באיזה ספורט אתה אוהב לצפות בטלוויזיה, עם מי?', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 2, 1, NULL),
(1578, 'F1323', 6, 85, NULL, 3, 'מה אכלת הבוקר?', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 4, 1, NULL),
(1579, 'F1324', 6, 85, NULL, 3, 'מה אתה מסבן ראשון במקלחת?', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 3, 1, NULL),
(1580, 'F1636', 6, 85, NULL, 3, 'האם שיקרת אי פעם לבוס שלך? בקשר למה?', 0, 1, 1, 18, 99, 4, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 3, 1, NULL),
(1581, 'F1624', 6, 85, NULL, 3, 'תאר מחווה רומנטית דביקה במיוחד שעשית בשביל אישה', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 2, 1, NULL),
(1582, 'F1603', 6, 85, NULL, 3, 'האם יצא לך להשתמש בסקס אפיל שלך בכוונה כדי להשיג משהו? אם כן, תן דוגמא', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 2, 1, NULL),
(1583, 'F1590', 6, 85, NULL, 3, 'כמה נכון המשפט -  \"הרבה בנות נמשכות דווקא לגברים שמתנהגים כמו חארות?\"', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 2, 1, NULL),
(1584, 'F1585', 6, 85, NULL, 3, 'מתי בפעם האחרונה קראת ספר `99`, הלכת לתיאטרון `99`, הפגנת בהפגנה אידיאולוגית `99`', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 3, 1, NULL),
(1585, 'F1574', 6, 85, NULL, 3, 'כמה זוגות נעליים יש לך בטוטאל? בבקשה פרטי... (כולל סנדלים, כפכפים, קרוקס, הכל הולך)', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 4, 1, NULL),
(1586, 'F1568', 6, 85, NULL, 3, 'האם יצא לך מתישהו להעיר לאישה הערה מביכה, למשל שיש לה ריח רע מהפה? למי? ומה?', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 3, 1, NULL),
(1587, 'F1569', 6, 85, NULL, 3, 'האם אתה בקשר עם חברי ילדות? עם כמה ומי?', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 2, 1, NULL),
(1588, 'F1657', 6, 85, NULL, 3, 'מנה כמה חברים טובים יש לך מכל תקופה (הילדות, הצבא, עבודה, וכו\'... ) ', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 2, 1, NULL),
(1589, 'F1685', 6, 85, NULL, 3, 'מה משך הזמן הכי גדול ברציפות שבו עשית את הפעילויות הבאות: צפיה בטלוויזיה `99`, לשכבלשבת על החוף `99`, שופינג `99`', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 4, 1, NULL),
(1590, 'F1678', 6, 85, NULL, 3, 'האם אתה חושב שאתה עובד קשה מידי? מה סוג העבודה שלך?', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 3, 1, NULL),
(1591, 'F1679', 6, 85, NULL, 3, 'באיזה ביטוי יוצא לך להשתמש הרבה (למשל - \"Been there, done that\" או \"זו לא תכנית כבקשתך\" וכו\'..)', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 2, 1, NULL),
(1592, 'F1680', 6, 85, NULL, 3, 'כתוב לפחות 3 חטיפים מלוחים לא בריאים שאתה מכור אליהם', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 3, 1, NULL),
(1593, 'F1681', 6, 85, NULL, 3, 'כתוב לפחות 3 דברים מתוקים וממש לא בריאים שאתה מכור אליהם', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 3, 1, NULL),
(1594, 'F1691', 6, 85, NULL, 3, 'נניח שמזמינים אותך לטיול טבע של יומיים בסופ\"ש הקרוב. השב במילים \"יש\" או \"אין\"', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 4, 1, NULL),
(1595, 'F1713', 6, 85, NULL, 3, 'מתי היתה החופשה האחרונה שלך, איפה, ולכמה זמן?', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 3, 1, NULL),
(1596, 'F1707', 6, 85, NULL, 3, 'ספר על חפץ שאתה אובססיבי לגביו, ולמה', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 4, 1, NULL),
(1597, 'F1426', 6, 85, NULL, 3, 'מהו הזמן הארוך ביותר שנסעת רצוף במכונית? באיזו סיטואציה זה קרה?', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 3, 1, NULL),
(1598, 'F1432', 6, 85, NULL, 3, 'איפה אתה נמצא עכשיו ולמה?', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 4, 1, NULL),
(1599, 'F1387', 6, 85, NULL, 3, 'באיזה גיל שתית לראשונה אלכוהול? איזה משקה זה היה? ', 0, 1, 1, 18, 99, 4, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 4, 1, NULL),
(1600, 'F1388', 6, 85, NULL, 3, 'ספר על משהו חשוב אחד, שכל מי שמכיר אותך אפילו קצת, בטוח יודע עליך. ', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 4, 1, NULL),
(1601, 'F1394', 6, 85, NULL, 3, 'האם יצא לך לשיר בפני קהל? באיזו סיטואציה?', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 4, 1, NULL),
(1602, 'F1408', 6, 85, NULL, 3, 'ספר על הישג שאתה גאה בו מהתקופה האחרונה', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 4, 1, NULL),
(1603, 'F1459', 6, 85, NULL, 3, 'מה הדבר הכי מוזר ששמת אי פעם במקרר?', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 3, 1, NULL),
(1604, 'F1463', 6, 85, NULL, 3, 'ננעלת פעם מחוץ לבית? `99`, יוצא לך מידי פעם לשכוח איפה שמת את הטלפון? `99`, יצא לך ששכחת משהו מתבשל על הגז וזה נשרף? `99`', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 3, 1, NULL),
(1605, 'F1461', 6, 85, NULL, 3, 'האם יוצא לך להסתובב עם שתי גרביים שהן לא זוג?', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 1, 1, NULL),
(1606, 'F1556', 6, 85, NULL, 3, 'מה אתה רואה בטלוויזיה במיטה לפני השניה?', 0, 1, 1, 18, 99, NULL, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', NULL, 1, NULL),
(1607, 'F1557', 6, 85, NULL, 3, 'לאיזה הרגל אתה מכור באופן קשה?', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 4, 1, NULL),
(1608, 'F1558', 6, 85, NULL, 3, 'לאיזה מאכל אתה מכור באופן הרסני?', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 4, 1, NULL),
(1609, 'F1249', 6, 86, NULL, 3, 'כתוב קללה שאתה מחבב במיוחד', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 2, 1, NULL),
(1610, 'F1703', 6, 87, NULL, 3, 'האם יצא לך לקנא (קנאה שלילית וצורבת) באחד החברים שלך?', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 3, 1, NULL),
(1611, 'F1190', 6, 88, NULL, 3, 'מה היתה הפעם האחרונה שבכית? למה?', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 4, 1, NULL),
(1612, 'F1757', 6, 89, NULL, 3, 'עד כמה אתה אוהב ומשחק משחקי ווידאו? אם כן, איזה משחקים אתה הכי אוהב?', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 2, 1, NULL),
(1613, 'F1469', 6, 90, NULL, 3, 'תאר את החוויה שלך מהתיכון ב 2-3 מילים בלבד. ', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 4, 1, NULL),
(1614, 'F1550', 6, 91, NULL, 3, 'האם את פמיניסטית שחושבת שצריך שיוויון מוחלט? או שלפעמים אולד פאשן זה נחמד לך?', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 1, 1, NULL),
(1615, 'F1555', 6, 91, NULL, 3, 'אם היו מאבחנים אצלך איזו הפרעה אישיותית, מה היא היתה?', 0, 1, 1, 18, 99, 4, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 3, 1, NULL),
(1616, 'F1548', 6, 91, NULL, 3, 'עד כמה אתה טיפוס שיודע להזיז אנשים, מסוגל לארגן הפגנות, לידר? ', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 2, 1, NULL),
(1617, 'F1545', 6, 91, NULL, 3, 'עד כמה אתה דייקן ופרפקציוניסט?', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 3, 1, NULL),
(1618, 'F1546', 6, 91, NULL, 3, 'האם אתה חולמני, או איש של תכלס?', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 3, 1, NULL),
(1619, 'F1526', 6, 91, NULL, 3, 'עד כמה אתם רגועים ושלווים? ', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 3, 1, NULL),
(1620, 'F1495', 6, 91, NULL, 3, 'כמה קל לך לזהות כשעושים עליך מנפילוציות רגשיות? ואיך אתה מגיב כשזה קורה?', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 3, 1, NULL),
(1621, 'F1491', 6, 91, NULL, 3, 'במה אתה טוב יותר? אינטואיציה רגשית, יכולת מחשבה או יכולת זיכרון? ', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 3, 1, NULL),
(1622, 'F1501', 6, 91, NULL, 3, 'האם את יודעת לפלרטט עם זרים בקלות, או שלוקח לך זמן להיפתח?', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 4, 1, NULL),
(1623, 'F1488', 6, 91, NULL, 3, 'דרג לפי סדר חשיבות, מה היית מעדיף לקרוא אצל אנשים -  רגשות, מחשבות, או את העתיד?', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 3, 1, NULL),
(1624, 'F1489', 6, 91, NULL, 3, 'אם היית יכול להגביר פי כמה את אחת התכונות החיוביות שלך. איזו תכונה היית מגביר? ', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 3, 1, NULL),
(1625, 'F1481', 6, 91, NULL, 3, 'נגינה בכלי כלשהו `99`, סדר וניקיון `99`, ארגון ותכנון `99`', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 3, 1, NULL),
(1626, 'F1482', 6, 91, NULL, 3, 'ניהול מו\"מ להוריד מחיר של רכב `99`, פירוק והרכבה של מכשירים חשמליים `99`, התנהלות פיננסית נכונה `99`, ', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 4, 1, NULL),
(1627, 'F1483', 6, 91, NULL, 3, 'שירה `99`, בישול `99`, עיצוב גרפי `99`', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 4, 1, NULL),
(1628, 'F1484', 6, 91, NULL, 3, 'להיות טיפ טופ בלבוש `99`, לרקוד ואלס `99`, להבין בקוקטיילים אלכוהולים `99`', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 4, 1, NULL),
(1629, 'F1705', 6, 91, NULL, 3, 'האם אתה נחשב בעיני החבר\'ה שלך כיועץ טוב? איזו עצה נתת לאחרונה לחברה? ', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 3, 1, NULL),
(1630, 'F1687', 6, 91, NULL, 3, 'תאר כמה אתה פוחד מ: חש `99`, עקרב `99`, עכביש `99`, ג\'וק `99`', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 4, 1, NULL),
(1631, 'F1688', 6, 91, NULL, 3, 'עד כמה אתה טיפוס שאוהב ילדים? (ילדים של בני משפחה שלך וכו\'...)', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 3, 1, NULL),
(1632, 'F1677', 6, 91, NULL, 3, 'כשאתה לבד, האם אתה מחפש להפסיק את זה כמה שיותר מהר, או שאתה נהנה להיות לבד?', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 2, 1, NULL),
(1633, 'F1675', 6, 91, NULL, 3, 'עד כמה נכונות לגביך התכונות הבאות: (נכון מאוד, בכלל לא, קצת, וכו...)', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 3, 1, NULL),
(1634, 'F1665', 6, 91, NULL, 3, 'עד כמה אתה טיפוס של \"מולטי בילויים\" לערב אחד, מול \"בילוי אחד ויחיד זה מספיק\"?', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 3, 1, NULL),
(1635, 'F1644', 6, 91, NULL, 3, 'תאר מקרה בו הצד הרך והאמפטי שלך בא לידי ביטוי', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 3, 1, NULL),
(1636, 'F1654', 6, 91, NULL, 3, 'כמה מהר או לאט אתה מתעצבן,  וכמה מהר או לאט אתה נרגע? ', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 3, 1, NULL),
(1637, 'F1655', 6, 91, NULL, 3, 'האם שברת פעם משהו מתוך כעס? מה זה היה ואיך?', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 2, 1, NULL),
(1638, 'F1656', 6, 91, NULL, 3, 'האם לפעמים את מדוכאת או מדוכדכת בלי סיבה? אם כן, איך את יוצאת מזה?', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 3, 1, NULL),
(1639, 'F1642', 6, 91, NULL, 3, 'מה עוזר לך להירגע? דרג מ 1 עד 10', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 4, 1, NULL),
(1640, 'F1638', 6, 91, NULL, 3, 'האם אתה זקוק ל\'תנאים\' מסוימים כדי להירדם, או שאתה נרדם בקלות גם על ערימת אבנים?', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 3, 1, NULL),
(1641, 'F1639', 6, 91, NULL, 3, 'כמה עמוק אתה ישן? האם אתה מתעורר מכל רעש קטן, או שגם תותח לא יעיר אותך?', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 3, 1, NULL),
(1642, 'F1647', 6, 91, NULL, 3, 'עד כמה זה נכון אם אחרים יגידו לך שאתה: (מאוד, בכלל לא, קצת וכו\'...) ', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 4, 1, NULL),
(1643, 'F1648', 6, 91, NULL, 3, 'עד כמה זה נכון אם אחרים יגידו לך שאתה: (מאוד, בכלל לא, קצת וכו\'...) ', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 4, 1, NULL),
(1644, 'F1649', 6, 91, NULL, 3, 'עד כמה מפחיד אותך לטייל ב: יער ענקי מלא ערפל `99`, בית קברות `99`, סמטא חשוכה בלילה בעיר `99`', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 4, 1, NULL),
(1645, 'F1570', 6, 91, NULL, 3, 'האם באופן כללי חם לך? על איזו טמפרטורה אתה מכוון את המזגן בקיץ? אתה אוהב שהרוח עליך?', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 3, 1, NULL),
(1646, 'F1571', 6, 91, NULL, 3, 'האם באופן כללי קר לך? עם איזו שמיכה אתה ישן בחורף? עם כמה שכבות אתה יוצא מהבית ביום חורפי?', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 3, 1, NULL),
(1647, 'F1563', 6, 91, NULL, 3, 'בכללי אתה טיפוס חסכן או בזבזן? ', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 3, 1, NULL),
(1648, 'F1566', 6, 91, NULL, 3, 'עד כמה אתם נחשבים בעיני עצמכם לכאלה שנפתחים בקלות ויודעים לשתף דברים אינטימיים?', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 4, 1, NULL),
(1649, 'F1567', 6, 91, NULL, 3, 'האם השתנית הרבה מכפי שהיית לפני 5 שנים? אם כן, במה?', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 3, 1, NULL),
(1650, 'F1613', 6, 91, NULL, 3, 'אני ריאליסט `99`, אני וורקוהוליק `99`, אני איש של אתגרים `99`', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 4, 1, NULL),
(1651, 'F1614', 6, 91, NULL, 3, 'אני זאב בודד `99`, יש לי ביטחון עצמי גבוה `99`, אוני אוהב להוביל `99`', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 4, 1, NULL),
(1652, 'F1633', 6, 91, NULL, 3, 'עד כמה התכונות הללו מגדירות אותך? (מאוד, קצת, בכלל לא, וכו\'...) ', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 4, 1, NULL),
(1653, 'F1622', 6, 91, NULL, 3, 'אם אתה בראיון עבודה. איזו תכונה שלך תעדיף להסתיר?', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 2, 1, NULL),
(1654, 'F1623', 6, 91, NULL, 3, 'האם יש לך צד נשי כלשהו? אם כן, איך זה מתבטא?', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 2, 1, NULL),
(1655, 'F1050', 6, 91, NULL, 3, 'מתי בפעם האחרונה אמרו לך שאתה מטורף (או משוגע, או מחורפן), ולמה?', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 3, 1, NULL),
(1656, 'F1031', 6, 91, NULL, 3, 'איזה הרגל מעצבן יש לך, שמישהו או מישהי שחי לידך מספיק זמן היה מעיד עליו?', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 3, 1, NULL),
(1657, 'F1011', 6, 91, NULL, 3, 'האם אתה מסוגל להירדם תוך כדי התכבלות עם מישהי, או שאתה זקוק למרחב שלך?', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 4, 1, NULL),
(1658, 'F1012', 6, 91, NULL, 3, 'באיזה תחומים הזיכרון שלך הכי טוב? למשל, פרצופים, שמות, מספרים, זיכרון רגשי, וכו\'...', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 3, 1, NULL),
(1659, 'F1005', 6, 91, NULL, 3, 'אני יוזם ומארח אצלי מסיבות `99`, אני עובד על ביזנס משלי `99`, אני זה שיוזם יציאות עם החבר\'ה `99`', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 4, 1, NULL),
(1660, 'F1001', 6, 91, NULL, 3, 'חשוב לי מה אחרים אומרים עלי `99`, אני מבקר את עצמי יותר מידי `99`, אני מדבר אל עצמי לפעמים `99`', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 4, 1, NULL),
(1661, 'F1002', 6, 91, NULL, 3, 'בשנה האחרונה הרגשתי בודד `99`, שתקתי רוב הזמן `99`, בכיתי הרבה `99`, אכלתי הרבה שוקולד `99`', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 4, 1, NULL),
(1662, 'F1017', 6, 91, NULL, 3, 'אין לי בעיה לצחצח שיניים במברשת שלה `99`, אין לי בעיה לערבב איתה מנות במסעדה באותו הסכו\"ם `99`, אין לי בעיה אם היא משתעלת על האוכל שלי `99`', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 5, 1, NULL),
(1663, 'F1776', 6, 91, NULL, 3, 'עד כמה אתה אסרטיבי? קיבלת חביתה לא ממש חמה מהמלצרית. מה תעשה?', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 3, 1, NULL),
(1664, 'F1794', 6, 91, NULL, 3, 'האם אתם נוהגים לאגור חפצים מהעבר, או שאתם מעדיפים לזרוק כמה שיותר?', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 3, 1, NULL),
(1665, 'F1783', 6, 91, NULL, 3, 'האם אתה מחליט וחותך מהר, או שאתה נוהג להתלבט הרבה עד שאתה מחליט?', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 3, 1, NULL),
(1666, 'F1748', 6, 91, NULL, 3, 'כשרע, כדאי לחשוב על דברים חיוביים אבל לא תמיד זה מצליח. יש לך שיטה אחרת שעובדת עבורך?', 0, 1, 1, 18, 99, 4, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 3, 1, NULL),
(1667, 'F1749', 6, 91, NULL, 3, 'האם כיום אתה יותר אמפטי כלפי אנשים מאשר פעם, או יותר ביקורתי? ', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 2, 1, NULL),
(1668, 'F1754', 6, 91, NULL, 3, 'האם אתה בדרך כלל נמנע מקונפליקטים, או שאין לך בעיה להתווכח ולעמוד על שלך?', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 3, 1, NULL),
(1669, 'F1752', 6, 91, NULL, 3, 'האם אתה בדרך כלל מהדברנים, או מהשתקנים?', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 2, 1, NULL),
(1670, 'F1742', 6, 91, NULL, 3, 'איפה אתה על הסקאלה? עקשן שקשה להסתדר איתך, או אחד שתמיד מוותר?', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 2, 1, NULL),
(1671, 'F1828', 6, 91, NULL, 3, 'אני מוכשר מאוד `99`, אני סנוב `99`, החיים שלי מדהימים `99`', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 4, 1, NULL),
(1672, 'F1829', 6, 91, NULL, 3, 'אני מסתכל על עצמי הרבה במראה `99`, לפעמים אני מרגיש שאני כישלון `99`, אני נוהג לחלום בהקיץ `99`', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, '2023-08-09 10:46:33', '2023-08-09 10:46:33', 4, 1, NULL),
(1673, 'F1824', 1, 17, NULL, 3, 'איזו רמת יכולת ריכוז יש לך? עד כמה קל להסיח את דעתך?', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, '2024-12-09 14:48:06', '2024-12-09 14:48:06', 3, 1, NULL),
(1675, 'P1001', 4, NULL, NULL, 3, 'מה תלבש לדייט? הנח את בגדים על משטח וצלם', 0, 1, 1, 18, 99, 4, 5, 5, 5, 5, 5, '2023-08-09 10:50:07', '2023-08-09 10:50:07', 5, 1, NULL),
(1676, 'P1002', 4, NULL, NULL, 3, 'צלם את הספר שהיית שם על השולחן כדי שיחשבו שאתה אינטלקטואל', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, '2023-08-09 10:50:07', '2023-08-09 10:50:07', 5, 1, NULL),
(1677, 'P1003', 4, NULL, NULL, 3, 'ההורים באים לביקור פתע! צלם את מה שהיית מעלים מהשטח מיידית.', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, '2023-08-09 10:50:07', '2023-08-09 10:50:07', 5, 1, NULL),
(1678, 'P1004', 4, NULL, NULL, 3, 'צלם מתנה גרועה שאתה שונא, אבל שומר משום מה.', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, '2023-08-09 10:50:07', '2023-08-09 10:50:07', 3, 1, NULL),
(1679, 'P1005', 4, NULL, NULL, 3, 'צלם את פנים ארון הבגדים שלך. ', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, '2023-08-09 10:50:07', '2023-08-09 10:50:07', 4, 1, NULL),
(1680, 'P1006', 4, NULL, NULL, 3, 'צלם את הנעליים הכי שוות שלך', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, '2023-08-09 10:50:07', '2023-08-09 10:50:07', 4, 1, NULL),
(1681, 'P1007', 4, NULL, NULL, 3, 'צלם את הנעליים הכי מע\'פנות שלך. ', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, '2023-08-09 10:50:07', '2023-08-09 10:50:07', 4, 1, NULL),
(1682, 'P1008', 4, NULL, NULL, 3, 'צלם את כיור המטבח כפי שהוא נראה כרגע. ', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, '2023-08-09 10:50:07', '2023-08-09 10:50:07', 4, 1, NULL),
(1683, 'P1009', 4, NULL, NULL, 3, 'צלם חפץ בדירה שלך שהיית תורם ללא היסוס.', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, '2023-08-09 10:50:07', '2023-08-09 10:50:07', 5, 1, NULL),
(1684, 'P1010', 4, NULL, NULL, 3, 'צלם משהו שיתאר את המצב רוח שלך בזה הרגע. ', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, '2023-08-09 10:50:07', '2023-08-09 10:50:07', 5, 1, NULL),
(1685, 'P1011', 4, NULL, NULL, 3, 'צלם את שולחן העבודה שלך.', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, '2023-08-09 10:50:07', '2023-08-09 10:50:07', 5, 1, NULL),
(1686, 'P1012', 4, NULL, NULL, 3, 'צלם את מדף המקרר שלך.', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, '2023-08-09 10:50:07', '2023-08-09 10:50:07', 5, 1, NULL),
(1687, 'P1013', 4, NULL, NULL, 3, 'צלם את כף היד שלך', 0, 1, 1, 18, 99, 4, 5, 5, 5, 5, 5, '2023-08-09 10:50:07', '2023-08-09 10:50:07', 4, 1, NULL),
(1688, 'P1014', 4, NULL, NULL, 3, 'נניח שתקבל מיליון דולר במזומן, צלם את המקום בו היית מחביא אותם בדירה', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, '2023-08-09 10:50:07', '2023-08-09 10:50:07', 3, 1, NULL),
(1689, 'P1015', 4, NULL, NULL, 3, 'צלם בגד שהיית צריך לזרוק מזמן. ', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, '2023-08-09 10:50:07', '2023-08-09 10:50:07', 5, 1, NULL),
(1690, 'P1016', 4, NULL, NULL, 3, 'צלם את מדף הספרים שלך (או חלק ממנו), באופן שאפשר יהיה לזהות את כותרי הספרים. ', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, '2023-08-09 10:50:07', '2023-08-09 10:50:07', 5, 1, NULL),
(1691, 'P1017', 4, NULL, NULL, 3, 'שלח צילום מסך של מסך הבית שלך ', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, '2023-08-09 10:50:07', '2023-08-09 10:50:07', 4, 1, NULL),
(1692, 'P1018', 4, NULL, NULL, 3, 'צלם את המיטה בה אתה ישן. ', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, '2023-08-09 10:50:07', '2023-08-09 10:50:07', 5, 1, NULL),
(1693, 'P1019', 4, NULL, NULL, 3, 'צלם את משקפי השמש שלך.', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, '2023-08-09 10:50:07', '2023-08-09 10:50:07', 5, 1, NULL),
(1694, 'P1020', 4, NULL, NULL, 3, 'צלם את השמפו ואו את הסבון בהם אתה משתמש. ', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, '2023-08-09 10:50:07', '2023-08-09 10:50:07', 5, 1, NULL),
(1695, 'P1021', 4, NULL, NULL, 3, 'אם אם תיתן את המיטה שלך לאורח בלילה, צלם את המקום בבית שבו אתה תישן. ', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, '2023-08-09 10:50:07', '2023-08-09 10:50:07', 4, 1, NULL),
(1696, 'P1022', 4, NULL, NULL, 3, 'צלם משהו כחול', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, '2023-08-09 10:50:07', '2023-08-09 10:50:07', 4, 1, NULL),
(1697, 'P1023', 4, NULL, NULL, 3, 'צלם משהו אדום', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, '2023-08-09 10:50:07', '2023-08-09 10:50:07', 4, 1, NULL),
(1698, 'P1024', 4, NULL, NULL, 3, 'צלם משהו צהוב', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, '2023-08-09 10:50:07', '2023-08-09 10:50:07', 4, 1, NULL),
(1699, 'P1025', 4, NULL, NULL, 3, 'צלם משהו שחור', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, '2023-08-09 10:50:07', '2023-08-09 10:50:07', 4, 1, NULL),
(1700, 'P1026', 4, NULL, NULL, 3, 'צלם משהו לבן', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, '2023-08-09 10:50:07', '2023-08-09 10:50:07', 4, 1, NULL),
(1701, 'P1027', 4, NULL, NULL, 3, 'צלם משהו ירוק', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, '2023-08-09 10:50:07', '2023-08-09 10:50:07', 4, 1, NULL),
(1702, 'P1028', 4, NULL, NULL, 3, 'צייר אישה על דף נייר, צלם ושלח. ', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, '2023-08-09 10:50:07', '2023-08-09 10:50:07', 4, 1, NULL),
(1703, 'P1029', 4, NULL, NULL, 3, 'כתוב על דף נייר משפט כלשהו, צלם ושלח', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, '2023-08-09 10:50:07', '2023-08-09 10:50:07', 4, 1, NULL),
(1704, 'P1030', 4, NULL, NULL, 3, 'צייר בית על דף נייר, צלם ושלח', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, '2023-08-09 10:50:07', '2023-08-09 10:50:07', 4, 1, NULL),
(1705, 'P1031', 4, NULL, NULL, 3, 'צייר על דף נייר פרצוף מחייך סמיילי, צלם ושלח', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, '2023-08-09 10:50:07', '2023-08-09 10:50:07', 4, 1, NULL),
(1706, 'P1032', 4, NULL, NULL, 3, 'שלח תמונה כלשהי מהגלריה (מבלי לחשוף שום דבר לא רצוי, כמובן)', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, '2023-08-09 10:50:07', '2023-08-09 10:50:07', 4, 1, NULL),
(1707, 'P1033', 4, NULL, NULL, 3, 'צלם משהו מהמקום בו אתה נמצא עכשיו', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, '2023-08-09 10:50:07', '2023-08-09 10:50:07', 5, 1, NULL),
(1708, 'P1034', 4, NULL, NULL, 3, 'צלם את כוס הקפה שלך', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, '2023-08-09 10:50:07', '2023-08-09 10:50:07', 4, 1, NULL),
(1709, 'P1035', 4, NULL, NULL, 3, 'צלם את ארוחת הבוקר שלך', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, '2023-08-09 10:50:07', '2023-08-09 10:50:07', 4, 1, NULL),
(1710, 'P1036', 4, NULL, NULL, 3, 'אתה יוצא מהבית לרחוב - צלם את מה שאתה רואה', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, '2023-08-09 10:50:07', '2023-08-09 10:50:07', 4, 1, NULL),
(1711, 'P1037', 4, NULL, NULL, 3, 'צלם רהיט בבית שלך', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, '2023-08-09 10:50:07', '2023-08-09 10:50:07', 4, 1, NULL),
(1712, 'P1038', 4, NULL, NULL, 3, 'צלם קישוט על הקיר בחדר שלך', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, '2023-08-09 10:50:07', '2023-08-09 10:50:07', 4, 1, NULL),
(1713, 'P1039', 4, NULL, NULL, 3, 'הסתכל מהחלון בדירהבית - צלם מה שאתה רואה', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, '2023-08-09 10:50:07', '2023-08-09 10:50:07', 4, 1, NULL),
(1714, 'P1040', 4, NULL, NULL, 3, 'צלם אחד מהתמרוקים שלך (גילוח, דיאודורנט, וכו\'...)', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, '2023-08-09 10:50:07', '2023-08-09 10:50:07', 4, 1, NULL),
(1715, 'P1041', 4, NULL, NULL, 3, 'פתח מגירה וצלם את מה שבפנים', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, '2023-08-09 10:50:07', '2023-08-09 10:50:07', 3, 1, NULL),
(1716, 'P1042', 4, NULL, NULL, 3, 'צלם חפץ בבית שאתה נוהג להעביר איתו זמן פנוי', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, '2023-08-09 10:50:07', '2023-08-09 10:50:07', 4, 1, NULL),
(1717, 'P1043', 4, NULL, NULL, 3, 'צלם זו גרביים נקיות שלך', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, '2023-08-09 10:50:07', '2023-08-09 10:50:07', 2, 1, NULL),
(1718, 'P1044', 4, NULL, NULL, 3, 'צלם חפץ שאיתו אתה מתקן דברים', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, '2023-08-09 10:50:07', '2023-08-09 10:50:07', 3, 1, NULL),
(1719, 'P1045', 4, NULL, NULL, 3, 'צלם מכנסיים קצרות שלך', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, '2023-08-09 10:50:07', '2023-08-09 10:50:07', 5, 1, NULL),
(1720, 'P1046', 4, NULL, NULL, 3, 'צלם מכנסיים ארוכות שלך', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, '2023-08-09 10:50:07', '2023-08-09 10:50:07', 5, 1, NULL),
(1721, 'P1047', 4, NULL, NULL, 3, 'צלם חולצת יום יום שלך', 0, 1, 1, 18, 99, 3, 5, 5, 5, 5, 5, '2023-08-09 10:50:07', '2023-08-09 10:50:07', 5, 1, NULL),
(1722, 'P1048', 4, NULL, NULL, 3, 'צלם נעלי ספורט שלך', 0, 1, 1, 18, 99, 1, 5, 5, 5, 5, 5, '2023-08-09 10:50:07', '2023-08-09 10:50:07', 5, 1, NULL),
(1723, 'P1049', 4, NULL, NULL, 3, 'צלם משהו לאכול שאתה מנשנש כשאתה במצב רוח רע', 0, 1, 1, 18, 99, 2, 5, 5, 5, 5, 5, '2023-08-09 10:50:07', '2023-08-09 10:50:07', 4, 1, NULL),
(1724, 'P1050', 4, NULL, NULL, 3, 'אם יש לך קעקוע איפשהו על הגוף, צלם אותו, אם לא, צלם איפה שהיית שם קעקוע בגוף ', 0, 1, 1, 18, 99, 4, 5, 5, 5, 5, 5, '2023-08-09 10:50:07', '2023-08-09 10:50:07', 3, 1, NULL),
(1726, 'F1245', 6, 20, NULL, 3, 'להיפרד ב SMS, שופכת עלי, משגעת אותי, רואה כל הזמן....', 0, 1, 0, 18, 99, 2, 5, 5, 5, 5, 5, '2024-11-18 03:35:20', '2024-11-13 09:34:14', 4, 1, NULL),
(1727, 'F1830', 6, 20, NULL, 3, 'להיפרד ב SMS, שופכת עלי, משגעת אותי, רואה כל הזמן....', 0, 1, 0, 18, 99, 2, 5, 5, 5, 5, 5, '2024-11-18 03:41:14', '2024-11-13 09:34:14', 4, 1, NULL),
(1728, 'F1831', 6, 20, NULL, 3, 'להיפרד ב SMS, שופכת עלי, משגעת אותי, רואה כל הזמן....', 0, 1, 0, 18, 99, 2, 5, 5, 5, 5, 5, '2024-12-03 02:38:17', '2024-11-13 09:34:14', 4, 1, NULL),
(1729, 'F1832', 6, 20, NULL, 3, 'להיפרד ב SMS, שופכת עלי, משגעת אותי, רואה כל הזמן....', 0, 1, 0, 18, 99, 2, 5, 5, 5, 5, 5, '2024-12-03 02:38:40', '2024-11-13 09:34:14', 4, 1, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `net_taskstatus`
--

CREATE TABLE `net_taskstatus` (
  `Id` int(11) NOT NULL,
  `Description` varchar(1024) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `net_taskstatus`
--

INSERT INTO `net_taskstatus` (`Id`, `Description`) VALUES
(1, 'Draft 1'),
(2, 'Draft 2'),
(3, 'Approved '),
(4, 'Cancelled');

-- --------------------------------------------------------

--
-- Table structure for table `net_tasksubsubtype`
--

CREATE TABLE `net_tasksubsubtype` (
  `Id` int(11) NOT NULL,
  `SubType` int(11) DEFAULT NULL,
  `Description` varchar(1024) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `net_tasksubsubtype`
--

INSERT INTO `net_tasksubsubtype` (`Id`, `SubType`, `Description`) VALUES
(5, 17, 'q2 s1 ss1'),
(10, 17, 'q2 s1 ss2'),
(11, 2, 'q3-image-ss1'),
(12, 3, 'q4-image-ss1'),
(13, 4, 'photo s1 ss1'),
(14, 28, 'הולכי 4');

-- --------------------------------------------------------

--
-- Table structure for table `net_tasksubtype`
--

CREATE TABLE `net_tasksubtype` (
  `Id` int(11) NOT NULL,
  `TypeId` int(11) NOT NULL,
  `Description` varchar(1024) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `net_tasksubtype`
--

INSERT INTO `net_tasksubtype` (`Id`, `TypeId`, `Description`) VALUES
(2, 2, 'Image 23'),
(3, 3, 'Image'),
(4, 4, 'צילומי אנשים'),
(5, 5, 'Image'),
(17, 1, 'מי לוקח'),
(18, 1, 'Q2 s2'),
(20, 6, 'New'),
(21, 6, 'TEST'),
(26, 1, 'Q2 s3'),
(27, 4, 'צילומי נוף'),
(28, 4, 'צילומי חיות'),
(29, 6, 'אם היית'),
(31, 6, 'SMS'),
(32, 6, 'אהבה'),
(33, 6, 'אוכל'),
(34, 6, 'אומרים עלי'),
(35, 6, 'אישי'),
(36, 6, 'אם '),
(37, 6, 'אני לא מבין'),
(38, 6, 'אף פעם לא'),
(39, 6, 'אקס'),
(40, 6, 'ארוחת ערב'),
(41, 6, 'בא לי'),
(42, 6, 'בגדים'),
(43, 6, 'בחירה'),
(44, 6, 'בכי'),
(45, 6, 'דייט'),
(46, 6, 'דעות'),
(47, 6, 'דרוג'),
(48, 6, 'הורים'),
(49, 6, 'הייתי'),
(50, 6, 'הנדימן'),
(51, 6, 'העדפות'),
(52, 6, 'הרגלים'),
(53, 6, 'חופשה'),
(54, 6, 'חטאים'),
(55, 6, 'חלום'),
(56, 6, 'חרטה'),
(57, 6, 'חשוב או לא'),
(58, 6, 'טלוויזיה'),
(59, 6, 'טעם'),
(60, 6, 'יודע לבשל'),
(61, 6, 'יום יום'),
(62, 6, 'יחסים'),
(63, 6, 'ילדות'),
(64, 6, 'יצירתי'),
(65, 6, 'כסף'),
(66, 6, 'לבוש'),
(67, 6, 'לוק'),
(68, 6, 'מה עדיף'),
(69, 6, 'מוסיקה'),
(70, 6, 'מי'),
(71, 6, 'מיסטיקה'),
(72, 6, 'מפחיד'),
(73, 6, 'משפחה'),
(74, 6, 'ניקיון'),
(75, 6, 'סיטואציות'),
(76, 6, 'סקאלה'),
(77, 6, 'עבודה'),
(78, 6, 'עבר'),
(79, 6, 'עד שזה מגיע ל'),
(80, 6, 'עונש'),
(81, 6, 'עונש מתאים'),
(82, 6, 'עצב'),
(83, 6, 'עצבים'),
(84, 6, 'פחד'),
(85, 6, 'פרטים'),
(86, 6, 'קללות'),
(87, 6, 'קנאה'),
(88, 6, 'רגשות'),
(89, 6, 'תחביבים'),
(90, 6, 'תיכון'),
(91, 6, 'תכונות'),
(92, 2, '1122'),
(93, 2, '1AAAA');

-- --------------------------------------------------------

--
-- Table structure for table `net_tasktext`
--

CREATE TABLE `net_tasktext` (
  `Id` int(11) NOT NULL,
  `TaskId` varchar(50) NOT NULL,
  `LanguageId` int(11) NOT NULL,
  `TextForM` varchar(1024) DEFAULT NULL,
  `TextForF` varchar(1024) DEFAULT NULL,
  `BackgroundImage` varchar(128) DEFAULT NULL,
  `CommonDescription` varchar(1024) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `net_tasktext`
--

INSERT INTO `net_tasktext` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES
(1309, 'F1001', 1, 'עד כמה נכונים בעיניך המשפטים הבאים: (מאוד, בכלל לא, קצת וכו\'...)', 'עד כמה נכונים בעיניך המשפטים הבאים: (מאוד, בכלל לא, קצת וכו\'...)', NULL, NULL),
(1310, 'F1002', 1, 'עד כמה נכונים בעיניך המשפטים הבאים: (מאוד, בכלל לא, קצת וכו\'...)', 'עד כמה נכונים בעיניך המשפטים הבאים: (מאוד, בכלל לא, קצת וכו\'...)', NULL, NULL),
(1311, 'F1003', 1, 'בוא נראה כמה אתה ירוק! עד כמה נכונים המשפטים הבאים? (בכלל לא, מאוד, קצת, וכו\'...) ', 'בואי נראה כמה את ירוקה! עד כמה נכונים המשפטים הבאים? (בכלל לא, מאוד, קצת, וכו\'...) ', NULL, NULL),
(1312, 'F1004', 1, 'עד כמה נכונים המשפטים הבאים? (בכלל לא, מאוד, קצת, וכו\'...) ', 'עד כמה נכונים המשפטים הבאים? (בכלל לא, מאוד, קצת, וכו\'...) ', NULL, NULL),
(1313, 'F1005', 1, 'בוא נראה כמה אתה יזם באופי! עד כמה נכונים המשפטים הבאים? (הרבה, קצת, בכלל לא, תמיד, וכו\'...) ', 'בוא נראה כמה את יזמת באופי! עד כמה נכונים המשפטים הבאים? (הרבה, קצת, בכלל לא, תמיד, וכו\'...) ', NULL, NULL),
(1314, 'F1006', 1, 'תאר במדויק את הלבוש שלך במסיבה האחרונה שרקדת בה', 'תארי במדויק את הלבוש שלך במסיבה האחרונה שרקדת בה', NULL, 'תארי במדויק את הלבוש שלך במסיבה האחרונה שרקדת בה'),
(1315, 'F1007', 1, 'כשתתחתן, האם אתה בקטע של חתונה עם לימוזינה ופאר, או שאתה אוהב משהו צנוע יותר?', 'כשתתחתני, האם את בקטע של חתונה עם לימוזינה ופאר, או שאת אוהבת משהו צנוע יותר?', NULL, 'בחתונה, האם אתם בקטע של לימוזינה ופאר, או משהו צנוע יותר?'),
(1316, 'F1008', 1, 'אם תדע שלבחורה שמוצאת חן בעיניך יש מחזר  נוסף, והיא מתלבטת ביניכם, האם תנסה להתחרות על ליבה, או שתוותר מראש?', 'אם תדעי שלגבר שמוצא חן בעיניך יש מחזרת  נוספת, והוא מתלבט ביניכן, האם תנסי להתחרות על ליבו, או שתוותרי מראש?', NULL, 'אם הצד השני מתלבט ביניכם לבין עוד מישהוי, האם תנסי להתחרות, או שתוותרו מראש?'),
(1317, 'F1009', 1, 'באיזה אופן הכי קל לך לתקשר ולהרגיש נוח מול בחורה שאתה לא מכיר? (זה יכול להיות כל דבר, למשל - משחק טניס, פתירת תשבץ היגיון ביחד, צפיה באירוויזיון, וכו\'...)', 'באיזה אופן הכי קל לך לתקשר ולהרגיש נוח מול גבר זר שאת לא מכירה? (זה יכול להיות כל דבר, למשל - משחק טניס, פתירת תשבץ היגיון ביחד, צפיה באירוויזיון, וכו\'...)', NULL, 'באיזה אופן הכי קל לך להתבטא ולתקשר מול גבראישה שאתה לא מכירהה? '),
(1318, 'F1010', 1, 'האם קרה לך שהכל נראה שחור בלילה, אבל בבבוקר היית הרבה יותר מעודד? אם כן, במה היה מדובר?', 'האם קרה לך שהכל נראה שחור בלילה, אבל בבבוקר היית הרבה יותר מעודדת? אם כן, במה היה מדובר?', NULL, 'האם קרה לך שהכל נראה שחור בלילה, אבל בבבוקר היית הרבה יותר מעודדת? אם כן, במה היה מדובר?'),
(1319, 'F1011', 1, 'האם אתה מסוגל להירדם תוך כדי התכבלות עם מישהי, או שאתה זקוק למרחב שלך?', 'האם את מסוגלת להירדם תוך כדי התכרבלות עם מישהו, או שאת זקוקה למרחב שלך?', NULL, 'האם אתם מסוגלים להירדם תוך כדי התכרבלות עם מישהוי, או שאתם זקוקים למרחב שלכם?'),
(1320, 'F1012', 1, 'באיזה תחומים הזיכרון שלך הכי טוב? למשל, פרצופים, שמות, מספרים, זיכרון רגשי, וכו\'...', 'באיזה תחומים הזיכרון שלך הכי טוב? למשל, פרצופים, שמות, מספרים, זיכרון רגשי, וכו\'...', NULL, 'באיזה תחומים הזיכרון שלך הכי טוב? למשל, פרצופים, שמות, מספרים, זיכרון רגשי, וכו\'...'),
(1321, 'F1014', 1, 'אילו אפליקציות אתה בודק בסלולרי דבר ראשון אחרי שאתה מתעורר בבוקר?', 'אילו אפליקציות את בודדקת בסלולרי דבר ראשון אחרי שאת מתעוררת בבוקר?', NULL, 'אילו אפליקציות אתם בודקים בסלולרי דבר ראשון אחרי שאתם מתעוררים בבוקר?'),
(1322, 'F1015', 1, 'האם אתה מרגיש טוב עם זה שהחברה שלך תצא לפגישות עם ידידים גברים אחד על אחד, רק שניהם, בערב?', 'האם את מרגישה טוב עם זה שהחבר שלך ייצא לפגישות עם ידידות אחד על אחד, רק שניהם,  בערב?', NULL, 'איך אתם מרגישים עם זה שהחברה ייצא עם ידידיםידידות לפגישות אחד על אחד בערב?'),
(1323, 'F1016', 1, 'איך אתה ישן? על הבטן, על הגב, על הצד? עם כמה כריות, וכמה פעמים אתה מתעורר בכל לילה בממוצע?', 'איך את ישנה? על הבטן, על הגב, על הצד? עם כמה כריות, וכמה פעמים את מתעוררת בכל לילה בממוצע?', NULL, 'איך אתם ישינים? על הגב, על הבטן, על הצד? עם כמה כריות, וכמה פעמים אתם מתעוררים בלילה?'),
(1324, 'F1017', 1, 'עד כמה נכונים המשפטים הבאים? (לא נכון, נכון, קצת, וכו\'...) ', 'עד כמה נכונים המשפטים הבאים? (לא נכון, נכון, קצת, וכו\'...) ', NULL, NULL),
(1325, 'F1018', 1, 'אילו שלושה מאכלים אין סיכוי שתאכל', 'אילו שלושה מאכלים אין סיכוי שתאכלי', NULL, 'אילו שלושה מאכלים אין סיכוי שתאכלי'),
(1326, 'F1022', 1, 'פינת ההמלצה:', 'פינת ההמלצה:', NULL, NULL),
(1327, 'F1023', 1, 'פינת ההמלצה:', 'פינת ההמלצה:', NULL, NULL),
(1328, 'F1024', 1, 'איזה דבר אחד יכול לעשות לך טרן אוף אצל אישה?', 'איזה דבר אחד יכול לעשות לך טרן אוף אצל גבר?', NULL, 'איזה דבר אחד יכול לעשות לך טרן אוף אצל גבראישה?'),
(1329, 'F1025', 1, 'איזה אדם שמעורב בחיים שלך אתה מעריץ בענק?', 'איזה אדם שמעורב בחיים שלך את מעריצה בענק?', NULL, 'איזה אדם שמעורב בחיים שלכים אתם מעריצים בענק?'),
(1330, 'F1026', 1, 'מה הדבר הכי מצחיק שקרה לך אי פעם בדייט?', 'מה הדבר הכי מצחיק שקרה לך אי פעם בדייט?', NULL, 'מה הדבר הכי מצחיק שקרה לך אי פעם בדייט?'),
(1331, 'F1027', 1, 'מה הדבר הכי הזוי שקרה לך אי פעם בדייט?', 'מה הדבר הכי הזוי שקרה לך אי פעם בדייט?', NULL, 'מה הדבר הכי הזוי שקרה לך אי פעם בדייט?'),
(1332, 'F1029', 1, 'מהי המתנה הכי לא שווה ולא מתאימה שקיבלת? ', 'מהי המתנה הכי לא שווה ולא מתאימה שקיבלת? ', NULL, 'מהי המתנה הכי לא שווה ולא מתאימה שקיבלת? '),
(1333, 'F1030', 1, 'אם היתה לך גישה ללא הגבלת זמן או כסף לקניות חופשיות בחנות אחת. איזו חנות זו היתה? ', 'אם היתה לך גישה ללא הגבלת זמן או כסף לקניות חופשיות בחנות אחת. איזו חנות זו היתה? ', NULL, 'אם היתה לך גישה ללא הגבלת זמן או כסף לחנות אחת. איזו חנות זו היתה? '),
(1334, 'F1031', 1, 'איזה הרגל מעצבן יש לך, שמישהו או מישהי שחי לידך מספיק זמן היה מעיד עליו?', 'איזה הרגל מעצבן יש לך, שמישהו או מישהי שחי לידך מספיק זמן היה מעיד עליו?', NULL, 'איזה הרגל מעצבן יש לך, שמישהו או מישהי שחי לידך מספיק זמן היה מעיד עליו?'),
(1335, 'F1032', 1, 'בוא תהיה רגע בטלוויזיה', 'בואי תהיי רגע בטלוויזיה', NULL, NULL),
(1336, 'F1033', 1, 'יש לך משימה להיות מיליונר תוך 5 שנים. מה התכנית שלך כדי להשיג את זה?', 'יש לך משימה להיות מיליונרית תוך 5 שנים. מה התכנית שלך כדי להשיג את זה?', NULL, 'יש לך משימה להיות מיליונרית תוך 5 שנים. מה התכנית שלך?'),
(1337, 'F1034', 1, 'איזה חוק שאינו קיים בספר החוקים, היית מחוקק בעצמך לו יכולת?', 'איזה חוק שאינו קיים בספר החוקים, היית מחוקקת בעצמך לו יכולת?', NULL, 'איזה חוק שאינו קיים בספר החוקים, היית מחוקקת בעצמך לו יכולת?'),
(1338, 'F1035', 1, 'מהו הדבר הכי מטופש שעשית אי פעם בחייך', 'מהו הדבר הכי מטופש שעשית אי פעם בחייך', NULL, 'מהו הדבר הכי מטופש שעשית אי פעם בחייך'),
(1339, 'F1036', 1, 'הולכים לים', 'הולכים לים', NULL, NULL),
(1340, 'F1037', 1, 'מהו הדבר הכי מצחיק שקרה לך השבוע?', 'מהו הדבר הכי מצחיק שקרה לך השבוע?', NULL, 'מהו הדבר הכי מצחיק שקרה לך השבוע?'),
(1341, 'F1038', 1, 'מהו הטיפ הגבוה ביותר שהשראת למלצרית, ומה היה כל כך מיוחד?', 'מהו הטיפ הגבוה ביותר שהשראת למלצרית, ומה היה כל כך מיוחד?', NULL, 'מהו הטיפ הגבוה ביותר שהשראת למלצרית, ומה היה כל כך מיוחד?'),
(1342, 'F1039', 1, 'הרכב לך אישה עם 5 תכונות מהרשימה שלפניך, כשחייבות להופיע לפחות 2 תכונות שליליות: יפה, חכמה, אתלטית, עשירה, יודעת להקשיב, חייכנית עם גישה חיובית - מכוערת, טיפשה, בלי גרוש, לא קשובה, מרירה עם גישה שלילית (מותר להיות יצירתי ולהמציא בעצמך)', 'הרכיבי לך גבר עם 5 תכונות מהרשימה שלפניך, כשחייבות להופיע לפחות 2 תכונות שליליות: יפה, חכם, אתלטי, עשיר, יודע להקשיב, חייכני עם גישה חיובית - מכוער, טיפש, בלי גרוש, לא קשוב, מרירה עם גישה שלילית. (מותר להיות יצירתית ולהמציא בעצמך)', NULL, 'הרכיבו בןבת זוג עם 5 תכונות מהרשימה'),
(1343, 'F1040', 1, 'עד כמה נעים לך? (מאוד, בכלל לא, קצת וכו\'...) ', 'עד כמה נעים לך? (מאוד, בכלל לא, קצת וכו\'...) ', NULL, 'עד כמה נעים לך? '),
(1344, 'F1041', 1, 'עם מי אתה מתייעץ בבחירת התחתונים שלך?', 'עם מי את מתייעצת בבחירת החזיותתחתונים שלך?', NULL, 'עם מי אתם מתייעצים בבחירת הבגדים התחתונים שלכם?'),
(1345, 'F1042', 1, 'כן או לא? ', 'כן או לא? ', NULL, NULL),
(1346, 'F1043', 1, 'מהי המחמאה הכי גדולה שמישהו נתן לך בזמן האחרון?', 'מהי המחמאה הכי גדולה שמישהו נתן לך בזמן האחרון?', NULL, 'מהי המחמאה הכי גדולה שמישהו נתן לך בזמן האחרון?'),
(1347, 'F1044', 1, 'אם תוכל להיות בכל גיל שתבחר למשך שבוע, מה תבחר ומה תעשה בשבוע הזה?', 'אם תוכלי להיות בכל גיל שתבחרי למשך שבוע, מה תבחרי ומה תעשי בשבוע הזה?', NULL, 'אם תוכלי להיות בכל גיל שתבחרי למשך שבוע, מה תבחרי ומה תעשהי בשבוע הזה?'),
(1348, 'F1045', 1, 'מה עשית בדיוק לפני שעה?', 'מה עשית בדיוק לפני שעה?', NULL, 'מה עשית בדיוק לפני שעה?'),
(1349, 'F1046', 1, 'מהו הזמן הממושך ביותר בו לא ישנת, ומה היתה הסיבה?', 'מהו הזמן הממושך ביותר בו לא ישנת, ומה היתה הסיבה?', NULL, 'מהו הזמן הממושך ביותר בו לא ישנת, ומה היתה הסיבה?'),
(1350, 'F1047', 1, 'געגוע', 'געגוע', NULL, NULL),
(1351, 'F1048', 1, 'עד כמה מרתיעה אותך (או מושכת אותך) מישהי שבפוקוס חזק על הלוק שלה (שיער, בגדים, מוצרי טיפוח וכו\'..) ', 'עד כמה מרתיע אותך (או מושך אותך) מישהו שבפוקוס חזק על הלוק שלו (שיער, בגדים, מוצרי טיפוח וכו\'...)', NULL, 'עד כמה מרתיע אותך (או מושך אותך) מישהוי שבפוקוס חזק על הלוק שלושלה?'),
(1352, 'F1049', 1, 'התאהבות', 'התאהבות', NULL, NULL),
(1353, 'F1050', 1, 'מתי בפעם האחרונה אמרו לך שאתה מטורף (או משוגע, או מחורפן), ולמה?', 'מתי בפעם האחרונה אמרו לך שאת מטורפת (או משוגעת, או מחורפנת), ולמה?', NULL, 'מתי בפעם האחרונה אמרו לכם שאתם מטורפים (או משוגעים או מחורפנים), ולמה?'),
(1354, 'F1051', 1, 'מה אתה אומר על המשפט: \"נשים אוהבות שגברים מתאמצים לכבוש אותן, כי הן לא אלא רוצה שהגבר יקבל שום דבר בחינם\". ', 'מה את אומרת על המשפט: \"נשים אוהבות שגברים מתאמצים לכבוש אותן, כי הן לא אלא רוצה שהגבר יקבל שום דבר בחינם\". ', NULL, 'מה אתה אומרת על המשפט: \"נשים אוהבות שגברים מתאמצים לכבוש אותן, כי הן לא אלא רוצה שהגבר יקבל שום דבר בחינם\". '),
(1355, 'F1052', 1, 'מה אתה אומר על המשפט: \"גברים שמשחקים נכון את המשחק, יצליחו לכבוש יותר בחורות\"', 'מה את אומרת על המשפט: \"גברים שמשחקים נכון את המשחק, יצליחו לכבוש יותר בחורות\"', NULL, 'מה אתה אומרת על המשפט: \"גברים שמשחקים נכון את המשחק, יצליחו לכבוש יותר בחורות\"'),
(1356, 'F1053', 1, 'הרגלים', 'הרגלים', NULL, NULL),
(1357, 'F1054', 1, 'עד כמה אתה אוהב את הממרחים הבאים? (בכלל לא, מאוד, קצת וכו\'...) ', 'עד כמה את אוהבת את הממרחים הבאים? (בכלל לא, מאוד, קצת וכו\'...) ', NULL, NULL),
(1358, 'F1159', 1, 'השלם את החסר', 'השלימי את החסר', NULL, NULL),
(1359, 'F1160', 1, 'השלם את החסר', 'השלימי את החסר', NULL, NULL),
(1360, 'F1161', 1, 'השלם את החסר', 'השלימי את החסר', NULL, NULL),
(1361, 'F1162', 1, 'השלם את החסר', 'השלימי את החסר', NULL, NULL),
(1362, 'F1163', 1, 'השלם את החסר', 'השלימי את החסר', NULL, NULL),
(1363, 'F1164', 1, 'השלם את החסר', 'השלימי את החסר', NULL, NULL),
(1364, 'F1165', 1, 'השלם את החסר', 'השלימי את החסר', NULL, NULL),
(1365, 'F1168', 1, 'איזו תכנית טלווזיה הכי אהבת בתור ילד?', 'איזו תכנית טלווזיה הכי אהבת בתור ילדה?', NULL, 'איזו תכנית טלווזיה הכי אהבת בתור ילדה?'),
(1366, 'F1169', 1, 'באיזה תחום הצטיינת בתיכון?', 'באיזה תחום הצטיינת בתיכון?', NULL, 'באיזה מקצוע הצטיינתם בתיכון?'),
(1367, 'F1170', 1, 'ספר על סלב כלשהו שהערצת כילד ועכשיו אתה מרגיש שזה היה מגוחך', 'ספרי על סלב כלשהו שהערצת כילדה ועכשיו את מרגישה שזה היה מגוחך?', NULL, 'ספרו על סלב כלשהו שהערצתם כילד ועכשיו אתם מרגישים שזה היה מגוחך?'),
(1368, 'F1171', 1, 'ספר על מחווה מרגשת שמישהו עשה עבורך בחודש האחרון', 'ספרי על מחווה מרגשת שמישהו עשה עבורך בחודש האחרון', NULL, 'ספרו על מחווה מרגשת שמישהו עשה עבורכם בחודש האחרון'),
(1369, 'F1172', 1, 'זכית בחמישים מיליון למי תיתן מיליון?', 'זכית בחמישים מיליון. למי תתני מיליון?', NULL, 'זכיתם בחמישים מיליון. למי תתנו מיליון?'),
(1370, 'F1173', 1, 'זכית בחמישים מיליון. מה תהיה הרכישה המוגזמת הראשונה שלך?', 'זכית בחמישים מיליון. מה תהיה הרכישה המוגזמת הראשונה שלך?', NULL, 'זכית בחמישים מיליון. מה תהיה הרכישה המוגזמת הראשונה שלך?'),
(1371, 'F1174', 1, 'זכית בחמישים מיליון. על מי תוציא חוזה חיסול?', 'זכית בחמישים מיליון. על מי תוציאי חוזה חיסול?', NULL, 'זכית בחמישים מיליון. על מי תוציאו חוזה חיסול?'),
(1372, 'F1175', 1, 'מי היית רוצה שיופיע בחתונה שלך?', 'מי היית רוצה שיופיע בחתונה שלך?', NULL, 'מי יופיע בחתונה שלך?'),
(1373, 'F1176', 1, 'עם מי תרצה להיתקע במעלית?', 'עם מי תרצי להיתקע במעלית?', NULL, 'עם מי תרצו להיתקע במעלית?'),
(1374, 'F1177', 1, 'עם מי בא לך לשתות עכשיו קפה?', 'עם מי בא לך לשתות עכשיו קפה?', NULL, 'עם מי בא לך לשתות עכשיו קפה?'),
(1375, 'F1180', 1, 'איזה רעש הכי מעצבן אותך?', 'איזה רעש הכי מעצבן אותך?', NULL, 'הרעש שהכי מעצבן אותי'),
(1376, 'F1182', 1, 'איך אתה מרגיע את עצמך כשמעצבנים אותך?', 'איך את מרגיעה את עצמך כשמעצבנים אותך?', NULL, 'איך אתם מרגיעים את עצמכם כשמעצבנים אתכם?'),
(1377, 'F1183', 1, 'איזו מנה עיקרית אתה הכי אוהב לאכול?', 'איזו מנה עיקרית את הכי אוהבת לאכול?', NULL, 'איזו מנה עיקרית אתם הכי אוהבים לאכול?'),
(1378, 'F1184', 1, 'איזה קינוח בא לך עכשיו?', 'איזה קינוח בא לך עכשיו?', NULL, 'איזה קינוח בא לך עכשיו?'),
(1379, 'F1190', 1, 'מה היתה הפעם האחרונה שבכית?', 'מה היתה הפעם האחרונה שבכית? ', NULL, 'מה היתה הפעם האחרונה שבכית?'),
(1380, 'F1195', 1, 'איזה מפורסם היית רוצה להיות?', 'איזה מפורסמת היית רוצה להיות?', NULL, 'איזה מפורסםת היית רוצה להיות?'),
(1381, 'F1196', 1, 'איזו דמות מסרט היית רוצה להיות?', 'איזו דמות מסרט היית רוצה להיות?', NULL, 'איזו דמות מסרט היית רוצה להיות?'),
(1382, 'F1197', 1, 'יצאת עם מישהי נחמדה, אבל אתה מרגיש שזה לא זה. כתוב לה SMS בו אתה מודיע שאתה לא מעוניין, אבל בו זמנית אתה חייב להחמיא לה ולהעלות לה את הביטחון העצמי', 'יצאת עם מישהו נחמד, אבל את מרגישה שזה לא זה. כתבי לו SMS בו את מודיעה שאת לא מעוניינת, אבל בו זמנית את חייבת להחמיא לו ולהעלות לו את הביטחון העצמי', NULL, 'יצאתם עם מישהו נחמד אבל זה לא זה. כתבו לוה בSMS שאתם לא מעוניינים, אבל בו זמנית אתם צריכים להעלות לוה את הביטחון העצמי. '),
(1383, 'F1198', 1, 'פגשת בחורה סקסית במיוחד. החמא לה ב-SMS אבל אסור לך להיות ישיר מידי אחרת היא תפסול אותך מייד', 'פגשת בחור סקסי במיוחד. החמיאי לו ב-SMS אבל אסור לך להיות ישירה מידי אחרת הוא יחשוב שאת קלה להשגה ויאבד עניין', NULL, 'החמיאו ב-SMS בלי להיות ישירים מידי'),
(1384, 'F1199', 1, 'הבחור שאיתך תפס אותך לוטשת מבט במלצר החמוד במסעדה ועכשיו הראש שלך על הגיליוטינה. מה תגידי להגנתך?', 'הבחור שאיתך תפס אותך לוטשת מבט במלצר החמוד במסעדה ועכשיו הראש שלך על הגיליוטינה. מה תגידי להגנתך?', NULL, 'נתפסתם לוטשים מבט במלצרית. מה תגידו להגנתכם?'),
(1385, 'F1204', 1, 'ספר על החלטה שלקחת השבוע ואתה מתחרט עליה ', 'ספרי על חלטה שלקחת השבוע ואת מתחרטת עליה', NULL, 'האם יש החלטה שלקחתם אתמול ואתם מתחרטים עליה?'),
(1386, 'F1205', 1, 'את מי בא לך לחבק כשאתה עצוב?', 'את מי בא לך לחבק כשאת עצובה? ', NULL, 'את מי בא לכם לחבק כשאתם עצובים?'),
(1387, 'F1206', 1, 'הזמנת בחורה לדייט רומנטי כשאתה מבשל את הארוחה אצלך. ', 'הזמנת בחור לדייט רומנטי כשאת מבשלת את הארוחה אצלך.', NULL, 'הזמנתם את הבחורה לדייט רומנטי אצלכם בדירה. מה תגישו? (אחר כך תנו בצ\'אט ציון לבחירות של הצד השני)'),
(1388, 'F1207', 1, 'הזמנת בחורה לדייט רומנטי אצלך בבית. ', 'הזמנת בחור לדייט רומנטי אצלך בבית. ', NULL, 'הזמנתם את הבחורה לדייט רומנטי אצלכם בבית. (אחר כך בצ\'אט, תנו ציון מ 1-10 לבחירות של הצד השני)'),
(1389, 'F1209', 1, 'נניח שיש לך אספקה בלתי מוגבלת של אוכל מסוג אחד, מה תבחר?', 'נניח שיש לך אספקה בלתי מוגבלת של אוכל מסוג אחד, מה תבחרי?', NULL, 'נניח שיש לך אספקה בלתי מוגבלת של אוכל מסוג אחד, מה תבחרי?'),
(1390, 'F1212', 1, 'אתה אוהב שבחורות מתאפרות או שאתה בעד נטורל? ', 'את אוהבת להתאפר, או שאת בדרך כלל נטורל?', NULL, 'באיזו מידה אתם מחשיבים איפור בקפידה? אן שאולי עדיף נטורל...'),
(1391, 'F1213', 1, 'האם אתה לובש מידי פעם עם בגדים צמודים? האם אתה אוהב שבחורות לובשות בגדים צמודים? ', 'האם את לובשת מידי פעם בגדים צמודים? האם את אוהבת שגברים לובשים בגדים צמודים?', NULL, 'עד כמה אתם אוהבים  לובשים בגדים צמודים?'),
(1392, 'F1214', 1, 'תאר באחוזים, מה חשוב יותר, גובה או משקל?', 'תארי באחוזים, מה חשוב יותר, גובה או משקל?', NULL, 'תארו באחוזים, מה חשוב יותר, גובה או משקל?'),
(1393, 'F1215', 1, 'תאר באחוזים, מה חשוב יותר, שתהיה שנונה או שתיראה טוב. ', 'תארי באחוזים, מה חשוב יותר, שיהיה שנון או שייראה טוב?', NULL, 'תארו באחוזים, מה חשוב יותר, שכל או חיטוב?'),
(1394, 'F1216', 1, 'איזה מספר אתה אם 10 זה שופך באופן חופשי מחמאות סרק, ו-1 זה אומר רק אמת בפרצוף', 'איזה מספר את אם 10 זה שופכת באופן חופשי מחמאות סרק, ו-1 זה אומרת רק אמת בפרצוף', NULL, 'מ-0 עד 10 כמה אתם נוהגים לתת מחמאות סרק?'),
(1395, 'F1217', 1, 'מ-0 עד 10, כמה יוצא לך לאחר לפגישות? (0 זה אף פעם, 10 זה כל הזמן) ', 'מ-0 עד 10, כמה יוצא לך לאחר לפגישות? (0 זה אף פעם, 10 זה כל הזמן) ', NULL, 'מ-0 עד 10, כמה יוצא לך לאחר לפגישות? (0 זה אף פעם, 10 זה כל הזמן) '),
(1396, 'F1226', 1, 'בחר את העונש מבין \"על תנאי\", \"נידוי חברתי\",  \"מוות בעינויים\" (ואפשר גם להמציא עונש אחר)', 'בחרי את העונש מבין \"על תנאי\", \"נידוי חברתי\",  \"מוות בעינויים\" (ואפשר גם להמציא עונש אחר)', NULL, NULL),
(1397, 'F1227', 1, 'בחר את העונש מבין \"על תנאי\", \"נידוי חברתי\",  \"מוות בעינויים\" (ואפשר גם להמציא עונש אחר)', 'בחרי את העונש מבין \"על תנאי\", \"נידוי חברתי\",  \"מוות בעינויים\" (ואפשר גם להמציא עונש אחר)', NULL, NULL),
(1398, 'F1228', 1, 'בחר את העונש מבין \"על תנאי\", \"נידוי חברתי\",  \"מחלות קשות\" (ואפשר גם להמציא עונש אחר)', 'בחרי את העונש מבין \"על תנאי\", \"נידוי חברתי\",  \"מחלות קשות\" (ואפשר גם להמציא עונש אחר)', NULL, NULL),
(1399, 'F1229', 1, 'בחר את העונש מבין \"על תנאי\", \"נידוי חברתי\",  \"מחלות קשות\" (ואפשר גם להמציא עונש אחר)', 'בחרי את העונש מבין \"על תנאי\", \"נידוי חברתי\",  \"מחלות קשות\" (ואפשר גם להמציא עונש אחר)', NULL, NULL),
(1400, 'F1230', 1, 'בחר את העונש מבין \"על תנאי\", \"כריתת יד\", \"אומללות אינסופית\" (ואפשר גם להמציא עונש אחר)', 'בחרי את העונש מבין \"על תנאי\", \"מוות בעינויים\", \"אומללות אינסופית\" (ואפשר גם להמציא עונש אחר)', NULL, NULL),
(1401, 'F1231', 1, 'מה אתה עושה כשאתה רואה ג\'וק בגודל של ביואיק?', 'מה את עושה כשאת רואה ג\'וק בגודל של ביואיק?', NULL, 'מה אתה עושה כשאתה רואה ג\'וק?'),
(1402, 'F1232', 1, 'הכיור עולה על גדותיו בגלל סתימה. תתקן לבד או מה?', 'הכיור עולה על גדותיו בגלל סתימה. תתקני לבד או מה? ', NULL, 'הכיור עולה על גדותיו בגלל סתימה. תתקנו לבד?'),
(1403, 'F1233', 1, 'אופס, באמצע נסיעה, פנצ\'ר. תתקן לבד?', 'אופס, באמצע נסיעה, פנצ\'ר. תתקני לבד? ', NULL, 'אופס, באמצע נסיעה, פנצ\'ר. תתקנו לבד?'),
(1404, 'F1234', 1, 'הכפתור בחולצה נתלש. תתפור בעצמך? תיתן לאמא לתפור? תשאיר את זה ככה? ', 'הכפתור בחולצה נתלש. תתפרי בעצמך? תתני לאמא לתפור? תשאירי את זה ככה? ', NULL, 'הכפתור בחולצה נתלש. מה תעשו?'),
(1405, 'F1235', 1, 'צריך לתלות תמונה. תעשה את זה בעצמך? ', 'צריך לתלות תמונה. תעשי את זה בעצמך? ', NULL, 'צריך לתלות תמונה שקניתם. תעשו את זה לבד? '),
(1406, 'F1236', 1, 'המחשב עושה בעיות. האם תנסה לתקן לבד, או ישר תקרא לטכנאי? ', 'המחשב עושה בעיות. האם תנסי לתקן לבד, או ישר תקראי לטכנאי?', NULL, 'המחשב מקרטע. האם תנסו לתקן לבד או ישר תקראו לטכנאי. '),
(1407, 'F1237', 1, 'השלם את החסר במילים \"יודע\", או \"קצת יודע\", או \"אין לי מושג\".', 'השלימי את החסר במילים \"יודעת\", \"קצת יודעת\", או \"אין לי מושג\"', NULL, NULL),
(1408, 'F1238', 1, 'השלם את החסר במילים \"יודע\", או \"קצת יודע\", או \"אין לי מושג\".', 'השלימי את החסר במילים \"אני יודעת\", \"אני קצת יודעת\", או \"אין לי מושג איך\"', NULL, NULL),
(1409, 'F1239', 1, 'השלם את החסר במילים \"יודע\", או \"קצת יודע\", או \"אין לי מושג\".', 'השלימי את החסר במילים \"אני יודעת\", \"אני קצת יודעת\", או \"אין לי מושג איך\"', NULL, NULL),
(1410, 'F1240', 1, 'האם יכול להיות מצב שבו תתאהב במישהי מייד ותגיד לה \"אני אוהב אותך\" אחרי שבוע?', 'האם יכול להיות מצב שבו תתאהבי במישהו מייד ותגידי לו \"אני אוהבת אותך\" אחרי שבוע היכרות?', NULL, 'האם אפשר להתאהב תוך שבוע?'),
(1411, 'F1241', 1, 'אהבה חדשה ומרגשת. מה תגיד אם היא מסמסת לך כל 10 דקות? ', 'אהבה חדשה ומרגשת. מה תגידי אם הוא מסמס לך כל 10 דקות? ', NULL, 'אהבה חדשה ומרגשת. מה תגידו אם אתם מקבלים ממנוה SMS כל 10 דקות?'),
(1412, 'F1242', 1, 'מה תגיד אם היא תזמין אותך לפגוש את ההורים שלה אחרי חודש היכרות?', 'מה תגידי אם הוא יזמין אותך לפגוש את ההורים שלו אחרי חודש היכרות?', NULL, 'מה תגידו אם הואהיא יזמינו אתכם לפגוש את ההורים אחרי חודש היכרות?'),
(1413, 'F1243', 1, 'להתנשק בפומבי זה:', 'להתנשק בפומבי זה:', NULL, 'להתנשק בפומבי זה:'),
(1414, 'F1244', 1, 'להחזיק ידיים ברחוב זה: (כיף, לא כיף, מביך, מרגש)', 'להחזיק ידיים ברחוב זה: (כיף, לא כיף, מביך, מרגש)', NULL, 'להחזיק ידיים ברחוב זה:'),
(1415, 'F1245', 1, 'אתה רוצה להיפרד מהחברה שלך, ואתה חייב לעשות זאת ב-SMS. השלם:', 'את רוצה להיפרד מהחבר שלך ואת חייבת לעשות זאת ב-SMS. השלימי:', '1856174242589052928 (2).png', 'אתם רוצים להיפרד מהחברה, ואתם חייבים לעשות זאת ב SM-. השלימו:'),
(1416, 'F1246', 1, 'כתוב SMS פרידה מהחברה שלך, כשבהודעה חייבת להופיע המילה \"גדול\". ', 'כתבי SMS פרידה מהחבר שלך, כשבהודעה חייבת להופיע המילה \"קטן\". ', NULL, 'כתבו SMS פרידה מהחברה, כשבהודעה חייבת להופיע המילה גדולקטן. '),
(1417, 'F1247', 1, 'כתוב SMS פרידה מהחברה שלך, כשבהודעה יהיו מילים בנות שתי אותיות בלבד. ', 'כתבי SMS פרידה מהחבר שלך, כשבהודעה יהיו מילים בנות שתי אותיות בלבד. ', NULL, 'כתבו SMS פרידה מהחברה, כשבהודעה יהיו מילים בנות שתי אותיות בלבד. '),
(1418, 'F1248', 1, 'סמס לאקסית במטרה שהיא תזמין אותך אליה, מבלי להיראות להוט', 'סמסי לאקס במטרה שהוא יזמין אותך אליו, מבלי להיראות להוטה', NULL, 'סמסו לאקסית, במטרה לקבל הזמנה, אבל מבלי להיראות להוטים. '),
(1419, 'F1249', 1, 'כתוב קללה שאתה מחבב במיוחד', 'כתבי קללה שאת מחבבת במיוחד', NULL, 'כתבו קללה שאתם מחבבים במיוחד'),
(1420, 'F1250', 1, 'האם בחורה בחרה עבורך פעם בגדים בחנות? באיזו סיטואציה זה קרה? (ולא, אמא שלך, זה לא נחשב)', 'האם בחור בחר עבורך פעם בגדים בחנות? באיזו סיטואציה זה קרה? ', NULL, 'האם בחורה בחרו עבורכם פעם בגדים בחנות?'),
(1421, 'F1251', 1, 'פרט את כל זוגות הנעליים שיש לך... (כולל סנדלים, כפכפים, קרוקס, הכל הולך)', 'פרטי את כל זוגות הנעליים שיש לך... (כולל סנדלים, כפכפים, קרוקס, הכל הולך)', NULL, 'כמה זוגות נעליים יש לך בטוטאל? בבקשה תפרטי... (כולל סנדלים, כפכפים, קרוקס, הכל הולך)'),
(1422, 'F1252', 1, 'כמה זמן בממוצע לוקח לך לבחור בגדים, כדי לצאת איתם בבוקר מהבית?', 'כמה זמן בממוצע לוקח לך לבחור בגדים, כדי לצאת איתם בבוקר מהבית?', NULL, 'כמה זמן בממוצע לוקח לך לבחור בגדים, כדי לצאת איתם בבוקר מהבית?'),
(1423, 'F1253', 1, 'האם יצא לך לקנות בגד חדש במיוחד לאירוע ספציפי? תן דוגמא... ', 'האם יצא לך לקנות בגד חדש במיוחד לאירוע ספציפי? תני דוגמא... ', NULL, 'האם יצא לך לקנות בגד חדש במיוחד לאירוע ספציפי? תןי דוגמא... '),
(1424, 'F1254', 1, 'כתוב SMS לבחורה חדשה שפגשת, ותסביר שזה לא ילך ביניכם, כשאתה משתמש במונחים מעולם הרפואה. ', 'כתבי SMS לבחור חדש שפגשת, ותסבירי שזה לא ילך ביניכם, כשאת משתמשת במונחים מעולם הכדורגל.', NULL, 'כתבו SMS לבחורה חדשה שזה לא ילך ביניכם, תוך שאתם משתמשים במונחים מעולם הכדורגלרפואה'),
(1425, 'F1255', 1, 'החברה שלך בגדה בך ומבקשת מחילה. סרב לה ב-SMS תוך שאתה משתמש במונחים מעולם המוסיקה. ', 'החבר שלך בגד בך ומבקש מחילה. סרבי לו ב SMS תוך שאת משתמשת במונחים מעולם המוסיקה. ', NULL, 'החברה שלך בגדה בך ומבקשת מחילה. סרבו לו ב SMS תוך שאתם משתמשים במונחים מעולם המוסיקה. '),
(1426, 'F1256', 1, 'מכריחים אותך להתחתן עם אחת מהשלוש- מיקי חיימוביץ, גאולה אבן, יונית לוי. במי תבחר ולמה?', 'מכריחים אותך להתחתן עם אחד מהשלושה - יעקב אילון, גיא זוהר, איתי אנגל. במי תבחרי ולמה?', NULL, 'מכריחים אתכם להתחתן עם מישהו מתחום החדשות. עם מי זה יהיה? '),
(1427, 'F1257', 1, 'איפה בא לך לגור?', 'איפה בא לך לגור?', NULL, 'איפה בא לך לגור?'),
(1428, 'F1258', 1, 'ספר על מקרה שבו היית עצבנית ואיבדת את זה לגמרי.', 'ספרי על מקרה שבו היית עצבנית ואיבדת את זה לגמרי. ', NULL, 'האם קרה לך שהיית עצבנית ואיבדת את זה לגמרי? אם כן, מה עיצבן אותך?'),
(1429, 'F1259', 1, 'אתה לא נרדם בלילה, איך אתה מעביר את הזמן?', 'את לא נרדמת בלילה, איך את מעבירה את הזמן?', NULL, 'אתה לא נרדםת בלילה, איך מעבירה את הזמן?'),
(1430, 'F1260', 1, 'מה תנשנש כשאתה במצב רוח רע?', 'מה תנשנשי כשאת במצב רוח רע?', NULL, 'מה תנשנשי כשאתה במצב רוח רע?'),
(1431, 'F1261', 1, 'את מי תרצה להכיר מהשלוש? נסיכה, מדענית פיסיקה, או פסיכולוגית', 'את מי תרצי להכיר מהשלושה? נסיך, מדען פיסיקה, או פסיכולוג', NULL, 'את מי מהשלושה תרצו להכיר? נסיךה, מדעןית פיסיקה, או פסיכולוגית'),
(1432, 'F1262', 1, 'מה לא כדאי לבחורה להגיד בדייט ראשון איתך?', 'מה לא כדאי לגבר להגיד בדייט ראשון איתך?', NULL, 'מה לא כדאי להגיד בדייט ראשון איתך?'),
(1433, 'F1263', 1, 'מה זה עושה לך אם היא מתלהבת ממך בגלוי ישר על ההתחלה?', 'מה זה עושה לך אם הוא מתלהב ממך בגלוי ישר על ההתחלה?', NULL, 'מה זה עושה לך אם הואהיא מתלהבת ממך ישר על ההתחלה?'),
(1434, 'F1264', 1, 'אחרי כמה דייטיםזמן הגיוני לצפות לבלעדיות בקשר?', 'אחרי כמה דייטיםזמן הגיוני לצפות לבלעדיות בקשר?', NULL, 'אחרי כמה דייטיםזמן הגיוני לצפות לבלעדיות בקשר?'),
(1435, 'F1265', 1, 'האם יש מצב שתקבע מראש שני דייטים עם בחורות שונות לאותו השבוע?', 'האם יש מצב שתקבעי מראש שני דייטים עם גברים שונים לאותו השבוע?', NULL, 'האם יש מצב שתקבעו מראש שני דייטים עם אחריםות לאותו השבוע?'),
(1436, 'F1266', 1, 'האם תסכים לצאת איתה אם תדע שהיא כבר קבעה דייט נוסף עם אחר לאותו השבוע?', 'האם תסכימי לצאת איתו, אם תדעי שהוא כבר קבע דייט נוסף עם אחרת לאותו השבוע?', NULL, 'האם תסכימו לצאת לדייט אם תדעו שהואהיא קבעו דייט נוסף לאותו השבוע?'),
(1437, 'F1267', 1, 'איזה דייט איכותי בעיניך?', 'איזה דייט איכותי בעינייך?', NULL, NULL),
(1438, 'F1268', 1, 'אם היתה לך מכונת זמן, לאיזו תקופה היה בא לך לנסוע?', 'אם היתה לך מכונת זמן, לאיזו תקופה היה בא לך לנסוע?', NULL, 'אם היתה לך מכונת זמן, לאיזו תקופה היה בא לך לנסוע?'),
(1439, 'F1269', 1, 'אם יכולת למחוק רגע מהעבר שלך, איזה רגע היית מוחק?', 'אם יכולת למחוק רגע מהעבר שלך, איזה רגע היית מוחקת?', NULL, 'אם יכולת למחוק רגע מהעבר שלך, איזה רגע היית מוחקת?'),
(1440, 'F1270', 1, 'אם יכולת לשחזר רגע מהעבר שלך, איזה רגע היית משחזר?', 'אם יכולת לשחזר רגע מהעבר שלך, איזה רגע היית משחזרת?', NULL, 'אם יכולת לשחזר רגע מהעבר שלך, איזה רגע היית משחזרת?'),
(1441, 'F1271', 1, 'אתה יכול לקבל לילה סוער עם כוכבת קולנוע. במי תבחר?', 'את יכולה לקבל לילה סוער עם כוכב קולנוע. במי תבחרי?', NULL, 'אתם יכולים לקבל בילוי סוער עם כוכבת קולנוע. במי תבחרו?'),
(1442, 'F1272', 1, 'איפה תבחר להיות זבוב על הקיר? (למשל, בחדר שבו דנים בהעלאת שכר שלך, או בחדר שבו האקסית מספרת לחברה שלה מדוע נפרדה ממך, וכו\'... )', 'איפה תבחרי להיות זבוב על הקיר? (למשל בחדר שבו דנים בהעלאת שכר שלך, או בחדר שבו האקס מספר לחבר שלו מדוע נפרד ממך, וכו\'..) ', NULL, 'איפה תבחרו להיות זבוב על הקיר?'),
(1443, 'F1273', 1, 'איזה מספר אתה אם 1 זה הכי זרוק ו-10 זה הכי מקפיד בלבוש?', 'איזה מספר את אם 1 זה הכי זרוקה ו-10 זה הכי מקפידה בלבוש?', NULL, 'איזה מספר אתה אם 1 זה הכי זרוקה ו-10 זה הכי מקפידה בלבוש?'),
(1444, 'F1274', 1, 'איזה מספר אתה אם 1 זה הכי הכי אוהב להיות בבית ו-10 זה בליין? ', 'איזה מספר את אם 1 זה הכי הכי אוהבת להיות בבית ו-10 זה בליינית? ', NULL, 'איזה מספר אתה אם 1 זה הכי הכי אוהבת להיות בבית ו-10 זה בליינית? '),
(1445, 'F1275', 1, 'איזה מספר אתה אם 1 זה הכי פחדן ו-10 זה הכי אמיץ? ', 'איזה מספר את אם 1 זה הכי פחדנית ו-10 זה הכי אמיצה? ', NULL, 'איזה מספר אתה אם 1 זה הכי פחדנית ו-10 זה הכי אמיצה? '),
(1446, 'F1276', 1, 'איזה מספר אתה אם 1 זה הכי מתבודד ו-10 זה הכי חברותי?', 'איזה מספר את אם 1 זה הכי מתבודדת ו-10 זה הכי חברותית?', NULL, 'איזה מספר אתה אם 1 זה הכי מתבודדת ו-10 זה הכי חברותית?'),
(1447, 'F1277', 1, 'איזה מספר אתה אם 1 זה הכי ריאליסטי ו-10 זה הכי פנטזיונר?', 'איזה מספר את אם 1 זה הכי ריאליסטית ו-10 זה הכי פנטזיונרית?', NULL, 'איזה מספר אתה אם 1 זה הכי ריאליסטית ו-10 זה הכי פנטזיונרית?'),
(1448, 'F1278', 1, 'איזה מספר אתה אם 1 זה הכי פסימי ו-10 זה הכי אופטימי?', 'איזה מספר את אם 1 זה הכי פסימית ו-10 זה הכי אופטימית?', NULL, 'איזה מספר אתה אם 1 זה הכי פסימית ו-10 זה הכי אופטימית?'),
(1449, 'F1279', 1, 'איזה מספר אתה אם 1 זה הכי מתוכנן ו-10 זה הכי ספונטני?', 'איזה מספר את אם 1 זה הכי מתוכננת ו-10 זה הכי ספונטנית?', NULL, 'איזה מספר אתה אם 1 זה הכי מתוכננת ו-10 זה הכי ספונטנית?'),
(1450, 'F1280', 1, 'איזה מספר אתה אם 1 זה הכי קשוח ו-10 זה הכי בוכה בסרטים?', 'איזה מספר את אם 1 זה הכי קשוחה ו-10 זה הכי בוכה בסרטים?', NULL, 'איזה מספר אתה אם 1 זה הכי קשוחה ו-10 זה הכי בוכה בסרטים?'),
(1451, 'F1281', 1, 'איזה מספר אתה אם 1 זה הכי לא יכול להתחייב ו-10 זה הכי אוהב מערכות יחסים?', 'איזה מספר את אם 1 זה הכי לא יכולה להתחייב ו-10 זה הכי אוהבת מערכות יחסים?', NULL, 'איזה מספר אתה אם 1 זה הכי לא יכולה להתחייב ו-10 זה הכי אוהבת מערכות יחסים?'),
(1452, 'F1282', 1, 'איזה מספר אתה אם 1 זה הכי עקשן ו-10 זה הכי מוותר וזורם?', 'איזה מספר את אם 1 זה הכי עקשנית ו-10 זה הכי מוותרת וזורמת?', NULL, 'איזה מספר אתה אם 1 זה הכי עקשנית ו-10 זה הכי מוותרת וזורמת?'),
(1453, 'F1283', 1, 'איזה משקה אתה אוהב לשתות בפאב?', 'איזה משקה את אוהבת לשתות בפאב?', NULL, 'איזה משקה אתם אוהבים לשתות בפאב?'),
(1454, 'F1284', 1, 'תן שיר אחד שאם תשמע אותו בפאב, תקום ותגיד \"ריספקט\"', 'תני שיר אחד שאם תשמעי אותו מתנגן בפאב, תקומי ותגידי \"ריספקט\"', NULL, 'שיר אחד שאם תשמעו אותו בפאב תקומו ותגידו \"ריספקט\"'),
(1455, 'F1285', 1, 'איזה דייט איכותי בעיניך?', 'איזה דייט איכותי בעינייך?', NULL, NULL),
(1456, 'F1286', 1, 'האם יצא לך להשתכר בפאב שהיה צריך לאסוף אותך מהרצפה?', 'האם יצא לך להשתכר בפאב שהיה צריך לאסוף אותך מהרצפה?', NULL, 'האם יצא לך להשתכר בפאב שהיה צריך לאסוף אותך מהרצפה?'),
(1457, 'F1287', 1, 'איזה סוג בירה אתה הכי אוהב?', 'איזה סוג בירה את הכי אוהבת?', NULL, 'איזה סוג בירה אתם הכי אוהבים?'),
(1458, 'F1288', 1, 'ספר על ז\'אנר סרטים אקסטרימי שאתה אוהב.  ', 'ספרי על ז\'אנר סרטים אקסטרימי שאת אוהבת.', NULL, 'ספרו על ז\'אנר סרטים אקסטרימי שאתם אוהבים, למשל סרטים על ערפדים, אימה, וכו\'... '),
(1459, 'F1289', 1, 'לאיזה מקום בעולם הכי בא לך לנסוע עכשיו?', 'לאיזה מקום בעולם הכי בא לך לנסוע עכשיו?', NULL, 'לאיזה מקום בעולם הכי בא לך לנסוע עכשיו?'),
(1460, 'F1290', 1, 'היפרד מחברה שלך ב-SMS', 'היפרדי מחבר שלך ב-SMS', NULL, 'פרידה ב SMS'),
(1461, 'F1291', 1, 'טוב, בתכלס, איזה אוכל טעים אתה אלוף בלהכין?', 'טוב, תכלס, איזה אוכל טעים את אלופה בלהכין?', NULL, 'טוב, תכלס, איזה אוכל טעים אתה יודעת להכין?'),
(1462, 'F1292', 1, 'תאר באחוזים את סדר העדיפויות עבורך', 'תארי באחוזים את סדר העדיפויות עבורך', NULL, NULL),
(1463, 'F1293', 1, 'מי האחרוןה שעשהתה לך מסאז\'? ואיפה?', 'מי האחרוןה שעשהתה לך מסאז\'? ואיפה?', NULL, 'מי האחרוןה שעשהתה לך מסאז\'? ואיפה?'),
(1464, 'F1294', 1, 'את מי תיקח איתך לאי בודד? ומה תעשו שם כל הזמן? ', 'את מי תקחי איתך לאי בודד? ומה תעשו שם כל הזמן?', NULL, 'את מי תקחי איתך לאי בודד?'),
(1465, 'F1295', 1, 'השב ב \"נחמד, מעולה, לא נורא, מבאס\" וכו\'...', 'השיבי ב \"נחמד, מעולה, לא נורא, מבאס\" וכו\'...', NULL, NULL),
(1466, 'F1297', 1, 'אילו דברים אתה יודע להכין? השלם את החסר רק במילים כן או לא או ככה ככה ', 'אילו דברים את יודעת להכין? השלימי את החסר רק בכן או לא או ככה ככה ', NULL, NULL),
(1467, 'F1298', 1, 'אילו דברים אתה יודע להכין? השלם את החסר רק במילים כן או לא או ככה ככה ', 'אילו דברים את יודעת להכין? השלימי את החסר רק בכן או לא או ככה ככה ', NULL, NULL),
(1468, 'F1299', 1, 'אילו דברים אתה יודע להכין? השלם את החסר רק במילים כן או לא או ככה ככה ', 'אילו דברים את יודעת להכין? השלימי את החסר רק בכן או לא או ככה ככה ', NULL, NULL),
(1469, 'F1300', 1, 'שיפשפת מנורה והג\'יני אמרה שתוכל להיות מי  מה שאתה רוצה למשך שבוע. איזה מפורסם היית רוצה להיות? ', 'שיפשפת מנורה והג\'יני אמרה שתוכלי להיות מי  מה שאת רוצה למשך שבוע. איזו מפורסמת היית רוצה להיות?', NULL, 'איזה מפורסםת היית רוצה להיות? '),
(1470, 'F1302', 1, 'פרצה שריפה בבית – אילו שלושה פריטים תציל?', 'פרצה שריפה בבית – אילו שלושה פריטים תצילי?', NULL, 'פרצה שריפה בבית – אילו שלושה פריטים תצילו? '),
(1471, 'F1304', 1, 'אם יציעו לך ללמד אחרים באופן פרטי משהו שאתה מומחה בו תמורת כסף טוב. מה זה יהיה? ', 'אם יציעו לך ללמד אחרים באופן פרטי משהו שאת מומחית בו תמורת כסף טוב. מה זה יהיה? ', NULL, 'במה אתם הכי טובים ללמד אחרים באופן פרטי? '),
(1472, 'F1305', 1, 'האם יש לך על הגוף קעקוע? איפה? מה מצויר?', 'האם יש לך על הגוף קעקוע? איפה? מה מצויר?', NULL, 'האם יש לך על הגוף קעקוע? איפה? מה מצויר?'),
(1473, 'F1307', 1, 'ספר על כינוי או שם חיבה שהחבריםמשפחה נוהגים לכנות אותך', 'ספרי על כינוי או שם חיבה שהחבריםמשפחה נוהגים לכנות אותך', NULL, 'ספרי על כינוי או שם חיבה שהחבריםמשפחה נוהגים לכנות אותך'),
(1474, 'F1308', 1, 'ספר איך אתה מזיז את הגוף שלך במהלך השבוע כדי לשמור על כושר ולא להיות בטטה ', 'ספרי איך את מזיזה את הגוף שלך במהלך השבוע כדי לשמור על כושר ולא להיות בטטה', NULL, 'ספרו איך אתם מזיזים את הגוף שלכם במהלך השבוע כדי להיות בטטה'),
(1475, 'F1309', 1, 'באיזה צד של המיטה אתה ישן? ', 'באיזה צד של המיטה את ישנה? ', NULL, 'באיזה צד של המיטה אתם ישנים?'),
(1476, 'F1310', 1, 'מה היתה התחפושת הכי שווה  אי פעם שהתחפשת בפורים? ', 'מה היתה התחפושת הכי שווה  אי פעם שהתחפשת בפורים? ', NULL, 'למה התחפשת בפורים?'),
(1477, 'F1311', 1, 'באיזה כלי נגינה היית רוצה לדעת לנגן?', 'באיזה כלי נגינה היית רוצה לדעת לנגן?', NULL, 'באיזה כלי נגינה היית רוצה לדעת לנגן?'),
(1478, 'F1312', 1, 'השב ב מילים כמו \"מאוד, בכלל לא, ככה ככה\"', 'השיבי ב מילים כמו \"מאוד, בכלל לא, ככה ככה\"', NULL, NULL),
(1479, 'F1313', 1, 'איך אתה בבקרים ובלילות?', 'איך את בבקרים ובלילות?', NULL, NULL),
(1480, 'F1314', 1, 'רוצה משהו חם לשתות?', 'רוצה משהו חם לשתות?', NULL, 'רוצה משהו חם לשתות?'),
(1481, 'F1315', 1, 'השלם', 'השלימי', NULL, NULL),
(1482, 'F1316', 1, 'כמה זמן בממוצע ביום אתה מבלה ברשתות חברתיות?', 'כמה זמן בממוצע ביום את מבלה ברשתות חברתיות?', NULL, 'כמה זמן בממוצע ביום אתם מבלים ברשתות חברתיות?'),
(1483, 'F1317', 1, 'נשיקה ראשונה', 'נשיקה ראשונה', NULL, NULL),
(1484, 'F1318', 1, 'מסעדה', 'מסעדה', NULL, NULL),
(1485, 'F1321', 1, 'באיזה גיל עשית רישיון נהיגה, וכמה טסטים לקח לך לעבור?', 'באיזה גיל עשית רישיון נהיגה, וכמה טסטים לקח לך לעבור?', NULL, 'באיזה גיל עשית רישיון נהיגה, וכמה טסטים לקח לך לעבור?'),
(1486, 'F1322', 1, 'באיזה סוג ספורט אתה הכי אוהב לצפות בטלוויזיה? עם מי?', 'באיזה סוג ספורט את הכי אוהבת לצפות בטלוויזיה? עם מי? ', NULL, 'באיזה סוג ספורט אתה הכי אוהבת לצפות בטלויזיה? '),
(1487, 'F1323', 1, 'מה אכלת הבוקר?', 'מה אכלת הבוקר?', NULL, 'מה אכלת הבוקר?'),
(1488, 'F1324', 1, 'מה אתה מסבן ראשון במקלחת?', 'מה את מסבנת ראשונה במקלחת?', NULL, 'איזה איבר אתם מסבנים ראשון במקלחת?'),
(1489, 'F1325', 1, 'נניח שיתפסו אותך לוטש עיניים במישהי, באיזה חלק של הגוף שלה תביט?', 'נניח שיתפסו אותך לוטשת עיניים במישהו, באיזה חלק של הגוף שלו תביטי? ', NULL, 'נניח שתופסים אותך לוטשים עיניים במישהוי, באיזה חלק של הגוף שלוה תביטי? '),
(1490, 'F1326', 1, 'איזה חשבון אתה הכי שונא לשלם? ', 'איזה חשבון את הכי שונאת לשלם? ', NULL, 'איזה חשבון אתם הכי שונאים לשלם?'),
(1491, 'F1327', 1, 'טיסה', 'טיסה', NULL, NULL),
(1492, 'F1328', 1, 'גלישה באינטרנט', 'גלישה באינטרנט', NULL, NULL),
(1493, 'F1329', 1, 'מה המצב?', 'מה המצב?', NULL, NULL),
(1494, 'F1330', 1, 'ספר על חפץ שלך, בעלך ערך משמעותי ומיוחד עבורך', 'ספרי על חפץ שלך, בעל ערך משמעותי ומיוחד עבורך', NULL, 'ספרו על חפץ שלכם, בעל ערך משמעותי ומיוחד עבוכם'),
(1495, 'F1331', 1, 'איך אתה מבלה בחוף הים? וכמה זמן?', 'איך את מבלה בחוף הים? וכמה זמן?', NULL, NULL),
(1496, 'F1332', 1, 'ספר על מאכל טעים במיוחד, שאמא שלך היתה מכינה לך כשהיית ילד', 'ספרי על מאכל טעים במיוחד שאמא שלך היתה מכינה לך כשהיית ילדה', NULL, 'ספרו על מאכל טעים במיוחד שאמא היתה מכינה כשהייתם ילדים'),
(1497, 'F1333', 1, 'איזה מספר אתה אם 1 זה הכי מופנם, ו-10 זה הכי מוחצן?', 'איזה מספר את אם 1 זה הכי מופנם, ו-10 זה הכי מוחצן?', NULL, 'איזה מספר אתם אם 1 זה הכי מופנמים ו-10 זה הכי מוחצנים?'),
(1498, 'F1334', 1, 'ספר על מאכל דוחה במיוחד שאתה שונא לאכול:', 'ספרי על מאכל דוחה במיוחד שאת שונאת לאכול:', NULL, 'ספרו על מאכל דוחה ביוחד שיצא לכם לאכול בעבר'),
(1499, 'F1335', 1, 'איזה סיגנון אתה הכי אוהב לרקוד?', 'איזה סיגנון את הכי אוהבת לרקוד?', NULL, 'איזה סיגנון אתם הכי אוהבים לרקוד? '),
(1500, 'F1336', 1, 'איזה סרט הכי אהבת כשהיית ילד?', 'איזה סרט הכי אהבת כשהיית ילדה?', NULL, 'איזה סרט הכי אהבת כשהיית ילדה?'),
(1501, 'F1337', 1, 'מהי ההופעה האחרונה שראית ומתי?', 'מהי ההופעה האחרונה שראית ומתי?', NULL, 'מהי ההופעה האחרונה שראית ומתי?'),
(1502, 'F1338', 1, 'איזה מזל אתה, והאם אתה בכלל מאמין באסטרולוגיה?', 'איזה מזל את, והאם את בכלל מאמינה באסטרולוגיה?', NULL, 'איזה מזל אתה והאם אתה בכלל מאמינה באסטרולוגיה? '),
(1503, 'F1339', 1, 'במה אתה ממש טוב?', 'במה את ממש טובה?', NULL, NULL),
(1504, 'F1340', 1, 'תעודה', 'תעודה', NULL, NULL),
(1505, 'F1341', 1, 'האם אתה אספן של משהו? (בולים, מפיות, דמויות מסטארטרק וכו\'... ) ', 'האם אתה אספן של משהו? (בולים, מפיות, דמויות מסטארטרק וכו\'... ) ', NULL, 'האם אתם אספנים של משהו?'),
(1506, 'F1342', 1, 'איך אתה עם פאזלים?', 'איך את עם פאזלים?', NULL, 'איך אתם עם פאזלים?'),
(1507, 'F1343', 1, 'איך בילית את השבת האחרונה?', 'איך בילית את השבת האחרונה?', NULL, 'איך בילית את השבת האחרונה?'),
(1508, 'F1344', 1, 'כמה חברים הכי טובים יש לך? (כאלה שתעשה הכל בשבילם), וכמה חברים  ידידים רגילים?', 'כמה חברים הכי טובים יש לך? (כאלה שתעשי הכל בשבילם), וכמה חברים  ידידים רגילים?', NULL, 'כמה חברים הכי טובים יש לך?'),
(1509, 'F1345', 1, 'ספר על ספר שקראת שהרשים אותך מאוד ', 'ספרי על ספר שקראת שהרשים אותך מאוד', NULL, 'ספרו על ספר שקראתם שהרשים אתכם מאוד'),
(1510, 'F1346', 1, 'ספר על העבודה הכי ביזארית שיצא לך לעבוד בה בעבר?', 'ספרי על העבודה הכי ביזארית שיצא לך לעבוד בה בעבר?', NULL, 'ספרי על העבודה הכי ביזארית שיצא לך לעבוד בה בעבר?'),
(1511, 'F1347', 1, 'כשאתה יחד עם חבר\'ה, האם אתה פעיל במרכז, או מביט מהצד ומהתערב בקטנה?', 'כשאת יחד עם חבר\'ה, האם את פעילה במרכז, או מביטה מהצד ומתערבת בקטנה?', NULL, 'כשאתם עם חברה, האם אתם במרכז, או בצד?'),
(1512, 'F1348', 1, 'האם יצא לך להופיעלהרצות מול קבוצה גדולה של אנשים? איפה?', 'האם יצא לך להופיעלהרצות מול קבוצה גדולה של אנשים? איפה?', NULL, 'האם יצא לך להופיעלהרצות מול קבוצה גדולה של אנשים?'),
(1513, 'F1349', 1, ' ערב, אתה מחוק וגמור מעייפות אחרי יום עבודה מתיש, בקושי עומד. לאיזה בילוי תסכים בכל זאת?', ' ערב, את מחוקה וגמורה מעייפות אחרי יום עבודה מתיש, בקושי עומדת. לאיזה בילוי תסכימי בכל זאת?', NULL, 'בערב אחרי יום עבודה מתיש, איזה בילוי הכי מתחשק לך? '),
(1514, 'F1350', 1, 'איזו עונה אתה הכי אוהב? ', 'איזו עונה את הכי אוהבת? ', NULL, 'איזו עונה אתם הכי אוהבים? למה?'),
(1515, 'F1351', 1, 'דרג כל פרמטר מ-1 עד 10 ', 'דרגי כל פרמטר -1 עד 10', NULL, NULL),
(1516, 'F1352', 1, 'ממה אתה הכי נעלב?', 'ממה את הכי נעלבת?', NULL, 'ממה אתם הכי נעלבים?'),
(1517, 'F1353', 1, 'ספר על משהו אחד שאתה מאושר ממנו בחייך כיום', 'ספרי על משהו אחד שאת מאושרת ממנו בחייך כיום', NULL, 'ספרו על משהו אחד שאתם מאושרים ממנו בחייכם כיום'),
(1518, 'F1354', 1, 'פנטהאוז עם נוף מדהים לים, או בית בכפר עם גינה? או משהו אחר?', 'פנטהאוז עם נוף מדהים לים, או בית בכפר עם גינה? או משהו אחר?', NULL, 'איפה לגור? דירת פנטהאוז עם נוף מדהים לים, או בית עם גינה?'),
(1519, 'F1355', 1, 'מה בעבודה שלך אתה הכי אוהב?', 'מה בעבודה שלך את הכי אוהבת?', NULL, 'מה בעבודה שלך אתה הכי אוהבת'),
(1520, 'F1356', 1, 'איזה סרט שאתה אוהב יצא לך לראות הרבה פעמים ואין לך בעיה לצפות בו שוב?', 'איזה סרט שאת אוהת יצא לך לראות הרבה פעמים ואין לך בעיה לצפות בו שוב?', NULL, 'איזה סרט אתם אוהבים ובא לכם לצפות שוב ושוב?'),
(1521, 'F1357', 1, 'נניח שבחורה תבחר בך לפי שיר שתשמיע לה מהנגן שלך. איזה שיר תשים כדי לעשות עליה רושם?', 'נניח שבחור יבחר בך לפי שיר שתשמיעי לו מהנגן שלך. איזה שיר תשימי כדי לעשות עליו רושם?', NULL, 'נניח שיבחרו בכם לפי שיר, איזה שיר תשמיעו?'),
(1522, 'F1358', 1, 'חו\"ל - הופעות וריקודים, או תרבות ואמנות? או משהו אחר?', 'בחופשה חו\"ל - הופעות וריקודים, או תרבות ואמנות? או משהו אחר?', NULL, 'כשאתם בחו\"ל, אתם בעניין של תרבות ואמנות, או בעניין של בילויים והופעות?'),
(1523, 'F1359', 1, 'השלם במילים \"יש מצב\" או \"אין מצב\". ', 'השלימי במילים \"יש מצב\" או \"אין מצב\"', NULL, NULL),
(1524, 'F1360', 1, 'האם יש מצב שתהיה בן זוג של שחקנית שצריכה לצלם סצינות פיזיות עם  גברים אחרים על המסך בסרטי מיינסטרים?', 'האם יש מצב שתהיי בת זוג של שחקן שצריך לצלם סצינות פיזיות עם נשים אחרות על המסך בסרטי מיינסטרים?', NULL, 'האם יש מצב שתהיו בני זוג של שחקנים שצריכים לצלם סצינות פיזיות עם אחריםות בסרטי מיינסטרים?'),
(1525, 'F1361', 1, 'השלם במילים \"יש מצב\" או \"אין מצב\". ', 'השלימי במילים \"יש מצב\" או \"אין מצב\"', NULL, NULL),
(1526, 'F1362', 1, 'במה תבחר נכון לרגע זה?', 'במה תבחרי נכון לרגע זה? ', NULL, NULL),
(1527, 'F1363', 1, 'במה תבחר נכון לרגע זה?', 'במה תבחרי נכון לרגע זה? ', NULL, NULL),
(1528, 'F1364', 1, 'במה תבחר נכון לרגע זה?', 'במה תבחרי נכון לרגע זה? ', NULL, NULL),
(1529, 'F1369', 1, 'מה יש לך בכיסים עכשיו?', 'מה יש לך בכיסים עכשיו?', NULL, 'מה יש לך בכיסים עכשיו?'),
(1530, 'F1370', 1, 'מה אתה לובש עכשיו?', 'מה את לובשת עכשיו?', NULL, NULL),
(1531, 'F1371', 1, 'איזו חובת תחזוקת בית אתה הכי שונא לעשות?', 'איזו חובת תחזוקת בית את הכי שונאת לעשות?', NULL, 'איזו חובת תחזוקת בית אתם הכי שונאים לעשות?'),
(1532, 'F1372', 1, 'אתה שותה אלכוהול בבר. מה הגבול שלך מבחינת כמות או מספר משקאות?', 'את שותה אלכוהול בבר. מה הגבול שלך מבחינת כמות, או מספר משקאות?', NULL, 'האם אתם שמים לעצמכם גבול כשאתם שותים אלכוהול בבילוי בערב?'),
(1533, 'F1373', 1, 'אם תשתתף בחידון, באיזה נושא היית זוכה מקום ראשון?', 'אם תשתתפי בחידון, באיזה נושא היית זוכה מקום ראשון?', NULL, 'אם תשתתףי בחידון, באיזה נושא היית זוכה מקום ראשון?'),
(1534, 'F1374', 1, 'איזה הרגל של אחד החברים שלך מטריף לך את השכל?', 'איזה הרגל של אחת החברות שלך מטריף לך את השכל?', NULL, 'איזה הרגל של אחד החבריםות שלך מטריף לך את השכל?'),
(1535, 'F1376', 1, 'השלם:', 'השלימי:', NULL, NULL),
(1536, 'F1377', 1, 'איזה שיר קיטשי אתה הכי אוהב?', 'איזה שיר קיטשי את הכי אוהבת?', NULL, 'איזה שיר רומנטיקיטשי אתם הכי אוהבים?'),
(1537, 'F1378', 1, 'אתה נבוך כשאתה בחברה ומקרינים סצינת סקס?', 'את נבוכה, כשאת בחברה ומקרינים סצינת סקס?', NULL, 'אם אתם יוצאים לדייט סרט, האם אתם נבוכים כשמקרינים סצינת סקס?'),
(1538, 'F1379', 1, 'מה אתה אוהב לאכול במיטה?', 'מה את אוהבת לאכול במיטה?', NULL, 'האם יש מאכל שאתם אוהבים לאכול במיטה?'),
(1539, 'F1380', 1, 'אם יגידו לך שאתה דומה למישהו מפורסם, למי אתה דומה?', 'אם יגידו לך שאת דומה למישהי מפורסמת, למי את דומה? ', NULL, 'אם אתם דומים למפורסםת, למי? '),
(1540, 'F1381', 1, 'איזה סוג מסאז\' אתה הכי אוהב?', 'איזה סוג מסאז\' את הכי אוהבת? ', NULL, 'איזה סוג מסאז\' אתם הכי אוהבים?'),
(1541, 'F1382', 1, 'האם יצא לך לטייל משך זמן של לפחות כמה ימים לבד לבד? אם כן, באיזו סיטואציה?', 'האם יצא לך לטייל משך זמן של לפחות כמה ימים לבד לבד? אם כן, באיזו סיטואציה?', NULL, 'האם יצא לך לטייל לפחות כמה ימים לבד לבד? אם כן, באיזו סיטואציה?'),
(1542, 'F1383', 1, 'האם אתה אוהב להירדם עם מוסיקה? איזה?', 'האם את אוהבת להירדם עם מוסיקה? איזה?', NULL, 'האם אתם אוהבים להירדם עם מוסיקה? אם כן, איזה סוג? '),
(1543, 'F1384', 1, 'אילו תחתונים יש לך במגירה? ענה ב\"כן ו\"לא\" ', 'אילו תחתונים יש לך במגירה? עני ב\"כן ו\"לא\" ', NULL, 'אילו תחתונים יש לכם במגירה?'),
(1544, 'F1385', 1, 'מה יעשה אותך מאושר יותר בזה הרגע?', 'מה יעשה אותך מאושר יותר בזה הרגע?', NULL, 'מה יעשה אותך מאושר יותר בזה הרגע?'),
(1545, 'F1386', 1, 'השב ב מילים כמו \"מאוד, בכלל לא, ככה ככה\"', 'השיבי ב מילים כמו \"מאוד, בכלל לא, ככה ככה\"', NULL, NULL),
(1546, 'F1387', 1, 'באיזה גיל שתית לראשונה אלכוהול? איזה משקה זה היה? ', 'באיזה גיל שתית לראשונה אלכוהול? איזה משקה זה היה? ', NULL, 'באיזה גיל שתית לראשונה אלכוהול? איזה משקה זה היה? '),
(1547, 'F1388', 1, 'ספר על משהו חשוב אחד, שכל מי שמכיר אותך אפילו קצת, בטוח יודע עליך. ', 'ספרי על משהו חשוב אחד, שכל מי שמכיר אותך אפילו קצת, בטוח יודע עליך. ', NULL, 'ספרי על משהו חשוב אחד, שכל מי שמכיר אותך אפילו קצת, בטוח יודע עליך. '),
(1548, 'F1389', 1, 'מה אתה רוצה להיות כשתהיה \"גדול\"? ', 'מה את רוצה להיות כשתהיי \"גדולה\"? ', NULL, 'מה אתם רוצים להיות כשתהיו \"גדולים\"?'),
(1549, 'F1390', 1, 'האם יש לך פוביה כלשהי? מהי?', 'האם יש לך פוביה כלשהי? מהי?', NULL, 'האם יש לך פוביה כלשהי? מהי?'),
(1550, 'F1391', 1, 'חולם להיות מפורסם? באיזה תחום?', 'חולמת להיות מפורסמת? באיזה תחום?', NULL, 'הייתם רוצים להיות מפורסמים? באיזה תחום?'),
(1551, 'F1392', 1, 'כשאתה מחייג למישהי, האם יוצא לך לעשות חזרות בראש על מה שאתה הולך להגיד? יש לך דוגמא?', 'כשאת מחייגת למישהו, האם יוצא לך לעשות חזרות בראש על מה שאת הולכת להגיד? יש לך דוגמא?', NULL, 'כשאתה מחייגת, האם יוצא לך לעשות חזרות בראש על מה שאתה הולךת להגיד? '),
(1552, 'F1393', 1, 'האם אתה שר במקלחת? איזה שיר?', 'האם את שרה במקלחת? איזה שיר? ', NULL, 'האם אתה שרה במקלחת? איזה שיר שרת לעצמך לאחרונה? '),
(1553, 'F1394', 1, 'האם יצא לך לשיר בפני קהל? איפה?', 'האם יצא לך לשיר בפני קהל? איפה?', NULL, 'האם יצא לך לשיר בפני קהל? באיזו סיטואציה?'),
(1554, 'F1395', 1, 'מה עדיף? שיהיה לה גוף מדהים, והיא טיפשה במיוחד, או גוף ממוצע, וחכמה במיוחד?', 'מה עדיף? שיהיה לו גוף מדהים והוא טיפש במיוחד? או גוף ממוצע והוא חכם במיוחד?', NULL, 'מה עדיף? גוף מדהים בלי שכל בכלל? או גוף ממוצע וחכםה במיוחד?'),
(1555, 'F1396', 1, 'מה עדיף? שיהיה לה חיוך מיליון דולר עם צחוק מעצבן, או חיוך עקום עם צחוק מקסים ומדבק?', 'מה עדיף? שיהיה לו חיוך מיליון דולר עם צחוק מעצבן, או חיוך עקום עם צחוק מקסים ומדבק?', NULL, 'מה עדיף? שיהיה לולה חיוך מיליון דולר אבל צחוק מעצבן, או חיוך עקום אבל צחוק מקסים ומדבק?'),
(1556, 'F1397', 1, 'עד כמה חשוב לך שהיא תהיה בנאדם רגיש לאחרים?', 'עד כמה חשוב לך שהוא יהיה בנאדם רגיש לאחרים?', NULL, 'עד כמה חשוב לך שהואהיא יהיו בנאדם רגיש לאחרים?'),
(1557, 'F1398', 1, 'מה עדיף? שהיא תהיה יפיפיה וגברים יתחילו איתה כל הזמן, או שתהיה ממוצעת, וכך היא תיתקל בפחות פיתויים ביום יום?', 'מה עדיף? שהוא יהיה יפיוף ובחורות יתחילו איתו כל הזמן, או שיהיה ממוצע, וכך הוא יתקל בפחות פיתויים ביום יום?', NULL, 'מה עדיף? שהואהיא יהיו יפיופים ויתחילו איתם כל הזמן, או שיהיו ממוצעים וכך יתקלו בפחות פיתויים ביום יום?'),
(1558, 'F1399', 1, 'האם אתה מאמין שיש דבר כזה בחורה שהיא \"נפש תאומה\" שלך? ', 'האם את מאמינה שיש דבר כזה גבר שהוא \"נפש תאומה\" שלך?', NULL, 'האם אתם מאמינים שיש דבר כזה \"נפש תאומה\"?'),
(1559, 'F1400', 1, 'ספר על תכונה אחת שבה אתה מאוד דומה לאבא שלך', 'ספרי על תכונה אחת שבה את מאוד דומה לאמא שלך', NULL, 'ספרו על תכונה אחת שבה אתם דומים לאבאאמא'),
(1560, 'F1403', 1, 'גש לשיחות וואטסאפ שלך. העתק לכאן הודעה כלשהי שכתבת שמייצגת את מצב הרוח שלך היום', 'גשי לשיחות וואטסאפ שלך. העתיקי לכאן הודעה כלשהי שכתבת שמייצגת את מצב הרוח שלך היום', NULL, 'העתיקו לכאן הודעה כלשהי שכתבתם, שמייצגת את מצב הרוח שלכם היום'),
(1561, 'F1404', 1, 'עד כמה זה נכון, שאפשר להתאהב באדם יותר בזמן שהוא מפגין חולשה ופגיעות? ', 'עד כמה זה נכון, שאפשר להתאהב באדם יותר בזמן שהוא מפגין חולשה ופגיעות? ', NULL, 'עד כמה זה נכון, שאפשר להתאהב באדם יותר בזמן שהוא מפגין חולשה ופגיעות? '),
(1562, 'F1405', 1, 'אם פוגעים בך מאוד בחוסר צדק משווע, האם אתה נוטה לפגוע בחזרה?', 'אם פוגעים בך מאוד בחוסר צדק משווע, האם את נוטה לפגוע בחזרה?', NULL, 'אם פוגעים בך מאוד בחוסר צדק משווע, האם אתה נוטה לפגוע בחזרה?'),
(1563, 'F1406', 1, 'אם היה לך כדור בדולח שיודע על העתיד שלך... מה היית רוצה לדעת?', 'אם היה לך כדור בדולח שיודע על העתיד שלך... מה היית רוצה לדעת?', NULL, 'אם היה לך כדור בדולח שיודע הכל על החיים, על העתיד על הכל... מה היית רוצה לדעת?'),
(1564, 'F1407', 1, 'כמה אתה זוכר את החלומות שלך?', 'כמה את זוכרת את החלומות שלך? ', NULL, 'איזה אחוז מהחלומות שלכם אתם זוכרים?'),
(1565, 'F1408', 1, 'ספר על הישג שאתה גאה בו מהתקופה האחרונה', 'ספרי על הישג שאתה גאה בו מהתקופה האחרונה', NULL, 'ספרי על הישג שאתה גאה בו מהתקופה האחרונה'),
(1566, 'F1409', 1, 'החברה הכי טוב שלך מבקשת ממך עזרה כספית. תסכים, או שהחברות לא כוללת כסף?', 'החברה הכי טובה שלך מבקשת ממך עזרה כספית. תסכימי, או שהחברות לא כוללת כסף?', NULL, 'החברה הכי טובה מבקשת עזרה כספית, האם תסכימו?'),
(1567, 'F1410', 1, 'כמה קניות עשית בשנה האחרונה באינטרנט?', 'כמה קניות עשית בשנה האחרונה באינטרנט?', NULL, 'האם אתם נוהגים לקנות באינטרנט? כמה קניות עשיתם למשל בשנה האחרונה?'),
(1568, 'F1411', 1, 'ספר על זיכרון נעים', 'ספרי על זיכרון נעים', NULL, 'ספרי על זיכרון נעים מהשנים האחרונות'),
(1569, 'F1415', 1, 'איזה עצה בנושא דייטים תיתן לעצמך הצעיר יותר, מהניסיון שלך כיום? (למשל - תבוא בלי ציפיות, ככה לא תתאכזב)', 'איזו עצה בנושא דייטים תתני לעצמך הצעירה יותר, מהניסיון שלך כיום? (למשל - תבואי בלי ציפיות, ככה לא תתאכזבי)', NULL, 'איזו עצה בנושא דייטים הייתם נותנים לעצמכם הצעירים יותר מהניסיון שלכם כיום?'),
(1570, 'F1416', 1, 'מה זה עושה לך אם בחורה מסמיקה בגללך?', 'מה זה עושה לך אם בחור מסמיק בגללך?', NULL, 'מה זה עושה לכם אם מישהוי מסמיקה בגללך?'),
(1571, 'F1417', 1, 'היה לך דייט עם מישהי ונדמה לך שהלך טוב, אבל היא לא עונה ל-SMSים ממך. כמה פעמים תסמס לה עד שתחליט לוותר?', 'היה לך דייט עם מישהו ונדמה שהכל הלך טוב, אבל הוא נעלם ולא עונה ל-SMSים. כמה פעמיםזמן עד שתחליטי לוותר?', NULL, 'היה לכם דייט ונדמה שהכל הלך טוב, אבל הצד השני נעלם ולא עונה. כמה זמןפעמים תנסו ליצור קשר עד שתחליטו לוותר?'),
(1572, 'F1418', 1, 'קרה שאחרים לא הבינו אותך נכון? אם כן, באיזה עניין?', 'קרה שאחרים לא הבינו אותך נכון? אם כן, באיזה עניין?', NULL, 'קרה שאחרים לא הבינו אותך נכון? אם כן, באיזה עניין?'),
(1573, 'F1419', 1, 'מה בא לך לחלוק?', 'מה בא לך לחלוק?', NULL, NULL),
(1574, 'F1420', 1, 'איך תציג את עצמך בתחילת פגישת עבודה עם אנשים שאתה לא מכיר?', 'איך תציגי את עצמך בתחילת פגישת עבודה עם אנשים שאת לא מכירה?', NULL, 'איך תציגו את עצמכם בתחילת פגישת עבודה עם אנשים שאתם לא מכירים?'),
(1575, 'F1421', 1, 'חבר שלך מפגיש אותך עם חבר\'ה שלו שאינך מכיר. איך תציג את עצמך בפניהם? ', 'חברה שלך מפגישה אותך עם חבר\'ה שלה שאינך מכירה. איך תציגי את עצמך בפניהם?', NULL, 'חברה שלכם מציגה בפניכם חבר\'ה שאינכם מכירים. איך תציגו את עצמכם?'),
(1576, 'F1422', 1, 'נניח שהוזמנת למפגש מחזור של התיכון שלך. כתוב משפט קצר שבזכותו כולם יזהו מייד מי אתה. ', 'נניח שהוזמנת למפגש מחזור של התיכון שלך. כתבי משפט קצר שבזכותו כולם יזהו מייד מי את. ', NULL, 'נניח שהוזמנת למפגש מחזור של התיכון שלך. כתבו משפט קצר שבזכותו כולם יזהו מייד מי אתם. '),
(1577, 'F1423', 1, 'מארגנים תחרות כישרונות, ומותר להתחרות בכל תחום שקיים בעולם. במה תבקש להתחרות?', 'מארגנים תחרות כישרונות, ומותר להתחרות בכל תחום שקיים בעולם. במה תבקשי להתחרות?', NULL, 'מארגנים תחרות כישרונות, ומותר להתחרות בכל תחום שקיים בעולם. במה תבקשו להתחרות?'),
(1578, 'F1424', 1, 'איזה בגד הכי מחמיא לך? ', 'איזה בגד הכי מחמיא לך? ', NULL, 'איזה בגד הכי מחמיא לך? '),
(1579, 'F1425', 1, 'כמה זמן מותר לאחר לדייט, מבלי שזה נחשב איחור?', 'כמה זמן מותר לאחר לדייט, מבלי שזה נחשב איחור?', NULL, 'כמה זמן מותר לאחר לדייט, מבלי שזה נחשב איחור?'),
(1580, 'F1426', 1, 'מהו הזמן הארוך ביותר שנסעת רצוף במכונית? באיזו סיטואציה זה קרה?', 'מהו הזמן הארוך ביותר שנסעת רצוף במכונית? באיזו סיטואציה זה קרה?', NULL, 'מהו הזמן הארוך ביותר שנסעת רצוף במכונית? באיזו סיטואציה זה קרה?'),
(1581, 'F1427', 1, 'מה הדבר המוזר ביותר שאכלת אי פעם בחופשה?', 'מה הדבר המוזר ביותר שאכלת אי פעם בחופשה?', NULL, 'מה הדבר המוזר ביותר שאכלת אי פעם בחופשה?'),
(1582, 'F1428', 1, 'איפה היתה החופשה הגרועה ביותר שהיתה לך? למה היא היתה כל כך גרועה?', 'איפה היתה החופשה הגרועה ביותר שהיתה לך? למה היא היתה כל כך גרועה?', NULL, 'איפה היתה החופשה הגרועה ביותר שהיתה לך? למה היא היתה כל כך גרועה?'),
(1583, 'F1429', 1, 'איפה היתה החופשה הטובה ביותר שהיתה לך? מה עשה אותה כל כך טובה?', 'איפה היתה החופשה הטובה ביותר שהיתה לך? מה עשה אותה כל כך טובה?', NULL, 'איפה היתה החופשה הטובה ביותר שהיתה לך? מה עשה אותה כל כך טובה?'),
(1584, 'F1431', 1, 'באילו ארצות כבר ביקרת? יאללה לשפוך... ', 'באילו ארצות כבר ביקרת? יאללה לשפוך... ', NULL, 'באילו ארצות כבר ביקרת? יאללה לשפוך... '),
(1585, 'F1432', 1, 'איפה אתה נמצא עכשיו ולמה?', 'איפה את נמצאת עכשיו ולמה?', NULL, 'איפה אתם נמצאים עכשיו ולמה?'),
(1586, 'F1433', 1, 'מהי העבודה הכי כיפית שהיתה לך?', 'מהי העבודה הכי כיפית שהיתה לך?', NULL, 'מהי העבודה הכי כיפית שהיתה לך?'),
(1587, 'F1434', 1, 'מהי העבודה הכי מבאסת שהיתה לך?', 'מהי העבודה הכי מבאסת שהיתה לך?', NULL, 'מהי העבודה הכי מבאסת שהיתה לך?'),
(1588, 'F1435', 1, 'תאר במילה אחת את ההבנה והכישורים שלך במחשב', 'תארי את ההבנה והכישורים שלך במחשב', NULL, 'תארי את ההבנה והכישורים שלך במחשב'),
(1589, 'F1436', 1, 'אם היית עף על עצמך באופן מוגזם, איך היית מתאר את עצמך בחצי משפט?', 'אם היית עפה על עצמך באופן מוגזם, איך היית מתארת את עצמך בחצי משפט? ', NULL, 'אם היית עפה על עצמך באופן מוגזם, איך היית מתארת את עצמך בחצי משפט? '),
(1590, 'F1437', 1, 'מה הדבר הכי טוב שקרה לך בשבוע האחרון?', 'מה הדבר הכי טוב שקרה לך בשבוע האחרון?', NULL, 'מה הדבר הכי טוב שקרה לך בשבוע האחרון?'),
(1591, 'F1438', 1, 'לאיזה רגע אחד אתה מחכה במיוחד כל השבוע ולא תסכים שיקחו לך אותו?', 'לאיזה רגע אחד את מחכה במיוחד כל השבוע ולא תסכימי שיקחו לך אותו?', NULL, 'לאיזה רגע אחד בשבוע, אתה הכי מחכה כל השבוע?'),
(1592, 'F1439', 1, 'בתוך מציאות של איזה סרט קולנוע מתחשק לך לחיות את החיים?', 'בתוך מציאות של איזה סרט קולנוע מתחשק לך לחיות את החיים?', NULL, 'בתוך מציאות של איזה סרט קולנוע מתחשק לך לחיות את החיים?');
INSERT INTO `net_tasktext` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES
(1593, 'F1440', 1, 'יש לך אפשרות לקנות מכונית חדשה בלי מגבלת כסף, איזה רכב תקנה?', 'יש לך אפשרות לקנות מכונית חדשה בלי מגבלת כסף, איזה רכב תקני?', NULL, 'יש לכם אפשרות לקנות מכונית חדשה בלי מגבלת כסף, איזה רכב תקנו?'),
(1594, 'F1441', 1, 'יש לך אפשרות לשנות תכונה אחת שלך, איזו תכונה תשנה?', 'יש לך אפשרות לשנות תכונה אחת שלך, איזו תכונה תשני?', NULL, 'יש לכם אפשרות לשנות תכונה אחת שלך, איזו תכונה תשנו?'),
(1595, 'F1442', 1, 'בעוד 10 שנים מהיום, במה אתה רואה את עצמך עוסק?', 'בעוד 10 שנים מהיום, במה את רואה את עצמך עוסקת?', NULL, 'בעוד 10 שנים מהיום, במה אתה רואה את עצמך עוסקת?'),
(1596, 'F1443', 1, 'נניח שיש לך אפשרות להעלים כמה שעות מהיומן שלך בשבוע הקרוב, מה תמחק?', 'נניח שיש לך אפשרות להעלים כמה שעות מהיומן שלך בשבוע הקרוב, מה תמחקי?', NULL, 'נניח שיש לך אפשרות להעלים כמה שעות מהיומן שלך בשבוע הקרוב, מה תמחקי?'),
(1597, 'F1444', 1, 'נניח שהיה אפשר לענות לך במדויק על שאלה אחת מכל סוג שעולה לך בראש. איזו שאלה תשאלי?', 'נניח שהיה אפשר לענות לך במדויק על שאלה אחת מכל סוג שעולה לך בראש. איזו שאלה תשאל?', NULL, 'נניח שהיה אפשר לענות לך במדויק על שאלה אחת מכל סוג שעולה לך בראש. איזו שאלה תשאלי?'),
(1598, 'F1445', 1, 'איזו מיומנות וירטואוזית הכי בא לך שתהיה לך?', 'איזו מיומנות וירטואוזית הכי בא לך שתהיה לך?', NULL, 'איזו מיומנות וירטואוזית הכי בא לך שתהיה לך?'),
(1599, 'F1446', 1, 'יש לך אפשרות לקרוא מחשבות של מישהו. מי זה יהיה?', 'יש לך אפשרות לקרוא מחשבות של מישהו. מי זה יהיה?', NULL, 'יש לך אפשרות לקרוא מחשבות של מישהו. מי זה יהיה?'),
(1600, 'F1448', 1, 'למי אתה הכי מתגעגע עכשיו??', 'למי את הכי מתגעגעת עכשיו?', NULL, 'למי אתם הכי מתגעגעים עכשיו?'),
(1601, 'F1449', 1, 'באיזה מצב רוח קמת הבוקר? ', 'באיזה מצב רוח קמת הבוקר? ', NULL, 'באיזה מצב רוח קמת הבוקר? '),
(1602, 'F1456', 1, 'האם יצא לך לקבל משלוח זר פרחים? אם כן, על מה קיבלת אותם בפעם האחרונה שזה קרה?', 'האם יצא לך לקבל משלוח זר פרחים? אם כן, על מה קיבלת אותם בפעם האחרונה שזה קרה?', NULL, 'האם יצא לך לקבל משלוח זר פרחים? אם כן, על מה קיבלת אותם בפעם האחרונה שזה קרה?'),
(1603, 'F1457', 1, 'האם השתתפת פעם בתחרות ספורט עם מדליה או גביע? האם זכית פעם? אם כן, במה?', 'האם השתתפת פעם בתחרות ספורט עם מדליה או גביע? האם זכית פעם? אם כן, במה?', NULL, 'האם השתתפת פעם בתחרות ספורט עם מדליה או גביע? האם זכית פעם? אם כן, במה?'),
(1604, 'F1459', 1, 'מה הדבר הכי מוזר ששמת אי פעם במקרר?', 'מה הדבר הכי מוזר ששמת אי פעם במקרר?', NULL, 'מה הדבר הכי מוזר ששמת אי פעם במקרר?'),
(1605, 'F1460', 1, 'האם זה \"אסון\" או \"לא נורא\"', 'האם זה \"אסון\" או \"לא נורא\"', NULL, 'האם זה \"אסון\" או \"לא נורא\"'),
(1606, 'F1461', 1, 'האם יוצא לך להסתובב עם שתי גרביים שהן לא זוג?', 'האם יוצא לך להסתובב עם שתי גרביים שהן לא זוג?', NULL, 'האם יוצא לך להסתובב עם שתי גרביים שהן לא זוג?'),
(1607, 'F1462', 1, 'האם זה \"אסון\" או \"לא נורא\"', 'האם זה \"אסון\" או \"לא נורא\"', NULL, 'האם זה \"אסון\" או \"לא נורא\"'),
(1608, 'F1463', 1, 'בוא נראה אם אתה מפוזר או לא', 'בואו נראה אם את מפוזרת או לא', NULL, 'בואו נראה אם אתם מפוזרים או לא'),
(1609, 'F1464', 1, 'מה עדיף? ', 'מה עדיף? ', NULL, 'מה עדיף? '),
(1610, 'F1465', 1, 'מה עדיף?', 'מה עדיף?', NULL, 'מה עדיף?'),
(1611, 'F1466', 1, 'האם יצא לך להיפרד ממישהי בטלפוןSMSמייל? אם כן, איך היא קיבלה את זה?', 'האם יצא לך להיפרד ממישהו בטלפוןSMSמייל? אם כן, איך הוא קיבל את זה? ', NULL, 'האם יצא לך להיפרד ממישהיו בטלפוןSMSמייל? אם כן, איך הואהיא קיבלה את זה? '),
(1612, 'F1468', 1, 'מה הדבר הכי שרוט שאתה יכול להגיד על המשפחה שלך בכמה מילים? ', 'מה הדבר הכי שרוט שאת יכולה להגיד על המשפחה שלך בכמה מילים?', NULL, 'מה הדבר הכי שרוט שאתם יכולים להגיד על המשפחה שלכם בכמה מילים?'),
(1613, 'F1469', 1, 'תאר את החוויה שלך מהתיכון ב 2-3 מילים בלבד. ', 'תארי את החוויה שלך מהתיכון ב 2-3 מילים בלבד. ', NULL, 'תארי את החוויה שלך מהתיכון ב 2-3 מילים בלבד. '),
(1614, 'F1470', 1, 'מה אתה יכול להגיד על החבר הכי מוזר שיש לך? ', 'מה את יכולה להגיד על החברה הכי מוזרה שיש לך?', NULL, 'מה אתם יכולים להגיד על החברה הכי מוזרה שיש לכם?'),
(1615, 'F1471', 1, 'ממה אתה הכי מודאג השבוע?', 'ממה את הכי מודאגת השבוע?', NULL, 'ממה אתם הכי מודאגים השבוע?'),
(1616, 'F1472', 1, 'מה הדבר הכי מעודד שקרה לך השבוע?', 'מה הדבר הכי מעודד שקרה לך השבוע?', NULL, 'מה הדבר הכי מעודד שקרה לך השבוע?'),
(1617, 'F1473', 1, 'ההבדל ביני לבין אבא שלי הוא:', 'ההבדל ביני לבין אמא שלי הוא:', NULL, 'ההבדל ביני לבין אבאאמא שלי הוא:'),
(1618, 'F1474', 1, 'איזה דבר יוצא דופן עשית בחודש האחרון?', 'איזה דבר יוצא דופן עשית בחודש האחרון?', NULL, 'איזה דבר יוצא דופן עשית בחודש האחרון?'),
(1619, 'F1475', 1, 'בחר', 'בחרי', NULL, NULL),
(1620, 'F1476', 1, 'בחר', 'בחרי', NULL, NULL),
(1621, 'F1477', 1, 'מה אתה מעדיף?', 'מה את מעדיפה?', NULL, NULL),
(1622, 'F1478', 1, 'מה עדיף?', 'מה עדיף?', NULL, NULL),
(1623, 'F1479', 1, 'השלם ב\"הייתי\" או \"לא הייתי\" ', 'השלימי ב\"הייתי\" או \"לא הייתי\" ', NULL, NULL),
(1624, 'F1480', 1, 'השלם ב\"הייתי\" או \"לא הייתי\" ', 'השלימי ב\"הייתי\" או \"לא הייתי\" ', NULL, NULL),
(1625, 'F1481', 1, 'השב ב מילים כמו \"מאוד, בכלל לא, ככה ככה\"', 'השיבי ב מילים כמו \"מאוד, בכלל לא, ככה ככה\"', NULL, NULL),
(1626, 'F1482', 1, 'השב ב מילים כמו \"מאוד, בכלל לא, ככה ככה\"', 'השיבי ב מילים כמו \"מאוד, בכלל לא, ככה ככה\"', NULL, NULL),
(1627, 'F1483', 1, 'השב ב מילים כמו \"מאוד, בכלל לא, ככה ככה\"', 'השיבי ב מילים כמו \"מאוד, בכלל לא, ככה ככה\"', NULL, NULL),
(1628, 'F1484', 1, 'השב ב מילים כמו \"מאוד, בכלל לא, ככה ככה\"', 'השיבי ב מילים כמו \"מאוד, בכלל לא, ככה ככה\"', NULL, NULL),
(1629, 'F1485', 1, 'מהו המאכל הכי מוזר שאכלת אי פעם?', 'מהו המאכל הכי מוזר שאכלת אי פעם?', NULL, 'מהו המאכל הכי מוזר שאכלת אי פעם?'),
(1630, 'F1487', 1, 'האם היה לך חלום שהספקת לממש? כם כן, מהו?', 'האם היה לך חלום שהספקת לממש? כם כן, מהו?', NULL, 'האם היה לך חלום שהספקת לממש? כם כן, מהו?'),
(1631, 'F1488', 1, 'דרג לפי סדר חשיבות, מה היית מעדיף לקרוא אצל אנשים -  רגשות, מחשבות, או את העתיד?', 'דרגי לפי סדר חשיבות, מה היית מעדיפה לקרוא אצל אנשים -  רגשות, מחשבות, או את העתיד?', NULL, 'דרגו לפי סדר חשיבות, מה הייתם מעדיפים לקרוא אצל אנשים -  רגשות, מחשבות, או את העתיד?'),
(1632, 'F1489', 1, 'אם היית יכול להגביר פי כמה את אחת התכונות החיוביות שלך. איזו תכונה היית מגביר? ', 'אם היית יכולה להגביר פי כמה את אחת התכונות החיוביות שלך. איזו תכונה היית מגבירה? ', NULL, 'אם היית יכולה להגביר פי כמה את אחת התכונות החיוביות שלך. איזו תכונה היית מגבירה? '),
(1633, 'F1490', 1, 'על מה החמיאו לך לאחרונה?', 'על מה החמיאו לך לאחרונה?', NULL, 'על מה החמיאו לך לאחרונה?'),
(1634, 'F1491', 1, 'במה אתה טוב יותר? אינטואיציה רגשית, יכולת מחשבה או יכולת זיכרון? ', 'במה את טובה יותר? אינטואיציה רגשית, יכולת מחשבה או יכולת זיכרון? ', NULL, 'במה אתה טובה יותר? אינטואיציה רגשית, יכולת מחשבה או יכולת זיכרון? '),
(1635, 'F1492', 1, 'השב ב מילים כמו \"מאוד, בכלל לא, ככה ככה\"', 'השיבי ב מילים כמו \"מאוד, בכלל לא, ככה ככה\"', NULL, NULL),
(1636, 'F1493', 1, 'האם לדעתך החברים שלך אתה מתנהל לפי אינטואציה, או לפי חשיבה הגיונית? האם הם צודקים?', 'האם לדעתך החברים שלך את מתנהלת לפי אינטואציה, או לפי חשיבה הגיונית? האם הם צודקים?', NULL, 'האם לדעתך החברים שלך אתה מתנהלת לפי אינטואציה, או לפי חשיבה הגיונית? האם הם צודקים?'),
(1637, 'F1494', 1, 'מאמין או לא מאמין? ', 'מאמינה או לא מאמינה?', NULL, 'מאמיןה או לא? '),
(1638, 'F1495', 1, 'כמה קל לך לזהות כשעושים עליך מנפילוציות רגשיות? ואיך אתה מגיב כשזה קורה?', 'כמה קל לך לזהות כשעושים עליך מנפילוציות רגשיות? ואיך את מגיבה כשזה קורה?', NULL, 'כמה קל לך לזהות כשעושים עליך מנפילוציות רגשיות? ואיך אתה מגיבה כשזה קורה?'),
(1639, 'F1496', 1, 'נכון או לא נכון?', 'נכון או לא נכון?', NULL, NULL),
(1640, 'F1497', 1, 'נכון או לא נכון?', 'נכון או לא נכון?', NULL, NULL),
(1641, 'F1498', 1, 'נכון או לא נכון?', 'נכון או לא נכון?', NULL, NULL),
(1642, 'F1499', 1, 'נכון או לא נכון?', 'נכון או לא נכון?', NULL, NULL),
(1643, 'F1500', 1, 'נכון או לא נכון?', 'נכון או לא נכון?', NULL, NULL),
(1644, 'F1501', 1, 'האם אתה יודע לפלרטט עם זרים בקלות, או שלוקח לך זמן להיפתח?', 'האם את יודעת לפלרטט עם זרים בקלות, או שלוקח לך זמן להיפתח?', NULL, 'האם אתה יודעת לפלרטט עם זרים בקלות, או שלוקח לך זמן להיפתח?'),
(1645, 'F1502', 1, 'מה בא לך יותר היום? מפגש עם חברים הכולל שיחות עם כמה אנשים, או מפגש מעמיק אחד על אחד?', 'מה בא לך יותר היום? מפגש עם חברים הכולל שיחות עם כמה אנשים, או מפגש מעמיק אחד על אחד?', NULL, 'מה בא לך יותר היום? מפגש עם חברים הכולל שיחות עם כמה אנשים, או מפגש מעמיק אחד על אחד?'),
(1646, 'F1503', 1, 'מה בא לך יותר עכשיו? לראות הופעה בפארק, או לצאת לבר עם חברים? ', 'מה בא לך יותר עכשיו? לראות הופעה בפארק, או לצאת לבר עם חברים? ', NULL, 'מה בא לך יותר עכשיו? לראות הופעה בפארק, או לצאת לבר עם חברים? '),
(1647, 'F1504', 1, 'האם בנות התחילו איתך פעם? אם כן, איך זה הרגיש?', 'האם יצא לך להתחיל עם גברים? אם כן, איך הם קיבלו את זה?', NULL, 'האם יצא לך להתחיל עם גברים? ולגבר, האם מישהי התחילה איתך פעם?'),
(1648, 'F1505', 1, 'אם אתה חייב לבחור, עדיף שהיא תהיה ספונטנית, או מסתורית?', 'אם את חייבת לבחור, עדיף שהוא יהיה ספונטני, או מסתורי? ', NULL, 'אם אתה חייבת לבחור, עדיף שהואהיא יהיו ספונטנית או מסתורית'),
(1649, 'F1506', 1, 'אם אתה חייב לבחור, עדיף שהיא תהיה יודעת להקשיב, או יודעת לדבר?', 'אם את חייבת לבחור, עדיף שהוא יהיה יודע להקשיב או יודע לדבר? ', NULL, 'אם אתה חייבת לבחור, עדיף שהואהיא יהיו יודעת להקשיב או יודעת לדבר?'),
(1650, 'F1507', 1, 'האם עדיף שאתה תהיה כל העולם שלה, או שיהיו לה תחומי עניין שיעסיקו אותה גם בלעדיך?', 'האם עדיף שאת תהיי כל העולם שלו, או שיהיו לו תחומי עניין שיעסיקו אותו גם בלעדייך? ', NULL, 'האם עדיף שאתם תהיו כל העולם עבור בןבת הזוג, או שיהיו להם תחומי עניין שיעסיקו אותם גם בלעדיכם?'),
(1651, 'F1508', 1, 'החברה אומרת לך שהיא רוצה לצאת לניו יורק לשבוע חופשת בנות בלעדיך. איך תרגיש עם זה?', 'החבר אומר לך שהוא רוצה לצאת לחופשת לתאילנד לשבוע חופשת בנים בלעדייך. איך תרגישי עם זה?', NULL, 'החברה אומרת שהואהיא רוצה לצאת לחופשת בניםבנות בלעדיכם, איך תרגישו עם זה?'),
(1652, 'F1509', 1, 'החברה בנסיעת עבודה בחו\"ל, ובגלל נסיבות, היא תצטרך לישון באותו החדר במלון עם עמית לעבודה שהוא גבר. האם זה מקובל עליך?', 'החבר בנסיעת עבודה בחו\"ל ובגלל נסיבות הוא יצטרך לישון באותו החדר במלון עם עמיתה לעבודה שהיא בחורה. האם זה מקובל עלייך?', NULL, 'בןבת הזוג בחו\"ל והם נאלצים לישון באותו החדר עם בןבת המין השני. האם זה מקובל עליכם? '),
(1653, 'F1510', 1, 'כתוב רעיון לדייט שאינו מקובל בדרך כלל, לדוגמא -  דייט בחנות ספרים תוך כדי בחירת ספר. ', 'כתבי רעיון לדייט שאינו מקובל בדרך כלל, לדוגמא -  דייט בחנות ספרים תוך כדי בחירת ספר. ', NULL, 'כתבו רעיון לדייט שאינו מקובל בדרך כלל, לדוגמא -  דייט בחנות ספרים תוך כדי בחירת ספר. '),
(1654, 'F1511', 1, 'דרג עד כמה חשובים לך הערכים הבאים, במילים כמו \"מאוד, בכלל לא, ככה ככה\" ', 'דרגי עד כמה חשובים לך הערכים הבאים, במילים כמו \"מאוד, בכלל לא, ככה ככה\" ', NULL, NULL),
(1655, 'F1512', 1, 'דרג עד כמה חשובים לך הערכים הבאים, במילים כמו \"מאוד, בכלל לא, ככה ככה\" ', 'דרגי עד כמה חשובים לך הערכים הבאים, במילים כמו \"מאוד, בכלל לא, ככה ככה\" ', NULL, NULL),
(1656, 'F1513', 1, 'באיזה דבר אם מעצבנים אותך בו - פחד אלוהים להסתבך איתך?', 'באיזה דבר אם מעצבנים אותך בו - פחד אלוהים להסתבך איתך?', NULL, 'באיזה תחום אם מעצבנים אותך - פחד אלוהים להסתבך איתך?'),
(1657, 'F1514', 1, 'באיזה תחום אתה מוותר תמיד, שאפשר להגדיר אותך לגמרי פרייר? ', 'באיזה תחום את מוותרת תמיד, שאפשר להגדיר אותך לגמרי פריירית? ', NULL, 'באיזה תחום אתם מוותרים תמיד, שאפשר להגדיר אתכם לגמרי פריירים?'),
(1658, 'F1515', 1, 'מה גרם לך לחייך ביום יומיים האחרונים?', 'מה גרם לך לחייך ביום יומיים האחרונים?', NULL, 'מה גרם לך לחייך ביום יומיים האחרונים?'),
(1659, 'F1516', 1, 'מה עיצבן אותך במיוחד בשבוע האחרון?', 'מה עיצבן אותך במיוחד בשבוע האחרון?', NULL, 'מה עיצבן אותך במיוחד בשבוע האחרון?'),
(1660, 'F1517', 1, 'מה העציב אותך בשבוע האחרון?', 'מה העציב אותך בשבוע האחרון?', NULL, 'מה העציב אותך בשבוע האחרון?'),
(1661, 'F1518', 1, 'מה איכזב אותך בשבוע האחרון?', 'מה איכזב אותך בשבוע האחרון?', NULL, 'מה איכזב אותך בשבוע האחרון?'),
(1662, 'F1519', 1, 'אילו שלושה דברים הכי מעצבנים אותך בחיים?', 'אילו שלושה דברים הכי מעצבנים אותך בחיים?', NULL, 'אילו שלושה דברים הכי מעצבנים אותך בחיים?'),
(1663, 'F1520', 1, 'האם אי פעם קינאת בחבר שלך? אם כן, מה? ', 'האם אי פעם קינאת בחברה שלך? אם כן, מה? ', NULL, 'האם אי פעם קינאת בחברה שלך? אם כן, מה? '),
(1664, 'F1521', 1, 'באיזו מידה אתה נוהג להשתמש בדברים הלא נוחים הבאים, השב במילים \"הרבה, בכלל לא, קצת\" וכו\'... ', 'באיזו מידה את נוהגת להשתמש בדברים הלא נוחים הבאים, השיבי במילים \"הרבה, בכלל לא, קצת\" וכו\'... ', NULL, 'באילו מהאביזרים הלא נוחים הבאים אתם משתמשים?'),
(1665, 'F1522', 1, 'אם אתה צריך לצאת ב 8:00 בבוקר מהבית, לאיזו שעה תכוון שעון? ', 'אם את צריכה לצאת ב 8:00 בבוקר מהבית, לאיזו שעה תכווני שעון? ', NULL, 'אם אתם צריכים לצאת ב 8:00 בבוקר מהבית, לאיזו שעה תכוונו שעון? '),
(1666, 'F1523', 1, 'מהר או לאט?', 'מהר או לאט?', NULL, 'מהר או לאט?'),
(1667, 'F1524', 1, 'מהר או לאט?', 'מהר או לאט?', NULL, 'מהר או לאט?'),
(1668, 'F1525', 1, 'איך אתה ישן?', 'איך את ישנה? ', NULL, NULL),
(1669, 'F1526', 1, 'עד כמה אתה בחור רגוע מלא בשלווה? ', 'עד כמה את בחורה רגועה ושלווה? ', NULL, 'עד כמה אתם רגועים ושלווים? '),
(1670, 'F1527', 1, 'באיזה תחום אתה מרגיש חסר ביטחון לפעמים? ', 'באיזה תחום את מרגישה חסרת ביטחון לפעמים?', NULL, 'באיזה תחום אתם מרגישים חסרי ביטחון לפעמים?'),
(1671, 'F1528', 1, 'באיזו דרך אתה נפגש עם הידידות שלך? חיבוק, לחיצת יד, נפנוף לשלום, חיוך, נשיקה בלחי, נשיקה קלה בשפתיים?', 'באיזו דרך את נפגשת עם הידידים שלך? חיבוק, לחיצת יד, נפנוף לשלום, חיוך, נשיקה בלחי, נשיקה קלה בשפתיים?', NULL, 'באיזו דרך אתה נפגשת עם הידידיםות שלך? חיבוק, לחיצת יד, נפנוף לשלום, חיוך, נשיקה בלחי, נשיקה קלה בשפתיים?'),
(1672, 'F1529', 1, 'מתי קיללת בפעם האחרונה, ומה היתה הקללה?', 'מתי קיללת בפעם האחרונה, ומה היתה הקללה?', NULL, 'מתי קיללת בפעם האחרונה, ומה היתה הקללה?'),
(1673, 'F1530', 1, 'מודיעים לך בהפתעה שקיבלת את עבודת החלומות שלך. איך תגיב? (למשל, ניתור ביחד עם \"יש!\" או רק חיוך סיפוק וכו\'...)', 'מודיעים לך בהפתעה שהתקבלת לעבודת החלומות שלך. איך תגיבי? (למשל, ניתור ביחד עם \"יש!\" או רק חיוך סיפוק וכו\'...)', NULL, 'מודיעים לך בהפתעה שהתקבלת לעבודת החלומות שלך. איך תגיבי? (למשל, ניתור ביחד עם \"יש!\" או רק חיוך סיפוק וכו\'...)'),
(1674, 'F1531', 1, 'מה הכי כדאי לעשות מייד אחרי השחרור מצה\"ל? טיול גדול (איפה?), לימודים, סתם לחיות?', 'מה הכי כדאי לעשות מייד אחרי השחרור מצה\"ל? טיול גדול (איפה?), לימודים, סתם לחיות?', NULL, 'מה הכי כדאי לעשות מייד אחרי השחרור מצה\"ל? טיול גדול (איפה?), לימודים, סתם לחיות?'),
(1675, 'F1532', 1, 'איך אתה מעביר את הזמן כשאתה לבד בבית בערב, אחרי יום עבודה מתיש?', 'איך את מעבירה את הזמן כשאת לבד בבית בערב, אחרי יום עבודה מתיש?', NULL, 'איך אתם מעבירים את הזמן כשאתם לבד בבית בערב אחרי יום עבודה מתיש?'),
(1676, 'F1533', 1, 'האם אתה מחשיב את עצמך כ\"יודע להתלבש\"? האם אתה קונה לעצמך לבד את הבגדים?', 'האם את מחשיבה את עצמך כ\"יודעת להתלבש\"? האם את קונה לעצמך לבד את הבגדים? ', NULL, 'האם אתם מחשיבים את עצמכם כ\"יודעים להתלבש\"? האם אתם קונים לעצמכם לבד את הבגדים?'),
(1677, 'F1534', 1, 'האם כילד היית נוהג לאכול כל הזמן \"שניצל ואורז\", או שקיבלת גם אוכל ביתי מושקע יותר?  איזה מאכל הכי אהבת בילדות?', 'האם כילדה היית נוהגת לאכול כל הזמן \"שניצל ואורז\", או שקיבלת גם אוכל ביתי מושקע יותר?  איזה מאכל הכי אהבת בילדות?', NULL, 'האם כילדה היית נוהגת לאכול כל הזמן \"שניצל ואורז\", או שקיבלת גם אוכל ביתי מושקע יותר? '),
(1678, 'F1535', 1, 'איזה בילוי הכי מועדף עליך כשאתה עם המשפחה שלך?', 'איזה בילוי הכי מועדף עליך כשאת עם המשפחה שלך?', NULL, 'איזה בילוי הכי מועדף עליך כשאתה עם המשפחה שלך?'),
(1679, 'F1536', 1, 'איזה בילוי הכי מועדף עליך כשאתה עם החבר\'ה שלך?', 'איזה בילוי הכי מועדף עליך כשאת עם החבר\'ה שלך?', NULL, 'איזה בילוי הכי מועדף עליך כשאתה עם החבר\'ה שלך?'),
(1680, 'F1537', 1, 'נניח שאתה יוצא לדייט חשוב וקיבלת תקציב בלתי מוגבל לקנות בגדים. מה תלבש?', 'נניח שאת יוצאת לדייט חשוב וקיבלת תקציב בלתי מוגבל לקנות בגדים. מה תלבשי?', NULL, 'נניח שאתה יוצאת לדייט חשוב וקיבלת תקציב בלתי מוגבל לקנות בגדים. מה תלבשי?'),
(1681, 'F1538', 1, 'בחר עם מי לדבר על כל נושא: (למשל - משפחה  חברה טובה  בוס  פורום אנונימי וכו\'...) ', 'בחרי עם מי לדבר על כל נושא: (למשל - משפחה  חברה טובה  בוס  פורום אנונימי וכו\'...) ', NULL, 'בחרי עם מי לדבר על כל נושא'),
(1682, 'F1539', 1, 'באילו נושאים אתה עקשן ומתקשה לוותר?', 'באילו נושאים את עקשנית ומתקשית לוותר?', NULL, 'באילו נושאים אתם עקשנים ומתקשים לוותר?'),
(1683, 'F1540', 1, 'עד כמה אתה זורם עם נימוס בסטייל בריטי אירופאי קלאסי?', 'עד כמה את זורמת עם נימוס בסטייל בריטי אירופאי קלאסי?', NULL, 'עד כמה אתם מנומסים עם גינונים בסטייל בריטי אירופאי קלאסי?'),
(1684, 'F1541', 1, 'עם מי התווכחת בשבוע האחרון ועל מה?', 'עם מי התווכחת בשבוע האחרון ועל מה?', NULL, 'עם מי התווכחת בשבוע האחרון ועל מה?'),
(1685, 'F1542', 1, 'איזו קריירה אתה חושב שהכי מתאימה לך? ', 'איזו קריירה את חושבת שהכי מתאימה לך? ', NULL, 'איזו קריירה אתה חושבת שהכי מתאימה לך? '),
(1686, 'F1543', 1, 'עד כמה מתאים לך להיות \"הבוס\" ולנהל אחרים? ', 'עד כמה מתאים לך להיות \"הבוס\" ולנהל אחרים? ', NULL, 'עד כמה בא לך להיות \"הבוס\" ולנהל אחרים? '),
(1687, 'F1544', 1, 'אתה בקניון ועכשיו קיבלת 1,000 ₪. על מה תבזבז אותם?', 'את בקניון ועכשיו קיבלת 1,000 ₪. על מה תבזבזי אותם?', NULL, 'אתה בקניון ועכשיו קיבלת 500 ₪. על מה תבזבזי אותם?'),
(1688, 'F1545', 1, 'עד כמה אתה דייקן ופרפקציוניסט?', 'עד כמה את דייקנית ופרפקציוניסטית?', NULL, 'עד כמה אתם דייקנים ופרפקציוניסטים?'),
(1689, 'F1546', 1, 'האם אתה חולמני, או איש של תכלס?', 'האם את חולמנית או אישה של תכלס? ', NULL, 'האם אתם חולמניים או אנשים של תכלס?'),
(1690, 'F1547', 1, 'בוקר. אתה עומד לצאת מהבית, ולפתע מודיעים לך שהפגישה נדחתה בשעתיים. איך תעביר את הזמן בבית?', 'בוקר. את עומדת לצאת מהבית, ולפתע מודיעים לך שהפגישה נדחתה בשעתיים. איך תעבירי את הזמן בבית? ', NULL, 'בוקר, אתם עומדים לצאת מהבית, ולפתע מודיעים לכם שהפגישה נדחתה בשעתיים. איך תעבירו את הזמן בבית?'),
(1691, 'F1548', 1, 'עד כמה אתה טיפוס שיודע להזיז אנשים, מסוגל לארגן הפגנות, לידר? ', 'עד כמה את טיפוס שיודעת להזיז אנשים, מסוגלת לארגן הפגנות, לידרית? ', NULL, 'עד כמה אתם טיפוסים שיודעים להזיז אנשים, מסוגלים לארגן הפגנות, לידרים? '),
(1692, 'F1549', 1, 'היום - בית עם גינה או פנטהאוז במרכז העיר? ועוד 10 שנים? ', 'היום - בית עם גינה או פנטהאוז במרכז העיר? ועוד 10 שנים? ', NULL, 'היום - בית עם גינה או פנטהאוז במרכז העיר? ועוד 10 שנים? '),
(1693, 'F1550', 1, 'האם את פמיניסטית שחושבת שצריך שיוויון מוחלט? או שלפעמים אולד פאשן זה נחמד לך?', 'האם אתה פמיניסטי שחושב שצריך שיוויון מוחלט? או שלפעמים אולד פאשן זה נחמד לך?', NULL, 'האם אתה פמיניסטית שחושב תשצריך שיוויון מוחלט? או שלפעמים אולד פאשן זה נחמד לך?'),
(1694, 'F1551', 1, 'אילו תכשיטים אתה אוהב אם היא תשים עליה, ובאיזו מידה. השתמש במילים \"מאוד, קצת, בינוני\"', 'אילו תכשיטים את אוהבת לשים עליך, ובאיזו מידה, השתמשי במילים \"מאוד, קצת, בינוני\"', NULL, NULL),
(1695, 'F1552', 1, 'מחר יום חופש! איך תבחר לבלות אותו? ', 'מחר יום חופש. איך תבחרי לבלות אותו?', NULL, 'מחר יום חופש. איך תבחרו לבלות אותו?'),
(1696, 'F1553', 1, 'מהו הדייט השני האידיאלי בעיניך? דרג מ 1 עד 10', 'מהו הדייט השני האידיאלי בעיניך? דרג מ 1 עד 10', NULL, 'מהו הדייט השני האידיאלי בעיניך?'),
(1697, 'F1554', 1, 'נשלחת למשימה במאדים על ידי נאסא. אילו שלושה דברים תקח איתך לחללית?', 'נשלחת למשימה במאדים על ידי נאסא. אילו שלושה דברים תקחי איתך לחללית?', NULL, 'נשלחת למשימה במאדים על ידי נאסא. אילו שלושה דברים תקחי איתך לחללית?'),
(1698, 'F1555', 1, 'אם היו מאבחנים אצלך איזו הפרעה אישיותית, מה היא היתה?', 'אם היו מאבחנים אצלך איזו הפרעה אישיותית, מה היא היתה?', NULL, 'אם היו מאבחנים אצלך איזו הפרעה אישיותית, מה היא היתה?'),
(1699, 'F1556', 1, 'מה אתה רואה בטלוויזיה במיטה לפני השניה?', 'מה את רואה בטלוויזיה במיטה לפני השניה?', NULL, 'מה אתה רואה בטלוויזיה במיטה לפני השניה?'),
(1700, 'F1557', 1, 'לאיזה הרגל אתה מכור באופן קשה?', 'לאיזה הרגל את מכורה באופן קשה?', NULL, 'לאיזה הרגל מכורים באופן קשה? '),
(1701, 'F1558', 1, 'לאיזה מאכל אתה מכור באופן הרסני?', 'לאיזה מאכל את מכורה באופן הרסני?', NULL, 'לאיזה מאכל אתם מכורים באופן הרסני?'),
(1702, 'F1559', 1, 'אם תוכל לסגור חשבון עם מישהו מהעבר שפגע בך שלא בצדק, על מה ועם מי זה יהיה? ', 'אם תוכלי לסגור חשבון עם מישהו מהעבר שפגע בך שלא בצדק, על מה ועם מי זה יהיה? ', NULL, 'אם תוכלי לסגור חשבון עם מישהו מהעבר שפגע בך שלא בצדק, על מה ועם מי זה יהיה? '),
(1703, 'F1560', 1, 'קרה לך שידידה התקשרה אליך לבוא לבכות לך? על מה?', 'קרה לך שידיד התקשר אליך לבוא לבכות לך? על מה?', NULL, 'קרה לך שידידה התקשר אליך לבוא לבכות לך? על מה?'),
(1704, 'F1561', 1, 'תאר את הלבוש שלך כשיצאת אתמול בבוקר מהבית.', 'תארי את הלבוש שלך כשיצאת אתמול בבוקר מהבית.', NULL, 'תארי את הלבוש שלך כשיצאת אתמול בבוקר מהבית.'),
(1705, 'F1562', 1, 'הבוס שלך מספר בדיחה ממש לא מצחיקה. מה תעשה?', 'הבוס שלך מספר בדיחה ממש לא מצחיקה. מה תעשי?', NULL, 'הבוס שלך מספר בדיחה ממש לא מצחיקה. מה תעשהי?'),
(1706, 'F1563', 1, 'בכללי אתה טיפוס חסכן או בזבזן? ', 'בכללי את טיפוס של חסכנית או בזבזנית?', NULL, 'בכללי אתם טיפוסים חסכנים או בזבזנים?'),
(1707, 'F1564', 1, 'בחר שתי תכונות שהכי נחשבות בעיניך מהרשימה: מלאת השראה, מבט חודר, אמיצה, מבריקה, יודעת להקשיב, יודעת להתלבש, רוקדת מדהים.', 'בחרי שתי תכונות שהכי נחשבות בעיניך מהרשימה: מלא השראה, מבט חודר, אמיץ, מבריק, יודע להקשיב, יודע להתלבש', NULL, 'בחרו שתי תכונות שהכי נחשבות בעיניכם מהרשימה:'),
(1708, 'F1565', 1, 'אהבה היא: מסובכת, מדהימה, מפחידה, אוויר לנשימה, מכאיבה, עיוורת. בחר מהרשימה (או הוסף משלך)', 'אהבה היא: מסובכת, מדהימה, מפחידה, אוויר לנשימה, מכאיבה, עיוורת. בחרי מהרשימה (או הוסיפי משלך)', NULL, 'אהבה היא: מסובכת, מדהימה, מפחידה, אוויר לנשימה, מכאיבה, עיוורת. בחרו מהרשימה (או הוסיפו משלך)'),
(1709, 'F1566', 1, 'עד כמה אתה נחשב בעיני אעצמך לגבר שנפתח בקלות ויודע לשתף דברים אינטימיים?', 'עד כמה את נחשבת בעיני עצמך לאישה שנפתחת בקלות ויודעת לשתף דברים אינטימיים?', NULL, 'עד כמה אתם נחשבים בעיני עצמכם לכאלה שנפתחים בקלות ויודעים לשתף דברים אינטימיים?'),
(1710, 'F1567', 1, 'האם השתנית הרבה מכפי שהיית לפני 5 שנים? אם כן, במה?', 'האם השתנית הרבה מכפי שהיית לפני 5 שנים? אם כן, במה?', NULL, 'האם השתנית הרבה מכפי שהיית לפני 5 שנים? אם כן, במה?'),
(1711, 'F1568', 1, 'האם יצא לך מתישהו להעיר לאישה הערה מביכה, למשל שיש לה ריח רע מהפה? למי? ומה?', 'האם יצא לך מתישהו להעיר לגבר הערה מביכה, למשל שיש לו ריח רע מהפה? למי ומה?', NULL, 'האם יצא לכם מתישהו להעיר לגבר הערה מביכה? '),
(1712, 'F1569', 1, 'האם אתה בקשר עם חברי ילדות? עם כמה ומי?', 'האם את בקשר עם חברי ילדות? עם כמה ומי?', NULL, 'האם אתה בקשר עם חברי ילדות? עם כמה ומי?'),
(1713, 'F1570', 1, 'על איזו טמפרטורה אתה מכוון את המזגן בקיץ? אתה אוהב שהרוח עליך?', 'על איזו טמפרטורה את מכוונת את המזגן בקיץ? את אוהבת שהרוח עליך?', NULL, 'האם באופן כללי חם לכם? על איזו טמפרטורה אתם מכוונים את המזגן? אתם אוהבים שהרוח עליכם?'),
(1714, 'F1571', 1, 'האם באופן כללי קר לך? עם איזו שמיכה אתה ישן בחורף? עם כמה שכבות אתה יוצא מהבית ביום חורפי?', 'האם באופן כללי קר לך? עם איזו שמיכה את ישנה בחורף? עם כמה שכבות את יוצאת מהבית ביום חורפי?', NULL, 'האם באופן כללי קר לך? עם איזו שמיכה אתה ישנה בחורף? עם כמה שכבות אתה יוצאת מהבית ביום חורפי?'),
(1715, 'F1572', 1, 'מה אתה נוהג לומר לאנשים שמקטרים ומתלוננים כל הזמן? ', 'מה את נוהגת לומר לאנשים שמקטרים ומתלוננים כל הזמן?', NULL, 'מה אתם נוהגים לומר לאנשים שמקטרים ומתלוננים כל הזמן?'),
(1716, 'F1573', 1, 'כמה פעמים הכנת בשבועיים האחרונים ארוחת ערב? מה הכנת בעיקר? ', 'כמה פעמים הכנת בשבועיים האחרונים ארוחת ערב? מה הכנת בעיקר? ', NULL, 'כמה פעמים הכנת בשבועיים האחרונים ארוחת ערב מושקעת? מה הכנת בעיקר? '),
(1717, 'F1574', 1, 'כמה זוגות נעליים יש לך בטוטאל? בבקשה פרט... (כולל סנדלים, כפכפים, קרוקס, הכל הולך)', 'כמה זוגות נעליים יש לך בטוטאל? בבקשה פרטי... (כולל סנדלים, כפכפים, קרוקס, הכל הולך)', NULL, 'כמה זוגות נעליים יש לך בטוטאל? בבקשה פרטי... (כולל סנדלים, כפכפים, קרוקס, הכל הולך)'),
(1718, 'F1575', 1, 'האם יצא לך להיות בשנה האחרונה ממש שיכור? באילו נסיבות?', 'האם יצא לך להיות בשנה האחרונה ממש שיכורה? באילו נסיבות?', NULL, 'האם יצא לך להיות בשנה האחרונה ממש שיכורה? באילו נסיבות?'),
(1719, 'F1576', 1, 'כמה שעות אתה ישן בממוצע בלילה? כמה היית רוצה לישון? ', 'כמה שעות את ישנה בממוצע בלילה? כמה היית רוצה לישון? ', NULL, 'כמה שעות אתה ישנה בממוצע בלילה? כמה היית רוצה לישון? '),
(1720, 'F1578', 1, 'אתה שנתיים באי בודד. קבע דרגת חשיבות לדברים מהרשימה שלדעתך חשוב שיהיו איתך שם. השתמש במילים \"חשוב מאוד, לא חשוב, קצת חשוב, וכו\'\"', 'את שנתיים באי בודד. קבעי דרגת חשיבות לדברים מהרשימה שלדעתך חשוב שיהיו איתך שם. השתמשי במילים \"חשוב מאוד, לא חשוב, קצת חשוב, וכו\'\"', NULL, 'אתם שנתיים באי בודד'),
(1721, 'F1579', 1, 'פרט חלום אופטימי שאתה זוכר שחלמת.', 'פרטי חלום אופטימי שאתה זוכר שחלמת.', NULL, 'פרטי חלום אופטימי שאתה זוכר שחלמת.'),
(1722, 'F1580', 1, 'פרט בבקשה חלום מפחיד שאתה זוכר שחלמת', 'פרטי בבקשה חלום מפחיד שאת זוכרת שחלמת', NULL, 'פרטי חלום מפחיד שאתה זוכר שחלמת'),
(1723, 'F1581', 1, 'האם יצא לך פעם שחזית משהו והוא התגשם במדויק באופן מפתיע? אם כן, מה?', 'האם יצא לך פעם שחזית משהו והוא התגשם במדויק באופן מפתיע? אם כן, מה?', NULL, 'האם יצא לך פעם שחזית משהו והוא התגשם במדויק באופן מפתיע? אם כן, מה זה היה?'),
(1724, 'F1582', 1, 'השלם במילים \"כן\" או \"לא\" או \"קצת\"', 'השלימי במילים \"כן\" או \"לא\" או \"קצת\"', NULL, NULL),
(1725, 'F1583', 1, 'השלם במילים \"כן\" או \"לא\" או \"קצת\"', 'השלימי במילים \"כן\" או \"לא\" או \"קצת\"', NULL, NULL),
(1726, 'F1584', 1, 'דרג מה יותר חשוב: קריירה טובה יותר, השכלה רחבה יותר, משפחה גדולה יותר?', 'דרגי מה יותר חשוב: קריירה טובה יותר, השכלה רחבה יותר, משפחה גדולה יותר?', NULL, 'דרגו מה יותר חשוב'),
(1727, 'F1585', 1, 'מתי בפעם האחרונה:', 'מתי בפעם האחרונה:', NULL, NULL),
(1728, 'F1586', 1, 'איפה אתה חולם להתחתן? תן ציון מ 1 עד 10 ללוקיישנים הבאים:', 'איפה את חולמת להתחתן? תני ציון מ 1 עד 10 ללוקיישנים הבאים:', NULL, 'איפה אתה חולםת להתחתן? '),
(1729, 'F1587', 1, 'הוזמנת למסיבה עם החברה החדשה שלך, והיא מדברת עם גברים אחרים המון, יותר מאשר איתך. כתוב לה SMS', 'הוזמנת למסיבה עם החבר החדש שלך, והוא מדבר עם נשים אחרות המון, יותר מאשר איתך. כתבי לו SMS', NULL, 'כתבו SMS לחברה החדשה שמקדישה יותר זמן לאחרים מאשר אליכם'),
(1730, 'F1588', 1, 'אתה מפגיש את החברה החדשה עם ההורים שלך. מה יהיה נחשב בעיניך להתנהגות לא מכובדת מצידה. ', 'את מפגישה את החבר החדש עם ההורים שלך. מה יהיה נחשבך בעיניך להתנהגות לא מכובדת מצידו?', NULL, 'אתם מפגישים את החברה החדשה עם ההורים. מה נחשבת בעיניכם התנהגות לא מכובדת?'),
(1731, 'F1589', 1, 'תן דוגמא ל\"איך אסור להתנהג איתך בדייט ראשון\". ', 'תני דוגמא ל\"איך אסור להתנהג איתך בדייט ראשון\". ', NULL, 'תןי דוגמא ל\"איך אסור להתנהג איתך בדייט ראשון\". '),
(1732, 'F1590', 1, 'כמה נכון המשפט -  \"הרבה בנות נמשכות דווקא לגברים שמתנהגים כמו חארות?\"', 'כמה נכון המשפט -  \"הרבה בנות נמשכות דווקא לגברים שמתנהגים כמו חארות?\"', NULL, 'כמה נכון המשפט -  \"הרבה בנות נמשכות דווקא לגברים שמתנהגים כמו חארות?\"'),
(1733, 'F1591', 1, 'כמה נכון המשפט -  \"הרבה גברים נמשכים דווקא לבנות שמתעללות בהם רגשית?\"', 'כמה נכון המשפט -  \"הרבה גברים נמשכים דווקא לבנות שמתעללות בהם רגשית?\"', NULL, 'כמה נכון המשפט -  \"הרבה גברים נמשכים דווקא לבנות שמתעללות בהם רגשית?\"'),
(1734, 'F1592', 1, 'אתה יוצא לבליינד דייט והיא מבקשת שאתה תבחר לבדך את מקום ואופי הבילוי - מה תבחר?', 'את יוצאת  לבליינד דייט והוא מבקש שאת תבחרי לבדך את מקום ואופי הבילוי. מה תבחרי?', NULL, 'אתם יוצאים לבליינד דייט, ואתם צריכים לבחור לבד את מקום ואופי הבילוי'),
(1735, 'F1593', 1, 'באוניברסיטה! איזה דייט מועדף עליך. השב במילים כמו \"מעולה, גרוע, סביר\" ', 'באוניברסיטה! איזה דייט מועדף עליך. השיבי במילים כמו \"מעולה, גרוע, סביר\" ', NULL, 'באוניברסיטה! איזה דייט מועדף עליך.'),
(1736, 'F1594', 1, 'מה פער הגילאים המקסימלי המקובל עליך?', 'מה פער הגילאים המקסימלי המקובל עליך?', NULL, NULL),
(1737, 'F1595', 1, 'איזה דבר אחד עשית בעבר, שמחשיב אותך להרפתקן בעיניך?', 'איזה דבר אחד עשית בעבר, שמחשיב אותך להרפתקנית בעיניך?', NULL, 'איזה דבר אחד עשית בעבר, שמחשיב אותך להרפתקןית בעיניך?'),
(1738, 'F1596', 1, 'גורלך תלוי באיכות הסנדוויץ שתכין עבורה. תאר את הסנדוויץ. ', 'גורלך תלוי באיכות הסנדוויץ שתכיני עבורו. תארי את הסנדוויץ. ', NULL, 'גורלך תלוי באיכות הסנדוויץ שתכיני עבורוה. תארי את הרכב הסנדוויץ. '),
(1739, 'F1597', 1, 'ספר על גבר (ידוע) אחד שמרשים אותך כל כך עד שאתה אומר \"אני מת להיות כמוהו\"', 'ספרי על אישה אחת (ידועה) שמרשימה אותך כל כך, עד שאת אומרת \"אני מתה להיות כמוה\"', NULL, 'ספרו על מישהוי שמרשימים אתכם כל כך עד שאתם רוצים להיות כמוהםהן'),
(1740, 'F1598', 1, 'דרג מ 1 עד 100 כמה אתה דומה לגברים הבאים:', 'את בבר, ומולך עומדים שלושה גברים. דרגי מ 1 עד 100 את הסיכויים במי מהם תבחרי. ', NULL, NULL),
(1741, 'F1599', 1, 'אתה בבר ומולך עומדות שלוש נשים. דרג מ 1 עד 100 את הסיכויים במי מהן תבחר. ', 'דרגי מ 1 עד 100 עד כמה את דומה לנשים הבאות:', NULL, NULL),
(1742, 'F1600', 1, 'איזה דבר מטופש שאתה מתחרט עליו, עשית בשבוע האחרון?', 'איזה דבר מטופש שאת מתחרטת עליו, עשית בשבוע האחרון?', NULL, 'איזה דבר מטופש שאתה מתחרטת עליו, עשית בשבוע האחרון?'),
(1743, 'F1601', 1, 'אילו סוגי מדים (כל סוג של בגדי עבודה) עושים לך את זה אצל אישה?', 'אילו סוגי מדים (כל סוג של בגדי עבודה) עושים לך את זה אצל גבר?', NULL, 'אילו סוגי מדים (כל סוג של בגדי עבודה) עושים לך את זה אצל אישהגבר?'),
(1744, 'F1602', 1, 'עד כמה גברים בסטאטוס חברתיניהולי גבוה, או עמדת כוח, עושים לך את זה? ', 'עד כמה נשים בסטאטוס חברתיניהולי גבוה, או עמדת כוח, עושים לך את זה? ', NULL, 'עד כמה נשיםגברים בסטאטוס חברתיניהולי גבוה, או עמדת כוח, עושים לך את זה? '),
(1745, 'F1603', 1, 'האם יצא לך להשתמש בסקס אפיל שלך בכוונה כדי להשיג משהו? אם כן, תן דוגמא', 'האם יצא לך להשתמש בסקס אפיל שלך בכוונה כדי להשיג משהו? אם כן, תני דוגמא', NULL, 'האם יצא לך להשתמש בסקס אפיל שלך בכוונה כדי להשיג משהו? אם כן, תןי דוגמא'),
(1746, 'F1604', 1, 'מה דעתך על נשים אמיצות שלא מתביישות להתחיל עם גבר ישירות?', 'אם גבר מוצא חן בעיניך, האם תתחילי איתו ישירות, או שמקסימום תפילי מטפחת ותקווי שהוא ימשיך את העבודה משם?', NULL, NULL),
(1747, 'F1606', 1, 'מציעים לך משכורת מובטחת לכל החיים תמורת ויתור על לימודיםקריירה. מה הסכום  החודשי ברוטו שפחות ממנו לא תסכים לעיסקה?', 'מציעים לך משכורת מובטחת לכל החיים תמורת ויתור על לימודיםקריירה. מה הסכום  החודשי ברוטו שפחות ממנו לא תסכימי לעיסקה?', NULL, NULL),
(1748, 'F1607', 1, 'מציעים לך משכורת מובטחת לכל החיים תמורת ירידה מהארץ. מה הסכום  החודשי ברוטו שפחות ממנו לא תסכים לעיסקה?', 'מציעים לך משכורת מובטחת לכל החיים תמורת ירידה מהארץ. מה הסכום  החודשי ברוטו שפחות ממנו לא תסכימי לעיסקה?', NULL, NULL),
(1749, 'F1608', 1, 'דרג מ 1 עד 10 עד כמה כדאיות הדרכים הבאות כדי להרשים אישה:', 'דרגי מ 1 עד 10 עד כמה כדאיות הדרכים הבאות כדי להרשים גבר:', NULL, 'עד כמה כדאיות הדרכים הבאות כדי להרשים גבראישה:'),
(1750, 'F1609', 1, 'דרג מ 1 עד 10 עד כמה כדאיות הדרכים הבאות כדי להרשים אישה:', 'דרגי מ 1 עד 10 עד כמה כדאיות הדרכים הבאות כדי להרשים גבר:', NULL, 'עד כמה כדאיות הדרכים הבאות כדי להרשים גבראישה:'),
(1751, 'F1610', 1, 'דרג מ 1 עד 10 עד כמה כדאיות הדרכים הבאות כדי להרשים אישה:', 'דרגי מ 1 עד 10 עד כמה כדאיות הדרכים הבאות כדי להרשים גבר:', NULL, 'עד כמה כדאיות הדרכים הבאות כדי להרשים גבראישה:'),
(1752, 'F1611', 1, 'נניח שיש מסיבת חברים והגיע הקטע שכל אחד חייב לתת 2-3 דקות הופעה, לא משנה מה. במה תופיע?', 'נניח שיש מסיבת חברים והגיע הקטע שכל אחד חייב לתת 2-3 דקות הופעה, לא משנה מה. במה תופיעי?', NULL, 'נניח שיש מסיבת חברים והגיע הקטע שכל אחד חייב לתת 2-3 דקות הופעה, לא משנה מה. במה תופיעי?'),
(1753, 'F1612', 1, 'ספר מה גורם לך להרגיש יותר סקסי? האם זה כשאתה מתעמל? שנותנים לך מחמאות? כשאתה מתלבש יפה, או משהו אחר?', 'ספרי מה גורם לך להרגיש יותר סקסית? האם זה כשאת מתעמלת? שנותנים לך מחמאות? כשאת מתלבשת יפה, או משהו אחר?', NULL, 'מה גורם לכם להרגיש סקסיים?'),
(1754, 'F1613', 1, 'עד כמה נכונות לגביך התכונות הבאות: (נכון מאוד, בכלל לא, קצת, וכו...)', 'עד כמה נכונות לגביך התכונות הבאות: (נכון מאוד, בכלל לא, קצת, וכו...)', NULL, NULL),
(1755, 'F1614', 1, 'עד כמה נכונות לגביך התכונות הבאות: (נכון מאוד, בכלל לא, קצת, וכו...)', 'עד כמה נכונות לגביך התכונות הבאות: (נכון מאוד, בכלל לא, קצת, וכו...)', NULL, NULL),
(1756, 'F1615', 1, 'את מי תעדיף מהאפשרויות הבאות? דרג מ 1 עד 10', 'את מי תעדיפי מהאפשרויות הבאות? דרג מ 1 עד 10', NULL, 'את מי תעדיפו מהאפשרויות הבאות? דרגו מ 1 עד 10'),
(1757, 'F1616', 1, 'את מי תעדיף מהאפשרויות הבאות? דרג מ 1 עד 10', 'את מי תעדיפי מהאפשרויות הבאות? דרג מ 1 עד 10', NULL, 'את מי תעדיפו מהאפשרויות הבאות? דרגו מ 1 עד 10'),
(1758, 'F1617', 1, 'נניח שאתה בדייט עכשיו. איזה חיסרון שלך תנסה להצניע?', 'נניח שאת בדייט עכשיו. איזה חיסרון שלך תנסי להצניע?', NULL, 'אתם בדייט עכשיו. איזה חיסרון שלכם תנסו להצניע?'),
(1759, 'F1618', 1, 'כמה אתה בעניין של אקסטרים? כתוב עד כמה בא לך עכשיו: (מאוד בכלל לא קצת וכו\'... )', 'כמה את בעניין של אקסטרים? כתבי עד כמה בא לך עכשיו: (מאוד בכלל לא קצת וכו\'... )', NULL, 'כמה אתם בעניין של אקסטרים? '),
(1760, 'F1619', 1, 'כמה אתה בעניין של אקסטרים? כתוב עד כמה בא לך עכשיו: (מאוד בכלל לא קצת וכו\'... )', 'כמה את בעניין של אקסטרים? כתבי עד כמה בא לך עכשיו: (מאוד בכלל לא קצת וכו\'... )', NULL, 'כמה אתם בעניין של אקסטרים? '),
(1761, 'F1620', 1, 'בילוי טוב ומרגש זה:', 'בילוי טוב זה:', NULL, 'בילוי טוב זה:'),
(1762, 'F1621', 1, 'מה בא לך עכשיו? פרפרים בבטן, או נוחות ורוגע? ומה אתה מתכוון לעשות כדי להשיג את זה?', 'מה בא לך עכשיו? פרפרים בבטן, או נוחות ורוגע? ומה את מתכוונת לעשות כדי להשיג את זה?', NULL, 'מה בא לך עכשיו? פרפרים בבטן, או נוחות ורוגע? ומה אתה מתכווןת לעשות כדי להשיג את זה?'),
(1763, 'F1622', 1, 'אם אתה בראיון עבודה. איזו תכונה שלך תעדיף להסתיר?', 'את בראיון עבודה עכשיו. איזו תכונה שלך תעדיפי להסתיר?', NULL, 'אתם בראיון עבודה עכשיו. איזו תכונה שלכם תעדיפו להסתיר?'),
(1764, 'F1623', 1, 'האם יש לך צד נשי כלשהו? אם כן, איך זה מתבטא?', 'האם יש בך צד גברי כלשהו? אם כן, איך זה מתבטא? ', NULL, NULL),
(1765, 'F1624', 1, 'תאר מחווה רומנטית דביקה במיוחד שעשית בשביל אישה', 'תארי מחווה רומנטית דביקה במיוחד שעשית בשביל גבר', NULL, 'תארי מחווה רומנטית דביקה במיוחד שעשית בשביל גבראישה'),
(1766, 'F1625', 1, 'מישהי שאתה יוצא איתה כבר חודש מביאה לך בהפתעה מתנה ארוזה. מה תרצה שיהיה בקופסא?', 'מישהו שאת יוצאת איתו כבר חודש מביא לך בהפתעה מתנה ארוזה. מה תרצי שיהיה בקופסא?', NULL, 'מישהוי שאתם יוצאים איתואיתה כבר חודש מביא לכם בהפתעה מתנה ארוזה. מה תרצו שיהיה בקופסא?'),
(1767, 'F1626', 1, 'יש לך יום הולדת. מה היית רוצה לקבל מהחברה? (דרג במילים כמו מאוד, בכלל לא, קצת, וכו\'...)', 'יש לך יום הולדת. מה היית רוצה לקבל מהחבר? (דרגי במילים כמו מאוד, בכלל לא, קצת, וכו\'...)', NULL, 'איזו מתנה הייתם רוצים לקבל מהחברה ליום ההולדת?'),
(1768, 'F1627', 1, 'יש לך יום הולדת. מה היית רוצה לקבל מהחברה? (דרג במילים כמו מאוד, בכלל לא, קצת, וכו\'...)', 'יש לך יום הולדת. מה היית רוצה לקבל מהחברה? (דרג במילים כמו מאוד, בכלל לא, קצת, וכו\'...)', NULL, 'איזו מתנה הייתם רוצים לקבל מהחברה ליום ההולדת?'),
(1769, 'F1628', 1, 'האם מישהו פעם אמר לך משפט ששינה לך את החיים במובן מסוים? אם כן, מה?', 'האם מישהו פעם אמר לך משפט ששינה לך את החיים במובן מסוים? אם כן, מה?', NULL, 'האם מישהו פעם אמר לך משפט ששינה לך את החיים במובן מסוים? אם כן, מה?'),
(1770, 'F1629', 1, 'עד כמה היית רוצה לעבוד במקצועות הבאים: (מאוד, קצת, בכלל לא ,וכו\'...) ', 'עד כמה היית רוצה לעבוד במקצועות הבאים: (מאוד, קצת, בכלל לא ,וכו\'...) ', NULL, 'עד כמה היית רוצה לעבוד במקצועות הבאים: '),
(1771, 'F1630', 1, 'עד כמה היית רוצה לעבוד במקצועות הבאים: (מאוד, קצת, בכלל לא , וכו\'...) ', 'עד כמה היית רוצה לעבוד במקצועות הבאים: (מאוד, קצת, בכלל לא, וכו\'...) ', NULL, 'עד כמה היית רוצה לעבוד במקצועות הבאים: '),
(1772, 'F1631', 1, 'עד כמה היית רוצה לעבוד במקצועות הבאים: (מאוד, קצת, בכלל לא , וכו\'...) ', 'עד כמה היית רוצה לעבוד במקצועות הבאים: (מאוד, קצת, בכלל לא , וכו\'...) ', NULL, 'עד כמה היית רוצה לעבוד במקצועות הבאים: '),
(1773, 'F1632', 1, 'מתי היתה הפעם האחרונה שאמא שלך קנתה לך בגדים? מה היא קנתה?', 'מתי היתה הפעם האחרונה שאמא שלך קנתה לך בגדים? מה היא קנתה?', NULL, 'מתי היתה הפעם האחרונה שאמא שלך קנתה לך בגדים? מה היא קנתה?'),
(1774, 'F1633', 1, 'עד כמה התכונות הללו מגדירות אותך? (מאוד, קצת, בכלל לא, וכו\'...) ', 'עד כמה התכונות הללו מגדירות אותך? (מאוד, קצת, בכלל לא, וכו\'...) ', NULL, 'עד כמה התכונות הללו מגדירות אותך?'),
(1775, 'F1634', 1, 'האם אתה מוכן להיות עם מישהי ש... (השב במילים כמו \"מאוד, בכלל לא, אולי, ככה ככה, וכו\'...\"', 'האם את מוכנה להיות עם מישהו ש.... (השיבי במילים כמו \"מאוד, בכלל לא, אולי, ככה ככה, וכו\'...\"', NULL, 'עד כמה אתם מוכנים להיות עם מישהוי ש:'),
(1776, 'F1635', 1, 'האם הרגשת פעם בפאניקה אמיתית? אם כן, ממה?', 'האם הרגשת פעם בפאניקה אמיתית? אם כן, ממה?', NULL, 'האם הרגשת פעם בפאניקה אמיתית? אם כן, ממה?'),
(1777, 'F1636', 1, 'האם שיקרת אי פעם לבוס שלך? בקשר למה?', 'האם שיקרת אי פעם לבוס שלך? בקשר למה?', NULL, 'האם שיקרת אי פעם לבוס שלך? בקשר למה?'),
(1778, 'F1637', 1, 'עם איזה שיר היית רוצה להתעורר בבוקר?', 'עם איזה שיר היית רוצה להתעורר בבוקר?', NULL, 'עם איזה שיר היית רוצה להתעורר בבוקר?'),
(1779, 'F1638', 1, 'האם אתה זקוק ל\'תנאים\' מסוימים כדי להירדם, או שאתה נרדם בקלות גם על ערימת אבנים?', 'האם את זקוקה ל\'תנאים\' מסוימים כדי להירדם, או שאת נרדמת בקלות גם על ערימת אבנים?', NULL, 'האם אתם זקוקים לתנאים מסוימים כדי להירדם, או שאתם נרדמים בקלות גם על ערימת אבנים?'),
(1780, 'F1639', 1, 'כמה עמוק אתה ישן? האם אתה מתעורר מכל רעש קטן, או שגם תותח לא יעיר אותך?', 'כמה עמוק את ישנה? האם את מתעוררת מכל רעש קטן, או שגם תותח לא יעיר אותך?', NULL, 'כמה עמוק אתם ישנים? האם אתם מתעוררים מכל רעש קטן, או שגם תותח לא יעיר אתכם?'),
(1781, 'F1640', 1, 'שבת בבוקר. בחוץ גשם וסערה. ', 'שבת בבוקר. בחוץ גשם וסערה. ', NULL, 'שבת בבוקר. בחוץ גשם וסערה. '),
(1782, 'F1641', 1, 'בחוץ חמסין כבד. ', 'בחוץ חמסין כבד. ', NULL, 'בחוץ חמסין כבד. '),
(1783, 'F1642', 1, 'מה עוזר לך להירגע? דרג מ 1 עד 10', 'מה עוזר לך להירגע? דרגי מ 1 עד 10', NULL, 'מה עוזר לך להירגע?'),
(1784, 'F1643', 1, 'האם יצא לך פעם לנאום בפני קהל? אם כן, איך היתה ההרגשה?', 'האם יצא לך פעם לנאום בפני קהל? אם כן, איך היתה ההרגשה?', NULL, 'האם יצא לך פעם לנאום בפני קהל? אם כן, איך היתה ההרגשה?'),
(1785, 'F1644', 1, 'באיזה מקרה ספציפי הצד הרך והאמפטי שלך בא לידי ביטוי?', 'באיזה מקרה ספציפי הצד הרך והאמפטי שלך בא לידי ביטוי?', NULL, 'באיזה מקרה ספציפי הצד הרך והאמפטי שלך בא לידי ביטוי?'),
(1786, 'F1645', 1, 'דרג עד כמה חשובות לך התכונות הבאות אצל בת הזוג... (השב במילים \"מאוד, בכלל לא, קצת\", וכו...', 'דרגי עד כמה חשובות לך התכונות הבאות אצל בן הזוג (השיבי במילים \"מאוד, בכלל לא, קצת\", וכו...', NULL, 'דרגי עד כמה חשובות לך התכונות הבאות אצל בןבת הזוג:'),
(1787, 'F1646', 1, 'ממי כדאי שתבקש סליחה ביום כיפור? ועל מה?', 'ממי כדאי שתבקשי סליחה ביום כיפור? ועל מה?', NULL, 'ממי כדאי שתבקשי סליחה ביום כיפור? ועל מה?'),
(1788, 'F1647', 1, 'עד כמה תתבייש אם אחרים יגידו שאתה: (מאוד, בכלל לא, קצת וכו\'...) ', 'עד כמה זה נכון אם אחרים יגידו לך שאת: (מאוד, בכלל לא, קצת וכו\'...) ', NULL, 'עד כמה זה נכון אם אחרים יגידו שאתם: '),
(1789, 'F1648', 1, 'עד כמה תתבייש אם אחרים יגידו שאתה: (מאוד, בכלל לא, קצת וכו\'...) ', 'עד כמה זה נכון אם אחרים יגידו לך שאת: (מאוד, בכלל לא, קצת וכו\'...) ', NULL, 'עד כמה זה נכון אם אחרים יגידו שאתם: '),
(1790, 'F1649', 1, 'עד כמה מפחיד אותך לטייל ב: (מאוד, בכלל לא, קצת וכו\'...) ', 'עד כמה מפחיד אותך לטייל ב: (מאוד, בכלל לא, קצת וכו\'...) ', NULL, 'עד כמה מפחיד אותך לטייל ב:'),
(1791, 'F1650', 1, 'דרג עד כמה בא לך שההרפתקאה הבאה שלך תהיה ב: (מאוד, בכלל לא, קצת וכו\'...)', 'דרגי עד כמה בא לך שההרפתקאה הבאה שלך תהיה ב: (מאוד, בכלל לא, קצת וכו\'...)', NULL, 'דרגי עד כמה בא לך שההרפתקאה הבאה שלך תהיה ב: '),
(1792, 'F1651', 1, 'דרג עד כמה בא לך שההרפתקאה הבאה שלך תהיה ב: (מאוד, בכלל לא, קצת וכו\'...)', 'דרגי עד כמה בא לך שההרפתקאה הבאה שלך תהיה ב: (מאוד, בכלל לא, קצת וכו\'...)', NULL, 'דרגי עד כמה בא לך שההרפתקאה הבאה שלך תהיה ב: '),
(1793, 'F1653', 1, 'על מה לא תסלח בחיים אם יעשו לך אותו?', 'על מה לא תסלחי בחיים אם יעשו לך אותו?', NULL, 'על מה לא תסלחי בחיים אם יעשו לך אותו?'),
(1794, 'F1654', 1, 'כמה מהר או לאט אתה מתעצבן,  וכמה מהר או לאט אתה נרגע? ', 'כמה מהר או לאט את מתעצבנת  וכמה מהר או לאט את נרגעת? ', NULL, 'כמה מהר אתם מתעצבנים, וכמה מהר אתם נרגעים?'),
(1795, 'F1655', 1, 'האם שברת פעם משהו מתוך כעס? מה זה היה ואיך?', 'האם שברת פעם משהו מתוך כעס? מה זה היה ואיך?', NULL, 'האם שברת פעם משהו מתוך כעס? מה זה היה ואיך?'),
(1796, 'F1656', 1, 'האם לפעמים אתה מדוכא או מדוכדך בלי סיבה? אם כן, איך אתה יוצא מזה?', 'האם לפעמים את מדוכאת או מדוכדכת בלי סיבה? אם כן, איך את יוצאת מזה?', NULL, 'האם לפעמים אתם מדוכאים או מדוכדכים בלי סיבה? איך אתם יוצאים מזה? '),
(1797, 'F1657', 1, 'ספר כמה חברים טובים יש לך מכל תקופה (הילדות, הצבא, עבודה, וכו\'... ) ', 'ספרי כמה חברים טובים יש לך מכל תקופה (הילדות, הצבא, עבודה, וכו\'... ) ', NULL, 'ספרי כמה חברים טובים יש לך מכל תקופה (הילדות, הצבא, עבודה, וכו\'... ) '),
(1798, 'F1658', 1, 'מה אכלת אתמול לארוחת צהריים? (בבקשה לפרט הכל!)', 'מה אכלת אתמול לארוחת צהריים? (בבקשה לפרט הכל!)', NULL, 'מה אכלת אתמול לארוחת צהריים? (בבקשה לפרט הכל!)'),
(1799, 'F1659', 1, 'מה אכלת אתמול לארוחת ערב? בבקשה לפרט הכל)', 'מה אכלת אתמול לארוחת ערב? בבקשה לפרט הכל)', NULL, 'מה אכלת אתמול לארוחת ערב? בבקשה לפרט הכל)'),
(1800, 'F1660', 1, 'איזה משחקים שיחקת הכי הרבה בחיים?', 'איזה משחקים שיחקת הכי הרבה בחיים?', NULL, 'איזה משחקים שיחקת הכי הרבה בחיים?'),
(1801, 'F1661', 1, 'עד כמה מבאסות העבודות הבאות? (הכי מבאס, קצת מבאס, לא מבאס, וכו\'...) ', 'עד כמה מבאסות העבודות הבאות? (הכי מבאס, קצת מבאס, לא מבאס, וכו\'...) ', NULL, 'עד כמה מבאסות העבודות הבאות?'),
(1802, 'F1662', 1, 'עד כמה מבאסות העבודות הבאות? (הכי מבאס, קצת מבאס, לא מבאס, וכו\'...) ', 'עד כמה מבאסות העבודות הבאות? (הכי מבאס, קצת מבאס, לא מבאס, וכו\'...) ', NULL, 'עד כמה מבאסות העבודות הבאות?'),
(1803, 'F1663', 1, 'מתי בפעם האחרונה רבת עם אמא שלך? ועל מה?', 'מתי בפעם האחרונה רבת עם מישהו מהמשפחה שלך? על מה?', NULL, 'מתי בפעם האחרונה רבת עם אמא שלך? ועל מה?'),
(1804, 'F1664', 1, 'תאר את ההערכות שקיבלת בתיכון', 'תארי את ההערכות שקיבלת בתיכון', NULL, 'תארי את ההערכות שקיבלת בתיכון'),
(1805, 'F1665', 1, 'עד כמה אתה טיפוס של \"מולטי בילויים\" לערב אחד, מול \"בילוי אחד ויחיד זה מספיק\"?', 'עד כמה את טיפוס של \"מולטי בילויים\" לערב אחד, מול \"בילוי אחד ויחיד זה מספיק\"?', NULL, 'עד כמה אתה טיפוס של \"מולטי בילויים\" לערב אחד, מול \"בילוי אחד ויחיד זה מספיק\"?'),
(1806, 'F1666', 1, 'תאר את ההערכות שקיבלת בתיכון', 'תארי את ההערכות שקיבלת בתיכון', NULL, 'תארי את ההערכות שקיבלת בתיכון'),
(1807, 'F1667', 1, 'דרג מהרשימה, עד כמה רומנטי כל דבר בעיניך: (מאוד, קצת, בכלל לא, וכו\'...)', 'דרגי מהרשימה, עד כמה רומנטי כל דבר בעיניך: (מאוד, קצת, בכלל לא, וכו\'...)', NULL, 'עד כמה רומנטי כל דבר בעיניך: '),
(1808, 'F1668', 1, 'דרג מהרשימה, עד כמה רומנטי כל דבר בעיניך: (מאוד, קצת, בכלל לא, וכו\'...)', 'דרגי מהרשימה, עד כמה רומנטי כל דבר בעיניך: (מאוד, קצת, בכלל לא, וכו\'...)', NULL, 'עד כמה רומנטי כל דבר בעיניך: '),
(1809, 'F1669', 1, 'כמה אתה מסודר ונקי?', 'כמה את מסודרת ונקיה?', NULL, 'כמה אתם מסודרים ונקיים?'),
(1810, 'F1670', 1, 'באילו מקרים היית פוסל מישהי מראש? (ענה ב\"פוסל\" או \"לא פוסל\")', 'באילו מקרים היית פוסלת מישהו מראש? (ענה ב\"פוסלת\" או \"לא פוסלת\")', NULL, 'באילו מקרים הייתם פוסלים מישהוי מראש?'),
(1811, 'F1671', 1, 'באילו מקרים היית פוסל מישהי מראש? (ענה ב\"פוסל\" או \"לא פוסל\")', 'באילו מקרים היית פוסלת מישהו מראש? (ענה ב\"פוסלת\" או \"לא פוסלת\")', NULL, 'באילו מקרים הייתם פוסלים מישהוי מראש?'),
(1812, 'F1672', 1, 'האם היה מקרה שבו פסלת מישהי מראש בגלל משהו (שאינו צורה חיצונית)? אם כן, בגלל מה?', 'האם היה מקרה שבו פסלת מישהו מראש בגלל משהו (שאינו צורה חיצונית)? אם כן, בגלל מה?', NULL, 'האם היה מקרה שבו פסלת מישהוי מראש בגלל משהו (שאינו צורה חיצונית)? אם כן, בגלל מה?'),
(1813, 'F1673', 1, 'תאר ב 2-4 מילים את תקופת הילדות שלך', 'תארי ב 2-4 מילים את תקופת הילדות שלך', NULL, 'תארי ב 2-4 מילים את תקופת הילדות שלך'),
(1814, 'F1674', 1, 'ספר על משהו מיוחד ויוצא דופן שעשית השבוע', 'ספרי על משהו מיוחד ויוצא דופן שעשית השבוע', NULL, 'ספרי על משהו מיוחד ויוצא דופן שעשית השבוע'),
(1815, 'F1675', 1, 'עד כמה נכונות לגביך התכונות הבאות: (נכון מאוד, בכלל לא, קצת, וכו...)', 'עד כמה נכונות לגביך התכונות הבאות: (נכון מאוד, בכלל לא, קצת, וכו...)', NULL, 'עד כמה נכונות לגביך התכונות הבאות: '),
(1816, 'F1676', 1, 'תאר במשפט קצר או כותרת את הסרט שיעשו על החיים שלך', 'תארי במשפט קצר או כותרת את הסרט שיעשו על החיים שלך', NULL, 'תארי במשפט קצר או כותרת את הסרט שיעשו על החיים שלך'),
(1817, 'F1677', 1, 'כשאתה לבד, האם אתה מחפש להפסיק את זה כמה שיותר מהר, או שאתה נהנה להיות לבד?', 'כשאת לבד, האם את מחפשת להפסיק את זה כמה שיותר מהר, או נהנית להיות לבד?', NULL, 'כשאתם לבד, האם אתם מחפשים להפסיק את זה, או נהנים להיות לבד?'),
(1818, 'F1678', 1, 'האם אתה חושב שאתה עובד קשה מידי? מה סוג העבודה שלך?', 'האם את חושבת שאת עובדת קשה מידי? מה סוג העבודה שלך?', NULL, 'האם אתם חושבים שאתם עובדים קשה מידי? מה סוג העבודה שלכם?'),
(1819, 'F1679', 1, 'באיזה ביטוי יוצא לך להשתמש הרבה (למשל - Been there, done that)', 'באיזה ביטוי יוצא לך להשתמש הרבה (למשל - \"Been there, done that\" או \"זו לא תכנית כבקשתך\" וכו\'..)', NULL, 'באיזה ביטוי יוצא לך להשתמש הרבה (למשל - \"Been there, done that\" או \"זו לא תכנית כבקשתך\" וכו\'..)'),
(1820, 'F1680', 1, 'כתוב לפחות 3 חטיפים מלוחים לא בריאים שאתה מכור אליהם', 'כתבי לפחות 3 חטיפים מלוחים לא בריאים שאת מכורה אליהם', NULL, 'כתבו לפחות 3 חטיפים מלוחים וממש לא בריאים שאתם מכורים אליהם'),
(1821, 'F1681', 1, 'כתוב לפחות 3 דברים מתוקים וממש לא בריאים שאתה מכור אליהם', 'כתבי לפחות 3 דברים מתוקים וממש לא בריאים שאת מכורה אליהם', NULL, 'כתבו לפחות 3 דברים מתוקים וממש לא בריאים שאתם מכורים אליהם'),
(1822, 'F1682', 1, 'ידידה שלך שואלת אותך אם היא השמינה, ואתה רואה בבירור שכן, והרבה. איך תשיב?', 'ידיד שלך שואל אותך אם הוא השמין, ואת רואה בבירור שכן, והרבה. איך תגיבי?', NULL, 'ידידה שלכם שואלת אתכם אם הואהיא השמינה. אתם רואים שכן. איך תגיבו?'),
(1823, 'F1683', 1, 'למה בא לך להתחפש בפורים הקרוב?', 'למה בא לך להתחפש בפורים הקרוב?', NULL, 'למה בא לך להתחפש בפורים הקרוב?'),
(1824, 'F1684', 1, 'תאר עד כמה אתה אוהב דברים לא בריאים בחגים: (אוהב מאוד, בכלל לא, קצת, וכו\'...)', 'תארי עד כמה את אוהבת דברים לא בריאים בחגים: (אוהבת מאוד, בכלל לא, קצת, וכו\'...)', NULL, 'עד כמה אתה אוהבת דברים לא בריאים בחגים: '),
(1825, 'F1685', 1, 'מה משך הזמן הכי גדול ברציפות שבו עשית את הפעילויות הבאות:', 'מה משך הזמן הכי גדול ברציפות שבו עשית את הפעילויות הבאות:', NULL, 'מה משך הזמן הכי גדול ברציפות שבו עשית את הפעילויות הבאות:'),
(1826, 'F1686', 1, 'תאר את עצמך בעוד 20 שנה:', 'תארי את עצמך בעוד 20 שנה:', NULL, NULL),
(1827, 'F1687', 1, 'תאר כמה אתה פוחד מ: (בכלל לא, קצת, הרבה מאוד וכו\'...) ', 'תאר כמה את פוחדת מ: (בכלל לא, קצת, הרבה מאוד וכו\'...) ', NULL, NULL),
(1828, 'F1688', 1, 'עד כמה אתה טיפוס שאוהב ילדים? (ילדים של בני משפחה שלך וכו\'...)', 'עד כמה את טיפוס שאוהבת ילדים? (ילדים של בני משפחה שלך וכו\'...)', NULL, 'עד כמה אתם אוהבים ילדים?'),
(1829, 'F1689', 1, 'איזה דבר אחד היה צריך להשתנות אתמול, כדי שאתמול יהיה יום מוצלח במיוחד? ואם היה ממילא מוצלח, מה הסיבה שהיה כזה מוצלח?', 'איזה דבר אחד היה צריך להשתנות אתמול, כדי שאתמול יהיה יום מוצלח במיוחד? ואם היה ממילא מוצלח, מה הסיבה שהיה כזה מוצלח?', NULL, 'איזה דבר אחד היה צריך להשתנות אתמול, כדי שאתמול יהיה יום מוצלח במיוחד?'),
(1830, 'F1690', 1, 'במה אפשר לסמוך עליך?', 'במה אפשר לסמוך עליך?', NULL, NULL),
(1831, 'F1691', 1, 'נניח שמזמינים אותך לטיול טבע של יומיים בסופ\"ש הקרוב. השב במילים \"יש\" או \"אין\"', 'נניח שמזמינים אותך לטיול טבע יומיים בסופ\"ש הקרוב. השיבי במילים \"יש\" או \"אין\"', NULL, 'טיול בטבע'),
(1832, 'F1692', 1, 'מה נחשבת הצלחה בחיים בעיניך? דרג את הערכים הבאים: (בכלל לא, קצת, חשוב מאוד, וכו\'...)', 'מה נחשבת הצלחה בחיים בעיניך? דרגי את הערכים הבאים: (בכלל לא, קצת, חשוב מאוד, וכו\'...)', NULL, 'מה נחשבת הצלחה בחיים בעיניך?'),
(1833, 'F1693', 1, 'איך אתה בבקרים?', 'איך את בבקרים?', NULL, 'איך אתם בבקרים?'),
(1834, 'F1694', 1, 'איך אתה בבקרים? דרג את הפעיליות הבאות: (נורא ואיום, מעולה, ככה ככה, וכו\'..) ', 'איך את בבקרים? דרגי את הפעיליות הבאות: (נורא ואיום, מעולה, ככה ככה, וכו\'..) ', NULL, 'איך אתם בבקרים? '),
(1835, 'F1695', 1, 'איך נראות בדרך כלל ארוחות הצהריים שלך? כבדות עם בשר, או סלטים קלילים?', 'איך נראות בדרך כלל ארוחות הצהריים שלך? כבדות עם בשר, או סלטים קלילים, או משהו אחר?', NULL, 'איך נראות בדרך כלל ארוחות הצהריים שלך? כבדות עם בשר, או סלטים קלילים, או משהו אחר?'),
(1836, 'F1696', 1, 'נניח שמציעים לך עבודה זמנית ליום אחד. דרג עד כמה אתה מעוניין ב: (בכלל לא, מאוד, קצת, וכו\'...) ', 'נניח שמציעים לך עבודה זמנית ליום אחד. דרגי עד כמה אתה מעוניינת ב: (בכלל לא, מאוד, קצת, וכו\'...) ', NULL, 'נניח שמציעים לכם עבודה זמנית ליום אחד, דרגו כמה אתם מעוניינים ב:'),
(1837, 'F1697', 1, 'חבר שלך יוצא לדייט עם מישהי שהיא בענק מעל לליגה שלו. איזו עצה תיתן לו לקראת הדייט?', 'חברה שלך יוצאת לדייט עם מישהו שהוא בענק מעל לליגה שלה. איזו עצה תתני לה לקראת הדייט?', NULL, 'חברה שלך יוצאת לדייט עם מישהוי שהואהיא בענק מעל לליגה שלוה. איזו עצה תתני להו לקראת הדייט?'),
(1838, 'F1698', 1, 'יש קריוקי ואתה חייב לשיר. באיזה שיר תבחר? במידה שאין, תן שיר חליפי', 'יש קריוקי ואת חייבת לשיר. באיזה שיר תבחרי? באיזה שיר חליפי?', NULL, 'יש קריוקי ואתם חייבים לשיר. באיזה שיר תבחרו? באיזה שיר חליפי?'),
(1839, 'F1699', 1, 'הסתכל מבעד לחלון שלידך. מה אתה רואה? ', 'הסתכלי מבעד לחלון שלידך. מה את רואה? ', NULL, 'הסתכלי מבעד לחלון שלידך. מה אתה רואה?'),
(1840, 'F1700', 1, 'מה התכניות שלך לסוף השבוע הקרוב?', 'מה התכניות שלך לסוף השבוע הקרוב?', NULL, 'מה התכניות שלך לסוף השבוע הקרוב?'),
(1841, 'F1701', 1, 'האם אתה מודה שחטאת בעבר באחד מהחטאים האלה: (מודה, לא מודה, קצת וכו\'... )', 'האם את מודה שחטאת בעבר באחד מהחטאים האלה: (מודה, לא מודה, קצת וכו\'... )', NULL, 'האם אתה מודה שחטאת בעבר באחד מהחטאים האלה:'),
(1842, 'F1702', 1, 'האם אתה מודה שחטאת בעבר באחד מהחטאים האלה: (מודה, לא מודה, קצת וכו\'... )', 'האם את מודה שחטאת בעבר באחד מהחטאים האלה: (מודה, לא מודה, קצת וכו\'... )', NULL, 'האם אתה מודה שחטאת בעבר באחד מהחטאים האלה:'),
(1843, 'F1703', 1, 'האם יצא לך לקנא (קנאה שלילית וצורבת) באחד החברים שלך? אם כן, על מה?', 'האם יצא לך לקנא (קנאה שלילית וצורבת) באחת החברות שלך? אם כן, על מה?', NULL, 'האם יצא לך לקנא (קנאה שלילית וצורבת) באחדת החבריםות שלך?'),
(1844, 'F1704', 1, 'עד כמה בא לך לעשות בזה הרגע את הפעילויות הבאות (מאוד, בכלל לא, קצת וכו\'...) ', 'עד כמה בא לך לעשות בזה הרגע את הפעילויות הבאות (מאוד, בכלל לא, קצת וכו\'...) ', NULL, 'עד כמה בא לך לעשות בזה הרגע את הפעילויות הבאות:'),
(1845, 'F1705', 1, 'האם אתה נחשב בעיני החבר\'ה שלך כיועץ טוב? איזו עצה נתת לאחרונה? ', 'האם את נחשבת בעיני החבר\'ה שלך כיועצת טובה? איזו עצה טובה נתת לאחרונה? ', NULL, 'האם אתם נחשבים בעיני החברים כיועצים טובים? איזה עצה נתתם לאחרונה?'),
(1846, 'F1706', 1, 'נניח שהיתה לך מילגה חלומית ללמוד איפה שתרצה ומה שתרצה. מה היית לומד, ואיפה?', 'נניח שהיתה לך מילגה חלומית ללמוד איפה שתרצי ומה שתרצי. מה היית לומדת, ואיפה?', NULL, 'נניח שהיתה לכם מילגה חלומית ללמוד איפה שתרצו ומה שתרצו. מה הייתם לומדים ואיפה?'),
(1847, 'F1707', 1, 'ספר על חפץ שאתה אובססיבי לגביו, ולמה', 'ספרי על חפץ שאת אובססיבית לגביו, ולמה', NULL, 'ספרו על חפץ שאתם אובססיבים לגביו, ולמה'),
(1848, 'F1708', 1, 'ספר על איסור חמור שאתה משתוקק מאוד  להפר אותו', 'ספרי על איסור חמור שאת משתוקקת מאוד להפר אותו', NULL, 'ספרו על איסור חמור שאתם משתוקקים מאוד להפר אותו'),
(1849, 'F1709', 1, 'עד כמה כלי הרכב מחרמן אותך? (מאוד, בכלל לא, קצת, וכו\'...) ', 'עד כמה כלי הרכב מחרמן אותך? (מאוד, בכלל לא, קצת, וכו\'...) ', NULL, 'עד כמה כלי הרכב מחרמן אותך? '),
(1850, 'F1710', 1, 'אם האוכל במסעדה לא טעים אבל השירות טוב, איזה טיפ תשאיר למלצרית, אם בכלל?', 'אם האוכל במסעדה לא טעים אבל השירות טוב, איזה טיפ תשאירי למלצרית, אם בכלל?', NULL, 'אם האוכל במסעדה לא טעים אבל השירות טוב, איזה טיפ תשאירי למלצרית, אם בכלל?'),
(1851, 'F1711', 1, 'עד כמה חצוף בעיניך בבית קפה? (מאוד, בכלל לא, קצת וכו\'...) ', 'עד כמה חצוף בעיניך בבית קפה? (מאוד, בכלל לא, קצת וכו\'...) ', NULL, 'עד כמה חצוף בעיניך בבית קפה? '),
(1852, 'F1712', 1, 'מה היית רוצה לומר בסתר ליבך לאמא שמתעלמת מהצרחות של התינוק שלה באמצע בית קפה?', 'מה היית רוצה לומר בסתר ליבך לאמא שמתעלמת מהצרחות של התינוק שלה באמצע בית קפה?', NULL, 'מה היית רוצה לומר בסתר ליבך לאמא שמתעלמת מהצרחות של התינוק שלה באמצע בית קפה?');
INSERT INTO `net_tasktext` (`Id`, `TaskId`, `LanguageId`, `TextForM`, `TextForF`, `BackgroundImage`, `CommonDescription`) VALUES
(1853, 'F1713', 1, 'מתי היתה החופשה האחרונה שלך, איפה, ולכמה זמן?', 'מתי היתה החופשה האחרונה שלך, איפה, ולכמה זמן?', NULL, 'מתי היתה החופשה האחרונה שלך, איפה, ולכמה זמן?'),
(1854, 'F1714', 1, 'אם מותר לך לבחור רק אחד - היית מתקן את החיים האישיים, או המקצועיים שלך? ומה היית מתקן?', 'אם מותר לך לבחור רק אחד - היית מתקנת את החיים האישיים, או המקצועיים שלך? ומה היית מתקנת?', NULL, 'אם מותר לך לבחור רק אחד - היית מתקנת את החיים האישיים, או המקצועיים שלך? ומה היית מתקנת?'),
(1855, 'F1715', 1, 'מהי התקופה הכי טובה בחייך. ולמה?', 'מהי התקופה הכי טובה בחייך. ולמה?', NULL, 'מהי התקופה הכי טובה בחייך. ולמה?'),
(1856, 'F1716', 1, 'האם יצא לך להישאר בקשר טוב עם אקסית שלך גם אחרי הפרידה?', 'האם יצא לך להישאר בקשר טוב עם אקס שלך גם אחרי הפרידה?', NULL, 'האם יצא לך להישאר בקשר טוב עם אקסית שלך גם אחרי הפרידה?'),
(1857, 'F1717', 1, 'דרג את מדד התענוג (הכי בעולם, לא מעניין, ככה ככה וכו\'...) ', 'דרגי את מדד התענוג (הכי בעולם, לא מעניין, ככה ככה וכו\'...) ', NULL, 'דרגי את מדד התענוג '),
(1858, 'F1718', 1, 'פוביות', 'פוביות', NULL, NULL),
(1859, 'F1719', 1, 'פוביות', 'פוביות', NULL, NULL),
(1860, 'F1720', 1, 'עד כמה תאהב בילוי שמכיל: (בכלל לא, מאוד, קצת וכו\'...) ', 'עד כמה תאהבי בילוי שמכיל: (בכלל לא, מאוד, קצת וכו\'...) ', NULL, 'עד כמה תאהבי בילוי שמכיל: '),
(1861, 'F1721', 1, 'אתה צריך לקרוא לסופה בשם של אדם שאתה שונא. מה השם, ומדוע אתה שונא אותואותה?', 'את צריכה לקרוא לסופה בשם של אדם שאתה שונאת. מה השם, ומדוע את שונאת אותואותה?', NULL, 'אתם צריכים לקרוא לסופה בשם של אדם שאתם שונאים. מה השם, ומדוע אתם שונאים אותואותה?'),
(1862, 'F1722', 1, 'האם בכית פעם בגלל פרידה? אם כן, באילו נסיבות?', 'האם בכית פעם בגלל פרידה? אם כן, באילו נסיבות?', NULL, 'האם בכית פעם בגלל פרידה? אם כן, באילו נסיבות?'),
(1863, 'F1723', 1, 'האם בכית פעם בגלל שהפסדת הזדמנות? על מה? ואם לא, איך הגבת אל הפסד הזדמנות?', 'האם בכית פעם בגלל שהפסדת הזדמנות? על מה? ואם לא, איך הגבת אל הפסד הזדמנות?', NULL, 'האם בכית פעם בגלל שהפסדת הזדמנות? על מה? ואם לא, איך הגבת אל הפסד הזדמנות?'),
(1864, 'F1724', 1, 'האם בכית פעם בגלל מוות? באילו נסיבות?', 'האם בכית פעם בגלל מוות? באילו נסיבות?', NULL, 'האם בכית פעם בגלל מוות? באילו נסיבות?'),
(1865, 'F1725', 1, 'האם בכית פעם בגלל ריב עם ההורים? אם כן, באילו נסיבות?', 'האם בכית פעם בגלל ריב עם ההורים? אם כן, באילו נסיבות?', NULL, 'האם בכית פעם בגלל ריב עם ההורים? אם כן, באילו נסיבות?'),
(1866, 'F1726', 1, 'אחרי תקופה לחוצה, באיזה אופן אתה מרשה לעצמך להתפרק?', 'אחרי תקופה לחוצה, באיזה אופן את מרשה לעצמך להתפרק?', NULL, 'אחרי תקופה לחוצה, באיזה אופן אתה מרשה לעצמך להתפרק?'),
(1867, 'F1727', 1, 'לאיזו מטרה בא לך לתרום כסף?', 'לאיזו מטרה בא לך לתרום כסף?', NULL, 'לאיזו מטרה בא לך לתרום כסף?'),
(1868, 'F1728', 1, 'מהי מערכת היחסים הארוכה ביותר שהיתה לך? מדוע היא הסתיימה?', 'מהי מערכת היחסים הארוכה ביותר שהיתה לך? מדוע היא הסתיימה?', NULL, 'מהי מערכת היחסים הארוכה ביותר שהיתה לך? מדוע היא הסתיימה?'),
(1869, 'F1729', 1, 'כמה מערכות יחסים היו לך? כמה מתוכן משמעותיות?', 'כמה מערכות יחסים היו לך? כמה מתוכן משמעותיות?', NULL, 'כמה מערכות יחסים היו לך? כמה מתוכן משמעותיות?'),
(1870, 'F1730', 1, 'בהנחה שנפרדו ממך פעם. מה היתה התקופה הארוכה ביותר שלקח לך להתאושש מהכאב? ', 'מה היתה התקופה הארוכה ביותר שלקח לך להתאושש מכאב פרידה?', NULL, 'מה היתה התקופה הארוכה ביותר שלקח לך להתאושש מכאב פרידה?'),
(1871, 'F1731', 1, 'בהנחה שנפרדו ממך פעם. מה היתה התקופה הקצרה ביותר שלקח לך להתאושש מהכאב? ', 'מה היתה התקופה הקצרה ביותר שלקח לך להתאושש מהכאב? ', NULL, 'מה היתה התקופה הקצרה ביותר שלקח לך להתאושש מהכאב? '),
(1872, 'F1732', 1, 'הרכב את אשת חלומותיך - בחר 3 תכונות בלבד מהנ\"ל: הומור, כנות, אינטלגנציה, ביטחון עצמי, סקס טוב, מעגל חברתי רחב,  קריירה טובה', 'הרכיבי את גבר חלומותיך - בחרי 3 תכונות בלבד מהנ\"ל: הומור, כנות, אינטלגנציה, ביטחון עצמי, סקס טוב, מעגל חברתי רחב,  קריירה טובה', NULL, 'הרכיבו את גבראשת חלומותיך - בחרו 3 תכונות בלבד:'),
(1873, 'F1733', 1, 'הרכב את האישה האידיאלית: ', 'הרכיבי את הגבר האידיאלי:', NULL, 'הרכבהרכיבי את גבראשת האידיאלים: '),
(1874, 'F1734', 1, 'על מה תפרק מערכת יחסים? (כן, לא, אולי וכו\'...) ', 'על מה תפרקי מערכת יחסים? (כן, לא, אולי וכו\'...) ', NULL, 'על מה תפרקי מערכת יחסים? '),
(1875, 'F1735', 1, 'על מה תפרק מערכת יחסים? (כן, לא, אולי וכו\'...) ', 'על מה תפרקי מערכת יחסים? (כן, לא, אולי וכו\'...) ', NULL, 'על מה תפרקי מערכת יחסים? '),
(1876, 'F1736', 1, 'על מה תפרק מערכת יחסים? (כן, לא, אולי וכו\'...) ', 'על מה תפרקי מערכת יחסים? (כן, לא, אולי וכו\'...) ', NULL, 'על מה תפרקי מערכת יחסים? '),
(1877, 'F1737', 1, 'אחרי כמה זמן היכרות מותר להגיד \"אני אוהבת אותך\"?', 'אחרי כמה זמן היכרות מותר להגיד \"אני אוהב אותך\"?', NULL, 'אחרי כמה זמן היכרות מותר להגיד \"אני אוהבת אותך\"?'),
(1878, 'F1738', 1, 'בשדה התעופה - האם אתה נפרד במהירות, או מושך פרידה עם מיליון חיבוקים ונשיקות?', 'בשדה התעופה - האם את נפרדת במהירות, או מושכת פרידה עם מיליון חיבוקים ונשיקות?', NULL, 'בשדה תעופה - האם אתם נפרדים במהירות, או מושכים פרידה עם מיליון חיבוקים ונשיקות?'),
(1879, 'F1739', 1, 'האם בחורה עשתה לך פעם עוול? אם כן, מהו?', 'האם גבר עשה לך פעם עוול? אם כן, מהו?', NULL, 'האם גבראישה עשו לכם פעם עוול? מהו?'),
(1880, 'F1740', 1, 'בזמן שאתה נמצא במערכת יחסים, האם תרשה לעצמך לפלרטט עם נשים אחרות?', 'בזמן שאת נמצאת במערכת יחסים, האם תרשי לעצמך לפלרטט עם גברים אחרים?', NULL, 'בזמן שאתם במערכת יחסים, האם אתם מרשים לעצמכם לפלרטט עם גבריםנשים אחריםות?'),
(1881, 'F1741', 1, 'בזמן שאתה במערכת יחסים איתו, האם זה בסדר מבחינתך שהיא תפלרטט עם גברים אחרים?', 'בזמן שאת במערכת יחסים איתו, האם זה בסדר מבחינתך שהוא יפלרטט עם נשים אחרות?', NULL, 'בזמן שאתם במערכת יחסים, האם זה בסדר שהואהיא יפלרטטו עם גבריםנשים אחריםות?'),
(1882, 'F1742', 1, 'איפה אתה על הסקאלה? עקשן שקשה להסתדר איתך, או אחד שתמיד מוותר?', 'איפה את על הסקאלה? אחת שקשה להסתדר איתך, או אחת שתמיד מוותרת?', NULL, 'איפה אתם על הסקאלה? עקשנים, או וותרנים?'),
(1883, 'F1744', 1, 'נניח שאתה חייב להפקיד את הגורל שלך בידי מישהו שיקבע הכל עבורך. מי זה יהיה? (בלי הורים)', 'נניח שאת חייבת להפקיד את הגורל שלך בידי מישהו שיקבע הכל עבורך. מי זה יהיה? (בלי הורים)', NULL, 'נניח שאתה חייבת להפקיד את הגורל שלך בידי מישהו שיקבע הכל עבורך. מי זה יהיה? '),
(1884, 'F1745', 1, 'ספר על משהו אחד שאתה מאוד מתחרט לגביו בחייך', 'ספרי על משהו אחד שאת מאוד מתחרטת לגביו בחייך', NULL, 'ספרו על משהו אחד שאתם מאוד מתחרטים לגביו בחיים'),
(1885, 'F1747', 1, 'על מה חשבת אתמול בלילה לפני השינה ממש לפני שנרדמת?', 'על מה חשבת אתמול בלילה לפני השינה ממש לפני שנרדמת?', NULL, 'על מה חשבת אתמול בלילה לפני השינה ממש לפני שנרדמת?'),
(1886, 'F1748', 1, 'כשרע, כדאי לחשוב על דברים חיוביים אבל לא תמיד זה מצליח. יש לך שיטה אחרת שעובדת עבורך?', 'כשרע, כדאי לחשוב על דברים חיוביים אבל לא תמיד זה מצליח. יש לך שיטה אחרת שעובדת עבורך?', NULL, 'כשרע, כדאי לחשוב על דברים חיוביים אבל לא תמיד זה מצליח. יש לך שיטה אחרת שעובדת עבורך?'),
(1887, 'F1749', 1, 'האם כיום אתה יותר אמפטי כלפי אנשים מאשר פעם, או יותר ביקורתי? ', 'האם כיום את יותר אמפטית כלפי אנשים מאשר פעם, או יותר ביקורתית? ', NULL, 'האם כיום אתה יותר אמפטית כלפי אנשים מאשר פעם, או יותר ביקורתית? '),
(1888, 'F1750', 1, 'נסח מכתב אהבה הכי דביקי בעולם לאהובה הדמיונית שלך', 'נסחי מכתב אהבה הכי דביקי בעולם לאהוב הדמיוני שלך:', NULL, 'נסחי מכתב אהבה הכי דביקי בעולם:'),
(1889, 'F1751', 1, 'כשהיית בזוגיות, עד כמה הרגשת  פתוח לדבר על היחסים הזוגיים שלך עם חברים או משפחה?', 'כשהיית בזוגיות, עד כמה הרגשת  פתוחה לדבר על היחסים הזוגיים שלך עם חברים או משפחה?', NULL, 'כשהיית בזוגיות, עד כמה הרגשת  פתוחה לדבר על היחסים הזוגיים שלך עם חברים או משפחה?'),
(1890, 'F1752', 1, 'האם אתה בדרך כלל מהדברנים, או מהשתקנים?', 'האם את בדרך כלל מהדברנים, או מהשתקנים?', NULL, 'האם אתה בדרך כלל מהדברנים, או מהשתקנים?'),
(1891, 'F1753', 1, 'האם היתה לך מערכת יחסים שבה התקשית לבטוח בה? אם כן, מדוע?', 'האם היתה לך מערכת יחסים שבה התקשית לבטוח בו? אם כן, מדוע?', NULL, 'האם היתה לך מערכת יחסים שבה התקשית לבטוח בובה? אם כן, מדוע?'),
(1892, 'F1754', 1, 'האם אתה בדרך כלל נמנע מקונפליקטים, או שאין לך בעיה להתווכח ולעמוד על שלך?', 'האם את בדרך כלל נמנעת מקונפליקטים, או שאין לך בעיה להתווכח ולעמוד על שלך?', NULL, 'האם אתה בדרך כלל נמנעת מקונפליקטים, או שאין לך בעיה להתווכח ולעמוד על שלך?'),
(1893, 'F1755', 1, 'עד כמה החדר שלך מסודר עכשיו בזה הרגע?', 'עד כמה החדר שלך מסודר עכשיו בזה הרגע?', NULL, 'עד כמה החדר שלך מסודר עכשיו בזה הרגע?'),
(1894, 'F1756', 1, 'שלח קישור (למשל ל-youtube) של שיר שמרגיע אותך', 'שלחי קישור (למשל ל-youtube) של שיר שמרגיע אותך', NULL, 'שלחי קישור (למשל ל-youtube) של שיר שמרגיע אותך'),
(1895, 'F1757', 1, 'עד כמה אתה אוהב ומשחק משחקי ווידאו? אם כן, איזה משחקים אתה הכי אוהב?', 'עד כמה את אוהבת ומשחקת משחקי ווידאו? אם כן, איזה משחקים את הכי אוהבת?', NULL, 'עד כמה אתה אוהבת ומשחקת משחקי ווידאו? אם כן, איזה משחקים אתה הכי אוהבת?'),
(1896, 'F1758', 1, 'במשפט אחד - מהי תכנית 5 השנים שלך?', 'במשפט אחד - מהי תכנית 5 השנים שלך?', NULL, 'במשפט אחד - מהי תכנית 5 השנים שלך?'),
(1897, 'F1759', 1, 'מה תרצה לארוחת בוקר? בורקס? חביתה עם לחם מלא? או אולי מוזלי? או רעיון אחר?', 'תארי את ארוחת הבוקר שלך', NULL, 'תארו את ארוחת הבוקר שלכם'),
(1898, 'F1760', 1, 'ספר על משהו אחד שמגיע לך להיות גאה בו בחייך', 'ספרי על משהו אחד שמגיע לך להיות גאה בו בחייך', NULL, 'ספרי על משהו אחד שמגיע לך להיות גאה בו בחייך'),
(1899, 'F1761', 1, 'האם הקרבת אי פעם הקרבה גדולה מאוד למען מישהו אחר? אם כן, איזו הקרבה ולמי?', 'האם הקרבת אי פעם הקרבה גדולה מאוד למען מישהו אחר? אם כן, איזו הקרבה ולמי?', NULL, 'האם הקרבת אי פעם הקרבה גדולה מאוד למען מישהו אחר? אם כן, איזו הקרבה ולמי?'),
(1900, 'F1762', 1, 'מה דעתך לגבי הריחות הבאים? (כל מילת תואר שעולה לך בראש)', 'מה דעתך לגבי הריחות הבאים? (כל מילת תואר שעולה לך בראש)', NULL, NULL),
(1901, 'F1763', 1, 'פרט (כן, תטרח קצת, לא נורא) את כל זוגות המכנסיים שיש לך בארון, כולל סוג וצבע', 'פרטי (כן, תטרחי קצת, לא נורא) את כל זוגות המכנסיים שיש לך בארון, כולל סוג וצבע', NULL, 'זוגות המכנסיים שיש לך בארון, כולל סוג וצבע'),
(1902, 'F1764', 1, 'כמה זה נכון? (לא נכון, קצת, נכון מאוד וכו\'...) ', 'כמה זה נכון? (לא נכון, קצת, נכון מאוד וכו\'...) ', NULL, NULL),
(1903, 'F1766', 1, 'תאר מקרה שבו כעסת על ביקורת שהעבירו עליך, אבל אחרי זמן הבנת שהביקורת היתה נכונה', 'תארי מקרה שבו כעסת על ביקורת שהעבירו עליך, אבל אחרי זמן הבנת שהביקורת היתה נכונה', NULL, 'תארי מקרה שבו כעסת על ביקורת, אבל אחרי זמן הבנת שהביקורת היתה נכונה'),
(1904, 'F1767', 1, 'האם אתה זוכר מקרה שבו מישהו הוריד לך את הביטחון? מי ועל מה?', 'האם את זוכרת מקרה שבו מישהו הוריד לך את הביטחון? מי ועל מה?', NULL, 'האם אתה זוכרת מקרה שבו מישהו הוריד לך את הביטחון? מי ועל מה?'),
(1905, 'F1768', 1, 'האם יש לך אקסית שאתה חבר שלה בפייסבוק? אם לא, האם יצא לך להציץ בפייסבוק של אקס?', 'האם יש לך אקס שאת חברה שלו בפייסבוק? אם לא, האם יצא לך להציץ בפייסבוק של אקס?', NULL, 'האם יש לך אקסית שאתה חברה שלו בפייסבוק? אם לא, האם יצא לך להציץ בפייסבוק של אקסית?'),
(1906, 'F1769', 1, 'האם חבר או חברה טובים איכזבו אותך פעם? אם כן, במה?', 'האם חבר או חברה טובים איכזבו אותך פעם? אם כן, במה?', NULL, 'האם חבר או חברה טובים איכזבו אותך פעם? אם כן, במה?'),
(1907, 'F1770', 1, 'האם ידוע לך על מישהו שמקנא בך? אם כן, מדוע הוא מקנא?', 'האם ידוע לך על מישהו שמקנא בך? אם כן, מדוע הוא מקנא?', NULL, 'האם ידוע לך על מישהו שמקנא בך? אם כן, מדוע הוא מקנא?'),
(1908, 'F1771', 1, 'האם יצא לך להכיר מישהי בסיטואציה לא רומנטית, ורק אחרי זמן רב (לפחות כמה חודשים) להרגיש לפתע משיכה אליה?', 'האם יצא לך להכיר מישהו בסיטואציה לא רומנטית, ורק אחרי זמן רב (לפחות כמה חודשים) להרגיש לפתע משיכה אליו?', NULL, 'האם יצא לך להכיר מישהוי בסיטואציה לא רומנטית, ורק אחרי זמן רב (לפחות כמה חודשים) להרגיש לפתע משיכה אליוה?'),
(1909, 'F1772', 1, 'עד כמה היית מרגיש בנוח אם לחברה שלך יש ידידים קרובים?', 'עד כמה היית מרגישה בנוח אם לחבר שלך יש ידידות קרובות? ', NULL, 'עד כמה אתה מרגישה בנוח אם לחברה שלך יש ידידות קרובות  ידידים קרובים? '),
(1910, 'F1773', 1, 'מה היתה הפעם האחרונה שבה אמרת למישהו \"מצטער\"?', 'מה היתה הפעם האחרונה שבה אמרת למישהו \"מצטערת\"?', NULL, 'מה היתה הפעם האחרונה שבה אמרת למישהו \"מצטערת\"?'),
(1911, 'F1774', 1, 'האם אתה מרגיש בנוח אם החברה שלך תשמור על קשר עם אקס שלה?', 'האם את מרגישה בנוח עם החבר שלך ישמור על קשר עם אקסית שלו?', NULL, 'האם אתם מרגישים בנוח עם החברה שלכם שומרת על קשר עם אקסיםיות?'),
(1912, 'F1776', 1, 'עד כמה אתה אסרטיבי? קיבלת מנת צהריים לא ממש חמה מהמלצרית. מה תעשה?', 'עד כמה את אסרטיבית? קיבלת מנת צהריים לא ממש חמה מהמלצרית. מה תעשי?', NULL, 'עד כמה אתם אסרטיביים? קיבלתם חביתה לא ממש חמה מהמלצרית. מה תעשו?'),
(1913, 'F1778', 1, 'ספר על פעם שבה עברת על החוק', 'ספרי על פעם שבה עברת על החוק', NULL, 'ספרי על פעם שבה עברת על החוק'),
(1914, 'F1779', 1, 'ספר על מקרה שבו לא עשית את מה שאתה תמיד מטיף לעשות', 'ספרי על מקרה שבו לא עשית את מה שאת תמיד מטיפה לעשות', NULL, 'ספרו על מקרה שבו לא עשיתם את מה שאתם תמיד מטיפים לעשות'),
(1915, 'F1780', 1, 'ספר על משהו יפה שראית היום', 'ספרי על משהו יפה שראית היום', NULL, 'ספרי על משהו יפה שראית היום'),
(1916, 'F1783', 1, 'האם אתה מחליט וחותך מהר, או שאתה נוהג להתלבט הרבה עד שאתה מחליט?', 'האם את מחליטה וחותכת מהר, או שאת נוהגת להתלבט הרבה עד שאת מחליטה?', NULL, 'האם אתם מחליטים מהר, או שאתם נוהגים להתלבט הרבה?'),
(1917, 'F1784', 1, 'נניח שעכשיו 4 בבוקר. אתה ער. מדוע?', 'נניח שעכשיו 4 בבוקר. את ערה. מדוע?', NULL, 'נניח שעכשיו 4 בבוקר. אתה ערה. מדוע?'),
(1918, 'F1785', 1, 'דרג עד כמה אתה אוהב את תחנות הרדיו? (אוהב מאוד, בכלל לא, קצת וכו\'...)', 'דרגי עד כמה את אוהבת את תחנות הרדיו? (אוהבת מאוד, בכלל לא, קצת וכו\'...)', NULL, 'דרגו עד כמה את אוהבים את תחנות הרדיו:'),
(1919, 'F1786', 1, 'אתה צריך לארגן פעילות לדייט הבא שלך. איך נראות לך ההצעות הבאןת? (מעולה, גרוע, ככה ככה, וכו\'...) ', 'את צריכה לארגן פעילות לדייט הבא שלך. איך נראות לך ההצעות הבאות? (מעולה, גרוע, ככה ככה וכו\'...) ', NULL, 'אתם צריכים לארגן פעילות לדייט הבא שלכם'),
(1920, 'F1787', 1, 'איך מכעיסים אותך?', 'איך מכעיסים אותך?', NULL, 'איך מכעיסים אותך?'),
(1921, 'F1788', 1, 'עד כמה אתה מאמץ את הקונספט שאם פגשת מישהי שווה במיוחד, כדאי לנסות לדחות כמה שיותר את הקטע הפיסי ביניכם.', 'עד כמה אתה מאמצת את הקונספט שאם פגשת מישהו שווה במיוחד, כדאי לנסות לדחות כמה שיותר את הקטע הפיסי ביניכם.', NULL, 'עד כמה אתה מאמצת את הקונספט שאם פגשת מישהוהי שווה במיוחד, כדאי לנסות לדחות כמה שיותר את הקטע הפיסי ביניכם.'),
(1922, 'F1789', 1, 'האם לגור עם ההורים זה לא בא בחשבון, או שזה דווא יכול להתאים לפעמים כדי לחסוך כסף?', 'האם לגור עם ההורים זה לא בא בחשבון, או שזה דווא יכול להתאים לפעמים כדי לחסוך כסף?', NULL, 'האם לגור עם ההורים זה לא בא בחשבון, או שזה דווא יכול להתאים לפעמים כדי לחסוך כסף?'),
(1923, 'F1790', 1, 'אתה מלצר במסעדה, יש מצב שתאכל מתוך צלחת שלקוח השאיר ולא סיים הכל? ', 'את מלצרית במסעדה, יש מצב שתאכלי מתוך צלחת שלקוח השאיר ולא סיים הכל? ', NULL, 'אתה מלצרית במסעדה, יש מצב שתאכלי מתוך צלחת שלקוח השאיר ולא סיים הכל? '),
(1924, 'F1791', 1, 'פגשת מישהי נדירה וזה נראה רציני. מיהם שלושת הראשונים שתספר להם על כך?', 'פגשת מישהו נדיר וזה נראה רציני. מיהם שלושת הראשונים שתספרי להם על כך?', NULL, 'פגשת מישהוי נדיר וזה נראה רציני. מיהם שלושת הראשונים שתספרי להם על כך?'),
(1925, 'F1792', 1, 'מה התכניות שלך למחר?', 'מה התכניות שלך למחר?', NULL, 'מה התכניות שלך למחר?'),
(1926, 'F1793', 1, 'האם יצא לך להודות שטעית, גם אם חשבת שבכלל לא טעית, רק כדי לסיים באווירה טובה  ויכוח עם אישה? עם מי זה היה?', 'האם יצא לך להודות שטעית, גם אם חשבת שבכלל לא טעית, רק כדי לסיים באווירה טובה ויכוח עם גבר? עם מי זה היה.', NULL, 'האם יצא לך להודות שטעית, גם אם חשבת שבכלל לא טעית, רק כדי לסיים באווירה טובה ויכוח עם גבראישה?'),
(1927, 'F1794', 1, 'האם אתה נוהג לאגור חפצים מהעבר, או שאתה מעדיף לזרוק כמה שיותר?', 'האם את נוהגת לאגור חפצים מהעבר, או שאת מעדיפה לזרוק כמה שיותר?', NULL, 'האם אתם נוהגים לאגור חפצים מהעבר, או שאתם מעדיפים לזרוק כמה שיותר?'),
(1928, 'F1795', 1, 'עם מי ואיך חגגת את יום ההולדת האחרון שלך?', 'עם מי ואיך חגגת את יום ההולדת האחרון שלך?', NULL, 'עם מי ואיך חגגת את יום ההולדת האחרון שלך?'),
(1929, 'F1796', 1, 'ממה הופתעת מאוד בזמן האחרון?', 'ממה הופתעת מאוד בזמן האחרון?', NULL, 'ממה הופתעת מאוד בזמן האחרון?'),
(1930, 'F1797', 1, 'באיזה מקרה לאחרונה העדפת לסתום את הפה, למרות שהיה לך הרבה מה להגיד? ', 'באיזה מקרה לאחרונה העדפת לסתום את הפה, למרות שהיה לך הרבה מה להגיד? ', NULL, 'באיזה מקרה לאחרונה העדפת לסתום את הפה, למרות שהיה לך הרבה מה להגיד? '),
(1931, 'F1798', 1, 'איך אתה מתנהל עם כספים? (בכלל לא, תמיד, לפעמים, וכו\'...) ', 'איך את מתנהלת עם כספים? (בכלל לא, תמיד, לפעמים, וכו\'...) ', NULL, 'איך אתה מתנהלת עם כספים? '),
(1932, 'F1799', 1, 'עד כמה אתה מפונק? (בכלל לא, הרבה, קצת, וכו\'...)', 'עד כמה את מפונקת? (בכלל לא, הרבה, קצת, וכו\'...)', NULL, 'עד כמה אתה מפונקת? '),
(1933, 'F1800', 1, 'מה האתגר שלך לשבוע הקרוב?', 'מה האתגר שלך לשבוע הקרוב?', NULL, 'מה האתגר שלך לשבוע הקרוב?'),
(1934, 'F1801', 1, 'איזה ג\'אנקפוד אתה אוהב? (בכלל לא, מאוד, קצת, וכו\'...) ', 'איזה ג\'אנקפוד את אוהבת? (בכלל לא, מאוד, קצת, וכו\'...) ', NULL, 'איזה ג\'אנקפוד אתם אוהבים?  '),
(1935, 'F1802', 1, 'איזה ג\'אנקפוד אתה אוהב? (בכלל לא, מאוד, קצת, וכו\'...) ', 'איזה ג\'אנקפוד את אוהבת? (בכלל לא, מאוד, קצת, וכו\'...) ', NULL, 'איזה ג\'אנקפוד אתם אוהבים? '),
(1936, 'F1803', 1, 'הרכב לעצמך פיצה חלומית גורמה', 'הרכיבי לעצמך פיצה חלומית גורמה', NULL, 'הרכיבו לעצמכם פיצה חלומית גורמה'),
(1937, 'F1804', 1, 'יש לך כסף לשני טיפולי מניקור פדיקור, או שני ג\'ינסים, או טלפון סלולרי סיני. במה תבחר? (מותר לך לבקש משהו אחר שעלותו דומה)', 'יש לך כסף לשני טיפולי מניקור פדיקור, או שני ג\'ינסים, או טלפון סלולרי סיני. במה תבחרי? (מותר לך לבקש משהו אחר שעלותו דומה)', NULL, 'יש לך כסף לשני טיפולי מניקור פדיקור, או שני ג\'ינסים, או טלפון סלולרי סיני. במה תבחרי? (מותר לך לבקש משהו אחר שעלותו דומה)'),
(1938, 'F1805', 1, 'מה אתה יודע לעשות? (בכלל לא, בוודאי, קצת, וכו\'...) ', 'מה את יודעת לעשות? (בכלל לא, בוודאי, קצת, וכו\'...) ', NULL, NULL),
(1939, 'F1807', 1, 'איזה שיר תשיר במקלחת הקרובה שלך?', 'איזה שיר תשירי במקלחת הקרובה שלך?', NULL, 'איזה שיר תשירי במקלחת הקרובה שלך?'),
(1940, 'F1808', 1, 'עד כמה תאהב לקבל את המחמאות הבאות מאישה: (אוי ואבוי, מממ... יאמי, קצת, וכו\'...) ', 'עד כמה תאהבי לקבל את המחמאות הבאות מגבר: (אוי ואבוי, מממ... יאמי, קצת, וכו\'...) ', NULL, 'עד כמה תאהבי לקבל את המחמאות הבאות מגבראישה: '),
(1941, 'F1809', 1, 'עד כמה תאהב לקבל את המחמאות הבאות מאישה: (אוי ואבוי, מממ... יאמי, קצת, וכו\'...) ', 'עד כמה תאהבי לקבל את המחמאות הבאות מגבר: (אוי ואבוי, מממ... יאמי, קצת, וכו\'...) ', NULL, 'עד כמה תאהבי לקבל את המחמאות הבאות מגבראישה: '),
(1942, 'F1810', 1, 'עד כמה תסכים להיות בן זוג של: (לא בא בחשבון, אולי, בכיף, וכו\'...) ', 'עד כמה תסכימי להיות בת זוג של: (לא בא בחשבון, אולי, בכיף, וכו\'...) ', NULL, 'עד כמה תסכימו להיות בניבנות זוג של:'),
(1943, 'F1811', 1, 'החבר שלך מודיע לך שהוא מתכוון לנסוע לכנס מקצועי (עם הרבה נשים שעובדות איתו), שם כולם יכנסו גם לבריכה וג\'קוזי. מה תגובתך?', 'החברה שלך מודיעה לך שהיא מתכוונת לנסוע לכנס מקצועי (עם הרבה גברים שעובדים איתה), שם כולם יכנסו גם לבריכה וג\'קוזי. מה תגובתך?', NULL, 'החברה שלך מודיעה לך שהיאהוא מתכוונת לנסוע לכנס מקצועי (עם הרבה גברים נשיםשעובדים איתוה), שם כולם יכנסו גם לבריכה וג\'קוזי. מה תגובתך?'),
(1944, 'F1812', 1, 'עד כמה המקצועות הבאים מיותרים בעיניך, (מיותר לגמרי, לא מיותר, אולי, וכו\'..) הוסף מקצוע שלדעתך גם הוא מיותר:', 'עד כמה המקצועות הבאים מיותרים בעיניך, (מיותר לגמרי, לא מיותר, אולי, וכו\'..) הוסיפי מקצוע שלדעתך גם הוא מיותר:', NULL, 'עד כמה המקצועות הבאים מיותרים בעיניך?'),
(1945, 'F1813', 1, 'עד כמה חלומות יכולים לחזות את העתיד, או מנבאים את התשוקות הפנימיות שלנו? מה דעתך?', 'עד כמה חלומות יכולים לחזות את העתיד, או מנבאים את התשוקות הפנימיות שלנו? מה דעתך?', NULL, 'עד כמה חלומות יכולים לחזות את העתיד, או מנבאים את התשוקות הפנימיות שלנו? מה דעתך?'),
(1946, 'F1814', 1, 'נסה להעריך כמה כסף הוצאת בשנה האחרונה על מוצרי טיפוח? (אפטרשייב, בושם, קרמים וכו\')', 'נסי להעריך כמה כסף הוצאת בשנה האחרונה על מוצרי טיפוח? (איפור, בושם, קרמים וכו\')', NULL, 'נסהי להעריך כמה כסף הוצאת בשנה האחרונה על מוצרי טיפוח? (איפור, בושם, קרמים וכו\')'),
(1947, 'F1815', 1, 'ספר על משהו מיותר לגמרי שעשית בחיים שלך, שהיה סתם בזבוז זמן', 'ספרי על משהו מיותר לגמרי שעשית בחיים שלך, שהיה סתם בזבוז זמן', NULL, 'ספרי על משהו מיותר לגמרי שעשית בחיים שלך, שהיה סתם בזבוז זמן'),
(1948, 'F1816', 1, 'ליד איזה אנשים אתה מרגיש הכי רגוע ושלא שופטים אותך? (ספר על 2-3) ', 'ליד איזה אנשים את מרגישה הכי רגועה ושלא שופטים אותך? (ספרי על 2-3) ', NULL, 'ליד איזה אנשים אתם מרגישים הכי רגועים ושלא שופטים אתכם? (ספרו על 2-3) '),
(1949, 'F1817', 1, 'האם אתה מדמיין מצב שבו תוותר על מעבר לחו\"ל לקידום בקריירה, בגלל אהבה? האם קרה לך?', 'האם את מדמיינת מצב שבו תוותרי על מעבר לחו\"ל לקידום בקריירה, בגלל אהבה? האם קרה לך?', NULL, 'האם אתם מדמיינים מצב שבו תוותרו על מעבר לחו\"ל לקידום בקריירה, בגלל אהבה? האם קרה לכם?'),
(1950, 'F1818', 1, 'למה החיים שלך יפים?', 'למה החיים שלך יפים?', NULL, 'למה החיים שלך יפים?'),
(1951, 'F1819', 1, 'השלים', 'השלימי', NULL, 'השלימו:'),
(1952, 'F1820', 1, 'במה לא מבינים אותך, וזה מתסכל אותך?', 'במה לא מבינים אותך, וזה מתסכל אותך?', NULL, 'במה לא מבינים אותך, וזה מתסכל אותך?'),
(1953, 'F1821', 1, 'מה יושב לך על הלב עכשיו?', 'מה יושב לך על הלב עכשיו?', NULL, 'מה יושב לך על הלב עכשיו?'),
(1954, 'F1823', 1, 'תאר הרגל יומיומי שמרגיע אותך', 'תארי הרגל יומיומי שמרגיע אותך', NULL, 'תארי הרגל יומיומי שמרגיע אותך'),
(1955, 'F1824', 1, 'איזו רמת יכולת ריכוז יש לך? עד כמה קל להסיח את דעתך?', 'איזו רמת יכולת ריכוז יש לך? עד כמה קל להסיח את דעתך?', 'png-transparent-computer-icons-online-chat-livechat-chat-miscellaneous-angle-text-thumbnail - Copy (3).png', 'איזו רמת יכולת ריכוז יש לך? עד כמה קל להסיח את דעתך?'),
(1956, 'F1825', 1, 'עד כמה חשובות לך המטרות הבאות? (מאוד, בכלל לא, קצת, וכו\'...)', 'עד כמה חשובות לך המטרות הבאות? (מאוד, בכלל לא, קצת, וכו\'...)', NULL, 'עד כמה חשובות לך המטרות הבאות?'),
(1957, 'F1826', 1, 'עד כמה חשובות לך המטרות הבאות? (מאוד, בכלל לא, קצת, וכו\'...)', 'עד כמה חשובות לך המטרות הבאות? (מאוד, בכלל לא, קצת, וכו\'...)', NULL, 'עד כמה חשובות לך המטרות הבאות?'),
(1958, 'F1827', 1, 'תאר מקרה בו פישלת (למשל, היית צריך לשמור על כלב של חבר, והוא ברח)', 'תארי מקרה בו פישלת (למשל, היית צריכה לשמור על כלב של חבר, והוא ברח)', NULL, 'תארי מקרה בו פישלת (למשל, היית צריכה לשמור על כלב של חבר, והוא ברח)'),
(1959, 'F1828', 1, 'עד כמה נכונים בעיניך המשפטים הבאים: (מאוד, בכלל לא, קצת וכו\'...)', 'עד כמה נכונים בעיניך המשפטים הבאים: (מאוד, בכלל לא, קצת וכו\'...)', NULL, NULL),
(1960, 'F1829', 1, 'עד כמה נכונים בעיניך המשפטים הבאים: (מאוד, בכלל לא, קצת וכו\'...)', 'עד כמה נכונים בעיניך המשפטים הבאים: (מאוד, בכלל לא, קצת וכו\'...)', NULL, NULL),
(1961, 'P1001', 1, 'מה תלבש לדייט? הנח את בגדים על משטח וצלם', 'מה תלבשי לדייט? הניחי את בגדים על משטח וצלמי.', NULL, 'לבוש לדייט'),
(1962, 'P1002', 1, 'צלם את הספר שהיית שם על השולחן כדי שיחשבו שאתה אינטלקטואל', 'צלמי את הספר שהיית שמה על השולחן כדי שיחשבו שאת אינטלקטואלית.', NULL, 'ספר אינטלקטואלי'),
(1963, 'P1003', 1, 'ההורים באים לביקור פתע! צלם את מה שהיית מעלים מהשטח מיידית.', 'ההורים באים לביקור פתע! צלמי את מה שהיית מעלימה מהשטח מיידית.', NULL, 'להעלים דחוף כשההורים באים'),
(1964, 'P1004', 1, 'צלם מתנה גרועה שאתה שונא, אבל שומר משום מה.', 'צלמי מתנה גרועה שאת שונאת, אבל שומרת משום מה.', NULL, 'מתנה גרועה  '),
(1965, 'P1005', 1, 'צלם את פנים ארון הבגדים שלך. ', 'צלמי את פנים ארון הבגדים שלך. ', NULL, 'ארון הבגדים'),
(1966, 'P1006', 1, 'צלם את הנעליים הכי שוות שלך', 'צלמי את הנעליים הכי שוות שלך', NULL, 'נעליים הכי שוות'),
(1967, 'P1007', 1, 'צלם את הנעליים הכי מע\'פנות שלך. ', 'צלמי את הנעליים הכי מע\'פנות שלך. ', NULL, 'נעליים הכי מע\'פנות'),
(1968, 'P1008', 1, 'צלם את כיור המטבח כפי שהוא נראה כרגע. ', 'צלמי את כיור המטבח כפי שהוא נראה כרגע. ', NULL, 'כיור המטבח'),
(1969, 'P1009', 1, 'צלם חפץ בדירה שלך שהיית תורם ללא היסוס.', 'צלמי חפץ בדירה שלך שהיית תורמת ללא היסוס.', NULL, 'חפץ לתרומה'),
(1970, 'P1010', 1, 'צלם משהו שיתאר את המצב רוח שלך בזה הרגע. ', 'צלמי משהו שיתאר את המצב רוח שלך בזה הרגע. ', NULL, 'מצב הרוח בזה הרגע'),
(1971, 'P1011', 1, 'צלם את שולחן העבודה שלך.', 'צלמי את שולחן העבודה שלך.', NULL, 'שולחן העבודה'),
(1972, 'P1012', 1, 'צלם את מדף המקרר שלך.', 'צלמי את מדף המקרר שלך.', NULL, 'מדף המקרר'),
(1973, 'P1013', 1, 'צלם את כף היד שלך', 'צלמי את כף היד שלך', NULL, 'כף היד'),
(1974, 'P1014', 1, 'נניח שתקבל מיליון דולר במזומן, צלם את המקום בו היית מחביא אותם בדירה', 'נניח שתקבלי מיליון דולר במזומן, צלמי את המקום בו היית מחביאה אותם בדירה.', NULL, 'להחביא מיליון דולר'),
(1975, 'P1015', 1, 'צלם בגד שהיית צריך לזרוק מזמן. ', 'צלמי בגד שהיית צריכה לזרוק מזמן. ', NULL, 'בגד לזריקה'),
(1976, 'P1016', 1, 'צלם את מדף הספרים שלך (או חלק ממנו), באופן שאפשר יהיה לזהות את כותרי הספרים. ', 'צלמי את מדף הספרים שלך (או חלק ממנו), באופן שאפשר יהיה לזהות את כותרי הספרים. ', NULL, 'מדף הספרים'),
(1977, 'P1017', 1, 'שלח צילום מסך של מסך הבית בטלפון שלך ', 'שלחי צילום מסך של מסך הבית בטלפון שלך', NULL, 'מסך הבית בטלפון'),
(1978, 'P1018', 1, 'צלם את המיטה בה אתה ישן. ', 'צלמי את המיטה בה את ישנה. ', NULL, 'מיטה'),
(1979, 'P1019', 1, 'צלם את משקפי השמש שלך.', 'צלמי את משקפי השמש שלך.', NULL, 'משקפי השמש'),
(1980, 'P1020', 1, 'צלם את השמפו ואו את הסבון בהם אתה משתמש. ', 'צלמי את השמפו ואו את הסבון איתם את משתמשת. ', NULL, 'שמפו'),
(1981, 'P1021', 1, 'אם אם תיתן את המיטה שלך לאורח בלילה, צלם את המקום בבית שבו אתה תישן. ', 'אם אם תיתני את המיטה שלך לאורח בלילה, צלמי את המקום בבית שבו את תישני. ', NULL, 'מקום לישון כשיש אורחים'),
(1982, 'P1022', 1, 'צלם משהו כחול', 'צלמי משהו כחול', NULL, 'משהו כחול'),
(1983, 'P1023', 1, 'צלם משהו אדום', 'צלמי משהו אדום', NULL, 'משהו אדום'),
(1984, 'P1024', 1, 'צלם משהו צהוב', 'צלמי משהו צהוב', NULL, 'משהו צהוב'),
(1985, 'P1025', 1, 'צלם משהו שחור', 'צלמי משהו שחור', NULL, 'משהו שחור'),
(1986, 'P1026', 1, 'צלם משהו לבן', 'צלמי משהו לבן', NULL, 'משהו לבן'),
(1987, 'P1027', 1, 'צלם משהו ירוק', 'צלמי משהו ירוק', NULL, 'משהו ירוק'),
(1988, 'P1028', 1, 'צייר אישה על דף נייר, צלם ושלח. ', 'ציירי על דף נייר אישה, צלמי ושלחי. ', NULL, 'ציור של אישה'),
(1989, 'P1029', 1, 'כתוב על דף נייר משפט כלשהו, צלם ושלח', 'כתבי על דף נייר משפט כלשהו, צלמי ושלחי', NULL, 'כתב יד'),
(1990, 'P1030', 1, 'צייר בית על דף נייר, צלם ושלח', 'ציירי על דף נייר בית, צלמי ושלחי', NULL, 'ציור של בית'),
(1991, 'P1031', 1, 'צייר על דף נייר פרצוף מחייך סמיילי, צלם ושלח', 'ציירי על דף נייר פרצוף מחייך סמיילי, צלמי ושלחי', NULL, 'פרצוף סמיילי'),
(1992, 'P1032', 1, 'שלח תמונה כלשהי מהגלריה (מבלי לחשוף שום דבר לא רצוי, כמובן)', 'שלחי תמונה כלשהי מהגלריה (מבלי לחשוף שום דבר לא רצוי, כמובן)', NULL, 'תמונה מהגלריה'),
(1993, 'P1033', 1, 'צלם משהו מהמקום בו אתה נמצא עכשיו', 'צלמי משהו מהמקום בו את נמצאת עכשיו', NULL, 'המקום בו אני נמצאת עכשיו'),
(1994, 'P1034', 1, 'צלם את כוס הקפה שלך', 'צלמי את כוס הקפה שלך', NULL, 'כוס הקפה'),
(1995, 'P1035', 1, 'צלם את ארוחת הבוקר שלך', 'צלמי את ארוחת הבוקר שלך', NULL, 'ארוחת הבוקר'),
(1996, 'P1036', 1, 'אתה יוצא מהבית לרחוב - צלם את מה שאתה רואה', 'את יוצאת מהבית לרחוב - צלמי את מה שאת רואה', NULL, 'הרחוב ליד הבית'),
(1997, 'P1037', 1, 'צלם רהיט בבית שלך', 'צלמי רהיט בבית שלך', NULL, 'רהיט'),
(1998, 'P1038', 1, 'צלם קישוט על הקיר בחדר שלך', 'צלמי קישוט על הקיר בחדר שלך', NULL, 'קישוט על הקיר'),
(1999, 'P1039', 1, 'הסתכל מהחלון בדירהבית - צלם מה שאתה רואה', 'הסתכלי מהחלון בדירהבית - צלמי מה שאת רואה', NULL, 'מה שרואים מהחלון'),
(2000, 'P1040', 1, 'צלם אחד מהתמרוקים שלך (גילוח, דיאודורנט, וכו\'...)', 'צלמי אחד מהתמרוקים שלך ', NULL, 'תמרוקים'),
(2001, 'P1041', 1, 'פתח מגירה וצלם את מה שבפנים', 'פתחי מגירה וצלמי את מה שבפנים', NULL, 'פנים המגירה'),
(2002, 'P1042', 1, 'צלם חפץ בבית שאתה נוהג להעביר איתו זמן פנוי', 'צלמי חפץ בבית שאת נוהגת להעביר איתו זמן פנוי', NULL, 'חפץ לזמן פנוי'),
(2003, 'P1043', 1, 'צלם זו גרביים נקיות שלך', 'צלמי זוג גרביים נקיות שלך', NULL, 'זוג גרביים'),
(2004, 'P1044', 1, 'צלם חפץ שאיתו אתה מתקן דברים', 'צלמי חפץ שאיתו את מתקנת דברים', NULL, 'חפץ לתיקון דברים'),
(2005, 'P1045', 1, 'צלם מכנסיים קצרות שלך', 'צלמי מכנסיים קצרותחצאית שלך', NULL, 'מכנסיים קצרותחצאית'),
(2006, 'P1046', 1, 'צלם מכנסיים ארוכות שלך', 'צלמי מכנסיים ארוכותשמלה שלך', NULL, 'מכנסיים ארוכותשמלה'),
(2007, 'P1047', 1, 'צלם חולצת יום יום שלך', 'צלמי חולצת יום יום שלך', NULL, 'חולצת יום יום'),
(2008, 'P1048', 1, 'צלם נעלי ספורט שלך', 'צלמי נעלי ספורט שלך', NULL, 'נעלי ספורט'),
(2009, 'P1049', 1, 'צלם משהו לאכול שאתה מנשנש כשאתה במצב רוח רע', 'צלמי משהו לאכול שאת מנשנשת כשאת במצב רוח רע', NULL, 'נשנוש למצב רוח רע'),
(2010, 'P1050', 1, 'אם יש לך קעקוע איפשהו על הגוף, צלם אותו, אם לא, צלם איפה שהיית שם קעקוע בגוף ', 'אם יש לך קעקוע איפשהו על הגוף, צלמי אותו. אם לא, צלמי איפה היית שמה קעקוע בגוף', NULL, 'קעקוע'),
(2013, 'F1830', 1, 'אתה רוצה להיפרד מהחברה שלך, ואתה חייב לעשות זאת ב-SMS. השלם:', 'את רוצה להיפרד מהחבר שלך ואת חייבת לעשות זאת ב-SMS. השלימי:', NULL, 'אתם רוצים להיפרד מהחברה, ואתם חייבים לעשות זאת ב SM-. השלימו:'),
(2014, 'F1831', 1, 'אתה רוצה להיפרד מהחברה שלך, ואתה חייב לעשות זאת ב-SMS. השלם:', 'את רוצה להיפרד מהחבר שלך ואת חייבת לעשות זאת ב-SMS. השלימי:', NULL, 'אתם רוצים להיפרד מהחברה, ואתם חייבים לעשות זאת ב SM-. השלימו:'),
(2015, 'F1832', 1, 'אתה רוצה להיפרד מהחברה שלך, ואתה חייב לעשות זאת ב-SMS. השלם:', 'את רוצה להיפרד מהחבר שלך ואת חייבת לעשות זאת ב-SMS. השלימי:', NULL, 'אתם רוצים להיפרד מהחברה, ואתם חייבים לעשות זאת ב SM-. השלימו:');

-- --------------------------------------------------------

--
-- Table structure for table `net_tasktype`
--

CREATE TABLE `net_tasktype` (
  `Id` int(11) NOT NULL,
  `Description` varchar(1024) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `net_tasktype`
--

INSERT INTO `net_tasktype` (`Id`, `Description`) VALUES
(1, 'Q-2'),
(2, 'Q-3'),
(3, 'Q-4'),
(4, 'Photo'),
(5, 'Video'),
(6, 'Fill text'),
(14, 'Q Chain'),
(15, 'Voice');

-- --------------------------------------------------------

--
-- Table structure for table `net_textinmultilanguages`
--

CREATE TABLE `net_textinmultilanguages` (
  `Id` int(11) NOT NULL,
  `TextId` int(11) DEFAULT NULL,
  `text` longtext,
  `LanguageId` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `net_textinmultilanguages`
--

INSERT INTO `net_textinmultilanguages` (`Id`, `TextId`, `text`, `LanguageId`) VALUES
(1, 1, '%3Chtml%3E%0A%3Chead%3E%0A%09%3Ctitle%3E%3C%2Ftitle%3E%0A%3C%2Fhead%3E%0A%3Cbody%3E%0A%3Cp%3E%D7%94%D7%9E%D7%A9%D7%97%D7%A7%20%D7%94%D7%A1%D7%AA%D7%99%D7%99%D7%9D%3C%2Fp%3E%0A%3C%2Fbody%3E%0A%3C%2Fhtml%3E%0A', 1),
(2, 1, '%3Chtml%3E%0A%3Chead%3E%0A%09%3Ctitle%3E%3C%2Ftitle%3E%0A%3C%2Fhead%3E%0A%3Cbody%3E%0A%3Cp%3EGame%20ended!!%3C%2Fp%3E%0A%3C%2Fbody%3E%0A%3C%2Fhtml%3E%0A', 2),
(3, 1, 'End Game', 3),
(4, 1, 'End Game', 4),
(5, 2, '%3Chtml%3E%0A%3Chead%3E%0A%09%3Ctitle%3E%3C%2Ftitle%3E%0A%3C%2Fhead%3E%0A%3Cbody%3E%0A%3Cp%3E%3F%D7%94%D7%90%D7%9D%20%D7%9C%D7%94%D7%9E%D7%A9%D7%99%D7%9A%20%D7%9C%D7%9E%D7%A9%D7%97%D7%A7%20%D7%A0%D7%95%D7%A1%D7%A3%3C%2Fp%3E%0A%3C%2Fbody%3E%0A%3C%2Fhtml%3E%0A', 1),
(6, 2, 'Do you want to continue playing with your partner?', 2),
(7, 2, 'Do you want to continue playing with your partner?', 3),
(8, 2, 'Do you want to continue playing with your partner?', 4),
(9, 3, '%3Chtml%3E%0A%3Chead%3E%0A%09%3Ctitle%3E%3C%2Ftitle%3E%0A%3C%2Fhead%3E%0A%3Cbody%3E%0A%3Cp%3EYour%20account%20has%20been%20%3Cstrong%3Edisabled%3C%2Fstrong%3E.%20pay%20via%26nbsp%3B%3Ca%20href%3D%22http%3A%2F%2Fwww.;ogle.com%22%3Ewww.;ogle.com%3C%2Fa%3E%26nbsp%3B%20HEB%3C%2Fp%3E%0A%3C%2Fbody%3E%0A%3C%2Fhtml%3E%0A', 1),
(10, 3, '%3Chtml%3E%0A%3Chead%3E%0A%09%3Ctitle%3E%3C%2Ftitle%3E%0A%3C%2Fhead%3E%0A%3Cbody%3E%0A%3Cp%3EYour%20account%20has%20been%20%3Cspan%20style%3D%22color%3A%23e74c3c%22%3E%3Cstrong%3Edisabled%3C%2Fstrong%3E%3C%2Fspan%3E.%20Pay%20via%26nbsp%3B%3Ca%20href%3D%22http%3A%2F%2Fwww.;ogle.com%22%3Ewww.;ogle.com%3C%2Fa%3E%20ENG%3C%2Fp%3E%0A%3C%2Fbody%3E%0A%3C%2Fhtml%3E%0A', 2),
(11, 3, 'Your account has been disabled.', 3),
(12, 3, 'Your account has been disabled.', 4),
(1009, 1003, '%3Chtml%3E%0A%3Chead%3E%0A%09%3Ctitle%3E%3C%2Ftitle%3E%0A%3C%2Fhead%3E%0A%3Cbody%3E%0A%3Cp%3EYou%20have%20reached%20the%20daily%20quota.%20Try%20again%20tomorrow%20HEB%3C%2Fp%3E%0A%3C%2Fbody%3E%0A%3C%2Fhtml%3E%0A', 1),
(1010, 1003, '%3Chtml%3E%0A%3Chead%3E%0A%09%3Ctitle%3E%3C%2Ftitle%3E%0A%3C%2Fhead%3E%0A%3Cbody%3E%0A%3Cp%3EYou%20have%20reached%20the%20daily%20quota.%20Try%20again%20tomorrow%3C%2Fp%3E%0A%3C%2Fbody%3E%0A%3C%2Fhtml%3E%0A', 2),
(1011, 1003, 'You have reached the daily quota. Try again tomorrow', 3),
(1012, 1003, 'You have reached the daily quota. Try again tomorrow', 4),
(1013, 1004, '%3Chtml%3E%0A%3Chead%3E%0A%09%3Ctitle%3E%3C%2Ftitle%3E%0A%3C%2Fhead%3E%0A%3Cbody%3E%0A%3Cp%3E%D7%9C%D7%97%D7%A6%2F%D7%99%20%D7%9B%D7%90%D7%9F%20%D7%91%D7%A9%D7%91%D7%99%D7%9C%20%D7%9C%D7%94%D7%96%D7%9E%D7%99%D7%9F%20%D7%A4%D7%A8%D7%98%D7%A0%D7%A8%20%D7%9C%D7%9E%D7%A9%D7%97%D7%A7%3C%2Fp%3E%0A%3C%2Fbody%3E%0A%3C%2Fhtml%3E%0A', 1),
(1014, 1004, 'Click here to invite more friends to play together', 2),
(1015, 1004, 'Click here to invite more friends to play together', 3),
(1016, 1004, 'Click here to invite more friends to play together', 4),
(1017, 1005, '%3Chtml%3E%0A%3Chead%3E%0A%09%3Ctitle%3E%3C%2Ftitle%3E%0A%3C%2Fhead%3E%0A%3Cbody%3E%0A%3Cp%3E%D7%91%D7%A0%D7%99%20%D7%94%D7%96%D7%95%D7%92%20%D7%A9%D7%94%D7%95%D7%AA%D7%90%D7%9E%D7%95%20%D7%A2%D7%9C%20%D7%99%D7%93%D7%99%20%D7%94%D7%9E%D7%A2%D7%A8%D7%9B%D7%AA%3C%2Fp%3E%0A%3C%2Fbody%3E%0A%3C%2Fhtml%3E%0A', 1),
(1018, 1005, '%3Chtml%3E%0A%3Chead%3E%0A%09%3Ctitle%3E%3C%2Ftitle%3E%0A%3C%2Fhead%3E%0A%3Cbody%3E%0A%3Cp%3EHere%20are%20your%20current%20partners%20assigned%20by%20the%20system%3C%2Fp%3E%0A%3C%2Fbody%3E%0A%3C%2Fhtml%3E%0A', 2),
(1019, 1005, '%3Chtml%3E%0A%3Chead%3E%0A%09%3Ctitle%3E%3C%2Ftitle%3E%0A%3C%2Fhead%3E%0A%3Cbody%3E%0A%3Cp%3EHere%20are%20your%20current%20partners%20assigned%20by%20the%20system%3C%2Fp%3E%0A%3C%2Fbody%3E%0A%3C%2Fhtml%3E%0A', 3),
(1020, 1005, '%3Chtml%3E%0A%3Chead%3E%0A%09%3Ctitle%3E%3C%2Ftitle%3E%0A%3C%2Fhead%3E%0A%3Cbody%3E%0A%3Cp%3EHere%20are%20your%20current%20partners%20assigned%20by%20the%20system%3C%2Fp%3E%0A%3C%2Fbody%3E%0A%3C%2Fhtml%3E%0A', 4),
(1021, 1006, '%3Chtml%3E%0A%3Chead%3E%0A%09%3Ctitle%3E%3C%2Ftitle%3E%0A%3C%2Fhead%3E%0A%3Cbody%3E%0A%3Cp%3E%D7%A9%D7%9C%D7%99%D7%97%D7%AA%20%D7%94%D7%95%D7%93%D7%A2%D7%95%D7%AA%20%D7%A6%26%2339%3B%D7%90%D7%98%3C%2Fp%3E%0A%3C%2Fbody%3E%0A%3C%2Fhtml%3E%0A', 1),
(1022, 1006, 'This is for typing and sending messages', 2),
(1023, 1006, 'This is for typing and sending messages', 3),
(1024, 1006, 'This is for typing and sending messages', 4),
(1025, 1007, '%3Chtml%3E%0A%3Chead%3E%0A%09%3Ctitle%3E%3C%2Ftitle%3E%0A%3C%2Fhead%3E%0A%3Cbody%3E%0A%3Cp%3E%D7%9C%D7%97%D7%A6%2F%D7%99%20%D7%9C%D7%94%D7%AA%D7%97%D7%9C%D7%AA%20%D7%94%D7%9E%D7%A9%D7%97%D7%A7%3C%2Fp%3E%0A%3C%2Fbody%3E%0A%3C%2Fhtml%3E%0A', 1),
(1026, 1007, 'Click here to start playing with your partner', 2),
(1027, 1007, 'Click here to start playing with your partner', 3),
(1028, 1007, 'Click here to start playing with your partner', 4),
(1029, 1008, '%3Chtml%3E%0A%3Chead%3E%0A%09%3Ctitle%3E%3C%2Ftitle%3E%0A%3C%2Fhead%3E%0A%3Cbody%3E%0A%3Cp%3E%3Cspan%20style%3D%22color%3A%23e74c3c%22%3E%3Cstrong%3E%D7%9C%D7%97%D7%A6%2F%D7%99%20%D7%9B%D7%90%D7%9F%20%D7%91%D7%A9%D7%91%D7%99%D7%9C%3C%2Fstrong%3E%3C%2Fspan%3E%20%D7%9C%D7%A9%D7%97%D7%A7%20%3Cspan%20style%3D%22background-color%3A%23f1c40f%22%3E%D7%A2%D7%9D%20%D7%A4%D7%A8%D7%98%D7%A0%D7%A8%20%D7%97%D7%93%D7%A9%3C%2Fspan%3E%3C%2Fp%3E%0A%3C%2Fbody%3E%0A%3C%2Fhtml%3E%0A', 1),
(1030, 1008, 'Click here to play with the most suitable player', 2),
(1031, 1008, 'Click here to play with the most suitable player', 3),
(1032, 1008, 'Click here to play with the most suitable player', 4),
(1033, 1009, '%3Chtml%3E%0A%3Chead%3E%0A%09%3Ctitle%3E%3C%2Ftitle%3E%0A%3C%2Fhead%3E%0A%3Cbody%3E%0A%3Cp%3E%D7%A9%D7%9C%D7%95%D7%9D%20%D7%A9%D7%9C%D7%95%D7%9D%3C%2Fp%3E%0A%0A%3Cp%3E%3Cspan%20style%3D%22font-family%3AArial%2CHelvetica%2Csans-serif%22%3E%3Cstrong%3EWelcome%20to%20Play%20with%20Me!%3C%2Fstrong%3E%20%F0%9F%8C%9F%3Cbr%20%2F%3E%0AYour%20journey%20to%20meaningful%20connections%20starts%20here.%20Whether%20you%26%2339%3Bre%20looking%20for%20love%2C%20friendship%2C%20or%20just%20great%20conversations%2C%20you%26%2339%3Bve%20come%20to%20the%20right%20place.%3C%2Fspan%3E%3C%2Fp%3E%0A%0A%3Cp%3E%3Cspan%20style%3D%22font-family%3AArial%2CHelvetica%2Csans-serif%22%3E%E2%9C%A8%20%3Cstrong%3EReady%20to%20meet%20someone%20amazing%3F%3C%2Fstrong%3E%3Cbr%20%2F%3E%0ATake%20a%20moment%20to%20set%20up%20your%20profile%2C%20explore%20matches%2C%20and%20get%20to%20know%20people%20who%20share%20your%20vibe.%3C%2Fspan%3E%3C%2Fp%3E%0A%0A%3Cp%3E%3Cspan%20style%3D%22font-family%3AArial%2CHelvetica%2Csans-serif%22%3ELet%20the%20conversations%20flow%20and%20the%20connections%20grow.%20We%26rsquo%3Bre%20here%20to%20make%20every%20interaction%20memorable.%20%E2%9D%A4%EF%B8%8F%3C%2Fspan%3E%3C%2Fp%3E%0A%0A%3Cp%3E%3Cspan%20style%3D%22font-family%3AArial%2CHelvetica%2Csans-serif%22%3EEnjoy%20the%20experience%2C%3Cbr%20%2F%3E%0A%3Cstrong%3EThe%20Play%20with%20Me%20Team%3C%2Fstrong%3E%3C%2Fspan%3E%3C%2Fp%3E%0A%3C%2Fbody%3E%0A%3C%2Fhtml%3E%0A', 1),
(1034, 1009, '%3Chtml%3E%0A%3Chead%3E%0A%09%3Ctitle%3E%3C%2Ftitle%3E%0A%3C%2Fhead%3E%0A%3Cbody%3E%0A%3Cp%3E%3Cspan%20style%3D%22font-family%3AArial%2CHelvetica%2Csans-serif%22%3E%3Cstrong%3EWelcome%20to%20Play%20with%20Me!%3C%2Fstrong%3E%20%F0%9F%8C%9F%3Cbr%20%2F%3E%0AYour%20journey%20to%20meaningful%20connections%20starts%20here.%20Whether%20you%26%2339%3Bre%20looking%20for%20love%2C%20friendship%2C%20or%20just%20great%20conversations%2C%20you%26%2339%3Bve%20come%20to%20the%20right%20place.%3C%2Fspan%3E%3C%2Fp%3E%0A%0A%3Cp%3E%3Cspan%20style%3D%22font-family%3AArial%2CHelvetica%2Csans-serif%22%3E%E2%9C%A8%20%3Cstrong%3EReady%20to%20meet%20someone%20amazing%3F%3C%2Fstrong%3E%3Cbr%20%2F%3E%0ATake%20a%20moment%20to%20set%20up%20your%20profile%2C%20explore%20matches%2C%20and%20get%20to%20know%20people%20who%20share%20your%20vibe.%3C%2Fspan%3E%3C%2Fp%3E%0A%0A%3Cp%3E%3Cspan%20style%3D%22font-family%3AArial%2CHelvetica%2Csans-serif%22%3ELet%20the%20conversations%20flow%20and%20the%20connections%20grow.%20We%26rsquo%3Bre%20here%20to%20make%20every%20interaction%20memorable.%20%E2%9D%A4%EF%B8%8F%3C%2Fspan%3E%3C%2Fp%3E%0A%0A%3Cp%3E%3Cspan%20style%3D%22font-family%3AArial%2CHelvetica%2Csans-serif%22%3EEnjoy%20the%20experience%2C%3Cbr%20%2F%3E%0A%3Cstrong%3EThe%20Play%20with%20Me%20Team%3C%2Fstrong%3E%3C%2Fspan%3E%3C%2Fp%3E%0A%3C%2Fbody%3E%0A%3C%2Fhtml%3E%0A', 2),
(1035, 1009, '%3Chtml%3E%0A%3Chead%3E%0A%09%3Ctitle%3E%3C%2Ftitle%3E%0A%3C%2Fhead%3E%0A%3Cbody%3E%0A%3Cp%3EWelcome!%3C%2Fp%3E%0A%3C%2Fbody%3E%0A%3C%2Fhtml%3E%0A', 3),
(1036, 1009, 'Welcome', 4);

-- --------------------------------------------------------

--
-- Table structure for table `net_timesfortask`
--

CREATE TABLE `net_timesfortask` (
  `Id` int(11) NOT NULL,
  `TaskId` varchar(50) NOT NULL,
  `FromTime` datetime DEFAULT NULL,
  `ToTime` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `net_timesfortask`
--

INSERT INTO `net_timesfortask` (`Id`, `TaskId`, `FromTime`, `ToTime`) VALUES
(1, 'F1014', '2024-04-16 08:00:00', '2024-04-16 17:00:00'),
(3, 'F1824', '2024-07-27 08:00:00', '2024-07-27 17:00:00'),
(4, 'F1245', '2024-11-12 08:00:00', '2024-11-12 17:00:00'),
(5, 'F1176', '2024-11-18 08:00:00', '2024-11-18 17:00:00'),
(6, 'F1625', '2024-11-18 08:00:00', '2024-11-18 17:00:00');

-- --------------------------------------------------------

--
-- Table structure for table `net_userblock`
--

CREATE TABLE `net_userblock` (
  `Id` int(11) NOT NULL,
  `UserId` bigint(20) NOT NULL,
  `BlockByUser` int(11) NOT NULL,
  `CreateOn` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `net_userdislike`
--

CREATE TABLE `net_userdislike` (
  `Id` int(11) NOT NULL,
  `UserId` bigint(20) NOT NULL,
  `DislikeId` int(11) NOT NULL,
  `Timestamp` datetime DEFAULT NULL,
  `MessageId` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `net_userreport`
--

CREATE TABLE `net_userreport` (
  `Id` int(11) NOT NULL,
  `UserId` bigint(20) NOT NULL,
  `ReportBy` int(11) NOT NULL,
  `CreateOn` datetime NOT NULL,
  `ReportType` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `net_usertracking`
--

CREATE TABLE `net_usertracking` (
  `UserId` bigint(20) NOT NULL,
  `Country` varchar(50) DEFAULT NULL,
  `CountryCode` varchar(10) DEFAULT NULL,
  `Region` varchar(50) DEFAULT NULL,
  `RegionName` varchar(50) DEFAULT NULL,
  `City` varchar(50) DEFAULT NULL,
  `Zip` varchar(50) DEFAULT NULL,
  `Latitude` double DEFAULT NULL,
  `Longitude` double DEFAULT NULL,
  `TimeZone` varchar(50) DEFAULT NULL,
  `IP` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `phone_books`
--

CREATE TABLE `phone_books` (
  `id` bigint(20) NOT NULL,
  `user_id` bigint(20) NOT NULL DEFAULT '0',
  `auth_key_id` bigint(20) NOT NULL,
  `client_id` bigint(20) NOT NULL,
  `phone` varchar(32) NOT NULL,
  `first_name` varchar(64) NOT NULL,
  `last_name` varchar(64) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `photos`
--

CREATE TABLE `photos` (
  `id` bigint(20) NOT NULL,
  `photo_id` bigint(20) NOT NULL,
  `access_hash` bigint(20) NOT NULL,
  `has_stickers` tinyint(1) NOT NULL DEFAULT '0',
  `dc_id` int(11) NOT NULL DEFAULT '2',
  `date2` bigint(20) NOT NULL DEFAULT '0',
  `has_video` tinyint(1) NOT NULL DEFAULT '0',
  `size_id` bigint(20) NOT NULL DEFAULT '0',
  `video_size_id` bigint(20) NOT NULL DEFAULT '0',
  `input_file_name` varchar(128) NOT NULL DEFAULT '',
  `ext` varchar(32) NOT NULL DEFAULT '',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `photo_sizes`
--

CREATE TABLE `photo_sizes` (
  `id` bigint(20) NOT NULL,
  `photo_size_id` bigint(20) NOT NULL,
  `size_type` char(1) NOT NULL DEFAULT '',
  `width` int(11) NOT NULL,
  `height` int(11) NOT NULL,
  `file_size` int(11) NOT NULL,
  `file_path` varchar(255) NOT NULL,
  `cached_type` int(11) NOT NULL DEFAULT '0',
  `cached_bytes` varchar(4096) NOT NULL DEFAULT '',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `popular_contacts`
--

CREATE TABLE `popular_contacts` (
  `id` bigint(20) NOT NULL,
  `phone` varchar(32) NOT NULL,
  `importers` int(11) NOT NULL DEFAULT '1',
  `deleted` tinyint(1) NOT NULL DEFAULT '0',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `predefined_users`
--

CREATE TABLE `predefined_users` (
  `id` bigint(20) NOT NULL,
  `phone` varchar(32) NOT NULL,
  `first_name` varchar(255) NOT NULL DEFAULT '',
  `last_name` varchar(255) NOT NULL DEFAULT '',
  `username` varchar(255) NOT NULL,
  `code` varchar(32) NOT NULL,
  `verified` tinyint(1) NOT NULL DEFAULT '0',
  `registered_user_id` bigint(20) NOT NULL DEFAULT '0',
  `deleted` tinyint(1) NOT NULL DEFAULT '0',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `reactions`
--

CREATE TABLE `reactions` (
  `id` bigint(20) NOT NULL,
  `user_id` bigint(20) NOT NULL,
  `message_id` bigint(20) NOT NULL,
  `reaction` varchar(255) NOT NULL,
  `peer_id` bigint(20) NOT NULL,
  `peer_type` int(11) NOT NULL,
  `read` tinyint(1) NOT NULL DEFAULT '0',
  `reported` tinyint(1) NOT NULL DEFAULT '0',
  `created_at` bigint(20) NOT NULL,
  `updated_at` bigint(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `saved_dialogs`
--

CREATE TABLE `saved_dialogs` (
  `id` bigint(20) NOT NULL,
  `user_id` bigint(20) NOT NULL,
  `peer_type` int(11) NOT NULL,
  `peer_id` bigint(20) NOT NULL,
  `pinned` bigint(20) NOT NULL DEFAULT '0',
  `top_message` int(11) NOT NULL,
  `deleted` tinyint(1) NOT NULL DEFAULT '0',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `themes`
--

CREATE TABLE `themes` (
  `id` bigint(20) NOT NULL,
  `slug` varchar(255) NOT NULL,
  `title` varchar(255) NOT NULL,
  `creator` tinyint(1) DEFAULT '0',
  `default` tinyint(1) DEFAULT '0',
  `for_chat` tinyint(1) DEFAULT '0',
  `access_hash` bigint(20) NOT NULL,
  `document_id` bigint(20) DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `theme_settings`
--

CREATE TABLE `theme_settings` (
  `id` bigint(20) NOT NULL,
  `theme_id` bigint(20) NOT NULL,
  `message_colors_animated` tinyint(1) DEFAULT '0',
  `base_theme` varchar(255) DEFAULT NULL,
  `accent_color` int(11) DEFAULT NULL,
  `outbox_accent_color` int(11) DEFAULT NULL,
  `message_colors` json DEFAULT NULL,
  `wallpaper_id` bigint(20) DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `unregistered_contacts`
--

CREATE TABLE `unregistered_contacts` (
  `id` bigint(20) NOT NULL,
  `phone` varchar(32) NOT NULL,
  `importer_user_id` bigint(20) NOT NULL,
  `import_first_name` varchar(64) NOT NULL,
  `import_last_name` varchar(64) NOT NULL,
  `imported` tinyint(1) NOT NULL DEFAULT '0',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `username`
--

CREATE TABLE `username` (
  `id` bigint(20) NOT NULL,
  `username` varchar(32) NOT NULL,
  `peer_type` int(11) NOT NULL DEFAULT '0',
  `peer_id` bigint(20) NOT NULL DEFAULT '0',
  `deleted` tinyint(1) NOT NULL DEFAULT '0',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` bigint(20) NOT NULL,
  `user_type` int(11) NOT NULL DEFAULT '2',
  `access_hash` bigint(20) NOT NULL,
  `secret_key_id` bigint(20) NOT NULL DEFAULT '0',
  `first_name` varchar(64) NOT NULL DEFAULT '',
  `last_name` varchar(64) NOT NULL DEFAULT '',
  `username` varchar(64) NOT NULL DEFAULT '',
  `phone` varchar(32) NOT NULL,
  `country_code` varchar(3) NOT NULL,
  `verified` tinyint(1) NOT NULL DEFAULT '0',
  `support` tinyint(1) NOT NULL DEFAULT '0',
  `scam` tinyint(1) NOT NULL DEFAULT '0',
  `fake` tinyint(1) NOT NULL DEFAULT '0',
  `premium` tinyint(1) NOT NULL DEFAULT '0',
  `about` varchar(128) NOT NULL DEFAULT '',
  `state` int(11) NOT NULL DEFAULT '0',
  `is_bot` tinyint(1) NOT NULL DEFAULT '0',
  `account_days_ttl` int(11) NOT NULL DEFAULT '180',
  `photo_id` bigint(20) NOT NULL DEFAULT '0',
  `restricted` tinyint(1) NOT NULL DEFAULT '0',
  `restriction_reason` varchar(128) NOT NULL DEFAULT '',
  `archive_and_mute_new_noncontact_peers` tinyint(1) NOT NULL DEFAULT '0',
  `emoji_status_document_id` bigint(20) NOT NULL DEFAULT '0',
  `emoji_status_until` int(11) NOT NULL DEFAULT '0',
  `stories_max_id` int(11) NOT NULL DEFAULT '0',
  `color` int(11) NOT NULL DEFAULT '0',
  `color_background_emoji_id` bigint(20) NOT NULL DEFAULT '0',
  `profile_color` int(11) NOT NULL DEFAULT '0',
  `profile_color_background_emoji_id` bigint(20) NOT NULL DEFAULT '0',
  `birthday` char(10) NOT NULL DEFAULT '',
  `deleted` tinyint(1) NOT NULL DEFAULT '0',
  `delete_reason` varchar(128) NOT NULL DEFAULT '',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `Email` varchar(128) DEFAULT NULL,
  `RegistrationEmail` varchar(128) DEFAULT NULL,
  `RegistrationPhone` varchar(20) DEFAULT NULL,
  `Gender` int(11) DEFAULT NULL,
  `LastAccessDate` datetime DEFAULT NULL,
  `Active` tinyint(4) DEFAULT NULL,
  `OnlineStatus` varchar(16) DEFAULT NULL,
  `MaxContactCount` int(11) DEFAULT NULL,
  `MaxFavoriteCount` int(11) DEFAULT NULL,
  `LastLogin` datetime DEFAULT NULL,
  `IOSPushToken` varchar(255) DEFAULT NULL,
  `AndroidPushToken` varchar(255) DEFAULT NULL,
  `MaxAllowedPartners` int(11) DEFAULT NULL,
  `YearOfBirth` int(11) DEFAULT NULL,
  `Area` int(11) DEFAULT NULL,
  `PlayWith` int(11) DEFAULT NULL,
  `RegisteredByFacebook` tinyint(4) DEFAULT NULL,
  `ReferenceAccount` varchar(50) DEFAULT NULL,
  `RegistrationId` varchar(100) DEFAULT NULL,
  `PartnersFromAge` int(11) DEFAULT NULL,
  `PartnersToAge` int(11) DEFAULT NULL,
  `PartnersGender` int(11) DEFAULT NULL,
  `Passions` longtext,
  `ActiveTimestamp` datetime DEFAULT NULL,
  `Platform` varchar(50) DEFAULT NULL,
  `LatestAppVersion` varchar(50) DEFAULT NULL,
  `LastSuggestedPartners` longtext,
  `LastFetchSuggestionTimestamp` datetime DEFAULT NULL,
  `Regions` varchar(256) DEFAULT NULL,
  `RegistrationTime` datetime DEFAULT NULL,
  `Religion` varchar(256) DEFAULT NULL,
  `PartnerReligions` varchar(256) DEFAULT NULL,
  `RegistrationType` varchar(50) DEFAULT NULL,
  `PartnerRegions` varchar(256) DEFAULT NULL,
  `RegistrationValidated` tinyint(4) DEFAULT NULL,
  `RegistrationBirthday` datetime DEFAULT NULL,
  `LanguageId` int(11) DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `user_type`, `access_hash`, `secret_key_id`, `first_name`, `last_name`, `username`, `phone`, `country_code`, `verified`, `support`, `scam`, `fake`, `premium`, `about`, `state`, `is_bot`, `account_days_ttl`, `photo_id`, `restricted`, `restriction_reason`, `archive_and_mute_new_noncontact_peers`, `emoji_status_document_id`, `emoji_status_until`, `stories_max_id`, `color`, `color_background_emoji_id`, `profile_color`, `profile_color_background_emoji_id`, `birthday`, `deleted`, `delete_reason`, `created_at`, `updated_at`, `Email`, `RegistrationEmail`, `RegistrationPhone`, `Gender`, `LastAccessDate`, `Active`, `OnlineStatus`, `MaxContactCount`, `MaxFavoriteCount`, `LastLogin`, `IOSPushToken`, `AndroidPushToken`, `MaxAllowedPartners`, `YearOfBirth`, `Area`, `PlayWith`, `RegisteredByFacebook`, `ReferenceAccount`, `RegistrationId`, `PartnersFromAge`, `PartnersToAge`, `PartnersGender`, `Passions`, `ActiveTimestamp`, `Platform`, `LatestAppVersion`, `LastSuggestedPartners`, `LastFetchSuggestionTimestamp`, `Regions`, `RegistrationTime`, `Religion`, `PartnerReligions`, `RegistrationType`, `PartnerRegions`, `RegistrationValidated`, `RegistrationBirthday`, `LanguageId`) VALUES
(777000, 4, 6599886787491911851, 6895602324158323006, 'Pwm', 'Service', 'pwm', '42777', '', 1, 0, 0, 0, 0, '', 0, 0, 180, 0, 0, '', 0, 0, 0, 0, 0, 0, 0, 0, '', 0, '', '2018-09-25 13:43:11', '2021-12-17 12:40:51', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1);

-- --------------------------------------------------------

--
-- Table structure for table `user_contacts`
--

CREATE TABLE `user_contacts` (
  `id` bigint(20) NOT NULL,
  `owner_user_id` bigint(20) NOT NULL,
  `contact_user_id` bigint(20) NOT NULL,
  `contact_phone` varchar(32) NOT NULL DEFAULT '',
  `contact_first_name` varchar(255) NOT NULL DEFAULT '',
  `contact_last_name` varchar(255) NOT NULL DEFAULT '',
  `mutual` tinyint(1) NOT NULL DEFAULT '0',
  `close_friend` tinyint(1) NOT NULL DEFAULT '0',
  `stories_hidden` tinyint(1) NOT NULL DEFAULT '0',
  `is_deleted` tinyint(1) NOT NULL DEFAULT '0',
  `date2` bigint(20) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `user_global_privacy_settings`
--

CREATE TABLE `user_global_privacy_settings` (
  `id` bigint(20) NOT NULL,
  `user_id` bigint(20) NOT NULL,
  `archive_and_mute_new_noncontact_peers` tinyint(1) NOT NULL DEFAULT '0',
  `keep_archived_unmuted` tinyint(1) NOT NULL DEFAULT '0',
  `keep_archived_folders` tinyint(1) NOT NULL DEFAULT '0',
  `hide_read_marks` tinyint(1) NOT NULL DEFAULT '0',
  `new_noncontact_peers_require_premium` tinyint(1) NOT NULL DEFAULT '0',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `user_notify_settings`
--

CREATE TABLE `user_notify_settings` (
  `id` bigint(20) NOT NULL,
  `user_id` bigint(20) NOT NULL,
  `peer_type` int(11) NOT NULL,
  `peer_id` bigint(20) NOT NULL,
  `show_previews` int(11) NOT NULL DEFAULT '-1',
  `silent` int(11) NOT NULL DEFAULT '-1',
  `mute_until` int(11) NOT NULL DEFAULT '-1',
  `sound` varchar(255) NOT NULL DEFAULT 'default',
  `deleted` tinyint(1) NOT NULL DEFAULT '0',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `user_peer_blocks`
--

CREATE TABLE `user_peer_blocks` (
  `id` bigint(20) NOT NULL,
  `user_id` bigint(20) NOT NULL,
  `peer_type` int(11) NOT NULL,
  `peer_id` bigint(20) NOT NULL,
  `date` bigint(20) NOT NULL DEFAULT '0',
  `deleted` tinyint(1) NOT NULL DEFAULT '0',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `user_peer_settings`
--

CREATE TABLE `user_peer_settings` (
  `id` bigint(20) NOT NULL,
  `user_id` bigint(20) NOT NULL,
  `peer_type` int(11) NOT NULL,
  `peer_id` bigint(20) NOT NULL,
  `hide` tinyint(1) NOT NULL DEFAULT '0',
  `report_spam` tinyint(1) NOT NULL DEFAULT '0',
  `add_contact` tinyint(1) NOT NULL DEFAULT '0',
  `block_contact` tinyint(1) NOT NULL DEFAULT '0',
  `share_contact` tinyint(1) NOT NULL DEFAULT '0',
  `need_contacts_exception` tinyint(1) NOT NULL DEFAULT '0',
  `report_geo` tinyint(1) NOT NULL DEFAULT '0',
  `autoarchived` tinyint(1) NOT NULL DEFAULT '0',
  `invite_members` tinyint(1) NOT NULL DEFAULT '0',
  `geo_distance` int(11) NOT NULL DEFAULT '0',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `user_presences`
--

CREATE TABLE `user_presences` (
  `id` bigint(20) NOT NULL,
  `user_id` bigint(20) NOT NULL,
  `last_seen_at` bigint(20) NOT NULL,
  `expires` int(11) NOT NULL DEFAULT '0',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `user_privacies`
--

CREATE TABLE `user_privacies` (
  `id` bigint(20) NOT NULL,
  `user_id` bigint(20) NOT NULL,
  `key_type` int(11) NOT NULL DEFAULT '0',
  `rules` json NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `user_profile_photos`
--

CREATE TABLE `user_profile_photos` (
  `id` bigint(20) NOT NULL,
  `user_id` bigint(20) NOT NULL,
  `photo_id` bigint(20) NOT NULL,
  `date2` bigint(20) NOT NULL,
  `deleted` tinyint(1) NOT NULL DEFAULT '0',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `user_pts_updates`
--

CREATE TABLE `user_pts_updates` (
  `id` bigint(20) NOT NULL,
  `user_id` bigint(20) NOT NULL,
  `pts` int(11) NOT NULL,
  `pts_count` int(11) NOT NULL,
  `update_type` tinyint(4) NOT NULL DEFAULT '0',
  `update_data` json NOT NULL,
  `date2` bigint(20) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `user_settings`
--

CREATE TABLE `user_settings` (
  `id` bigint(20) NOT NULL,
  `user_id` bigint(20) NOT NULL,
  `key2` varchar(64) NOT NULL,
  `value` varchar(512) NOT NULL,
  `deleted` tinyint(1) NOT NULL DEFAULT '0',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `user_themes`
--

CREATE TABLE `user_themes` (
  `id` bigint(20) NOT NULL,
  `user_id` bigint(20) NOT NULL,
  `theme_id` bigint(20) NOT NULL,
  `selected_accent_color` int(11) DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `user_wallpapers`
--

CREATE TABLE `user_wallpapers` (
  `id` bigint(20) NOT NULL,
  `user_id` bigint(20) NOT NULL,
  `wallpaper_id` bigint(20) NOT NULL,
  `for_both` tinyint(1) NOT NULL DEFAULT '0',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `video_sizes`
--

CREATE TABLE `video_sizes` (
  `id` bigint(20) NOT NULL,
  `video_size_id` bigint(20) NOT NULL,
  `size_type` char(1) NOT NULL DEFAULT '',
  `width` int(11) NOT NULL,
  `height` int(11) NOT NULL,
  `file_size` int(11) NOT NULL DEFAULT '0',
  `video_start_ts` double NOT NULL DEFAULT '0',
  `file_path` varchar(255) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `wallpapers`
--

CREATE TABLE `wallpapers` (
  `id` bigint(20) NOT NULL,
  `slug` varchar(255) NOT NULL,
  `title` varchar(255) NOT NULL,
  `pattern` tinyint(1) NOT NULL DEFAULT '0',
  `dark` tinyint(1) NOT NULL DEFAULT '0',
  `document_id` bigint(20) DEFAULT NULL,
  `access_hash` bigint(20) NOT NULL,
  `background_color` int(11) DEFAULT NULL,
  `second_background_color` int(11) DEFAULT NULL,
  `third_background_color` int(11) DEFAULT NULL,
  `fourth_background_color` int(11) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `wallpaper_settings`
--

CREATE TABLE `wallpaper_settings` (
  `id` bigint(20) NOT NULL,
  `wallpaper_id` bigint(20) NOT NULL,
  `blur` tinyint(1) DEFAULT '0',
  `motion` tinyint(1) DEFAULT '0',
  `background_color` int(11) DEFAULT NULL,
  `second_background_color` int(11) DEFAULT NULL,
  `third_background_color` int(11) DEFAULT NULL,
  `fourth_background_color` int(11) DEFAULT NULL,
  `intensity` int(11) DEFAULT NULL,
  `rotation` int(11) DEFAULT NULL,
  `emoticon` varchar(255) DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `auths`
--
ALTER TABLE `auths`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `auth_key_id` (`auth_key_id`);

--
-- Indexes for table `auth_keys`
--
ALTER TABLE `auth_keys`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `auth_key_id` (`auth_key_id`);

--
-- Indexes for table `auth_key_infos`
--
ALTER TABLE `auth_key_infos`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `auth_key_id` (`auth_key_id`);

--
-- Indexes for table `auth_seq_updates`
--
ALTER TABLE `auth_seq_updates`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `auth_id` (`auth_id`,`user_id`,`seq`);

--
-- Indexes for table `auth_users`
--
ALTER TABLE `auth_users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `auth_key_id` (`auth_key_id`,`user_id`),
  ADD KEY `auth_key_id_2` (`auth_key_id`,`user_id`,`deleted`);

--
-- Indexes for table `bots`
--
ALTER TABLE `bots`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `bot_id` (`bot_id`),
  ADD UNIQUE KEY `token` (`token`);

--
-- Indexes for table `bot_commands`
--
ALTER TABLE `bot_commands`
  ADD PRIMARY KEY (`id`),
  ADD KEY `bot_id` (`bot_id`);

--
-- Indexes for table `chats`
--
ALTER TABLE `chats`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `chat_invites`
--
ALTER TABLE `chat_invites`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `link` (`link`),
  ADD KEY `chat_id` (`chat_id`,`permanent`,`admin_id`),
  ADD KEY `chat_id_2` (`chat_id`,`admin_id`);

--
-- Indexes for table `chat_invite_participants`
--
ALTER TABLE `chat_invite_participants`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `link` (`link`,`user_id`),
  ADD KEY `link_2` (`link`);

--
-- Indexes for table `chat_participants`
--
ALTER TABLE `chat_participants`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `chat_id_2` (`chat_id`,`user_id`),
  ADD KEY `chat_id` (`chat_id`);

--
-- Indexes for table `devices`
--
ALTER TABLE `devices`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `auth_key_id` (`auth_key_id`,`user_id`,`token_type`);

--
-- Indexes for table `dialogs`
--
ALTER TABLE `dialogs`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `user_id` (`user_id`,`peer_type`,`peer_id`),
  ADD UNIQUE KEY `user_id_2` (`user_id`,`peer_dialog_id`);

--
-- Indexes for table `dialog_filters`
--
ALTER TABLE `dialog_filters`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `user_id` (`user_id`,`dialog_filter_id`);

--
-- Indexes for table `documents`
--
ALTER TABLE `documents`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `document_id` (`document_id`) USING BTREE;

--
-- Indexes for table `encrypted_files`
--
ALTER TABLE `encrypted_files`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `hash_tags`
--
ALTER TABLE `hash_tags`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `user_id_4` (`user_id`,`hash_tag`,`hash_tag_message_id`),
  ADD KEY `user_id` (`user_id`,`hash_tag`),
  ADD KEY `user_id_2` (`user_id`,`peer_type`,`peer_id`,`hash_tag`),
  ADD KEY `user_id_3` (`user_id`,`hash_tag_message_id`);

--
-- Indexes for table `identify_role`
--
ALTER TABLE `identify_role`
  ADD PRIMARY KEY (`Id`);

--
-- Indexes for table `identify_role_claims`
--
ALTER TABLE `identify_role_claims`
  ADD PRIMARY KEY (`Id`),
  ADD KEY `FK_RoleClaims_Role` (`RoleId`);

--
-- Indexes for table `identify_user`
--
ALTER TABLE `identify_user`
  ADD PRIMARY KEY (`Id`);

--
-- Indexes for table `identify_user_claims`
--
ALTER TABLE `identify_user_claims`
  ADD PRIMARY KEY (`Id`),
  ADD KEY `FK_UserClaims_User` (`UserId`);

--
-- Indexes for table `identify_user_logins`
--
ALTER TABLE `identify_user_logins`
  ADD PRIMARY KEY (`LoginProvider`,`ProviderKey`),
  ADD KEY `FK_UserLogins_User` (`UserId`);

--
-- Indexes for table `identify_user_roles`
--
ALTER TABLE `identify_user_roles`
  ADD PRIMARY KEY (`UserId`,`RoleId`),
  ADD KEY `FK_UserRoles_Role` (`RoleId`);

--
-- Indexes for table `identify_user_tokens`
--
ALTER TABLE `identify_user_tokens`
  ADD PRIMARY KEY (`UserId`,`LoginProvider`,`Name`);

--
-- Indexes for table `imported_contacts`
--
ALTER TABLE `imported_contacts`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `user_id` (`user_id`),
  ADD UNIQUE KEY `user_id_2` (`user_id`,`imported_user_id`);

--
-- Indexes for table `messages`
--
ALTER TABLE `messages`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `user_id_2` (`user_id`,`user_message_box_id`),
  ADD KEY `user_id` (`user_id`,`dialog_id1`,`dialog_id2`),
  ADD KEY `FK_messages_pair_idx` (`PairId`),
  ADD KEY `FK_messages_pairgame_idx` (`PairGameId`),
  ADD KEY `FK_messages_gameconfig_idx` (`GameConfigId`);

--
-- Indexes for table `net_areas`
--
ALTER TABLE `net_areas`
  ADD PRIMARY KEY (`Id`);

--
-- Indexes for table `net_brands`
--
ALTER TABLE `net_brands`
  ADD PRIMARY KEY (`Id`);

--
-- Indexes for table `net_broadcastmessage`
--
ALTER TABLE `net_broadcastmessage`
  ADD PRIMARY KEY (`BroadcastMessageId`);

--
-- Indexes for table `net_broadcastmessageuser`
--
ALTER TABLE `net_broadcastmessageuser`
  ADD PRIMARY KEY (`Id`),
  ADD KEY `FK_BroadcastMessageUser_BroadcastMessage` (`BroadcastMessageId`),
  ADD KEY `FK_BroadcastMessageUser_User` (`UserId`);

--
-- Indexes for table `net_chain`
--
ALTER TABLE `net_chain`
  ADD PRIMARY KEY (`Id`),
  ADD KEY `FK_Chain_Task` (`ChainId`);

--
-- Indexes for table `net_completedchain`
--
ALTER TABLE `net_completedchain`
  ADD PRIMARY KEY (`CompletedChainId`),
  ADD KEY `FK_CompletedChain_CompletedTask` (`CompletedTaskId`),
  ADD KEY `FK_CompletedChain_Tasks` (`ChainId`),
  ADD KEY `FK_CompletedChain_Tasks1` (`TaskId`);

--
-- Indexes for table `net_completedtask`
--
ALTER TABLE `net_completedtask`
  ADD PRIMARY KEY (`CompletedTaskId`),
  ADD KEY `FK_CompletedTask_GameConfig` (`GameConfigId`),
  ADD KEY `FK_CompletedTask_PairGame` (`PairGameId`),
  ADD KEY `FK_CompletedTask_User` (`PlayerId`);

--
-- Indexes for table `net_configurabletext`
--
ALTER TABLE `net_configurabletext`
  ADD PRIMARY KEY (`Id`);

--
-- Indexes for table `net_country`
--
ALTER TABLE `net_country`
  ADD PRIMARY KEY (`Id`);

--
-- Indexes for table `net_filltext`
--
ALTER TABLE `net_filltext`
  ADD PRIMARY KEY (`Id`),
  ADD KEY `FK_FillText_Language` (`LanguageId`),
  ADD KEY `FK_FillText_Task` (`TaskId`);

--
-- Indexes for table `net_game`
--
ALTER TABLE `net_game`
  ADD PRIMARY KEY (`GameId`),
  ADD KEY `FK_Game_GameType` (`Type`);

--
-- Indexes for table `net_gameconfig`
--
ALTER TABLE `net_gameconfig`
  ADD PRIMARY KEY (`Id`),
  ADD KEY `FK_GameConfig_Game` (`GameId`),
  ADD KEY `FK_GameConfig_TaskF` (`TaskForF`),
  ADD KEY `FK_GameConfig_TaskM` (`TaskForM`);

--
-- Indexes for table `net_gametype`
--
ALTER TABLE `net_gametype`
  ADD PRIMARY KEY (`Id`);

--
-- Indexes for table `net_gender`
--
ALTER TABLE `net_gender`
  ADD PRIMARY KEY (`Id`);

--
-- Indexes for table `net_generatorparameters`
--
ALTER TABLE `net_generatorparameters`
  ADD PRIMARY KEY (`Id`);

--
-- Indexes for table `net_geographicalarea`
--
ALTER TABLE `net_geographicalarea`
  ADD PRIMARY KEY (`Id`);

--
-- Indexes for table `net_keywords`
--
ALTER TABLE `net_keywords`
  ADD PRIMARY KEY (`Id`);

--
-- Indexes for table `net_language`
--
ALTER TABLE `net_language`
  ADD PRIMARY KEY (`Id`);

--
-- Indexes for table `net_loginsession`
--
ALTER TABLE `net_loginsession`
  ADD PRIMARY KEY (`Id`);

--
-- Indexes for table `net_mediacomment`
--
ALTER TABLE `net_mediacomment`
  ADD PRIMARY KEY (`Id`);

--
-- Indexes for table `net_newgamerules`
--
ALTER TABLE `net_newgamerules`
  ADD PRIMARY KEY (`Id`);

--
-- Indexes for table `net_news`
--
ALTER TABLE `net_news`
  ADD PRIMARY KEY (`Id`);

--
-- Indexes for table `net_newscomment`
--
ALTER TABLE `net_newscomment`
  ADD PRIMARY KEY (`Id`);

--
-- Indexes for table `net_offensivereport`
--
ALTER TABLE `net_offensivereport`
  ADD PRIMARY KEY (`Id`);

--
-- Indexes for table `net_pairgame`
--
ALTER TABLE `net_pairgame`
  ADD PRIMARY KEY (`PairGameId`),
  ADD KEY `FK_PairGame_Game` (`GameId`),
  ADD KEY `FK_PairGame_PlayerPair_idx` (`PlayerPairId`);

--
-- Indexes for table `net_pairstatus`
--
ALTER TABLE `net_pairstatus`
  ADD PRIMARY KEY (`Id`);

--
-- Indexes for table `net_passion`
--
ALTER TABLE `net_passion`
  ADD PRIMARY KEY (`PassionId`);

--
-- Indexes for table `net_playerpair`
--
ALTER TABLE `net_playerpair`
  ADD PRIMARY KEY (`PlayerPairId`),
  ADD KEY `FK_PlayerPair_PairStatus` (`Status`),
  ADD KEY `FK_PlayerPair_UserFemale` (`Player2`),
  ADD KEY `FK_PlayerPair_UserMale` (`Player1`),
  ADD KEY `FK_PlayerPair_PairGame_idx` (`CurrentPairGameId`);

--
-- Indexes for table `net_q234`
--
ALTER TABLE `net_q234`
  ADD PRIMARY KEY (`Id`),
  ADD KEY `FK_Q234_Language` (`LanguageId`),
  ADD KEY `FK_Q234_Task` (`TaskId`);

--
-- Indexes for table `net_resourcestring`
--
ALTER TABLE `net_resourcestring`
  ADD PRIMARY KEY (`Id`);

--
-- Indexes for table `net_role`
--
ALTER TABLE `net_role`
  ADD PRIMARY KEY (`Id`);

--
-- Indexes for table `net_sexualorientation`
--
ALTER TABLE `net_sexualorientation`
  ADD PRIMARY KEY (`SexualOrientationId`);

--
-- Indexes for table `net_sysparam`
--
ALTER TABLE `net_sysparam`
  ADD PRIMARY KEY (`Id`);

--
-- Indexes for table `net_taskanswer`
--
ALTER TABLE `net_taskanswer`
  ADD PRIMARY KEY (`Id`),
  ADD KEY `fk_taskanswer_completedtask_idx` (`CompletedTaskId`);

--
-- Indexes for table `net_taskanswerfeedback`
--
ALTER TABLE `net_taskanswerfeedback`
  ADD PRIMARY KEY (`Id`),
  ADD KEY `FK_TaskAnswerComment_TaskAnswer` (`CompletedTaskId`),
  ADD KEY `FK_TaskAnswerFeedback_TaskLike` (`LikeTypeId`),
  ADD KEY `FK_TaskAnswerFeedback_User` (`PlayerId`);

--
-- Indexes for table `net_taskauthor`
--
ALTER TABLE `net_taskauthor`
  ADD PRIMARY KEY (`Id`);

--
-- Indexes for table `net_taskkeyword`
--
ALTER TABLE `net_taskkeyword`
  ADD PRIMARY KEY (`Id`);

--
-- Indexes for table `net_tasklike`
--
ALTER TABLE `net_tasklike`
  ADD PRIMARY KEY (`Id`);

--
-- Indexes for table `net_taskmaxstep`
--
ALTER TABLE `net_taskmaxstep`
  ADD PRIMARY KEY (`Id`),
  ADD KEY `FK_TaskMaxStep_PlayerPair` (`PlayerPairId`),
  ADD KEY `FK_TaskMaxStep_Task` (`TaskId`),
  ADD KEY `FK_TaskMaxStep_User` (`PlayerId`);

--
-- Indexes for table `net_tasknotification`
--
ALTER TABLE `net_tasknotification`
  ADD PRIMARY KEY (`Id`),
  ADD KEY `FK_TaskNotification_CompletedTask` (`CompletedTaskId`),
  ADD KEY `FK_TaskNotification_User` (`PlayerToId`),
  ADD KEY `FK_TaskNotification_UserFrom` (`PlayerFromId`);

--
-- Indexes for table `net_tasks`
--
ALTER TABLE `net_tasks`
  ADD PRIMARY KEY (`Seq`),
  ADD KEY `TaskId` (`TaskId`),
  ADD KEY `FK_Task_TaskSubSubType` (`SubSubType`),
  ADD KEY `FK_Task_TaskSubType` (`SubType`),
  ADD KEY `FK_Tasks_TaskAuthor` (`Author`),
  ADD KEY `FK_Tasks_TaskStatus` (`Status`),
  ADD KEY `FK_Tasks_TaskTypes` (`Type`);

--
-- Indexes for table `net_taskstatus`
--
ALTER TABLE `net_taskstatus`
  ADD PRIMARY KEY (`Id`);

--
-- Indexes for table `net_tasksubsubtype`
--
ALTER TABLE `net_tasksubsubtype`
  ADD PRIMARY KEY (`Id`),
  ADD KEY `FK_TaskSubSubType_TaskSubType` (`SubType`);

--
-- Indexes for table `net_tasksubtype`
--
ALTER TABLE `net_tasksubtype`
  ADD PRIMARY KEY (`Id`);

--
-- Indexes for table `net_tasktext`
--
ALTER TABLE `net_tasktext`
  ADD PRIMARY KEY (`Id`),
  ADD KEY `FK_TaskText_Languages` (`LanguageId`),
  ADD KEY `FK_TaskText_Task` (`TaskId`);

--
-- Indexes for table `net_tasktype`
--
ALTER TABLE `net_tasktype`
  ADD PRIMARY KEY (`Id`);

--
-- Indexes for table `net_textinmultilanguages`
--
ALTER TABLE `net_textinmultilanguages`
  ADD PRIMARY KEY (`Id`);

--
-- Indexes for table `net_timesfortask`
--
ALTER TABLE `net_timesfortask`
  ADD PRIMARY KEY (`Id`),
  ADD KEY `FK_TimesForTask_Task` (`TaskId`);

--
-- Indexes for table `net_userblock`
--
ALTER TABLE `net_userblock`
  ADD PRIMARY KEY (`Id`);

--
-- Indexes for table `net_userdislike`
--
ALTER TABLE `net_userdislike`
  ADD PRIMARY KEY (`Id`);

--
-- Indexes for table `net_userreport`
--
ALTER TABLE `net_userreport`
  ADD PRIMARY KEY (`Id`);

--
-- Indexes for table `net_usertracking`
--
ALTER TABLE `net_usertracking`
  ADD PRIMARY KEY (`UserId`);

--
-- Indexes for table `phone_books`
--
ALTER TABLE `phone_books`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `auth_key_id` (`auth_key_id`,`client_id`);

--
-- Indexes for table `photos`
--
ALTER TABLE `photos`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `photo_id` (`photo_id`);

--
-- Indexes for table `photo_sizes`
--
ALTER TABLE `photo_sizes`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `photo_size_id` (`photo_size_id`,`size_type`),
  ADD KEY `photo_id` (`photo_size_id`);

--
-- Indexes for table `popular_contacts`
--
ALTER TABLE `popular_contacts`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `phone` (`phone`);

--
-- Indexes for table `predefined_users`
--
ALTER TABLE `predefined_users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `phone` (`phone`);

--
-- Indexes for table `reactions`
--
ALTER TABLE `reactions`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_user_id` (`user_id`),
  ADD KEY `idx_message_id` (`message_id`),
  ADD KEY `idx_peer_id_peer_type` (`peer_id`,`peer_type`),
  ADD KEY `idx_read` (`read`);

--
-- Indexes for table `saved_dialogs`
--
ALTER TABLE `saved_dialogs`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `user_id` (`user_id`,`peer_type`,`peer_id`),
  ADD KEY `user_id_2` (`user_id`);

--
-- Indexes for table `themes`
--
ALTER TABLE `themes`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `theme_settings`
--
ALTER TABLE `theme_settings`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_theme_settings_theme_id` (`theme_id`),
  ADD KEY `fk_theme_settings_wallpaper_id` (`wallpaper_id`);

--
-- Indexes for table `unregistered_contacts`
--
ALTER TABLE `unregistered_contacts`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `phone` (`phone`,`importer_user_id`),
  ADD KEY `phone_2` (`phone`,`importer_user_id`,`imported`),
  ADD KEY `phone_3` (`phone`);

--
-- Indexes for table `username`
--
ALTER TABLE `username`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `username` (`username`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `phone` (`phone`),
  ADD KEY `FK_User_Areas` (`Area`),
  ADD KEY `FK_Users_Genders` (`Gender`),
  ADD KEY `FK_Users_Language_idx` (`LanguageId`),
  ADD KEY `FK_Users_Genders_Partner_idx` (`PartnersGender`);

--
-- Indexes for table `user_contacts`
--
ALTER TABLE `user_contacts`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `owner_user_id` (`owner_user_id`,`contact_user_id`),
  ADD KEY `owner_user_id_2` (`owner_user_id`);

--
-- Indexes for table `user_global_privacy_settings`
--
ALTER TABLE `user_global_privacy_settings`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `user_id` (`user_id`);

--
-- Indexes for table `user_notify_settings`
--
ALTER TABLE `user_notify_settings`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `user_id` (`user_id`,`peer_type`,`peer_id`);

--
-- Indexes for table `user_peer_blocks`
--
ALTER TABLE `user_peer_blocks`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `user_id_2` (`user_id`,`peer_type`,`peer_id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `user_peer_settings`
--
ALTER TABLE `user_peer_settings`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `user_id` (`user_id`,`peer_type`,`peer_id`);

--
-- Indexes for table `user_presences`
--
ALTER TABLE `user_presences`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `user_id` (`user_id`);

--
-- Indexes for table `user_privacies`
--
ALTER TABLE `user_privacies`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `user_id` (`user_id`,`key_type`);

--
-- Indexes for table `user_profile_photos`
--
ALTER TABLE `user_profile_photos`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `user_id` (`user_id`,`photo_id`),
  ADD KEY `user_id_2` (`user_id`);

--
-- Indexes for table `user_pts_updates`
--
ALTER TABLE `user_pts_updates`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`,`pts`);

--
-- Indexes for table `user_settings`
--
ALTER TABLE `user_settings`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `user_id` (`user_id`,`key2`);

--
-- Indexes for table `user_themes`
--
ALTER TABLE `user_themes`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_themes_user_id_idx` (`user_id`),
  ADD KEY `user_themes_theme_id_idx` (`theme_id`);

--
-- Indexes for table `user_wallpapers`
--
ALTER TABLE `user_wallpapers`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_wallpapers_user_id_idx` (`user_id`),
  ADD KEY `user_wallpapers_wallpaper_id_idx` (`wallpaper_id`);

--
-- Indexes for table `video_sizes`
--
ALTER TABLE `video_sizes`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `video_size_id` (`video_size_id`,`size_type`),
  ADD KEY `video_size_id_2` (`video_size_id`);

--
-- Indexes for table `wallpapers`
--
ALTER TABLE `wallpapers`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_wallpapers_document_id` (`document_id`);

--
-- Indexes for table `wallpaper_settings`
--
ALTER TABLE `wallpaper_settings`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_wallpaper_settings_wallpaper_id` (`wallpaper_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `auths`
--
ALTER TABLE `auths`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;

--
-- AUTO_INCREMENT for table `auth_keys`
--
ALTER TABLE `auth_keys`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT for table `auth_key_infos`
--
ALTER TABLE `auth_key_infos`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT for table `auth_seq_updates`
--
ALTER TABLE `auth_seq_updates`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `auth_users`
--
ALTER TABLE `auth_users`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `bots`
--
ALTER TABLE `bots`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `bot_commands`
--
ALTER TABLE `bot_commands`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `chats`
--
ALTER TABLE `chats`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `chat_invites`
--
ALTER TABLE `chat_invites`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `chat_invite_participants`
--
ALTER TABLE `chat_invite_participants`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `chat_participants`
--
ALTER TABLE `chat_participants`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `devices`
--
ALTER TABLE `devices`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `dialogs`
--
ALTER TABLE `dialogs`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `dialog_filters`
--
ALTER TABLE `dialog_filters`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `documents`
--
ALTER TABLE `documents`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `encrypted_files`
--
ALTER TABLE `encrypted_files`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `hash_tags`
--
ALTER TABLE `hash_tags`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `identify_role_claims`
--
ALTER TABLE `identify_role_claims`
  MODIFY `Id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `identify_user_claims`
--
ALTER TABLE `identify_user_claims`
  MODIFY `Id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `imported_contacts`
--
ALTER TABLE `imported_contacts`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `messages`
--
ALTER TABLE `messages`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `net_areas`
--
ALTER TABLE `net_areas`
  MODIFY `Id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `net_brands`
--
ALTER TABLE `net_brands`
  MODIFY `Id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `net_broadcastmessage`
--
ALTER TABLE `net_broadcastmessage`
  MODIFY `BroadcastMessageId` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `net_broadcastmessageuser`
--
ALTER TABLE `net_broadcastmessageuser`
  MODIFY `Id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `net_chain`
--
ALTER TABLE `net_chain`
  MODIFY `Id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `net_completedchain`
--
ALTER TABLE `net_completedchain`
  MODIFY `CompletedChainId` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `net_completedtask`
--
ALTER TABLE `net_completedtask`
  MODIFY `CompletedTaskId` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `net_configurabletext`
--
ALTER TABLE `net_configurabletext`
  MODIFY `Id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1010;

--
-- AUTO_INCREMENT for table `net_country`
--
ALTER TABLE `net_country`
  MODIFY `Id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `net_filltext`
--
ALTER TABLE `net_filltext`
  MODIFY `Id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2619;

--
-- AUTO_INCREMENT for table `net_game`
--
ALTER TABLE `net_game`
  MODIFY `GameId` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `net_gameconfig`
--
ALTER TABLE `net_gameconfig`
  MODIFY `Id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `net_gametype`
--
ALTER TABLE `net_gametype`
  MODIFY `Id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `net_generatorparameters`
--
ALTER TABLE `net_generatorparameters`
  MODIFY `Id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `net_geographicalarea`
--
ALTER TABLE `net_geographicalarea`
  MODIFY `Id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `net_keywords`
--
ALTER TABLE `net_keywords`
  MODIFY `Id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT for table `net_language`
--
ALTER TABLE `net_language`
  MODIFY `Id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `net_loginsession`
--
ALTER TABLE `net_loginsession`
  MODIFY `Id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `net_mediacomment`
--
ALTER TABLE `net_mediacomment`
  MODIFY `Id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `net_newgamerules`
--
ALTER TABLE `net_newgamerules`
  MODIFY `Id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `net_news`
--
ALTER TABLE `net_news`
  MODIFY `Id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `net_newscomment`
--
ALTER TABLE `net_newscomment`
  MODIFY `Id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `net_offensivereport`
--
ALTER TABLE `net_offensivereport`
  MODIFY `Id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `net_pairgame`
--
ALTER TABLE `net_pairgame`
  MODIFY `PairGameId` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `net_passion`
--
ALTER TABLE `net_passion`
  MODIFY `PassionId` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=38;

--
-- AUTO_INCREMENT for table `net_playerpair`
--
ALTER TABLE `net_playerpair`
  MODIFY `PlayerPairId` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `net_q234`
--
ALTER TABLE `net_q234`
  MODIFY `Id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `net_sysparam`
--
ALTER TABLE `net_sysparam`
  MODIFY `Id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `net_taskanswer`
--
ALTER TABLE `net_taskanswer`
  MODIFY `Id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `net_taskanswerfeedback`
--
ALTER TABLE `net_taskanswerfeedback`
  MODIFY `Id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `net_taskauthor`
--
ALTER TABLE `net_taskauthor`
  MODIFY `Id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `net_taskkeyword`
--
ALTER TABLE `net_taskkeyword`
  MODIFY `Id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=60;

--
-- AUTO_INCREMENT for table `net_tasklike`
--
ALTER TABLE `net_tasklike`
  MODIFY `Id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `net_taskmaxstep`
--
ALTER TABLE `net_taskmaxstep`
  MODIFY `Id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `net_tasknotification`
--
ALTER TABLE `net_tasknotification`
  MODIFY `Id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `net_tasks`
--
ALTER TABLE `net_tasks`
  MODIFY `Seq` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1730;

--
-- AUTO_INCREMENT for table `net_taskstatus`
--
ALTER TABLE `net_taskstatus`
  MODIFY `Id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `net_tasksubsubtype`
--
ALTER TABLE `net_tasksubsubtype`
  MODIFY `Id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;

--
-- AUTO_INCREMENT for table `net_tasksubtype`
--
ALTER TABLE `net_tasksubtype`
  MODIFY `Id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=94;

--
-- AUTO_INCREMENT for table `net_tasktext`
--
ALTER TABLE `net_tasktext`
  MODIFY `Id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2016;

--
-- AUTO_INCREMENT for table `net_tasktype`
--
ALTER TABLE `net_tasktype`
  MODIFY `Id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- AUTO_INCREMENT for table `net_textinmultilanguages`
--
ALTER TABLE `net_textinmultilanguages`
  MODIFY `Id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1037;

--
-- AUTO_INCREMENT for table `net_timesfortask`
--
ALTER TABLE `net_timesfortask`
  MODIFY `Id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `net_userdislike`
--
ALTER TABLE `net_userdislike`
  MODIFY `Id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `phone_books`
--
ALTER TABLE `phone_books`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `photos`
--
ALTER TABLE `photos`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `photo_sizes`
--
ALTER TABLE `photo_sizes`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT for table `popular_contacts`
--
ALTER TABLE `popular_contacts`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `predefined_users`
--
ALTER TABLE `predefined_users`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `reactions`
--
ALTER TABLE `reactions`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `saved_dialogs`
--
ALTER TABLE `saved_dialogs`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `themes`
--
ALTER TABLE `themes`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `theme_settings`
--
ALTER TABLE `theme_settings`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `unregistered_contacts`
--
ALTER TABLE `unregistered_contacts`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `username`
--
ALTER TABLE `username`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=777001;

--
-- AUTO_INCREMENT for table `user_contacts`
--
ALTER TABLE `user_contacts`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT for table `user_global_privacy_settings`
--
ALTER TABLE `user_global_privacy_settings`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `user_notify_settings`
--
ALTER TABLE `user_notify_settings`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `user_peer_blocks`
--
ALTER TABLE `user_peer_blocks`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `user_peer_settings`
--
ALTER TABLE `user_peer_settings`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `user_presences`
--
ALTER TABLE `user_presences`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=86;

--
-- AUTO_INCREMENT for table `user_privacies`
--
ALTER TABLE `user_privacies`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `user_profile_photos`
--
ALTER TABLE `user_profile_photos`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `user_pts_updates`
--
ALTER TABLE `user_pts_updates`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT for table `user_settings`
--
ALTER TABLE `user_settings`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `user_themes`
--
ALTER TABLE `user_themes`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `user_wallpapers`
--
ALTER TABLE `user_wallpapers`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `video_sizes`
--
ALTER TABLE `video_sizes`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `wallpapers`
--
ALTER TABLE `wallpapers`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `wallpaper_settings`
--
ALTER TABLE `wallpaper_settings`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `identify_role_claims`
--
ALTER TABLE `identify_role_claims`
  ADD CONSTRAINT `FK_RoleClaims_Role` FOREIGN KEY (`RoleId`) REFERENCES `identify_role` (`Id`) ON DELETE CASCADE;

--
-- Constraints for table `identify_user_claims`
--
ALTER TABLE `identify_user_claims`
  ADD CONSTRAINT `FK_UserClaims_User` FOREIGN KEY (`UserId`) REFERENCES `identify_user` (`Id`) ON DELETE CASCADE;

--
-- Constraints for table `identify_user_logins`
--
ALTER TABLE `identify_user_logins`
  ADD CONSTRAINT `FK_UserLogins_User` FOREIGN KEY (`UserId`) REFERENCES `identify_user` (`Id`) ON DELETE CASCADE;

--
-- Constraints for table `identify_user_roles`
--
ALTER TABLE `identify_user_roles`
  ADD CONSTRAINT `FK_UserRoles_Role` FOREIGN KEY (`RoleId`) REFERENCES `identify_role` (`Id`) ON DELETE CASCADE,
  ADD CONSTRAINT `FK_UserRoles_User` FOREIGN KEY (`UserId`) REFERENCES `identify_user` (`Id`) ON DELETE CASCADE;

--
-- Constraints for table `identify_user_tokens`
--
ALTER TABLE `identify_user_tokens`
  ADD CONSTRAINT `FK_UserTokens_User` FOREIGN KEY (`UserId`) REFERENCES `identify_user` (`Id`) ON DELETE CASCADE;

--
-- Constraints for table `messages`
--
ALTER TABLE `messages`
  ADD CONSTRAINT `FK_messages_gameconfig` FOREIGN KEY (`GameConfigId`) REFERENCES `net_gameconfig` (`Id`) ON DELETE SET NULL ON UPDATE SET NULL,
  ADD CONSTRAINT `FK_messages_pair` FOREIGN KEY (`PairId`) REFERENCES `net_playerpair` (`PlayerPairId`) ON DELETE SET NULL ON UPDATE SET NULL,
  ADD CONSTRAINT `FK_messages_pairgame` FOREIGN KEY (`PairGameId`) REFERENCES `net_pairgame` (`PairGameId`) ON DELETE SET NULL ON UPDATE SET NULL;

--
-- Constraints for table `net_broadcastmessageuser`
--
ALTER TABLE `net_broadcastmessageuser`
  ADD CONSTRAINT `FK_BroadcastMessageUser_BroadcastMessage` FOREIGN KEY (`BroadcastMessageId`) REFERENCES `net_broadcastmessage` (`BroadcastMessageId`),
  ADD CONSTRAINT `FK_BroadcastMessageUser_User` FOREIGN KEY (`UserId`) REFERENCES `users` (`id`);

--
-- Constraints for table `net_chain`
--
ALTER TABLE `net_chain`
  ADD CONSTRAINT `FK_Chain_Task` FOREIGN KEY (`ChainId`) REFERENCES `net_tasks` (`TaskId`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `net_completedchain`
--
ALTER TABLE `net_completedchain`
  ADD CONSTRAINT `FK_CompletedChain_CompletedTask` FOREIGN KEY (`CompletedTaskId`) REFERENCES `net_completedtask` (`CompletedTaskId`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `FK_CompletedChain_Tasks` FOREIGN KEY (`ChainId`) REFERENCES `net_tasks` (`TaskId`),
  ADD CONSTRAINT `FK_CompletedChain_Tasks1` FOREIGN KEY (`TaskId`) REFERENCES `net_tasks` (`TaskId`);

--
-- Constraints for table `net_completedtask`
--
ALTER TABLE `net_completedtask`
  ADD CONSTRAINT `FK_CompletedTask_GameConfig` FOREIGN KEY (`GameConfigId`) REFERENCES `net_gameconfig` (`Id`),
  ADD CONSTRAINT `FK_CompletedTask_PairGame` FOREIGN KEY (`PairGameId`) REFERENCES `net_pairgame` (`PairGameId`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `FK_CompletedTask_User` FOREIGN KEY (`PlayerId`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `net_filltext`
--
ALTER TABLE `net_filltext`
  ADD CONSTRAINT `FK_FillText_Language` FOREIGN KEY (`LanguageId`) REFERENCES `net_language` (`Id`),
  ADD CONSTRAINT `FK_FillText_Task` FOREIGN KEY (`TaskId`) REFERENCES `net_tasks` (`TaskId`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `net_game`
--
ALTER TABLE `net_game`
  ADD CONSTRAINT `FK_Game_GameType` FOREIGN KEY (`Type`) REFERENCES `net_gametype` (`Id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `net_gameconfig`
--
ALTER TABLE `net_gameconfig`
  ADD CONSTRAINT `FK_GameConfig_Game` FOREIGN KEY (`GameId`) REFERENCES `net_game` (`GameId`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `FK_GameConfig_TaskF` FOREIGN KEY (`TaskForF`) REFERENCES `net_tasks` (`TaskId`),
  ADD CONSTRAINT `FK_GameConfig_TaskM` FOREIGN KEY (`TaskForM`) REFERENCES `net_tasks` (`TaskId`);

--
-- Constraints for table `net_pairgame`
--
ALTER TABLE `net_pairgame`
  ADD CONSTRAINT `FK_PairGame_Game` FOREIGN KEY (`GameId`) REFERENCES `net_game` (`GameId`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `FK_PairGame_PlayerPair` FOREIGN KEY (`PlayerPairId`) REFERENCES `net_playerpair` (`PlayerPairId`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `net_playerpair`
--
ALTER TABLE `net_playerpair`
  ADD CONSTRAINT `FK_PlayerPair_PairGame` FOREIGN KEY (`CurrentPairGameId`) REFERENCES `net_pairgame` (`PairGameId`) ON DELETE SET NULL ON UPDATE SET NULL,
  ADD CONSTRAINT `FK_PlayerPair_PairStatus` FOREIGN KEY (`Status`) REFERENCES `net_pairstatus` (`Id`),
  ADD CONSTRAINT `FK_PlayerPair_UserFemale` FOREIGN KEY (`Player2`) REFERENCES `users` (`id`),
  ADD CONSTRAINT `FK_PlayerPair_UserMale` FOREIGN KEY (`Player1`) REFERENCES `users` (`id`);

--
-- Constraints for table `net_q234`
--
ALTER TABLE `net_q234`
  ADD CONSTRAINT `FK_Q234_Language` FOREIGN KEY (`LanguageId`) REFERENCES `net_language` (`Id`),
  ADD CONSTRAINT `FK_Q234_Task` FOREIGN KEY (`TaskId`) REFERENCES `net_tasks` (`TaskId`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `net_taskanswer`
--
ALTER TABLE `net_taskanswer`
  ADD CONSTRAINT `fk_taskanswer_completedtask` FOREIGN KEY (`CompletedTaskId`) REFERENCES `net_completedtask` (`CompletedTaskId`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `net_taskanswerfeedback`
--
ALTER TABLE `net_taskanswerfeedback`
  ADD CONSTRAINT `FK_TaskAnswerComment_TaskAnswer` FOREIGN KEY (`CompletedTaskId`) REFERENCES `net_completedtask` (`CompletedTaskId`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `FK_TaskAnswerFeedback_TaskLike` FOREIGN KEY (`LikeTypeId`) REFERENCES `net_tasklike` (`Id`),
  ADD CONSTRAINT `FK_TaskAnswerFeedback_User` FOREIGN KEY (`PlayerId`) REFERENCES `users` (`id`);

--
-- Constraints for table `net_taskmaxstep`
--
ALTER TABLE `net_taskmaxstep`
  ADD CONSTRAINT `FK_TaskMaxStep_PlayerPair` FOREIGN KEY (`PlayerPairId`) REFERENCES `net_playerpair` (`PlayerPairId`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `FK_TaskMaxStep_Task` FOREIGN KEY (`TaskId`) REFERENCES `net_tasks` (`TaskId`),
  ADD CONSTRAINT `FK_TaskMaxStep_User` FOREIGN KEY (`PlayerId`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `net_tasknotification`
--
ALTER TABLE `net_tasknotification`
  ADD CONSTRAINT `FK_TaskNotification_CompletedTask` FOREIGN KEY (`CompletedTaskId`) REFERENCES `net_completedtask` (`CompletedTaskId`),
  ADD CONSTRAINT `FK_TaskNotification_User` FOREIGN KEY (`PlayerToId`) REFERENCES `users` (`id`),
  ADD CONSTRAINT `FK_TaskNotification_UserFrom` FOREIGN KEY (`PlayerFromId`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `net_tasks`
--
ALTER TABLE `net_tasks`
  ADD CONSTRAINT `FK_Task_TaskSubSubType` FOREIGN KEY (`SubSubType`) REFERENCES `net_tasksubsubtype` (`Id`),
  ADD CONSTRAINT `FK_Task_TaskSubType` FOREIGN KEY (`SubType`) REFERENCES `net_tasksubtype` (`Id`),
  ADD CONSTRAINT `FK_Tasks_TaskAuthor` FOREIGN KEY (`Author`) REFERENCES `net_taskauthor` (`Id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `FK_Tasks_TaskStatus` FOREIGN KEY (`Status`) REFERENCES `net_taskstatus` (`Id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `FK_Tasks_TaskTypes` FOREIGN KEY (`Type`) REFERENCES `net_tasktype` (`Id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `net_tasksubsubtype`
--
ALTER TABLE `net_tasksubsubtype`
  ADD CONSTRAINT `FK_TaskSubSubType_TaskSubType` FOREIGN KEY (`SubType`) REFERENCES `net_tasksubtype` (`Id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `net_tasktext`
--
ALTER TABLE `net_tasktext`
  ADD CONSTRAINT `FK_TaskText_Languages` FOREIGN KEY (`LanguageId`) REFERENCES `net_language` (`Id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `FK_TaskText_Task` FOREIGN KEY (`TaskId`) REFERENCES `net_tasks` (`TaskId`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `net_timesfortask`
--
ALTER TABLE `net_timesfortask`
  ADD CONSTRAINT `FK_TimesForTask_Task` FOREIGN KEY (`TaskId`) REFERENCES `net_tasks` (`TaskId`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `reactions`
--
ALTER TABLE `reactions`
  ADD CONSTRAINT `fk_reactions_message_id` FOREIGN KEY (`message_id`) REFERENCES `messages` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_reactions_user_id` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `theme_settings`
--
ALTER TABLE `theme_settings`
  ADD CONSTRAINT `fk_theme_settings_theme_id` FOREIGN KEY (`theme_id`) REFERENCES `themes` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_theme_settings_wallpaper_id` FOREIGN KEY (`wallpaper_id`) REFERENCES `wallpapers` (`id`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Constraints for table `users`
--
ALTER TABLE `users`
  ADD CONSTRAINT `FK_User_Areas` FOREIGN KEY (`Area`) REFERENCES `net_areas` (`Id`),
  ADD CONSTRAINT `FK_Users_Genders` FOREIGN KEY (`Gender`) REFERENCES `net_gender` (`Id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `FK_Users_Genders_Partner` FOREIGN KEY (`PartnersGender`) REFERENCES `net_gender` (`Id`),
  ADD CONSTRAINT `FK_Users_Language` FOREIGN KEY (`LanguageId`) REFERENCES `net_language` (`Id`) ON DELETE SET NULL ON UPDATE SET NULL;

--
-- Constraints for table `user_themes`
--
ALTER TABLE `user_themes`
  ADD CONSTRAINT `fk_user_themes_theme_id` FOREIGN KEY (`theme_id`) REFERENCES `themes` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `user_wallpapers`
--
ALTER TABLE `user_wallpapers`
  ADD CONSTRAINT `fk_user_wallpapers_wallpaper_id` FOREIGN KEY (`wallpaper_id`) REFERENCES `wallpapers` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `wallpapers`
--
ALTER TABLE `wallpapers`
  ADD CONSTRAINT `fk_wallpapers_document_id` FOREIGN KEY (`document_id`) REFERENCES `documents` (`document_id`) ON DELETE SET NULL;

--
-- Constraints for table `wallpaper_settings`
--
ALTER TABLE `wallpaper_settings`
  ADD CONSTRAINT `fk_wallpaper_settings_wallpaper_id` FOREIGN KEY (`wallpaper_id`) REFERENCES `wallpapers` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
