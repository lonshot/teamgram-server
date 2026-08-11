package service

import (
	"context"
	"errors"
	"io"
	"net/http"
	"net/http/httptest"
	"testing"

	"github.com/stretchr/testify/require"
)

func TestFCMHTTPV1Sender(t *testing.T) {
	t.Run("success carries cursor rather than mutable state", func(t *testing.T) {
		server := httptest.NewServer(http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
			require.Equal(t, http.MethodPost, r.Method)
			body, err := io.ReadAll(r.Body)
			require.NoError(t, err)
			require.Contains(t, string(body), `"eventId":"event-1"`)
			require.Contains(t, string(body), `"cursor":"42"`)
			require.NotContains(t, string(body), "nextTask")
			w.WriteHeader(http.StatusOK)
		}))
		defer server.Close()

		sender := &fcmHTTPV1Sender{client: server.Client(), endpoint: server.URL}
		err := sender.Send(context.Background(), "device-token", map[string]string{
			"eventId": "event-1",
			"cursor":  "42",
		})
		require.NoError(t, err)
	})

	t.Run("invalid token is permanent", func(t *testing.T) {
		server := httptest.NewServer(http.HandlerFunc(func(w http.ResponseWriter, _ *http.Request) {
			w.WriteHeader(http.StatusNotFound)
			_, _ = w.Write([]byte(`{"error":{"status":"NOT_FOUND","details":[{"errorCode":"UNREGISTERED"}]}}`))
		}))
		defer server.Close()

		sender := &fcmHTTPV1Sender{client: server.Client(), endpoint: server.URL}
		err := sender.Send(context.Background(), "expired-token", map[string]string{"cursor": "42"})
		require.ErrorIs(t, err, errGamePushTokenInvalid)
	})

	t.Run("transient provider error is retried by outbox", func(t *testing.T) {
		server := httptest.NewServer(http.HandlerFunc(func(w http.ResponseWriter, _ *http.Request) {
			w.WriteHeader(http.StatusServiceUnavailable)
			_, _ = w.Write([]byte(`{"error":{"status":"UNAVAILABLE"}}`))
		}))
		defer server.Close()

		sender := &fcmHTTPV1Sender{client: server.Client(), endpoint: server.URL}
		err := sender.Send(context.Background(), "device-token", map[string]string{"cursor": "42"})
		require.Error(t, err)
		require.False(t, errors.Is(err, errGamePushTokenInvalid))
	})
}

func TestGameHintData(t *testing.T) {
	data := hintData(gameOutboxPayload{
		EventID:       "event-1",
		EventType:     "pwm.game.answer_submitted",
		AggregateType: "pair_game",
		AggregateID:   "7",
	}, gameOutboxRecipient{UserID: 9, Cursor: 42})

	require.Equal(t, "pwm_game_event", data["type"])
	require.Equal(t, "event-1", data["eventId"])
	require.Equal(t, "42", data["cursor"])
	require.Equal(t, "7", data["aggregateId"])
}
