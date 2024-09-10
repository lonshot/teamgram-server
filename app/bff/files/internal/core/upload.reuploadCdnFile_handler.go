package core

import (
	"github.com/teamgram/proto/mtproto"
)

// UploadReuploadCdnFile
// upload.reuploadCdnFile#9b2754a8 file_token:bytes request_token:bytes = Vector<FileHash>;
func (c *FilesCore) UploadReuploadCdnFile(in *mtproto.TLUploadReuploadCdnFile) (*mtproto.Vector_FileHash, error) {
	// TODO: not impl
	c.Logger.Errorf("upload.reuploadCdnFile blocked, License key from https://teamgram.net required to unlock enterprise features.")

	return &mtproto.Vector_FileHash{
		Datas: []*mtproto.FileHash{},
	}, nil
}
