// pwm-server/pkg/errors/errors.go
package errors

import "errors"

// Custom error definitions for mtproto error handling.
var (
	ErrPhoneCodeEmpty       = errors.New("PHONE_CODE_EMPTY")
	ErrPhoneCodeInvalid     = errors.New("PHONE_CODE_INVALID")
	ErrPhoneNumberOccupied  = errors.New("PHONE_NUMBER_OCCUPIED")
	ErrInternalServerError  = errors.New("INTERNAL_SERVER_ERROR")
	ErrEnterpriseIsBlocked  = errors.New("ENTERPRISE_FEATURE_BLOCKED")
	ErrReasonEmpty          = errors.New("REASON_EMPTY")
	ErrPhoneCodeSendFailure = errors.New("PHONE_CODE_SEND_FAILURE")
	ErrPhoneNumberInvalid   = errors.New("PHONE_NUMBER_INVALID")
	ErrPhoneCodeNotFound    = errors.New("PHONE_CODE_NOT_FOUND")
)
