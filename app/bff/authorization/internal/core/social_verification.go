package core

import (
	"strings"

	"github.com/teamgram/proto/mtproto"
	"google.golang.org/grpc/status"
)

func socialProviderFromPhoneNumber(phoneNumber string) string {
	normalized := strings.ToUpper(strings.TrimSpace(phoneNumber))
	switch {
	case strings.HasPrefix(normalized, "GOOGLE"):
		return "google"
	case strings.HasPrefix(normalized, "FACEBOOK"):
		return "facebook"
	case strings.HasPrefix(normalized, "APPLE"):
		return "apple"
	default:
		return "unknown"
	}
}

func verificationExtraData(confirmationID, email, phoneNumber string) string {
	return confirmationID + "@@" + email +
		"@@provider=" + socialProviderFromPhoneNumber(phoneNumber) +
		"@@registration_id=" + strings.TrimSpace(phoneNumber)
}

func verificationDeliveryError() error {
	return status.Error(mtproto.ErrInternal, "EMAIL_DELIVERY_FAILED")
}

// verificationResponseError preserves the small, public error contract returned
// by pwm-dotnet. Plain Go errors are intentionally collapsed to
// INTERNAL_SERVER_ERROR by the MTProto proxy, which made the client lose the
// actionable reason and show a generic retry message.
func verificationResponseError(errorCode string) error {
	switch strings.ToUpper(strings.TrimSpace(errorCode)) {
	case "EMAIL_ADDRESS_INVALID":
		return status.Error(mtproto.ErrBadRequest, "EMAIL_ADDRESS_INVALID")
	case "EMAIL_ADDRESS_OCCUPIED":
		return status.Error(mtproto.ErrBadRequest, "EMAIL_ADDRESS_OCCUPIED")
	case "EMAIL_DELIVERY_FAILED":
		return verificationDeliveryError()
	case "EMAIL_VERIFICATION_STATE_UNAVAILABLE":
		return status.Error(mtproto.ErrInternal, "EMAIL_VERIFICATION_STATE_UNAVAILABLE")
	default:
		// Do not expose arbitrary downstream text through the MTProto API.
		return verificationDeliveryError()
	}
}
