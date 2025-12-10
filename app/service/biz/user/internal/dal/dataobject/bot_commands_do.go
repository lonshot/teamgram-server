package dataobject

type BotCommandsDO struct {
	Id          int64  `db:"id" json:"id"`
	BotId       int64  `db:"bot_id" json:"bot_id"`
	Command     string `db:"command" json:"command"`
	Description string `db:"description" json:"description"`
}
