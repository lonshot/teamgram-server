package core

import (
	"github.com/teamgram/proto/mtproto"
	"pwm-server/app/service/idgen/idgen"
	"strconv"
)

// IdgenSetCurrentSeqId
// idgen.setCurrentSeqId key:string id:long = Bool;
func (c *IdgenCore) IdgenSetCurrentSeqId(in *idgen.TLIdgenSetCurrentSeqId) (*mtproto.Bool, error) {
	// Sequence IDs are monotonic. A stale repair request must not reset a
	// counter after another sender has already reserved a larger value.
	const setAtLeast = `local current = tonumber(redis.call('GET', KEYS[1]) or '0')
local requested = tonumber(ARGV[1])
if requested > current then redis.call('SET', KEYS[1], ARGV[1]) end
return 1`
	_, err := c.svcCtx.Dao.KV.EvalCtx(c.ctx, setAtLeast, in.GetKey(), strconv.FormatInt(in.GetId(), 10))
	if err != nil {
		c.Logger.Errorf("idgen.setCurrentSeqId(%s, %d) error: %v", in.GetKey(), in.GetId(), err)
		return nil, err
	}

	return mtproto.BoolTrue, nil
}
