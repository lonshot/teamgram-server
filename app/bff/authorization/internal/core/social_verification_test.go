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

func TestVerificationResponseErrorPreservesPublicCodes(t *testing.T) {
	tests := []struct {
		input       string
		wantCode    int
		wantMessage string
	}{
		{" email_address_invalid ", int(mtproto.ErrBadRequest), "EMAIL_ADDRESS_INVALID"},
		{"EMAIL_ADDRESS_OCCUPIED", int(mtproto.ErrBadRequest), "EMAIL_ADDRESS_OCCUPIED"},
		{"EMAIL_DELIVERY_FAILED", int(mtproto.ErrInternal), "EMAIL_DELIVERY_FAILED"},
		{"EMAIL_VERIFICATION_STATE_UNAVAILABLE", int(mtproto.ErrInternal), "EMAIL_VERIFICATION_STATE_UNAVAILABLE"},
		{"downstream implementation detail", int(mtproto.ErrInternal), "EMAIL_DELIVERY_FAILED"},
		{"", int(mtproto.ErrInternal), "EMAIL_DELIVERY_FAILED"},
	}

	for _, test := range tests {
		err := verificationResponseError(test.input)
		if int(status.Code(err)) != test.wantCode {
			t.Fatalf("code for %q: got %v, want %v", test.input, status.Code(err), test.wantCode)
		}
		if actual := status.Convert(err).Message(); actual != test.wantMessage {
			t.Fatalf("message for %q: got %q, want %q", test.input, actual, test.wantMessage)
		}
		rpcError := mtproto.NewRpcError(err)
		if actual := rpcError.GetErrorMessage(); actual != test.wantMessage {
			t.Fatalf("MTProto message for %q: got %q, want %q", test.input, actual, test.wantMessage)
		}
	}
}
