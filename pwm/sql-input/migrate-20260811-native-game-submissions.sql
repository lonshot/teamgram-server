USE pwm;

CREATE TABLE IF NOT EXISTS game_config_completions (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  command_id BIGINT UNSIGNED DEFAULT NULL COMMENT 'NULL only for legacy backfill',
  pair_game_id INT NOT NULL,
  game_config_id INT NOT NULL,
  player_id BIGINT NOT NULL,
  task_id VARCHAR(50) NOT NULL,
  completion_kind TINYINT UNSIGNED NOT NULL COMMENT '1=ordinary, 2=chain',
  completed_task_id INT DEFAULT NULL COMMENT 'Legacy compatibility projection',
  completed_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  UNIQUE KEY uk_game_config_completion (pair_game_id, game_config_id, player_id),
  UNIQUE KEY uk_game_config_completion_command (command_id),
  KEY idx_game_config_completion_player (player_id, pair_game_id, game_config_id),
  CONSTRAINT fk_game_config_completion_command
    FOREIGN KEY (command_id) REFERENCES game_commands (id)
    ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS game_chain_submissions (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  command_id BIGINT UNSIGNED DEFAULT NULL COMMENT 'NULL only for legacy backfill',
  pair_game_id INT NOT NULL,
  game_config_id INT NOT NULL,
  player_id BIGINT NOT NULL,
  chain_id VARCHAR(50) NOT NULL,
  child_task_id VARCHAR(50) NOT NULL,
  completed_task_id INT DEFAULT NULL COMMENT 'Legacy compatibility projection',
  task_answer_id INT DEFAULT NULL COMMENT 'Legacy compatibility projection',
  submitted_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  UNIQUE KEY uk_game_chain_submission
    (pair_game_id, game_config_id, player_id, chain_id, child_task_id),
  UNIQUE KEY uk_game_chain_submission_command (command_id),
  KEY idx_game_chain_submission_progress
    (pair_game_id, game_config_id, player_id, chain_id),
  CONSTRAINT fk_game_chain_submission_command
    FOREIGN KEY (command_id) REFERENCES game_commands (id)
    ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT IGNORE INTO game_chain_submissions
  (command_id, pair_game_id, game_config_id, player_id, chain_id,
   child_task_id, completed_task_id, task_answer_id, submitted_at)
SELECT NULL, ct.PairGameId, ct.GameConfigId, ct.PlayerId, cc.ChainId,
  cc.TaskId, MIN(ct.CompletedTaskId), MIN(ta.Id),
  COALESCE(MIN(ct.Timestamp), CURRENT_TIMESTAMP)
FROM net_completedtask ct
JOIN net_completedchain cc ON cc.CompletedTaskId = ct.CompletedTaskId
LEFT JOIN net_taskanswer ta ON ta.CompletedTaskId = ct.CompletedTaskId
WHERE ct.GameConfigId IS NOT NULL AND ct.PlayerId IS NOT NULL
GROUP BY ct.PairGameId, ct.GameConfigId, ct.PlayerId, cc.ChainId, cc.TaskId;

INSERT IGNORE INTO game_config_completions
  (command_id, pair_game_id, game_config_id, player_id, task_id,
   completion_kind, completed_task_id, completed_at)
SELECT NULL, ct.PairGameId, ct.GameConfigId, ct.PlayerId,
  IF(partner.Gender = 2, gc.TaskForM, gc.TaskForF),
  1, MIN(ct.CompletedTaskId), COALESCE(MIN(ct.Timestamp), CURRENT_TIMESTAMP)
FROM net_completedtask ct
JOIN net_pairgame pg ON pg.PairGameId = ct.PairGameId
JOIN net_playerpair pp ON pp.PlayerPairId = pg.PlayerPairId
JOIN users partner
  ON partner.id = IF(pp.Player1 = ct.PlayerId, pp.Player2, pp.Player1)
JOIN net_gameconfig gc
  ON gc.Id = ct.GameConfigId AND gc.GameId = pg.GameId
WHERE ct.GameConfigId IS NOT NULL
  AND ct.PlayerId IN (pp.Player1, pp.Player2)
  AND NOT EXISTS (
    SELECT 1 FROM net_chain c
    WHERE c.ChainId = IF(partner.Gender = 2, gc.TaskForM, gc.TaskForF)
  )
GROUP BY ct.PairGameId, ct.GameConfigId, ct.PlayerId,
  IF(partner.Gender = 2, gc.TaskForM, gc.TaskForF);

INSERT IGNORE INTO game_config_completions
  (command_id, pair_game_id, game_config_id, player_id, task_id,
   completion_kind, completed_task_id, completed_at)
SELECT NULL, gcs.pair_game_id, gcs.game_config_id, gcs.player_id,
  gcs.chain_id, 2, MIN(gcs.completed_task_id), MIN(gcs.submitted_at)
FROM game_chain_submissions gcs
JOIN net_chain c
  ON c.ChainId COLLATE utf8mb4_unicode_ci = gcs.chain_id
GROUP BY gcs.pair_game_id, gcs.game_config_id, gcs.player_id, gcs.chain_id
HAVING COUNT(DISTINCT gcs.child_task_id) >= COUNT(DISTINCT c.TaskId);

INSERT IGNORE INTO schema_migrations (version)
VALUES ('20260811-native-game-submissions');
