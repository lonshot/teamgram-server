package core

import (
	"github.com/teamgram/proto/mtproto"
)

// HelpGetAppConfig61E3F854
// help.getAppConfig#61e3f854 hash:int = help.AppConfig;
func (c *ConfigurationCore) HelpGetAppConfig61E3F854(in *mtproto.TLHelpGetAppConfig61E3F854) (
	*mtproto.Help_AppConfig, error,
) {
	//// TODO: not impl
	//c.Logger.Errorf("help.getAppConfig blocked, License key from https://teamgram.net required to unlock enterprise features.")

	return mtproto.MakeTLHelpAppConfig(
		&mtproto.Help_AppConfig{
			Hash: 0,
			Config: mtproto.MakeTLJsonObject(
				&mtproto.JSONValue{
					Value_VECTORJSONOBJECTVALUE: []*mtproto.JSONObjectValue{},
				},
			).To_JSONValue(),
		},
	).To_Help_AppConfig(), nil
}
