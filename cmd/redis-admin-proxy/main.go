package main

import (
	"context"
	"flag"
	"log"
	"os"
	"os/signal"
	"syscall"
	"time"

	redis_proxy "pwm-server/pkg/redis-proxy"
)

var (
	configFile = flag.String("config", "", "Path to configuration file (optional)")
	help       = flag.Bool("help", false, "Show help message")
)

func main() {
	flag.Parse()

	if *help {
		printHelp()
		return
	}

	// Load configuration
	config := redis_proxy.LoadConfig()

	// Create and start proxy server
	proxy := redis_proxy.NewProxyServer(config)

	// Setup graceful shutdown
	ctx, cancel := context.WithCancel(context.Background())
	defer cancel()

	// Handle shutdown signals
	sigChan := make(chan os.Signal, 1)
	signal.Notify(sigChan, syscall.SIGINT, syscall.SIGTERM)

	go func() {
		sig := <-sigChan
		log.Printf("Received signal %v, shutting down gracefully...", sig)

		// Stop accepting new connections
		if err := proxy.Stop(); err != nil {
			log.Printf("Error stopping proxy server: %v", err)
		}

		// Give existing connections time to finish
		time.Sleep(5 * time.Second)
		cancel()
	}()

	// Start the proxy server
	log.Printf("Starting Redis Admin Proxy...")
	log.Printf("Proxy will listen on %s:%d", config.ProxyHost, config.ProxyPort)
	log.Printf("Backend Redis: %s:%d", config.RedisHost, config.RedisPort)
	log.Printf("Max connections: %d", config.MaxConnections)
	log.Printf("Logging enabled: %t", config.EnableLogging)

	// Start server in a goroutine
	serverErr := make(chan error, 1)
	go func() {
		if err := proxy.Start(); err != nil {
			serverErr <- err
		}
	}()

	// Wait for shutdown signal or server error
	select {
	case <-ctx.Done():
		log.Println("Redis Admin Proxy shutdown complete")
	case err := <-serverErr:
		log.Printf("Server error: %v", err)
		os.Exit(1)
	}
}

func printHelp() {
	log.Println("Redis Admin Proxy Server")
	log.Println("========================")
	log.Println()
	log.Println("This service provides a secure proxy to Redis for administrative access only.")
	log.Println("It requires authentication with an admin password before allowing connections.")
	log.Println()
	log.Println("Environment Variables:")
	log.Println("  REDIS_PROXY_HOST       - Proxy server bind address (default: 0.0.0.0)")
	log.Println("  REDIS_PROXY_PORT       - Proxy server port (default: 6380)")
	log.Println("  REDIS_ADMIN_PASSWORD   - Admin password for proxy access (default: admin_redis_2025!)")
	log.Println("  REDIS_HOST             - Backend Redis host (default: redis)")
	log.Println("  REDIS_PORT             - Backend Redis port (default: 6379)")
	log.Println("  REDIS_PASSWORD         - Backend Redis password (default: A65D0770B69940FEA084C9C8028908F7)")
	log.Println("  REDIS_MAX_CONNECTIONS  - Maximum concurrent connections (default: 100)")
	log.Println("  REDIS_ENABLE_LOGGING   - Enable detailed logging (default: true)")
	log.Println()
	log.Println("Usage:")
	log.Println("  redis-admin-proxy [options]")
	log.Println()
	log.Println("Options:")
	flag.PrintDefaults()
	log.Println()
	log.Println("Example:")
	log.Println("  # Start proxy with custom settings")
	log.Println("  REDIS_PROXY_PORT=6380 REDIS_ADMIN_PASSWORD=mysecretpass redis-admin-proxy")
	log.Println()
	log.Println("Connection Example:")
	log.Println("  redis-cli -h localhost -p 6380")
	log.Println("  > AUTH mysecretpass")
	log.Println("  > PING")
}
