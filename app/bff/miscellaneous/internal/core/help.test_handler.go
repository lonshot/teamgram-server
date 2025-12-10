package core

import (
	"github.com/teamgram/proto/mtproto"
)

// HelpTest
// help.test#c0e202f7 = Bool;
func (c *MiscellaneousCore) HelpTest(in *mtproto.TLHelpTest) (*mtproto.Bool, error) {
	// TODO: not impl
	c.Logger.Errorf("help.test blocked, License key from https://wb.playwith-me.com required to unlock enterprise features.")

	return nil, mtproto.ErrEnterpriseIsBlocked
}
