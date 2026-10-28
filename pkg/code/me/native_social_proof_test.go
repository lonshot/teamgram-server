package me

import (
	"context"
	"encoding/json"
	"net/http"
	"net/http/httptest"
	"pwm-server/pkg/code/conf"
	"strings"
	"testing"
	"time"
)

func TestNativeSocialProofUsesAuthenticatedVerificationChannel(t *testing.T) {
	proof := "PWMN1." + strings.Repeat("x", 43)
	payload := "-~~!~~" + proof + "~~!@!~~platform=ios"
	calls := 0
	server := httptest.NewServer(http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		calls++
		if r.Header.Get("X-Pwm-Key") != "test-server-only-key" {
			t.Error("missing server-only verification credential")
		}
		var body map[string]string
		if err := json.NewDecoder(r.Body).Decode(&body); err != nil {
			t.Fatal(err)
		}
		if body["data"] != payload || body["phoneNumber"] != "APPLEsubject" || body["codeHash"] != "attempt-bound-hash" {
			t.Error("proof or subject/hash binding changed in transport")
		}
		_, _ = w.Write([]byte(`{"valid":true,"auto":true}`))
	}))
	defer server.Close()
	client := New(&conf.SmsVerifyCodeConfig{SendCodeUrl: server.URL, Secret: "test-server-only-key", RequestTimeout: time.Second})
	result, err := client.SendSmsVerifyCode(context.Background(), "APPLEsubject", "12345", "attempt-bound-hash", payload)
	if err != nil || result == nil || !result.Valid || !result.Auto || calls != 1 {
		t.Fatal("valid native proof not forwarded exactly once")
	}
}
func TestNativeSocialProofRejectsInvalidEnvelopeBeforeHTTP(t *testing.T) {
	proof := "PWMN1." + strings.Repeat("x", 43)
	for _, tc := range []struct{ phone, token, hash, secret string }{
		{"APPLEsubject", "PWMN2." + strings.Repeat("x", 43), "hash", "key"},
		{"APPLEsubject", "PWMN1.short", "hash", "key"},
		{"GOOGLEsubject", proof, "hash", "key"},
		{"FACEBOOKsubject", proof, "", "key"},
		{"FACEBOOKsubject", proof, "hash", ""},
	} {
		client := New(&conf.SmsVerifyCodeConfig{SendCodeUrl: "http://127.0.0.1:1", Secret: tc.secret, RequestTimeout: time.Millisecond})
		_, err := client.SendSmsVerifyCode(context.Background(), tc.phone, "12345", tc.hash, "-~~!~~"+tc.token+"~~!@!~~platform=ios")
		if err == nil || !strings.Contains(err.Error(), "invalid native social proof") {
			t.Fatal("invalid proof did not fail before HTTP")
		}
	}
}
func TestNativeSocialProofNeedsVerifiedPasswordlessResponse(t *testing.T) {
	for _, body := range []string{`{"valid":false,"auto":true}`, `{"valid":true,"auto":false}`} {
		server := httptest.NewServer(http.HandlerFunc(func(w http.ResponseWriter, _ *http.Request) { _, _ = w.Write([]byte(body)) }))
		client := New(&conf.SmsVerifyCodeConfig{SendCodeUrl: server.URL, Secret: "key", RequestTimeout: time.Second})
		_, err := client.SendSmsVerifyCode(context.Background(), "APPLEsubject", "12345", "hash", "-~~!~~PWMN1."+strings.Repeat("x", 43))
		server.Close()
		if err == nil {
			t.Fatal("unverified proof must not produce passwordless marker")
		}
	}
}
func TestVerificationNeverFollowsRedirectWithServerKey(t *testing.T) {
	leaked := false
	target := httptest.NewServer(http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) { leaked = true }))
	defer target.Close()
	source := httptest.NewServer(http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		http.Redirect(w, r, target.URL, http.StatusTemporaryRedirect)
	}))
	defer source.Close()
	client := New(&conf.SmsVerifyCodeConfig{SendCodeUrl: source.URL, Secret: "server-key", RequestTimeout: time.Second})
	_, err := client.SendSmsVerifyCode(context.Background(), "APPLEsubject", "12345", "hash", "-~~!~~PWMN1."+strings.Repeat("x", 43))
	if err == nil || leaked {
		t.Fatal("verification redirect must fail without contacting target")
	}
}
