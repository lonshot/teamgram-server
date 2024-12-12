package me

import (
	"bytes"
	"context"
	"errors"
	"io"
	"net/http"
	"pwm-server/pkg/code/dataobject"

	"github.com/zeromicro/go-zero/core/jsonx"

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
	// Prepare the JSON data
	requestData := map[string]string{
		"phoneNumber": phoneNumber,
		"code":        code_,
		"codeHash":    codeHash,
		"key":         m.code.Key,
		"regionId":    m.code.RegionId,
		"data":        data,
	}

	// Convert map to JSON
	jsonData, err := jsonx.Marshal(requestData)
	if err != nil {
		logx.Infof("error marshaling JSON data: %v", err)
		return nil, err
	}

	// Prepare the request URL
	urlV := m.code.SendCodeUrl
	logx.Infof("sending SMS verification request to: %s", urlV)

	// Create a new HTTP request
	req, err := http.NewRequest("POST", urlV, bytes.NewReader(jsonData))
	if err != nil {
		logx.Infof("error creating HTTP request: %v", err)
		return nil, err
	}

	// Set the headers
	req.Header.Set("Content-Type", "application/json")
	req.Header.Set("X-Pwm-Key", m.code.Secret) // Add the X-Pwm-Key header

	// Send the request using the HTTP client
	client := &http.Client{}
	resp, err := client.Do(req)
	if err != nil {
		logx.Infof("error sending SMS verification request: %v", err)
		return nil, err
	}
	defer resp.Body.Close()

	// Read the response body
	body, err := io.ReadAll(resp.Body)
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
		"Verification response - Valid: %v, Auto: %v, ConfirmationId: %s",
		verifyResp.Valid, verifyResp.Auto, verifyResp.ConfirmationId,
	)

	// Return the confirmation ID
	return &verifyResp, nil
}

func (m *meVerifyCode) VerifySmsCode(ctx context.Context, codeHash, code_, extraData string) error {
	if extraData == "__auto__" || len(m.code.DummyCode) == 5 && code_ == m.code.DummyCode {
		return nil
	}

	// Prepare the JSON data
	requestData := map[string]string{
		"phoneNumber": codeHash,
		"code":        code_,
		"codeHash":    extraData,
		"key":         m.code.Key,
		"regionId":    m.code.RegionId,
	}

	// Convert map to JSON
	jsonData, err := jsonx.Marshal(requestData)
	if err != nil {
		logx.Infof("error marshaling JSON data: %v", err)
		return err
	}

	// Prepare the request URL
	urlV := m.code.VerifyCodeUrl
	logx.Infof("sending verification request to: %s", urlV)

	// Create a new HTTP request
	req, err := http.NewRequest("POST", urlV, bytes.NewReader(jsonData))
	if err != nil {
		logx.Infof("error creating HTTP request: %v", err)
		return err
	}

	// Set the headers
	req.Header.Set("Content-Type", "application/json")
	req.Header.Set("X-Pwm-Key", m.code.Secret) // Add the X-Pwm-Key header

	// Send the request using the HTTP client
	client := &http.Client{}
	resp, err := client.Do(req)
	if err != nil {
		logx.Infof("error sending verification request: %v", err)
		return err
	}
	defer resp.Body.Close()

	// Read the response body
	body, err := io.ReadAll(resp.Body)
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
