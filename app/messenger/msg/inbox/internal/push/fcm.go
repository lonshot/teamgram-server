package push

import (
	"bytes"
	"context"
	"encoding/json"
	"errors"
	"fmt"
	"io"
	"net/http"
	"os"
	"strings"
	"time"

	"golang.org/x/oauth2"
	"golang.org/x/oauth2/google"
)

var ErrNotConfigured = errors.New("chat push is not configured")
var ErrTokenInvalid = errors.New("chat push token is invalid")

type Sender struct {
	client   *http.Client
	endpoint string
}

type serviceAccount struct {
	ProjectID string `json:"project_id"`
}

func New(ctx context.Context) (*Sender, error) {
	credentialsFile := strings.TrimSpace(os.Getenv("PWM_FIREBASE_CREDENTIALS_FILE"))
	if credentialsFile == "" {
		credentialsFile = strings.TrimSpace(os.Getenv("GOOGLE_APPLICATION_CREDENTIALS"))
	}
	if credentialsFile == "" {
		return nil, ErrNotConfigured
	}
	credentialsJSON, err := os.ReadFile(credentialsFile)
	if err != nil {
		return nil, fmt.Errorf("read Firebase credentials: %w", err)
	}
	var account serviceAccount
	if err = json.Unmarshal(credentialsJSON, &account); err != nil {
		return nil, fmt.Errorf("parse Firebase credentials: %w", err)
	}
	projectID := strings.TrimSpace(os.Getenv("PWM_FIREBASE_PROJECT_ID"))
	if projectID == "" {
		projectID = account.ProjectID
	}
	if projectID == "" {
		return nil, errors.New("Firebase project ID is missing")
	}
	credentials, err := google.CredentialsFromJSON(ctx, credentialsJSON,
		"https://www.googleapis.com/auth/firebase.messaging")
	if err != nil {
		return nil, fmt.Errorf("initialize Firebase credentials: %w", err)
	}
	return &Sender{
		client: &http.Client{
			Transport: &oauth2.Transport{Source: credentials.TokenSource},
			Timeout:   10 * time.Second,
		},
		endpoint: "https://fcm.googleapis.com/v1/projects/" + projectID + "/messages:send",
	}, nil
}

func (s *Sender) SendChat(ctx context.Context, token, title, body, peerID, messageID string, withSound bool) error {
	payload, err := chatPayload(token, title, body, peerID, messageID, withSound)
	if err != nil {
		return err
	}
	req, err := http.NewRequestWithContext(ctx, http.MethodPost, s.endpoint, bytes.NewReader(payload))
	if err != nil {
		return err
	}
	req.Header.Set("Content-Type", "application/json")
	resp, err := s.client.Do(req)
	if err != nil {
		return err
	}
	defer resp.Body.Close()
	responseBody, _ := io.ReadAll(io.LimitReader(resp.Body, 4096))
	if resp.StatusCode >= 200 && resp.StatusCode < 300 {
		return nil
	}
	responseText := string(responseBody)
	if (resp.StatusCode == http.StatusBadRequest || resp.StatusCode == http.StatusNotFound) &&
		(strings.Contains(responseText, "UNREGISTERED") || strings.Contains(responseText, "INVALID_ARGUMENT")) {
		return ErrTokenInvalid
	}
	return fmt.Errorf("FCM send failed with status %d: %s", resp.StatusCode, responseText)
}

func chatPayload(token, title, body, peerID, messageID string, withSound bool) ([]byte, error) {
	androidNotification := map[string]string{"channel_id": "playwithme_channel"}
	aps := map[string]any{}
	if withSound {
		androidNotification["sound"] = "default"
		aps["sound"] = "default"
	}
	return json.Marshal(map[string]any{
		"message": map[string]any{
			"token": token,
			"notification": map[string]string{
				"title": title,
				"body":  body,
			},
			"data": map[string]string{
				"type":   "message",
				"peerId": peerID,
				"mId":    messageID,
				"title":  title,
				"body":   body,
			},
			"android": map[string]any{
				"priority":     "high",
				"notification": androidNotification,
			},
			"apns": map[string]any{
				"headers": map[string]string{
					"apns-priority":  "10",
					"apns-push-type": "alert",
				},
				"payload": map[string]any{
					"aps": aps,
				},
			},
		},
	})
}
