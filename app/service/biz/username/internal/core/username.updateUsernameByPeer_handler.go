package core

import (
	"github.com/teamgram/marmota/pkg/stores/sqlx"
	"github.com/teamgram/proto/mtproto"
	"pwm-server/app/service/biz/username/internal/dal/dataobject"
	"pwm-server/app/service/biz/username/username"
)

// UsernameUpdateUsernameByPeer
// username.updateUsernameByPeer peer_type:int peer_id:int username:string = Bool;
func (c *UsernameCore) UsernameUpdateUsernameByPeer(in *username.TLUsernameUpdateUsernameByPeer) (*mtproto.Bool, error) {
	_, _, err := c.svcCtx.Dao.UsernameDAO.Insert(c.ctx, &dataobject.UsernameDO{
		Username: in.Username,
		PeerType: in.PeerType,
		PeerId:   in.PeerId,
	})

	if err != nil {
		if sqlx.IsDuplicate(err) {
			return mtproto.BoolFalse, nil
		} else {
			c.Logger.Errorf("username.updateUsername - error: %v", err)
			return nil, err
		}
	}

	return mtproto.BoolTrue, nil
}
