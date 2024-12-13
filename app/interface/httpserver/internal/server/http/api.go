package http

import (
	"crypto/aes"
	"crypto/cipher"
	"crypto/rand"
	"crypto/rsa"
	"crypto/sha256"
	"crypto/x509"
	"encoding/base64"
	"encoding/json"
	"encoding/pem"
	"fmt"
	"io"
	"net"
	"net/http"
	"os"
	"strings"

	"pwm-server/app/interface/httpserver/internal/config"
	"pwm-server/app/interface/httpserver/internal/core"
	"pwm-server/app/interface/httpserver/internal/svc"

	"github.com/mitchellh/mapstructure"
	"github.com/zeromicro/go-zero/core/logx"
)

var PrivateKey *rsa.PrivateKey
var SecureAPIKey string
var VerifySameNetwork bool

func Initialize(c config.Config) {
	logx.Info("Initializing configuration...")

	VerifySameNetwork = c.VerifySameNetwork
	// Secure API Key Setup
	SecureAPIKey = c.SecureAPIKey
	logx.Infof("Secure API Key loaded: %s", SecureAPIKey)

	// Read private key file
	logx.Infof("Attempting to read private key file: %s", c.KeyFile)
	privateKeyPEM, err := os.ReadFile(c.KeyFile)
	if err != nil {
		logx.Errorf("Failed to read private key file %s: %v", c.KeyFile, err)
		panic(fmt.Errorf("failed to parse private key: %v", err))
	}
	logx.Infof("Successfully read private key file: %s", c.KeyFile)

	// Decode PEM block
	block, _ := pem.Decode(privateKeyPEM)
	if block == nil {
		logx.Errorf("Failed to decode PEM block from private key file")
		panic("Failed to parse PEM block containing the key")
	}
	logx.Info("PEM block decoded successfully")

	// Parse the private key
	key, err := x509.ParsePKCS1PrivateKey(block.Bytes)
	if err != nil {
		logx.Errorf("Failed to parse private key: %v", err)
		panic(fmt.Errorf("failed to parse private key: %v", err))
	}
	logx.Info("Private key parsed successfully")

	// Store the private key
	PrivateKey = key
	logx.Info("Private key initialized successfully")

	// Finish initialization
	logx.Info("Configuration initialization complete.")
}

// Validate if client and server are in the same LAN (based on first 3 parts of the IP)
func validateSameLAN(r *http.Request) bool {
	if !VerifySameNetwork {
		return true
	}
	// Validate client IP (without port)
	clientIP, _, err := net.SplitHostPort(r.RemoteAddr)
	if err != nil {
		logx.Errorf("Failed to extract client IP from %s: %v", r.RemoteAddr, err)
		return false
	}

	// Validate server IP (without port)
	serverIP, _, err := net.SplitHostPort(r.Host)
	if err != nil {
		// If r.Host doesn't contain a port, SplitHostPort would fail. So we just use the whole host as serverIP.
		serverIP = r.Host
	}
	// Remove any port information from server IP if present
	serverIP = strings.Split(serverIP, ":")[0]

	// Determine if both are IPv4 or IPv6
	if isIPv4(clientIP) && isIPv4(serverIP) {
		// For IPv4, compare the first 3 octets
		clientParts := strings.Split(clientIP, ".")
		serverParts := strings.Split(serverIP, ".")

		if len(clientParts) < 3 || len(serverParts) < 3 {
			logx.Errorf("Invalid IPv4 address format. Client IP: %s, Server IP: %s", clientIP, serverIP)
			return false
		}

		// Compare the first 3 parts of the IPv4 address
		if clientParts[0] == serverParts[0] && clientParts[1] == serverParts[1] && clientParts[2] == serverParts[2] {
			return true
		}
	} else if isIPv6(clientIP) && isIPv6(serverIP) {
		// For IPv6, compare the first 3 segments
		clientParts := strings.Split(clientIP, ":")
		serverParts := strings.Split(serverIP, ":")

		if len(clientParts) < 3 || len(serverParts) < 3 {
			logx.Errorf("Invalid IPv6 address format. Client IP: %s, Server IP: %s", clientIP, serverIP)
			return false
		}

		// Compare the first 3 segments of the IPv6 address
		if clientParts[0] == serverParts[0] && clientParts[1] == serverParts[1] && clientParts[2] == serverParts[2] {
			return true
		}
	} else {
		logx.Errorf("IP address types do not match (one is IPv4, the other is IPv6). Client IP: %s, Server IP: %s", clientIP, serverIP)
	}

	// If no match, log and return false
	logx.Errorf("Forbidden: clientIP=%s serverIP=%s", clientIP, serverIP)
	return false
}

// Check if the given IP address is IPv4
func isIPv4(ip string) bool {
	return net.ParseIP(ip).To4() != nil
}

// Check if the given IP address is IPv6
func isIPv6(ip string) bool {
	return net.ParseIP(ip).To16() != nil && net.ParseIP(ip).To4() == nil
}

func decryptMessage(encryptedBase64 string, privateKey *rsa.PrivateKey) (string, error) {
	decodedMessage, err := base64.StdEncoding.DecodeString(encryptedBase64)
	if err != nil {
		return "", fmt.Errorf("base64 decode failed: %v", err)
	}
	decryptedBytes, err := rsa.DecryptPKCS1v15(nil, privateKey, decodedMessage)
	if err != nil {
		return "", fmt.Errorf("decryption failed: %v", err)
	}
	return string(decryptedBytes), nil
}

func handleBadRequest(w http.ResponseWriter, msg string, statusCode int) {
	logx.Errorf("Bad request: %s (status: %d)", msg, statusCode)
	http.Error(w, msg, statusCode)
}

func validateRequest(r *http.Request) (string, error) {
	// Validate the secure API key
	apiKey := r.Header.Get("X-Pwm-Server-Key")
	if apiKey != SecureAPIKey {
		return "Unauthorized", fmt.Errorf("invalid API key")
	}
	if !validateSameLAN(r) {
		return "Forbidden", fmt.Errorf("client IP not in same lan as server IP")
	}

	return "", nil
}
func pkcs7Unpad(data []byte) ([]byte, error) {
	length := len(data)
	if length == 0 {
		return nil, fmt.Errorf("invalid padding size")
	}
	padding := int(data[length-1])
	if padding > length || padding > aes.BlockSize {
		return nil, fmt.Errorf("invalid padding size")
	}
	return data[:length-padding], nil
}
func decryptAES(encryptedData, key []byte) ([]byte, error) {
	// Extract IV (first 16 bytes) and ciphertext
	if len(encryptedData) < aes.BlockSize {
		return nil, fmt.Errorf("ciphertext too short")
	}
	iv := encryptedData[:aes.BlockSize]
	ciphertext := encryptedData[aes.BlockSize:]

	// Initialize AES cipher
	block, err := aes.NewCipher(key)
	if err != nil {
		return nil, fmt.Errorf("failed to create AES cipher: %v", err)
	}

	// Decrypt using AES CBC
	decrypted := make([]byte, len(ciphertext))
	mode := cipher.NewCBCDecrypter(block, iv)
	mode.CryptBlocks(decrypted, ciphertext)

	// Remove padding
	decrypted, err = pkcs7Unpad(decrypted)
	if err != nil {
		return nil, fmt.Errorf("failed to unpad decrypted data: %v", err)
	}

	return decrypted, nil
}

func parseAndDecryptBody(r *http.Request, privateKey *rsa.PrivateKey, payload interface{}) error {
	// Read request body
	body, err := io.ReadAll(r.Body)
	if err != nil {
		return fmt.Errorf("failed to read request body: %v", err)
	}
	defer r.Body.Close()

	// Parse combined payload
	var encryptedData struct {
		EncryptedData string `json:"encryptedData"`
		EncryptedKey  string `json:"encryptedKey"`
	}
	if err := json.Unmarshal(body, &encryptedData); err != nil {
		return fmt.Errorf("failed to parse encrypted payload: %v", err)
	}

	// Decode base64-encoded data and key
	encryptedKey, err := base64.StdEncoding.DecodeString(encryptedData.EncryptedKey)
	if err != nil {
		return fmt.Errorf("failed to decode encrypted key: %v", err)
	}
	encryptedPayload, err := base64.StdEncoding.DecodeString(encryptedData.EncryptedData)
	if err != nil {
		return fmt.Errorf("failed to decode encrypted data: %v", err)
	}

	// Decrypt the AES key using RSA
	aesKey, err := rsa.DecryptOAEP(sha256.New(), rand.Reader, privateKey, encryptedKey, nil)
	if err != nil {
		return fmt.Errorf("failed to decrypt AES key: %v", err)
	}

	// Decrypt the payload using AES
	decryptedPayload, err := decryptAES(encryptedPayload, aesKey)
	if err != nil {
		return fmt.Errorf("failed to decrypt payload: %v", err)
	}

	// Parse the decrypted JSON payload
	if err := json.Unmarshal(decryptedPayload, payload); err != nil {
		return fmt.Errorf("invalid JSON format: %v", err)
	}

	return nil
}

func apiwSecure(ctx *svc.ServiceContext) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		// Validate request
		if msg, err := validateRequest(r); err != nil {
			handleBadRequest(w, msg, http.StatusUnauthorized)
			return
		}

		// Define structure for method_name and payload
		var request struct {
			MethodName string      `json:"method_name"`
			Payload    interface{} `json:"payload"`
		}

		// Parse and decrypt body into request struct
		if err := parseAndDecryptBody(r, PrivateKey, &request); err != nil {
			handleBadRequest(w, "Invalid Request Body", http.StatusBadRequest)
			return
		}

		// Call the appropriate handler based on the method_name
		switch request.MethodName {
		case "push_message":
			handlePushMessage(ctx, w, r, request.Payload)

		case "update_cache":
			handleUpdateCache(ctx, w, r, request.Payload)

		default:
			handleBadRequest(w, "Unknown method_name", http.StatusBadRequest)
		}
	}
}

// Handle push_message logic
func handlePushMessage(ctx *svc.ServiceContext, w http.ResponseWriter, r *http.Request, payload interface{}) {
	var messagePayload struct {
		UserIds []int64 `json:"userIds"`
		Message string  `json:"message"`
	}
	if err := mapstructure.Decode(payload, &messagePayload); err != nil {
		handleBadRequest(w, "Invalid Payload for push_message", http.StatusBadRequest)
		return
	}

	// Process push_message logic
	c := core.New(r.Context(), ctx)
	success, err := c.PushMessage(r.Context(), messagePayload.UserIds, messagePayload.Message)

	// Check if there was an error or the operation was unsuccessful
	if err != nil {
		logx.Errorf("Failed to push message: %v", err)
		handleBadRequest(w, "Failed to send message", http.StatusInternalServerError)
		return
	}

	// Check if message was successfully sent to all users
	if !success {
		logx.Infof("Failed to send message to some users")
		handleBadRequest(w, "Failed to send message to all users", http.StatusInternalServerError)
		return
	}

	// Respond with success
	logx.Infof("Message sent successfully to %d users", len(messagePayload.UserIds))
	w.WriteHeader(http.StatusOK)
	w.Write([]byte("Message sent successfully"))
}

// Handle update_cache logic
func handleUpdateCache(ctx *svc.ServiceContext, w http.ResponseWriter, r *http.Request, payload interface{}) {

	c := core.New(r.Context(), ctx)

	success, err := c.UpdateCache(r.Context(), payload)
	// Check if there was an error or the operation was unsuccessful
	if err != nil {
		logx.Errorf("Failed to update cache: %v", err)
		handleBadRequest(w, "Failed to update cache", http.StatusInternalServerError)
		return
	}

	// Check if message was successfully sent to all users
	if !success {
		logx.Infof("Failed to update cache")
		handleBadRequest(w, "Failed to update cache", http.StatusInternalServerError)
		return
	}

	// Respond with success
	logx.Infof("Update cache successfully")
	w.WriteHeader(http.StatusOK)
	w.Write([]byte("Update cache successfully"))
}
