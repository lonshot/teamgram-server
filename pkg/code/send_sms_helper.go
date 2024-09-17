package code

import (
	"context"
	"pwm-server/pkg/code/me"

	"pwm-server/pkg/code/conf"
	"pwm-server/pkg/code/none"
)

type VerifyResponse struct {
	Valid          bool   `json:"valid"`
	Auto           bool   `json:"auto"`
	ConfirmationId string `json:"confirmationId"`
}

type VerifyCodeInterface interface {
	SendSmsVerifyCode(ctx context.Context, phoneNumber, code, codeHash, data string) (*VerifyResponse, error)
	VerifySmsCode(ctx context.Context, codeHash, code, extraData string) error
}

func NewVerifyCode(c *conf.SmsVerifyCodeConfig) VerifyCodeInterface {
	if c == nil {
		c = new(conf.SmsVerifyCodeConfig)
	}

	switch c.Name {
	// case "predefined":
	// 	return predefined.New(c)
	case "none":
		return none.New(c)
	}
	return me.New(c)
}
