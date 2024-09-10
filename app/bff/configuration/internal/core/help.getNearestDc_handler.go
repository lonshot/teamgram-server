package core

import (
	"github.com/teamgram/proto/mtproto"
)

// HelpGetNearestDc
// help.getNearestDc#1fb33026 = NearestDc;
func (c *ConfigurationCore) HelpGetNearestDc(in *mtproto.TLHelpGetNearestDc) (*mtproto.NearestDc, error) {
	// TODO: not impl
	_ = in

	// TODO: not impl
	c.Logger.Errorf("help.getNearestDc blocked, License key from https://teamgram.net required to unlock enterprise features.")

	rValue := mtproto.MakeTLNearestDc(&mtproto.NearestDc{
		Country:   "CN",
		ThisDc:    1,
		NearestDc: 1,
	}).To_NearestDc()

	return rValue, nil
}
