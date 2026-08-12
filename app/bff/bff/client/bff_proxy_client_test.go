package bff_proxy_client

import (
	"testing"
	"time"

	"github.com/teamgram/proto/mtproto"
)

func TestRpcTimeoutForAuthSendCodeAllowsEmailDelivery(t *testing.T) {
	if got := rpcTimeoutFor(&mtproto.TLAuthSendCode{}); got != authSendCodeTimeout {
		t.Fatalf("auth.sendCode timeout = %s, want %s", got, authSendCodeTimeout)
	}
}

func TestRpcTimeoutForDefaultRequestsRemainsBounded(t *testing.T) {
	if got := rpcTimeoutFor(&mtproto.TLAuthSignIn{}); got != defaultRPCTimeout {
		t.Fatalf("default RPC timeout = %s, want %s", got, defaultRPCTimeout)
	}
	if got := rpcTimeoutFor(&mtproto.TLMessagesSendMedia{}); got != 60*time.Second {
		t.Fatalf("media RPC timeout = %s, want 60s", got)
	}
}
