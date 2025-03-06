package dao

import (
	"github.com/teamgram/proto/mtproto"
	"github.com/zeromicro/go-zero/core/jsonx"
)

const (
	versionField = "0"
)

var (
	defaultRules = []*mtproto.PrivacyRule{
		mtproto.MakeTLPrivacyValueAllowAll(nil).To_PrivacyRule(),
	}
	phoneNumberRules = []*mtproto.PrivacyRule{
		mtproto.MakeTLPrivacyValueDisallowAll(nil).To_PrivacyRule(),
	}

	defaultRulesData     string
	phoneNumberRulesData string
)

func init() {
	defaultRulesData, _ = jsonx.MarshalToString(defaultRules)
	phoneNumberRulesData, _ = jsonx.MarshalToString(phoneNumberRules)
}

type idxId struct {
	idx int
	id  int64
}

func removeAllNil(contacts []*mtproto.ContactData) []*mtproto.ContactData {
	for i := 0; i < len(contacts); {
		if contacts[i] != nil {
			i++
			continue
		}

		if i < len(contacts)-1 {
			copy(contacts[i:], contacts[i+1:])
		}

		contacts[len(contacts)-1] = nil
		contacts = contacts[:len(contacts)-1]
	}

	return contacts
}

func makeDefaultPrivacyRules(key int32) []*mtproto.PrivacyRule {
	if key == mtproto.PHONE_NUMBER {
		return phoneNumberRules
	} else {
		return defaultRules
	}
}
