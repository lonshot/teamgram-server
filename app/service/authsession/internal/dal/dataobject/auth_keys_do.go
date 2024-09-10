package dataobject

type AuthKeysDO struct {
	Id        int64  `db:"id" json:"id"`
	AuthKeyId int64  `db:"auth_key_id" json:"auth_key_id"`
	Body      string `db:"body" json:"body"`
	Deleted   bool   `db:"deleted" json:"deleted"`
}
