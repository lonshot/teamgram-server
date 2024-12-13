package media_client

import (
	"github.com/zeromicro/go-zero/zrpc"
)

type MediaClientHelper struct {
	cli MediaClient
}

func NewMediaClientHelper(cli zrpc.Client) *MediaClientHelper {
	return &MediaClientHelper{
		cli: NewMediaClient(cli),
	}
}

func (m *MediaClientHelper) Client() MediaClient {
	return m.cli
}
