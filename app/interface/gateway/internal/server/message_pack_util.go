package server

import (
	"github.com/teamgram/proto/mtproto"
)

func parseFromIncomingMessage(b []byte) (msgId int64, obj mtproto.TLObject, err error) {
	dBuf := mtproto.NewDecodeBuf(b)

	msgId = dBuf.Long()
	_ = dBuf.Int()
	obj = dBuf.Object()
	err = dBuf.GetError()

	return
}

func serializeToBuffer(x *mtproto.EncodeBuf, msgId int64, obj mtproto.TLObject) error {
	//obj.Encode(x, 0)
	// x := mtproto.NewEncodeBuf(8 + 4 + len(oBuf))
	x.Long(0)
	x.Long(msgId)
	offset := x.GetOffset()
	x.Int(0)
	err := obj.Encode(x, 0)
	if err != nil {
		return err
	}
	//x.Bytes(oBuf)
	x.IntOffset(offset, int32(x.GetOffset()-offset-4))
	return nil
}
