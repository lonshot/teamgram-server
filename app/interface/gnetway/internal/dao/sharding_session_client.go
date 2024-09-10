// Copyright (c) 2021-present,  Teamgram Studio (https://teamgram.io).
//  All rights reserved.
//
// Author: teamgramio (teamgram.io@gmail.com)
//

package dao

import (
	"errors"

	"pwm-server/app/interface/gnetway/internal/config"
	sessionclient "pwm-server/app/interface/session/client"

	"github.com/zeromicro/go-zero/core/discov"
	"github.com/zeromicro/go-zero/core/hash"
	"github.com/zeromicro/go-zero/core/logx"
	"github.com/zeromicro/go-zero/core/stringx"
	"github.com/zeromicro/go-zero/zrpc"
)

var (
	ErrSessionNotFound = errors.New("not found session")
)

type ShardingSessionClient struct {
	gatewayId  string
	dispatcher *hash.ConsistentHash
	sessions   map[string]sessionclient.SessionClient
}

func NewShardingSessionClient(c config.Config) *ShardingSessionClient {
	sess := &ShardingSessionClient{
		dispatcher: hash.NewConsistentHash(),
		sessions:   make(map[string]sessionclient.SessionClient),
	}
	sess.watch(c.Session)

	return sess
}

func (sess *ShardingSessionClient) watch(c zrpc.RpcClientConf) {
    // Initialize Subscriber and check for errors
    sub, err := discov.NewSubscriber(c.Etcd.Hosts, c.Etcd.Key)
    if err != nil {
        logx.Errorf("Failed to initialize Subscriber: %v", err)
        return
    }

    update := func() {
        var (
            addClis    []string
            removeClis []string
        )

        // Check if the subscriber is properly initialized
        if sub == nil {
            logx.Error("Subscriber is nil")
            return
        }

        values := sub.Values()
        if values == nil {
            logx.Error("Subscriber returned nil values")
            return
        }

        sessions := map[string]sessionclient.SessionClient{}
        for _, v := range values {
            if old, ok := sess.sessions[v]; ok {
                sessions[v] = old
                continue
            }

            // Ensure endpoints are not empty before creating a new client
            c.Endpoints = []string{v}
            cli, err := zrpc.NewClient(c)
            if err != nil {
                logx.Errorf("watchComet NewClient(%+v) error(%v)", values, err)
                continue
            }

            sessionCli := sessionclient.NewSessionClient(cli)
            sessions[v] = sessionCli

            addClis = append(addClis, v)
        }

        // Handle sessions to remove
        for key := range sess.sessions {
            if !stringx.Contains(values, key) {
                removeClis = append(removeClis, key)
            }
        }

        // Update dispatcher with added and removed clients
        for _, n := range addClis {
            sess.dispatcher.Add(n)
        }

        for _, n := range removeClis {
            sess.dispatcher.Remove(n)
        }

        // Update sessions map
        sess.sessions = sessions
    }

    // Add listener to subscriber with error handling
    if sub != nil {
        sub.AddListener(update)
    } else {
        logx.Error("Cannot add listener to a nil Subscriber")
    }

    // Initial update call to set up clients
    update()
}

func (sess *ShardingSessionClient) InvokeByKey(key string, cb func(client sessionclient.SessionClient) (err error)) error {
	val, ok := sess.dispatcher.Get(key)
	if !ok {
		return ErrSessionNotFound
	}

	cli, ok := sess.sessions[val.(string)]
	if !ok {
		return ErrSessionNotFound
	}

	if cb == nil {
		return nil
	}

	return cb(cli)
}
