package core

import (
	"github.com/teamgram/proto/mtproto"
	"pwm-server/app/service/biz/user/user"
)

// UserCheckPrivacy
// user.checkPrivacy flags:# user_id:int key_type:int peer_id:int is_contact:flags.0?true = Bool;
func (c *UserCore) UserCheckPrivacy(in *user.TLUserCheckPrivacy) (*mtproto.Bool, error) {
	rules, err := c.UserGetPrivacy(&user.TLUserGetPrivacy{
		UserId:  in.UserId,
		KeyType: in.KeyType,
	})

	if err != nil {
		return mtproto.BoolFalse, nil
	} else if len(rules.GetDatas()) == 0 {
		return mtproto.BoolTrue, nil
	}

	// TODO(@benqi): check allow
	// return rulesData2.IsAllow(peerId, isContact)
	return mtproto.BoolTrue, nil

}
