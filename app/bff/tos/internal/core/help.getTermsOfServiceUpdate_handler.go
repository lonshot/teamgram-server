package core

import (
	"time"

	"github.com/teamgram/proto/mtproto"
)

// HelpGetTermsOfServiceUpdate
// help.getTermsOfServiceUpdate#2ca51fd1 = help.TermsOfServiceUpdate;
func (c *TosCore) HelpGetTermsOfServiceUpdate(in *mtproto.TLHelpGetTermsOfServiceUpdate) (*mtproto.Help_TermsOfServiceUpdate, error) {
	// TODO: not impl
	c.Logger.Errorf("help.getTermsOfServiceUpdate blocked, License key from https://teamgram.net required to unlock enterprise features.")

	rValue := mtproto.MakeTLHelpTermsOfServiceUpdateEmpty(&mtproto.Help_TermsOfServiceUpdate{
		Expires: int32(time.Now().Unix() + 3600),
	}).To_Help_TermsOfServiceUpdate()

	return rValue, nil
}
