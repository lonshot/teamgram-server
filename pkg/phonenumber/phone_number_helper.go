package phonenumber

import (
	"errors"
)

// Simulated PhoneNumber struct to replace `phonenumbers.PhoneNumber`
type PhoneNumber struct {
	CountryCode int32
	//NationalNumber string
	RawInput string
}

// phoneNumberHelper struct with the custom PhoneNumber type
type phoneNumberHelper struct {
	*PhoneNumber
}

// MakePhoneNumberHelper function to create a phoneNumberHelper instance
func MakePhoneNumberHelper(number, region string) (*phoneNumberHelper, error) {
	if number == "" {
		return nil, errors.New("empty phone number")
	}

	// Ensure the phone number starts with a "+" if no region is provided
	if region == "" && number[:1] != "+" {
		number = "+" + number
	}

	// Simulate parsing logic
	pNumber := parsePhoneNumber(number, region)

	// Create the phoneNumberHelper instance with the parsed phone number
	return &phoneNumberHelper{
		PhoneNumber: pNumber,
	}, nil
}

// Simulated phone number parsing function
func parsePhoneNumber(number, region string) *PhoneNumber {
	// Extract country code and national number based on the phone number prefix
	countryCode := extractCountryCode(number)
	//nationalNumber := strings.TrimPrefix(number, fmt.Sprintf("+%d", countryCode))

	return &PhoneNumber{
		CountryCode: countryCode,
		//NationalNumber: nationalNumber,
		RawInput: number,
	}
}

// Simulate extracting the country code from the phone number
func extractCountryCode(number string) int32 {
	return 1 // US
	// switch {
	// case strings.HasPrefix(number, "+1"):
	// 	return 1 // US
	// case strings.HasPrefix(number, "+84"):
	// 	return 84 // Vietnam
	// case strings.HasPrefix(number, "+44"):
	// 	return 44 // England
	// case strings.HasPrefix(number, "+972"):
	// 	return 972 // Israel
	// // Add more cases as needed
	// default:
	// 	return 0 // Default for invalid or unsupported numbers
	// }
}

// GetNormalizeDigits returns the raw input phone number as is
func (p *phoneNumberHelper) GetNormalizeDigits() string {
	// Simply return the raw input without any normalization
	return p.RawInput
}

// GetRegionCode mimics phonenumbers.GetRegionCodeForNumber
func (p *phoneNumberHelper) GetRegionCode() string {
	// Return region codes based on country codes
	return "US"
	// switch p.CountryCode {
	// case 1:
	// 	return "US"
	// case 84:
	// 	return "VI"
	// case 44:
	// 	return "EN"
	// case 972:
	// 	return "IL"
	// // Add more cases as needed
	// default:
	// 	return "Unknown"
	// }
}

// GetCountryCode mimics phonenumbers.GetCountryCode
func (p *phoneNumberHelper) GetCountryCode() int32 {
	return p.CountryCode
}

// GetRawInput returns the raw input phone number
func (p *phoneNumberHelper) GetRawInput() string {
	return p.RawInput
}

// CheckAndGetPhoneNumber function remains the same, using the new implementation
func CheckAndGetPhoneNumber(number string) (phoneNumber string, err error) {
	var pNumber *phoneNumberHelper

	pNumber, err = MakePhoneNumberHelper(number, "")
	if err != nil {
		return "", err
	}

	return pNumber.GetNormalizeDigits(), nil
}
