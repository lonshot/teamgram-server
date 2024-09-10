package dataobject

type PopularContactsDO struct {
	Id        int64  `db:"id" json:"id"`
	Phone     string `db:"phone" json:"phone"`
	Importers int32  `db:"importers" json:"importers"`
	Deleted   bool   `db:"deleted" json:"deleted"`
	UpdateAt  string `db:"update_at" json:"update_at"`
}
