package core

import (
	"pwm-server/app/service/biz/message/message"

	"github.com/teamgram/proto/mtproto"
)

// MessageUnPinAllMessages
// message.unPinAllMessages user_id:long peer_type:int peer_id:long = Vector<int>;
func (c *MessageCore) MessageUnPinAllMessages(in *message.TLMessageUnPinAllMessages) (*message.Vector_Int, error) {
	var (
		idList []int32
	)

	switch in.PeerType {
	case mtproto.PEER_SELF,
		mtproto.PEER_USER,
		mtproto.PEER_CHAT:
		dialogId := mtproto.MakeDialogId(in.UserId, in.PeerType, in.PeerId)
		idList, _ = c.svcCtx.Dao.MessagesDAO.SelectPinnedMessageIdList(c.ctx, in.UserId, dialogId.A, dialogId.B)
		if len(idList) > 0 {
			c.svcCtx.Dao.MessagesDAO.UpdateUnPinnedByIdList(c.ctx, in.UserId, idList)
		}
	case mtproto.PEER_CHANNEL:
		c.Logger.Errorf("message.unPinAllMessages blocked, License key from https://wb.playwith-me.com required to unlock enterprise features.")

		return nil, mtproto.ErrEnterpriseIsBlocked
	}

	return &message.Vector_Int{
		Datas: idList,
	}, nil
}
