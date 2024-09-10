package server

import (
	"fmt"

	"github.com/teamgram/proto/mtproto"
)

type CacheV struct {
	V *mtproto.AuthKeyInfo
}

func (c CacheV) Size() int {
	return 1
}

func (s *Server) GetAuthKey(authKeyId int64) *mtproto.AuthKeyInfo {
	var (
		cacheK = fmt.Sprintf("%d", authKeyId)
		value  *CacheV
	)

	if v, ok := s.cache.Get(cacheK); ok {
		value = v.(*CacheV)
	}

	if value == nil {
		return nil
	} else {
		return value.V
	}
}

func (s *Server) PutAuthKey(keyInfo *mtproto.AuthKeyInfo) {
	var (
		cacheK = fmt.Sprintf("%d", keyInfo.AuthKeyId)
	)

	// TODO: expires_in
	s.cache.Set(cacheK, &CacheV{V: keyInfo})
}
