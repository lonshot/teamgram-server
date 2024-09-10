package core

import (
	"pwm-server/app/service/biz/chat/chat"
	"pwm-server/app/service/biz/chat/internal/dal/dataobject"
)

// ChatGetRecentChatInviteRequesters
// chat.getRecentChatInviteRequesters self_id:long chat_id:long = RecentChatInviteRequesters;
func (c *ChatCore) ChatGetRecentChatInviteRequesters(in *chat.TLChatGetRecentChatInviteRequesters) (*chat.RecentChatInviteRequesters, error) {
	rValue := chat.MakeTLRecentChatInviteRequesters(&chat.RecentChatInviteRequesters{
		RequestsPending:  0,
		RecentRequesters: []int64{},
	}).To_RecentChatInviteRequesters()

	doList, _ := c.svcCtx.Dao.ChatInviteParticipantsDAO.SelectRecentRequestedListWithCB(
		c.ctx,
		in.GetChatId(),
		func(sz, i int, v *dataobject.ChatInviteParticipantsDO) {
			rValue.RecentRequesters = append(rValue.RecentRequesters, v.UserId)
		})

	rValue.RequestsPending = int32(len(doList))

	return rValue, nil
}
