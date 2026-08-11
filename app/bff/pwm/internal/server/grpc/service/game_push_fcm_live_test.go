package service

import (
	"context"
	"os"
	"testing"

	"golang.org/x/oauth2"
)

func TestFCMCredentialsLive(t *testing.T) {
	if os.Getenv("PWM_FCM_LIVE_TEST") != "1" {
		t.Skip("set PWM_FCM_LIVE_TEST=1 to verify the configured Firebase service account")
	}

	sender, err := newFCMHTTPV1Sender(context.Background())
	if err != nil {
		t.Fatalf("initialize FCM sender: %v", err)
	}
	fcmSender, ok := sender.(*fcmHTTPV1Sender)
	if !ok {
		t.Fatalf("unexpected FCM sender type %T", sender)
	}
	transport, ok := fcmSender.client.Transport.(*oauth2.Transport)
	if !ok || transport.Source == nil {
		t.Fatal("FCM OAuth token source is not configured")
	}
	token, err := transport.Source.Token()
	if err != nil {
		t.Fatalf("exchange Firebase credentials for OAuth token: %v", err)
	}
	if !token.Valid() {
		t.Fatal("Firebase OAuth token is invalid")
	}
}
