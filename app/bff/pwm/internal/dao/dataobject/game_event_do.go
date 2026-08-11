package dataobject

import "time"

type GameEventDO struct {
	Id              uint64    `db:"id"`
	EventId         string    `db:"event_id"`
	CommandId       uint64    `db:"command_id"`
	RecipientUserId int64     `db:"recipient_user_id"`
	EventType       string    `db:"event_type"`
	AggregateType   string    `db:"aggregate_type"`
	AggregateId     string    `db:"aggregate_id"`
	Payload         string    `db:"payload"`
	CreatedAt       time.Time `db:"created_at"`
}

type GameOutboxDO struct {
	Id           uint64 `db:"id"`
	EventId      string `db:"event_id"`
	CommandId    uint64 `db:"command_id"`
	EventType    string `db:"event_type"`
	Payload      string `db:"payload"`
	AttemptCount uint32 `db:"attempt_count"`
}
