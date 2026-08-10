package core

import (
	"bytes"
	"crypto/md5"
	"fmt"
	"image"
	"math/rand"

	"github.com/teamgram/marmota/pkg/bytes2"
	"github.com/teamgram/proto/mtproto"
	"pwm-server/app/service/dfs/dfs"
	"pwm-server/app/service/dfs/internal/imaging"
	"pwm-server/app/service/dfs/internal/model"
)

// DfsUploadDocumentFileV2
// dfs.uploadDocumentFileV2 creator:long media:InputMedia = Document;
func (c *DfsCore) DfsUploadDocumentFileV2(in *dfs.TLDfsUploadDocumentFileV2) (*mtproto.Document, error) {
	media := in.GetMedia()
	if media == nil || media.GetFile() == nil {
		return nil, mtproto.ErrMediaInvalid
	}
	var (
		documentId = c.svcCtx.Dao.IDGenClient2.NextId(c.ctx)
		//idgen.GetUUID()
		file      = media.GetFile()
		cacheData []byte
	)

	// 有点难理解，主要是为了不在这里引入snowflake
	ext := model.GetFileExtName(file.GetName())
	extType := model.GetStorageFileTypeConstructor(ext)
	accessHash := int64(extType)<<32 | int64(rand.Uint32())

	r, err := c.svcCtx.Dao.OpenFile(c.ctx, in.GetCreator(), file.Id_INT64, file.Parts)
	if err != nil {
		c.Logger.Errorf("dfs.uploadDocumentFile - %v", err)
		return nil, mtproto.ErrMediaInvalid
	}

	//fileInfo, err := s.Dao.GetFileInfo(ctx, creatorId, file.Id)
	//if err != nil {
	//	log.Errorf("dfs.uploadDocumentFile - error: %v", err)
	//	return nil, err
	//}

	c.svcCtx.Dao.SetCacheFileInfo(c.ctx, documentId, r.DfsFileInfo)

	//go func() {
	//	_, err2 := s.Dao.PutDocumentFile(ctx,
	//		fmt.Sprintf("%d.dat", documentId),
	//		s.Dao.NewSSDBReader(r.DfsFileInfo))
	//	if err2 != nil {
	//		log.Errorf("dfs.uploadDocumentFile - error: %v", err2)
	//	}
	//}()

	attributes := make([]*mtproto.DocumentAttribute, 0, len(media.Attributes)+1)
	for _, attr := range media.GetAttributes() {
		switch attr.GetPredicateName() {
		case mtproto.Predicate_documentAttributeAnimated:
			if media.GetMimeType() == "application/x-tgsticker" {
				attributes = append(attributes, attr)
			}
		case mtproto.Predicate_documentAttributeFilename:
			if attr.GetFileName() != "" {
				attributes = append(attributes, attr)
			}
		case mtproto.Predicate_documentAttributeAudio:
			if in.GetMedia().GetMimeType() == "audio/ogg" {
				if attr.Voice == true {
					attributes = append(attributes, attr)
				}
			} else {
				attributes = append(attributes, attr)
			}
		default:
			attributes = append(attributes, attr)
		}
	}

	// document#1e87342b flags:#
	//	id:long
	//	access_hash:long
	//	file_reference:bytes
	//	date:int
	//	mime_type:string
	//	size:int
	//	thumbs:flags.0?Vector<PhotoSize>
	//	video_thumbs:flags.1?Vector<VideoSize>
	//	dc_id:int
	//	attributes:Vector<DocumentAttribute> = Document;
	document := mtproto.MakeTLDocument(&mtproto.Document{
		Id:            documentId,
		AccessHash:    accessHash,
		FileReference: nil,
		Date:          int32(r.DfsFileInfo.Mtime),
		MimeType:      media.GetMimeType(),
		Size2:         r.DfsFileInfo.GetFileSize(),
		Size2_INT32:   int32(r.DfsFileInfo.GetFileSize()),
		Size2_INT64:   r.DfsFileInfo.GetFileSize(),
		Thumbs:        nil,
		VideoThumbs:   nil,
		DcId:          1,
		Attributes:    attributes,
	}).To_Document()

	if media.GetThumb() != nil {
		thumbs, width, height, thumbErr := c.uploadDocumentThumb(in.GetCreator(), documentId, media.GetThumb())
		if thumbErr != nil {
			return nil, thumbErr
		}
		document.Thumbs = thumbs
		if !hasImageSizeAttribute(document.Attributes) {
			document.Attributes = append(document.Attributes, mtproto.MakeTLDocumentAttributeImageSize(&mtproto.DocumentAttribute{W: width, H: height}).To_DocumentAttribute())
		}
	}

	isThumb := media.GetThumb() == nil && mtproto.IsMimeAcceptedForPhotoVideoAlbum(document.MimeType) && model.IsFileExtImage(ext)
	if isThumb {
		var (
			thumb image.Image
			// photoId = idgen.GetUUID()
			// ext2     = ".jpg"
			// extType2 = model.GetStorageFileTypeConstructor(ext2)
			// secretId = int64(extType2)<<32 | int64(rand.Uint32())
		)

		cacheData, err = r.ReadAll(c.ctx)
		if err != nil {
			c.Logger.Errorf("dfs.uploadDocumentFile - %v", err)
			return nil, mtproto.ErrWallpaperFileInvalid
		} else {
			// log.Debugf("cacheData: %s", hex.EncodeToString(cacheData))
		}

		// build photoStrippedSize
		thumb, err = imaging.Decode(bytes.NewReader(cacheData))
		if err == nil {
			stripped := bytes2.NewBuffer(make([]byte, 0, 4096))
			if thumb.Bounds().Dx() >= thumb.Bounds().Dy() {
				err = imaging.EncodeStripped(stripped, imaging.Resize(thumb, 40, 0), 30)
			} else {
				err = imaging.EncodeStripped(stripped, imaging.Resize(thumb, 0, 40), 30)
			}
			if err != nil {
				c.Logger.Errorf("dfs.uploadDocumentFile - error: %v", err)
				return nil, err
			}

			// upload thumb
			var (
				mThumbData = bytes2.NewBuffer(make([]byte, 0, len(cacheData)))
				mThumb     image.Image
			)
			if thumb.Bounds().Dx() >= thumb.Bounds().Dy() {
				mThumb = imaging.Resize(thumb, 320, 0)
				// err = imaging.Encode(mThumbData, mThumb, 80)
			} else {
				mThumb = imaging.Resize(thumb, 0, 320)
				// err = imaging.Encode(mThumbData, imaging.Resize(thumb, 0, 320), 80)
			}

			err = imaging.EncodeJpeg(mThumbData, mThumb)
			if err != nil {
				c.Logger.Errorf("dfs.uploadDocumentFile - error: %v", err)
				return nil, err
			}

			// upload thumb
			path := fmt.Sprintf("%s/%d.dat", mtproto.PhotoSZMediumType, documentId)
			// upload
			c.svcCtx.Dao.PutPhotoFile(c.ctx, path, mThumbData.Bytes())

			document.Thumbs = []*mtproto.PhotoSize{
				mtproto.MakeTLPhotoStrippedSize(&mtproto.PhotoSize{
					Type:  mtproto.PhotoSZStrippedType,
					Bytes: stripped.Bytes(),
				}).To_PhotoSize(),
				mtproto.MakeTLPhotoSize(&mtproto.PhotoSize{
					Type:  mtproto.PhotoSZMediumType,
					W:     int32(mThumb.Bounds().Dx()),
					H:     int32(mThumb.Bounds().Dy()),
					Size2: int32(len(mThumbData.Bytes())),
				}).To_PhotoSize(),
			}
		} else {
			// ioutil.WriteFile("./t.jpg", cacheData, 0644)
			c.Logger.Errorf("dfs.uploadDocumentFile - error: %v", err)
			// return nil, err
			isThumb = false
		}
	}

	if isThumb {
		_, err = c.svcCtx.Dao.PutDocumentFile(c.ctx, fmt.Sprintf("%d.dat", documentId), bytes.NewReader(cacheData))
	} else {
		_, err = c.svcCtx.Dao.PutDocumentFile(c.ctx, fmt.Sprintf("%d.dat", documentId), c.svcCtx.Dao.NewSSDBReader(r.DfsFileInfo))
	}
	if err != nil {
		return nil, err
	}
	return document, nil
}

func hasImageSizeAttribute(attributes []*mtproto.DocumentAttribute) bool {
	for _, attribute := range attributes {
		if attribute.GetPredicateName() == mtproto.Predicate_documentAttributeImageSize {
			return true
		}
	}
	return false
}

func (c *DfsCore) uploadDocumentThumb(creatorId, documentId int64, thumbFile *mtproto.InputFile) ([]*mtproto.PhotoSize, int32, int32, error) {
	if err := model.CheckFileParts(thumbFile.Parts); err != nil {
		return nil, 0, 0, err
	}
	r, err := c.svcCtx.Dao.OpenFile(c.ctx, creatorId, thumbFile.Id_INT64, thumbFile.Parts)
	if err != nil {
		return nil, 0, 0, mtproto.ErrMediaInvalid
	}
	data, err := r.ReadAll(c.ctx)
	if err != nil {
		return nil, 0, 0, mtproto.ErrMediaInvalid
	}
	if thumbFile.Md5Checksum != "" && fmt.Sprintf("%x", md5.Sum(data)) != thumbFile.Md5Checksum {
		return nil, 0, 0, mtproto.ErrCheckSumInvalid
	}
	thumbs, width, height, mediumBytes, err := makeDocumentThumb(data)
	if err != nil {
		return nil, 0, 0, mtproto.ErrMediaInvalid
	}
	stored, err := c.svcCtx.Dao.PutPhotoFile(c.ctx, fmt.Sprintf("%s/%d.dat", mtproto.PhotoSZMediumType, documentId), mediumBytes)
	if err != nil {
		return nil, 0, 0, err
	}
	thumbs[len(thumbs)-1].Size2 = int32(stored.Size)
	return thumbs, width, height, nil
}

func makeDocumentThumb(data []byte) ([]*mtproto.PhotoSize, int32, int32, []byte, error) {
	preview, err := imaging.Decode(bytes.NewReader(data))
	if err != nil {
		preview, err = imaging.DecodeWebp(bytes.NewReader(data))
	}
	if err != nil {
		return nil, 0, 0, nil, err
	}
	width, height := int32(preview.Bounds().Dx()), int32(preview.Bounds().Dy())
	stripped := bytes2.NewBuffer(make([]byte, 0, 4096))
	if width >= height {
		err = imaging.EncodeStripped(stripped, imaging.Resize(preview, 40, 0), 30)
	} else {
		err = imaging.EncodeStripped(stripped, imaging.Resize(preview, 0, 40), 30)
	}
	if err != nil {
		return nil, 0, 0, nil, err
	}
	medium := preview
	if width > mtproto.PhotoSZMediumSize || height > mtproto.PhotoSZMediumSize {
		if width >= height {
			medium = imaging.Resize(preview, mtproto.PhotoSZMediumSize, 0)
		} else {
			medium = imaging.Resize(preview, 0, mtproto.PhotoSZMediumSize)
		}
	}
	encoded := bytes2.NewBuffer(make([]byte, 0, len(data)))
	if err = imaging.EncodeJpeg(encoded, medium); err != nil {
		return nil, 0, 0, nil, err
	}
	return []*mtproto.PhotoSize{
		mtproto.MakeTLPhotoStrippedSize(&mtproto.PhotoSize{Type: mtproto.PhotoSZStrippedType, Bytes: stripped.Bytes()}).To_PhotoSize(),
		mtproto.MakeTLPhotoSize(&mtproto.PhotoSize{Type: mtproto.PhotoSZMediumType, W: int32(medium.Bounds().Dx()), H: int32(medium.Bounds().Dy()), Size2: int32(len(encoded.Bytes()))}).To_PhotoSize(),
	}, width, height, encoded.Bytes(), nil
}
