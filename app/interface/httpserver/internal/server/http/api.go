package http

import (
	"crypto/rsa"
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

	"github.com/zeromicro/go-zero/core/logx"
)

var PrivateKey *rsa.PrivateKey
var SecureAPIKey string

func Initialize(c config.Config) {
	logx.Info("Initializing configuration...")

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
func validateSameLAN(clientIP, serverIP string) bool {
	// Determine if both are IPv4 or IPv6
	if isIPv4(clientIP) && isIPv4(serverIP) {
		// For IPv4, compare the first 3 octets
		clientParts := strings.Split(clientIP, ".")
		serverParts := strings.Split(serverIP, ".")

		if len(clientParts) < 3 || len(serverParts) < 3 {
			logx.Errorf("Invalid IPv4 address format.")
			return false
		}

		if clientParts[0] == serverParts[0] && clientParts[1] == serverParts[1] && clientParts[2] == serverParts[2] {
			return true
		}
	} else if isIPv6(clientIP) && isIPv6(serverIP) {
		// For IPv6, compare the first 3 segments
		clientParts := strings.Split(clientIP, ":")
		serverParts := strings.Split(serverIP, ":")

		if len(clientParts) < 3 || len(serverParts) < 3 {
			logx.Errorf("Invalid IPv6 address format.")
			return false
		}

		if clientParts[0] == serverParts[0] && clientParts[1] == serverParts[1] && clientParts[2] == serverParts[2] {
			return true
		}
	} else {
		logx.Errorf("IP address types do not match (one is IPv4, the other is IPv6).")
	}

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

	// Validate client IP
	clientIP, _, _ := net.SplitHostPort(r.RemoteAddr)
	serverIP := r.Host // Assume server IP is in r.Host, adjust if needed
	if !validateSameLAN(clientIP, serverIP) {
		logx.Errorf("Forbidden: clientIP=%s serverIP=%s", clientIP, serverIP)
		return "Forbidden", fmt.Errorf("client IP not in same lan as server IP")
	}

	return "", nil
}

func parseAndDecryptBody(r *http.Request, privateKey *rsa.PrivateKey, payload interface{}) error {
	// Read and decrypt request body
	body, err := io.ReadAll(r.Body)
	if err != nil {
		return fmt.Errorf("failed to read request body: %v", err)
	}
	defer r.Body.Close()

	decryptedBody, err := decryptMessage(string(body), privateKey)
	if err != nil {
		return fmt.Errorf("failed to decrypt request body: %v", err)
	}

	// Parse JSON payload
	if err := json.Unmarshal([]byte(decryptedBody), payload); err != nil {
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

		// Define payload structure
		var payload struct {
			UserIds []int64 `json:"userIds"`
			Message string  `json:"message"`
		}

		// Parse and decrypt body
		if err := parseAndDecryptBody(r, PrivateKey, &payload); err != nil {
			handleBadRequest(w, "Invalid Request Body", http.StatusBadRequest)
			return
		}

		// Call pushMessage for each userId
		c := core.New(
			r.Context(),
			ctx,
		)
		c.PushMessage(r.Context(), payload.UserIds, payload.Message)

		// Return success
		logx.Infof("Message sent successfully to %d users", len(payload.UserIds))
		w.WriteHeader(http.StatusOK)
		w.Write([]byte("Message sent successfully"))
	}
}
