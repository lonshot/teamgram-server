package service

import (
	"context"
	"strings"
	"time"

	"github.com/teamgram/proto/mtproto"

	"pwm-server/app/bff/pwm/internal/dao/dataobject"
	"pwm-server/app/service/media/media"
)

func (s Service) MessagesGetSavedGifs(
	ctx context.Context, in *mtproto.TLMessagesGetSavedGifs,
) (*mtproto.Messages_SavedGifs, error) {
	userID, err := stickerUserId(ctx)
	if err != nil {
		return nil, err
	}
	rows, err := s.svcCtx.SelectSavedGifs(ctx, userID, 200)
	if err != nil {
		return nil, err
	}
	hash := savedGifsHash(rows)
	if in != nil && in.GetHash() != 0 && in.GetHash() == hash {
		return mtproto.MakeTLMessagesSavedGifsNotModified(
			&mtproto.Messages_SavedGifs{},
		).To_Messages_SavedGifs(), nil
	}

	ids := make([]int64, 0, len(rows))
	for i := range rows {
		ids = append(ids, rows[i].DocumentID)
	}
	documents := make([]*mtproto.Document, 0, len(ids))
	if len(ids) > 0 {
		result, loadErr := s.svcCtx.MediaGetDocumentList(ctx, &media.TLMediaGetDocumentList{IdList: ids})
		if loadErr != nil {
			return nil, loadErr
		}
		byID := make(map[int64]*mtproto.Document, len(result.GetDatas()))
		for _, document := range result.GetDatas() {
			if document != nil {
				byID[document.GetId()] = document
			}
		}
		for i := range rows {
			document := byID[rows[i].DocumentID]
			if document != nil && document.GetAccessHash() == rows[i].AccessHash && isGifDocument(document) {
				documents = append(documents, document)
			}
		}
	}

	return mtproto.MakeTLMessagesSavedGifs(&mtproto.Messages_SavedGifs{
		Hash: hash,
		Gifs: documents,
	}).To_Messages_SavedGifs(), nil
}

func (s Service) MessagesSaveGif(ctx context.Context, in *mtproto.TLMessagesSaveGif) (*mtproto.Bool, error) {
	userID, err := stickerUserId(ctx)
	if err != nil {
		return nil, err
	}
	input := in.GetId()
	if in == nil || input == nil || input.GetPredicateName() != mtproto.Predicate_inputDocument ||
		input.GetId() <= 0 || input.GetAccessHash() == 0 {
		return nil, mtproto.ErrGifIdInvalid
	}
	document, err := s.svcCtx.MediaGetDocument(ctx, &media.TLMediaGetDocument{Id: input.GetId()})
	if err != nil {
		return nil, err
	}
	if document == nil || document.GetId() != input.GetId() || document.GetAccessHash() != input.GetAccessHash() {
		return nil, mtproto.ErrGifIdInvalid
	}
	if !isGifDocument(document) {
		return nil, mtproto.ErrGifContentTypeInvalid
	}
	if err = s.svcCtx.SetSavedGif(ctx, userID, input.GetId(), input.GetAccessHash(),
		int32(time.Now().Unix()), !mtproto.FromBool(in.GetUnsave())); err != nil {
		return nil, err
	}
	return mtproto.BoolTrue, nil
}

func isGifDocument(document *mtproto.Document) bool {
	if document == nil || document.GetPredicateName() != mtproto.Predicate_document {
		return false
	}
	mimeType := strings.ToLower(strings.TrimSpace(document.GetMimeType()))
	if mimeType == "image/gif" {
		return true
	}
	for _, attribute := range document.GetAttributes() {
		if attribute != nil && attribute.GetPredicateName() == mtproto.Predicate_documentAttributeAnimated {
			return true
		}
	}
	return false
}

func savedGifsHash(rows []dataobject.SavedGifDO) int64 {
	var hash int64
	for i := range rows {
		hash = opaqueStickerHash(hash, rows[i].DocumentID)
		hash = opaqueStickerHash(hash, int64(rows[i].SavedAt))
	}
	return hash
}
