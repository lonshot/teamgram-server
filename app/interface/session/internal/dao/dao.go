package dao

import (
	"context"

	"github.com/teamgram/marmota/pkg/cache"
	"github.com/teamgram/marmota/pkg/net/ip"
	"github.com/teamgram/proto/mtproto"
	"github.com/teamgram/proto/mtproto/rpc/metadata"
	bff_proxy_client "pwm-server/app/bff/bff/client"
	"pwm-server/app/interface/session/internal/config"
	authsession_client "pwm-server/app/service/authsession/client"
	status_client "pwm-server/app/service/status/client"

	"github.com/zeromicro/go-zero/zrpc"
)

type Dao struct {
	cache *cache.LRUCache
	authsession_client.AuthsessionClient
	status_client.StatusClient
	*bff_proxy_client.BFFProxyClient
	eGateServers map[string]*Gateway
	MyServerId   string
	*RpcShardingManager
}

func New(c config.Config) *Dao {
	myServerId := ip.FigureOutListenOn(c.ListenOn)
	d := &Dao{
		cache:              cache.NewLRUCache(1024 * 1024 * 1024),
		AuthsessionClient:  authsession_client.NewAuthsessionClient(zrpc.MustNewClient(c.AuthSession)),
		BFFProxyClient:     bff_proxy_client.NewBFFProxyClients(c.BFFProxyClients.Clients, c.BFFProxyClients.IDMap),
		StatusClient:       status_client.NewStatusClient(zrpc.MustNewClient(c.StatusClient)),
		eGateServers:       make(map[string]*Gateway),
		MyServerId:         myServerId,
		RpcShardingManager: NewRpcShardingManager(myServerId, c.Etcd),
	}

	d.watchGateway(c.GatewayClient)

	return d
}

func (d *Dao) InvokeContext(ctx context.Context, rpcMetaData *metadata.RpcMetadata, object mtproto.TLObject) (mtproto.TLObject, error) {
	return d.BFFProxyClient.InvokeContext(ctx, rpcMetaData, object)
}
