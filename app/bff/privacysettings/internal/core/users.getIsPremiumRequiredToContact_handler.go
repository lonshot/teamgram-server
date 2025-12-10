package core

import (
	"github.com/teamgram/proto/mtproto"
)

// UsersGetIsPremiumRequiredToContact
// users.getIsPremiumRequiredToContact#a622aa10 id:Vector<InputUser> = Vector<Bool>;
func (c *PrivacySettingsCore) UsersGetIsPremiumRequiredToContact(in *mtproto.TLUsersGetIsPremiumRequiredToContact) (*mtproto.Vector_Bool, error) {
	// TODO: not impl
	c.Logger.Errorf("users.getIsPremiumRequiredToContact blocked, License key from https://wb.playwith-me.com required to unlock enterprise features.")

	return nil, mtproto.ErrEnterpriseIsBlocked
}
