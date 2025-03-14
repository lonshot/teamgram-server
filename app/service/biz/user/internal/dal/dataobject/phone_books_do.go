package dataobject

type PhoneBooksDO struct {
	Id        int64  `db:"id" json:"id"`
	UserId    int64  `db:"user_id" json:"user_id"`
	AuthKeyId int64  `db:"auth_key_id" json:"auth_key_id"`
	ClientId  int64  `db:"client_id" json:"client_id"`
	Phone     string `db:"phone" json:"phone"`
	FirstName string `db:"first_name" json:"first_name"`
	LastName  string `db:"last_name" json:"last_name"`
}
