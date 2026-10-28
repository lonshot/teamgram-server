package me

import (
	"errors"
	"regexp"
	"strings"
)

var nativeSocialProof = regexp.MustCompile(`^PWMN1\.[A-Za-z0-9_-]{43}$`)

// The opaque proof remains an opaque server-issued bearer credential. Go must
// not decode/trust a client JWT or synthesize the passwordless success marker.
func validateNativeSocialProof(phone, codeHash, data, secret string) (bool, error) {
	parts := strings.SplitN(data, "~~!~~", 2)
	if len(parts) != 2 {
		return false, nil
	}
	token := strings.SplitN(parts[1], "~~!@!~~", 2)[0]
	if !strings.HasPrefix(strings.ToUpper(token), "PWMN") {
		return false, nil
	}
	provider := registrationProvider(phone)
	if !nativeSocialProof.MatchString(token) || (provider != "apple" && provider != "facebook") ||
		strings.TrimSpace(secret) == "" || codeHash == "" || len(codeHash) > 256 {
		return true, errors.New("invalid native social proof request")
	}
	return true, nil
}
