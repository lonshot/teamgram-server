package service

import (
	"context"
	"encoding/json"
	"errors"
	"fmt"
	"strconv"
	"sync"
	"time"

	"github.com/teamgram/proto/mtproto"
	"github.com/zeromicro/go-zero/core/logx"
	"pwm-server/app/bff/pwm/internal/dao/dataobject"
	syncpb "pwm-server/app/messenger/sync/sync"
)

type gameOutboxRecipient struct {
	UserID int64  `json:"userId"`
	Cursor uint64 `json:"cursor"`
}

type gameOutboxPayload struct {
	Version       int                   `json:"version"`
	EventID       string                `json:"eventId"`
	EventType     string                `json:"eventType"`
	AggregateType string                `json:"aggregateType"`
	AggregateID   string                `json:"aggregateId"`
	Recipients    []gameOutboxRecipient `json:"recipients"`
}

type GameOutboxWorker struct {
	service *Service
	owner   string
	push    gamePushSender
	pushErr error
	cancel  context.CancelFunc
	wait    sync.WaitGroup
}

func NewGameOutboxWorker(service *Service) *GameOutboxWorker {
	push, err := newFCMHTTPV1Sender(context.Background())
	return &GameOutboxWorker{
		service: service,
		owner:   fmt.Sprintf("pwm-game-%d", time.Now().UnixNano()),
		push:    push,
		pushErr: err,
	}
}

func (w *GameOutboxWorker) Start() {
	ctx, cancel := context.WithCancel(context.Background())
	w.cancel = cancel
	w.wait.Add(1)
	go w.run(ctx)
}

func (w *GameOutboxWorker) Stop() {
	if w.cancel != nil {
		w.cancel()
	}
	w.wait.Wait()
}

func (w *GameOutboxWorker) run(ctx context.Context) {
	defer w.wait.Done()
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

func (w *GameOutboxWorker) process(ctx context.Context) {
	rows, err := w.service.svcCtx.Dao.ClaimGameOutbox(ctx, w.owner, 16, 30)
	if err != nil {
		logx.WithContext(ctx).Errorf("claim game outbox: %v", err)
		return
	}
	for i := range rows {
		if ctx.Err() != nil {
			return
		}
		w.deliver(ctx, &rows[i])
	}
}

func (w *GameOutboxWorker) deliver(ctx context.Context, row *dataobject.GameOutboxDO) {
	var payload gameOutboxPayload
	if err := json.Unmarshal([]byte(row.Payload), &payload); err != nil {
		w.fail(row, err)
		return
	}
	if payload.Version != 1 || payload.EventID == "" || len(payload.Recipients) == 0 {
		w.fail(row, errors.New("invalid game outbox payload"))
		return
	}
	for _, recipient := range payload.Recipients {
		if err := w.sendHint(ctx, payload, recipient); err != nil {
			w.fail(row, err)
			return
		}
	}
	userIDs := make([]int64, 0, len(payload.Recipients))
	for _, recipient := range payload.Recipients {
		userIDs = append(userIDs, recipient.UserID)
	}
	devices, err := w.service.svcCtx.Dao.SelectGamePushDevices(ctx, userIDs)
	if err != nil {
		w.fail(row, err)
		return
	}
	if len(devices) > 0 && w.pushErr != nil {
		w.fail(row, w.pushErr)
		return
	}
	cursors := make(map[int64]uint64, len(payload.Recipients))
	for _, recipient := range payload.Recipients {
		cursors[recipient.UserID] = recipient.Cursor
	}
	for _, device := range devices {
		data := hintData(payload, gameOutboxRecipient{UserID: device.UserId, Cursor: cursors[device.UserId]})
		if err := w.push.Send(ctx, device.Token, data); err != nil {
			if errors.Is(err, errGamePushTokenInvalid) {
				_ = w.service.svcCtx.Dao.DisableGamePushDevice(context.Background(), device.UserId, device.Token)
				continue
			}
			w.fail(row, err)
			return
		}
	}
	if _, err := w.service.svcCtx.Dao.MarkGameOutboxPublished(ctx, row.Id, w.owner); err != nil {
		logx.WithContext(ctx).Errorf("mark game outbox published: %v", err)
	}
}

func hintData(payload gameOutboxPayload, recipient gameOutboxRecipient) map[string]string {
	return map[string]string{
		"type":          "pwm_game_event",
		"eventId":       payload.EventID,
		"eventType":     payload.EventType,
		"cursor":        strconv.FormatUint(recipient.Cursor, 10),
		"aggregateType": payload.AggregateType,
		"aggregateId":   payload.AggregateID,
	}
}

func (w *GameOutboxWorker) sendHint(ctx context.Context, payload gameOutboxPayload, recipient gameOutboxRecipient) error {
	data, err := json.Marshal(hintData(payload, recipient))
	if err != nil {
		return err
	}
	update := mtproto.MakeTLUpdateBotWebhookJSON(&mtproto.Update{
		Data_DATAJSON: mtproto.MakeTLDataJSON(&mtproto.DataJSON{Data: string(data)}).To_DataJSON(),
	}).To_Update()
	_, err = w.service.svcCtx.Dao.SyncClient.SyncPushUpdates(ctx, &syncpb.TLSyncPushUpdates{
		UserId: recipient.UserID,
		Updates: mtproto.MakeTLUpdateShort(&mtproto.Updates{
			Update: update,
			Date:   int32(time.Now().Unix()),
		}).To_Updates(),
	})
	return err
}

func (w *GameOutboxWorker) fail(row *dataobject.GameOutboxDO, err error) {
	logx.Errorf("publish game outbox %d: %v", row.Id, err)
	_ = w.service.svcCtx.Dao.MarkGameOutboxFailed(context.Background(), row.Id, w.owner, err.Error())
}
