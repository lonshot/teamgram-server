package service

import (
	"context"
	"testing"

	"github.com/teamgram/proto/mtproto"
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
