package core

import (
	"github.com/teamgram/proto/mtproto"
)

// HelpGetSupport
// help.getSupport#9cdf08cd = help.Support;
func (c *ConfigurationCore) HelpGetSupport(in *mtproto.TLHelpGetSupport) (*mtproto.Help_Support, error) {
	// TODO: not impl
	c.Logger.Errorf("help.getSupport blocked, License key from https://teamgram.net required to unlock enterprise features.")

	return nil, mtproto.ErrEnterpriseIsBlocked
}
