package dataobject

// ReactionsDO is the Data Object (DO) that represents a reaction in the database.
type ReactionsDO struct {
	Id        int64  `db:"id"`         // Primary key
	UserId    int64  `db:"user_id"`    // The ID of the user who reacted
	MessageId int64  `db:"message_id"` // The ID of the message that was reacted to
	Reaction  string `db:"reaction"`   // The reaction (e.g., emoji)
	PeerId    int64  `db:"peer_id"`    // Peer ID (chat or user)
	PeerType  int32  `db:"peer_type"`  // Peer type (user, group, etc.)
	Read      bool   `db:"read"`       // Whether the reaction has been read
	Reported  bool   `db:"reported"`   // Whether the reaction has been reported
	CreatedAt int64  `db:"created_at"` // Timestamp of the reaction
	UpdatedAt int64  `db:"updated_at"` // Timestamp when the reaction was last updated
}

type MessageReactionDO struct {
	Id              int64  `db:"id"`
	UserId          int64  `db:"user_id"`
	AuthorUserId    int64  `db:"author_user_id"`
	PeerType        int32  `db:"peer_type"`
	PeerId          int64  `db:"peer_id"`
	MessageId       int32  `db:"message_id"`
	DialogMessageId int64  `db:"dialog_message_id"`
	ReactionType    uint8  `db:"reaction_type"`
	ReactionValue   string `db:"reaction_value"`
	Big             bool   `db:"big"`
	Unread          bool   `db:"unread"`
	Date            int32  `db:"date2"`
}

type MessageReactionPageDO struct {
	Count      int32
	Reactions  []MessageReactionDO
	NextOffset string
}

type MessageReactionCommandDO struct {
	Id                  uint64 `db:"id"`
	CommandKey          string `db:"command_key"`
	UserId              int64  `db:"user_id"`
	AuthKeyId           int64  `db:"auth_key_id"`
	PeerType            int32  `db:"peer_type"`
	RequestPeerId       int64  `db:"request_peer_id"`
	PeerId              int64  `db:"peer_id"`
	MessageId           int32  `db:"message_id"`
	DialogMessageId     int64  `db:"dialog_message_id"`
	Generation          uint64 `db:"generation"`
	DeliveredGeneration uint64 `db:"delivered_generation"`
	AttemptCount        uint32 `db:"attempt_count"`
}

type UnreadReactionMessagePageDO struct {
	Count      int32
	MessageIds []int32
}

type ChatReactionSettingsDO struct {
	PeerType       int32
	PeerId         int64
	PolicyType     int32
	ReactionsLimit *int32
	Reactions      []UserReactionDO
}

// ReactionCountDO represents a reaction and the count of times it has been used.
type ReactionCountDO struct {
	Reaction string // The emoji or reaction identifier
	Count    int64  // The number of times this reaction was used
}

// ChatsDO represents the available reactions for a chat.
type ChatReactionsDO struct {
	AvailableReactionsType int32  `db:"available_reactions_type"`
	AvailableReactions     string `db:"available_reactions"`
}
