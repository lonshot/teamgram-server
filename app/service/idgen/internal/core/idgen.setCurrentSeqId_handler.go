package core

import (
	"github.com/teamgram/proto/mtproto"
	"pwm-server/app/service/idgen/idgen"
	"strconv"
)

// IdgenSetCurrentSeqId
// idgen.setCurrentSeqId key:string id:long = Bool;
func (c *IdgenCore) IdgenSetCurrentSeqId(in *idgen.TLIdgenSetCurrentSeqId) (*mtproto.Bool, error) {
	err := c.svcCtx.Dao.KV.SetCtx(c.ctx, in.GetKey(), strconv.FormatInt(in.GetId(), 10))
	if err != nil {
		c.Logger.Errorf("idgen.setCurrentSeqId(%s, %d) error: %v", in.GetKey(), in.GetId(), err)
		return nil, err
	}

	return mtproto.BoolTrue, nil
}
