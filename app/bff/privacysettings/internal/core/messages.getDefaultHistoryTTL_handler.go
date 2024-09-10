package core

import (
	"github.com/teamgram/proto/mtproto"
)

// MessagesGetDefaultHistoryTTL
// messages.getDefaultHistoryTTL#658b7188 = DefaultHistoryTTL;
func (c *PrivacySettingsCore) MessagesGetDefaultHistoryTTL(in *mtproto.TLMessagesGetDefaultHistoryTTL) (*mtproto.DefaultHistoryTTL, error) {
	// TODO: not impl
	c.Logger.Errorf("messages.getDefaultHistoryTTL blocked, License key from https://teamgram.net required to unlock enterprise features.")

	return nil, mtproto.ErrEnterpriseIsBlocked
}
