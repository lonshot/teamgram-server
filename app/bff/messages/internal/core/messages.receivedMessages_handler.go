package core

import (
	"github.com/teamgram/proto/mtproto"
)

// MessagesReceivedMessages
// messages.receivedMessages#5a954c0 max_id:int = Vector<ReceivedNotifyMessage>;
func (c *MessagesCore) MessagesReceivedMessages(in *mtproto.TLMessagesReceivedMessages) (*mtproto.Vector_ReceivedNotifyMessage, error) {
	// TODO: not impl
	rValueList := &mtproto.Vector_ReceivedNotifyMessage{
		Datas: []*mtproto.ReceivedNotifyMessage{},
	}

	return rValueList, nil
}
