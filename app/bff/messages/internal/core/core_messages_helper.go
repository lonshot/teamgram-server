package core

import (
	"context"
	// "github.com/teamgram/proto/mtproto/rpc/metadata"
	"math/rand"
	// "mvdan.cc/xurls/v2"
	// "pwm-server/app/service/biz/username/username"
	// "pwm-server/pkg/mention"
	// "sort"
	"time"

	"pwm-server/app/messenger/sync/sync"
	"pwm-server/app/service/biz/dialog/dialog"
	userpb "pwm-server/app/service/biz/user/user"
	mediapb "pwm-server/app/service/media/media"
	"pwm-server/pkg/phonenumber"

	"github.com/teamgram/proto/mtproto"
)

// draft
func (c *MessagesCore) doClearDraft(ctx context.Context, userId int64, authKeyId int64, peer *mtproto.PeerUtil) {
	rV, _ := c.svcCtx.Dao.DialogClient.DialogClearDraftMessage(
		ctx, &dialog.TLDialogClearDraftMessage{
			UserId:   c.MD.UserId,
			PeerType: peer.PeerType,
			PeerId:   peer.PeerId,
		},
	)

	// ClearDraft
	if mtproto.FromBool(rV) {
		updateDraftMessage := mtproto.MakeTLUpdateDraftMessage(
			&mtproto.Update{
				Peer_PEER: peer.ToPeer(),
				Draft:     mtproto.MakeTLDraftMessageEmpty(nil).To_DraftMessage(),
			},
		).To_Update()

		c.svcCtx.Dao.SyncClient.SyncUpdatesNotMe(
			ctx,
			&sync.TLSyncUpdatesNotMe{
				UserId:        userId,
				PermAuthKeyId: authKeyId,
				Updates:       mtproto.MakeUpdatesByUpdates(updateDraftMessage),
			},
		)
	}
}

func (c *MessagesCore) makeMediaByInputMedia(media *mtproto.InputMedia) (
	messageMedia *mtproto.MessageMedia, err error,
) {
	var (
		now = int32(time.Now().Unix())
	)

	switch media.PredicateName {
	case mtproto.Predicate_inputMediaEmpty:
		// inputMediaEmpty#9664f57f = InputMedia;

		messageMedia = mtproto.MakeTLMessageMediaEmpty(nil).To_MessageMedia()
	case mtproto.Predicate_inputMediaUploadedPhoto:
		// inputMediaUploadedPhoto#1e287d04 flags:#
		//	file:InputFile
		//	stickers:flags.0?Vector<InputDocument>
		//	ttl_seconds:flags.1?int = InputMedia;

		var (
			photo *mtproto.Photo
		)
		photo, err = c.svcCtx.Dao.MediaClient.MediaUploadPhotoFile(
			c.ctx, &mediapb.TLMediaUploadPhotoFile{
				OwnerId:    c.MD.PermAuthKeyId,
				File:       media.File,
				Stickers:   nil,
				TtlSeconds: nil,
			},
		)
		if err != nil {
			c.Logger.Errorf("UploadPhoto error: %v, by %s", err, media)
			return
		}

		messageMedia = mtproto.MakeTLMessageMediaPhoto(
			&mtproto.MessageMedia{
				Photo_FLAGPHOTO: photo,
				TtlSeconds:      media.TtlSeconds,
			},
		).To_MessageMedia()
	case mtproto.Predicate_inputMediaPhoto:
		// inputMediaPhoto#b3ba0635 flags:#
		//	id:InputPhoto
		//	ttl_seconds:flags.0?int = InputMedia;

		mediaPhoto := media.To_InputMediaPhoto()
		sizeList, _ := c.svcCtx.Dao.MediaClient.MediaGetPhotoSizeList(
			c.ctx, &mediapb.TLMediaGetPhotoSizeList{
				SizeId: mediaPhoto.GetId_INPUTPHOTO().GetId(),
			},
		)

		photo := mtproto.MakeTLPhoto(
			&mtproto.Photo{
				Id:          mediaPhoto.GetId_INPUTPHOTO().GetId(),
				HasStickers: false,
				AccessHash:  mediaPhoto.GetId_INPUTPHOTO().GetAccessHash(),
				Date:        now,
				Sizes:       sizeList.Sizes,
				DcId:        sizeList.DcId,
			},
		)

		messageMedia = mtproto.MakeTLMessageMediaPhoto(
			&mtproto.MessageMedia{
				Photo_FLAGPHOTO: photo.To_Photo(),
				TtlSeconds:      mediaPhoto.GetTtlSeconds(),
			},
		).To_MessageMedia()
	case mtproto.Predicate_inputMediaGeoPoint:
		// inputMediaGeoPoint#f9c44144 geo_point:InputGeoPoint = InputMedia;

		messageMedia = mtproto.MakeTLMessageMediaGeo(
			&mtproto.MessageMedia{
				Geo: mtproto.MakeGeoPointByInput(media.To_InputMediaGeoPoint().GetGeoPoint()),
			},
		).To_MessageMedia()
	case mtproto.Predicate_inputMediaContact:
		// inputMediaContact#f8ab7dfb
		//	phone_number:string
		//	first_name:string
		//	last_name:string
		//	vcard:string = InputMedia;

		contact := media.To_InputMediaContact()

		messageMedia = mtproto.MakeTLMessageMediaContact(
			&mtproto.MessageMedia{
				PhoneNumber: contact.GetPhoneNumber(),
				FirstName:   contact.GetFirstName(),
				LastName:    contact.GetLastName(),
				Vcard:       contact.GetVcard(),
				UserId:      0,
			},
		).To_MessageMedia()

		phoneNumber, err := phonenumber.CheckAndGetPhoneNumber(contact.GetPhoneNumber())
		if err == nil {
			contactUser, _ := c.svcCtx.Dao.UserClient.UserGetImmutableUserByPhone(
				c.ctx, &userpb.TLUserGetImmutableUserByPhone{
					Phone: phoneNumber,
				},
			)
			if contactUser != nil {
				messageMedia.UserId = contactUser.Id()
			}
		}
	case mtproto.Predicate_inputMediaUploadedDocument:
		// inputMediaUploadedDocument#5b38c6c1 flags:#
		//	nosound_video:flags.3?true
		//	force_file:flags.4?true
		//	file:InputFile
		//	thumb:flags.2?InputFile
		//	mime_type:string
		//	attributes:Vector<DocumentAttribute>
		//	stickers:flags.0?Vector<InputDocument>
		//	ttl_seconds:flags.1?int = InputMedia;
		documentMedia, err2 := c.svcCtx.Dao.MediaClient.MediaUploadedDocumentMedia(
			c.ctx, &mediapb.TLMediaUploadedDocumentMedia{
				OwnerId: c.MD.PermAuthKeyId,
				Media:   media,
			},
		)
		if err2 != nil {
			err = mtproto.ErrMediaInvalid
			return
		}
		messageMedia = documentMedia
	case mtproto.Predicate_inputMediaDocument:
		// inputMediaDocument#33473058 flags:#
		//	id:InputDocument
		//	ttl_seconds:flags.0?int
		//	query:flags.1?string = InputMedia;

		id := media.To_InputMediaDocument().GetId_INPUTDOCUMENT()
		document3, _ := c.svcCtx.Dao.MediaClient.MediaGetDocument(
			c.ctx, &mediapb.TLMediaGetDocument{
				Id: id.GetId(),
			},
		)

		// messageMediaDocument#7c4414d3 flags:# document:flags.0?Document caption:flags.1?string ttl_seconds:flags.2?int = MessageMedia;
		messageMedia = mtproto.MakeTLMessageMediaDocument(
			&mtproto.MessageMedia{
				Document: document3,
				// Caption:    media.To_InputMediaDocument().GetCaption(),
				TtlSeconds: media.To_InputMediaDocument().GetTtlSeconds(),
			},
		).To_MessageMedia()
	case mtproto.Predicate_inputMediaVenue:
		// inputMediaVenue#c13d1c11
		//	geo_point:InputGeoPoint
		//	title:string
		//	address:string
		//	provider:string
		//	venue_id:string
		//	venue_type:string = InputMedia;
		venue := media.To_InputMediaVenue()

		// messageMediaVenue#2ec0533f geo:GeoPoint title:string address:string provider:string venue_id:string venue_type:string = MessageMedia;
		messageMedia = mtproto.MakeTLMessageMediaVenue(
			&mtproto.MessageMedia{
				Geo:       mtproto.MakeGeoPointByInput(venue.GetGeoPoint()),
				Title:     venue.GetTitle(),
				Address:   venue.GetAddress(),
				Provider:  venue.GetProvider_STRING(),
				VenueId:   venue.GetVenueId(),
				VenueType: venue.GetVenueType(),
			},
		).To_MessageMedia()
	case mtproto.Predicate_inputMediaPhotoExternal:
		// inputMediaPhotoExternal#e5bbfe1a flags:# url:string ttl_seconds:flags.0?int = InputMedia;

		messageMedia = mtproto.MakeTLMessageMediaUnsupported(nil).To_MessageMedia()
	case mtproto.Predicate_inputMediaDocumentExternal:
		// TODO(@benqi): MessageMedia???
		// inputMediaDocumentExternal#fb52dc99 flags:# url:string ttl_seconds:flags.0?int = InputMedia;
		messageMedia = mtproto.MakeTLMessageMediaUnsupported(nil).To_MessageMedia()
	case mtproto.Predicate_inputMediaGame:
		// inputMediaGame#d33f43f3 id:InputGame = InputMedia;

		// TODO(@benqi): Not impl inputMediaGame
		messageMedia = mtproto.MakeTLMessageMediaUnsupported(nil).To_MessageMedia()
	case mtproto.Predicate_inputMediaInvoice:
		// inputMediaInvoice#d9799874 flags:# title:string description:string photo:flags.0?InputWebDocument invoice:Invoice payload:bytes provider:string provider_data:DataJSON start_param:flags.1?string = InputMedia;

		// TODO(@benqi): Not impl inputMediaGame
		messageMedia = mtproto.MakeTLMessageMediaUnsupported(nil).To_MessageMedia()
	case mtproto.Predicate_inputMediaGeoLive:
		// inputMediaGeoLive#971fa843 flags:# stopped:flags.0?true geo_point:InputGeoPoint heading:flags.2?int period:flags.1?int proximity_notification_radius:flags.3?int = InputMedia;

		messageMedia = mtproto.MakeTLMessageMediaGeoLive(
			&mtproto.MessageMedia{
				Geo:    mtproto.MakeGeoPointByInput(media.To_InputMediaGeoLive().GetGeoPoint()),
				Period: media.To_InputMediaGeoLive().GetPeriod().GetValue(),
			},
		).To_MessageMedia()
	case mtproto.Predicate_inputMediaPoll:
		// inputMediaPoll#f94e5f1 flags:# poll:Poll correct_answers:flags.0?Vector<bytes> solution:flags.1?string solution_entities:flags.1?Vector<MessageEntity> = InputMedia;

		// TODO(@benqi): Not impl inputMediaPoll
		messageMedia = mtproto.MakeTLMessageMediaUnsupported(nil).To_MessageMedia()
	case mtproto.Predicate_inputMediaDice:
		// inputMediaDice#e66fbf7b emoticon:string = InputMedia;

		if media.Emoticon == "🎲" {
			messageMedia = mtproto.MakeTLMessageMediaDice(
				&mtproto.MessageMedia{
					Value:    rand.Int31()%6 + 1,
					Emoticon: media.Emoticon,
				},
			).To_MessageMedia()
		} else if media.Emoticon == "🎯" {
			messageMedia = mtproto.MakeTLMessageMediaDice(
				&mtproto.MessageMedia{
					Value:    rand.Int31()%6 + 1,
					Emoticon: media.Emoticon,
				},
			).To_MessageMedia()
		} else if media.Emoticon == "🏀" {
			messageMedia = mtproto.MakeTLMessageMediaDice(
				&mtproto.MessageMedia{
					Value:    rand.Int31()%5 + 1,
					Emoticon: media.Emoticon,
				},
			).To_MessageMedia()
		} else {
			messageMedia = mtproto.MakeTLMessageMediaDice(
				&mtproto.MessageMedia{
					Value:    rand.Int31()%6 + 1,
					Emoticon: media.Emoticon,
				},
			).To_MessageMedia()
		}

	default:
		err = mtproto.ErrMediaInvalid
	}

	return
}

func (c *MessagesCore) fixMessageEntities(
	fromId int64, peer *mtproto.PeerUtil, noWebpage bool, message *mtproto.Message, hasBot func() bool,
) (*mtproto.Message, error) {
	// var (
	// 	entities mtproto.MessageEntitySlice
	// 	idxList  []int
	// )

	// getIdxList := func() []int {
	// 	if len(idxList) == 0 {
	// 		idxList = mention.EncodeStringToUTF16Index(message.Message)
	// 	}
	// 	return idxList
	// }

	// // Extract URLs and convert them into message entities
	// extractUrls := func() {
	// 	rIndexes := xurls.Relaxed().FindAllStringIndex(message.Message, -1)
	// 	if len(rIndexes) > 0 {
	// 		getIdxList()
	// 		for _, v := range rIndexes {
	// 			entityUrl := mtproto.MakeTLMessageEntityUrl(
	// 				&mtproto.MessageEntity{
	// 					Offset: int32(idxList[v[0]]),
	// 					Length: int32(idxList[v[1]] - idxList[v[0]]),
	// 				},
	// 			)
	// 			entities = append(entities, entityUrl.To_MessageEntity())
	// 		}
	// 	}
	// }

	// // Webpage preview for the first URL
	// addWebpagePreview := func() {
	// 	firstUrl := ""
	// 	rIndexes := xurls.Relaxed().FindAllStringIndex(message.Message, -1)
	// 	if len(rIndexes) > 0 {
	// 		firstUrl = message.Message[rIndexes[0][0]:rIndexes[0][1]]
	// 	}
	// 	if !noWebpage && firstUrl != "" && c.svcCtx.Plugin != nil {
	// 		ctx, _ := metadata.RpcMetadataToOutgoing(c.ctx, c.MD)
	// 		webpage, _ := c.svcCtx.Plugin.GetWebpagePreview(ctx, firstUrl)
	// 		if webpage != nil {
	// 			message.Media = mtproto.MakeTLMessageMediaWebPage(
	// 				&mtproto.MessageMedia{
	// 					Webpage: webpage,
	// 				},
	// 			).To_MessageMedia()
	// 		}
	// 	}
	// }

	// // Process mention tags
	// processMentions := func() {
	// 	tags := mention.GetTags('@', message.Message, '(', ')')
	// 	for _, tag := range tags {
	// 		getIdxList()
	// 		mention2 := mtproto.MakeTLMessageEntityMention(
	// 			&mtproto.MessageEntity{
	// 				Offset: int32(idxList[tag.Index]),
	// 				Length: int32(idxList[tag.Index+len(tag.Tag)+1] - idxList[tag.Index]),
	// 			},
	// 		).To_MessageEntity()

	// 		if v, _ := c.svcCtx.Dao.UsernameClient.UsernameResolveUsername(
	// 			c.ctx, &username.TLUsernameResolveUsername{
	// 				Username: tag.Tag,
	// 			},
	// 		); v != nil && v.GetPredicateName() == mtproto.Predicate_peerUser {
	// 			mention2.UserId_INT64 = v.UserId
	// 		}
	// 		entities = append(entities, mention2)
	// 	}
	// }

	// // Process hashtags
	// processHashtags := func() {
	// 	tags := mention.GetTags('#', message.Message)
	// 	for _, tag := range tags {
	// 		getIdxList()
	// 		hashtag := mtproto.MakeTLMessageEntityHashtag(
	// 			&mtproto.MessageEntity{
	// 				Offset: int32(idxList[tag.Index]),
	// 				Length: int32(idxList[tag.Index+len(tag.Tag)+1] - idxList[tag.Index]),
	// 				Url:    "#" + tag.Tag,
	// 			},
	// 		).To_MessageEntity()
	// 		entities = append(entities, hashtag)
	// 	}
	// }

	// // Process bot commands
	// processBotCommands := func() {
	// 	if hasBot != nil && hasBot() {
	// 		tags := mention.GetTags('/', message.Message)
	// 		for _, tag := range tags {
	// 			getIdxList()
	// 			botCommand := mtproto.MakeTLMessageEntityBotCommand(
	// 				&mtproto.MessageEntity{
	// 					Offset: int32(idxList[tag.Index]),
	// 					Length: int32(idxList[tag.Index+len(tag.Tag)+1] - idxList[tag.Index]),
	// 				},
	// 			).To_MessageEntity()
	// 			entities = append(entities, botCommand)
	// 		}
	// 	}
	// }

	// // Extract URLs and add webpage preview if needed
	// extractUrls()
	// addWebpagePreview()

	// // Process mentions, hashtags, and bot commands
	// processMentions()
	// processHashtags()
	// processBotCommands()

	// // Sort entities by offset and update the message entities
	// sort.Sort(entities)
	// message.Entities = entities

	return message, nil
}
