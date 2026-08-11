package core

import "strings"

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
