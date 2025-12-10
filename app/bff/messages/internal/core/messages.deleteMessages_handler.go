package core

import (
	"github.com/teamgram/proto/mtproto"
	msgpb "pwm-server/app/messenger/msg/msg/msg"
)

// MessagesDeleteMessages
// messages.deleteMessages#e58e95d2 flags:# revoke:flags.0?true id:Vector<int> = messages.AffectedMessages;
func (c *MessagesCore) MessagesDeleteMessages(in *mtproto.TLMessagesDeleteMessages) (*mtproto.Messages_AffectedMessages, error) {
	// TODO(@benqi): Check message service.
	affectedMessages, err := c.svcCtx.Dao.MsgClient.MsgDeleteMessages(c.ctx, &msgpb.TLMsgDeleteMessages{
		UserId:    c.MD.UserId,
		AuthKeyId: c.MD.PermAuthKeyId,
		PeerType:  mtproto.PEER_EMPTY,
		PeerId:    0,
		Revoke:    in.Revoke,
		Id:        in.Id,
	})

	if err != nil {
		c.Logger.Errorf("messages.deleteMessages - error: %v", err)
		return nil, err
	}

	return affectedMessages, nil
}
