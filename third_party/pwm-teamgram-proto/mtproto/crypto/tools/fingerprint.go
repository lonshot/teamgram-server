// Copyright 2024 Teamgram Authors
//  All rights reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//   http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//
// Author: teamgramio (teamgram.io@gmail.com)
//

package main

import (
	"crypto/rsa"
	"crypto/sha1"
	"crypto/x509"
	"encoding/binary"
	"encoding/hex"
	"encoding/pem"
	"fmt"
	"io/ioutil"
	"math/big"
	"os"

	"github.com/teamgram/proto/mtproto"
)

func computeFingerprint(key *rsa.PrivateKey) uint64 {
	// testPrivateKey
	ebuf := mtproto.NewEncodeBuf(500)
	n := key.N.Bytes()
	e := new(big.Int).SetInt64(int64(key.E)).Bytes()

	// fmt.Printf("N: %d, E: %d\n", len(n), len(e))
	fmt.Println("N: ", hex.EncodeToString(n))
	fmt.Println("N: ", key.N.String())
	fmt.Println("E: ", hex.EncodeToString(e))
	fmt.Println("E: ", int64(key.E))
	// fmt.Println(hex.EncodeToString(ebuf.GetBuf()))
	ebuf.StringBytes(n)
	ebuf.StringBytes(e)

	hash := sha1.Sum(ebuf.GetBuf())
	return binary.LittleEndian.Uint64(hash[12:20])
}

func main() {
	if len(os.Args) != 2 {
		fmt.Println(" ./fingerprint rsakey")
		os.Exit(0)
	}

	keyFile := os.Args[1]
	pkcs1PemPrivateKey, err := ioutil.ReadFile(keyFile)
	if err != nil {
		fmt.Println("invalid pemsKeyFile: " + keyFile)
		os.Exit(0)
	}

	block, _ := pem.Decode(pkcs1PemPrivateKey)
	if block == nil {
		panic("invalid pemsKeyData: " + string(pkcs1PemPrivateKey))
		os.Exit(0)
	}

	key, err := x509.ParsePKCS1PrivateKey(block.Bytes)
	if err != nil {
		panic("Failed to parse private key: " + err.Error())
	}

	// fingerprint uint64 = 12240908862933197005
	v := computeFingerprint(key)
	fmt.Printf("fingerprint, decimal: %d, decimal: %d, hexadecimal： %x\n", v, int64(v), v)
}
