package service

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

var (
	errGamePushNotConfigured = errors.New("game push is not configured")
	errGamePushTokenInvalid  = errors.New("game push token is invalid")
)

type gamePushSender interface {
	Send(context.Context, string, map[string]string) error
}

type fcmHTTPV1Sender struct {
	client   *http.Client
	endpoint string
}

type firebaseServiceAccount struct {
	ProjectID string `json:"project_id"`
}

func newFCMHTTPV1Sender(ctx context.Context) (gamePushSender, error) {
	credentialsFile := strings.TrimSpace(os.Getenv("PWM_FIREBASE_CREDENTIALS_FILE"))
	if credentialsFile == "" {
		credentialsFile = strings.TrimSpace(os.Getenv("GOOGLE_APPLICATION_CREDENTIALS"))
	}
	if credentialsFile == "" {
		return nil, errGamePushNotConfigured
	}
	credentialsJSON, err := os.ReadFile(credentialsFile)
	if err != nil {
		return nil, fmt.Errorf("read Firebase credentials: %w", err)
	}
	var account firebaseServiceAccount
	if err := json.Unmarshal(credentialsJSON, &account); err != nil {
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
	return &fcmHTTPV1Sender{
		client: &http.Client{
			Transport: &oauth2.Transport{Source: credentials.TokenSource},
			Timeout:   10 * time.Second,
		},
		endpoint: "https://fcm.googleapis.com/v1/projects/" + projectID + "/messages:send",
	}, nil
}

func (s *fcmHTTPV1Sender) Send(ctx context.Context, token string, data map[string]string) error {
	message := map[string]any{
		"token": token,
		"data":  data,
		"android": map[string]any{
			"priority": "high",
		},
	}
	if title, hasTitle := data["title"]; hasTitle && title != "" {
		if notificationBody := data["body"]; notificationBody != "" {
			message["notification"] = map[string]string{"title": title, "body": notificationBody}
			message["android"] = map[string]any{
				"priority":     "high",
				"notification": map[string]string{"channel_id": "playwithme_channel", "sound": "default"},
			}
			message["apns"] = map[string]any{
				"headers": map[string]string{"apns-priority": "10", "apns-push-type": "alert"},
				"payload": map[string]any{"aps": map[string]any{"sound": "default"}},
			}
		}
	}
	body, err := json.Marshal(map[string]any{"message": message})
	if err != nil {
		return err
	}
	req, err := http.NewRequestWithContext(ctx, http.MethodPost, s.endpoint, bytes.NewReader(body))
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
		return errGamePushTokenInvalid
	}
	return fmt.Errorf("FCM send failed with status %d: %s", resp.StatusCode, responseText)
}
