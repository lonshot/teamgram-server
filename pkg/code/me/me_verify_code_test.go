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
	if !providerAllowsOperationalBypass("google") {
		t.Fatal("Google email OTP must allow the explicitly configured operational bypass")
	}
	if providerAllowsOperationalBypass("unknown") || providerAllowsOperationalBypass("apple") ||
		providerAllowsOperationalBypass("facebook") {
		t.Fatal("Only the Google email OTP flow may use the operational bypass")
	}
}

func TestGoogleOperationalBypassRequiresExactConfiguredCode(t *testing.T) {
	requests := 0
	server := httptest.NewServer(http.HandlerFunc(func(w http.ResponseWriter, _ *http.Request) {
		requests++
		_, _ = w.Write([]byte(`{"valid":false}`))
	}))
	defer server.Close()

	client := New(&conf.SmsVerifyCodeConfig{
		BypassEnabled:  true,
		BypassCode:     "12345",
		VerifyCodeUrl:  server.URL,
		RequestTimeout: time.Second,
	})
	extraData := "confirmation@@user@example.com@@provider=google@@registration_id=GOOGLE123"

	if err := client.VerifySmsCode(context.Background(), "GOOGLE123", "12345", extraData); err != nil {
		t.Fatalf("exact configured bypass code must be accepted: %v", err)
	}
	if requests != 0 {
		t.Fatalf("exact bypass should not call the email verifier; got %d requests", requests)
	}

	if err := client.VerifySmsCode(context.Background(), "GOOGLE123", "54321", extraData); err == nil {
		t.Fatal("an arbitrary code must be rejected when the email verifier rejects it")
	}
	if requests != 1 {
		t.Fatalf("non-bypass code must be verified by email service; got %d requests", requests)
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
