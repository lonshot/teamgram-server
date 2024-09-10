package core

import (
	"github.com/teamgram/proto/mtproto"
)

// HelpGetAppConfig98914110
// help.getAppConfig#98914110 = JSONValue;
func (c *ConfigurationCore) HelpGetAppConfig98914110(in *mtproto.TLHelpGetAppConfig98914110) (*mtproto.JSONValue, error) {
	// TODO: not impl
	c.Logger.Errorf("help.getAppConfig blocked, License key from https://teamgram.net required to unlock enterprise features.")

	return mtproto.MakeTLJsonObject(&mtproto.JSONValue{
		Value_VECTORJSONOBJECTVALUE: []*mtproto.JSONObjectValue{},
	}).To_JSONValue(), nil
}
