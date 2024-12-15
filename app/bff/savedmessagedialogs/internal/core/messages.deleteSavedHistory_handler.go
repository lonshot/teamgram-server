package core

import (
	"github.com/teamgram/proto/mtproto"
)

// MessagesDeleteSavedHistory
// messages.deleteSavedHistory#6e98102b flags:# peer:InputPeer max_id:int min_date:flags.2?int max_date:flags.3?int = messages.AffectedHistory;
func (c *SavedMessageDialogsCore) MessagesDeleteSavedHistory(in *mtproto.TLMessagesDeleteSavedHistory) (*mtproto.Messages_AffectedHistory, error) {
	// TODO: not impl
	c.Logger.Errorf("messages.deleteSavedHistory blocked, License key from https://wb.playwith-me.com required to unlock enterprise features.")

	return nil, mtproto.ErrEnterpriseIsBlocked
}
