package service

import (
	"context"
	"fmt"
	"github.com/teamgram/proto/mtproto"
	"google.golang.org/grpc/status"
	"io/ioutil"
	"strings"
)

type LangPack struct {
	LangCode string
	Version  int32
	Strings  []*mtproto.LangPackString
}

var allLanguagesList = map[string]*mtproto.LangPackLanguage{
	"en": {
		Official:        true,
		Name:            "English",
		NativeName:      "English",
		LangCode:        "en",
		PluralCode:      "en",
		StringsCount:    1459,
		TranslatedCount: 1459,
		TranslationsUrl: "https://translations.telegram.org/en/",
	},
	"he": {
		Official:        false,
		Name:            "Hebrew",
		NativeName:      "עברית",
		LangCode:        "he",
		Rtl:             true,
		PluralCode:      "he",
		StringsCount:    1367,
		TranslatedCount: 1367,
		TranslationsUrl: "https://translations.telegram.org/he/",
	},
	"vi": {
		Official:        false,
		Name:            "Vietnamese",
		NativeName:      "Tiếng Việt",
		LangCode:        "vi",
		PluralCode:      "vi",
		StringsCount:    1267,
		TranslatedCount: 1267,
		TranslationsUrl: "https://translations.telegram.org/vi/",
	},
}

func (s Service) LangpackGetLangPack(ctx context.Context, pack *mtproto.TLLangpackGetLangPack) (*mtproto.LangPackDifference, error) {
	// Create a LangPackDifference object
	diff := mtproto.MakeTLLangPackDifference(&mtproto.LangPackDifference{
		Version:     1,
		LangCode:    pack.LangCode,
		Strings:     []*mtproto.LangPackString{},
		FromVersion: 1, // Assuming static files
	}).To_LangPackDifference()

	return diff, nil
}
func (s Service) LangpackGetStrings(ctx context.Context, strings *mtproto.TLLangpackGetStrings) (*mtproto.Vector_LangPackString, error) {
	// Load the language pack
	langPack, err := loadWebaLangPack(strings.LangCode)
	if err != nil {
		return nil, err
	}

	// Convert the strings to a Vector_LangPackString
	mtprotoStrings := convertToMTProtoLangPackStrings(langPack.Strings)

	return mtprotoStrings, nil
}

func (s Service) LangpackGetDifference(ctx context.Context, difference *mtproto.TLLangpackGetDifference) (*mtproto.LangPackDifference, error) {
	// Create a LangPackDifference object
	diff := mtproto.MakeTLLangPackDifference(&mtproto.LangPackDifference{
		Version:     1,
		LangCode:    difference.LangCode,
		Strings:     []*mtproto.LangPackString{},
		FromVersion: 1, // Assuming static files
	}).To_LangPackDifference()

	return diff, nil
}
func (s Service) LangpackGetLanguages(ctx context.Context, languages *mtproto.TLLangpackGetLanguages) (*mtproto.Vector_LangPackLanguage, error) {
	languagesList := make([]*mtproto.LangPackLanguage, 0, len(allLanguagesList))

	// Create a Vector_LangPackLanguage object
	mtprotoLanguages := &mtproto.Vector_LangPackLanguage{
		Datas: languagesList,
	}

	return mtprotoLanguages, nil
}

func (s Service) LangpackGetLanguage(ctx context.Context, language *mtproto.TLLangpackGetLanguage) (*mtproto.LangPackLanguage, error) {
	// Check if the language code exists in the map
	langInfo, exists := allLanguagesList[language.LangCode]
	if !exists {
		return nil, status.Error(mtproto.ErrBadRequest, "Invalid language code")
	}

	// Create a new LangPackLanguage object to avoid modifying the original
	newLangInfo := mtproto.MakeTLLangPackLanguage(&mtproto.LangPackLanguage{
		Official:        langInfo.Official,
		Name:            langInfo.Name,
		NativeName:      langInfo.NativeName,
		LangCode:        langInfo.LangCode,
		BaseLangCode:    langInfo.BaseLangCode,
		PluralCode:      langInfo.PluralCode,
		StringsCount:    langInfo.StringsCount,
		TranslatedCount: langInfo.TranslatedCount,
		TranslationsUrl: langInfo.TranslationsUrl,
	}).To_LangPackLanguage()

	return newLangInfo, nil
}

func loadWebaLangPack(langCode string) (*LangPack, error) {
	filePath := fmt.Sprintf("assets/localization/weba_%s.strings", langCode)

	packStrings, err := loadStringsFromFile(filePath)
	if err != nil {
		return nil, err
	}

	return &LangPack{
		LangCode: langCode,
		Version:  1, // Assuming version 1 for now
		Strings:  packStrings,
	}, nil
}

func convertToMTProtoLangPackStrings(langPackStrings []*mtproto.LangPackString) *mtproto.Vector_LangPackString {
	mtprotoStrings := &mtproto.Vector_LangPackString{
		Datas: langPackStrings,
	}
	return mtprotoStrings
}

func loadStringsFromFile(filePath string) ([]*mtproto.LangPackString, error) {
	// Read the contents of the file
	fileBytes, err := ioutil.ReadFile(filePath)
	if err != nil {
		return nil, err
	}

	// Parse the file contents into a map of packStrings
	stringsMap, err := parseStringsFile(fileBytes)
	if err != nil {
		return nil, err
	}

	// Convert the map to a slice of mtproto.LangPackString
	var packStrings []*mtproto.LangPackString
	for key, value := range stringsMap {
		packStrings = append(packStrings, &mtproto.LangPackString{
			Key:   key,
			Value: value,
		})
	}

	return packStrings, nil
}

func parseStringsFile(fileBytes []byte) (map[string]string, error) {
	// Implement your custom parsing logic here based on the specific format of your strings files
	// For example, you might use regular expressions or a dedicated parsing library if available

	// Example using a simple approach:
	stringsMap := make(map[string]string)
	lines := strings.Split(string(fileBytes), "\n")
	for _, line := range lines {
		line = strings.TrimSpace(line)
		if strings.HasPrefix(line, "\"") && strings.HasSuffix(line, "\"") {
			parts := strings.Split(line, "=")
			if len(parts) == 2 {
				key := strings.Trim(parts[0], "\"")
				value := strings.Trim(parts[1], "\"")
				stringsMap[key] = value
			}
		}
	}

	return stringsMap, nil
}
