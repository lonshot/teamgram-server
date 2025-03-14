package dao

import (
	kafka "github.com/teamgram/marmota/pkg/mq"
	"github.com/teamgram/marmota/pkg/net/rpcx"
	"github.com/teamgram/marmota/pkg/stores/sqlx"
	sync_client "pwm-server/app/messenger/sync/client"
	"pwm-server/app/messenger/sync/internal/config"
	chat_client "pwm-server/app/service/biz/chat/client"
	idgen_client "pwm-server/app/service/idgen/client"
	status_client "pwm-server/app/service/status/client"
	"github.com/zeromicro/go-zero/core/stores/kv"
	"github.com/zeromicro/go-zero/zrpc"
)

type Dao struct {
	*Mysql
	kv             kv.Store
	conf           *config.Config
	sessionServers map[string]*Session
	idgen_client.IDGenClient2
	status_client.StatusClient
	chat_client.ChatClient
	PushClient sync_client.SyncClient
}

func New(c config.Config) *Dao {
	db := sqlx.NewMySQL(&c.Mysql)
	d := &Dao{
		Mysql:          newMysqlDao(db),
		kv:             kv.NewStore(c.KV),
		conf:           &c,
		sessionServers: make(map[string]*Session),
		IDGenClient2:   idgen_client.NewIDGenClient2(zrpc.MustNewClient(c.IdgenClient)),
		StatusClient:   status_client.NewStatusClient(zrpc.MustNewClient(c.StatusClient)),
		ChatClient:     chat_client.NewChatClient(rpcx.GetCachedRpcClient(c.ChatClient)),
	}
	if c.PushClient != nil {
		d.PushClient = sync_client.NewSyncMqClient(kafka.MustKafkaProducer(c.PushClient))
	}

	go d.watch(c.SessionClient)
	return d
}
