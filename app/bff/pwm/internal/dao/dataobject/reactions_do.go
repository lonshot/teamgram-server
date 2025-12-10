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
