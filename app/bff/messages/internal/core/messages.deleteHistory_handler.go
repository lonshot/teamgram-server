package core

import (
	msgpb "pwm-server/app/messenger/msg/msg/msg"
	"pwm-server/app/service/biz/dialog/dialog"

	"github.com/teamgram/proto/mtproto"
)

// MessagesDeleteHistory
// messages.deleteHistory#b08f922a flags:# just_clear:flags.0?true revoke:flags.1?true peer:InputPeer max_id:int min_date:flags.2?int max_date:flags.3?int = messages.AffectedHistory;
func (c *MessagesCore) MessagesDeleteHistory(in *mtproto.TLMessagesDeleteHistory) (*mtproto.Messages_AffectedHistory, error) {
	var (
		peer = mtproto.FromInputPeer2(c.MD.UserId, in.Peer)
	)

	if peer.IsChannel() {
		c.Logger.Errorf("messages.deleteHistory blocked, License key from https://wb.playwith-me.com required to unlock enterprise features.")
		return nil, mtproto.ErrEnterpriseIsBlocked
	}

	if !peer.IsChatOrUser() {
		err := mtproto.ErrPeerIdInvalid
		c.Logger.Errorf("messages.deleteHistory - error: %v", err)
		return nil, err
	}

	if in.GetMinDate() != nil || in.GetMaxDate() != nil {
		// TODO: not impl
		pts := c.svcCtx.Dao.IDGenClient2.CurrentPtsId(c.ctx, c.MD.UserId)
		return mtproto.MakeTLMessagesAffectedHistory(&mtproto.Messages_AffectedHistory{
			Pts:      pts,
			PtsCount: 0,
			Offset:   0,
		}).To_Messages_AffectedHistory(), nil
	}

	affectedHistory, err := c.svcCtx.Dao.MsgClient.MsgDeleteHistory(c.ctx, &msgpb.TLMsgDeleteHistory{
		UserId:    c.MD.UserId,
		AuthKeyId: c.MD.PermAuthKeyId,
		PeerType:  peer.PeerType,
		PeerId:    peer.PeerId,
		JustClear: in.GetJustClear(),
		Revoke:    in.Revoke,
		MaxId:     in.MaxId,
	})

	if err != nil {
		c.Logger.Errorf("messages.deleteHistory - error: %v", err)
		return nil, err
	}

	if !in.GetJustClear() {
		if peer.IsUser() {
			c.svcCtx.Dao.DialogDeleteDialog(c.ctx, &dialog.TLDialogDeleteDialog{
				UserId:   c.MD.UserId,
				PeerType: peer.PeerType,
				PeerId:   peer.PeerId,
			})
			if in.Revoke && !peer.IsSelf() {
				c.svcCtx.Dao.DialogDeleteDialog(c.ctx, &dialog.TLDialogDeleteDialog{
					UserId:   peer.PeerId,
					PeerType: peer.PeerType,
					PeerId:   c.MD.UserId,
				})
			}
		}
	}

	return affectedHistory, nil
}
