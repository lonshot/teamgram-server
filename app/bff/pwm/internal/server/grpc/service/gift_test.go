package service

import (
	"testing"

	"github.com/stretchr/testify/require"
	"github.com/teamgram/proto/mtproto"

	"pwm-server/app/bff/pwm/internal/dao/dataobject"
)

func TestIsGifDocument(t *testing.T) {
	animated := mtproto.MakeTLDocument(&mtproto.Document{
		MimeType: "video/mp4",
		Attributes: []*mtproto.DocumentAttribute{
			mtproto.MakeTLDocumentAttributeAnimated(&mtproto.DocumentAttribute{}).To_DocumentAttribute(),
		},
	}).To_Document()
	require.True(t, isGifDocument(animated))

	gif := mtproto.MakeTLDocument(&mtproto.Document{MimeType: "image/gif"}).To_Document()
	require.True(t, isGifDocument(gif))

	image := mtproto.MakeTLDocument(&mtproto.Document{MimeType: "image/jpeg"}).To_Document()
	require.False(t, isGifDocument(image))
}

func TestSavedGifsHashIsOrderAndTimestampSensitive(t *testing.T) {
	base := []dataobject.SavedGifDO{{DocumentID: 10, SavedAt: 20}, {DocumentID: 30, SavedAt: 40}}
	reordered := []dataobject.SavedGifDO{{DocumentID: 30, SavedAt: 40}, {DocumentID: 10, SavedAt: 20}}
	updated := []dataobject.SavedGifDO{{DocumentID: 10, SavedAt: 21}, {DocumentID: 30, SavedAt: 40}}

	require.NotZero(t, savedGifsHash(base))
	require.NotEqual(t, savedGifsHash(base), savedGifsHash(reordered))
	require.NotEqual(t, savedGifsHash(base), savedGifsHash(updated))
}
