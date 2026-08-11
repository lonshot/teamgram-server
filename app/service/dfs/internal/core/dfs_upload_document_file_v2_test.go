package core

import (
	"bytes"
	"image"
	"image/color"
	"image/png"
	"testing"

	"github.com/stretchr/testify/require"
)

func TestMakeDocumentThumbPreservesStickerTransparency(t *testing.T) {
	source := image.NewNRGBA(image.Rect(0, 0, 64, 64))
	source.SetNRGBA(32, 32, color.NRGBA{R: 255, G: 80, B: 20, A: 255})

	var encodedSource bytes.Buffer
	require.NoError(t, png.Encode(&encodedSource, source))

	_, width, height, mediumBytes, err := makeDocumentThumb(encodedSource.Bytes())
	require.NoError(t, err)
	require.Equal(t, int32(64), width)
	require.Equal(t, int32(64), height)
	require.True(t, bytes.HasPrefix(mediumBytes, []byte{0x89, 0x50, 0x4e, 0x47}))

	medium, err := png.Decode(bytes.NewReader(mediumBytes))
	require.NoError(t, err)
	_, _, _, alpha := medium.At(0, 0).RGBA()
	require.Zero(t, alpha)
}
