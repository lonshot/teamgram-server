package plugin

import (
	"context"

	"github.com/teamgram/proto/mtproto"
)

type StoryPlugin interface {
	// GetStoriesPinnedAvailable
	// stories_pinned_available	flags.26?true	Whether this user has some pinned stories.
	GetStoriesPinnedAvailable(ctx context.Context, peerUserId, toSelfUserId int64) bool
	// GetBlockedMyStoriesFrom
	// blocked_my_stories_from	flags.27?true	Whether we've blocked this user, preventing them from seeing our stories ».
	GetBlockedMyStoriesFrom(ctx context.Context, peerUserId, toSelfUserId int64) bool
	// GetActiveStories
	// stories	flags.25?PeerStories	Active stories »
	GetActiveStories(ctx context.Context, peerUserId, toSelfUserId int64) *mtproto.PeerStories
}
