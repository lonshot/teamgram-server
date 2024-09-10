package core

import (
	"github.com/teamgram/proto/mtproto"
)

// PaymentsAssignAppStoreTransaction
// payments.assignAppStoreTransaction#80ed747d receipt:bytes purpose:InputStorePaymentPurpose = Updates;
func (c *PremiumCore) PaymentsAssignAppStoreTransaction(in *mtproto.TLPaymentsAssignAppStoreTransaction) (*mtproto.Updates, error) {
	// TODO: not impl
	c.Logger.Errorf("payments.assignAppStoreTransaction blocked, License key from https://teamgram.net required to unlock enterprise features.")

	return nil, mtproto.ErrEnterpriseIsBlocked
}
