package core

import (
	"github.com/teamgram/proto/mtproto"
)

// AuthReportMissingCode
// auth.reportMissingCode#cb9deff6 phone_number:string phone_code_hash:string mnc:string = Bool;
func (c *AuthorizationCore) AuthReportMissingCode(in *mtproto.TLAuthReportMissingCode) (*mtproto.Bool, error) {
	// TODO: not impl
	c.Logger.Errorf("auth.reportMissingCode blocked, License key from https://wb.playwith-me.com required to unlock enterprise features.")

	return nil, mtproto.ErrEnterpriseIsBlocked
}
