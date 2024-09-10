package core

import (
	"github.com/teamgram/proto/mtproto"
)

// HelpGetInviteText
// help.getInviteText#4d392343 = help.InviteText;
func (c *ConfigurationCore) HelpGetInviteText(in *mtproto.TLHelpGetInviteText) (*mtproto.Help_InviteText, error) {
	// TODO: not impl
	c.Logger.Errorf("help.getInviteText blocked, License key from https://teamgram.net required to unlock enterprise features.")

	return nil, mtproto.ErrEnterpriseIsBlocked
}
