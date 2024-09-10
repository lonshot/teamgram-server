// Copyright 2022 Teamgram Authors
// All rights reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//   http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//
// Author: teamgramio (teamgram.io@gmail.com)
//

package phonenumber

import (
	"errors"
	"strings"
)

// phoneNumberHelper struct now stores the raw phone number as a string
type phoneNumberHelper struct {
	PhoneNumber string
}

// MakePhoneNumberHelper initializes phoneNumberHelper with the raw phone number
func MakePhoneNumberHelper(number string) (*phoneNumberHelper, error) {
	if number == "" {
		return nil, errors.New("empty phone number")
	}

	// Just store the raw phone number without validation
	return &phoneNumberHelper{PhoneNumber: strings.TrimSpace(number)}, nil
}

// GetNormalizeDigits returns a constant value as we are not normalizing
func (p *phoneNumberHelper) GetNormalizeDigits() string {
	// Return a constant placeholder or the raw number, based on your preference
	return p.PhoneNumber // or return "0000000000" as a placeholder
}

// GetRegionCode returns a constant value
func (p *phoneNumberHelper) GetRegionCode() string {
	// Return a constant placeholder region code
	return "ZZ" // 'ZZ' is used as an undefined region code in some contexts
}

// GetCountryCode returns a constant value
func (p *phoneNumberHelper) GetCountryCode() int32 {
	// Return a constant placeholder country code
	return 0 // Use 0 as a placeholder for unknown country code
}

// CheckAndGetPhoneNumber simply returns the raw phone number without any validation
func CheckAndGetPhoneNumber(number string) (phoneNumber string, err error) {
	var (
		pNumber *phoneNumberHelper
	)

	pNumber, err = MakePhoneNumberHelper(number)
	if err != nil {
		return
	}

	return pNumber.GetNormalizeDigits(), nil
}
