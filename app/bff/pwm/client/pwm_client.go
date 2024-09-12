package pwm_client

import (
	"github.com/teamgram/proto/mtproto"

	"github.com/zeromicro/go-zero/zrpc"
)

var _ *mtproto.Bool

type PwmClient interface {
}

type defaultMiscellaneousClient struct {
	cli zrpc.Client
}

func NewMiscellaneousClient(cli zrpc.Client) PwmClient {
	return &defaultMiscellaneousClient{
		cli: cli,
	}
}
