package core

import (
	"testing"

	"github.com/teamgram/proto/mtproto"
	"google.golang.org/grpc/status"
)

func TestSocialProviderFromPhoneNumber(t *testing.T) {
	tests := map[string]string{
		"GOOGLE123":   "google",
		"facebook456": "facebook",
		" APPLE789 ":  "apple",
		"other":       "unknown",
	}
	for input, expected := range tests {
		if actual := socialProviderFromPhoneNumber(input); actual != expected {
			t.Fatalf("provider for %q: got %q, want %q", input, actual, expected)
		}
	}
}

func TestVerificationExtraDataIncludesProvider(t *testing.T) {
	actual := verificationExtraData("confirmation", "user@example.com", "GOOGLE123")
	if actual != "confirmation@@user@example.com@@provider=google@@registration_id=GOOGLE123" {
		t.Fatalf("unexpected extra data: %q", actual)
	}
}

func TestVerificationDeliveryErrorIsStableRpcError(t *testing.T) {
	err := verificationDeliveryError()
	if status.Code(err) != mtproto.ErrInternal {
		t.Fatalf("unexpected status code: %v", status.Code(err))
	}
	if status.Convert(err).Message() != "EMAIL_DELIVERY_FAILED" {
		t.Fatalf("unexpected status message: %q", status.Convert(err).Message())
	}
}
