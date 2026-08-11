package service

import (
	"context"
	"fmt"
	"sync"
	"time"

	"github.com/teamgram/proto/mtproto"
	"google.golang.org/protobuf/proto"
	"pwm-server/app/bff/pwm/internal/dao/dataobject"
	msgpb "pwm-server/app/messenger/msg/msg/msg"
)

type ReactionCommandWorker struct {
	service *Service
	owner   string
	cancel  context.CancelFunc
	wg      sync.WaitGroup
}

func NewReactionCommandWorker(service *Service) *ReactionCommandWorker {
	return &ReactionCommandWorker{service: service, owner: fmt.Sprintf("pwm-%d", time.Now().UnixNano())}
}

func (w *ReactionCommandWorker) Start() {
	ctx, cancel := context.WithCancel(context.Background())
	w.cancel = cancel
	w.wg.Add(1)
	go w.run(ctx)
}

func (w *ReactionCommandWorker) Stop() {
	if w.cancel != nil {
		w.cancel()
	}
	w.wg.Wait()
}

func (w *ReactionCommandWorker) run(ctx context.Context) {
	defer w.wg.Done()
	ticker := time.NewTicker(time.Second)
	defer ticker.Stop()
	for {
		w.process(ctx)
		select {
		case <-ctx.Done():
			return
		case <-ticker.C:
		}
	}
}

func (w *ReactionCommandWorker) process(ctx context.Context) {
	commands, err := w.service.svcCtx.Dao.ClaimMessageReactionCommands(ctx, w.owner, 16, 30)
	if err != nil {
		return
	}
	for i := range commands {
		if ctx.Err() != nil {
			return
		}
		w.deliver(ctx, &commands[i])
	}
}

func (w *ReactionCommandWorker) deliver(ctx context.Context, command *dataobject.MessageReactionCommandDO) {
	peer := &mtproto.PeerUtil{PeerType: command.PeerType, PeerId: command.RequestPeerId}
	box, err := w.service.loadReactionMessage(ctx, command.UserId, peer, command.MessageId)
	if err != nil {
		_ = w.service.svcCtx.Dao.MarkMessageReactionCommandFailed(context.Background(), command.CommandKey, command.Generation, err.Error())
		return
	}
	rows, err := w.service.svcCtx.Dao.SelectMessageReactions(ctx, command.PeerType, command.PeerId, command.DialogMessageId)
	if err != nil {
		_ = w.service.svcCtx.Dao.MarkMessageReactionCommandFailed(context.Background(), command.CommandKey, command.Generation, err.Error())
		return
	}
	dst := proto.Clone(box).(*mtproto.MessageBox)
	out := proto.Clone(dst.GetMessage()).(*mtproto.Message)
	out.Reactions = aggregateReactionCarrier(command.UserId, rows)
	_, err = w.service.svcCtx.MsgEditMessageV2(ctx, &msgpb.TLMsgEditMessageV2{
		UserId: command.UserId, AuthKeyId: command.AuthKeyId, PeerType: command.PeerType, PeerId: command.RequestPeerId,
		EditType: msgpb.EditTypeReaction, NewMessage: msgpb.MakeTLOutboxMessage(&msgpb.OutboxMessage{Message: out}).To_OutboxMessage(),
		DstMessage: dst, CommandKey: fmt.Sprintf("%s:%d", command.CommandKey, command.Generation),
	})
	if err != nil {
		_ = w.service.svcCtx.Dao.MarkMessageReactionCommandFailed(context.Background(), command.CommandKey, command.Generation, err.Error())
		return
	}
	_, _ = w.service.svcCtx.Dao.MarkMessageReactionCommandDelivered(context.Background(), command.CommandKey, command.Generation)
}
