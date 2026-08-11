package conf

import (
	"crypto/subtle"
	"errors"
	"fmt"
	"strings"
	"time"
)

func SecureCodeEqual(actual, expected string) bool {
	if len(actual) != len(expected) {
		return false
	}
	return subtle.ConstantTimeCompare([]byte(actual), []byte(expected)) == 1
}

type SmsVerifyCodeConfig struct {
	Name                    string
	Environment             string `json:",default=Development"`
	SendCodeUrl             string
	VerifyCodeUrl           string
	PushMessageUrl          string
	Key                     string
	Secret                  string
	RegionId                string
	RequestTimeout          time.Duration `json:",default=20s"`
	AutoVerifyEnabled       bool          `json:",default=false"`
	BypassEnabled           bool          `json:",default=false"`
	BypassAllowInProduction bool          `json:",default=false"`
	BypassCode              string        `json:",optional"`
}

const minBypassCodeLength = 5

func (c *SmsVerifyCodeConfig) Validate() error {
	if c == nil {
		return errors.New("verification code configuration is required")
	}

	isProduction := strings.EqualFold(c.Environment, "Production")
	if isProduction && strings.EqualFold(c.Name, "none") {
		return errors.New("verification provider 'none' is forbidden in production")
	}
	if c.RequestTimeout <= 0 {
		return errors.New("verification request timeout must be positive")
	}
	if c.BypassEnabled {
		if len(c.BypassCode) < minBypassCodeLength {
			return fmt.Errorf("verification bypass code must contain at least %d characters", minBypassCodeLength)
		}
		if isProduction && !c.BypassAllowInProduction {
			return errors.New("production verification bypass requires explicit production opt-in")
		}
	} else if c.BypassCode != "" {
		return fmt.Errorf("verification bypass code is configured while bypass is disabled")
	}

	return nil
}

type WebrtcConfig struct {
	Turn     bool
	Stun     bool
	Ip       string
	Ipv6     string
	Port     int
	Username string
	Password string
}
