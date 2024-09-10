package dataobject

type UserNotifySettingsDO struct {
	Id           int64  `db:"id" json:"id"`
	UserId       int64  `db:"user_id" json:"user_id"`
	PeerType     int32  `db:"peer_type" json:"peer_type"`
	PeerId       int64  `db:"peer_id" json:"peer_id"`
	ShowPreviews int32  `db:"show_previews" json:"show_previews"`
	Silent       int32  `db:"silent" json:"silent"`
	MuteUntil    int32  `db:"mute_until" json:"mute_until"`
	Sound        string `db:"sound" json:"sound"`
	Deleted      bool   `db:"deleted" json:"deleted"`
}
