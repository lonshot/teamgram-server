package dao

import "context"

type GamePartnerDO struct {
	Id             int64  `db:"Id" json:"Id"`
	FirstName      string `db:"FirstName" json:"FirstName"`
	LastName       string `db:"LastName" json:"LastName"`
	Gender         int64  `db:"Gender" json:"Gender"`
	Female         bool   `db:"Female" json:"Female"`
	PlayerPairId   int64  `db:"PlayerPairId" json:"PlayerPairId"`
	LastPairGameId int64  `db:"LastPairGameId" json:"LastPairGameId"`
	DoneTasks      int64  `db:"DoneTasks" json:"DoneTasks"`
	TotalTasks     int64  `db:"TotalTasks" json:"TotalTasks"`
	HasTask        bool   `db:"HasTask" json:"HasTask"`
	Disconnected   bool   `db:"Disconnected" json:"Disconnected"`
}

func (d *Dao) SelectGamePartners(ctx context.Context, userId, partnerId int64) ([]GamePartnerDO, error) {
	const query = `SELECT u.id AS Id, COALESCE(u.first_name, '') AS FirstName,
		COALESCE(u.last_name, '') AS LastName, COALESCE(u.Gender, 0) AS Gender,
		IF(u.Gender = 2, 1, 0) AS Female, pp.PlayerPairId,
		COALESCE(pp.CurrentPairGameId, 0) AS LastPairGameId,
		(SELECT COUNT(*) FROM game_config_completions gcc
		 WHERE gcc.pair_game_id = pp.CurrentPairGameId AND gcc.player_id = ?) AS DoneTasks,
		(SELECT COUNT(*) FROM net_gameconfig gc JOIN net_pairgame pg ON pg.GameId = gc.GameId
		 WHERE pg.PairGameId = pp.CurrentPairGameId) AS TotalTasks,
		IF(pg.PairGameId IS NOT NULL AND pg.IsActive = 1
			AND (pg.IsFinished IS NULL OR pg.IsFinished <> 1), 1, 0) AS HasTask,
		0 AS Disconnected
		FROM net_playerpair pp JOIN users u ON u.id = IF(pp.Player1 = ?, pp.Player2, pp.Player1)
		LEFT JOIN net_pairgame pg ON pg.PairGameId = pp.CurrentPairGameId
		WHERE pp.IsActive = 1 AND (pp.Player1 = ? OR pp.Player2 = ?)
		AND (pp.Status IS NULL OR pp.Status = 1)
		AND u.Active = 1 AND u.deleted = 0
		AND (? = 0 OR u.id = ?) ORDER BY pp.PlayerPairId`
	rows := make([]GamePartnerDO, 0)
	err := d.db.QueryRowsPartial(ctx, &rows, query, userId, userId, userId, userId, partnerId, partnerId)
	return rows, err
}
