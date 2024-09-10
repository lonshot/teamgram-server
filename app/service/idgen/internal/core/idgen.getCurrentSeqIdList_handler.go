package core

import (
	"github.com/teamgram/proto/mtproto"
	"pwm-server/app/service/idgen/idgen"
	"strconv"
)

// IdgenGetCurrentSeqIdList
// idgen.getCurrentSeqIdList id:Vector<InputId> = Vector<IdVal>;
func (c *IdgenCore) IdgenGetCurrentSeqIdList(in *idgen.TLIdgenGetCurrentSeqIdList) (*idgen.Vector_IdVal, error) {
	var (
		idList = make([]*idgen.IdVal, len(in.GetId()))
	)

	for i, id := range in.GetId() {
		switch id.GetPredicateName() {
		case idgen.Predicate_inputSeqId:
			sid, err := c.svcCtx.Dao.KV.GetCtx(c.ctx, id.Key)
			if err != nil {
				c.Logger.Errorf("idgen.getCurrentSeqIdList(%s) error: %v", id.Key, err)
				return nil, err
			}

			if sid == "" {
				idList[i] = idgen.MakeTLSeqIdVal(&idgen.IdVal{
					Id_INT64: 0,
				}).To_IdVal()
			} else {
				iV, _ := strconv.ParseInt(sid, 10, 64)
				idList[i] = idgen.MakeTLSeqIdVal(&idgen.IdVal{
					Id_INT64: iV,
				}).To_IdVal()
			}
		default:
			err := mtproto.ErrInputRequestInvalid
			c.Logger.Errorf("idgen.getCurrentSeqIdList - error: %v", err)
			return nil, err
		}
	}

	return &idgen.Vector_IdVal{
		Datas: idList,
	}, nil
}
