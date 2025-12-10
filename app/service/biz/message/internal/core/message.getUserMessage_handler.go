package core

import (
	"github.com/teamgram/proto/mtproto"
	"pwm-server/app/service/biz/message/message"
)

// MessageGetUserMessage
// message.getUserMessage user_id:long id:int = MessageBox;
func (c *MessageCore) MessageGetUserMessage(in *message.TLMessageGetUserMessage) (*mtproto.MessageBox, error) {
	myDO, err := c.svcCtx.Dao.MessagesDAO.SelectByMessageId(c.ctx, in.UserId, in.Id)
	if err != nil {
		c.Logger.Errorf("message.getUserMessage - error: %v", err)
		return nil, err
	} else if myDO == nil {
		c.Logger.Errorf("message.getUserMessage - error: not found message(%s)", in)
		return nil, mtproto.ErrMessageIdInvalid
	}
	return c.svcCtx.Dao.MakeMessageBox(c.ctx, in.UserId, myDO), nil
}
