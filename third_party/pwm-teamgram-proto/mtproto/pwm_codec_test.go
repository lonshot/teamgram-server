package mtproto

import "testing"

func TestPwmRequestCodecRoundTrip(t *testing.T) {
	tests := []TLObject{
		&TLPwmGetPartners{Constructor: CRC32_pwm_getPartners, PartnerId: 42},
		&TLPwmGetTask{Constructor: CRC32_pwm_getTask, PartnerId: 42, PlayerPairId: 7},
		&TLPwmSubmitAnswer{Constructor: CRC32_pwm_submitAnswer, RequestId: 9, GameConfigId: 10, PairGameId: 11, ChainTaskId: "c", Answer: "a", AttachedText: "t", MediaPath: "m"},
		&TLPwmGetDifference{Constructor: CRC32_pwm_getDifference, Cursor: 12, Limit: 100},
	}
	for _, object := range tests {
		encoded := NewEncodeBuf(256)
		if err := object.Encode(encoded, 186); err != nil {
			t.Fatal(err)
		}
		decoded := NewDecodeBuf(encoded.GetBuf()).Object()
		if decoded == nil {
			t.Fatalf("decode %T failed", object)
		}
		if FindRPCContextTuple(decoded) == nil {
			t.Fatalf("missing RPC tuple for %T", decoded)
		}
	}
}
