package premium_client

import (
	"context"

	"github.com/teamgram/proto/mtproto"

	"github.com/zeromicro/go-zero/zrpc"
)

var _ *mtproto.Bool

type PremiumClient interface {
	HelpGetPremiumPromo(ctx context.Context, in *mtproto.TLHelpGetPremiumPromo) (*mtproto.Help_PremiumPromo, error)
	PaymentsAssignAppStoreTransaction(ctx context.Context, in *mtproto.TLPaymentsAssignAppStoreTransaction) (*mtproto.Updates, error)
	PaymentsAssignPlayMarketTransaction(ctx context.Context, in *mtproto.TLPaymentsAssignPlayMarketTransaction) (*mtproto.Updates, error)
	PaymentsCanPurchasePremium(ctx context.Context, in *mtproto.TLPaymentsCanPurchasePremium) (*mtproto.Bool, error)
}

type defaultPremiumClient struct {
	cli zrpc.Client
}

func NewPremiumClient(cli zrpc.Client) PremiumClient {
	return &defaultPremiumClient{
		cli: cli,
	}
}

// HelpGetPremiumPromo
// help.getPremiumPromo#b81b93d4 = help.PremiumPromo;
func (m *defaultPremiumClient) HelpGetPremiumPromo(ctx context.Context, in *mtproto.TLHelpGetPremiumPromo) (*mtproto.Help_PremiumPromo, error) {
	client := mtproto.NewRPCPremiumClient(m.cli.Conn())
	return client.HelpGetPremiumPromo(ctx, in)
}

// PaymentsAssignAppStoreTransaction
// payments.assignAppStoreTransaction#80ed747d receipt:bytes purpose:InputStorePaymentPurpose = Updates;
func (m *defaultPremiumClient) PaymentsAssignAppStoreTransaction(ctx context.Context, in *mtproto.TLPaymentsAssignAppStoreTransaction) (*mtproto.Updates, error) {
	client := mtproto.NewRPCPremiumClient(m.cli.Conn())
	return client.PaymentsAssignAppStoreTransaction(ctx, in)
}

// PaymentsAssignPlayMarketTransaction
// payments.assignPlayMarketTransaction#dffd50d3 receipt:DataJSON purpose:InputStorePaymentPurpose = Updates;
func (m *defaultPremiumClient) PaymentsAssignPlayMarketTransaction(ctx context.Context, in *mtproto.TLPaymentsAssignPlayMarketTransaction) (*mtproto.Updates, error) {
	client := mtproto.NewRPCPremiumClient(m.cli.Conn())
	return client.PaymentsAssignPlayMarketTransaction(ctx, in)
}

// PaymentsCanPurchasePremium
// payments.canPurchasePremium#9fc19eb6 purpose:InputStorePaymentPurpose = Bool;
func (m *defaultPremiumClient) PaymentsCanPurchasePremium(ctx context.Context, in *mtproto.TLPaymentsCanPurchasePremium) (*mtproto.Bool, error) {
	client := mtproto.NewRPCPremiumClient(m.cli.Conn())
	return client.PaymentsCanPurchasePremium(ctx, in)
}
