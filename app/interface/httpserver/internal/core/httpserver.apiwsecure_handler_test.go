package core

import "testing"

func TestDurablePushRandomID(t *testing.T) {
	message := `{"title":"Hello","messageId":"42","message":"Body"}`
	first := durablePushRandomID(1001, message)
	if first <= 0 {
		t.Fatalf("expected a positive random id, got %d", first)
	}
	if replay := durablePushRandomID(1001, message); replay != first {
		t.Fatalf("expected retry to reuse %d, got %d", first, replay)
	}
	if otherUser := durablePushRandomID(1002, message); otherUser == first {
		t.Fatalf("expected a different user to receive a different random id")
	}
	otherMessage := `{"title":"Hello","messageId":"43","message":"Body"}`
	if durablePushRandomID(1001, otherMessage) == first {
		t.Fatalf("expected a different broadcast to receive a different random id")
	}
}
