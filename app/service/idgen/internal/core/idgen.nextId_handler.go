package core

import (
	"github.com/teamgram/proto/mtproto"
	"pwm-server/app/service/idgen/idgen"
)

// IdgenNextId
// idgen.nextId = Int64;
func (c *IdgenCore) IdgenNextId(in *idgen.TLIdgenNextId) (*mtproto.Int64, error) {
	_ = in

	return &mtproto.Int64{
		V: c.svcCtx.Dao.Node.Generate().Int64(),
	}, nil
}
