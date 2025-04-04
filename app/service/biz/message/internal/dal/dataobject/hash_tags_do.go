package dataobject

type HashTagsDO struct {
	Id               int64  `db:"id" json:"id"`
	UserId           int64  `db:"user_id" json:"user_id"`
	PeerType         int32  `db:"peer_type" json:"peer_type"`
	PeerId           int64  `db:"peer_id" json:"peer_id"`
	HashTag          string `db:"hash_tag" json:"hash_tag"`
	HashTagMessageId int32  `db:"hash_tag_message_id" json:"hash_tag_message_id"`
	Deleted          bool   `db:"deleted" json:"deleted"`
}
