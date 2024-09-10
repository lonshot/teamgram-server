package core

import (
	"github.com/teamgram/proto/mtproto"
)

// HelpGetCountriesList
// help.getCountriesList#735787a8 lang_code:string hash:int = help.CountriesList;
func (c *ConfigurationCore) HelpGetCountriesList(in *mtproto.TLHelpGetCountriesList) (*mtproto.Help_CountriesList, error) {
	// TODO: not impl
	c.Logger.Errorf("help.getCountriesList blocked, License key from https://teamgram.net required to unlock enterprise features.")

	return mtproto.MakeTLHelpCountriesList(&mtproto.Help_CountriesList{
		Countries: []*mtproto.Help_Country{},
		Hash:      0,
	}).To_Help_CountriesList(), nil
}
