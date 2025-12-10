package code

import (
	"context"
	"pwm-server/pkg/code/dataobject"
	"pwm-server/pkg/code/me"

	"pwm-server/pkg/code/conf"
	"pwm-server/pkg/code/none"
)

type VerifyCodeInterface interface {
	SendSmsVerifyCode(ctx context.Context, phoneNumber, code, codeHash, data string) (*dataobject.VerifyResponse, error)
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
