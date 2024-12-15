package core

import (
	"github.com/teamgram/proto/mtproto"
)

// PaymentsCanPurchasePremium
// payments.canPurchasePremium#9fc19eb6 purpose:InputStorePaymentPurpose = Bool;
func (c *PremiumCore) PaymentsCanPurchasePremium(in *mtproto.TLPaymentsCanPurchasePremium) (*mtproto.Bool, error) {
	// TODO: not impl
	// c.Logger.Errorf("payments.canPurchasePremium blocked, License key from https://wb.playwith-me.com required to unlock enterprise features.")

	return mtproto.BoolFalse, nil
}
