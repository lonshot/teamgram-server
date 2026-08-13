package dao

import (
	"bytes"
	"context"
	"crypto/sha256"
	"encoding/json"
	"fmt"
	"html"
	"regexp"
	"strings"

	"github.com/google/uuid"
	"github.com/teamgram/marmota/pkg/stores/sqlx"
)

type GameAnswerCommandDO struct {
	RequestId    int64  `json:"requestId"`
	GameConfigId int64  `json:"gameConfigId"`
	PairGameId   int64  `json:"pairGameId"`
	ChainTaskId  string `json:"chainTaskId"`
	Answer       string `json:"answer"`
	AttachedText string `json:"attachedText"`
	MediaPath    string `json:"mediaPath"`
}

type GameProgressDO struct {
	TotalConfigs     int64 `json:"totalConfigs"`
	Player1Id        int64 `json:"player1Id"`
	Player1Completed int64 `json:"player1Completed"`
	Player2Id        int64 `json:"player2Id"`
	Player2Completed int64 `json:"player2Completed"`
}

type GameTaskAnswerPresentationDO struct {
	Version         int    `json:"version"`
	TaskAnswerId    int64  `json:"taskAnswerId"`
	CompletedTaskId int64  `json:"completedTaskId"`
	ActorUserId     int64  `json:"actorUserId"`
	PlayerPairId    int64  `json:"playerPairId"`
	PairGameId      int64  `json:"pairGameId"`
	GameConfigId    int64  `json:"gameConfigId"`
	TaskId          string `json:"taskId"`
	ChainTaskId     string `json:"chainTaskId,omitempty"`
	TaskTypeName    string `json:"taskTypeName"`
	Kind            string `json:"kind"`
	Title           string `json:"title"`
	MainTitle       string `json:"mainTitle,omitempty"`
	Subtitle        string `json:"subtitle,omitempty"`
	AnswerText      string `json:"answerText"`
	MediaPath       string `json:"mediaPath,omitempty"`
}

type GameAnswerResultDO struct {
	Version            int                           `json:"version"`
	Accepted           bool                          `json:"accepted"`
	NewlyRecorded      bool                          `json:"newlyRecorded"`
	ConfigComplete     bool                          `json:"configComplete"`
	GameFinished       bool                          `json:"gameFinished"`
	GameNewlyFinished  bool                          `json:"gameNewlyFinished"`
	WaitingForPlayerId *int64                        `json:"waitingForPlayerId"`
	CompletedTaskId    int64                         `json:"completedTaskId"`
	TaskAnswerId       int64                         `json:"taskAnswerId"`
	Presentation       *GameTaskAnswerPresentationDO `json:"presentation"`
	Progress           GameProgressDO                `json:"progress"`
	NextTask           *GameTaskResultDO             `json:"nextTask"`
	Cursor             uint64                        `json:"cursor"`
}

var (
	taskAnswerBreakPattern = regexp.MustCompile(`(?i)<br\s*/?>`)
	taskAnswerTagPattern   = regexp.MustCompile(`<[^>]*>`)
)

func taskAnswerKind(taskTypeName string) string {
	switch strings.ToLower(strings.TrimSpace(taskTypeName)) {
	case "q-2":
		return "question_2"
	case "q-3":
		return "question_3"
	case "q-4":
		return "question_4"
	case "fill text":
		return "fill_text"
	case "photo":
		return "photo"
	case "video":
		return "video"
	case "voice":
		return "voice"
	default:
		return "unknown"
	}
}

func plainTaskAnswerText(value string) string {
	value = taskAnswerBreakPattern.ReplaceAllString(value, "\n")
	value = taskAnswerTagPattern.ReplaceAllString(value, "")
	return strings.TrimSpace(html.UnescapeString(value))
}

func buildTaskAnswerPresentation(actorId int64, locked *gameLockedPairState,
	in GameAnswerCommandDO, task *GameTaskDO, completedTaskId, taskAnswerId int64) *GameTaskAnswerPresentationDO {
	return &GameTaskAnswerPresentationDO{
		Version:         1,
		TaskAnswerId:    taskAnswerId,
		CompletedTaskId: completedTaskId,
		ActorUserId:     actorId,
		PlayerPairId:    locked.PlayerPairId,
		PairGameId:      locked.PairGameId,
		GameConfigId:    in.GameConfigId,
		TaskId:          task.TaskId,
		ChainTaskId:     task.ChainTaskId,
		TaskTypeName:    task.TaskTypeName,
		Kind:            taskAnswerKind(task.TaskTypeName),
		Title:           plainTaskAnswerText(task.Title),
		MainTitle:       plainTaskAnswerText(task.MainTitle),
		Subtitle:        plainTaskAnswerText(task.ChainCommonTitle),
		AnswerText:      plainTaskAnswerText(in.Answer),
		MediaPath:       in.MediaPath,
	}
}

type gameCommandState struct {
	Id            uint64 `db:"id"`
	PayloadHash   []byte `db:"payload_hash"`
	Status        int    `db:"status"`
	ResultPayload string `db:"result_payload"`
}

type gameLockedPairState struct {
	PairGameId        int64 `db:"pair_game_id"`
	PlayerPairId      int64 `db:"player_pair_id"`
	GameId            int64 `db:"game_id"`
	Player1           int64 `db:"player1"`
	Player2           int64 `db:"player2"`
	CurrentPairGameId int64 `db:"current_pair_game_id"`
	ActorActive       int   `db:"actor_active"`
	ActorDeleted      int   `db:"actor_deleted"`
	PartnerId         int64 `db:"partner_id"`
	PartnerActive     int   `db:"partner_active"`
	PartnerDeleted    int   `db:"partner_deleted"`
	PartnerGender     int   `db:"partner_gender"`
	PairGameActive    int   `db:"pair_game_active"`
	PairGameFinished  int   `db:"pair_game_finished"`
	PairActive        int   `db:"pair_active"`
	PairStatus        int   `db:"pair_status"`
}

func selectLockedGamePair(tx *sqlx.Tx, actorId, pairGameId int64) (*gameLockedPairState, error) {
	row := new(gameLockedPairState)
	err := tx.QueryRowPartial(row, `SELECT pg.PairGameId AS pair_game_id,
		pp.PlayerPairId AS player_pair_id, pg.GameId AS game_id,
		pp.Player1 AS player1, pp.Player2 AS player2,
		COALESCE(pp.CurrentPairGameId, 0) AS current_pair_game_id,
		COALESCE(actor.Active, 0) AS actor_active, actor.deleted AS actor_deleted,
		partner.id AS partner_id, COALESCE(partner.Active, 0) AS partner_active,
		partner.deleted AS partner_deleted, COALESCE(partner.Gender, 0) AS partner_gender,
		COALESCE(pg.IsActive, 0) AS pair_game_active,
		COALESCE(pg.IsFinished, 0) AS pair_game_finished,
		COALESCE(pp.IsActive, 0) AS pair_active,
		COALESCE(pp.Status, 1) AS pair_status
		FROM net_pairgame pg
		JOIN net_playerpair pp ON pp.PlayerPairId = pg.PlayerPairId
		JOIN users actor ON actor.id = ?
			AND actor.id IN (pp.Player1, pp.Player2)
		JOIN users partner ON partner.id =
			IF(pp.Player1 = actor.id, pp.Player2, pp.Player1)
		WHERE pg.PairGameId = ?
		FOR UPDATE`, actorId, pairGameId)
	if err != nil {
		if isGameNotFound(err) {
			return nil, nil
		}
		return nil, err
	}
	return row, nil
}

func claimGameCommand(tx *sqlx.Tx, actorId int64, in GameAnswerCommandDO) (*gameCommandState, []byte, error) {
	payload, err := json.Marshal(in)
	if err != nil {
		return nil, nil, err
	}
	hash := sha256.Sum256(payload)
	commandKey := fmt.Sprintf("pwm.submitAnswer:%d:%d", actorId, in.RequestId)
	if _, err := tx.Exec(`INSERT IGNORE INTO game_commands
		(command_key, command_type, actor_user_id, pair_game_id, game_config_id,
		 chain_task_id, payload, payload_hash, status)
		VALUES (?, 'pwm.submitAnswer', ?, ?, ?, NULLIF(?, ''), ?, ?, 0)`,
		commandKey, actorId, in.PairGameId, in.GameConfigId, in.ChainTaskId,
		string(payload), hash[:]); err != nil {
		return nil, nil, err
	}
	row := new(gameCommandState)
	if err := tx.QueryRowPartial(row, `SELECT id, payload_hash, status,
		COALESCE(result_payload, '') AS result_payload
		FROM game_commands WHERE command_key = ? FOR UPDATE`, commandKey); err != nil {
		return nil, nil, err
	}
	if !bytes.Equal(row.PayloadHash, hash[:]) {
		return nil, nil, ErrGameCommandConflict
	}
	return row, payload, nil
}

func replayGameCommand(command *gameCommandState) (*GameAnswerResultDO, bool, error) {
	if command.Status != 1 || command.ResultPayload == "" {
		return nil, false, nil
	}
	result := new(GameAnswerResultDO)
	if err := json.Unmarshal([]byte(command.ResultPayload), result); err != nil {
		return nil, false, err
	}
	return result, true, nil
}

func insertLegacyAnswer(tx *sqlx.Tx, actorId int64, locked *gameLockedPairState,
	taskId, parentChainId, childTaskId string, in GameAnswerCommandDO) (int64, int64, error) {
	var chainValue interface{}
	if parentChainId != "" {
		chainValue = parentChainId
	}
	completed, err := tx.Exec(`INSERT INTO net_completedtask
		(PairGameId, PlayerId, Timestamp, GameConfigId, ChainTaskId, TaskId)
		VALUES (?, ?, CURRENT_TIMESTAMP, ?, ?, ?)`,
		locked.PairGameId, actorId, in.GameConfigId, chainValue, taskId)
	if err != nil {
		return 0, 0, err
	}
	completedTaskId, err := completed.LastInsertId()
	if err != nil {
		return 0, 0, err
	}
	answer, err := tx.Exec(`INSERT INTO net_taskanswer
		(OrderNumber, CompletedTaskId, AttachedText, AnswerText, MediaPath,
		 Timestamp, Score, Offensive)
		VALUES (0, ?, ?, ?, ?, CURRENT_TIMESTAMP, 0, '')`,
		completedTaskId, in.AttachedText, in.Answer, in.MediaPath)
	if err != nil {
		return 0, 0, err
	}
	taskAnswerId, err := answer.LastInsertId()
	if err != nil {
		return 0, 0, err
	}
	if parentChainId != "" {
		if _, err := tx.Exec(`INSERT INTO net_completedchain
			(ChainId, TaskId, CompletedTaskId) VALUES (?, ?, ?)`,
			parentChainId, childTaskId, completedTaskId); err != nil {
			return 0, 0, err
		}
	}
	return completedTaskId, taskAnswerId, nil
}

func selectGameProgress(q gameQuery, pairGameId, gameId, player1Id, player2Id int64) (GameProgressDO, error) {
	progress := GameProgressDO{
		Player1Id: player1Id,
		Player2Id: player2Id,
	}
	if err := q.QueryRow(&progress.TotalConfigs, `SELECT COUNT(*)
        FROM net_gameconfig WHERE GameId = ?`, gameId); err != nil {
		return progress, err
	}
	if err := q.QueryRow(&progress.Player1Completed, `SELECT COUNT(*)
        FROM game_config_completions gcc
        JOIN net_gameconfig gc ON gc.Id = gcc.game_config_id
        WHERE gcc.pair_game_id = ? AND gcc.player_id = ? AND gc.GameId = ?`,
		pairGameId, player1Id, gameId); err != nil {
		return progress, err
	}
	if err := q.QueryRow(&progress.Player2Completed, `SELECT COUNT(*)
        FROM game_config_completions gcc
        JOIN net_gameconfig gc ON gc.Id = gcc.game_config_id
        WHERE gcc.pair_game_id = ? AND gcc.player_id = ? AND gc.GameId = ?`,
		pairGameId, player2Id, gameId); err != nil {
		return progress, err
	}
	return progress, nil
}

type gameEventRecipient struct {
	UserId int64  `json:"userId"`
	Cursor uint64 `json:"cursor"`
}

func insertGameEvents(tx *sqlx.Tx, commandId uint64, actorId int64,
	locked *gameLockedPairState, in GameAnswerCommandDO, completedTaskId,
	taskAnswerId int64, presentation *GameTaskAnswerPresentationDO,
	gameFinished bool, progress GameProgressDO) (uint64, error) {
	eventId := uuid.NewString()
	eventType := "pwm.game.answer_submitted"
	if gameFinished {
		eventType = "pwm.game.finished"
	}
	eventPayload, err := json.Marshal(map[string]interface{}{
		"version":         2,
		"actorUserId":     actorId,
		"playerPairId":    locked.PlayerPairId,
		"pairGameId":      locked.PairGameId,
		"gameConfigId":    in.GameConfigId,
		"completedTaskId": completedTaskId,
		"taskAnswerId":    taskAnswerId,
		"presentation":    presentation,
		"gameFinished":    gameFinished,
		"progress":        progress,
	})
	if err != nil {
		return 0, err
	}
	recipients := make([]gameEventRecipient, 0, 2)
	var actorCursor uint64
	for _, recipientId := range []int64{locked.Player1, locked.Player2} {
		inserted, err := tx.Exec(`INSERT INTO game_events
			(event_id, command_id, recipient_user_id, event_type,
			 aggregate_type, aggregate_id, payload)
			VALUES (?, ?, ?, ?, 'pair_game', ?, ?)`,
			eventId, commandId, recipientId, eventType,
			fmt.Sprintf("%d", locked.PairGameId), string(eventPayload))
		if err != nil {
			return 0, err
		}
		cursor, err := inserted.LastInsertId()
		if err != nil {
			return 0, err
		}
		recipients = append(recipients, gameEventRecipient{
			UserId: recipientId,
			Cursor: uint64(cursor),
		})
		if recipientId == actorId {
			actorCursor = uint64(cursor)
		}
	}
	outboxPayload, err := json.Marshal(map[string]interface{}{
		"version":       1,
		"eventId":       eventId,
		"eventType":     eventType,
		"aggregateType": "pair_game",
		"aggregateId":   fmt.Sprintf("%d", locked.PairGameId),
		"recipients":    recipients,
	})
	if err != nil {
		return 0, err
	}
	if _, err := tx.Exec(`INSERT INTO game_outbox
		(event_id, command_id, event_type, payload)
		VALUES (?, ?, ?, ?)`, eventId, commandId, eventType, string(outboxPayload)); err != nil {
		return 0, err
	}
	return actorCursor, nil
}

func (d *Dao) SubmitGameAnswer(ctx context.Context, actorId int64, in GameAnswerCommandDO) (*GameAnswerResultDO, error) {
	var result *GameAnswerResultDO
	err := d.db.Transact(ctx, func(tx *sqlx.Tx) error {
		command, _, err := claimGameCommand(tx, actorId, in)
		if err != nil {
			return err
		}
		if replay, ok, err := replayGameCommand(command); err != nil {
			return err
		} else if ok {
			result = replay
			return nil
		}

		locked, err := selectLockedGamePair(tx, actorId, in.PairGameId)
		if err != nil {
			return err
		}
		if locked == nil || locked.CurrentPairGameId != locked.PairGameId ||
			locked.PairActive != 1 || locked.PairStatus != 1 {
			return ErrGamePairInvalid
		}
		if locked.ActorActive != 1 || locked.ActorDeleted != 0 {
			return ErrGameActorInvalid
		}
		if locked.PartnerActive != 1 || locked.PartnerDeleted != 0 {
			return ErrGamePartnerInvalid
		}
		if locked.PairGameActive != 1 || locked.PairGameFinished == 1 {
			return ErrGameTaskInvalid
		}

		next, err := selectNextGameTask(tx, actorId, locked.PartnerId, locked.PlayerPairId)
		if err != nil {
			return err
		}
		if next == nil || !next.HasTask || next.Task == nil ||
			next.Task.PairGameId != in.PairGameId ||
			next.Task.GameConfigId != in.GameConfigId {
			return ErrGameTaskInvalid
		}
		if next.Task.ChainTaskId != in.ChainTaskId {
			return ErrGameTaskInvalid
		}

		config := new(gameConfigState)
		if err := tx.QueryRowPartial(config, `SELECT Id AS id, GameId AS game_id,
			COALESCE(TaskForM, '') AS task_for_m, COALESCE(TaskForF, '') AS task_for_f
			FROM net_gameconfig WHERE Id = ? AND GameId = ? FOR UPDATE`,
			in.GameConfigId, locked.GameId); err != nil {
			if isGameNotFound(err) {
				return ErrGameTaskInvalid
			}
			return err
		}
		parentTaskId := taskIdForActor(*config, locked.PartnerGender)
		parentTask, err := selectGameTaskState(tx, parentTaskId)
		if err != nil {
			return err
		}
		if parentTask == nil {
			return ErrGameTaskInvalid
		}
		isChain := next.Task.ChainTaskId != ""
		if isChain {
			var validChild int
			if err := tx.QueryRow(&validChild, `SELECT EXISTS(
				SELECT 1 FROM net_chain
				WHERE ChainId = ? AND TaskId = ?)`,
				parentTaskId, in.ChainTaskId); err != nil {
				return err
			}
			if validChild != 1 {
				return ErrGameTaskInvalid
			}
			inserted, err := tx.Exec(`INSERT IGNORE INTO game_chain_submissions
				(command_id, pair_game_id, game_config_id, player_id,
				 chain_id, child_task_id)
				VALUES (?, ?, ?, ?, ?, ?)`,
				command.Id, locked.PairGameId, in.GameConfigId, actorId,
				parentTaskId, in.ChainTaskId)
			if err != nil {
				return err
			}
			rows, err := inserted.RowsAffected()
			if err != nil {
				return err
			}
			if rows != 1 {
				return ErrGameTaskInvalid
			}
		} else {
			inserted, err := tx.Exec(`INSERT IGNORE INTO game_config_completions
				(command_id, pair_game_id, game_config_id, player_id,
				 task_id, completion_kind)
				VALUES (?, ?, ?, ?, ?, 1)`,
				command.Id, locked.PairGameId, in.GameConfigId, actorId,
				parentTaskId)
			if err != nil {
				return err
			}
			rows, err := inserted.RowsAffected()
			if err != nil {
				return err
			}
			if rows != 1 {
				return ErrGameTaskInvalid
			}
		}

		completedTaskId, taskAnswerId, err := insertLegacyAnswer(
			tx, actorId, locked, parentTaskId,
			func() string {
				if isChain {
					return parentTaskId
				}
				return ""
			}(),
			in.ChainTaskId,
			in,
		)
		if err != nil {
			return err
		}
		configComplete := !isChain
		if isChain {
			if _, err := tx.Exec(`UPDATE game_chain_submissions
				SET completed_task_id = ?, task_answer_id = ?
				WHERE command_id = ?`,
				completedTaskId, taskAnswerId, command.Id); err != nil {
				return err
			}
			var childCount, submittedCount int64
			if err := tx.QueryRow(&childCount, `SELECT COUNT(DISTINCT TaskId)
				FROM net_chain WHERE ChainId = ?`, parentTaskId); err != nil {
				return err
			}
			if err := tx.QueryRow(&submittedCount, `SELECT COUNT(DISTINCT child_task_id)
				FROM game_chain_submissions
				WHERE pair_game_id = ? AND game_config_id = ?
				AND player_id = ? AND chain_id = ?`,
				locked.PairGameId, in.GameConfigId, actorId, parentTaskId); err != nil {
				return err
			}
			configComplete = childCount > 0 && submittedCount == childCount
			if configComplete {
				if _, err := tx.Exec(`INSERT IGNORE INTO game_config_completions
					(command_id, pair_game_id, game_config_id, player_id,
					 task_id, completion_kind, completed_task_id)
					VALUES (?, ?, ?, ?, ?, 2, ?)`,
					command.Id, locked.PairGameId, in.GameConfigId, actorId,
					parentTaskId, completedTaskId); err != nil {
					return err
				}
			}
		} else {
			if _, err := tx.Exec(`UPDATE game_config_completions
				SET completed_task_id = ? WHERE command_id = ?`,
				completedTaskId, command.Id); err != nil {
				return err
			}
		}

		progress, err := selectGameProgress(tx, locked.PairGameId, locked.GameId, locked.Player1, locked.Player2)
		if err != nil {
			return err
		}
		gameFinished := progress.TotalConfigs > 0 &&
			progress.Player1Completed == progress.TotalConfigs &&
			progress.Player2Completed == progress.TotalConfigs
		gameNewlyFinished := false
		if gameFinished {
			updated, err := tx.Exec(`UPDATE net_pairgame
				SET IsFinished = 1
				WHERE PairGameId = ? AND (IsFinished IS NULL OR IsFinished <> 1)`,
				locked.PairGameId)
			if err != nil {
				return err
			}
			rows, err := updated.RowsAffected()
			if err != nil {
				return err
			}
			gameNewlyFinished = rows == 1
			if _, err := tx.Exec(`UPDATE net_playerpair
				SET ContinueByPlayer1 = 0, ContinueByPlayer2 = 0
				WHERE PlayerPairId = ?`, locked.PlayerPairId); err != nil {
				return err
			}
		}

		nextAfter, err := selectNextGameTask(tx, actorId, locked.PartnerId, locked.PlayerPairId)
		if err != nil {
			return err
		}
		var waitingFor *int64
		if nextAfter != nil {
			waitingFor = nextAfter.WaitingForPlayerId
		}
		presentation := buildTaskAnswerPresentation(
			actorId, locked, in, next.Task, completedTaskId, taskAnswerId,
		)
		cursor, err := insertGameEvents(tx, command.Id, actorId, locked, in,
			completedTaskId, taskAnswerId, presentation, gameFinished, progress)
		if err != nil {
			return err
		}
		result = &GameAnswerResultDO{
			Version:            2,
			Accepted:           true,
			NewlyRecorded:      true,
			ConfigComplete:     configComplete,
			GameFinished:       gameFinished,
			GameNewlyFinished:  gameNewlyFinished,
			WaitingForPlayerId: waitingFor,
			CompletedTaskId:    completedTaskId,
			TaskAnswerId:       taskAnswerId,
			Presentation:       presentation,
			Progress:           progress,
			NextTask:           nextAfter,
			Cursor:             cursor,
		}
		responsePayload, err := json.Marshal(result)
		if err != nil {
			return err
		}
		if _, err := tx.Exec(`UPDATE game_commands SET
			player_pair_id = ?, pair_game_id = ?, game_config_id = ?,
			task_id = ?, chain_task_id = NULLIF(?, ''),
			completed_task_id = ?, task_answer_id = ?,
			status = 1, result_payload = ?, error_code = NULL,
			applied_at = CURRENT_TIMESTAMP
			WHERE id = ?`,
			locked.PlayerPairId, locked.PairGameId, in.GameConfigId,
			parentTaskId, in.ChainTaskId, completedTaskId, taskAnswerId,
			string(responsePayload), command.Id); err != nil {
			return err
		}
		return nil
	})
	return result, err
}
