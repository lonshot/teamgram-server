package core

import (
	"github.com/teamgram/proto/mtproto"
)

// UploadGetCdnFileHashes
// upload.getCdnFileHashes#4da54231 file_token:bytes offset:int = Vector<FileHash>;
func (c *FilesCore) UploadGetCdnFileHashes(in *mtproto.TLUploadGetCdnFileHashes) (*mtproto.Vector_FileHash, error) {
	// TODO: not impl
	c.Logger.Errorf("upload.getCdnFileHashes blocked, License key from https://wb.playwith-me.com required to unlock enterprise features.")

	return &mtproto.Vector_FileHash{
		Datas: []*mtproto.FileHash{},
	}, nil
}
