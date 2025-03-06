package core

import (
	"github.com/teamgram/proto/mtproto"
	"pwm-server/app/service/biz/user/internal/dal/dataobject"
	"pwm-server/app/service/biz/user/user"
)

// UserGetBotInfo
// user.getBotInfo bot_id:long = BotInfo;
func (c *UserCore) UserGetBotInfo(in *user.TLUserGetBotInfo) (*mtproto.BotInfo, error) {
	botsDO, err := c.svcCtx.BotsDAO.Select(c.ctx, in.BotId)
	if err != nil {
		c.Logger.Errorf("user.getBotInfo - error: %v", err)
		return nil, err
	} else if botsDO == nil {
		return nil, mtproto.ErrUserIdInvalid
	}

	botInfo := mtproto.MakeTLBotInfo(&mtproto.BotInfo{
		UserId_INT64:           in.BotId,
		UserId_FLAGINT64:       mtproto.MakeFlagsInt64(in.BotId),
		Description_STRING:     botsDO.Description,
		Description_FLAGSTRING: mtproto.MakeFlagsString(botsDO.Description),
		Commands:               []*mtproto.BotCommand{},
	}).To_BotInfo()

	c.svcCtx.Dao.BotCommandsDAO.SelectListWithCB(
		c.ctx,
		in.BotId,
		func(sz, i int, v *dataobject.BotCommandsDO) {
			botInfo.Commands = append(botInfo.Commands, mtproto.MakeTLBotCommand(&mtproto.BotCommand{
				Command:     v.Command,
				Description: v.Description,
			}).To_BotCommand())
		})

	return botInfo, nil
}
