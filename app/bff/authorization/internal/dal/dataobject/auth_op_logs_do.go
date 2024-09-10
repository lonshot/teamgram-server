package dataobject

type AuthOpLogsDO struct {
	Id        int64  `db:"id" json:"id"`
	AuthKeyId int64  `db:"auth_key_id" json:"auth_key_id"`
	Ip        string `db:"ip" json:"ip"`
	OpType    int32  `db:"op_type" json:"op_type"`
	LogText   string `db:"log_text" json:"log_text"`
}
