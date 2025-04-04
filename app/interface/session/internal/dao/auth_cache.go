package dao

import (
	"context"
	"fmt"
	"strconv"
	"time"

	"github.com/teamgram/proto/mtproto"
	"pwm-server/app/service/authsession/authsession"

	"github.com/zeromicro/go-zero/core/logx"
)

type cacheAuthValue struct {
	SaltList []*mtproto.TLFutureSalt
}

// Size Impl cache.Value interface
func (cv *cacheAuthValue) Size() int {
	return 1
}

func (d *Dao) getCacheValue(authKeyId int64) *cacheAuthValue {
	var (
		cacheK = strconv.FormatInt(authKeyId, 10)
	)

	if v, ok := d.cache.Get(cacheK); !ok {
		cv := new(cacheAuthValue)
		d.cache.Set(cacheK, cv)
		return cv
	} else {
		return v.(*cacheAuthValue)
	}
}

func (d *Dao) getFutureSaltList(ctx context.Context, authKeyId int64) ([]*mtproto.TLFutureSalt, bool) {
	var (
		cv   = d.getCacheValue(authKeyId)
		date = int32(time.Now().Unix())
	)

	if len(cv.SaltList) > 0 {
		futureSalts := cv.SaltList
		for i, salt := range futureSalts {
			if salt.Data2.ValidUntil >= date {
				if i > 0 {
					return futureSalts[i-1:], true
				} else {
					return futureSalts[i:], true
				}
			}
		}
	}

	futureSalts, err := d.AuthsessionClient.AuthsessionGetFutureSalts(ctx, &authsession.TLAuthsessionGetFutureSalts{
		AuthKeyId: authKeyId,
	})
	if err != nil {
		logx.WithContext(ctx).Error(err.Error())
		return nil, false
	}

	saltList := futureSalts.GetSalts()
	for i, salt := range saltList {
		if salt.Data2.ValidUntil >= date {
			if i > 0 {
				saltList = saltList[i-1:]
				cv.SaltList = saltList
				return saltList, true
			} else {
				saltList = saltList[i:]
				cv.SaltList = saltList
				return saltList, true
			}
		}
	}

	return nil, false
}

func (d *Dao) GetOrFetchNewSalt(ctx context.Context, authKeyId int64) (salt, lastInvalidSalt *mtproto.TLFutureSalt, err error) {
	cacheSalts, _ := d.getFutureSaltList(ctx, authKeyId)
	//TODO(@benqi): check len(cacheSalts) > 0
	if len(cacheSalts) < 2 {
		return nil, nil, fmt.Errorf("get salt error")
	} else {
		if cacheSalts[0].GetValidUntil() >= int32(time.Now().Unix()) {
			return cacheSalts[0], nil, nil
		} else {
			return cacheSalts[1], cacheSalts[0], nil
		}
	}
}

func (d *Dao) GetFutureSalts(ctx context.Context, authKeyId int64, num int32) ([]*mtproto.TLFutureSalt, error) {
	cacheSalts, _ := d.getFutureSaltList(ctx, authKeyId)
	//TODO(@benqi): check len(cacheSalts) > 0

	return cacheSalts, nil
}
