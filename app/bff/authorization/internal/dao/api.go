package dao

import (
	"errors"
	"net"
	"regexp"
	"strings"

	"github.com/zeromicro/go-zero/core/logx"
)

func (d *Dao) CheckApiIdAndHash(apiId int32, apiHash string) (string, string, error) {
	// Split the ApiHash by "~~!~~"
	parts := strings.Split(apiHash, "~~!~~")
	if len(parts) != 2 {
		return "", "", errors.New("invalid ApiHash format")
	}

	email := parts[0]
	socialToken := parts[1]

	// Allow "-" as a valid email
	if email != "-" {
		// Validate the email format using a basic regex
		emailRegex := `^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$`
		if !regexp.MustCompile(emailRegex).MatchString(email) {
			return "", "", errors.New("invalid email in ApiHash")
		}
	}

	// Ensure the social token is not empty
	if socialToken == "" {
		return "", "", errors.New("social token in ApiHash cannot be empty")
	}

	return email, socialToken, nil
}

func (d *Dao) GetCountryAndRegionByIp(ip string) (string, string) {
	if d.MMDB == nil {
		return "UNKNOWN", ""
	} else {
		r, err := d.MMDB.City(net.ParseIP(ip))
		if err != nil {
			logx.Errorf("getCountryAndRegionByIp - error: %v", err)
			return "UNKNOWN", ""
		}

		return r.City.Names["en"] + ", " + r.Country.Names["en"], r.Country.IsoCode
	}
}
