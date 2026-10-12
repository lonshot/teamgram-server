package core

import (
	"testing"

	"pwm-server/pkg/env2"
)

func TestShouldSendChatPushSuppressesSyntheticServicePeer(t *testing.T) {
	if shouldSendChatPush(int64(env2.ServiceUserId)) {
		t.Fatal("synthetic service peer must not emit a generic chat FCM notification")
	}
	if !shouldSendChatPush(42) {
		t.Fatal("ordinary chat peers must retain chat FCM notifications")
	}
}
