package core

import (
	"github.com/teamgram/proto/mtproto"
)

// UploadGetFileHashes
// upload.getFileHashes#c7025931 location:InputFileLocation offset:int = Vector<FileHash>;
func (c *FilesCore) UploadGetFileHashes(in *mtproto.TLUploadGetFileHashes) (*mtproto.Vector_FileHash, error) {
	// TODO: not impl
	c.Logger.Errorf("upload.getFileHashes blocked, License key from https://wb.playwith-me.com required to unlock enterprise features.")

	return nil, mtproto.ErrEnterpriseIsBlocked
}
