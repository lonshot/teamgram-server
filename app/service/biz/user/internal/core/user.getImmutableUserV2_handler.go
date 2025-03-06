package core

import (
	"github.com/teamgram/proto/mtproto"
	"pwm-server/app/service/biz/user/user"
)

// UserGetImmutableUserV2
// user.getImmutableUserV2 flags:# id:long privacy:flags.0?true has_to:flags.2?true to:flags.2?Vector<long> = ImmutableUser;
// user.getImmutableUserV2 flags:# id:long privacy:flags.0?true contacts:flags.1?Vector<long> reverse_contacts:flags.2?Vector<long> = ImmutableUser;
func (c *UserCore) UserGetImmutableUserV2(in *user.TLUserGetImmutableUserV2) (*mtproto.ImmutableUser, error) {
	rV, err := c.svcCtx.Dao.GetImmutableUserV2(
		c.ctx,
		in.Id,
		in.Privacy,
		in.HasTo,
		in.To)
	if err != nil {
		c.Logger.Errorf("user.getImmutableUserV2(%s) - error: %v", in, err)
		return nil, err
	}

	return rV, nil
}
