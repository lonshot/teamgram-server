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
