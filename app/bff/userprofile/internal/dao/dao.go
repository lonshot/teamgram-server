// Copyright 2022 Teamgram Authors
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

package dao

import (
	kafka "github.com/teamgram/marmota/pkg/mq"
	"github.com/teamgram/marmota/pkg/net/rpcx"
	"pwm-server/app/bff/userprofile/internal/config"
	sync_client "pwm-server/app/messenger/sync/client"
	user_client "pwm-server/app/service/biz/user/client"
	media_client "pwm-server/app/service/media/client"
)

type Dao struct {
	media_client.MediaClient
	user_client.UserClient
	sync_client.SyncClient
}

func New(c config.Config) *Dao {
	return &Dao{
		MediaClient: media_client.NewMediaClient(rpcx.GetCachedRpcClient(c.MediaClient)),
		UserClient:  user_client.NewUserClient(rpcx.GetCachedRpcClient(c.UserClient)),
		SyncClient:  sync_client.NewSyncMqClient(kafka.MustKafkaProducer(c.SyncClient)),
	}
}