package core

import (
	"strings"
	"testing"
)

func TestChatPushInheritsEachScopeField(t *testing.T) {
	rows := []chatPushSettings{
		{ShowPreviews: 0, Silent: 0, MuteUntil: 1234, Sound: "none"},
		{ShowPreviews: -1, Silent: -1, MuteUntil: -1, Sound: "-1"},
	}
	got := resolveChatPushSettings(rows)
	if got != rows[0] {
		t.Fatalf("inherited preferences lost: %#v", got)
	}
	rows[1].MuteUntil = 0
	got = resolveChatPushSettings(rows)
	if got.MuteUntil != 0 || got.ShowPreviews != 0 || got.Sound != "none" {
		t.Fatalf("independent override lost: %#v", got)
	}
}

func TestChatPushPreviewHidesSenderAndMessage(t *testing.T) {
	title, body := chatPushPreview(false, "Private name", "Private message")
	if title != "Play with Me" || body != "Sent you a message" {
		t.Fatal("private preview escaped")
	}
	title, body = chatPushPreview(true, "Sender", strings.Repeat("👋", 300))
	if title != "Sender" || len([]rune(body)) != 256 {
		t.Fatal("allowed preview was not bounded in Unicode characters")
	}
}

func TestChatPushDefaultsAndExplicitPeerOverrides(t *testing.T) {
	defaults := resolveChatPushSettings(nil)
	if defaults.ShowPreviews != 1 || defaults.Silent != 0 || defaults.MuteUntil != 0 || defaults.Sound != "default" {
		t.Fatal(defaults)
	}
	got := resolveChatPushSettings([]chatPushSettings{{ShowPreviews: 0, Silent: 1, MuteUntil: 100, Sound: "none"}, {ShowPreviews: 1, Silent: 0, MuteUntil: 0, Sound: "default"}})
	if got != defaults {
		t.Fatal("peer override must win", got)
	}
}
