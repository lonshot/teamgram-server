package core

import (
	"fmt"
	"math/rand"
	"time"

	msgpb "pwm-server/app/messenger/msg/msg/msg"
	"pwm-server/pkg/env2"

	"github.com/mitchellh/mapstructure"
	"github.com/teamgram/proto/mtproto"
	"github.com/zeromicro/go-zero/core/jsonx"
	"github.com/zeromicro/go-zero/core/logx"
)

type ApiUserContactsDO struct {
	Id               int64  `json:"id" mapstructure:"id"`
	OwnerUserId      int64  `json:"owner_user_id" mapstructure:"owner_user_id"`
	ContactUserId    int64  `json:"contact_user_id" mapstructure:"contact_user_id"`
	ContactPhone     string `json:"contact_phone" mapstructure:"contact_phone"`
	ContactFirstName string `json:"contact_first_name" mapstructure:"contact_first_name"`
	ContactLastName  string `json:"contact_last_name" mapstructure:"contact_last_name"`
	Mutual           bool   `json:"mutual" mapstructure:"mutual"`
	CloseFriend      bool   `json:"close_friend" mapstructure:"close_friend"`
	StoriesHidden    bool   `json:"stories_hidden" mapstructure:"stories_hidden"`
	IsDeleted        bool   `json:"is_deleted" mapstructure:"is_deleted"`
	Date2            int64  `json:"date2" mapstructure:"date2"`
}

const (
	ContactKeyPrefix       = "user_contact.2"
	CacheUserDataKeyPrefix = "user_data.2"
)

// PushMessage sends a message to the specified users
// Returns true if all messages were successfully sent, otherwise returns false and the error
func (c *HttpserverCore) PushMessage(userIds []int64, message string) (bool, int) {
	// Flag to track if any errors occurred
	var hasError bool
	var failedCount int
	// Iterate over each userId and attempt to send the message
	for _, userId := range userIds {
		// Create the message
		msg := mtproto.MakeTLMessage(&mtproto.Message{
			Out:     true,
			Date:    int32(time.Now().Unix()),
			FromId:  mtproto.MakePeerUser(int64(env2.ServiceUserId)),
			PeerId:  mtproto.MakeTLPeerUser(&mtproto.Peer{UserId: userId}).To_Peer(),
			Message: message,
		}).To_Message()

		// Attempt to send the message to the user
		_, err := c.svcCtx.Dao.MsgClient.MsgPushUserMessage(
			c.ctx,
			&msgpb.TLMsgPushUserMessage{
				UserId:    int64(env2.ServiceUserId),
				AuthKeyId: 0,
				PeerType:  mtproto.PEER_USER,
				PeerId:    userId,
				PushType:  1,
				Message: msgpb.MakeTLOutboxMessage(&msgpb.OutboxMessage{
					NoWebpage:    false,
					Background:   false,
					RandomId:     rand.Int63(),
					Message:      msg,
					ScheduleDate: nil,
				}).To_OutboxMessage(),
			})

		// If error occurs while pushing the message, log it and continue
		if err != nil {
			// Log the error and continue sending to the next user
			logx.Errorf("Error sending message to user %d: %v", userId, err)
			hasError = true
			failedCount++
			// Optionally, you can log the error with more details if required.
		}
	}

	// If there were errors, return false, otherwise return true
	return !hasError, failedCount
}

// UpdateCache updates the contact list cache for the given user
func (c *HttpserverCore) UpdateCache(payload *interface{}) (bool, error) {
	var updateCachePayload struct {
		Type string             `json:"type" mapstructure:"type"`
		Data *ApiUserContactsDO `json:"data" mapstructure:"data"`
	}
	logx.Infof("Payload before decoding: %v", payload)

	// Decode the payload into updateCachePayload
	if err := mapstructure.Decode(payload, &updateCachePayload); err != nil {
		logx.Errorf("Failed to decode payload: %v", err)
		return false, fmt.Errorf("failed to decode payload: %w", err)
	}

	// Check if Type is present and valid
	if updateCachePayload.Type == "" {
		logx.Errorf("Missing or empty 'type' field in payload")
		return false, fmt.Errorf("missing or empty 'type' field in payload")
	}

	// Switch on the 'type' field to determine the action
	switch updateCachePayload.Type {
	case "add_contact":
		// Log action type for debugging
		logx.Infof("Adding contact: %+v", updateCachePayload.Data)
		return c.updateContactCache(updateCachePayload.Data, true)
	case "remove_contact":
		// Log action type for debugging
		logx.Infof("Removing contact: %+v", updateCachePayload.Data)
		return c.updateContactCache(updateCachePayload.Data, false)
	default:
		// Log unrecognized type
		logx.Errorf("Unrecognized update type: %s", updateCachePayload.Type)
		return false, fmt.Errorf("unrecognized update type: %s", updateCachePayload.Type)
	}
}

// updateContactCache handles adding or removing a contact from the cache and updating the contact lists
func (r *HttpserverCore) updateContactCache(contact *ApiUserContactsDO, add bool) (bool, error) { // Pass as pointer

	// logx.Infof("Decoded contact: %+v", contact)

	// Validate that the necessary fields are present (e.g., valid user IDs)
	if contact.OwnerUserId == 0 || contact.ContactUserId == 0 {
		return false, fmt.Errorf("invalid contact data: OwnerUserId or ContactUserId is zero")
	}

	// Generate the cache key
	key := r.genContactCacheKey(contact.OwnerUserId, contact.ContactUserId)

	// Access kv store from the Dao context
	kvStore := r.svcCtx.Dao.KV

	// Serialize the contact data
	data, err := jsonx.MarshalToString(contact)
	if err != nil {
		logx.Errorf("Failed to serialize contact data for OwnerID: %d, ContactID: %d: %v", contact.OwnerUserId, contact.ContactUserId, err)
		return false, err
	}

	// Add or remove contact from the cache based on 'add' flag
	if add {
		if err := kvStore.Set(key, data); err != nil {
			logx.Errorf("Failed to add contact to cache for OwnerID: %d, ContactID: %d: %v", contact.OwnerUserId, contact.ContactUserId, err)
			return false, err
		}
		logx.Infof("Added contact to cache for OwnerID: %d, ContactID: %d, data: %s", contact.OwnerUserId, contact.ContactUserId, data)
	} else {
		if _, err := kvStore.Del(key); err != nil {
			logx.Errorf("Failed to remove contact from cache for OwnerID: %d, ContactID: %d: %v", contact.OwnerUserId, contact.ContactUserId, err)
			return false, err
		}
		logx.Infof("Removed contact from cache for OwnerID: %d, ContactID: %d", contact.OwnerUserId, contact.ContactUserId)
	}

	// Update contact lists
	if err := r.updateContactLists(contact.OwnerUserId, contact.ContactUserId, add); err != nil {
		logx.Errorf("Failed to update contact lists for OwnerID: %d, ContactID: %d: %v", contact.OwnerUserId, contact.ContactUserId, err)
		return false, err
	}

	return true, nil
}

// UpdateContactLists updates the contact list cache for the given user
func (c *HttpserverCore) updateContactLists(userId, contactId int64, add bool) error {
	// Access kv store from the Dao context
	kvStore := c.svcCtx.Dao.KV

	// Generate cache key for user contact list
	cacheKey := c.genCacheUserDataCacheKey(userId)

	// Fetch the current contact list data from the cache
	cachedData, err := kvStore.Get(cacheKey)
	if err != nil {
		logx.Errorf("Error retrieving cached data for user %d: %v", userId, err)
		return err
	}

	// If no cached data found, log and return
	if len(cachedData) == 0 {
		logx.Infof("No cached data found for user: %d", userId)
		return err
	}

	// Unmarshal the cached data into a map
	var contactData map[string]interface{}
	if err := jsonx.UnmarshalFromString(cachedData, &contactData); err != nil {
		logx.Errorf("Failed to parse cached data for user %d: %v", userId, err)
		return err
	}

	// Retrieve the current contact list or initialize an empty list if not found
	contactIdList, ok := contactData["contact_id_list"].([]int64)
	if !ok {
		contactIdList = []int64{}
	}

	// Add or remove the contact based on the 'add' flag
	if add && !contains(contactIdList, contactId) {
		contactIdList = append(contactIdList, contactId)
	} else if !add && contains(contactIdList, contactId) {
		contactIdList = remove(contactIdList, contactId)
	}

	// Update the contact list in the cached data
	contactData["contact_id_list"] = contactIdList

	// Marshal the updated contact data back to JSON
	updatedData, err := jsonx.MarshalToString(contactData)
	if err != nil {
		logx.Errorf("Failed to serialize updated contact list for user %d: %v", userId, err)
		return err
	}

	// Store the updated data in the kv store (cache)
	if err := kvStore.Set(cacheKey, updatedData); err != nil {
		logx.Errorf("Error storing updated contact data for user %d: %v", userId, err)
	}
	logx.Infof("Successfully updated contact list for user: %d, Add: %v, ContactID: %d", userId, add, contactId)
	return nil
}

// Generate the contact cache key
func (c *HttpserverCore) genContactCacheKey(selfID, contactID int64) string {
	return fmt.Sprintf("%s_%d_%d", ContactKeyPrefix, selfID, contactID)
}

// Generate the user data cache key
func (c *HttpserverCore) genCacheUserDataCacheKey(selfID int64) string {
	return fmt.Sprintf("%s#%d", CacheUserDataKeyPrefix, selfID)
}

// Helper function to check if an item exists in a slice
func contains(slice []int64, item int64) bool {
	for _, v := range slice {
		if v == item {
			return true
		}
	}
	return false
}

// Helper function to remove an item from a slice
func remove(slice []int64, item int64) []int64 {
	var result []int64
	for _, v := range slice {
		if v != item {
			result = append(result, v)
		}
	}
	return result
}
