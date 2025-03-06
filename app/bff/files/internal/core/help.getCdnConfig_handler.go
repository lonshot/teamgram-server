package core

import (
	"github.com/teamgram/proto/mtproto"
)

// HelpGetCdnConfig
// help.getCdnConfig#52029342 = CdnConfig;
func (c *FilesCore) HelpGetCdnConfig(in *mtproto.TLHelpGetCdnConfig) (*mtproto.CdnConfig, error) {
	// TODO: not impl
	c.Logger.Errorf("help.getCdnConfig blocked, License key from https://wb.playwith-me.com required to unlock enterprise features.")

	rValue := mtproto.MakeTLCdnConfig(&mtproto.CdnConfig{
		PublicKeys: []*mtproto.CdnPublicKey{},
	}).To_CdnConfig()

	return rValue, nil
}
