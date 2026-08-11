package conf

import (
	"testing"
	"time"
)

func validConfig() *SmsVerifyCodeConfig {
	return &SmsVerifyCodeConfig{
		Name:           "me",
		Environment:    "Production",
		RequestTimeout: 5 * time.Second,
	}
}

func TestSmsVerifyCodeConfigRejectsNoneProviderInProduction(t *testing.T) {
	c := validConfig()
	c.Name = "none"
	if err := c.Validate(); err == nil {
		t.Fatal("expected production provider validation to fail")
	}
}

func TestSmsVerifyCodeConfigRejectsImplicitProductionBypass(t *testing.T) {
	c := validConfig()
	c.BypassEnabled = true
	c.BypassCode = "high-entropy-code"
	if err := c.Validate(); err == nil {
		t.Fatal("expected production bypass without opt-in to fail")
	}
}

func TestSmsVerifyCodeConfigAllowsExplicitProductionBypass(t *testing.T) {
	c := validConfig()
	c.BypassEnabled = true
	c.BypassAllowInProduction = true
	c.BypassCode = "12345"
	if err := c.Validate(); err != nil {
		t.Fatalf("expected explicit production bypass to validate: %v", err)
	}
}

func TestSmsVerifyCodeConfigRejectsTooShortBypass(t *testing.T) {
	c := validConfig()
	c.BypassEnabled = true
	c.BypassAllowInProduction = true
	c.BypassCode = "1234"
	if err := c.Validate(); err == nil {
		t.Fatal("expected bypass shorter than five characters to fail")
	}
}

func TestSmsVerifyCodeConfigRejectsDisabledBypassCode(t *testing.T) {
	c := validConfig()
	c.BypassCode = "high-entropy-code"
	if err := c.Validate(); err == nil {
		t.Fatal("expected disabled bypass with configured code to fail")
	}
}
