package svc

import (
	kafka "github.com/teamgram/marmota/pkg/mq"
	"github.com/teamgram/marmota/pkg/net/rpcx"
	"github.com/teamgram/marmota/pkg/stores/sqlx"
	inbox_client "pwm-server/app/messenger/msg/inbox/client"
	"pwm-server/app/messenger/msg/internal/dao"
	"pwm-server/app/messenger/msg/msg/internal/config"
	"pwm-server/app/messenger/msg/msg/plugin"
	sync_client "pwm-server/app/messenger/sync/client"
	chat_client "pwm-server/app/service/biz/chat/client"
	dialog_client "pwm-server/app/service/biz/dialog/client"
	user_client "pwm-server/app/service/biz/user/client"
	username_client "pwm-server/app/service/biz/username/client"
	idgen_client "pwm-server/app/service/idgen/client"
	"pwm-server/pkg/deduplication"
	"github.com/zeromicro/go-zero/core/stores/kv"
	"github.com/zeromicro/go-zero/core/stores/redis"
)

type ServiceContext struct {
	Config config.Config
	plugin.MsgPlugin
	*dao.Dao
}

func NewServiceContext(c config.Config, plugin plugin.MsgPlugin) *ServiceContext {
	db := sqlx.NewMySQL(&c.Mysql)
	svcCtx := &ServiceContext{
		Config:    c,
		MsgPlugin: plugin,
		Dao: &dao.Dao{
			Mysql:              dao.NewMysqlDao(db, c.MessageSharding),
			IDGenClient2:       idgen_client.NewIDGenClient2(rpcx.GetCachedRpcClient(c.IdgenClient)),
			UserClient:         user_client.NewUserClient(rpcx.GetCachedRpcClient(c.UserClient)),
			InboxClient:        inbox_client.NewInboxMqClient(kafka.MustKafkaProducer(c.InboxClient)),
			ChatClient:         chat_client.NewChatClient(rpcx.GetCachedRpcClient(c.ChatClient)),
			SyncClient:         sync_client.NewSyncMqClient(kafka.GetCachedMQClient(c.SyncClient)),
			DialogClient:       dialog_client.NewDialogClient(rpcx.GetCachedRpcClient(c.DialogClient)),
			MessageDeDuplicate: deduplication.NewMessageDeDuplicate(kv.NewStore(c.KV)),
			Redis:              redis.MustNewRedis(c.Redis2),
			UsernameClient:     username_client.NewUsernameClient(rpcx.GetCachedRpcClient(c.UsernameClient)),
		},
	}

	if plugin == nil {
		svcCtx.MsgPlugin = svcCtx.Dao
	}

	return svcCtx
}
