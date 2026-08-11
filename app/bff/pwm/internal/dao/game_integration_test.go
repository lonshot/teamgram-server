package dao

import (
	"context"
	"errors"
	"fmt"
	"os"
	"testing"
	"time"

	"github.com/stretchr/testify/require"
	"github.com/teamgram/marmota/pkg/stores/sqlx"
)

type gameTestFixture struct {
	dao          *Dao
	actorId      int64
	partnerId    int64
	outsiderId   int64
	gameId       int64
	pairId       int64
	pairGameId   int64
	ordinaryId   int64
	chainId      int64
	ordinaryTask string
	chainTask    string
	child1       string
	child2       string
	taskTypeId   int64
}

func newGameIntegrationDAO(t *testing.T) *Dao {
	t.Helper()
	dsn := os.Getenv("PWM_GAME_TEST_DSN")
	if dsn == "" {
		t.Skip("PWM_GAME_TEST_DSN is not set")
	}
	db := sqlx.NewMySQL(&sqlx.Config{
		DSN:         dsn,
		Active:      8,
		Idle:        8,
		IdleTimeout: "1m",
	})
	return &Dao{db: db}
}

func lastGameInsertId(t *testing.T, d *Dao, query string, args ...interface{}) int64 {
	t.Helper()
	result, err := d.db.Exec(context.Background(), query, args...)
	require.NoError(t, err)
	id, err := result.LastInsertId()
	require.NoError(t, err)
	return id
}

func seedNativeGameFixture(t *testing.T, d *Dao) *gameTestFixture {
	t.Helper()
	ctx := context.Background()
	users := make([]struct {
		Id int64 `db:"id"`
	}, 0, 3)
	require.NoError(t, d.db.QueryRowsPartial(ctx, &users, `SELECT id
		FROM users WHERE Active = 1 AND deleted = 0
		ORDER BY id LIMIT 3`))
	require.Len(t, users, 3)

	suffix := fmt.Sprintf("%d", time.Now().UnixNano())
	f := &gameTestFixture{
		dao:          d,
		actorId:      users[0].Id,
		partnerId:    users[1].Id,
		outsiderId:   users[2].Id,
		ordinaryTask: "NATIVE_ORD_" + suffix,
		chainTask:    "NATIVE_CHAIN_" + suffix,
		child1:       "NATIVE_CHILD1_" + suffix,
		child2:       "NATIVE_CHILD2_" + suffix,
	}
	f.taskTypeId = lastGameInsertId(t, d,
		"INSERT INTO net_tasktype (Description) VALUES ('Q Chain')")
	f.gameId = lastGameInsertId(t, d,
		"INSERT INTO net_game (Title) VALUES (?)", "Native integration "+suffix)
	f.pairId = lastGameInsertId(t, d, `INSERT INTO net_playerpair
		(Player1, Player2, Description, Timestamp, IsActive, Status,
		 ContinueByPlayer1, ContinueByPlayer2)
		VALUES (?, ?, ?, CURRENT_TIMESTAMP, 1, 1, 1, 1)`,
		f.actorId, f.partnerId, "native-integration-"+suffix)
	f.pairGameId = lastGameInsertId(t, d, `INSERT INTO net_pairgame
		(PlayerPairId, GameId, Timestamp, IsActive, IsFinished, Seq)
		VALUES (?, ?, CURRENT_TIMESTAMP, 1, 0, 1)`, f.pairId, f.gameId)
	_, err := d.db.Exec(ctx, "UPDATE net_playerpair SET CurrentPairGameId = ? WHERE PlayerPairId = ?",
		f.pairGameId, f.pairId)
	require.NoError(t, err)

	_, err = d.db.Exec(ctx, `INSERT INTO net_tasks
		(TaskId, Type, Title, Score) VALUES
		(?, NULL, 'Ordinary', 3),
		(?, ?, 'Chain', 5),
		(?, NULL, 'Child one', 7),
		(?, NULL, 'Child two', 9)`,
		f.ordinaryTask, f.chainTask, f.taskTypeId, f.child1, f.child2)
	require.NoError(t, err)
	f.ordinaryId = lastGameInsertId(t, d, `INSERT INTO net_gameconfig
		(GameId, TaskForM, TaskForF, Seq) VALUES (?, ?, ?, 1)`,
		f.gameId, f.ordinaryTask, f.ordinaryTask)
	f.chainId = lastGameInsertId(t, d, `INSERT INTO net_gameconfig
		(GameId, TaskForM, TaskForF, Seq) VALUES (?, ?, ?, 2)`,
		f.gameId, f.chainTask, f.chainTask)
	_, err = d.db.Exec(ctx, `INSERT INTO net_chain
		(ChainId, SeqNum, TaskId) VALUES (?, 1, ?), (?, 2, ?)`,
		f.chainTask, f.child1, f.chainTask, f.child2)
	require.NoError(t, err)
	_, err = d.db.Exec(ctx, `INSERT INTO net_tasktext
		(TaskId, LanguageId, TextForM, TextForF, CommonDescription) VALUES
		(?, 1, 'Ordinary M', 'Ordinary F', 'Ordinary common'),
		(?, 1, 'Chain M', 'Chain F', 'Chain common'),
		(?, 1, 'Child one M', 'Child one F', 'Child one common'),
		(?, 1, 'Child two M', 'Child two F', 'Child two common')`,
		f.ordinaryTask, f.chainTask, f.child1, f.child2)
	require.NoError(t, err)
	return f
}

func (f *gameTestFixture) cleanup(t *testing.T) {
	t.Helper()
	ctx := context.Background()
	queries := []struct {
		query string
		args  []interface{}
	}{
		{`DELETE FROM game_outbox WHERE command_id IN
			(SELECT id FROM game_commands WHERE pair_game_id = ?)`, []interface{}{f.pairGameId}},
		{`DELETE FROM game_events WHERE command_id IN
			(SELECT id FROM game_commands WHERE pair_game_id = ?)`, []interface{}{f.pairGameId}},
		{"DELETE FROM game_chain_submissions WHERE pair_game_id = ?", []interface{}{f.pairGameId}},
		{"DELETE FROM game_config_completions WHERE pair_game_id = ?", []interface{}{f.pairGameId}},
		{`DELETE ta FROM net_taskanswer ta JOIN net_completedtask ct
			ON ct.CompletedTaskId = ta.CompletedTaskId WHERE ct.PairGameId = ?`, []interface{}{f.pairGameId}},
		{`DELETE cc FROM net_completedchain cc JOIN net_completedtask ct
			ON ct.CompletedTaskId = cc.CompletedTaskId WHERE ct.PairGameId = ?`, []interface{}{f.pairGameId}},
		{"DELETE FROM net_completedtask WHERE PairGameId = ?", []interface{}{f.pairGameId}},
		{"DELETE FROM game_commands WHERE pair_game_id = ?", []interface{}{f.pairGameId}},
		{"DELETE FROM net_chain WHERE ChainId = ?", []interface{}{f.chainTask}},
		{"DELETE FROM net_tasktext WHERE TaskId IN (?, ?, ?, ?)", []interface{}{f.ordinaryTask, f.chainTask, f.child1, f.child2}},
		{"DELETE FROM net_gameconfig WHERE GameId = ?", []interface{}{f.gameId}},
		{"UPDATE net_playerpair SET CurrentPairGameId = NULL WHERE PlayerPairId = ?", []interface{}{f.pairId}},
		{"DELETE FROM net_pairgame WHERE PairGameId = ?", []interface{}{f.pairGameId}},
		{"DELETE FROM net_playerpair WHERE PlayerPairId = ?", []interface{}{f.pairId}},
		{"DELETE FROM net_tasks WHERE TaskId IN (?, ?, ?, ?)", []interface{}{f.ordinaryTask, f.chainTask, f.child1, f.child2}},
		{"DELETE FROM net_tasktype WHERE Id = ?", []interface{}{f.taskTypeId}},
		{"DELETE FROM net_game WHERE GameId = ?", []interface{}{f.gameId}},
	}
	for _, item := range queries {
		_, err := f.dao.db.Exec(ctx, item.query, item.args...)
		require.NoError(t, err)
	}
}

func countGameRows(t *testing.T, d *Dao, query string, args ...interface{}) int64 {
	t.Helper()
	var count int64
	require.NoError(t, d.db.QueryRow(context.Background(), &count, query, args...))
	return count
}

func TestNativeGameTaskAndAnswerIntegration(t *testing.T) {
	d := newGameIntegrationDAO(t)
	f := seedNativeGameFixture(t, d)
	t.Cleanup(func() { f.cleanup(t) })
	ctx := context.Background()

	next, err := d.SelectNextGameTask(ctx, f.actorId, f.partnerId, f.pairId)
	require.NoError(t, err)
	require.True(t, next.HasTask)
	require.Equal(t, f.ordinaryId, next.Task.GameConfigId)
	require.Equal(t, f.ordinaryTask, next.Task.TaskId)
	require.Empty(t, next.Task.ChainTaskId)
	require.NotEmpty(t, next.Task.Title)
	require.Equal(t, f.pairId, next.PlayerPairId)
	require.Equal(t, f.pairGameId, next.PairGameId)
	require.NotNil(t, next.Progress)
	require.Equal(t, 2, next.Progress.TotalConfigs)
	require.Zero(t, next.Progress.Player1Completed)
	require.Zero(t, next.Progress.Player2Completed)

	_, err = d.SelectNextGameTask(ctx, f.actorId, f.outsiderId, f.pairId)
	require.ErrorIs(t, err, ErrGamePairInvalid)

	requestBase := time.Now().UnixNano()
	ordinaryActor := GameAnswerCommandDO{
		RequestId:    requestBase,
		GameConfigId: f.ordinaryId,
		PairGameId:   f.pairGameId,
		Answer:       "actor ordinary",
	}
	first, err := d.SubmitGameAnswer(ctx, f.actorId, ordinaryActor)
	require.NoError(t, err)
	require.True(t, first.Accepted)
	require.True(t, first.NewlyRecorded)
	require.True(t, first.ConfigComplete)
	require.False(t, first.GameFinished)
	require.NotNil(t, first.WaitingForPlayerId)
	require.Equal(t, f.partnerId, *first.WaitingForPlayerId)
	require.Equal(t, 1, first.Progress.Player1Completed)
	require.Zero(t, first.Progress.Player2Completed)
	require.NotNil(t, first.NextTask.Progress)
	require.Equal(t, first.Progress, *first.NextTask.Progress)

	replay, err := d.SubmitGameAnswer(ctx, f.actorId, ordinaryActor)
	require.NoError(t, err)
	require.Equal(t, first, replay)
	require.Equal(t, int64(1), countGameRows(t, d,
		"SELECT COUNT(*) FROM game_commands WHERE pair_game_id = ? AND actor_user_id = ?",
		f.pairGameId, f.actorId))
	require.Equal(t, int64(1), countGameRows(t, d,
		"SELECT COUNT(*) FROM game_config_completions WHERE pair_game_id = ? AND game_config_id = ? AND player_id = ?",
		f.pairGameId, f.ordinaryId, f.actorId))

	conflict := ordinaryActor
	conflict.Answer = "different payload"
	_, err = d.SubmitGameAnswer(ctx, f.actorId, conflict)
	require.ErrorIs(t, err, ErrGameCommandConflict)

	invalidMembership := ordinaryActor
	invalidMembership.RequestId++
	_, err = d.SubmitGameAnswer(ctx, f.outsiderId, invalidMembership)
	require.ErrorIs(t, err, ErrGamePairInvalid)

	partnerOrdinary := ordinaryActor
	partnerOrdinary.RequestId += 2
	partnerOrdinary.Answer = "partner ordinary"
	partnerResult, err := d.SubmitGameAnswer(ctx, f.partnerId, partnerOrdinary)
	require.NoError(t, err)
	require.True(t, partnerResult.ConfigComplete)
	require.True(t, partnerResult.NextTask.HasTask)
	require.Equal(t, f.chainId, partnerResult.NextTask.Task.GameConfigId)
	require.Equal(t, f.child1, partnerResult.NextTask.Task.ChainTaskId)

	actorChild1 := GameAnswerCommandDO{
		RequestId:    requestBase + 3,
		GameConfigId: f.chainId,
		PairGameId:   f.pairGameId,
		ChainTaskId:  f.child1,
		Answer:       "actor child one",
	}
	child1Result, err := d.SubmitGameAnswer(ctx, f.actorId, actorChild1)
	require.NoError(t, err)
	require.False(t, child1Result.ConfigComplete)
	require.Equal(t, f.child2, child1Result.NextTask.Task.ChainTaskId)

	skippedChild := actorChild1
	skippedChild.RequestId++
	skippedChild.ChainTaskId = f.child2
	_, err = d.SubmitGameAnswer(ctx, f.partnerId, skippedChild)
	require.ErrorIs(t, err, ErrGameTaskInvalid)

	actorChild2 := actorChild1
	actorChild2.RequestId += 2
	actorChild2.ChainTaskId = f.child2
	actorChild2.Answer = "actor child two"
	actorChainDone, err := d.SubmitGameAnswer(ctx, f.actorId, actorChild2)
	require.NoError(t, err)
	require.True(t, actorChainDone.ConfigComplete)
	require.NotNil(t, actorChainDone.WaitingForPlayerId)
	require.Equal(t, f.partnerId, *actorChainDone.WaitingForPlayerId)

	partnerChild1 := actorChild1
	partnerChild1.RequestId += 3
	partnerChild1.Answer = "partner child one"
	_, err = d.SubmitGameAnswer(ctx, f.partnerId, partnerChild1)
	require.NoError(t, err)

	type concurrentOutcome struct {
		result *GameAnswerResultDO
		err    error
	}
	concurrentOutcomes := make(chan concurrentOutcome, 2)
	for offset := int64(0); offset < 2; offset++ {
		request := GameAnswerCommandDO{
			RequestId:    requestBase + 10 + offset,
			GameConfigId: f.chainId,
			PairGameId:   f.pairGameId,
			ChainTaskId:  f.child2,
			Answer:       fmt.Sprintf("partner child two %d", offset),
		}
		go func() {
			result, err := d.SubmitGameAnswer(ctx, f.partnerId, request)
			concurrentOutcomes <- concurrentOutcome{result: result, err: err}
		}()
	}
	var successes, rejected int
	var finishingResult *GameAnswerResultDO
	for i := 0; i < 2; i++ {
		outcome := <-concurrentOutcomes
		switch {
		case outcome.err == nil:
			successes++
			finishingResult = outcome.result
		case errors.Is(outcome.err, ErrGameTaskInvalid):
			rejected++
		default:
			require.NoError(t, outcome.err)
		}
	}
	require.Equal(t, 1, successes)
	require.Equal(t, 1, rejected)
	require.NotNil(t, finishingResult)
	require.True(t, finishingResult.GameFinished)
	require.True(t, finishingResult.GameNewlyFinished)
	require.Equal(t, int64(1), countGameRows(t, d,
		`SELECT COUNT(*) FROM game_chain_submissions
		WHERE pair_game_id = ? AND game_config_id = ? AND player_id = ?
		AND chain_id = ? AND child_task_id = ?`,
		f.pairGameId, f.chainId, f.partnerId, f.chainTask, f.child2))
	require.Equal(t, int64(1), countGameRows(t, d,
		"SELECT COUNT(*) FROM game_config_completions WHERE pair_game_id = ? AND game_config_id = ? AND player_id = ?",
		f.pairGameId, f.chainId, f.partnerId))
	require.Equal(t, int64(1), countGameRows(t, d,
		"SELECT COUNT(*) FROM net_pairgame WHERE PairGameId = ? AND IsFinished = 1",
		f.pairGameId))
	require.Greater(t, countGameRows(t, d,
		"SELECT COUNT(*) FROM game_events WHERE command_id IN (SELECT id FROM game_commands WHERE pair_game_id = ?)",
		f.pairGameId), int64(0))
	require.Greater(t, countGameRows(t, d,
		"SELECT COUNT(*) FROM game_outbox WHERE command_id IN (SELECT id FROM game_commands WHERE pair_game_id = ?)",
		f.pairGameId), int64(0))
}
