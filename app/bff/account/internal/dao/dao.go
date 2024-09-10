package dao

import (
	"context"
	"time"

	kafka "github.com/teamgram/marmota/pkg/mq"
	"github.com/teamgram/marmota/pkg/net/rpcx"
	"github.com/teamgram/proto/mtproto"
	"github.com/zeromicro/go-zero/core/logx"
	"github.com/zeromicro/go-zero/core/stores/redis"
	"pwm-server/app/bff/account/internal/config"
	sync_client "pwm-server/app/messenger/sync/client"
	authsession_client "pwm-server/app/service/authsession/client"
	chat_client "pwm-server/app/service/biz/chat/client"
	"pwm-server/app/service/biz/user/user"
	"pwm-server/pkg/errors"

	user_client "pwm-server/app/service/biz/user/client"
)

type Dao struct {
	authsession_client.AuthsessionClient
	user_client.UserClient
	sync_client.SyncClient
	chat_client.ChatClient
	RedisClient *redis.Redis // Redis client for managing temporary data
}

// New initializes the Dao object with clients
func New(c config.Config) *Dao {
	// Initialize the Redis client using MustNewRedis
	redisClient := redis.MustNewRedis(redis.RedisConf{
		Host: c.Redis.Host,
		Type: c.Redis.Type, // Set Redis type (e.g., "node" or "cluster")
	})

	return &Dao{
		RedisClient:       redisClient,
		UserClient:        user_client.NewUserClient(rpcx.GetCachedRpcClient(c.UserClient)),
		AuthsessionClient: authsession_client.NewAuthsessionClient(rpcx.GetCachedRpcClient(c.AuthsessionClient)),
		ChatClient:        chat_client.NewChatClient(rpcx.GetCachedRpcClient(c.ChatClient)),
		SyncClient:        sync_client.NewSyncMqClient(kafka.MustKafkaProducer(c.SyncClient)),
	}
}

// DeleteAccountByID deletes the user account by user ID.
func (d *Dao) DeleteAccountByID(ctx context.Context, userID int64, reason string) (*mtproto.Bool, error) {
	// Use the UserDeleteUser method from userclient to delete user account
	logx.Infof("Deleting account for user ID: %d, Reason: %s", userID, reason)
	result, err := d.UserClient.UserDeleteUser(ctx, &user.TLUserDeleteUser{
		UserId: userID,
		Reason: reason,
	})
	if err != nil {
		logx.Errorf("Failed to delete account for user ID: %d, error: %v", userID, err)
		return nil, err
	}

	logx.Infof("Successfully deleted account for user ID: %d", userID)
	return result, nil
}

// GetPhoneCodeByHash retrieves the stored phone code and its expiration time using the phone_code_hash.
func (d *Dao) GetPhoneCodeByHash(ctx context.Context, hash string) (string, time.Time, error) {
	// Redis key to retrieve the phone code
	redisKey := "phone_code:" + hash

	// Fetch the phone code from Redis
	storedCode, err := d.RedisClient.GetCtx(ctx, redisKey)
	if err != nil {
		logx.Errorf("Failed to retrieve phone code for hash: %s, error: %v", hash, err)
		return "", time.Time{}, err
	}

	// Handle the case where the key does not exist
	if storedCode == "" {
		logx.Errorf("Phone code not found for hash: %s", hash)
		return "", time.Time{}, errors.ErrPhoneCodeNotFound
	}

	// Fetch the expiration time (TTL) of the phone code in seconds
	ttl, err := d.RedisClient.TtlCtx(ctx, redisKey)
	if err != nil {
		logx.Errorf("Failed to retrieve TTL for phone code hash: %s, error: %v", hash, err)
		return "", time.Time{}, err
	}

	// Convert the TTL from seconds to time.Duration and calculate expiration time
	expirationTime := time.Now().Add(time.Duration(ttl) * time.Second)

	logx.Infof("Successfully retrieved phone code for hash: %s, expires at: %v", hash, expirationTime)
	return storedCode, expirationTime, nil
}

// ConfirmPhoneNumber confirms the phone number by removing the phone code hash from Redis.
func (d *Dao) ConfirmPhoneNumber(ctx context.Context, userID int64, hash string) error {
	// Redis key to delete after confirmation
	redisKey := "phone_code:" + hash

	// Step 1: Remove the phone code hash from Redis
	_, err := d.RedisClient.DelCtx(ctx, redisKey)
	if err != nil {
		logx.Errorf("Failed to delete phone code hash from Redis: %s, error: %v", hash, err)
		return err
	}

	// No further logic for updating user account confirmation status, just Redis cleanup.

	logx.Infof("Successfully confirmed phone number for user ID: %d and removed phone code hash: %s", userID, hash)
	return nil
}
