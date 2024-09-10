package core

import (
	"github.com/teamgram/proto/mtproto"
)

// AccountSaveAutoDownloadSettings
// account.saveAutoDownloadSettings#76f36233 flags:# low:flags.0?true high:flags.1?true settings:AutoDownloadSettings = Bool;
func (c *AutoDownloadCore) AccountSaveAutoDownloadSettings(in *mtproto.TLAccountSaveAutoDownloadSettings) (*mtproto.Bool, error) {
	// TODO: not impl
	c.Logger.Errorf("account.saveAutoDownloadSettings blocked, License key from https://teamgram.net required to unlock enterprise features.")

	return mtproto.BoolTrue, nil
}
