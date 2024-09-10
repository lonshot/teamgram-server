package plugin

import (
	"context"
	"github.com/teamgram/proto/mtproto"
)

type ThumbFilesPlugin interface {
	GetStickerSetThumbFileLocation(ctx context.Context, userId int64, stickerset *mtproto.InputStickerSet, version int32) (*mtproto.InputFileLocation, error)
}

type StreamFilesPlugin interface {
	GetGroupCallStreamFile(ctx context.Context, userId int64, file *mtproto.InputFileLocation) (*mtproto.Upload_File, error)
}
