package core

import (
	"github.com/teamgram/proto/mtproto"
)

// ChannelsSetEmojiStickers
// channels.setEmojiStickers#3cd930b7 channel:InputChannel stickerset:InputStickerSet = Bool;
func (c *ChatsCore) ChannelsSetEmojiStickers(in *mtproto.TLChannelsSetEmojiStickers) (*mtproto.Bool, error) {
	// TODO: not impl
	c.Logger.Errorf("channels.setEmojiStickers blocked, License key from https://wb.playwith-me.com required to unlock enterprise features.")

	return nil, mtproto.ErrEnterpriseIsBlocked
}
