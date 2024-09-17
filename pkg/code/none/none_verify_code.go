package none

import (
	"context"
	"pwm-server/pkg/code/dataobject"

	"github.com/teamgram/proto/mtproto"
	"pwm-server/pkg/code/conf"
)

func New(c *conf.SmsVerifyCodeConfig) *noneVerifyCode {
	return &noneVerifyCode{
		code: c,
	}
}

type noneVerifyCode struct {
	code *conf.SmsVerifyCodeConfig
}

func (m *noneVerifyCode) SendSmsVerifyCode(ctx context.Context, phoneNumber, code, codeHash, data string) (
	*dataobject.VerifyResponse, error,
) {
	return nil, nil
}

func (m *noneVerifyCode) VerifySmsCode(ctx context.Context, codeHash, code, extraData string) error {
	if code != "12345" {
		return mtproto.ErrPhoneCodeInvalid
	}
	return nil
}
