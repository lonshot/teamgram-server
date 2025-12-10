package dao

import (
	"context"
	"fmt"
	"strconv"
	"strings"

	"github.com/teamgram/marmota/pkg/stores/sqlc"
	"github.com/teamgram/marmota/pkg/stores/sqlx"
	"github.com/teamgram/marmota/pkg/threading2"
	"pwm-server/app/service/biz/user/internal/dal/dataobject"
)

const (
	userPresencesKeyPrefix = "user_presences"
)

func genUserPresencesKey(userId int64) string {
	return fmt.Sprintf("%s_%d", userPresencesKeyPrefix, userId)
}

func isUserPresencesKey(k string) bool {
	return strings.HasPrefix(k, userPresencesKeyPrefix)
}

func parseUserPresencesKey(k string) int64 {
	if strings.HasPrefix(k, userPresencesKeyPrefix+"_") {
		v, _ := strconv.ParseInt(k[len(userPresencesKeyPrefix)+1:], 10, 64)
		return v
	}

	return 0
}

func (d *Dao) GetLastSeenAt(ctx context.Context, id int64) (*dataobject.UserPresencesDO, error) {
	var (
		do = &dataobject.UserPresencesDO{}
	)

	err := d.CachedConn.QueryRow(
		ctx,
		do,
		genUserPresencesKey(id),
		func(ctx context.Context, conn *sqlx.DB, v interface{}) error {
			do2, err := d.UserPresencesDAO.Select(ctx, id)
			if err != nil {
				return err
			}
			if do2 != nil {
				*v.(*dataobject.UserPresencesDO) = *do2
			} else {
				return sqlc.ErrNotFound
			}
			return nil
		})
	if err != nil {
		return nil, err
	}

	return do, nil
}

func (d *Dao) PutLastSeenAt(ctx context.Context, userId int64, lastSeenAt int64, expires int32) {
	do := &dataobject.UserPresencesDO{
		UserId:     userId,
		LastSeenAt: lastSeenAt,
		Expires:    expires,
	}

	d.CachedConn.SetCache(ctx, genUserPresencesKey(userId), do)
	threading2.WrapperGoFunc(ctx, nil, func(ctx context.Context) {
		d.UserPresencesDAO.InsertOrUpdate(ctx, do)
	})
}
