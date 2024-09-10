package core

import (
	"github.com/teamgram/proto/mtproto"
	"pwm-server/app/messenger/sync/sync"
	"pwm-server/app/service/authsession/authsession"
)

// AccountResetAuthorization
// account.resetAuthorization#df77f3bc hash:long = Bool;
func (c *AccountCore) AccountResetAuthorization(in *mtproto.TLAccountResetAuthorization) (*mtproto.Bool, error) {
	if in.Hash == 0 {
		c.Logger.Errorf("account.resetAuthorization#df77f3bc - hash is 0")
		return mtproto.BoolFalse, nil
	}

	tKeyIdList, err := c.svcCtx.Dao.AuthsessionClient.AuthsessionResetAuthorization(c.ctx, &authsession.TLAuthsessionResetAuthorization{
		UserId:    c.MD.UserId,
		AuthKeyId: c.MD.PermAuthKeyId,
		Hash:      in.Hash,
	})

	if err != nil {
		c.Logger.Errorf("account.resetAuthorization#df77f3bc - error: %v", err)
		return nil, err
	}

	for _, id := range tKeyIdList.Datas {
		// notify kill session
		c.svcCtx.Dao.SyncClient.SyncUpdatesMe(
			c.ctx,
			&sync.TLSyncUpdatesMe{
				UserId:        c.MD.UserId,
				PermAuthKeyId: id,
				ServerId:      nil,
				AuthKeyId:     nil,
				SessionId:     nil,
				Updates:       mtproto.MakeTLUpdatesTooLong(nil).To_Updates(),
			})

		c.svcCtx.Dao.SyncClient.SyncUpdatesMe(
			c.ctx,
			&sync.TLSyncUpdatesMe{
				UserId:        c.MD.UserId,
				PermAuthKeyId: id,
				ServerId:      nil,
				AuthKeyId:     nil,
				SessionId:     nil,
				Updates: mtproto.MakeTLUpdateAccountResetAuthorization(&mtproto.Updates{
					UserId:    c.MD.UserId,
					AuthKeyId: id,
				}).To_Updates(),
			})
	}

	return mtproto.BoolTrue, nil
}
