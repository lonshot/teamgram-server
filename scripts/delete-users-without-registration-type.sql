-- Delete legacy fake accounts that never completed social registration.
-- Take and verify a full database backup before running this script.

START TRANSACTION;

CREATE TEMPORARY TABLE users_to_delete (
  id BIGINT NOT NULL PRIMARY KEY
) ENGINE=InnoDB;

INSERT INTO users_to_delete (id)
SELECT id
FROM users
WHERE RegistrationType IS NULL;

-- PWM application data with user references.
DELETE t FROM net_broadcastmessageuser t JOIN users_to_delete d ON d.id = t.UserId;
DELETE t FROM net_completedtask t JOIN users_to_delete d ON d.id = t.PlayerId;
DELETE t FROM net_taskanswerfeedback t JOIN users_to_delete d ON d.id = t.PlayerId;
DELETE t FROM net_taskmaxstep t JOIN users_to_delete d ON d.id = t.PlayerId;
DELETE t FROM net_tasknotification t JOIN users_to_delete d ON d.id = t.PlayerFromId OR d.id = t.PlayerToId;
DELETE t FROM net_playerpair t JOIN users_to_delete d ON d.id = t.Player1 OR d.id = t.Player2;
DELETE t FROM net_loginsession t JOIN users_to_delete d ON d.id = t.UserId;
DELETE t FROM net_mediacomment t JOIN users_to_delete d ON d.id = t.UserId;
DELETE t FROM net_news t JOIN users_to_delete d ON d.id = t.UserId;
DELETE t FROM net_newscomment t JOIN users_to_delete d ON d.id = t.UserId;
DELETE t FROM net_offensivereport t JOIN users_to_delete d ON d.id = t.PlayerId;
DELETE t FROM net_taskanswerfeedback t JOIN users_to_delete d ON d.id = t.PlayerId;
DELETE t FROM net_userblock t JOIN users_to_delete d ON d.id = t.UserId;
DELETE t FROM net_userdislike t JOIN users_to_delete d ON d.id = t.UserId;
DELETE t FROM net_userreport t JOIN users_to_delete d ON d.id = t.UserId;
DELETE t FROM net_usertracking t JOIN users_to_delete d ON d.id = t.UserId;

-- ASP.NET Identity data, where the user ID is stored as text.
DELETE t FROM identify_user_claims t JOIN users_to_delete d ON t.UserId = CAST(d.id AS CHAR);
DELETE t FROM identify_user_logins t JOIN users_to_delete d ON t.UserId = CAST(d.id AS CHAR);
DELETE t FROM identify_user_roles t JOIN users_to_delete d ON t.UserId = CAST(d.id AS CHAR);
DELETE t FROM identify_user_tokens t JOIN users_to_delete d ON t.UserId = CAST(d.id AS CHAR);

-- PWM server / MTProto data keyed by user ID.
DELETE t FROM auth_seq_updates t JOIN users_to_delete d ON d.id = t.user_id;
DELETE t FROM auth_users t JOIN users_to_delete d ON d.id = t.user_id;
DELETE t FROM bots t JOIN users_to_delete d ON d.id = t.creator_user_id;
DELETE t FROM chat_invite_participants t JOIN users_to_delete d ON d.id = t.user_id;
DELETE t FROM chat_participants t JOIN users_to_delete d ON d.id = t.user_id OR d.id = t.inviter_user_id;
DELETE t FROM devices t JOIN users_to_delete d ON d.id = t.user_id;
DELETE t FROM dialogs t JOIN users_to_delete d ON d.id = t.user_id;
DELETE t FROM dialog_filters t JOIN users_to_delete d ON d.id = t.user_id;
DELETE t FROM hash_tags t JOIN users_to_delete d ON d.id = t.user_id;
DELETE t FROM imported_contacts t JOIN users_to_delete d ON d.id = t.user_id OR d.id = t.imported_user_id;
DELETE t FROM messages t JOIN users_to_delete d ON d.id = t.user_id;
DELETE t FROM phone_books t JOIN users_to_delete d ON d.id = t.user_id;
DELETE t FROM reactions t JOIN users_to_delete d ON d.id = t.user_id;
DELETE t FROM saved_dialogs t JOIN users_to_delete d ON d.id = t.user_id;
DELETE t FROM user_global_privacy_settings t JOIN users_to_delete d ON d.id = t.user_id;
DELETE t FROM user_notify_settings t JOIN users_to_delete d ON d.id = t.user_id;
DELETE t FROM user_peer_blocks t JOIN users_to_delete d ON d.id = t.user_id;
DELETE t FROM user_peer_settings t JOIN users_to_delete d ON d.id = t.user_id;
DELETE t FROM user_preferences t JOIN users_to_delete d ON d.id = t.user_id;
DELETE t FROM user_presences t JOIN users_to_delete d ON d.id = t.user_id;
DELETE t FROM user_privacies t JOIN users_to_delete d ON d.id = t.user_id;
DELETE t FROM user_profile_photos t JOIN users_to_delete d ON d.id = t.user_id;
DELETE t FROM user_pts_updates t JOIN users_to_delete d ON d.id = t.user_id;
DELETE t FROM user_settings t JOIN users_to_delete d ON d.id = t.user_id;
DELETE t FROM user_themes t JOIN users_to_delete d ON d.id = t.user_id;
DELETE t FROM user_wallpapers t JOIN users_to_delete d ON d.id = t.user_id;

DELETE u
FROM users u
JOIN users_to_delete d ON d.id = u.id;

COMMIT;
