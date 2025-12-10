package dao

import (
	"github.com/teamgram/marmota/pkg/stores/kv"
	"github.com/teamgram/proto/mtproto"
	"pwm-server/app/service/status/internal/config"
)

type Dao struct {
	KV kv.Store
	mtproto.RPCNotificationClient
}

func New(c config.Config) *Dao {
	d := &Dao{
		KV: kv.NewStore(c.Status),
	}

	return d
}
