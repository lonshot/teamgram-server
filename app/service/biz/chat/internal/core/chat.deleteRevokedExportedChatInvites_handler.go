package core

import (
	"github.com/teamgram/proto/mtproto"
	"pwm-server/app/service/biz/chat/chat"
)

// ChatDeleteRevokedExportedChatInvites
// chat.deleteRevokedExportedChatInvites self_id:long chat_id:long admin_id:long = Bool;
func (c *ChatCore) ChatDeleteRevokedExportedChatInvites(in *chat.TLChatDeleteRevokedExportedChatInvites) (*mtproto.Bool, error) {
	_, err := c.svcCtx.Dao.ChatInvitesDAO.DeleteByRevoked(c.ctx, in.ChatId, in.AdminId)
	if err != nil {
		c.Logger.Errorf("chat.deleteRevokedExportedChatInvites - error: %v", err)
	}

	return mtproto.BoolTrue, nil
}
