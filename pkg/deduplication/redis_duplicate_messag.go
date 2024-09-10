package deduplication

import (
	"context"
	"fmt"

	"github.com/teamgram/marmota/pkg/stores/kv"
	"github.com/teamgram/proto/mtproto"

	"github.com/zeromicro/go-zero/core/logx"
	"google.golang.org/protobuf/proto"
)

const (
	duplicateMessageId   = "duplicate_message_id"
	duplicateMessageData = "duplicate_message_data"
	expireTimeout        = 60 // 60s
)

func makeDuplicateMessageKey(prefix string, senderUserId, clientRandomId int64) string {
	return fmt.Sprintf("%s_%d_%d", prefix, senderUserId, clientRandomId)
}

type MessageDeDuplicate struct {
	kv kv.Store
}

func NewMessageDeDuplicate(kv kv.Store) MessageDeDuplicate {
	return MessageDeDuplicate{
		kv: kv,
	}
}

func (m *MessageDeDuplicate) HasDuplicateMessage(ctx context.Context, senderUserId, deDuplicateId int64) (bool, error) {
	k := makeDuplicateMessageKey(duplicateMessageId, senderUserId, deDuplicateId)

	seq, err := m.kv.IncrCtx(ctx, k)
	if err != nil {
		logx.WithContext(ctx).Errorf("checkDuplicateMessage - INCR {%s}, error: {%v}", k, err)
		return false, err
	}

	if _, err = m.kv.ExpireCtx(ctx, k, expireTimeout); err != nil {
		logx.WithContext(ctx).Errorf("expire DuplicateMessage - EXPIRE {%s, %d}, error: %s", k, expireTimeout, err)
		return false, err
	}

	return seq > 1, nil
}

func (m *MessageDeDuplicate) PutDuplicateMessage(ctx context.Context, senderUserId, deDuplicateId int64, upd *mtproto.Updates) error {
	k := makeDuplicateMessageKey(duplicateMessageData, senderUserId, deDuplicateId)
	cacheData, _ := proto.Marshal(upd)

	if err := m.kv.SetexCtx(ctx, k, string(cacheData), expireTimeout); err != nil {
		logx.WithContext(ctx).Errorf("putDuplicateMessage - SET {%s, %s, %d}, error: %s", k, cacheData, expireTimeout, err)
		return err
	}

	return nil
}

func (m *MessageDeDuplicate) GetDuplicateMessage(ctx context.Context, senderUserId, clientRandomId int64) (*mtproto.Updates, error) {
	k := makeDuplicateMessageKey(duplicateMessageData, senderUserId, clientRandomId)

	if cacheData, err := m.kv.GetCtx(ctx, k); err != nil {
		logx.WithContext(ctx).Errorf("getDuplicateMessage - GET {%s}, error: %s", k, err)
		return nil, err
	} else {
		if cacheData == "" {
			return nil, nil
		}

		var (
			rUpdates = new(mtproto.Updates)
		)

		err = proto.Unmarshal([]byte(cacheData), rUpdates)
		if err != nil {
			return nil, err
		}

		return rUpdates, nil
	}
}
