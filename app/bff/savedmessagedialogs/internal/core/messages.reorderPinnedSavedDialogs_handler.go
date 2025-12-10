package core

import (
	"github.com/teamgram/proto/mtproto"
	"pwm-server/app/service/biz/dialog/dialog"
)

// MessagesReorderPinnedSavedDialogs
// messages.reorderPinnedSavedDialogs#8b716587 flags:# force:flags.0?true order:Vector<InputDialogPeer> = Bool;
func (c *SavedMessageDialogsCore) MessagesReorderPinnedSavedDialogs(in *mtproto.TLMessagesReorderPinnedSavedDialogs) (*mtproto.Bool, error) {
	if len(in.GetOrder()) == 0 {
		c.Logger.Errorf("messages.reorderPinnedDialogs - len(order) == 0")
		return mtproto.BoolTrue, nil
	}

	var (
		order []*mtproto.PeerUtil
	)
	for _, peer := range in.GetOrder() {
		switch peer.PredicateName {
		case mtproto.Predicate_inputDialogPeer:
			p := mtproto.FromInputPeer2(c.MD.UserId, peer.Peer)
			switch p.PeerType {
			case mtproto.PEER_SELF,
				mtproto.PEER_USER,
				mtproto.PEER_CHAT,
				mtproto.PEER_CHANNEL:
				order = append(order, p)
			default:
				err := mtproto.ErrPeerIdInvalid
				c.Logger.Errorf("messages.reorderPinnedSavedDialogs - error: %v", err)
				return nil, err
			}
		default:
			err := mtproto.ErrPeerIdInvalid
			c.Logger.Errorf("messages.reorderPinnedSavedDialogs - error: %v", err)
			return nil, err
		}
	}

	_, err := c.svcCtx.Dao.DialogClient.DialogReorderPinnedSavedDialogs(c.ctx, &dialog.TLDialogReorderPinnedSavedDialogs{
		UserId: c.MD.UserId,
		Force:  mtproto.ToBool(in.Force),
		Order:  order,
	})
	if err != nil {
		c.Logger.Errorf("messages.reorderPinnedSavedDialogs - error: %v", err)
		return nil, err
	}

	return mtproto.BoolTrue, nil
}
