package push

import (
	"encoding/json"
	"testing"
)

func TestChatPayloadDisplaysWhileAppIsBackgrounded(t *testing.T) {
	payload, err := chatPayload("token", "Alice", "Hello", "42", "7", true)
	if err != nil {
		t.Fatal(err)
	}
	var decoded map[string]any
	if err = json.Unmarshal(payload, &decoded); err != nil {
		t.Fatal(err)
	}
	message := decoded["message"].(map[string]any)
	notification := message["notification"].(map[string]any)
	if notification["title"] != "Alice" || notification["body"] != "Hello" {
		t.Fatalf("notification payload missing: %#v", notification)
	}
	android := message["android"].(map[string]any)
	if android["priority"] != "high" {
		t.Fatalf("android push is not high priority: %#v", android)
	}
	apns := message["apns"].(map[string]any)
	headers := apns["headers"].(map[string]any)
	if headers["apns-push-type"] != "alert" {
		t.Fatalf("APNs push is not visible alert: %#v", headers)
	}
}

func TestChatPayloadCanDisableSound(t *testing.T) {
	payload, err := chatPayload("token", "Alice", "Hello", "42", "7", false)
	if err != nil {
		t.Fatal(err)
	}
	var decoded map[string]any
	if err = json.Unmarshal(payload, &decoded); err != nil {
		t.Fatal(err)
	}
	message := decoded["message"].(map[string]any)
	android := message["android"].(map[string]any)
	notification := android["notification"].(map[string]any)
	if _, ok := notification["sound"]; ok {
		t.Fatalf("silent Android notification contains sound: %#v", notification)
	}
	apns := message["apns"].(map[string]any)
	aps := apns["payload"].(map[string]any)["aps"].(map[string]any)
	if _, ok := aps["sound"]; ok {
		t.Fatalf("silent APNs notification contains sound: %#v", aps)
	}
}
