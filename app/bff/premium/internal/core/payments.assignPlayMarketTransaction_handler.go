package core

import (
	"github.com/teamgram/proto/mtproto"
)

// PaymentsAssignPlayMarketTransaction
// payments.assignPlayMarketTransaction#dffd50d3 receipt:DataJSON purpose:InputStorePaymentPurpose = Updates;
func (c *PremiumCore) PaymentsAssignPlayMarketTransaction(in *mtproto.TLPaymentsAssignPlayMarketTransaction) (*mtproto.Updates, error) {
	// TODO: not impl
	c.Logger.Errorf("payments.assignPlayMarketTransaction blocked, License key from https://wb.playwith-me.com required to unlock enterprise features.")

	return nil, mtproto.ErrEnterpriseIsBlocked
}
