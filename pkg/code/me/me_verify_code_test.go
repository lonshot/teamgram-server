package me

import (
	"context"
	"net/http"
	"net/http/httptest"
	"testing"
	"time"

	"pwm-server/pkg/code/conf"
)

func TestSecureCodeEqual(t *testing.T) {
	if !conf.SecureCodeEqual("operational-code", "operational-code") {
		t.Fatal("expected equal codes to match")
	}
	if conf.SecureCodeEqual("12345", "operational-code") {
		t.Fatal("expected legacy dummy code to be rejected")
	}
	if conf.SecureCodeEqual("short", "longer") {
		t.Fatal("expected different lengths to be rejected")
	}
}

func TestVerificationProvider(t *testing.T) {
	if provider := verificationProvider("confirmation@@user@example.com@@provider=google@@registration_id=GOOGLE123"); provider != "google" {
		t.Fatalf("unexpected provider: %q", provider)
	}
	if provider := verificationProvider("legacy-extra-data"); provider != "unknown" {
		t.Fatalf("legacy data must not be treated as Google: %q", provider)
	}
	if providerAllowsOperationalBypass("google") || providerAllowsOperationalBypass("unknown") {
		t.Fatal("Google and untagged flows must never use the operational bypass")
	}
	if !providerAllowsOperationalBypass("apple") || !providerAllowsOperationalBypass("facebook") {
		t.Fatal("Apple and Facebook are the only allowed passwordless providers")
	}
}

func TestPasswordlessMarkerIsIndependentOfOperationalBypass(t *testing.T) {
	client := New(&conf.SmsVerifyCodeConfig{
		AutoVerifyEnabled: false,
		BypassEnabled:     false,
	})
	if err := client.VerifySmsCode(context.Background(), "APPLE123", "", "__auto__"); err != nil {
		t.Fatalf("validated Apple/Facebook marker must not require an OTP: %v", err)
	}
}

func TestPostJSONRejectsNonSuccessStatus(t *testing.T) {
	server := httptest.NewServer(http.HandlerFunc(func(w http.ResponseWriter, _ *http.Request) {
		http.Error(w, "failed", http.StatusInternalServerError)
	}))
	defer server.Close()

	client := New(&conf.SmsVerifyCodeConfig{RequestTimeout: time.Second})
	if _, err := client.postJson(context.Background(), server.URL, map[string]string{"code": "redacted"}); err == nil {
		t.Fatal("expected non-success HTTP status to fail")
	}
}

func TestPostJSONHonorsContextCancellation(t *testing.T) {
	server := httptest.NewServer(http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		<-r.Context().Done()
	}))
	defer server.Close()

	ctx, cancel := context.WithCancel(context.Background())
	cancel()
	client := New(&conf.SmsVerifyCodeConfig{RequestTimeout: time.Second})
	if _, err := client.postJson(ctx, server.URL, map[string]string{}); err == nil {
		t.Fatal("expected cancelled context to fail")
	}
}
