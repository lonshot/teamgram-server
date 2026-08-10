package service

import "github.com/teamgram/proto/mtproto"

var (
	_ mtproto.RPCStickersServer  = (*Service)(nil)
	_ mtproto.RPCReactionsServer = (*Service)(nil)
)
