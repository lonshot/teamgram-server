package core

import (
	"github.com/teamgram/proto/mtproto"
	"pwm-server/app/service/biz/dialog/dialog"
)

// DialogUpdateUnreadCount
// dialog.updateUnreadCount flags:# user_id:long peer_type:int peer_id:long unread_count:flags.0?int unread_mentions_count:flags.1?int unread_reactions_count:flags.2?int = Bool;
func (c *DialogCore) DialogUpdateUnreadCount(in *dialog.TLDialogUpdateUnreadCount) (*mtproto.Bool, error) {
	var (
		unreadCount          = in.GetUnreadCount().GetValue()
		unreadMentionsCount  = in.GetUnreadMentionsCount().GetValue()
		unreadReactionsCount = in.GetUnreadReactionsCount().GetValue()
	)

	c.svcCtx.Dao.DialogsDAO.UpdateUnreadCount(
		c.ctx,
		unreadCount,
		unreadMentionsCount,
		unreadReactionsCount,
		in.UserId,
		in.PeerType,
		in.PeerId)

	return mtproto.BoolTrue, nil
}
