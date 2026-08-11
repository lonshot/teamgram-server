package dao

import (
	"context"
	"database/sql"
	"errors"
	"strings"

	"github.com/teamgram/marmota/pkg/stores/sqlx"
)

var (
	ErrGameActorInvalid    = errors.New("game actor is inactive or deleted")
	ErrGamePartnerInvalid  = errors.New("game partner is inactive or deleted")
	ErrGamePairInvalid     = errors.New("game pair is invalid")
	ErrGameTaskInvalid     = errors.New("game task is invalid")
	ErrGameCommandConflict = errors.New("game command payload conflicts with an existing request")
)

type GameTaskQuestionDO struct {
	Type     int    `json:"Type"`
	Text     string `json:"Text"`
	Selected bool   `json:"Selected"`
}

type GameTaskDO struct {
	CommonDescription string               `json:"CommonDescription"`
	TaskId            string               `json:"TaskId"`
	Order             int                  `json:"Order"`
	LangId            int                  `json:"LangId"`
	Score             int                  `json:"Score"`
	Title             string               `json:"Title"`
	CompletedId       int                  `json:"CompletedId"`
	TaskTypeName      string               `json:"TaskTypeName"`
	Questions         []GameTaskQuestionDO `json:"Questions"`
	GameConfigId      int64                `json:"GameConfigId"`
	PairGameId        int64                `json:"PairGameId"`
	PlayPairId        int64                `json:"PlayPairId"`
	MainTitle         string               `json:"MainTitle"`
	ChainCommonTitle  string               `json:"ChainCommonTitle"`
	ChainTaskId       string               `json:"ChainTaskId"`
	PartnerCompleted  bool                 `json:"PartnerCompleted"`
}

type GameTaskResultDO struct {
	Version            int         `json:"version"`
	HasTask            bool        `json:"hasTask"`
	Reason             string      `json:"reason,omitempty"`
	WaitingForPlayerId *int64      `json:"waitingForPlayerId,omitempty"`
	Task               *GameTaskDO `json:"task"`
}

type gameQuery interface {
	QueryRowPartial(v interface{}, query string, args ...interface{}) error
	QueryRowsPartial(v interface{}, query string, args ...interface{}) error
	QueryRow(v interface{}, query string, args ...interface{}) error
}

type gameDBQuery struct {
	ctx context.Context
	db  *sqlx.DB
}

func (q gameDBQuery) QueryRowPartial(v interface{}, query string, args ...interface{}) error {
	return q.db.QueryRowPartial(q.ctx, v, query, args...)
}

func (q gameDBQuery) QueryRowsPartial(v interface{}, query string, args ...interface{}) error {
	return q.db.QueryRowsPartial(q.ctx, v, query, args...)
}

func (q gameDBQuery) QueryRow(v interface{}, query string, args ...interface{}) error {
	return q.db.QueryRow(q.ctx, v, query, args...)
}

type gameUserState struct {
	Id         int64 `db:"id"`
	Gender     int   `db:"gender"`
	LanguageId int   `db:"language_id"`
	Active     int   `db:"active"`
	Deleted    int   `db:"deleted"`
}

type gamePairState struct {
	PlayerPairId      int64 `db:"player_pair_id"`
	Player1           int64 `db:"player1"`
	Player2           int64 `db:"player2"`
	CurrentPairGameId int64 `db:"current_pair_game_id"`
}

type gamePairGameState struct {
	PairGameId   int64 `db:"pair_game_id"`
	PlayerPairId int64 `db:"player_pair_id"`
	GameId       int64 `db:"game_id"`
}

type gameConfigState struct {
	Id       int64  `db:"id"`
	GameId   int64  `db:"game_id"`
	TaskForM string `db:"task_for_m"`
	TaskForF string `db:"task_for_f"`
}

type gameTaskState struct {
	Order        int    `db:"order2"`
	TaskId       string `db:"task_id"`
	Score        int    `db:"score"`
	Title        string `db:"title"`
	TaskTypeName string `db:"task_type_name"`
}

type gameTaskTextState struct {
	TextForM          string `db:"text_for_m"`
	TextForF          string `db:"text_for_f"`
	CommonDescription string `db:"common_description"`
}

type gameChainChildState struct {
	Id     int64  `db:"id"`
	TaskId string `db:"task_id"`
}

type gameCompletionState struct {
	PlayerId int64 `db:"player_id"`
}

type gameChainCompletionState struct {
	PlayerId    int64  `db:"player_id"`
	ChildTaskId string `db:"child_task_id"`
}

func isGameNotFound(err error) bool {
	return errors.Is(err, sqlx.ErrNotFound) || errors.Is(err, sql.ErrNoRows)
}

func selectGameUser(q gameQuery, userId int64) (*gameUserState, error) {
	row := new(gameUserState)
	err := q.QueryRowPartial(row, `SELECT id, COALESCE(Gender, 0) AS gender,
		COALESCE(LanguageId, 1) AS language_id, COALESCE(Active, 0) AS active,
		deleted FROM users WHERE id = ?`, userId)
	if err != nil {
		if isGameNotFound(err) {
			return nil, nil
		}
		return nil, err
	}
	return row, nil
}

func selectGamePair(q gameQuery, actorId, partnerId, requestedPairId int64) (*gamePairState, error) {
	query := `SELECT pp.PlayerPairId AS player_pair_id, pp.Player1 AS player1,
		pp.Player2 AS player2, COALESCE(pp.CurrentPairGameId, 0) AS current_pair_game_id
		FROM net_playerpair pp
		WHERE pp.IsActive = 1 AND (pp.Status IS NULL OR pp.Status = 1)
		AND ((pp.Player1 = ? AND pp.Player2 = ?) OR (pp.Player1 = ? AND pp.Player2 = ?))`
	args := []interface{}{actorId, partnerId, partnerId, actorId}
	if requestedPairId > 0 {
		query += " AND pp.PlayerPairId = ?"
		args = append(args, requestedPairId)
	}
	query += " ORDER BY pp.PlayerPairId DESC LIMIT 1"
	row := new(gamePairState)
	if err := q.QueryRowPartial(row, query, args...); err != nil {
		if isGameNotFound(err) {
			return nil, nil
		}
		return nil, err
	}
	return row, nil
}

func selectActivePairGame(q gameQuery, pair *gamePairState) (*gamePairGameState, error) {
	if pair.CurrentPairGameId <= 0 {
		return nil, nil
	}
	row := new(gamePairGameState)
	err := q.QueryRowPartial(row, `SELECT PairGameId AS pair_game_id,
		PlayerPairId AS player_pair_id, GameId AS game_id
		FROM net_pairgame
		WHERE PairGameId = ? AND PlayerPairId = ? AND IsActive = 1
		AND (IsFinished IS NULL OR IsFinished <> 1)`,
		pair.CurrentPairGameId, pair.PlayerPairId)
	if err != nil {
		if isGameNotFound(err) {
			return nil, nil
		}
		return nil, err
	}
	return row, nil
}

func taskIdForActor(config gameConfigState, partnerGender int) string {
	if partnerGender == 2 {
		return config.TaskForM
	}
	return config.TaskForF
}

func selectGameTaskState(q gameQuery, taskId string) (*gameTaskState, error) {
	if taskId == "" || taskId == "-1" {
		return nil, nil
	}
	row := new(gameTaskState)
	err := q.QueryRowPartial(row, `SELECT t.Seq AS order2, t.TaskId AS task_id,
		COALESCE(t.Score, 0) AS score, COALESCE(t.Title, '') AS title,
		COALESCE(tt.Description, '') AS task_type_name
		FROM net_tasks t
		LEFT JOIN net_tasktype tt ON tt.Id = t.Type
		WHERE t.TaskId = ? ORDER BY t.Seq, t.TaskId LIMIT 1`, taskId)
	if err != nil {
		if isGameNotFound(err) {
			return nil, nil
		}
		return nil, err
	}
	return row, nil
}

func selectConfigCompletionPlayers(q gameQuery, pairGameId, configId int64) (map[int64]bool, error) {
	rows := make([]gameCompletionState, 0, 2)
	err := q.QueryRowsPartial(&rows, `SELECT player_id
		FROM game_config_completions
		WHERE pair_game_id = ? AND game_config_id = ?`, pairGameId, configId)
	if err != nil {
		return nil, err
	}
	done := make(map[int64]bool, len(rows))
	for _, row := range rows {
		done[row.PlayerId] = true
	}
	return done, nil
}

func selectChainCompletionPlayers(q gameQuery, pairGameId, configId int64, chainId string) (map[int64]map[string]bool, error) {
	rows := make([]gameChainCompletionState, 0)
	err := q.QueryRowsPartial(&rows, `SELECT player_id, child_task_id
		FROM game_chain_submissions
		WHERE pair_game_id = ? AND game_config_id = ? AND chain_id = ?`,
		pairGameId, configId, chainId)
	if err != nil {
		return nil, err
	}
	done := make(map[int64]map[string]bool)
	for _, row := range rows {
		if done[row.PlayerId] == nil {
			done[row.PlayerId] = make(map[string]bool)
		}
		done[row.PlayerId][row.ChildTaskId] = true
	}
	return done, nil
}

func localizedGameTaskText(q gameQuery, taskId string, languageId, actorGender int) (title, common string, err error) {
	if taskId == "" {
		return "", "", nil
	}
	row := new(gameTaskTextState)
	err = q.QueryRowPartial(row, `SELECT COALESCE(TextForM, '') AS text_for_m,
		COALESCE(TextForF, '') AS text_for_f,
		COALESCE(CommonDescription, '') AS common_description
		FROM net_tasktext WHERE TaskId = ? AND LanguageId = ?
		ORDER BY Id LIMIT 1`, taskId, languageId)
	if err != nil {
		if isGameNotFound(err) {
			return "", "", nil
		}
		return "", "", err
	}
	if actorGender == 1 {
		title = row.TextForM
	} else {
		title = row.TextForF
	}
	if title == "" {
		title = row.CommonDescription
	}
	return title, row.CommonDescription, nil
}

func selectGameTaskQuestions(q gameQuery, taskId string, languageId, actorGender int) ([]GameTaskQuestionDO, error) {
	questions := make([]GameTaskQuestionDO, 0)
	fillRows := make([]gameTaskTextState, 0)
	if err := q.QueryRowsPartial(&fillRows, `SELECT COALESCE(TextForM, '') AS text_for_m,
		COALESCE(TextForF, '') AS text_for_f, '' AS common_description
		FROM net_filltext WHERE TaskId = ? AND LanguageId = ? ORDER BY Id`,
		taskId, languageId); err != nil {
		return nil, err
	}
	for _, row := range fillRows {
		text := row.TextForF
		if actorGender == 1 {
			text = row.TextForM
		}
		if text != "" {
			questions = append(questions, GameTaskQuestionDO{Type: 1, Text: text})
		}
	}
	q234Rows := make([]struct {
		A1 string `db:"a1"`
		A2 string `db:"a2"`
		A3 string `db:"a3"`
		A4 string `db:"a4"`
	}, 0)
	if err := q.QueryRowsPartial(&q234Rows, `SELECT COALESCE(A1Text, '') AS a1,
		COALESCE(A2Text, '') AS a2, COALESCE(A3Text, '') AS a3,
		COALESCE(A4Text, '') AS a4
		FROM net_q234 WHERE TaskId = ? AND LanguageId = ? ORDER BY Id`,
		taskId, languageId); err != nil {
		return nil, err
	}
	for _, row := range q234Rows {
		for i, text := range []string{row.A1, row.A2, row.A3, row.A4} {
			if text != "" {
				questions = append(questions, GameTaskQuestionDO{Type: i + 1, Text: text})
			}
		}
	}
	return questions, nil
}

func buildGameTaskDetail(q gameQuery, actor *gameUserState, pair *gamePairState,
	pairGame *gamePairGameState, config gameConfigState, task *gameTaskState,
	parentChainId, childTaskId string, partnerCompleted bool) (*GameTaskDO, error) {
	title, common, err := localizedGameTaskText(q, task.TaskId, actor.LanguageId, actor.Gender)
	if err != nil {
		return nil, err
	}
	if title == "" {
		title = task.Title
	}
	mainTitle, chainCommon, err := localizedGameTaskText(q, parentChainId, actor.LanguageId, actor.Gender)
	if err != nil {
		return nil, err
	}
	questions, err := selectGameTaskQuestions(q, task.TaskId, actor.LanguageId, actor.Gender)
	if err != nil {
		return nil, err
	}
	return &GameTaskDO{
		CommonDescription: common,
		TaskId:            task.TaskId,
		Order:             task.Order,
		LangId:            actor.LanguageId,
		Score:             task.Score,
		Title:             title,
		TaskTypeName:      task.TaskTypeName,
		Questions:         questions,
		GameConfigId:      config.Id,
		PairGameId:        pairGame.PairGameId,
		PlayPairId:        pair.PlayerPairId,
		MainTitle:         mainTitle,
		ChainCommonTitle:  chainCommon,
		ChainTaskId:       childTaskId,
		PartnerCompleted:  partnerCompleted,
	}, nil
}

func selectNextGameTask(q gameQuery, actorId, partnerId, requestedPairId int64) (*GameTaskResultDO, error) {
	actor, err := selectGameUser(q, actorId)
	if err != nil {
		return nil, err
	}
	if actor == nil || actor.Active != 1 || actor.Deleted != 0 {
		return nil, ErrGameActorInvalid
	}
	partner, err := selectGameUser(q, partnerId)
	if err != nil {
		return nil, err
	}
	if partner == nil || partner.Active != 1 || partner.Deleted != 0 {
		return nil, ErrGamePartnerInvalid
	}
	pair, err := selectGamePair(q, actorId, partnerId, requestedPairId)
	if err != nil {
		return nil, err
	}
	if pair == nil {
		return nil, ErrGamePairInvalid
	}
	pairGame, err := selectActivePairGame(q, pair)
	if err != nil {
		return nil, err
	}
	if pairGame == nil {
		return &GameTaskResultDO{Version: 1, Reason: "no_active_game"}, nil
	}
	configs := make([]gameConfigState, 0)
	if err := q.QueryRowsPartial(&configs, `SELECT Id AS id, GameId AS game_id,
		COALESCE(TaskForM, '') AS task_for_m, COALESCE(TaskForF, '') AS task_for_f
		FROM net_gameconfig WHERE GameId = ? ORDER BY Seq, Id`, pairGame.GameId); err != nil {
		return nil, err
	}
	for _, config := range configs {
		parentTaskId := taskIdForActor(config, partner.Gender)
		parentTask, err := selectGameTaskState(q, parentTaskId)
		if err != nil {
			return nil, err
		}
		if parentTask == nil {
			continue
		}
		if strings.EqualFold(strings.TrimSpace(parentTask.TaskTypeName), "Q Chain") {
			children := make([]gameChainChildState, 0)
			if err := q.QueryRowsPartial(&children, `SELECT Id AS id, TaskId AS task_id
				FROM net_chain WHERE ChainId = ? ORDER BY SeqNum, Id`, parentTaskId); err != nil {
				return nil, err
			}
			if len(children) == 0 {
				continue
			}
			done, err := selectChainCompletionPlayers(q, pairGame.PairGameId, config.Id, parentTaskId)
			if err != nil {
				return nil, err
			}
			actorDone := done[actorId]
			partnerDone := done[partnerId]
			if len(actorDone) == len(children) && len(partnerDone) == len(children) {
				continue
			}
			if len(actorDone) == len(children) {
				waiting := partnerId
				return &GameTaskResultDO{Version: 1, Reason: "waiting_for_partner", WaitingForPlayerId: &waiting}, nil
			}
			var childId string
			for _, child := range children {
				if !actorDone[child.TaskId] {
					childId = child.TaskId
					break
				}
			}
			childTask, err := selectGameTaskState(q, childId)
			if err != nil {
				return nil, err
			}
			if childTask == nil {
				continue
			}
			detail, err := buildGameTaskDetail(q, actor, pair, pairGame, config,
				childTask, parentTaskId, childId, len(partnerDone) == len(children))
			if err != nil {
				return nil, err
			}
			return &GameTaskResultDO{Version: 1, HasTask: true, Task: detail}, nil
		}
		done, err := selectConfigCompletionPlayers(q, pairGame.PairGameId, config.Id)
		if err != nil {
			return nil, err
		}
		if done[actorId] && done[partnerId] {
			continue
		}
		if done[actorId] {
			waiting := partnerId
			return &GameTaskResultDO{Version: 1, Reason: "waiting_for_partner", WaitingForPlayerId: &waiting}, nil
		}
		detail, err := buildGameTaskDetail(q, actor, pair, pairGame, config,
			parentTask, "", "", done[partnerId])
		if err != nil {
			return nil, err
		}
		return &GameTaskResultDO{Version: 1, HasTask: true, Task: detail}, nil
	}
	return &GameTaskResultDO{Version: 1, Reason: "game_complete"}, nil
}

func (d *Dao) SelectNextGameTask(ctx context.Context, actorId, partnerId, requestedPairId int64) (*GameTaskResultDO, error) {
	return selectNextGameTask(gameDBQuery{ctx: ctx, db: d.db}, actorId, partnerId, requestedPairId)
}
