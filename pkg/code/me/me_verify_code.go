package me

import (
	"bytes"
	"context"
	"errors"
	"io"
	"net/http"
	"pwm-server/pkg/code/dataobject"

	"github.com/zeromicro/go-zero/core/jsonx"
	"github.com/zeromicro/go-zero/core/logx"

	"pwm-server/pkg/code/conf"
)

func New(c *conf.SmsVerifyCodeConfig) *meVerifyCode {
	return &meVerifyCode{
		code: c,
	}
}

type meVerifyCode struct {
	code *conf.SmsVerifyCodeConfig
}

// Shared function to send JSON POST request
func (m *meVerifyCode) postJson(url string, requestData map[string]string) ([]byte, error) {
	logx.Infof("Preparing to send POST request to URL: %s", url)
	logx.Infof("Request payload: %+v", requestData)

	// Convert map to JSON
	jsonData, err := jsonx.Marshal(requestData)
	if err != nil {
		logx.Errorf("Error marshaling JSON data: %v", err)
		return nil, err
	}

	// Create a new HTTP request
	req, err := http.NewRequest("POST", url, bytes.NewReader(jsonData))
	if err != nil {
		logx.Errorf("Error creating HTTP request: %v", err)
		return nil, err
	}

	// Set the headers
	req.Header.Set("Content-Type", "application/json")
	req.Header.Set("Accept", "application/json") // Expect JSON response
	req.Header.Set("X-Pwm-Key", m.code.Secret)   // Add the X-Pwm-Key header
	logx.Infof("Headers set: Content-Type=application/json, Accept=application/json, X-Pwm-Key=******")

	// Send the request using the HTTP client
	client := &http.Client{}
	resp, err := client.Do(req)
	if err != nil {
		logx.Errorf("Error sending request: %v", err)
		return nil, err
	}
	defer resp.Body.Close()

	logx.Infof("Response status code: %d", resp.StatusCode)

	// Read the response body
	body, err := io.ReadAll(resp.Body)
	if err != nil {
		logx.Errorf("Error reading response body: %v", err)
		return nil, err
	}

	logx.Infof("Response body received: %s", string(body))
	return body, nil
}

// Send SMS Verify Code using the shared function
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

	logx.Infof("Sending SMS verification request for phoneNumber: %s", phoneNumber)

	// Send JSON request
	urlV := m.code.SendCodeUrl
	body, err := m.postJson(urlV, requestData)
	if err != nil {
		logx.Errorf("Failed to send SMS verification request: %v", err)
		return nil, err
	}

	// Parse the JSON response
	var verifyResp dataobject.VerifyResponse
	err = jsonx.Unmarshal(body, &verifyResp)
	if err != nil {
		logx.Errorf("Error unmarshaling JSON response: %v", err)
		return nil, err
	}

	// Log the response details
	logx.Infof(
		"Verification response - Valid: %v, Auto: %v, ConfirmationId: %s",
		verifyResp.Valid, verifyResp.Auto, verifyResp.ConfirmationId,
	)

	return &verifyResp, nil
}

// Verify SMS Code using the shared function
func (m *meVerifyCode) VerifySmsCode(ctx context.Context, codeHash, code_, extraData string) error {
	logx.Infof("Verifying SMS code for codeHash: %s", codeHash)

	if extraData == "__auto__" || len(m.code.DummyCode) == 5 && code_ == m.code.DummyCode {
		logx.Infof("Auto-verification or dummy code detected, skipping server verification.")
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

	logx.Infof("Sending verification request for codeHash: %s", codeHash)

	// Send JSON request
	urlV := m.code.VerifyCodeUrl
	body, err := m.postJson(urlV, requestData)
	if err != nil {
		logx.Errorf("Failed to verify SMS code: %v", err)
		return err
	}

	// Parse the JSON response
	var verifyResp dataobject.VerifyResponse
	err = jsonx.Unmarshal(body, &verifyResp)
	if err != nil {
		logx.Errorf("Error unmarshaling JSON response: %v", err)
		return err
	}

	logx.Infof("Verification response - Valid: %v", verifyResp.Valid)

	if !verifyResp.Valid {
		logx.Errorf("Verification failed: Invalid code or confirmation.")
		return errors.New("verification code invalid")
	}

	logx.Infof("Verification succeeded for codeHash: %s", codeHash)
	return nil
}
