package core

import (
	"github.com/teamgram/proto/mtproto"
)

// HelpGetSupportName
// help.getSupportName#d360e72c = help.SupportName;
func (c *ConfigurationCore) HelpGetSupportName(in *mtproto.TLHelpGetSupportName) (*mtproto.Help_SupportName, error) {
	// TODO: not impl
	c.Logger.Errorf("help.getSupportName blocked, License key from https://teamgram.net required to unlock enterprise features.")

	return nil, mtproto.ErrEnterpriseIsBlocked
}
