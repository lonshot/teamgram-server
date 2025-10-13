package redis_proxy

import (
	"bufio"
	"fmt"
	"io"
	"log"
	"net"
	"strings"
	"sync"
	"time"
)

type ProxyServer struct {
	config      *Config
	listener    net.Listener
	connections sync.Map
	connCount   int64
	mu          sync.RWMutex
}

func NewProxyServer(config *Config) *ProxyServer {
	return &ProxyServer{
		config: config,
	}
}

func (p *ProxyServer) Start() error {
	addr := fmt.Sprintf("%s:%d", p.config.ProxyHost, p.config.ProxyPort)
	listener, err := net.Listen("tcp", addr)
	if err != nil {
		return fmt.Errorf("failed to start proxy server: %w", err)
	}

	p.listener = listener

	if p.config.EnableLogging {
		log.Printf("Redis proxy server started on %s", addr)
		log.Printf("Backend Redis: %s:%d", p.config.RedisHost, p.config.RedisPort)
	}

	for {
		conn, err := listener.Accept()
		if err != nil {
			if p.config.EnableLogging {
				log.Printf("Failed to accept connection: %v", err)
			}
			continue
		}

		go p.handleConnection(conn)
	}
}

func (p *ProxyServer) Stop() error {
	if p.listener != nil {
		return p.listener.Close()
	}
	return nil
}

func (p *ProxyServer) handleConnection(clientConn net.Conn) {
	defer clientConn.Close()

	p.mu.Lock()
	p.connCount++
	connID := p.connCount
	if p.connCount > int64(p.config.MaxConnections) {
		p.mu.Unlock()
		if p.config.EnableLogging {
			log.Printf("Connection %d rejected: max connections exceeded", connID)
		}
		clientConn.Write([]byte("-ERR max connections exceeded\r\n"))
		return
	}
	p.mu.Unlock()

	clientAddr := clientConn.RemoteAddr().String()
	if p.config.EnableLogging {
		log.Printf("Connection %d established from %s", connID, clientAddr)
	}

	// Store connection for tracking
	p.connections.Store(connID, clientConn)
	defer p.connections.Delete(connID)

	// Handle authentication first
	authenticated := false
	reader := bufio.NewReader(clientConn)

	for !authenticated {
		// Read the first command from client
		line, err := reader.ReadString('\n')
		if err != nil {
			if p.config.EnableLogging {
				log.Printf("Connection %d: failed to read command: %v", connID, err)
			}
			return
		}

		command := strings.TrimSpace(line)

		// Parse Redis protocol
		if strings.HasPrefix(command, "*") {
			// Multi-bulk format
			args, err := p.parseRESPCommand(reader, command)
			if err != nil {
				if p.config.EnableLogging {
					log.Printf("Connection %d: failed to parse command: %v", connID, err)
				}
				clientConn.Write([]byte("-ERR protocol error\r\n"))
				return
			}

			if len(args) >= 2 && strings.ToUpper(args[0]) == "AUTH" {
				if args[1] == p.config.AdminPassword {
					authenticated = true
					clientConn.Write([]byte("+OK\r\n"))
					if p.config.EnableLogging {
						log.Printf("Connection %d: authentication successful", connID)
					}
				} else {
					clientConn.Write([]byte("-ERR invalid password\r\n"))
					if p.config.EnableLogging {
						log.Printf("Connection %d: authentication failed", connID)
					}
					return
				}
			} else {
				clientConn.Write([]byte("-NOAUTH Authentication required\r\n"))
				return
			}
		} else {
			// Simple format (less common but still valid)
			parts := strings.Fields(command)
			if len(parts) >= 2 && strings.ToUpper(parts[0]) == "AUTH" {
				if parts[1] == p.config.AdminPassword {
					authenticated = true
					clientConn.Write([]byte("+OK\r\n"))
					if p.config.EnableLogging {
						log.Printf("Connection %d: authentication successful", connID)
					}
				} else {
					clientConn.Write([]byte("-ERR invalid password\r\n"))
					if p.config.EnableLogging {
						log.Printf("Connection %d: authentication failed", connID)
					}
					return
				}
			} else {
				clientConn.Write([]byte("-NOAUTH Authentication required\r\n"))
				return
			}
		}
	}

	// Now establish connection to Redis backend
	redisAddr := net.JoinHostPort(p.config.RedisHost, fmt.Sprintf("%d", p.config.RedisPort))
	redisConn, err := net.DialTimeout("tcp", redisAddr, 10*time.Second)
	if err != nil {
		if p.config.EnableLogging {
			log.Printf("Connection %d: failed to connect to Redis backend: %v", connID, err)
		}
		clientConn.Write([]byte("-ERR backend connection failed\r\n"))
		return
	}
	defer redisConn.Close()

	// Authenticate with Redis backend if password is set
        if p.config.EnableLogging {
                log.Printf("Connection %d: Redis password length: %d, value: %q", connID, len(p.config.RedisPassword), p.config.RedisPassword)
        }
	if p.config.RedisPassword != "" {
		authCmd := fmt.Sprintf("*2\r\n$4\r\nAUTH\r\n$%d\r\n%s\r\n",
			len(p.config.RedisPassword), p.config.RedisPassword)
		redisConn.Write([]byte(authCmd))

		// Read auth response
		authReader := bufio.NewReader(redisConn)
		authResp, err := authReader.ReadString('\n')
		if err != nil || !strings.HasPrefix(authResp, "+OK") {
			if p.config.EnableLogging {
				log.Printf("Connection %d: Redis backend authentication failed", connID)
			}
			clientConn.Write([]byte("-ERR backend authentication failed\r\n"))
			return
		}
	}

	if p.config.EnableLogging {
		log.Printf("Connection %d: proxy established successfully", connID)
	}

	// Start proxying data bi-directionally
	errChan := make(chan error, 2)

	// Client -> Redis
	go func() {
		_, err := io.Copy(redisConn, clientConn)
		errChan <- err
	}()

	// Redis -> Client
	go func() {
		_, err := io.Copy(clientConn, redisConn)
		errChan <- err
	}()

	// Wait for either direction to close/error
	<-errChan

	if p.config.EnableLogging {
		log.Printf("Connection %d: proxy session ended", connID)
	}
}

// parseRESPCommand parses Redis RESP protocol commands
func (p *ProxyServer) parseRESPCommand(reader *bufio.Reader, firstLine string) ([]string, error) {
	// Remove the * and parse number of arguments
	numArgsStr := strings.TrimPrefix(firstLine, "*")
	numArgsStr = strings.TrimSpace(numArgsStr)

	var numArgs int
	fmt.Sscanf(numArgsStr, "%d", &numArgs)

	args := make([]string, numArgs)

	for i := 0; i < numArgs; i++ {
		// Read length line
		lengthLine, err := reader.ReadString('\n')
		if err != nil {
			return nil, err
		}

		lengthStr := strings.TrimPrefix(lengthLine, "$")
		lengthStr = strings.TrimSpace(lengthStr)

		var length int
		fmt.Sscanf(lengthStr, "%d", &length)

		// Read the actual argument
		argBytes := make([]byte, length)
		_, err = io.ReadFull(reader, argBytes)
		if err != nil {
			return nil, err
		}

		// Read trailing CRLF
		reader.ReadString('\n')

		args[i] = string(argBytes)
	}

	return args, nil
}

// GetConnectionCount returns current number of active connections
func (p *ProxyServer) GetConnectionCount() int {
	count := 0
	p.connections.Range(func(key, value interface{}) bool {
		count++
		return true
	})
	return count
}
