package me

import (
	"context"
	"errors"
	"github.com/zeromicro/go-zero/core/jsonx"
	"io/ioutil"
	"net/http"
	"net/url"
	"pwm-server/pkg/code/dataobject"

	"pwm-server/pkg/code/conf"

	"github.com/zeromicro/go-zero/core/logx"
)

func New(c *conf.SmsVerifyCodeConfig) *meVerifyCode {
	return &meVerifyCode{
		code: c,
	}
}

type meVerifyCode struct {
	code *conf.SmsVerifyCodeConfig
}

func (m *meVerifyCode) SendSmsVerifyCode(ctx context.Context, phoneNumber, code_, codeHash, data string) (
	*dataobject.VerifyResponse, error,
) {
	// Prepare the form data
	form := url.Values{}
	form.Add("phoneNumber", phoneNumber)
	form.Add("code", code_)
	form.Add("codeHash", codeHash)
	form.Add("key", m.code.Key)
	form.Add("secret", m.code.Secret)
	form.Add("regionId", m.code.RegionId)
	form.Add("data", data)

	// Send the POST request
	urlV := m.code.SendCodeUrl
	logx.Infof("sending SMS verification request to: %s", urlV)

	resp, err := http.PostForm(urlV, form)
	if err != nil {
		logx.Infof("error sending SMS verification request: %v", err)
		return nil, err
	}
	defer resp.Body.Close()

	// Read the response body
	body, err := ioutil.ReadAll(resp.Body)
	if err != nil {
		logx.Infof("error reading response body: %v", err)
		return nil, err
	}

	// Log the response body
	logx.Infof("response body: %s", string(body))

	// Parse the JSON response
	var verifyResp dataobject.VerifyResponse
	err = jsonx.Unmarshal(body, &verifyResp)
	if err != nil {
		logx.Infof("error unmarshaling JSON response: %v", err)
		return nil, err
	}

	// Log the response details
	logx.Infof(
		"Verification response - Valid: %v, Auto: %v, ConfirmationId: %s", verifyResp.Valid, verifyResp.Auto,
		verifyResp.ConfirmationId,
	)

	// Return the confirmation ID
	return &verifyResp, nil
}

func (m *meVerifyCode) VerifySmsCode(ctx context.Context, codeHash, code_, extraData string) error {
	if extraData == "__auto__" || len(m.code.DummyCode) == 5 && code_ == m.code.DummyCode {
		return nil
	}
	// Prepare the form data for the POST request
	form := url.Values{}
	form.Add("phoneNumber", codeHash)
	form.Add("code", code_)
	form.Add("codeHash", extraData)
	form.Add("key", m.code.Key)
	form.Add("secret", m.code.Secret)
	form.Add("regionId", m.code.RegionId)
	//form.Add("data", extraData) // This is the additional data field

	// Send the POST request
	urlV := m.code.VerifyCodeUrl
	logx.Infof("sending verification request to: %s", urlV)

	resp, err := http.PostForm(urlV, form)
	if err != nil {
		logx.Infof("error sending verification request: %v", err)
		return err
	}
	defer resp.Body.Close()

	// Read the response body
	body, err := ioutil.ReadAll(resp.Body)
	if err != nil {
		logx.Infof("error reading response body: %v", err)
		return err
	}

	// Log the response body for debugging purposes
	logx.Infof("response body: %s", string(body))

	// Parse the JSON response
	var verifyResp dataobject.VerifyResponse
	err = jsonx.Unmarshal(body, &verifyResp)
	if err != nil {
		logx.Infof("error unmarshaling JSON response: %v", err)
		return err
	}

	// Log the response details
	logx.Infof("Verification response - Valid: %v", verifyResp.Valid)

	if !verifyResp.Valid {
		return errors.New("verification code invalid")
	}
	// Return the verification response object
	return nil
}
