package service

import (
	"context"
	"testing"

	"github.com/stretchr/testify/require"
	"github.com/teamgram/proto/mtproto"
	"pwm-server/app/bff/pwm/internal/dao/dataobject"
)

func TestReactionConversion(t *testing.T) {
	tests := []*mtproto.Reaction{
		mtproto.MakeTLReactionEmoji(&mtproto.Reaction{Emoticon: "👍"}).To_Reaction(),
		mtproto.MakeTLReactionCustomEmoji(&mtproto.Reaction{DocumentId: 42}).To_Reaction(),
	}
	for _, input := range tests {
		ref, ok := reactionFromMTProto(input)
		if !ok {
			t.Fatalf("reactionFromMTProto(%v) rejected", input)
		}
		if got := reactionToMTProto(ref); got.GetPredicateName() != input.GetPredicateName() || got.ToString() != input.ToString() {
			t.Fatalf("round trip = %v, want %v", got, input)
		}
	}
	if _, ok := reactionFromMTProto(mtproto.MakeTLReactionPaid(nil).To_Reaction()); ok {
		t.Fatal("paid reaction accepted")
	}
}

func TestAggregateReactionCarrierPreservesActorsAndCounts(t *testing.T) {
	rows := []dataobject.MessageReactionDO{
		{UserId: 2, ReactionType: 1, ReactionValue: "👍", Big: true, Date: 3},
		{UserId: 1, ReactionType: 1, ReactionValue: "👍", Date: 2},
		{UserId: 3, ReactionType: 1, ReactionValue: "❤️", Date: 1},
	}
	carrier := aggregateReactionCarrier(1, rows)
	require.Len(t, carrier.GetResults(), 2)
	require.Equal(t, int32(2), carrier.GetResults()[0].GetCount())
	require.True(t, carrier.GetResults()[0].GetChosen())
	require.Equal(t, int32(0), carrier.GetResults()[0].GetChosenOrder().GetValue())
	require.Equal(t, int32(1), carrier.GetResults()[1].GetCount())
	require.False(t, carrier.GetResults()[1].GetChosen())
	require.Len(t, carrier.GetRecentReactions(), 3)
	require.True(t, carrier.GetRecentReactions()[1].GetMy())
}

func TestAggregateReactionCarrierReturnsNilForEmptyState(t *testing.T) {
	require.Nil(t, aggregateReactionCarrier(1, nil))
}

func TestReactionAuthRejected(t *testing.T) {
	service := &Service{}
	_, _, err := service.reactionRequest(context.Background(), mtproto.MakeTLInputPeerSelf(nil).To_InputPeer(), false)
	if err != mtproto.ErrAuthKeyUnregistered {
		t.Fatalf("error = %v, want %v", err, mtproto.ErrAuthKeyUnregistered)
	}
}

func TestReactionsFromSendRequestDeduplicates(t *testing.T) {
	reaction := mtproto.MakeTLReactionEmoji(&mtproto.Reaction{Emoticon: "👍"}).To_Reaction()
	_, err := reactionsFromSendRequest(&mtproto.TLMessagesSendReaction{Reaction_FLAGVECTORREACTION: []*mtproto.Reaction{reaction, reaction}})
	if err != mtproto.ErrReactionInvalid {
		t.Fatalf("error = %v, want %v", err, mtproto.ErrReactionInvalid)
	}
}
