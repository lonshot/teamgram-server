// Copyright (c) 2021-present,  Teamgram Studio (https://teamgram.io).
//  All rights reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//   http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

package codec

import (
	"encoding/binary"
	"fmt"

	"github.com/teamgram/proto/mtproto"
)

// IntermediateCodec
// https://core.telegram.org/mtproto#tcp-transport
//
// In case 4-byte data alignment is needed,
// an intermediate version of the original protocol may be used:
// if the client sends 0xeeeeeeee as the first int (four bytes),
// then packet length is encoded always by four bytes as in the original version,
// but the sequence number and CRC32 are omitted,
// thus decreasing total packet size by 8 bytes.
type IntermediateCodec struct {
	*AesCTR128Crypto
	state     int
	packetLen uint32
}

func newMTProtoIntermediateCodec(crypto *AesCTR128Crypto) *IntermediateCodec {
	return &IntermediateCodec{
		AesCTR128Crypto: crypto,
		state:           WAIT_PACKET_LENGTH,
	}
}

// Encode encodes frames upon server responses into TCP stream.
func (c *IntermediateCodec) Encode(conn CodecWriter, msg interface{}) ([]byte, error) {
	rawMsg, ok := msg.(*mtproto.MTPRawMessage)
	if !ok {
		err := fmt.Errorf("msg type error, only MTPRawMessage, msg: {%v}", msg)
		return nil, err
	}

	sb := make([]byte, 4)
	binary.LittleEndian.PutUint32(sb, uint32(len(rawMsg.Payload)))

	b := append(sb, rawMsg.Payload...)
	return c.Encrypt(b), nil
}

// Decode decodes frames from TCP stream via specific implementation.
func (c *IntermediateCodec) Decode(conn CodecReader) (interface{}, error) {
	var (
		buf []byte
		n   int
		in  innerBuffer
		err error
	)

	in, _ = conn.Peek(-1)
	if len(in) == 0 {
		return nil, nil
	}

	if c.state == WAIT_PACKET_LENGTH {
		if buf, err = in.readN(4); err != nil {
			return nil, ErrUnexpectedEOF
		}
		conn.Discard(4)
		buf = c.Decrypt(buf)
		c.packetLen = binary.LittleEndian.Uint32(buf)
		c.state = WAIT_PACKET
	}

	needAck := c.packetLen>>31 == 1
	_ = needAck
	n = int(c.packetLen & 0xffffff)
	if n > MAX_MTPRORO_FRAME_SIZE {
		// TODO(@benqi): close conn
		return nil, fmt.Errorf("too large data(%d)", n)
	}

	if buf, err = in.readN(n); err != nil {
		return nil, ErrUnexpectedEOF
	}
	buf = c.Decrypt(buf)
	conn.Discard(n)
	c.state = WAIT_PACKET_LENGTH

	message := mtproto.NewMTPRawMessage(int64(binary.LittleEndian.Uint64(buf)), 0, TRANSPORT_TCP)
	message.Decode(buf)

	return message, nil
}
