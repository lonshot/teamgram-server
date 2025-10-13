package redis_proxy

import (
	"os"
	"strconv"
)

type Config struct {
	// Proxy server settings
	ProxyHost     string
	ProxyPort     int
	AdminPassword string

	// Redis backend settings
	RedisHost     string
	RedisPort     int
	RedisPassword string

	// Security settings
	MaxConnections int
	EnableLogging  bool
}

func LoadConfig() *Config {
	config := &Config{
		ProxyHost:      getEnvOrDefault("REDIS_PROXY_HOST", "0.0.0.0"),
		ProxyPort:      getEnvIntOrDefault("REDIS_PROXY_PORT", 6380),
		AdminPassword:  getEnvOrDefault("REDIS_ADMIN_PASSWORD", "admin_redis_2025!"),
		RedisHost:      getEnvOrDefault("REDIS_HOST", "redis"),
		RedisPort:      getEnvIntOrDefault("REDIS_PORT", 6379),
		RedisPassword:  getEnvOrDefault("REDIS_PASSWORD", "A65D0770B69940FEA084C9C8028908F7"),
		MaxConnections: getEnvIntOrDefault("REDIS_MAX_CONNECTIONS", 100),
		EnableLogging:  getEnvBoolOrDefault("REDIS_ENABLE_LOGGING", true),
	}
	return config
}

func getEnvOrDefault(key, defaultValue string) string {
	if value := os.Getenv(key); value != "" {
		return value
	}
	return defaultValue
}

func getEnvIntOrDefault(key string, defaultValue int) int {
	if value := os.Getenv(key); value != "" {
		if intValue, err := strconv.Atoi(value); err == nil {
			return intValue
		}
	}
	return defaultValue
}

func getEnvBoolOrDefault(key string, defaultValue bool) bool {
	if value := os.Getenv(key); value != "" {
		if boolValue, err := strconv.ParseBool(value); err == nil {
			return boolValue
		}
	}
	return defaultValue
}
