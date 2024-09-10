package core

import (
	"github.com/teamgram/proto/mtproto"
	"pwm-server/app/service/biz/dialog/dialog"
)

// MessagesMarkDialogUnread
// messages.markDialogUnread#c286d98f flags:# unread:flags.0?true peer:InputDialogPeer = Bool;
func (c *DialogsCore) MessagesMarkDialogUnread(in *mtproto.TLMessagesMarkDialogUnread) (*mtproto.Bool, error) {
	var (
		peer *mtproto.PeerUtil
	)

	if c.MD.IsBot {
		err := mtproto.ErrBotMethodInvalid
		c.Logger.Errorf("messages.markDialogUnread - error: %v", err)
		return nil, err
	}

	switch in.Peer.GetPredicateName() {
	case mtproto.Predicate_inputDialogPeer:
		peer = mtproto.FromInputPeer2(c.MD.UserId, in.Peer.Peer)
	case mtproto.Predicate_inputDialogPeerFolder:
		// error
		c.Logger.Errorf("client not send inputDialogPeerFolder: %v", in.Peer)
		return mtproto.BoolFalse, nil
	default:
		err := mtproto.ErrInputConstructorInvalid
		c.Logger.Errorf("messages.markDialogUnread - error: %v", err)
		return nil, err
	}

	rValue, err := c.svcCtx.Dao.DialogClient.DialogMarkDialogUnread(c.ctx, &dialog.TLDialogMarkDialogUnread{
		UserId:     c.MD.UserId,
		PeerType:   peer.PeerType,
		PeerId:     peer.PeerId,
		UnreadMark: mtproto.ToBool(in.Unread),
	})
	if err != nil {
		c.Logger.Errorf("messages.markDialogUnread - error: %v", err)
		return nil, err
	}

	// TODO: updates ...

	return rValue, nil
}
