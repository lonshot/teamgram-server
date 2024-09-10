package core

import (
	"github.com/teamgram/proto/mtproto"
	msgpb "pwm-server/app/messenger/msg/msg/msg"
)

// MessagesReadHistory
// messages.readHistory#e306d3a peer:InputPeer max_id:int = messages.AffectedMessages;
func (c *MessagesCore) MessagesReadHistory(in *mtproto.TLMessagesReadHistory) (*mtproto.Messages_AffectedMessages, error) {
	var (
		peer  = mtproto.FromInputPeer2(c.MD.UserId, in.Peer)
		maxId = in.MaxId
	)

	if !peer.IsChatOrUser() {
		err := mtproto.ErrPeerIdInvalid
		c.Logger.Errorf("messages.readHistory - error: %v", err)
		return nil, err
	}

	//if maxId == 0 || maxId >= 1000000000 {
	//	maxId = math.MaxInt32
	//}

	return c.svcCtx.Dao.MsgClient.MsgReadHistoryV2(
		c.ctx,
		&msgpb.TLMsgReadHistoryV2{
			UserId:    c.MD.UserId,
			AuthKeyId: c.MD.PermAuthKeyId,
			PeerType:  peer.PeerType,
			PeerId:    peer.PeerId,
			MaxId:     maxId,
		})
	//return c.svcCtx.Dao.MsgClient.MsgReadHistory(
	//	c.ctx,
	//	&msgpb.TLMsgReadHistory{
	//		UserId:    c.MD.UserId,
	//		AuthKeyId: c.MD.PermAuthKeyId,
	//		PeerType:  peer.PeerType,
	//		PeerId:    peer.PeerId,
	//		MaxId:     maxId,
	//	})
}
