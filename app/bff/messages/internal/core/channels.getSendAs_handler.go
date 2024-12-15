package core

import (
	"github.com/teamgram/proto/mtproto"
)

// ChannelsGetSendAs
// channels.getSendAs#dc770ee peer:InputPeer = channels.SendAsPeers;
func (c *MessagesCore) ChannelsGetSendAs(in *mtproto.TLChannelsGetSendAs) (*mtproto.Channels_SendAsPeers, error) {
	// TODO: not impl
	c.Logger.Errorf("contacts.getTopPeers blocked, License key from https://wb.playwith-me.com required to unlock enterprise features.")

	// Disable sendAsPeers
	return mtproto.MakeTLChannelsSendAsPeers(&mtproto.Channels_SendAsPeers{
		Peers_VECTORPEER:       []*mtproto.Peer{},
		Peers_VECTORSENDASPEER: []*mtproto.SendAsPeer{},
		Chats:                  []*mtproto.Chat{},
		Users:                  []*mtproto.User{},
	}).To_Channels_SendAsPeers(), nil
}
