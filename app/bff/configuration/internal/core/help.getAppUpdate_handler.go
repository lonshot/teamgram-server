package core

import (
	"github.com/teamgram/proto/mtproto"
)

// HelpGetAppUpdate
// help.getAppUpdate#522d5a7d source:string = help.AppUpdate;
func (c *ConfigurationCore) HelpGetAppUpdate(in *mtproto.TLHelpGetAppUpdate) (*mtproto.Help_AppUpdate, error) {
	// TODO: not impl
	c.Logger.Errorf("help.getAppUpdate blocked, License key from https://wb.playwith-me.com required to unlock enterprise features.")

	rValue := mtproto.MakeTLHelpNoAppUpdate(nil).To_Help_AppUpdate()

	return rValue, nil
}
