package dao

import (
	"context"
	"fmt"
	"strconv"
	"time"

	"pwm-server/app/interface/httpserver/internal/config"
	sessionpb "pwm-server/app/interface/session/session"
	msg_client "pwm-server/app/messenger/msg/msg/client"

	"github.com/teamgram/marmota/pkg/cache"
	"github.com/teamgram/marmota/pkg/net/rpcx"
	"github.com/teamgram/marmota/pkg/stores/kv"
	"github.com/teamgram/proto/mtproto"

	"github.com/zeromicro/go-zero/core/collection"
	"github.com/zeromicro/go-zero/core/logx"
)

// Dao dao.
type Dao struct {
	session                *Session
	cache                  *cache.LRUCache
	handshakeStateCtxCache *collection.Cache
	Handshake              *handshake
	msg_client.MsgClient
	KV kv.Store
}

// New new a dao and return.
func New(c config.Config) (dao *Dao) {
	dao = new(Dao)
	dao.session = NewSession(c)
	dao.cache = cache.NewLRUCache(10 * 1024 * 1024) // cache capacity: 10MB
	dao.handshakeStateCtxCache, _ = collection.NewCache(time.Minute)
	dao.MsgClient = msg_client.NewMsgClient(rpcx.GetCachedRpcClient(c.MsgClient))

	dao.KV = kv.NewStore(c.KV)
	keyFingerprint, err := strconv.ParseUint(c.KeyFingerprint, 10, 64)
	if err != nil {
		panic(c.KeyFingerprint)
	}
	dao.Handshake, err = newHandshake(c.KeyFile, keyFingerprint, dao.createAuthKey)
	if err != nil {
		panic(c.KeyFingerprint)
	}

	return dao
}

func (d *Dao) createAuthKey(ctx context.Context, key *mtproto.AuthKeyInfo, salt *mtproto.FutureSalt, expiresIn int32) error {
	sessClient, err2 := d.session.getSessionClient(strconv.FormatInt(key.AuthKeyId, 10))
	if err2 != nil {
		logx.Errorf("getSessionClient error: %v, {authKeyId: %d}", err2, key.AuthKeyId)
		return err2
	}

	// Fix by @wuyun9527, 2018-12-21
	var (
		rB *mtproto.Bool
	)
	rB, err2 = sessClient.SessionSetAuthKey(context.Background(), &sessionpb.TLSessionSetAuthKey{
		AuthKey:    key,
		FutureSalt: salt,
		ExpiresIn:  expiresIn,
	})
	if err2 != nil {
		logx.Errorf("saveAuthKeyInfo not successful - auth_key_id:%d, err:%v", key.AuthKeyId, err2)
		return err2
	} else if !mtproto.FromBool(rB) {
		logx.Errorf("saveAuthKeyInfo not successful - auth_key_id:%d", key.AuthKeyId)
		err2 = fmt.Errorf("saveAuthKeyInfo error")
		return err2
	} else {
		d.PutAuthKey(&mtproto.AuthKeyInfo{
			AuthKeyId:          key.AuthKeyId,
			AuthKey:            key.AuthKey,
			AuthKeyType:        key.AuthKeyType,
			PermAuthKeyId:      key.PermAuthKeyId,
			TempAuthKeyId:      key.TempAuthKeyId,
			MediaTempAuthKeyId: key.MediaTempAuthKeyId})
	}
	return nil
}
