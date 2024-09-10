package dao

import (
	"context"
	"strconv"

	"github.com/teamgram/proto/mtproto"
	sessionpb "pwm-server/app/interface/session/session"

	"github.com/zeromicro/go-zero/core/logx"
)

type CacheV struct {
	V *mtproto.AuthKeyInfo
}

func (c CacheV) Size() int {
	return 1
}

func (d *Dao) GetCacheAuthKey(ctx context.Context, authKeyId int64) (*mtproto.AuthKeyInfo, error) {
	var (
		cacheK = strconv.Itoa(int(authKeyId))
		value  *mtproto.AuthKeyInfo
	)

	if v, ok := d.cache.Get(cacheK); ok {
		value = v.(*CacheV).V
	} else {
		sessClient, err := d.session.getSessionClient(strconv.FormatInt(authKeyId, 10))
		if err != nil {
			logx.WithContext(ctx).Errorf("getSessionClient error: %v, {authKeyId: %d}", err, authKeyId)
			return nil, err
		} else {
			value, err = sessClient.SessionQueryAuthKey(ctx, &sessionpb.TLSessionQueryAuthKey{
				AuthKeyId: authKeyId,
			})
			if err != nil {
				logx.WithContext(ctx).Errorf("sessionQueryAuthKey - error: %v", err)
				return nil, err
			}
			d.PutAuthKey(value)
		}
	}

	return value, nil
}

func (d *Dao) PutAuthKey(keyInfo *mtproto.AuthKeyInfo) {
	var (
		cacheK = strconv.Itoa(int(keyInfo.AuthKeyId))
	)

	// TODO: expires_in
	d.cache.Set(cacheK, &CacheV{V: keyInfo})
}
