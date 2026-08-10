package service

import (
	"context"
	"strconv"
	"time"

	"github.com/teamgram/proto/mtproto"
	rpcmetadata "github.com/teamgram/proto/mtproto/rpc/metadata"
	"google.golang.org/protobuf/proto"
	"google.golang.org/protobuf/types/known/wrapperspb"
	"pwm-server/app/bff/pwm/internal/dao/dataobject"
	msgpb "pwm-server/app/messenger/msg/msg/msg"
	chatpb "pwm-server/app/service/biz/chat/chat"
	"pwm-server/app/service/biz/message/message"
	userpb "pwm-server/app/service/biz/user/user"
)

func (s *Service) MessagesSendReaction(ctx context.Context, in *mtproto.TLMessagesSendReaction) (*mtproto.Updates, error) {
	md, peer, err := s.reactionRequest(ctx, in.GetPeer(), true)
	if err != nil {
		return nil, err
	}
	refs, err := reactionsFromSendRequest(in)
	if err != nil {
		return nil, err
	}
	for _, ref := range refs {
		valid, validateErr := s.svcCtx.Dao.ValidateReaction(ctx, ref.ReactionType, ref.ReactionValue)
		if validateErr != nil {
			return nil, validateErr
		}
		if !valid {
			return nil, mtproto.ErrReactionInvalid
		}
	}
	box, err := s.loadReactionMessage(ctx, md.GetUserId(), peer, in.GetMsgId())
	if err != nil {
		return nil, err
	}
	dst := proto.Clone(box).(*mtproto.MessageBox)
	out := proto.Clone(dst.GetMessage()).(*mtproto.Message)
	out.Reactions = reactionCarrier(md.GetUserId(), refs, in.GetBig())
	updates, err := s.svcCtx.MsgEditMessageV2(ctx, &msgpb.TLMsgEditMessageV2{
		UserId: md.GetUserId(), AuthKeyId: md.GetPermAuthKeyId(), PeerType: peer.PeerType, PeerId: peer.PeerId,
		EditType: msgpb.EditTypeReaction, NewMessage: msgpb.MakeTLOutboxMessage(&msgpb.OutboxMessage{Message: out}).To_OutboxMessage(), DstMessage: dst,
	})
	if err != nil {
		return nil, err
	}
	now := int32(time.Now().Unix())
	rows := make([]dataobject.MessageReactionDO, len(refs))
	for i := range refs {
		rows[i] = dataobject.MessageReactionDO{UserId: md.GetUserId(), AuthorUserId: box.GetSenderUserId(), PeerType: peer.PeerType,
			PeerId: reactionScopePeerId(box), MessageId: box.GetMessageId(), DialogMessageId: box.GetDialogMessageId(),
			ReactionType: refs[i].ReactionType, ReactionValue: refs[i].ReactionValue, Big: in.GetBig(), Date: now}
	}
	if err = s.svcCtx.Dao.ReplaceMessageReactions(ctx, rows, md.GetUserId(), peer.PeerType, reactionScopePeerId(box), box.GetDialogMessageId()); err != nil {
		return nil, err
	}
	if in.GetAddToRecent() {
		for i := range refs {
			refs[i].UserId = md.GetUserId()
			refs[i].LastUsedAt = now
			if err = s.svcCtx.Dao.RecordRecentReaction(ctx, &refs[i]); err != nil {
				return nil, err
			}
		}
	}
	return updates, nil
}

func (s *Service) MessagesGetMessagesReactions(ctx context.Context, in *mtproto.TLMessagesGetMessagesReactions) (*mtproto.Updates, error) {
	md, peer, err := s.reactionRequest(ctx, in.GetPeer(), false)
	if err != nil {
		return nil, err
	}
	if len(in.GetId()) == 0 {
		return mtproto.MakeUpdatesByUpdatesUsersChats(nil, nil), nil
	}
	if len(in.GetId()) > 100 {
		return nil, mtproto.ErrInputRequestInvalid
	}
	boxes, err := s.svcCtx.MessageGetUserMessageList(ctx, &message.TLMessageGetUserMessageList{UserId: md.GetUserId(), IdList: in.GetId()})
	if err != nil {
		return nil, err
	}
	if len(boxes.GetDatas()) != len(in.GetId()) {
		return nil, mtproto.ErrMessageIdInvalid
	}
	updates := make([]*mtproto.Update, 0, len(boxes.GetDatas()))
	for _, box := range boxes.GetDatas() {
		if !messageBoxMatchesPeer(box, md.GetUserId(), peer) || box.GetMessage() == nil {
			return nil, mtproto.ErrMessageIdInvalid
		}
		updates = append(updates, mtproto.MakeTLUpdateMessageReactions(&mtproto.Update{Peer_PEER: mtproto.MakePeer(peer.PeerType, peer.PeerId), MsgId_INT32: box.GetMessageId(), Reactions_MESSAGEREACTIONS: box.GetMessage().GetReactions()}).To_Update())
	}
	return mtproto.MakeUpdatesByUpdatesUsersChats(nil, nil, updates...), nil
}

func (s *Service) MessagesGetMessageReactionsList(ctx context.Context, in *mtproto.TLMessagesGetMessageReactionsList) (*mtproto.Messages_MessageReactionsList, error) {
	md, peer, err := s.reactionRequest(ctx, in.GetPeer(), false)
	if err != nil {
		return nil, err
	}
	if in.GetLimit() <= 0 || in.GetLimit() > 100 {
		return nil, mtproto.ErrLimitInvalid
	}
	box, err := s.loadReactionMessage(ctx, md.GetUserId(), peer, in.GetId())
	if err != nil {
		return nil, err
	}
	var filter *dataobject.UserReactionDO
	if in.GetReaction_FLAGREACTION() != nil {
		value, ok := reactionFromMTProto(in.GetReaction_FLAGREACTION())
		if !ok {
			return nil, mtproto.ErrReactionInvalid
		}
		filter = &value
	} else if in.GetReaction_FLAGSTRING() != nil && in.GetReaction_FLAGSTRING().GetValue() != "" {
		filter = &dataobject.UserReactionDO{ReactionType: 1, ReactionValue: in.GetReaction_FLAGSTRING().GetValue()}
	}
	page, err := s.svcCtx.Dao.ListMessageReactions(ctx, peer.PeerType, reactionScopePeerId(box), box.GetDialogMessageId(), filter, in.GetOffset().GetValue(), int(in.GetLimit()))
	if err != nil {
		return nil, err
	}
	result := &mtproto.Messages_MessageReactionsList{Count: page.Count, Reactions: make([]*mtproto.MessagePeerReaction, 0, len(page.Reactions)), Users: []*mtproto.User{}, Chats: []*mtproto.Chat{}}
	ids := []int64{md.GetUserId()}
	seen := map[int64]struct{}{md.GetUserId(): {}}
	for _, row := range page.Reactions {
		result.Reactions = append(result.Reactions, mtproto.MakeTLMessagePeerReaction(&mtproto.MessagePeerReaction{Big: row.Big, My: row.UserId == md.GetUserId(), Unread: row.Unread && row.AuthorUserId == md.GetUserId(), PeerId: mtproto.MakePeerUser(row.UserId), Date: row.Date, Reaction_REACTION: reactionToMTProto(dataobject.UserReactionDO{ReactionType: row.ReactionType, ReactionValue: row.ReactionValue})}).To_MessagePeerReaction())
		if _, ok := seen[row.UserId]; !ok {
			seen[row.UserId] = struct{}{}
			ids = append(ids, row.UserId)
		}
	}
	users, err := s.svcCtx.UserGetMutableUsers(ctx, &userpb.TLUserGetMutableUsers{Id: ids})
	if err != nil {
		return nil, err
	}
	result.Users = users.GetUserListByIdList(md.GetUserId(), ids...)
	if page.NextOffset != "" {
		result.NextOffset = wrapperspb.String(page.NextOffset)
	}
	return mtproto.MakeTLMessagesMessageReactionsList(result).To_Messages_MessageReactionsList(), nil
}

func (s *Service) MessagesSetChatAvailableReactions(ctx context.Context, in *mtproto.TLMessagesSetChatAvailableReactions) (*mtproto.Updates, error) {
	md, peer, err := s.reactionRequest(ctx, in.GetPeer(), false)
	if err != nil {
		return nil, err
	}
	if peer.PeerType != mtproto.PEER_CHAT {
		return nil, mtproto.ErrPeerIdInvalid
	}
	if in.GetPaidEnabled() != nil && mtproto.FromBool(in.GetPaidEnabled()) {
		return nil, mtproto.ErrReactionInvalid
	}
	if in.GetReactionsLimit() != nil && (in.GetReactionsLimit().GetValue() < 1 || in.GetReactionsLimit().GetValue() > 11) {
		return nil, mtproto.ErrLimitInvalid
	}
	chat, err := s.svcCtx.ChatClient.Client().ChatGetMutableChat(ctx, &chatpb.TLChatGetMutableChat{ChatId: peer.PeerId})
	if err != nil {
		return nil, err
	}
	participant, ok := chat.GetImmutableChatParticipant(md.GetUserId())
	if !ok || !participant.IsChatMemberStateNormal() {
		return nil, mtproto.ErrParticipantIdInvalid
	}
	if !participant.CanAdminChangeInfo() {
		return nil, mtproto.ErrChatAdminRequired
	}
	policy, refs, err := s.chatReactionPolicy(ctx, in)
	if err != nil {
		return nil, err
	}
	settings := dataobject.ChatReactionSettingsDO{PeerType: peer.PeerType, PeerId: peer.PeerId, PolicyType: policy, ReactionsLimit: nil, Reactions: refs}
	if in.GetReactionsLimit() != nil {
		value := in.GetReactionsLimit().GetValue()
		settings.ReactionsLimit = &value
	}
	if err = s.svcCtx.Dao.SetChatReactionSettings(ctx, md.GetUserId(), settings); err != nil {
		return nil, err
	}
	return mtproto.MakeUpdatesByUpdatesUsersChats(nil, []*mtproto.Chat{chat.ToUnsafeChat(md.GetUserId())}, mtproto.MakeUpdateChat(peer.PeerId)), nil
}

func (s *Service) MessagesGetAvailableReactions(ctx context.Context, in *mtproto.TLMessagesGetAvailableReactions) (*mtproto.Messages_AvailableReactions, error) {
	rows, err := s.svcCtx.Dao.SelectAvailableReactionCatalog(ctx, false)
	if err != nil {
		return nil, err
	}
	hash := availableReactionsHash(rows)
	if in.GetHash() != 0 && in.GetHash() == hash {
		return mtproto.MakeTLMessagesAvailableReactionsNotModified(&mtproto.Messages_AvailableReactions{}).To_Messages_AvailableReactions(), nil
	}
	result := make([]*mtproto.AvailableReaction, 0, len(rows))
	for i := range rows {
		docRows, loadErr := s.svcCtx.Dao.SelectAvailableReactionDocuments(ctx, rows[i].Id)
		if loadErr != nil {
			return nil, loadErr
		}
		ids := make([]int64, len(docRows))
		for j := range docRows {
			ids[j] = docRows[j].NativeDocumentId
		}
		docs, loadErr := s.loadStickerDocuments(ctx, ids)
		if loadErr != nil {
			return nil, loadErr
		}
		byId := make(map[int64]*mtproto.Document, len(docs))
		for _, doc := range docs {
			byId[doc.GetId()] = doc
		}
		available := &mtproto.AvailableReaction{Inactive: rows[i].Inactive, Premium: rows[i].Premium, Reaction: rows[i].Emoticon, Title: rows[i].Title}
		for _, row := range docRows {
			switch row.Role {
			case 1:
				available.StaticIcon = byId[row.NativeDocumentId]
			case 2:
				available.AppearAnimation = byId[row.NativeDocumentId]
			case 3:
				available.SelectAnimation = byId[row.NativeDocumentId]
			case 4:
				available.ActivateAnimation = byId[row.NativeDocumentId]
			case 5:
				available.EffectAnimation = byId[row.NativeDocumentId]
			case 6:
				available.AroundAnimation = byId[row.NativeDocumentId]
			case 7:
				available.CenterIcon = byId[row.NativeDocumentId]
			}
		}
		if available.StaticIcon == nil || available.AppearAnimation == nil || available.SelectAnimation == nil || available.ActivateAnimation == nil || available.EffectAnimation == nil {
			return nil, mtproto.ErrInternalServerError
		}
		result = append(result, mtproto.MakeTLAvailableReaction(available).To_AvailableReaction())
	}
	return mtproto.MakeTLMessagesAvailableReactions(&mtproto.Messages_AvailableReactions{Hash: hash, Reactions: result}).To_Messages_AvailableReactions(), nil
}

func (s *Service) MessagesSetDefaultReaction(ctx context.Context, in *mtproto.TLMessagesSetDefaultReaction) (*mtproto.Bool, error) {
	userId, err := reactionUserId(ctx)
	if err != nil {
		return nil, err
	}
	ref, ok := reactionFromDefaultRequest(in)
	if !ok {
		return nil, mtproto.ErrReactionInvalid
	}
	valid, err := s.svcCtx.Dao.ValidateReaction(ctx, ref.ReactionType, ref.ReactionValue)
	if err != nil {
		return nil, err
	}
	if !valid {
		return nil, mtproto.ErrReactionInvalid
	}
	ref.UserId = userId
	if err = s.svcCtx.Dao.SetDefaultReaction(ctx, &ref); err != nil {
		return nil, err
	}
	return mtproto.BoolTrue, nil
}

func (s *Service) MessagesGetTopReactions(ctx context.Context, in *mtproto.TLMessagesGetTopReactions) (*mtproto.Messages_Reactions, error) {
	return s.listUserReactions(ctx, in.GetLimit(), in.GetHash(), true)
}
func (s *Service) MessagesGetRecentReactions(ctx context.Context, in *mtproto.TLMessagesGetRecentReactions) (*mtproto.Messages_Reactions, error) {
	return s.listUserReactions(ctx, in.GetLimit(), in.GetHash(), false)
}
func (s *Service) MessagesClearRecentReactions(ctx context.Context, _ *mtproto.TLMessagesClearRecentReactions) (*mtproto.Bool, error) {
	userId, err := reactionUserId(ctx)
	if err != nil {
		return nil, err
	}
	if err = s.svcCtx.Dao.ClearUserRecentReactions(ctx, userId); err != nil {
		return nil, err
	}
	return mtproto.BoolTrue, nil
}

func (s *Service) MessagesGetUnreadReactions(ctx context.Context, in *mtproto.TLMessagesGetUnreadReactions) (*mtproto.Messages_Messages, error) {
	md, peer, err := s.reactionRequest(ctx, in.GetPeer(), false)
	if err != nil {
		return nil, err
	}
	if in.GetTopMsgId() != nil {
		return nil, mtproto.ErrInputRequestInvalid
	}
	if in.GetLimit() <= 0 || in.GetLimit() > 100 {
		return nil, mtproto.ErrLimitInvalid
	}
	page, err := s.svcCtx.Dao.ListUnreadReactionMessages(ctx, md.GetUserId(), peer.PeerType, peer.PeerId, in.GetOffsetId(), in.GetAddOffset(), in.GetLimit(), in.GetMinId(), in.GetMaxId())
	if err != nil {
		return nil, err
	}
	boxes, err := s.svcCtx.MessageGetUserMessageList(ctx, &message.TLMessageGetUserMessageList{UserId: md.GetUserId(), IdList: page.MessageIds})
	if err != nil {
		return nil, err
	}
	messages := make([]*mtproto.Message, 0, len(boxes.GetDatas()))
	for _, box := range boxes.GetDatas() {
		if !messageBoxMatchesPeer(box, md.GetUserId(), peer) {
			return nil, mtproto.ErrMessageIdInvalid
		}
		messages = append(messages, box.ToMessage(md.GetUserId()))
	}
	return mtproto.MakeTLMessagesMessagesSlice(&mtproto.Messages_Messages{Count: page.Count, Messages: messages, Users: []*mtproto.User{}, Chats: []*mtproto.Chat{}}).To_Messages_Messages(), nil
}

func (s *Service) MessagesReadReactions(ctx context.Context, in *mtproto.TLMessagesReadReactions) (*mtproto.Messages_AffectedHistory, error) {
	md, peer, err := s.reactionRequest(ctx, in.GetPeer(), false)
	if err != nil {
		return nil, err
	}
	if in.GetTopMsgId() != nil {
		return nil, mtproto.ErrInputRequestInvalid
	}
	count, err := s.svcCtx.Dao.ClearUnreadReactionMessages(ctx, md.GetUserId(), peer.PeerType, peer.PeerId)
	if err != nil {
		return nil, err
	}
	return mtproto.MakeTLMessagesAffectedHistory(&mtproto.Messages_AffectedHistory{PtsCount: int32(count)}).To_Messages_AffectedHistory(), nil
}

func (s *Service) MessagesReportReaction(ctx context.Context, in *mtproto.TLMessagesReportReaction) (*mtproto.Bool, error) {
	md, peer, err := s.reactionRequest(ctx, in.GetPeer(), false)
	if err != nil {
		return nil, err
	}
	actor, err := reactionPeer(md.GetUserId(), in.GetReactionPeer())
	if err != nil || actor.PeerType != mtproto.PEER_USER || actor.PeerId == md.GetUserId() {
		return nil, mtproto.ErrReactionInvalid
	}
	box, err := s.loadReactionMessage(ctx, md.GetUserId(), peer, in.GetId())
	if err != nil {
		return nil, err
	}
	ok, err := s.svcCtx.Dao.ReportMessageReaction(ctx, md.GetUserId(), reactionScopePeerId(box), box.GetDialogMessageId(), actor.PeerId, peer.PeerType)
	if err != nil {
		return nil, err
	}
	if !ok {
		return nil, mtproto.ErrReactionInvalid
	}
	return mtproto.BoolTrue, nil
}

func (s *Service) listUserReactions(ctx context.Context, limit int32, requestHash int64, top bool) (*mtproto.Messages_Reactions, error) {
	userId, err := reactionUserId(ctx)
	if err != nil {
		return nil, err
	}
	if limit <= 0 || limit > 100 {
		limit = 100
	}
	var refs []dataobject.UserReactionDO
	if top {
		refs, err = s.svcCtx.Dao.SelectUserTopReactions(ctx, userId, limit)
	} else {
		refs, err = s.svcCtx.Dao.SelectUserRecentReactions(ctx, userId, limit)
	}
	if err != nil {
		return nil, err
	}
	hash := reactionRefsHash(refs)
	if requestHash != 0 && requestHash == hash {
		return mtproto.MakeTLMessagesReactionsNotModified(nil).To_Messages_Reactions(), nil
	}
	values := make([]*mtproto.Reaction, len(refs))
	for i := range refs {
		values[i] = reactionToMTProto(refs[i])
	}
	return mtproto.MakeTLMessagesReactions(&mtproto.Messages_Reactions{Hash: hash, Reactions: values}).To_Messages_Reactions(), nil
}

func (s *Service) reactionRequest(ctx context.Context, input *mtproto.InputPeer, write bool) (*rpcmetadata.RpcMetadata, *mtproto.PeerUtil, error) {
	md := rpcmetadata.RpcMetadataFromIncoming(ctx)
	if md == nil || md.GetUserId() <= 0 {
		return nil, nil, mtproto.ErrAuthKeyUnregistered
	}
	peer, err := reactionPeer(md.GetUserId(), input)
	if err != nil {
		return nil, nil, err
	}
	if peer.PeerType == mtproto.PEER_CHANNEL {
		return nil, nil, mtproto.ErrEnterpriseIsBlocked
	}
	if peer.PeerType == mtproto.PEER_CHAT && !s.svcCtx.ChatClient.CheckParticipantIsExist(ctx, md.GetUserId(), []int64{peer.PeerId}) {
		return nil, nil, mtproto.ErrPeerIdInvalid
	}
	_ = write
	return md, peer, nil
}

func reactionUserId(ctx context.Context) (int64, error) {
	md := rpcmetadata.RpcMetadataFromIncoming(ctx)
	if md == nil || md.GetUserId() <= 0 {
		return 0, mtproto.ErrAuthKeyUnregistered
	}
	return md.GetUserId(), nil
}
func reactionPeer(userId int64, input *mtproto.InputPeer) (*mtproto.PeerUtil, error) {
	if input == nil {
		return nil, mtproto.ErrPeerIdInvalid
	}
	peer := mtproto.FromInputPeer2(userId, input)
	if peer.PeerType == mtproto.PEER_SELF {
		peer.PeerType, peer.PeerId = mtproto.PEER_USER, userId
	}
	if peer.PeerId <= 0 || (peer.PeerType != mtproto.PEER_USER && peer.PeerType != mtproto.PEER_CHAT && peer.PeerType != mtproto.PEER_CHANNEL) {
		return nil, mtproto.ErrPeerIdInvalid
	}
	return peer, nil
}
func messageBoxMatchesPeer(box *mtproto.MessageBox, userId int64, peer *mtproto.PeerUtil) bool {
	if box == nil || peer == nil || box.GetUserId() != userId || box.GetPeerType() != peer.PeerType {
		return false
	}
	if peer.PeerType != mtproto.PEER_USER {
		return box.GetPeerId() == peer.PeerId
	}
	dialog := mtproto.MakeDialogId(userId, mtproto.PEER_USER, peer.PeerId)
	return box.GetDialogId1() == dialog.A && box.GetDialogId2() == dialog.B
}
func reactionScopePeerId(box *mtproto.MessageBox) int64 {
	if box.GetPeerType() == mtproto.PEER_USER {
		return box.GetDialogId1()
	}
	return box.GetPeerId()
}
func (s *Service) loadReactionMessage(ctx context.Context, userId int64, peer *mtproto.PeerUtil, id int32) (*mtproto.MessageBox, error) {
	boxes, err := s.svcCtx.MessageGetUserMessageList(ctx, &message.TLMessageGetUserMessageList{UserId: userId, IdList: []int32{id}})
	if err != nil {
		return nil, err
	}
	if len(boxes.GetDatas()) != 1 || boxes.GetDatas()[0].GetMessage() == nil || !messageBoxMatchesPeer(boxes.GetDatas()[0], userId, peer) {
		return nil, mtproto.ErrMessageIdInvalid
	}
	return boxes.GetDatas()[0], nil
}

func reactionFromMTProto(value *mtproto.Reaction) (dataobject.UserReactionDO, bool) {
	if value == nil {
		return dataobject.UserReactionDO{}, false
	}
	switch value.GetPredicateName() {
	case mtproto.Predicate_reactionEmoji:
		if value.GetEmoticon() == "" {
			return dataobject.UserReactionDO{}, false
		}
		return dataobject.UserReactionDO{ReactionType: 1, ReactionValue: value.GetEmoticon()}, true
	case mtproto.Predicate_reactionCustomEmoji:
		if value.GetDocumentId() <= 0 {
			return dataobject.UserReactionDO{}, false
		}
		return dataobject.UserReactionDO{ReactionType: 2, ReactionValue: strconv.FormatInt(value.GetDocumentId(), 10)}, true
	default:
		return dataobject.UserReactionDO{}, false
	}
}
func reactionToMTProto(value dataobject.UserReactionDO) *mtproto.Reaction {
	if value.ReactionType == 2 {
		id, _ := strconv.ParseInt(value.ReactionValue, 10, 64)
		return mtproto.MakeTLReactionCustomEmoji(&mtproto.Reaction{DocumentId: id}).To_Reaction()
	}
	return mtproto.MakeTLReactionEmoji(&mtproto.Reaction{Emoticon: value.ReactionValue}).To_Reaction()
}
func reactionFromDefaultRequest(in *mtproto.TLMessagesSetDefaultReaction) (dataobject.UserReactionDO, bool) {
	if in == nil {
		return dataobject.UserReactionDO{}, false
	}
	if in.GetReaction_REACTION() != nil {
		return reactionFromMTProto(in.GetReaction_REACTION())
	}
	if in.GetReaction_STRING() != "" {
		return dataobject.UserReactionDO{ReactionType: 1, ReactionValue: in.GetReaction_STRING()}, true
	}
	return dataobject.UserReactionDO{}, false
}
func reactionsFromSendRequest(in *mtproto.TLMessagesSendReaction) ([]dataobject.UserReactionDO, error) {
	if in == nil {
		return nil, mtproto.ErrInputRequestInvalid
	}
	input := in.GetReaction_FLAGVECTORREACTION()
	if len(input) > 3 {
		return nil, mtproto.ErrReactionsTooMany
	}
	refs := make([]dataobject.UserReactionDO, 0, len(input))
	seen := map[string]struct{}{}
	for _, value := range input {
		ref, ok := reactionFromMTProto(value)
		if !ok {
			return nil, mtproto.ErrReactionInvalid
		}
		key := strconv.Itoa(int(ref.ReactionType)) + ":" + ref.ReactionValue
		if _, ok = seen[key]; ok {
			return nil, mtproto.ErrReactionInvalid
		}
		seen[key] = struct{}{}
		refs = append(refs, ref)
	}
	if len(refs) == 0 && in.GetReaction_FLAGSTRING() != nil && in.GetReaction_FLAGSTRING().GetValue() != "" {
		refs = append(refs, dataobject.UserReactionDO{ReactionType: 1, ReactionValue: in.GetReaction_FLAGSTRING().GetValue()})
	}
	return refs, nil
}
func reactionCarrier(userId int64, refs []dataobject.UserReactionDO, big bool) *mtproto.MessageReactions {
	results := make([]*mtproto.ReactionCount, len(refs))
	for i := range refs {
		results[i] = mtproto.MakeTLReactionCount(&mtproto.ReactionCount{Chosen: true, ChosenOrder: wrapperspb.Int32(int32(i)), Reaction_REACTION: reactionToMTProto(refs[i]), Count: 1}).To_ReactionCount()
	}
	carrier := &mtproto.MessageReactions{Results: results}
	if len(refs) > 0 {
		carrier.RecentReactions = []*mtproto.MessagePeerReaction{mtproto.MakeTLMessagePeerReaction(&mtproto.MessagePeerReaction{My: true, Big: big, PeerId: mtproto.MakePeerUser(userId)}).To_MessagePeerReaction()}
	}
	return mtproto.MakeTLMessageReactions(carrier).To_MessageReactions()
}
func reactionRefsHash(refs []dataobject.UserReactionDO) int64 {
	var hash int64
	for _, ref := range refs {
		hash = hash*20261 + int64(ref.ReactionType)
		for _, r := range ref.ReactionValue {
			hash = hash*20261 + int64(r)
		}
	}
	return hash
}
func availableReactionsHash(rows []dataobject.AvailableReactionDO) int32 {
	var hash int64
	for _, row := range rows {
		hash = hash*20261 + row.ReactionHash
		for _, r := range row.Emoticon {
			hash = hash*20261 + int64(r)
		}
	}
	return int32(hash)
}
func (s *Service) chatReactionPolicy(ctx context.Context, in *mtproto.TLMessagesSetChatAvailableReactions) (int32, []dataobject.UserReactionDO, error) {
	policy := in.GetAvailableReactions_CHATREACTIONS()
	if policy == nil {
		legacy := in.GetAvailableReactions_VECTORSTRING()
		if len(legacy) == 0 {
			return 0, nil, mtproto.ErrReactionEmpty
		}
		refs := make([]dataobject.UserReactionDO, len(legacy))
		for i, value := range legacy {
			refs[i] = dataobject.UserReactionDO{ReactionType: 1, ReactionValue: value}
		}
		policy = mtproto.MakeTLChatReactionsSome(&mtproto.ChatReactions{Reactions: func() []*mtproto.Reaction {
			result := make([]*mtproto.Reaction, len(refs))
			for i := range refs {
				result[i] = reactionToMTProto(refs[i])
			}
			return result
		}()}).To_ChatReactions()
	}
	policyType, _ := policy.ToChatReactions()
	if policyType != mtproto.ChatReactionsTypeSome {
		if policyType == mtproto.ChatReactionsTypeNone || policyType == mtproto.ChatReactionsTypeAllNoAllowCustom || policyType == mtproto.ChatReactionsTypeAllAllowCustom {
			return policyType, nil, nil
		}
		return 0, nil, mtproto.ErrReactionInvalid
	}
	if len(policy.GetReactions()) == 0 {
		return 0, nil, mtproto.ErrReactionEmpty
	}
	if len(policy.GetReactions()) > 100 {
		return 0, nil, mtproto.ErrReactionsTooMany
	}
	refs := make([]dataobject.UserReactionDO, 0, len(policy.GetReactions()))
	seen := map[string]struct{}{}
	for _, value := range policy.GetReactions() {
		ref, ok := reactionFromMTProto(value)
		if !ok {
			return 0, nil, mtproto.ErrReactionInvalid
		}
		key := strconv.Itoa(int(ref.ReactionType)) + ":" + ref.ReactionValue
		if _, ok = seen[key]; ok {
			return 0, nil, mtproto.ErrReactionInvalid
		}
		valid, err := s.svcCtx.Dao.ValidateReaction(ctx, ref.ReactionType, ref.ReactionValue)
		if err != nil {
			return 0, nil, err
		}
		if !valid {
			return 0, nil, mtproto.ErrReactionInvalid
		}
		seen[key] = struct{}{}
		refs = append(refs, ref)
	}
	return policyType, refs, nil
}
