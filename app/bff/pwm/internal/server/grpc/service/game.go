package service

import (
	"context"
	"encoding/json"
	"errors"
	"unicode/utf8"

	"github.com/teamgram/proto/mtproto"
	"github.com/teamgram/proto/mtproto/rpc/metadata"
	"pwm-server/app/bff/pwm/internal/dao"
)

func dataJSON(value any) (*mtproto.DataJSON, error) {
	b, err := json.Marshal(value)
	if err != nil {
		return nil, err
	}
	return mtproto.MakeTLDataJSON(&mtproto.DataJSON{Data: string(b)}).To_DataJSON(), nil
}

func (s *Service) PwmGetPartners(ctx context.Context, in *mtproto.TLPwmGetPartners) (*mtproto.DataJSON, error) {
	md := metadata.RpcMetadataFromIncoming(ctx)
	rows, err := s.svcCtx.Dao.SelectGamePartners(ctx, md.GetUserId(), in.GetPartnerId())
	if err != nil {
		return nil, err
	}
	return dataJSON(map[string]any{"version": 1, "data": rows})
}

func (s *Service) PwmGetDifference(ctx context.Context, in *mtproto.TLPwmGetDifference) (*mtproto.DataJSON, error) {
	md := metadata.RpcMetadataFromIncoming(ctx)
	rows, err := s.svcCtx.Dao.SelectGameEvents(ctx, md.GetUserId(), uint64(in.GetCursor()), int(in.GetLimit()))
	if err != nil {
		return nil, err
	}
	cursor := in.GetCursor()
	if len(rows) > 0 {
		cursor = int64(rows[len(rows)-1].Id)
	}
	return dataJSON(map[string]any{"version": 1, "cursor": cursor, "events": rows})
}

func gameRPCError(err error) error {
	switch {
	case errors.Is(err, dao.ErrGameActorInvalid):
		return mtproto.ErrUserIdInvalid
	case errors.Is(err, dao.ErrGamePartnerInvalid), errors.Is(err, dao.ErrGamePairInvalid):
		return mtproto.ErrPeerIdInvalid
	case errors.Is(err, dao.ErrGameTaskInvalid), errors.Is(err, dao.ErrGameCommandConflict):
		return mtproto.ErrInputRequestInvalid
	default:
		return err
	}
}

func (s *Service) PwmGetTask(ctx context.Context, in *mtproto.TLPwmGetTask) (*mtproto.DataJSON, error) {
	md := metadata.RpcMetadataFromIncoming(ctx)
	if md.GetUserId() <= 0 {
		return nil, mtproto.ErrAuthKeyUnregistered
	}
	if in.GetPartnerId() <= 0 || in.GetPartnerId() == md.GetUserId() || in.GetPlayerPairId() < 0 {
		return nil, mtproto.ErrPeerIdInvalid
	}
	result, err := s.svcCtx.Dao.SelectNextGameTask(
		ctx,
		md.GetUserId(),
		in.GetPartnerId(),
		in.GetPlayerPairId(),
	)
	if err != nil {
		return nil, gameRPCError(err)
	}
	return dataJSON(result)
}

func (s *Service) PwmSubmitAnswer(ctx context.Context, in *mtproto.TLPwmSubmitAnswer) (*mtproto.DataJSON, error) {
	md := metadata.RpcMetadataFromIncoming(ctx)
	if md.GetUserId() <= 0 {
		return nil, mtproto.ErrAuthKeyUnregistered
	}
	if in.GetRequestId() == 0 || in.GetGameConfigId() <= 0 || in.GetPairGameId() <= 0 ||
		utf8.RuneCountInString(in.GetChainTaskId()) > 50 ||
		utf8.RuneCountInString(in.GetAnswer()) > 1024 ||
		utf8.RuneCountInString(in.GetAttachedText()) > 1024 ||
		utf8.RuneCountInString(in.GetMediaPath()) > 1024 {
		return nil, mtproto.ErrInputRequestInvalid
	}
	result, err := s.svcCtx.Dao.SubmitGameAnswer(ctx, md.GetUserId(), dao.GameAnswerCommandDO{
		RequestId:    in.GetRequestId(),
		GameConfigId: in.GetGameConfigId(),
		PairGameId:   in.GetPairGameId(),
		ChainTaskId:  in.GetChainTaskId(),
		Answer:       in.GetAnswer(),
		AttachedText: in.GetAttachedText(),
		MediaPath:    in.GetMediaPath(),
	})
	if err != nil {
		if errors.Is(err, dao.ErrGameTaskInvalid) {
			return dataJSON(map[string]any{
				"version": 1,
				"accepted": false,
				"errorCode": "task_stale",
			})
		}
		return nil, gameRPCError(err)
	}
	return dataJSON(result)
}
