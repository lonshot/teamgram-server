package core

import (
	"pwm-server/app/service/biz/user/user"
)

// UserCheckBots
// user.checkBots id:Vector<long> = Vector<long>;
func (c *UserCore) UserCheckBots(in *user.TLUserCheckBots) (*user.Vector_Long, error) {
	var (
		rVals []int64
	)

	if len(in.Id) > 0 {
		rVals, _ = c.svcCtx.Dao.UsersDAO.SelectBots(c.ctx, in.Id)
		if rVals == nil {
			rVals = []int64{}
		}
	}

	return &user.Vector_Long{
		Datas: rVals,
	}, nil
}
