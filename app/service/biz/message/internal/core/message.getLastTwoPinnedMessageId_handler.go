package core

import (
	"pwm-server/app/service/biz/message/message"

	"github.com/teamgram/proto/mtproto"
	"github.com/zeromicro/go-zero/core/logx"
)

// MessageGetLastTwoPinnedMessageId
// message.getLastTwoPinnedMessageId user_id:long peer_type:int peer_id:long = Vector<int>;
func (c *MessageCore) MessageGetLastTwoPinnedMessageId(in *message.TLMessageGetLastTwoPinnedMessageId) (*message.Vector_Int, error) {
	var (
		idList []int32
	)
	switch in.PeerType {
	case mtproto.PEER_SELF,
		mtproto.PEER_USER,
		mtproto.PEER_CHAT:
		dialogId := mtproto.MakeDialogId(in.UserId, in.PeerType, in.PeerId)
		idList, _ = c.svcCtx.Dao.MessagesDAO.SelectLastTwoPinnedList(c.ctx, in.UserId, dialogId.A, dialogId.B)
	case mtproto.PEER_CHANNEL:
		logx.Errorf("blocked, License key from https://wb.playwith-me.com required to unlock enterprise features.")
	}

	return &message.Vector_Int{
		Datas: idList,
	}, nil
}
