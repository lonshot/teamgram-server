package core

import (
	"github.com/teamgram/proto/mtproto"
	"pwm-server/app/messenger/sync/sync"
	userpb "pwm-server/app/service/biz/user/user"
)

// AccountUpdateProfile
// account.updateProfile#78515775 flags:# first_name:flags.0?string last_name:flags.1?string about:flags.2?string = User;
func (c *UserProfileCore) AccountUpdateProfile(in *mtproto.TLAccountUpdateProfile) (*mtproto.User, error) {
	me, err := c.svcCtx.Dao.UserClient.UserGetImmutableUser(c.ctx, &userpb.TLUserGetImmutableUser{
		Id: c.MD.UserId,
	})

	if in.GetAbout() != nil {
		//// about长度<70并且可以为emtpy
		if len(in.GetAbout().GetValue()) > 70 {
			err = mtproto.ErrAboutTooLong
			c.Logger.Errorf("account.updateProfile - error: %v", err)
			return nil, err
		}

		if in.GetAbout().GetValue() != me.About() {
			if _, err = c.svcCtx.Dao.UserClient.UserUpdateAbout(c.ctx, &userpb.TLUserUpdateAbout{
				UserId: c.MD.UserId,
				About:  in.GetAbout().GetValue(),
			}); err != nil {
				c.Logger.Errorf("account.updateProfile - error: %v", err)
			} else {
				me.SetAbout(in.GetAbout().GetValue())
			}
		}
	} else {
		if in.GetFirstName().GetValue() == "" {
			err = mtproto.ErrFirstnameInvalid
			c.Logger.Errorf("account.updateProfile - error: bad request (%v)", err)
			return nil, err
		}

		if in.GetFirstName().GetValue() != me.FirstName() ||
			in.GetLastName().GetValue() != me.LastName() {
			if _, err = c.svcCtx.Dao.UserClient.UserUpdateFirstAndLastName(c.ctx, &userpb.TLUserUpdateFirstAndLastName{
				UserId:    c.MD.UserId,
				FirstName: in.GetFirstName().GetValue(),
				LastName:  in.GetLastName().GetValue(),
			}); err != nil {
				c.Logger.Errorf("account.updateProfile - error: %v", err)
			} else {
				me.SetFirstName(in.GetFirstName().GetValue())
				me.SetLastName(in.GetLastName().GetValue())
			}

			c.svcCtx.Dao.SyncClient.SyncUpdatesNotMe(c.ctx, &sync.TLSyncUpdatesNotMe{
				UserId:        c.MD.UserId,
				PermAuthKeyId: c.MD.PermAuthKeyId,
				Updates: mtproto.MakeUpdatesByUpdates(mtproto.MakeTLUpdateUserName(&mtproto.Update{
					UserId:    c.MD.UserId,
					FirstName: in.GetFirstName().GetValue(),
					LastName:  in.GetLastName().GetValue(),
					Username:  me.Username(),
				}).To_Update()),
			})
		}
	}

	return me.ToSelfUser(), nil
}
