package service

import (
	"testing"

	"github.com/stretchr/testify/require"
	"pwm-server/app/bff/pwm/internal/dao"
)

func TestGameAnswerHint(t *testing.T) {
	result := &dao.GameAnswerResultDO{
		Accepted: true, Cursor: 42,
		Progress:     dao.GameProgressDO{Player1Id: 7, Player2Id: 9},
		Presentation: &dao.GameTaskAnswerPresentationDO{PairGameId: 20},
	}
	hint, valid := gameAnswerHint(result)
	require.True(t, valid)
	require.Equal(t, "pwm.game.answer_submitted", hint.EventType)
	require.Equal(t, []gameOutboxRecipient{{UserID: 7}, {UserID: 9}}, hint.Recipients)
	// Each recipient replays its own cursor; the actor cursor is not a valid
	// checkpoint for the other player. Hints carry no answer/profile data.
	require.Equal(t, "0", hintData(hint, hint.Recipients[1])["cursor"])
	require.Equal(t, "20", hintData(hint, hint.Recipients[1])["aggregateId"])
	result.GameFinished = true
	hint, valid = gameAnswerHint(result)
	require.True(t, valid)
	require.Equal(t, "pwm.game.finished", hint.EventType)
	result.Accepted = false
	_, valid = gameAnswerHint(result)
	require.False(t, valid)
	_, valid = gameAnswerHint(nil)
	require.False(t, valid)
}
