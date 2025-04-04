package core

import (
	"strconv"

	"github.com/teamgram/marmota/pkg/hack"
	"github.com/teamgram/proto/mtproto"
)

// AuthExportAuthorization
// auth.exportAuthorization#e5bfffcd dc_id:int = auth.ExportedAuthorization;
func (c *AuthorizationCore) AuthExportAuthorization(in *mtproto.TLAuthExportAuthorization) (*mtproto.Auth_ExportedAuthorization, error) {
	rExported := mtproto.MakeTLAuthExportedAuthorization(&mtproto.Auth_ExportedAuthorization{
		Id:    c.MD.UserId,
		Bytes: hack.Bytes(strconv.Itoa(int(in.DcId))),
	}).To_Auth_ExportedAuthorization()

	return rExported, nil
}
