package dao

import (
	"github.com/teamgram/proto/mtproto"
)

type idxId struct {
	idx int
	id  int64
}

type kv struct {
	k string
	v interface{}
}

func removeAllNil(participants []*mtproto.ImmutableChatParticipant) []*mtproto.ImmutableChatParticipant {
	for i := 0; i < len(participants); {
		if participants[i] != nil {
			i++
			continue
		}

		if i < len(participants)-1 {
			copy(participants[i:], participants[i+1:])
		}

		participants[len(participants)-1] = nil
		participants = participants[:len(participants)-1]
	}

	return participants
}
