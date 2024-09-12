package core

import (
	"github.com/teamgram/proto/mtproto"
	chatpb "pwm-server/app/service/biz/chat/chat" // Replace with your actual chat service import
	userpb "pwm-server/app/service/biz/user/user" // Replace with your actual user service import
	"time"
)

// MessagesGetOnlines
// messages.getOnlines#6e2be050 peer:InputPeer = ChatOnlines;
func (c *DialogsCore) MessagesGetOnlines(in *mtproto.TLMessagesGetOnlines) (*mtproto.ChatOnlines, error) {
	peer := mtproto.FromInputPeer2(c.MD.UserId, in.Peer)

	// Check if the peer is a valid chat
	if !peer.IsChat() {
		c.Logger.Errorf("MessagesGetOnlines - error: invalid peer type %v", peer)
		return nil, mtproto.ErrPeerIdInvalid
	}

	// Fetch the list of chat participants
	participantIds, err := c.svcCtx.ChatClient.ChatGetChatParticipantIdList(c.ctx, &chatpb.TLChatGetChatParticipantIdList{
		ChatId: peer.PeerId,
	})
	if err != nil {
		c.Logger.Errorf("MessagesGetOnlines - error fetching participants for chat %d: %v", peer.PeerId, err)
		return nil, err
	}

	// Initialize online count
	onlineCount := 0
	currentTime := time.Now().Unix()

	// Fetch user data for participants
	users, err := c.svcCtx.UserClient.UserGetMutableUsers(c.ctx, &userpb.TLUserGetMutableUsers{
		Id: participantIds.GetDatas(),
	})
	if err != nil {
		c.Logger.Errorf("MessagesGetOnlines - error fetching user data for participants: %v", err)
		return nil, err
	}

	// Check the online status of each participant
	for _, user := range users.GetDatas() {
		if isUserOnline(user, currentTime) {
			onlineCount++
		}
	}

	// Return the online count as a ChatOnlines object
	onlines := mtproto.MakeTLChatOnlines(&mtproto.ChatOnlines{
		Onlines: int32(onlineCount),
	}).To_ChatOnlines()

	// Log success
	c.Logger.Infof("MessagesGetOnlines - successfully fetched online users for chat %v, onlines: %d", peer, onlineCount)

	return onlines, nil
}

// isUserOnline checks if a user is considered online based on their LastSeenAt timestamp
func isUserOnline(user *mtproto.ImmutableUser, currentTime int64) bool {
	// If LastSeenAt is 0 or the user was seen in the last 5 minutes, consider the user online
	if user.LastSeenAt > 0 && (currentTime-user.LastSeenAt) <= 300 { // 5 minutes = 300 seconds
		return true
	}

	return false
}
