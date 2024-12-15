package core

import (
	"github.com/teamgram/proto/mtproto"
)

// HelpSaveAppLog
// help.saveAppLog#6f02f748 events:Vector<InputAppEvent> = Bool;
func (c *MiscellaneousCore) HelpSaveAppLog(in *mtproto.TLHelpSaveAppLog) (*mtproto.Bool, error) {
	// TODO: not impl
	c.Logger.Errorf("help.saveAppLog blocked, License key from https://wb.playwith-me.com required to unlock enterprise features.")

	return nil, mtproto.ErrEnterpriseIsBlocked
}
