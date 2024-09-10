package core

import (
	"github.com/teamgram/proto/mtproto"
)

// HelpAcceptTermsOfService
// help.acceptTermsOfService#ee72f79a id:DataJSON = Bool;
func (c *TosCore) HelpAcceptTermsOfService(in *mtproto.TLHelpAcceptTermsOfService) (*mtproto.Bool, error) {
	// TODO: not impl
	c.Logger.Errorf("help.acceptTermsOfService blocked, License key from https://teamgram.net required to unlock enterprise features.")

	return mtproto.BoolTrue, nil
}
